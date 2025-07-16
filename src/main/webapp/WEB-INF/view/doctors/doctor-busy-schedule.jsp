<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Gửi lịch bận</title>

            <!-- Bootstrap & Fonts -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
            <link rel="stylesheet" href="/css/homepage.css">


            <style>
                .body {
                    font-family: 'Inter', sans-serif;
                    margin-top: 1.5%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }

                .glass-card {
                    background: rgba(255, 255, 255, 0.9);
                    border-radius: 20px;
                    padding: 40px 30px;
                    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
                    backdrop-filter: blur(10px);
                    width: 100%;
                    max-width: 450px;
                }

                .glass-card h2 {
                    font-weight: 700;
                    color: #4b4b4b;
                    text-align: center;
                    margin-bottom: 30px;
                }

                .form-label {
                    font-weight: 600;
                    color: #333;
                }

                .form-control {
                    border-radius: 12px;
                    padding: 12px;
                }

                .btn-submit {
                    background: linear-gradient(135deg, #6c63ff, #4facfe);
                    border: none;
                    color: white;
                    font-weight: 600;
                    border-radius: 12px;
                    padding: 12px;
                    transition: 0.3s;
                }

                .btn-submit:hover {
                    opacity: 0.9;
                }

                #responseMessage {
                    margin-top: 15px;
                    text-align: center;
                    font-weight: 500;
                }

                .icon-top {
                    font-size: 48px;
                    color: #6c63ff;
                    display: block;
                    text-align: center;
                    margin-bottom: 15px;
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

            <div class="body">

                <div class="glass-card">
                    <i class="bi bi-calendar-check icon-top"></i>
                    <h2>Gửi lịch bận</h2>
                    <form id="busyScheduleForm">
                        <div class="mb-3">
                            <label for="workDate" class="form-label">Ngày làm việc</label>
                            <input type="date" class="form-control" id="workDate" name="workDate" required>
                        </div>
                        <div class="mb-3">
                            <label for="startTime" class="form-label">Thời gian bắt đầu</label>
                            <input type="time" class="form-control" id="startTime" name="startTime" required>
                        </div>
                        <div class="mb-3">
                            <label for="endTime" class="form-label">Thời gian kết thúc</label>
                            <input type="time" class="form-control" id="endTime" name="endTime" required>
                        </div>
                        <button type="submit" class="btn btn-submit w-100 mt-3">Xác nhận</button>
                    </form>
                    <div id="responseMessage"></div>
                    <div class="text-center">
                        <a href="/doctor/home" class="btn btn-back text-white">← Quay lại</a>
                    </div>
                </div>

                <!-- jQuery + AJAX -->
                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <script>
                    $(document).ready(function () {
                        $('#busyScheduleForm').submit(function (e) {
                            e.preventDefault();
                            const formData = {
                                workDate: $('#workDate').val(),
                                startTime: $('#startTime').val(),
                                endTime: $('#endTime').val()
                            };

                            $.ajax({
                                url: '/doctor/busy/submit-busy-schedule',
                                type: 'POST',
                                contentType: 'application/json',
                                data: JSON.stringify(formData),
                                success: function (response) {
                                    $('#responseMessage')
                                        .text(response.message)
                                        .css('color', response.success ? 'green' : 'red');
                                    if (response.success) {
                                        setTimeout(() => location.reload(), 2000);
                                    }
                                },
                                error: function (xhr, status, error) {
                                    $('#responseMessage')
                                        .text('Lỗi: ' + error)
                                        .css('color', 'red');
                                }
                            });
                        });
                    });
                </script>
            </div>

        </body>

        </html>