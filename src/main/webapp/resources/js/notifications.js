console.log('=== NOTIFICATIONS.JS LOADED ===');

// Get CSRF token
const csrfToken = document.querySelector("meta[name='_csrf']")?.getAttribute("content");
const csrfHeader = document.querySelector("meta[name='_csrf_header']")?.getAttribute("content");

console.log('CSRF Token:', csrfToken);
console.log('CSRF Header:', csrfHeader);

// Create headers for fetch requests
function createHeaders() {
    const headers = new Headers();
    headers.append('Content-Type', 'application/json');
    headers.append('Accept', 'application/json');
    if (csrfHeader && csrfToken) {
        try {
            // Log the header values for debugging
            console.log('CSRF Header:', csrfHeader);
            console.log('CSRF Token:', csrfToken);

            // Remove any potential whitespace and validate header name
            const cleanHeader = csrfHeader.trim();
            if (cleanHeader && /^[a-zA-Z0-9_-]+$/.test(cleanHeader)) {
                headers.append(cleanHeader, csrfToken);
            } else {
                console.warn('Invalid CSRF header name:', csrfHeader);
            }
        } catch (error) {
            console.error('Error adding CSRF headers:', error);
        }
    }
    return headers;
}

// Common fetch options
const fetchOptions = {
    credentials: 'include',
    mode: 'same-origin'
};

// Global variables
let loading = false;
let allNotifications = [];
let currentIndex = 0;
const ITEMS_PER_PAGE = 5;

// Global elements
let notificationBtn;
let notificationDropdown;
let notificationList;

// Initialize notification system
async function initNotifications() {
    console.log('=== KHỞI TẠO HỆ THỐNG THÔNG BÁO ===');

    // Initialize elements
    notificationBtn = document.getElementById('notificationBtn');
    notificationDropdown = document.getElementById('notificationDropdown');
    notificationList = document.querySelector('.notification-list');

    // Kiểm tra các elements cần thiết
    if (!notificationBtn) {
        console.error('Không tìm thấy nút thông báo');
        return;
    }
    if (!notificationDropdown) {
        console.error('Không tìm thấy dropdown thông báo');
        return;
    }
    if (!notificationList) {
        console.error('Không tìm thấy danh sách thông báo');
        return;
    }

    console.log('Các elements:', {
        notificationBtn,
        notificationDropdown,
        notificationList
    });

    await updateUnreadCount();
    setupEventListeners();
}

// Update unread count
async function updateUnreadCount() {
    try {
        const response = await fetch('/api/notifications/unread-count', {
            ...fetchOptions,
            method: 'GET',
            headers: createHeaders()
        });

        if (!response.ok) {
            throw new Error('Failed to fetch unread count');
        }

        const data = await response.json();
        console.log('Unread count response:', data);

        const badge = document.querySelector('.notification-badge');
        if (data.count > 0) {
            if (!badge) {
                const newBadge = document.createElement('span');
                newBadge.className = 'notification-badge';
                newBadge.textContent = data.count;
                notificationBtn.appendChild(newBadge);
            } else {
                badge.textContent = data.count;
            }
        } else if (badge) {
            badge.remove();
        }
    } catch (error) {
        console.error('Error updating notification count:', error);
    }
}

// Display notifications from current index
function displayMoreNotifications() {
    console.log('=== HIỂN THỊ THÊM THÔNG BÁO ===');
    console.log('Vị trí hiện tại:', currentIndex);
    console.log('Tổng số thông báo:', allNotifications.length);

    const loadMoreBtn = document.querySelector('.load-more');
    if (!loadMoreBtn) {
        console.error('Không tìm thấy nút xem thêm');
        return;
    }

    // Tính toán phạm vi thông báo cần hiển thị
    const endIndex = Math.min(currentIndex + ITEMS_PER_PAGE, allNotifications.length);
    const notificationsToShow = allNotifications.slice(currentIndex, endIndex);

    console.log('Số thông báo sẽ hiển thị:', notificationsToShow.length);
    console.log('Từ index', currentIndex, 'đến', endIndex);

    // Thêm các thông báo vào DOM
    notificationsToShow.forEach(notification => {
        const element = createNotificationElement(notification);
        notificationList.appendChild(element);
    });

    // Cập nhật vị trí hiện tại
    currentIndex = endIndex;

    // Cập nhật trạng thái nút xem thêm
    const remainingCount = allNotifications.length - currentIndex;
    console.log('Số thông báo còn lại:', remainingCount);

    if (remainingCount > 0) {
        loadMoreBtn.textContent = `Xem thêm ${remainingCount} thông báo`;
        loadMoreBtn.style.display = 'block';
        loadMoreBtn.classList.add('pulse-animation');
    } else {
        loadMoreBtn.style.display = 'none';
        loadMoreBtn.classList.remove('pulse-animation');
    }
}

// Format relative time in Vietnamese
function formatRelativeTime(dateStr) {
    console.log('Xử lý ngày:', dateStr);

    // Nếu không có ngày, trả về chuỗi rỗng
    if (!dateStr) {
        console.log('Không có dữ liệu ngày');
        return '';
    }

    try {
        let date;

        // Nếu là mảng (từ Java LocalDateTime)
        if (Array.isArray(dateStr)) {
            console.log('Dữ liệu là mảng:', dateStr);
            const [year, month, day, hour, minute, second] = dateStr;
            date = moment([year, month - 1, day, hour, minute, second]);
        } else {
            // Thử parse chuỗi ngày
            date = moment(dateStr);
        }

        // Kiểm tra ngày hợp lệ
        if (!date.isValid()) {
            console.log('Ngày không hợp lệ');
            return '';
        }

        console.log('Ngày đã parse:', date.format());

        // Sử dụng moment.js để format thời gian tương đối
        return date.fromNow();
    } catch (error) {
        console.error('Lỗi xử lý ngày:', error);
        return '';
    }
}

// Create notification element
function createNotificationElement(notification) {
    console.log('Creating notification element:', notification);
    const div = document.createElement('div');
    div.className = `notification-item ${notification.isRead ? '' : 'unread'}`;
    div.setAttribute('data-id', notification.id);

    // Xác định icon và màu sắc dựa vào loại thông báo
    let iconClass = 'bi bi-bell-fill';
    let iconColor = 'text-primary';

    if (notification.type === 'APPOINTMENT') {
        if (notification.message.includes('hết hạn') || notification.message.includes('đã bị khóa')) {
            iconClass = 'bi bi-exclamation-circle';
            iconColor = 'text-warning';
        } else {
            iconClass = 'bi bi-calendar-check-fill';
            iconColor = 'text-primary';
        }
    } else if (notification.type === 'MEDICAL') {
        iconClass = 'bi bi-file-medical-fill';
        iconColor = 'text-success';
    } else if (notification.type === 'SYSTEM') {
        iconClass = 'bi bi-gear-fill';
        iconColor = 'text-info';
    }

    // Tạo nội dung thông báo
    const timeAgo = formatRelativeTime(notification.createdAt);
    console.log('Time ago:', timeAgo);

    div.innerHTML = `
        <div class="notification-icon">
            <i class="${iconClass} ${iconColor}"></i>
        </div>
        <div class="notification-content">
            <div class="notification-message">${notification.message}</div>
            <span class="notification-time">${timeAgo}</span>
        </div>
    `;

    // Thêm sự kiện click
    div.addEventListener('click', async () => {
        // Đánh dấu đã đọc nếu chưa đọc
        if (!notification.isRead) {
            try {
                const response = await fetch(`/api/notifications/${notification.id}/mark-read`, {
                    ...fetchOptions,
                    method: 'POST',
                    headers: createHeaders()
                });

                if (response.ok) {
                    div.classList.remove('unread');
                    notification.isRead = true;
                    updateUnreadCount();

                    // Nếu muốn điều hướng đến trang my-appointments sau khi đánh dấu đã đọc
                    // window.location.href = '/appointments/my-appointments';
                }
            } catch (error) {
                console.error('Lỗi khi đánh dấu đã đọc:', error);
            }
        }
    });

    // Thêm hiệu ứng fade-in
    div.style.animation = 'fadeIn 0.3s ease-out';

    return div;
}

// Load notifications
async function loadNotifications(reset = false) {
    if (loading) return;
    loading = true;

    const filter = document.querySelector('.notification-filter')?.value || 'all';
    const loadMoreBtn = document.querySelector('.load-more');

    try {
        if (reset || allNotifications.length === 0) {
            notificationList.innerHTML = '';
            currentIndex = 0;

            // Thêm tiêu đề phần
            const newSection = document.createElement('div');
            newSection.className = 'notification-section';
            newSection.textContent = 'Mới';
            notificationList.appendChild(newSection);

            const url = `/api/notifications/list?page=0&size=100&filter=${filter}`;
            const response = await fetch(url, {
                ...fetchOptions,
                method: 'GET',
                headers: createHeaders()
            });

            if (!response.ok) {
                throw new Error('Không thể tải thông báo');
            }

            const data = await response.json();
            console.log('=== DỮ LIỆU THÔNG BÁO TỪ SERVER ===', data);
            allNotifications = data.notifications || [];
        }

        if (allNotifications.length === 0) {
            notificationList.innerHTML = '<div class="empty-state">Không có thông báo nào</div>';
            loadMoreBtn.style.display = 'none';
            return;
        }

        // Hiển thị thông báo tiếp theo
        const endIndex = Math.min(currentIndex + ITEMS_PER_PAGE, allNotifications.length);
        const nextNotifications = allNotifications.slice(currentIndex, endIndex);

        nextNotifications.forEach(notification => {
            console.log('Xử lý thông báo:', {
                id: notification.id,
                createdAt: notification.createdAt,
                type: notification.type,
                message: notification.message
            });
            const element = createNotificationElement(notification);
            notificationList.appendChild(element);
        });

        currentIndex = endIndex;

        // Cập nhật nút xem thêm
        const remainingCount = allNotifications.length - currentIndex;
        if (remainingCount > 0) {
            loadMoreBtn.textContent = `Xem thêm ${remainingCount} thông báo`;
            loadMoreBtn.style.display = 'block';
            loadMoreBtn.classList.add('pulse-animation');
        } else {
            loadMoreBtn.style.display = 'none';
            loadMoreBtn.classList.remove('pulse-animation');
        }

    } catch (error) {
        console.error('Lỗi:', error);
        if (reset) {
            notificationList.innerHTML = '<div class="empty-state">Không thể tải thông báo</div>';
        }
    } finally {
        loading = false;
    }
}

// Setup event listeners
function setupEventListeners() {
    console.log('=== THIẾT LẬP SỰ KIỆN ===');

    // Toggle dropdown
    if (notificationBtn) {
        console.log('Thiết lập sự kiện cho nút thông báo');

        // Xóa event listener cũ nếu có
        notificationBtn.onclick = async function (e) {
            console.log('=== CLICK NÚT THÔNG BÁO ===');
            e.preventDefault();
            e.stopPropagation();

            const isVisible = notificationDropdown.classList.contains('show');
            console.log('Trạng thái dropdown:', isVisible ? 'đang hiển thị' : 'đang ẩn');

            if (!isVisible) {
                // Đóng các dropdown khác
                document.querySelectorAll('.dropdown-menu.show').forEach(dropdown => {
                    dropdown.classList.remove('show');
                });

                notificationDropdown.classList.add('show');
                currentIndex = 0;
                await loadNotifications(true);
            } else {
                notificationDropdown.classList.remove('show');
            }
        };
    }

    // Close dropdown when clicking outside
    document.addEventListener('click', (e) => {
        if (!notificationDropdown.contains(e.target) && e.target !== notificationBtn) {
            notificationDropdown.classList.remove('show');
        }
    });

    // Filter change
    const filter = document.querySelector('.notification-filter');
    if (filter) {
        filter.addEventListener('change', async () => {
            await loadNotifications(true);
        });
    }

    // Mark all as read
    const markAllReadBtn = document.querySelector('.mark-all-read');
    if (markAllReadBtn) {
        markAllReadBtn.addEventListener('click', async (e) => {
            e.stopPropagation();
            try {
                const response = await fetch('/api/notifications/mark-all-read', {
                    ...fetchOptions,
                    method: 'POST',
                    headers: createHeaders()
                });

                if (!response.ok) {
                    throw new Error('Không thể đánh dấu tất cả là đã đọc');
                }

                await updateUnreadCount();
                await loadNotifications(true);
            } catch (error) {
                console.error('Lỗi khi đánh dấu tất cả là đã đọc:', error);
            }
        });
    }

    // Load more button
    const loadMoreBtn = document.querySelector('.load-more');
    if (loadMoreBtn) {
        loadMoreBtn.onclick = async function (e) {
            console.log('=== CLICK NÚT XEM THÊM ===');
            e.preventDefault();
            e.stopPropagation();

            if (!loading) {
                currentIndex += ITEMS_PER_PAGE; // Tăng index trước khi tải
                await loadNotifications(false);
            } else {
                console.log('Đang tải dữ liệu, vui lòng đợi...');
            }
        };
        console.log('Đã thiết lập sự kiện cho nút xem thêm');
    }
}

// Add CSS animations
const style = document.createElement('style');
style.textContent = `
@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(-10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@keyframes pulse {
    0% { transform: scale(1); }
    50% { transform: scale(1.05); }
    100% { transform: scale(1); }
}

.notification-item {
    animation: fadeIn 0.3s ease-out;
}

.notification-badge {
    animation: pulse 2s infinite;
}

.text-primary { color: #007bff !important; }
.text-success { color: #28a745 !important; }
.text-warning { color: #ffc107 !important; }
.text-info { color: #17a2b8 !important; }
`;
document.head.appendChild(style);

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    console.log('DOM đã sẵn sàng');
    moment.locale('vi'); // Set moment.js locale to Vietnamese
    initNotifications();
}); 