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
                        <li><a href="/" class="active"><i class="bi bi-house-door"></i> Trang chủ</a></li>
                        <li><a href="/doctors"><i class="bi bi-person-badge"></i> Bác sĩ</a></li>
                        <li><a href="/specialties"><i class="bi bi-clipboard2-pulse"></i> Chuyên khoa</a></li>
                        <li><a href="/appointments"><i class="bi bi-calendar-check"></i> Lịch hẹn</a></li>
                    </ul>

                    <!-- User Menu -->
                    <div class="user-menu">
                        <c:choose>
                            <c:when test="${not empty sessionScope.currentUser}">
                                <button class="notification-btn">
                                    <i class="bi bi-bell"></i>
                                    <span class="notification-badge">2</span>
                                </button>
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

        <!-- Header Scripts -->
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