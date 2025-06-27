// Hàm để cập nhật số lượng thông báo chưa đọc
function updateUnreadCount() {
    fetch('/notifications/unread-count')
        .then(response => response.json())
        .then(data => {
            const badge = document.querySelector('.notification-badge');
            if (badge) {
                badge.textContent = data.count;
                badge.style.display = data.count > 0 ? 'block' : 'none';
            }
        })
        .catch(error => console.error('Error:', error));
}

// Hàm để tải danh sách thông báo
function loadNotifications() {
    fetch('/notifications/list')
        .then(response => response.json())
        .then(notifications => {
            const container = document.querySelector('.notification-list');
            if (container) {
                container.innerHTML = ''; // Xóa nội dung cũ

                if (notifications.length === 0) {
                    container.innerHTML = '<div class="no-notifications">Không có thông báo mới</div>';
                    return;
                }

                notifications.forEach(notification => {
                    const notificationElement = createNotificationElement(notification);
                    container.appendChild(notificationElement);
                });

                // Thêm nút "Đánh dấu tất cả đã đọc" nếu có thông báo chưa đọc
                if (notifications.some(n => !n.isRead)) {
                    const markAllButton = document.createElement('button');
                    markAllButton.className = 'mark-all-read-btn';
                    markAllButton.textContent = 'Đánh dấu tất cả đã đọc';
                    markAllButton.onclick = markAllAsRead;
                    container.appendChild(markAllButton);
                }
            }
        })
        .catch(error => console.error('Error:', error));
}

// Hàm tạo element cho một thông báo
function createNotificationElement(notification) {
    const div = document.createElement('div');
    div.className = `notification-item ${notification.isRead ? '' : 'unread'}`;
    div.setAttribute('data-id', notification.notificationID);

    const title = document.createElement('div');
    title.className = 'notification-title';
    title.textContent = notification.title;

    const message = document.createElement('div');
    message.className = 'notification-message';
    message.textContent = notification.message;

    const time = document.createElement('div');
    time.className = 'notification-time';
    time.textContent = formatTime(notification.sentAt);

    div.appendChild(title);
    div.appendChild(message);
    div.appendChild(time);

    // Thêm sự kiện click để đánh dấu đã đọc
    if (!notification.isRead) {
        div.onclick = () => markAsRead(notification.notificationID);
    }

    return div;
}

// Hàm định dạng thời gian
function formatTime(timestamp) {
    if (!timestamp) return 'Không xác định';

    try {
        let momentDate;
        if (Array.isArray(timestamp)) {
            const [year, month, day, hour, minute, second] = timestamp;
            momentDate = moment([year, month - 1, day, hour, minute, second]);
        } else {
            momentDate = moment(timestamp);
        }

        if (!momentDate.isValid()) return 'Không xác định';

        const now = moment();
        const diff = now.diff(momentDate, 'minutes');

        if (diff < 1) return 'Vừa xong';
        if (diff < 60) return `${diff} phút trước`;
        if (diff < 1440) return momentDate.format('HH:mm [hôm nay]');
        if (diff < 2880) return momentDate.format('HH:mm [hôm qua]');
        if (diff < 7200) return momentDate.format('HH:mm [• ] DD/MM');
        return momentDate.format('HH:mm [•] DD/MM/YYYY');
    } catch (error) {
        console.error('Error formatting date:', error);
        return 'Không xác định';
    }
}

// Hàm đánh dấu một thông báo đã đọc
function markAsRead(notificationId) {
    fetch(`/notifications/${notificationId}/mark-read`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').getAttribute('content')
        }
    })
        .then(() => {
            updateUnreadCount();
            loadNotifications();
        })
        .catch(error => console.error('Error:', error));
}

// Hàm đánh dấu tất cả thông báo đã đọc
function markAllAsRead() {
    fetch('/notifications/mark-all-read', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').getAttribute('content')
        }
    })
        .then(() => {
            updateUnreadCount();
            loadNotifications();
        })
        .catch(error => console.error('Error:', error));
}

// Khởi tạo khi trang được load
document.addEventListener('DOMContentLoaded', () => {
    const notificationBtn = document.getElementById('notificationBtn');
    const notificationDropdown = document.getElementById('notificationDropdown');

    if (notificationBtn && notificationDropdown) {
        // Cập nhật số lượng thông báo chưa đọc mỗi 30 giây
        updateUnreadCount();
        setInterval(updateUnreadCount, 30000);

        // Xử lý sự kiện click vào nút thông báo
        notificationBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            notificationDropdown.classList.toggle('show');
            if (notificationDropdown.classList.contains('show')) {
                loadNotifications();
            }
        });

        // Đóng dropdown khi click ra ngoài
        document.addEventListener('click', (e) => {
            if (!notificationDropdown.contains(e.target) && !notificationBtn.contains(e.target)) {
                notificationDropdown.classList.remove('show');
            }
        });
    }
}); 