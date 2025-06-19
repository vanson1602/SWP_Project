<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
                        <li><a href="/doctors"
                                class="${pageContext.request.servletPath == '/WEB-INF/view/doctors.jsp' ? 'active' : ''}">
                                <i class="bi bi-person-badge"></i> Bác sĩ
                            </a></li>
                        <li><a href="/specialties"
                                class="${pageContext.request.servletPath == '/WEB-INF/view/specialties.jsp' ? 'active' : ''}">
                                <i class="bi bi-clipboard2-pulse"></i> Chuyên khoa
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
                                <div class="notification-wrapper">
                                    <button class="notification-btn">
                                        <i class="bi bi-bell"></i>
                                        <span class="notification-badge">0</span>
                                    </button>
                                    <div class="notification-dropdown">
                                        <!-- Notifications will be loaded here -->
                                    </div>
                                </div>
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
                transition: background-color 0.3s;
            }

            .profile-btn:hover {
                background-color: #f8f9fa;
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
                transition: background-color 0.3s;
            }

            .dropdown-item:hover {
                background-color: #f8f9fa;
            }

            .dropdown-divider {
                margin: 0.5rem 0;
                border-top: 1px solid #eee;
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
                    flex-direction: column;
                    padding: 1rem;
                    gap: 1rem;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                }

                .nav-links.show {
                    display: flex;
                }

                .nav-links a {
                    padding: 0.5rem;
                }

                .user-menu {
                    gap: 0.5rem;
                }

                .profile-btn span {
                    display: none;
                }
            }
        </style>

        <!-- Header JavaScript -->
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Mobile menu handling
                const mobileMenuBtn = document.getElementById('mobileMenuBtn');
                const navLinks = document.getElementById('navLinks');

                mobileMenuBtn.addEventListener('click', function () {
                    navLinks.classList.toggle('show');
                    const icon = this.querySelector('i');
                    if (navLinks.classList.contains('show')) {
                        icon.classList.remove('bi-list');
                        icon.classList.add('bi-x-lg');
                    } else {
                        icon.classList.remove('bi-x-lg');
                        icon.classList.add('bi-list');
                    }
                });

                // Profile dropdown handling
                const profileBtn = document.getElementById('profileDropdownBtn');
                const profileDropdown = document.getElementById('profileDropdown');

                if (profileBtn && profileDropdown) {
                    profileBtn.addEventListener('click', function (e) {
                        e.stopPropagation();
                        profileDropdown.classList.toggle('show');
                    });

                    // Close dropdown when clicking outside
                    document.addEventListener('click', function (e) {
                        if (!profileDropdown.contains(e.target) && !profileBtn.contains(e.target)) {
                            profileDropdown.classList.remove('show');
                        }
                    });
                }

                // Close mobile menu when clicking outside
                document.addEventListener('click', function (e) {
                    if (!e.target.closest('.nav-links') &&
                        !e.target.closest('.mobile-menu-btn') &&
                        navLinks.classList.contains('show')) {
                        navLinks.classList.remove('show');
                        const icon = mobileMenuBtn.querySelector('i');
                        icon.classList.remove('bi-x-lg');
                        icon.classList.add('bi-list');
                    }
                });
            });
        </script>

        <!-- Add notification CSS and JS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/notifications.css">
        <script src="${pageContext.request.contextPath}/resources/js/notifications.js"></script>