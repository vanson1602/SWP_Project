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
            const container = document.querySelector('.notification-dropdown');
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
    const date = new Date(timestamp);
    const now = new Date();
    const diff = now - date;

    if (diff < 60000) { // Dưới 1 phút
        return 'Vừa xong';
    } else if (diff < 3600000) { // Dưới 1 giờ
        const minutes = Math.floor(diff / 60000);
        return `${minutes} phút trước`;
    } else if (diff < 86400000) { // Dưới 1 ngày
        const hours = Math.floor(diff / 3600000);
        return `${hours} giờ trước`;
    } else {
        return date.toLocaleDateString('vi-VN');
    }
}

// Hàm đánh dấu một thông báo đã đọc
function markAsRead(notificationId) {
    fetch(`/notifications/${notificationId}/mark-read`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
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
            'Content-Type': 'application/json'
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
    const notificationBtn = document.querySelector('.notification-btn');
    const notificationDropdown = document.querySelector('.notification-dropdown');

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