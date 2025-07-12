// Hàm để cập nhật số lượng thông báo chưa đọc
function updateUnreadCount() {
  fetch("/notifications/unread-count")
    .then((response) => response.json())
    .then((data) => {
      const badge = document.querySelector(".notification-badge");
      if (badge) {
        badge.textContent = data.count;
        badge.style.display = data.count > 0 ? "block" : "none";
      }
    })
    .catch((error) => console.error("Error:", error));
}

// Hàm để tải danh sách thông báo
function loadNotifications() {
  fetch("/notifications/list")
    .then((response) => response.json())
    .then((notifications) => {
      console.log("Raw notifications:", notifications); // Debug log
      const container = document.querySelector(".notification-dropdown");
      if (container) {
        container.innerHTML = ""; // Xóa nội dung cũ

        if (notifications.length === 0) {
          container.innerHTML =
            '<div class="no-notifications">Không có thông báo mới</div>';
          return;
        }

        notifications.forEach((notification) => {
          console.log("Processing notification:", notification); // Debug log for each notification
          console.log("Timestamp:", notification.sentAt); // Debug specific timestamp
          const notificationElement = createNotificationElement(notification);
          container.appendChild(notificationElement);
        });

        // Thêm nút "Đánh dấu tất cả đã đọc" nếu có thông báo chưa đọc
        if (notifications.some((n) => !n.isRead)) {
          const markAllButton = document.createElement("button");
          markAllButton.className = "mark-all-read-btn";
          markAllButton.textContent = "Đánh dấu tất cả đã đọc";
          markAllButton.onclick = markAllAsRead;
          container.appendChild(markAllButton);
        }
      }
    })
    .catch((error) => console.error("Error:", error));
}

// Hàm tạo element cho một thông báo
function createNotificationElement(notification) {
  const div = document.createElement("div");
  div.className = `notification-item ${notification.isRead ? "" : "unread"}`;
  div.setAttribute("data-id", notification.notificationID);

  const title = document.createElement("div");
  title.className = "notification-title";
  title.textContent = notification.title;

  const message = document.createElement("div");
  message.className = "notification-message";
  message.textContent = notification.message;

  const time = document.createElement("div");
  time.className = "notification-time";
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
  console.log("Formatting timestamp:", timestamp);

  if (!timestamp) {
    console.log("Timestamp is null or undefined");
    return "Không xác định";
  }

  try {
    let momentDate;

    // Kiểm tra nếu timestamp là mảng
    if (Array.isArray(timestamp)) {
      // Chuyển đổi mảng thành đối tượng Date
      // Format: [year, month(1-12), day, hour, minute, second, nanoOfSecond]
      const [year, month, day, hour, minute, second, nano] = timestamp;
      // Lưu ý: moment month bắt đầu từ 0 nên phải trừ 1
      momentDate = moment([
        year,
        month - 1,
        day,
        hour,
        minute,
        second,
        Math.floor(nano / 1000000),
      ]);
    } else {
      momentDate = moment(timestamp);
    }

    if (!momentDate.isValid()) {
      console.error("Invalid date:", timestamp);
      return "Không xác định";
    }

    const now = moment();
    const diff = now.diff(momentDate, "minutes");

    console.log("Parsed date:", momentDate.format("YYYY-MM-DD HH:mm:ss"));
    console.log("Time difference in minutes:", diff);

    if (diff < 1) {
      return "Vừa xong";
    } else if (diff < 60) {
      return momentDate.fromNow() + " • " + momentDate.format("HH:mm");
    } else if (diff < 1440) {
      // 24 giờ
      return momentDate.fromNow() + " • " + momentDate.format("HH:mm");
    } else if (diff < 10080) {
      // 7 ngày
      return momentDate.fromNow() + " • " + momentDate.format("HH:mm");
    } else {
      return momentDate.format("DD/MM/YYYY • HH:mm");
    }
  } catch (error) {
    console.error("Error formatting date:", error);
    return "Không xác định";
  }
}

// Hàm đánh dấu một thông báo đã đọc
function markAsRead(notificationId) {
  fetch(`/notifications/${notificationId}/mark-read`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-TOKEN": document
        .querySelector('meta[name="_csrf"]')
        .getAttribute("content"),
    },
  })
    .then(() => {
      updateUnreadCount();
      loadNotifications();
    })
    .catch((error) => console.error("Error:", error));
}

// Hàm đánh dấu tất cả thông báo đã đọc
function markAllAsRead() {
  fetch("/notifications/mark-all-read", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-TOKEN": document
        .querySelector('meta[name="_csrf"]')
        .getAttribute("content"),
    },
  })
    .then(() => {
      updateUnreadCount();
      loadNotifications();
    })
    .catch((error) => console.error("Error:", error));
}

// Khởi tạo khi trang được load
document.addEventListener("DOMContentLoaded", () => {
  const notificationBtn = document.getElementById("notificationBtn");
  const notificationDropdown = document.getElementById("notificationDropdown");

  if (notificationBtn && notificationDropdown) {
    // Cập nhật số lượng thông báo chưa đọc mỗi 30 giây
    updateUnreadCount();
    setInterval(updateUnreadCount, 30000);

    // Xử lý sự kiện click vào nút thông báo
    notificationBtn.addEventListener("click", (e) => {
      e.stopPropagation();
      notificationDropdown.classList.toggle("show");
      if (notificationDropdown.classList.contains("show")) {
        loadNotifications();
      }
    });

    // Đóng dropdown khi click ra ngoài
    document.addEventListener("click", (e) => {
      if (
        !notificationDropdown.contains(e.target) &&
        !notificationBtn.contains(e.target)
      ) {
        notificationDropdown.classList.remove("show");
      }
    });
  }
});
