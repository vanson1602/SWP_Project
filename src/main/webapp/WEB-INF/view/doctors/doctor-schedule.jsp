<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Lịch làm việc</title>
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
            <link rel="stylesheet" href="/css/homepage.css">
            <style>
                .schedule-container {
                    margin-top: 50px;
                    background: white;
                    padding: 30px;
                    border-radius: 16px;
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
                }

                .table th,
                .table td {
                    vertical-align: middle !important;
                }

                .table thead {
                    background: linear-gradient(to right, #6a11cb, #2575fc);
                    color: white;
                }

                h2 {
                    color: #333;
                    font-weight: 600;
                    margin-bottom: 30px;
                }

                .btn-back {
                    margin-top: 20px;
                    background-color: #6c757d;
                    border: none;
                }

                .btn-back:hover {
                    background-color: #5a6268;
                }
            </style>
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
                            <li><a href="/doctor/busy/schedule"><i class="bi bi-person-badge"></i> Gửi lịch
                                    bận</a></li>
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

            <div class="container schedule-container">
                <h2 class="text-center">Lịch làm việc của tôi</h2>
                <div class="table-responsive">
                    <table class="table table-bordered table-hover text-center">
                        <thead>
                            <tr>
                                <th>Ngày</th>
                                <th>Giờ bắt đầu</th>
                                <th>Giờ kết thúc</th>
                                <th>Phòng khám</th>
                                <th>Trạng thái</th>
                                <th>Số BN tối đa</th>
                                <th>Ghi chú</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="schedule" items="${schedules}">
                                <tr>
                                    <td>${schedule.workDate}</td>
                                    <td>${schedule.startTime}</td>
                                    <td>${schedule.endTime}</td>
                                    <td>${schedule.clinicRoom}</td>
                                    <td>
                                        <span class="badge 
                                ${schedule.status == 'Available' ? 'bg-success' :
                                  schedule.status == 'Busy' ? 'bg-warning text-dark' :
                                  schedule.status == 'Done' ? 'bg-danger' :
                                  'bg-secondary'}">
                                            ${schedule.status}
                                        </span>
                                    </td>
                                    <td>${schedule.maxPatients}</td>
                                    <td>${schedule.notes}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div class="text-center">
                    <a href="/doctor/home" class="btn btn-back text-white">← Quay lại</a>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>