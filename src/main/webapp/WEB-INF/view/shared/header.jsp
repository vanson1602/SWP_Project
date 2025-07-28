<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- Required meta tags -->
        <meta name="_csrf" content="${_csrf.token}" />
        <meta name="_csrf_header" content="${_csrf.headerName}" />

        <!-- Required CSS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

        <!-- Header -->
        <header class="header">
            <div class="container">
                <nav class="nav">
                    <!-- Logo -->
                    <a href="/" class="logo">
                        <div class="logo-icon">⚕️</div>
                        HealthCare+
                    </a>

                    <!-- Mobile Menu Button -->
                    <button class="mobile-menu-btn" id="mobileMenuBtn">
                        <i class="bi bi-list"></i>
                    </button>

                    <!-- Navigation Links -->
                    <ul class="nav-links" id="navLinks">
                        <li><a href="/"
                                class="${pageContext.request.servletPath == '/WEB-INF/view/authentication/homepage.jsp' ? 'active' : ''}">
                                <i class="bi bi-house-door"></i> Trang chủ
                            </a></li>
                        <li><a href="/appointments"
                                class="${pageContext.request.servletPath.startsWith('/WEB-INF/view/appointment/') ? 'active' : ''}">
                                <i class="bi bi-calendar-check"></i> Lịch hẹn
                            </a></li>
                    </ul>

                    <!-- User Menu -->
                    <div class="user-menu">
                        <c:choose>
                            <c:when test="${not empty sessionScope.currentUser}">
                                <!-- Notification Button -->
                                <div class="notification-wrapper">
                                    <button type="button" class="notification-btn" id="notificationBtn">
                                        <i class="bi bi-bell-fill"></i>
                                        <c:if test="${notificationCount > 0}">
                                            <span class="notification-badge">${notificationCount}</span>
                                        </c:if>
                                    </button>
                                    <div class="notification-dropdown" id="notificationDropdown">
                                        <div class="notification-header">
                                            <h3>Thông báo</h3>
                                            <div class="d-flex gap-2">
                                                <button type="button" class="mark-all-read btn btn-light btn-sm">
                                                    <i class="bi bi-check2-all"></i> Đánh dấu đã đọc
                                                </button>
                                                <select class="notification-filter">
                                                    <option value="all">Tất cả</option>
                                                    <option value="unread">Chưa đọc</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="notification-list" id="notificationList">
                                            <!-- Notifications will be inserted here -->
                                        </div>
                                        <button type="button" class="load-more" style="display: none;">Xem thêm</button>
                                    </div>
                                </div>

                                <!-- Chat Button -->
                                <a href="/chat" class="chat-btn" title="Tin nhắn">
                                    <i class="bi bi-chat-dots"></i>
                                </a>

                                <!-- User Dropdown -->
                                <div class="dropdown">
                                    <button class="profile-btn" id="profileDropdownBtn">
                                        <i class="bi bi-person-circle"></i>
                                        ${sessionScope.currentUser.firstName} ${sessionScope.currentUser.lastName}
                                    </button>
                                    <ul class="dropdown-menu" id="profileDropdown">
                                        <li><a class="dropdown-item" href="/profile"><i class="bi bi-person"></i> Trang
                                                cá nhân</a></li>
                                        <li><a class="dropdown-item" href="/wallet"><i class="bi bi-wallet2"></i> Ví
                                                điện tử</a></li>
                                        <li><a class="dropdown-item" href="/settings"><i class="bi bi-gear"></i> Cài
                                                đặt</a></li>
                                        <li>
                                            <hr class="dropdown-divider">
                                        </li>
                                        <li><a class="dropdown-item" href="/logout"><i
                                                    class="bi bi-box-arrow-right"></i> Đăng xuất</a></li>
                                    </ul>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <a href="/login" class="profile-btn">
                                    <i class="bi bi-box-arrow-in-right"></i>
                                    Đăng nhập
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </nav>
            </div>
        </header>

        <!-- Header CSS -->
        <style>
            .header {
                background-color: #fff;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                position: sticky;
                top: 0;
                z-index: 1000;
            }

            .nav {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 1rem 0;
            }

            .logo {
                display: flex;
                align-items: center;
                text-decoration: none;
                color: #333;
                font-weight: bold;
                font-size: 1.5rem;
                transition: color 0.3s;
            }

            .logo:hover {
                color: #007bff;
            }

            .logo-icon {
                margin-right: 0.5rem;
                font-size: 1.8rem;
            }

            .mobile-menu-btn {
                display: none;
                background: none;
                border: none;
                font-size: 1.5rem;
                cursor: pointer;
                padding: 0.5rem;
            }

            .nav-links {
                display: flex;
                list-style: none;
                margin: 0;
                padding: 0;
                gap: 2rem;
            }

            .nav-links a {
                text-decoration: none;
                color: #666;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.5rem;
                transition: color 0.3s;
            }

            .nav-links a:hover,
            .nav-links a.active {
                color: #007bff;
            }

            .nav-links i {
                font-size: 1.2rem;
            }

            .user-menu {
                display: flex;
                align-items: center;
                gap: 1rem;
            }

            .notification-wrapper {
                position: relative;
                margin-right: 0.5rem;
            }

            .notification-btn {
                position: relative;
                background: #f0f2f5;
                border: none;
                padding: 0.5rem;
                cursor: pointer;
                color: #1a1a1a;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: all 0.3s ease;
                width: 40px;
                height: 40px;
                border-radius: 50%;
                text-decoration: none;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }

            .notification-btn i {
                font-size: 1.3rem;
                color: #1a1a1a;
            }

            .notification-btn:hover {
                background: #e4e6eb;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
            }

            .notification-badge {
                position: absolute;
                top: -5px;
                right: -5px;
                background-color: #f03e3e;
                color: white;
                border-radius: 50%;
                min-width: 20px;
                height: 20px;
                padding: 0 6px;
                font-size: 12px;
                font-weight: 700;
                display: flex;
                align-items: center;
                justify-content: center;
                border: 2px solid #fff;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
            }

            .profile-btn {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                background: none;
                border: none;
                color: #333;
                font-weight: 500;
                cursor: pointer;
                padding: 0.5rem 1rem;
                border-radius: 0.5rem;
                transition: all 0.3s ease;
                text-decoration: none;
            }

            .profile-btn:hover {
                color: #007bff;
            }

            .profile-btn i {
                font-size: 1.2rem;
                transition: color 0.3s ease;
            }

            .dropdown {
                position: relative;
            }

            .dropdown-menu {
                display: none;
                position: absolute;
                right: 0;
                top: 100%;
                background-color: #fff;
                border-radius: 0.5rem;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                padding: 0.5rem 0;
                min-width: 200px;
                z-index: 1000;
            }

            .dropdown-menu.show {
                display: block;
            }

            .dropdown-item {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.5rem 1rem;
                color: #333;
                text-decoration: none;
                transition: all 0.3s ease;
            }

            .dropdown-item:hover {
                background-color: #f8f9fa;
                color: #007bff;
            }

            .dropdown-item i {
                font-size: 1.1rem;
            }

            .dropdown-divider {
                height: 1px;
                background-color: #e9ecef;
                border: none;
                margin: 0.5rem 0;
            }

            /* Notification Dropdown */
            .notification-dropdown {
                display: none;
                position: absolute;
                top: 100%;
                right: 0;
                width: 400px;
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
                z-index: 1000;
                max-height: 90vh;
                overflow-y: auto;
            }

            .notification-dropdown.show {
                display: block;
            }

            /* Notification Header */
            .notification-header {
                padding: 20px;
                border-bottom: 1px solid #e4e6eb;
                display: flex;
                justify-content: space-between;
                align-items: center;
                position: sticky;
                top: 0;
                background: white;
                z-index: 1;
            }

            .notification-header h3 {
                margin: 0;
                font-size: 24px;
                font-weight: bold;
                color: #1c1e21;
            }

            /* Mark all as read button */
            .mark-all-read {
                padding: 8px 16px;
                border: none;
                border-radius: 20px;
                font-size: 14px;
                color: #1c1e21;
                background: #e4e6eb;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 8px;
                font-weight: 500;
            }

            .mark-all-read:hover {
                background: #d8dadf;
                transform: translateY(-1px);
            }

            .mark-all-read i {
                font-size: 18px;
            }

            /* Notification Filter */
            .notification-filter {
                padding: 8px 16px;
                border: none;
                border-radius: 20px;
                font-size: 14px;
                color: #1c1e21;
                background: #e4e6eb;
                cursor: pointer;
                outline: none;
                transition: all 0.3s ease;
                font-weight: 500;
            }

            .notification-filter:hover {
                background: #d8dadf;
            }

            /* Notification List */
            .notification-list {
                padding: 8px 0;
            }

            /* Notification Item */
            .notification-item {
                padding: 16px 20px;
                display: flex;
                align-items: flex-start;
                gap: 16px;
                cursor: pointer;
                transition: all 0.3s ease;
                border-bottom: 1px solid #f0f2f5;
            }

            .notification-item:hover {
                background-color: #f0f2f5;
                transform: translateY(-1px);
            }

            .notification-item.unread {
                background-color: #e7f3ff;
            }

            .notification-item.unread:hover {
                background-color: #dbe7f2;
            }

            .notification-icon {
                width: 48px;
                height: 48px;
                border-radius: 50%;
                background: #e4e6eb;
                display: flex;
                align-items: center;
                justify-content: center;
                flex-shrink: 0;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            }

            .notification-icon i {
                font-size: 20px;
            }

            .notification-content {
                flex-grow: 1;
            }

            .notification-message {
                margin: 0;
                font-size: 14px;
                line-height: 1.5;
                color: #1c1e21;
                font-weight: 500;
            }

            .notification-time {
                font-size: 12px;
                color: #65676b;
                margin-top: 6px;
                display: block;
            }

            /* Section Headers */
            .notification-section {
                padding: 16px 16px 8px;
                font-size: 16px;
                font-weight: 600;
                color: #1c1e21;
            }

            /* Empty State */
            .empty-state {
                padding: 40px 20px;
                text-align: center;
                color: #65676b;
                font-size: 15px;
                font-weight: 500;
            }

            /* Load More Button */
            .load-more {
                display: none;
                width: 100%;
                padding: 12px;
                background: none;
                border: none;
                color: #1877f2;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                font-size: 14px;
            }

            .load-more:hover {
                background-color: #f0f2f5;
            }

            .load-more.pulse-animation {
                animation: pulse 2s infinite;
            }

            @keyframes pulse {
                0% {
                    transform: scale(1);
                }

                50% {
                    transform: scale(1.05);
                }

                100% {
                    transform: scale(1);
                }
            }

            /* Chat Button */
            .chat-btn {
                position: relative;
                background: #f0f2f5;
                border: none;
                padding: 0.5rem;
                cursor: pointer;
                color: #1a1a1a;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: all 0.3s ease;
                width: 40px;
                height: 40px;
                border-radius: 50%;
                text-decoration: none;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }

            .chat-btn i {
                font-size: 1.3rem;
                color: #1a1a1a;
            }

            .chat-btn:hover {
                background: #e4e6eb;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
            }

            @media (max-width: 768px) {
                .mobile-menu-btn {
                    display: block;
                }

                .nav-links {
                    display: none;
                    position: absolute;
                    top: 100%;
                    left: 0;
                    right: 0;
                    background-color: #fff;
                    padding: 1rem;
                    flex-direction: column;
                    gap: 1rem;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                }

                .nav-links.show {
                    display: flex;
                }

                .notification-dropdown {
                    width: 100%;
                    position: fixed;
                    top: 60px;
                    left: 0;
                    right: 0;
                    max-height: calc(100vh - 60px);
                    border-radius: 0;
                }
            }
        </style>

        <!-- Header JavaScript -->
        <script>
            // Mobile menu toggle
            document.addEventListener('DOMContentLoaded', function () {
                const mobileMenuBtn = document.getElementById('mobileMenuBtn');
                const navLinks = document.getElementById('navLinks');

                if (mobileMenuBtn && navLinks) {
                    mobileMenuBtn.addEventListener('click', () => {
                        navLinks.classList.toggle('show');
                    });
                }

                // Profile dropdown toggle
                const profileDropdownBtn = document.getElementById('profileDropdownBtn');
                const profileDropdown = document.getElementById('profileDropdown');

                if (profileDropdownBtn && profileDropdown) {
                    profileDropdownBtn.addEventListener('click', (e) => {
                        e.stopPropagation();
                        profileDropdown.classList.toggle('show');
                    });
                }

                // Close dropdown when clicking outside
                document.addEventListener('click', () => {
                    if (profileDropdown) {
                        profileDropdown.classList.remove('show');
                    }
                });

                // Notification handling is now managed by notifications.js
                // Removed inline notification JavaScript to avoid conflicts
            });
        </script>