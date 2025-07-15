<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!-- Required scripts for notifications -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/locale/vi.js"></script>
        <link rel="stylesheet" href="/resources/css/notifications.css">
        <script src="/resources/js/notifications.js"></script>

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
                        <li><a href="<c:url value='/doctor/home' />" class="active"><i class="bi bi-house-door"></i> Trang
                            chủ</a></li>
                        <li><a href="/doctor/busy/schedule"><i class="bi bi-person-badge"></i> Gửi lịch bận</a></li>
                        <li><a href="/doctor/schedules"><i class="bi bi-clipboard2-pulse"></i> Xem lịch làm việc </a></li>
                        <li><a href="<c:url value='/doctor/appointments' />"><i class="bi bi-calendar-check"></i> Lịch hẹn</a>
                        </li>
                      </ul>

                    <!-- User Menu -->
                    <div class="user-menu">
                        <c:choose>
                            <c:when test="${not empty sessionScope.currentUser}">
                                <!-- Notification Dropdown -->
                                <div class="notification-wrapper">
                                    <button type="button" class="notification-btn" id="notificationBtn">
                                        <i class="bi bi-bell"></i>
                                        <span class="notification-badge">0</span>
                                    </button>
                                    <div class="notification-dropdown" id="notificationDropdown">
                                        <div class="notification-header">
                                            <h3>Thông báo</h3>
                                        </div>
                                        <div class="notification-list">
                                            <!-- Notifications will be loaded here -->
                                        </div>
                                    </div>
                                </div>

                                <!-- User Dropdown -->
                                <div class="dropdown">
                                    <button class="profile-btn" id="profileDropdownBtn">
                                        <i class="bi bi-person-circle"></i>
                                        ${sessionScope.currentUser.firstName} ${sessionScope.currentUser.lastName}
                                    </button>
                                    <ul class="dropdown-menu" id="profileDropdown">
                                        <li><a class="dropdown-item" href="/profile"><i class="bi bi-person"></i> Trang
                                                cá nhân</a></li>
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
            }
        </style>

        <!-- Header JavaScript -->
        <script>
            // Set moment.js locale to Vietnamese
            moment.locale('vi');
        </script>

        <script>
            // Mobile menu toggle
            document.getElementById('mobileMenuBtn')?.addEventListener('click', () => {
                document.getElementById('navLinks').classList.toggle('show');
            });

            // Profile dropdown toggle
            document.getElementById('profileDropdownBtn')?.addEventListener('click', (e) => {
                e.stopPropagation();
                document.getElementById('profileDropdown').classList.toggle('show');
            });

            // Close dropdown when clicking outside
            document.addEventListener('click', () => {
                document.getElementById('profileDropdown')?.classList.remove('show');
            });
        </script>