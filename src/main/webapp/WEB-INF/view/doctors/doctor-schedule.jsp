<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Lịch làm việc</title>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css">
            <link rel="stylesheet" href="/css/homepage.css">
            <link rel="stylesheet"
                href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <style>
                .schedule-container {
                    margin-top: 50px;
                    background: white;
                    padding: 30px;
                    border-radius: 16px;
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
                }

                .view-toggle-container {
                    margin-bottom: 20px;
                    text-align: right;
                }

                #calendar {
                    margin-top: 20px;
                }

                .table-view {
                    display: none;
                }

                .calendar-view {
                    display: block;
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
                    background-color: #6c757d;
                    border: none;
                }

                .btn-back:hover {
                    background-color: #5a6268;
                }

                .fc-event {
                    cursor: pointer;
                }

                .fc-event-title {
                    font-weight: bold;
                }

                .fc-toolbar-title {
                    font-size: 1.5em !important;
                    font-weight: 600;
                }

                /* Dropdown styles */
                .dropdown-menu {
                    display: none;
                    position: absolute;
                    top: 100%;
                    right: 0;
                    background: white;
                    border: 1px solid #ddd;
                    border-radius: 8px;
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                    min-width: 200px;
                    z-index: 1000;
                }

                .dropdown-menu.show {
                    display: block;
                }

                .dropdown-item {
                    display: block;
                    padding: 10px 15px;
                    color: #333;
                    text-decoration: none;
                    transition: background-color 0.2s;
                }

                .dropdown-item:hover {
                    background-color: #f8f9fa;
                    color: #333;
                    text-decoration: none;
                }

                .dropdown-divider {
                    margin: 0.5rem 0;
                    border-top: 1px solid #e9ecef;
                }

                .dropdown {
                    position: relative;
                }

                .profile-btn:hover {
                    background-color: #f8f9fa;
                }

                /* Mobile menu styles */
                .nav-links.active {
                    display: flex !important;
                }

                @media (max-width: 768px) {
                    .nav-links {
                        display: none;
                        flex-direction: column;
                        position: absolute;
                        top: 100%;
                        left: 0;
                        right: 0;
                        background: white;
                        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                        z-index: 1000;
                    }

                    .nav-links.active {
                        display: flex !important;
                    }

                    .nav-links li {
                        padding: 10px 20px;
                        border-bottom: 1px solid #eee;
                    }

                    .nav-links li:last-child {
                        border-bottom: none;
                    }
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
                            <li><a href="/feedback/list"><i class="bi bi-person-badge"></i> Feedback</a></li>
                            <li><a href="/doctor/schedules" class="active"><i class="bi bi-clipboard2-pulse"></i> Xem
                                    lịch làm việc</a>
                            </li>
                            <li><a href="<c:url value='/doctor/appointments' />"><i class="bi bi-calendar-check"></i>
                                    Lịch hẹn</a></li>
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

                <!-- Hidden inputs for schedule data -->
                <c:forEach var="schedule" items="${schedules}">
                    <input type="hidden" class="schedule-data" data-room="${schedule.clinicRoom}"
                        data-date="${schedule.workDate}" data-start="${schedule.startTime}"
                        data-end="${schedule.endTime}" data-status="${schedule.status}"
                        data-max-patients="${schedule.maxPatients}" data-notes="${schedule.notes}">
                </c:forEach>

                <div class="view-toggle-container">
                    <div class="btn-group" role="group">
                        <button type="button" class="btn btn-primary" id="calendarViewBtn">Xem lịch</button>
                        <button type="button" class="btn btn-outline-primary" id="tableViewBtn">Xem bảng</button>
                    </div>
                </div>

                <div id="calendar" class="calendar-view"></div>

                <div class="table-view">
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
                </div>

                <div class="text-center mt-4">
                    <a href="/doctor/home" class="btn btn-back text-white">← Quay lại</a>
                    <a href="/doctor/busy/schedule" class="btn btn-danger">Xin nghỉ trước</a>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>
            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    // Dropdown functionality
                    const profileDropdownBtn = document.getElementById('profileDropdownBtn');
                    const profileDropdown = document.getElementById('profileDropdown');

                    if (profileDropdownBtn && profileDropdown) {
                        profileDropdownBtn.addEventListener('click', function (e) {
                            e.preventDefault();
                            profileDropdown.classList.toggle('show');
                        });

                        // Close dropdown when clicking outside
                        document.addEventListener('click', function (e) {
                            if (!profileDropdownBtn.contains(e.target) && !profileDropdown.contains(e.target)) {
                                profileDropdown.classList.remove('show');
                            }
                        });
                    }

                    // Mobile menu functionality
                    const mobileMenuBtn = document.getElementById('mobileMenuBtn');
                    const navLinks = document.getElementById('navLinks');

                    if (mobileMenuBtn && navLinks) {
                        mobileMenuBtn.addEventListener('click', function () {
                            navLinks.classList.toggle('active');
                        });
                    }

                    // Parse schedule data from hidden inputs
                    var calendarEvents = [];
                    document.querySelectorAll('.schedule-data').forEach(function (input) {
                        var status = input.dataset.status;
                        var backgroundColor = status === 'Available' ? '#198754' :
                            status === 'Busy' ? '#ffc107' :
                                status === 'Done' ? '#dc3545' : '#6c757d';

                        calendarEvents.push({
                            title: 'Phòng ' + input.dataset.room,
                            start: input.dataset.date + 'T' + input.dataset.start,
                            end: input.dataset.date + 'T' + input.dataset.end,
                            backgroundColor: backgroundColor,
                            extendedProps: {
                                status: status,
                                maxPatients: input.dataset.maxPatients,
                                notes: input.dataset.notes
                            }
                        });
                    });

                    // Initialize FullCalendar
                    var calendarEl = document.getElementById('calendar');
                    var calendar = new FullCalendar.Calendar(calendarEl, {
                        initialView: 'timeGridWeek',
                        headerToolbar: {
                            left: 'prev,next today',
                            center: 'title',
                            right: 'dayGridMonth,timeGridWeek,timeGridDay'
                        },
                        locale: 'vi',
                        slotMinTime: '07:00:00',
                        slotMaxTime: '20:00:00',
                        allDaySlot: false,
                        height: 'auto',
                        events: calendarEvents,
                        eventClick: function (info) {
                            alert(
                                'Thông tin ca khám:\n' +
                                'Phòng: ' + info.event.title + '\n' +
                                'Trạng thái: ' + info.event.extendedProps.status + '\n' +
                                'Số BN tối đa: ' + info.event.extendedProps.maxPatients + '\n' +
                                'Ghi chú: ' + info.event.extendedProps.notes
                            );
                        }
                    });
                    calendar.render();

                    // View toggle functionality
                    const calendarView = document.getElementById('calendar');
                    const tableView = document.querySelector('.table-view');
                    const calendarViewBtn = document.getElementById('calendarViewBtn');
                    const tableViewBtn = document.getElementById('tableViewBtn');

                    calendarViewBtn.addEventListener('click', function () {
                        calendarView.style.display = 'block';
                        tableView.style.display = 'none';
                        calendarViewBtn.classList.add('btn-primary');
                        calendarViewBtn.classList.remove('btn-outline-primary');
                        tableViewBtn.classList.add('btn-outline-primary');
                        tableViewBtn.classList.remove('btn-primary');
                        calendar.render();
                    });

                    tableViewBtn.addEventListener('click', function () {
                        calendarView.style.display = 'none';
                        tableView.style.display = 'block';
                        tableViewBtn.classList.add('btn-primary');
                        tableViewBtn.classList.remove('btn-outline-primary');
                        calendarViewBtn.classList.add('btn-outline-primary');
                        calendarViewBtn.classList.remove('btn-primary');
                    });
                });
            </script>
        </body>

        </html>