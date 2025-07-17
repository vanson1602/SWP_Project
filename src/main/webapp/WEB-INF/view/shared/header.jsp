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

                                <!-- Chat Button -->
                                <a href="/chat" class="chat-btn" title="Tin nhắn">
                                    <i class="bi bi-chat-dots"></i>
                                </a>

                                <!-- User Dropdown -->
                                <div class="dropdown">
                                    <button class="profile-btn" id="profileDropdownBtn">
                                        <i class="bi bi-person-circle"></i>
                                        ${sessionScope.currentUser.firstName}
                                        ${sessionScope.currentUser.lastName}
                                    </button>
                                    <ul class="dropdown-menu" id="profileDropdown">
                                        <li><a class="dropdown-item" href="/profile"><i class="bi bi-person"></i> Trang
                                                cá nhân</a></li>
                                        <li><a class="dropdown-item" href="/settings"><i class="bi bi-gear"></i>
                                                Cài
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

            @keyframes slideIn {
                from {
                    transform: translateX(-100%);
                }

                to {
                    transform: translateX(0);
                }
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

            @keyframes glow {
                0% {
                    box-shadow: 0 0 5px rgba(0, 123, 255, 0.2);
                }

                50% {
                    box-shadow: 0 0 20px rgba(0, 123, 255, 0.4);
                }

                100% {
                    box-shadow: 0 0 5px rgba(0, 123, 255, 0.2);
                }
            }

            .header {
                background: linear-gradient(to right, #ffffff, #f8f9fa);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                position: sticky;
                top: 0;
                z-index: 1000;
                animation: fadeIn 0.5s ease-out;
                backdrop-filter: blur(10px);
            }

            .nav {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 1rem 0;
                max-width: 1400px;
                margin: 0 auto;
            }

            .logo {
                display: flex;
                align-items: center;
                text-decoration: none;
                color: #333;
                font-weight: bold;
                font-size: 1.5rem;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                position: relative;
                padding: 0.5rem 1rem;
                border-radius: 8px;
            }

            .logo:hover {
                color: #007bff;
                transform: translateY(-2px);
                text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
            }

            .logo::after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                width: 100%;
                height: 2px;
                background: linear-gradient(to right, #007bff, #00c6ff);
                transform: scaleX(0);
                transition: transform 0.3s ease;
            }

            .logo:hover::after {
                transform: scaleX(1);
            }

            .logo-icon {
                margin-right: 0.5rem;
                font-size: 1.8rem;
                animation: pulse 2s infinite;
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
                padding: 0.7rem 1rem;
                border-radius: 8px;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                position: relative;
                overflow: hidden;
            }

            .nav-links a::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 123, 255, 0.1);
                transform: translateX(-100%);
                transition: transform 0.3s ease;
            }

            .nav-links a:hover::before {
                transform: translateX(0);
            }

            .nav-links a:hover,
            .nav-links a.active {
                color: #007bff;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0, 123, 255, 0.1);
            }

            .nav-links i {
                font-size: 1.2rem;
                transition: transform 0.3s ease;
            }

            .nav-links a:hover i {
                transform: scale(1.2);
            }

            .user-menu {
                display: flex;
                align-items: center;
                gap: 1.5rem;
            }

            .profile-btn {
                display: flex;
                align-items: center;
                gap: 0.8rem;
                background: linear-gradient(to right, #f8f9fa, #ffffff);
                border: 1px solid rgba(0, 123, 255, 0.1);
                color: #333;
                font-weight: 500;
                cursor: pointer;
                padding: 0.7rem 1.2rem;
                border-radius: 12px;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                text-decoration: none;
            }

            .profile-btn:hover {
                color: #007bff;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0, 123, 255, 0.1);
                border-color: rgba(0, 123, 255, 0.3);
            }

            .chat-btn {
                display: flex;
                align-items: center;
                justify-content: center;
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background: linear-gradient(45deg, #007bff, #00c6ff);
                border: none;
                color: white;
                font-size: 1.2rem;
                cursor: pointer;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                text-decoration: none;
                padding: 0;
                animation: glow 2s infinite;
            }

            .chat-btn:hover {
                transform: scale(1.1) rotate(5deg);
                box-shadow: 0 6px 16px rgba(0, 123, 255, 0.2);
            }

            .notification-btn {
                position: relative;
                background: none;
                border: none;
                padding: 0.5rem;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .notification-badge {
                position: absolute;
                top: -5px;
                right: -5px;
                background: #ff4757;
                color: white;
                border-radius: 50%;
                padding: 0.2rem 0.5rem;
                font-size: 0.8rem;
                animation: pulse 2s infinite;
            }

            .dropdown-menu {
                display: none;
                position: absolute;
                right: 0;
                top: 120%;
                background: rgba(255, 255, 255, 0.95);
                border-radius: 12px;
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
                padding: 0.8rem 0;
                min-width: 220px;
                z-index: 1000;
                animation: fadeIn 0.3s ease-out;
                backdrop-filter: blur(10px);
                transform-origin: top right;
            }

            .dropdown-menu.show {
                display: block;
                animation: fadeIn 0.3s ease-out;
            }

            .dropdown-item {
                display: flex;
                align-items: center;
                gap: 0.8rem;
                padding: 0.8rem 1.2rem;
                color: #333;
                text-decoration: none;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .dropdown-item::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: linear-gradient(45deg, rgba(0, 123, 255, 0.1), transparent);
                transform: translateX(-100%);
                transition: transform 0.3s ease;
            }

            .dropdown-item:hover::before {
                transform: translateX(0);
            }

            .dropdown-item:hover {
                color: #007bff;
                transform: translateX(5px);
            }

            .dropdown-item i {
                font-size: 1.1rem;
                color: #007bff;
                transition: transform 0.3s ease;
            }

            .dropdown-item:hover i {
                transform: scale(1.2) rotate(5deg);
            }

            .dropdown-divider {
                height: 1px;
                background: linear-gradient(to right, transparent, rgba(0, 0, 0, 0.1), transparent);
                border: none;
                margin: 0.8rem 0;
            }

            @media (max-width: 768px) {
                .mobile-menu-btn {
                    display: block;
                    background: none;
                    border: none;
                    font-size: 1.5rem;
                    cursor: pointer;
                    padding: 0.5rem;
                    transition: transform 0.3s ease;
                }

                .mobile-menu-btn:hover {
                    transform: scale(1.1);
                }

                .nav-links {
                    display: none;
                    position: absolute;
                    top: 100%;
                    left: 0;
                    right: 0;
                    background: rgba(255, 255, 255, 0.95);
                    padding: 1rem;
                    flex-direction: column;
                    gap: 1rem;
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                    backdrop-filter: blur(10px);
                }

                .nav-links.show {
                    display: flex;
                    animation: slideIn 0.3s ease-out;
                }

                .nav-links a {
                    padding: 1rem;
                    border-radius: 8px;
                    background: linear-gradient(to right, #f8f9fa, #ffffff);
                }
            }
        </style>

        <script>
            // Set moment.js locale to Vietnamese
            moment.locale('vi');

            // Mobile menu toggle with animation
            document.getElementById('mobileMenuBtn')?.addEventListener('click', () => {
                const navLinks = document.getElementById('navLinks');
                navLinks.classList.toggle('show');

                if (navLinks.classList.contains('show')) {
                    navLinks.style.animation = 'slideIn 0.3s ease-out';
                } else {
                    navLinks.style.animation = 'slideOut 0.3s ease-out';
                }
            });

            // Profile dropdown toggle with animation
            document.getElementById('profileDropdownBtn')?.addEventListener('click', (e) => {
                e.stopPropagation();
                const dropdown = document.getElementById('profileDropdown');
                dropdown.classList.toggle('show');

                if (dropdown.classList.contains('show')) {
                    dropdown.style.animation = 'fadeIn 0.3s ease-out';
                }
            });

            // Close dropdown when clicking outside
            document.addEventListener('click', () => {
                const dropdown = document.getElementById('profileDropdown');
                if (dropdown?.classList.contains('show')) {
                    dropdown.style.animation = 'fadeOut 0.3s ease-out';
                    setTimeout(() => {
                        dropdown.classList.remove('show');
                    }, 300);
                }
            });

            // Add hover animation for nav links
            document.querySelectorAll('.nav-links a').forEach(link => {
                link.addEventListener('mouseenter', () => {
                    link.style.transform = 'translateY(-2px)';
                });

                link.addEventListener('mouseleave', () => {
                    link.style.transform = 'translateY(0)';
                });
            });
        </script>