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
                .header {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    padding: 15px 0;
                    position: fixed;
                    top: 0;
                    left: 0;
                    right: 0;
                    z-index: 1000;
                }

                .nav {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    padding: 0 20px;
                }

                .logo {
                    display: flex;
                    align-items: center;
                    text-decoration: none;
                    color: white;
                    font-weight: 600;
                    font-size: 1.5rem;
                    gap: 10px;
                }

                .logo:hover {
                    color: white;
                    opacity: 0.9;
                }

                .nav-links {
                    display: flex;
                    align-items: center;
                    list-style: none;
                    margin: 0;
                    padding: 0;
                    gap: 20px;
                }

                .nav-links li a {
                    color: white;
                    text-decoration: none;
                    padding: 8px 15px;
                    border-radius: 20px;
                    transition: 0.3s;
                    display: flex;
                    align-items: center;
                    gap: 5px;
                }

                .nav-links li a:hover,
                .nav-links li a.active {
                    background: rgba(255, 255, 255, 0.2);
                }

                .user-menu {
                    display: flex;
                    align-items: center;
                    gap: 15px;
                }

                .notification-btn {
                    background: none;
                    border: none;
                    color: white;
                    font-size: 1.2rem;
                    position: relative;
                    cursor: pointer;
                }

                .notification-badge {
                    position: absolute;
                    top: -5px;
                    right: -5px;
                    background: #ff4757;
                    color: white;
                    border-radius: 50%;
                    padding: 2px 6px;
                    font-size: 0.7rem;
                }

                .profile-btn {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    background: rgba(255, 255, 255, 0.2);
                    border: none;
                    color: white;
                    padding: 8px 15px;
                    border-radius: 20px;
                    cursor: pointer;
                    transition: 0.3s;
                }

                .profile-btn:hover {
                    background: rgba(255, 255, 255, 0.3);
                }

                .dropdown-menu {
                    background: white;
                    border-radius: 12px;
                    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
                    padding: 8px;
                    min-width: 200px;
                }

                .dropdown-item {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    padding: 10px 15px;
                    border-radius: 8px;
                    transition: 0.3s;
                }

                .dropdown-item:hover {
                    background: #f0f0f0;
                }

                .mobile-menu-btn {
                    display: none;
                }

                @media (max-width: 992px) {
                    .mobile-menu-btn {
                        display: block;
                        background: none;
                        border: none;
                        color: white;
                        font-size: 1.5rem;
                    }

                    .nav-links {
                        display: none;
                        position: absolute;
                        top: 100%;
                        left: 0;
                        right: 0;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        flex-direction: column;
                        padding: 20px;
                    }

                    .nav-links.show {
                        display: flex;
                    }
                }

                /* Main content styles */
                .main-content {
                    min-height: 100vh;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    padding: 120px 20px 40px;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                }

                .glass-card {
                    background: rgba(255, 255, 255, 0.9);
                    border-radius: 20px;
                    padding: 40px 30px;
                    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
                    backdrop-filter: blur(10px);
                    width: 100%;
                    max-width: 450px;
                    margin: 0 auto;
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
                    border: 1px solid #ddd;
                }

                .btn-submit {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    border: none;
                    color: white;
                    font-weight: 600;
                    border-radius: 12px;
                    padding: 12px;
                    transition: 0.3s;
                    width: 100%;
                }

                .btn-submit:hover {
                    opacity: 0.9;
                }

                .btn-back {
                    display: inline-block;
                    margin-top: 20px;
                    padding: 10px 20px;
                    background-color: #6c757d;
                    color: white;
                    border-radius: 12px;
                    text-decoration: none;
                    transition: 0.3s;
                }

                .btn-back:hover {
                    background-color: #5a6268;
                    color: white;
                }

                .icon-top {
                    font-size: 48px;
                    color: #667eea;
                    display: block;
                    text-align: center;
                    margin-bottom: 15px;
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

                        <!-- Navigation Links -->
                        <ul class="nav-links">
                            <li><a href="<c:url value='/doctor/home' />"><i class="bi bi-house-door"></i> Trang chủ</a>
                            </li>
                            <li><a href="/doctor/busy/schedule" class="active"><i class="bi bi-person-badge"></i> Gửi
                                    lịch bận</a></li>
                            <li><a href="/doctor/schedules"><i class="bi bi-clipboard2-pulse"></i> Xem lịch làm việc</a>
                            </li>
                            <li><a href="<c:url value='/doctor/appointments' />"><i class="bi bi-calendar-check"></i>
                                    Lịch hẹn</a></li>
                        </ul>

                        <!-- User Menu -->
                        <div class="user-menu">
                            <button class="notification-btn">
                                <i class="bi bi-bell"></i>
                                <span class="notification-badge">2</span>
                            </button>
                            <button class="profile-btn">
                                <i class="bi bi-person-circle"></i>
                                ${currentUser.firstName} ${currentUser.lastName}
                            </button>
                        </div>
                    </nav>
                </div>
            </header>

            <!-- Main Content -->
            <div class="main-content">
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
                        <button type="submit" class="btn btn-submit">Xác nhận</button>
                    </form>
                    <div id="responseMessage" class="mt-3 text-center"></div>
                    <div class="text-center">
                        <a href="/doctor/home" class="btn btn-back">← Quay lại</a>
                    </div>
                </div>
            </div>

            <!-- Scripts -->
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
        </body>

        </html>