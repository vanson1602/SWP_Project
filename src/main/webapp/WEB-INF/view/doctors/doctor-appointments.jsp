<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <link rel="stylesheet"
                href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
            <link rel="stylesheet" href="/css/homepage.css">
            <link rel="stylesheet" href="/css/doctor-appointments.css">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <title>HealthCare+ - Lịch hẹn Bác sĩ</title>
        </head>

        <body>
            <!-- Header -->
            <header class="header">
                <div class="container">
                    <nav class="nav">
                        <!-- Logo -->
                        <a href="<c:url value='/doctor/home' />" class="logo">
                            <div class="logo-icon">⚕️</div>
                            HealthCare+
                        </a>

                        <!-- Mobile Menu Button -->
                        <button class="mobile-menu-btn" id="mobileMenuBtn">
                            <i class="bi bi-list"></i>
                        </button>

                        <!-- Navigation Links -->
                        <ul class="nav-links" id="navLinks">
                            <li><a href="<c:url value='/doctor/home' />"><i class="bi bi-house-door"></i> Trang chủ</a>
                            </li>
                            <li><a href="/doctors"><i class="bi bi-person-badge"></i> Bác sĩ</a></li>
                            <li><a href="/doctor/schedules"><i class="bi bi-clipboard2-pulse"></i> Xem lịch làm việc</a>
                            </li>
                            <li><a href="<c:url value='/doctor/appointments' />" class="active"><i
                                        class="bi bi-calendar-check"></i> Lịch hẹn</a></li>
                        </ul>

                        <!-- User Menu -->
                        <div class="user-menu">
                            <c:choose>
                                <c:when test="${not empty currentUser}">
                                    <button class="notification-btn">
                                        <i class="bi bi-bell"></i>
                                        <span class="notification-badge">2</span>
                                    </button>
                                    <div class="dropdown">
                                        <button class="profile-btn" id="profileDropdownBtn">
                                            <i class="bi bi-person-circle"></i>
                                            ${currentUser.firstName} ${currentUser.lastName}
                                        </button>
                                        <ul class="dropdown-menu" id="profileDropdown">
                                            <li><a class="dropdown-item" href="/doctor/profile"><i
                                                        class="bi bi-person"></i> Trang cá nhân</a></li>
                                            <li><a class="dropdown-item" href="/doctor/settings"><i
                                                        class="bi bi-gear"></i> Cài đặt</a></li>
                                            <li>
                                                <hr class="dropdown-divider">
                                            </li>
                                            <li><a class="dropdown-item" href="/doctor/logout"><i
                                                        class="bi bi-box-arrow-right"></i> Đăng xuất</a></li>
                                        </ul>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <a href="<c:url value='/doctor' />" class="profile-btn">
                                        <i class="bi bi-box-arrow-in-right"></i>
                                        Đăng nhập
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </nav>
                </div>
            </header>

            <!-- Appointment Section -->
            <section class="appointments-section">
                <div class="container">
                    <h1 class="page-title">Lịch hẹn của bạn</h1>

                    <!-- Today's Bookings -->
                    <h2 class="section-title">
                        <i class="bi bi-calendar-day"></i>
                        Lịch hẹn hôm nay
                    </h2>
                    <div class="appointment-cards">
                        <c:choose>
                            <c:when test="${not empty bookingSlots}">
                                <c:forEach var="slot" items="${bookingSlots}">
                                    <div class="appointment-card">
                                        <div class="appointment-item">
                                            <div class="appointment-info">
                                                <div class="appointment-time">
                                                    <i class="bi bi-clock"></i>
                                                    ${slot.startTime} - ${slot.endTime}
                                                </div>
                                                <c:if test="${not empty slot.appointment.patient}">
                                                    <div class="appointment-patient">
                                                        <i class="bi bi-person"></i>
                                                        ${slot.appointment.patient.user.firstName}
                                                        ${slot.appointment.patient.user.lastName}
                                                    </div>
                                                </c:if>
                                            </div>
                                            <div class="d-flex align-items-center gap-3">
                                                <span
                                                    class="status-badge ${slot.status == 'Available' ? 'status-available' : 'status-confirmed'}">
                                                    ${slot.status}
                                                </span>
                                                <c:if test="${not empty slot.appointment.patient}">
                                                    <a href="<c:url value='/doctor/appointments/${slot.appointment.appointmentID}' />"
                                                        class="action-button view-btn">
                                                        <i class="bi bi-eye"></i> Xem chi tiết
                                                    </a>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="bi bi-calendar-x"></i>
                                    <p>Không có lịch hẹn nào trong ngày hôm nay</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Week's Appointments -->
                    <h2 class="section-title">
                        <i class="bi bi-calendar-week"></i>
                        Lịch hẹn trong tuần
                    </h2>
                    <div class="appointment-cards">
                        <c:choose>
                            <c:when test="${not empty appointments}">
                                <c:forEach var="appointment" items="${appointments}">
                                    <div class="appointment-card">
                                        <div class="appointment-item">
                                            <div class="appointment-info">
                                                <div class="appointment-time">
                                                    <i class="bi bi-calendar2-date"></i>
                                                    ${appointment.appointmentDate}
                                                </div>
                                                <div class="appointment-patient">
                                                    <i class="bi bi-hash"></i>
                                                    ${appointment.appointmentNumber}
                                                </div>
                                            </div>
                                            <div class="d-flex align-items-center gap-3">
                                                <span
                                                    class="status-badge ${appointment.status == 'Pending' ? 'status-pending' : 'status-confirmed'}">
                                                    ${appointment.status}
                                                </span>
                                                <a href="<c:url value='/doctor/appointments/${appointment.appointmentID}' />"
                                                    class="action-button view-btn">
                                                    <i class="bi bi-eye"></i> Xem chi tiết
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="bi bi-calendar-x"></i>
                                    <p>Không có lịch hẹn nào trong tuần này</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </section>

            <!-- Bootstrap JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

            <!-- Custom JavaScript -->
            <script>
                document.addEventListener('DOMContentLoaded', function () {
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

                    const profileBtn = document.getElementById('profileDropdownBtn');
                    const profileDropdown = document.getElementById('profileDropdown');

                    if (profileBtn && profileDropdown) {
                        profileBtn.addEventListener('click', function (e) {
                            e.stopPropagation();
                            profileDropdown.classList.toggle('show');
                        });

                        document.addEventListener('click', function (e) {
                            if (!profileDropdown.contains(e.target) && !profileBtn.contains(e.target)) {
                                profileDropdown.classList.remove('show');
                            }
                        });
                    }

                    document.addEventListener('click', function (e) {
                        if (!e.target.closest('.nav-links') && !e.target.closest('.mobile-menu-btn') && navLinks.classList.contains('show')) {
                            navLinks.classList.remove('show');
                            const icon = mobileMenuBtn.querySelector('i');
                            icon.classList.remove('bi-x-lg');
                            icon.classList.add('bi-list');
                        }
                    });
                });
            </script>
        </body>

        </html>