<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Admin Dashboard</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
                        rel="stylesheet">
                    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
                    <style>
                        :root {
                            --sidebar-width: 260px;
                            --primary-blue: #4f46e5;
                            --primary-teal: #0ea5e9;
                            --primary-emerald: #059669;
                            --primary-violet: #7c3aed;
                            --success: #10b981;
                            --warning: #f59e0b;
                            --danger: #ef4444;
                            --info: #06b6d4;
                            --light-bg: #fafbfc;
                            --card-bg: #ffffff;
                            --text-primary: #1f2937;
                            --text-secondary: #6b7280;
                            --border-light: rgba(226, 232, 240, 0.8);
                        }

                        body {
                            background: linear-gradient(135deg, #f0f4f8 0%, #e2e8f0 25%, #f7fafc 50%, #edf2f7 75%, #f0f4f8 100%);
                            font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                            min-height: 100vh;
                            color: var(--text-primary);
                        }

                        .sidebar {
                            width: var(--sidebar-width);
                            position: fixed;
                            top: 0;
                            left: 0;
                            height: 100vh;
                            background: linear-gradient(180deg, #334155 0%, #1e293b 100%);
                            padding: 25px 20px;
                            color: white;
                            transition: all 0.3s ease;
                            box-shadow: 4px 0 20px rgba(0, 0, 0, 0.15);
                            border-right: none;
                        }

                        .sidebar-header {
                            padding: 20px 0 30px 0;
                            text-align: center;
                            border-bottom: 2px solid rgba(255, 255, 255, 0.1);
                            margin-bottom: 20px;
                        }

                        .sidebar-header h3 {
                            background: linear-gradient(45deg, #06b6d4, #0ea5e9);
                            -webkit-background-clip: text;
                            -webkit-text-fill-color: transparent;
                            font-weight: 700;
                            font-size: 1.5rem;
                            margin: 0;
                        }

                        .sidebar-menu {
                            list-style: none;
                            padding: 0;
                            margin-top: 20px;
                        }

                        .sidebar-menu li {
                            margin-bottom: 8px;
                        }

                        .sidebar-menu a {
                            color: #e2e8f0;
                            text-decoration: none;
                            display: flex;
                            align-items: center;
                            gap: 12px;
                            padding: 14px 18px;
                            border-radius: 12px;
                            transition: all 0.3s ease;
                            font-weight: 600;
                            position: relative;
                        }

                        .sidebar-menu a i {
                            font-size: 1.1rem;
                            width: 20px;
                            text-align: center;
                        }

                        .sidebar-menu a:hover {
                            background: rgba(255, 255, 255, 0.1);
                            color: white;
                            transform: translateX(4px);
                        }

                        .sidebar-menu a.active {
                            background: linear-gradient(135deg, var(--primary-blue), var(--primary-teal));
                            color: white;
                            box-shadow: 0 6px 20px rgba(79, 70, 229, 0.3);
                        }

                        .main-content {
                            margin-left: var(--sidebar-width);
                            padding: 25px;
                            min-height: 100vh;
                        }

                        .dashboard-header {
                            background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
                            backdrop-filter: blur(20px);
                            border-radius: 20px;
                            padding: 30px;
                            margin-bottom: 30px;
                            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
                            border: 1px solid var(--border-light);
                        }

                        .dashboard-header h2 {
                            background: linear-gradient(45deg, var(--primary-blue), var(--primary-violet));
                            -webkit-background-clip: text;
                            -webkit-text-fill-color: transparent;
                            font-weight: 700;
                            margin: 0;
                            font-size: 2rem;
                        }

                        .filter-group {
                            margin-top: 25px;
                        }

                        .filter-group .btn {
                            border-radius: 30px;
                            padding: 12px 28px;
                            font-weight: 600;
                            margin-right: 12px;
                            border: 2px solid transparent;
                            transition: all 0.3s ease;
                            position: relative;
                            font-size: 0.95rem;
                        }

                        .filter-group .btn-primary {
                            background: linear-gradient(45deg, var(--primary-blue), var(--primary-teal));
                            color: white;
                            box-shadow: 0 6px 20px rgba(79, 70, 229, 0.3);
                            transform: translateY(-2px);
                            border: 2px solid transparent;
                        }

                        .filter-group .btn-outline-primary {
                            background: white;
                            color: var(--primary-blue);
                            border: 2px solid var(--primary-blue);
                        }

                        .filter-group .btn-outline-primary:hover {
                            background: linear-gradient(45deg, var(--primary-blue), var(--primary-teal));
                            color: white;
                            transform: translateY(-2px);
                            box-shadow: 0 6px 20px rgba(79, 70, 229, 0.3);
                            border: 2px solid transparent;
                        }

                        .dashboard-card {
                            border: none;
                            border-radius: 18px;
                            box-shadow: 0 4px 25px rgba(0, 0, 0, 0.06);
                            transition: transform 0.3s ease, box-shadow 0.3s ease;
                            background: var(--card-bg);
                            color: var(--text-primary);
                            border: 1px solid var(--border-light);
                            overflow: hidden;
                        }

                        .dashboard-card:hover {
                            transform: translateY(-5px);
                            box-shadow: 0 8px 35px rgba(0, 0, 0, 0.12);
                        }

                        .chart-card {
                            border: none;
                            border-radius: 18px;
                            box-shadow: 0 4px 25px rgba(0, 0, 0, 0.06);
                            background: var(--card-bg);
                            overflow: hidden;
                            border: 1px solid var(--border-light);
                        }

                        .chart-card .card-header {
                            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
                            color: var(--text-primary);
                            border: none;
                            padding: 25px;
                            font-weight: 600;
                            font-size: 1.2rem;
                            border-bottom: 1px solid var(--border-light);
                        }

                        .chart-container {
                            position: relative;
                            height: 400px;
                            padding: 25px;
                        }

                        .stats-number {
                            font-size: 2.8rem;
                            font-weight: 700;
                            margin: 10px 0;
                        }

                        .stats-label {
                            font-size: 1.1rem;
                            opacity: 0.8;
                            margin: 0;
                            font-weight: 500;
                        }

                        .revenue-card {
                            background: linear-gradient(135deg, #fef7ff 0%, #f3e8ff 100%);
                            border-left: 5px solid #a855f7;
                        }

                        .revenue-card .fas {
                            color: #a855f7;
                            font-size: 2.5rem;
                        }

                        .appointment-card {
                            background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%);
                            border-left: 5px solid #ef4444;
                        }

                        .appointment-card .fas {
                            color: #ef4444;
                            font-size: 2.5rem;
                        }

                        .patient-card {
                            background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
                            border-left: 5px solid #3b82f6;
                        }

                        .patient-card .fas {
                            color: #3b82f6;
                            font-size: 2.5rem;
                        }

                        .page-title {
                            color: var(--text-primary);
                            font-weight: 700;
                            margin-bottom: 30px;
                            text-align: center;
                            font-size: 1.8rem;
                        }

                        .status-legend {
                            display: flex;
                            justify-content: center;
                            flex-wrap: wrap;
                            gap: 15px;
                            margin-top: 20px;
                        }

                        .legend-item {
                            display: flex;
                            align-items: center;
                            gap: 10px;
                            padding: 10px 16px;
                            background: white;
                            border-radius: 25px;
                            font-size: 0.95rem;
                            font-weight: 500;
                            border: 1px solid var(--border-light);
                            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
                        }

                        .legend-color {
                            width: 14px;
                            height: 14px;
                            border-radius: 50%;
                        }

                        .doctor-revenue-card .card-header {
                            background: linear-gradient(135deg, #10b981 0%, #059669 100%) !important;
                            color: white !important;
                            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
                        }

                        .doctor-avatar {
                            width: 40px;
                            height: 40px;
                            background: #e0f2fe;
                            border-radius: 50%;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                        }

                        .doctor-avatar i {
                            font-size: 20px;
                            color: var(--primary-teal);
                        }

                        .doctor-name {
                            font-weight: 600;
                            color: var(--text-primary);
                        }

                        .table> :not(caption)>*>* {
                            padding: 18px 15px;
                            border-color: var(--border-light);
                        }

                        .table thead th {
                            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
                            color: var(--text-primary);
                            font-weight: 600;
                            border-bottom: 2px solid var(--border-light);
                        }

                        .badge {
                            padding: 10px 18px;
                            font-size: 0.9rem;
                            border-radius: 20px;
                        }

                        .d-flex.justify-content-between.align-items-center.mb-4 {
                            background: white;
                            padding: 20px 25px;
                            border-radius: 15px;
                            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
                            border: 1px solid var(--border-light);
                        }

                        .d-flex.justify-content-between.align-items-center.mb-4 h2 {
                            background: linear-gradient(45deg, var(--primary-blue), var(--primary-teal));
                            -webkit-background-clip: text;
                            -webkit-text-fill-color: transparent;
                            font-weight: 700;
                            margin: 0;
                        }

                        .dropdown-toggle {
                            border-radius: 25px !important;
                            padding: 10px 20px !important;
                            font-weight: 500 !important;
                            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%) !important;
                            border: 1px solid var(--border-light) !important;
                            color: var(--text-primary) !important;
                        }

                        .dropdown-menu {
                            border-radius: 12px !important;
                            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1) !important;
                            border: 1px solid var(--border-light) !important;
                        }

                        @media (max-width: 768px) {
                            .sidebar {
                                margin-left: calc(-1 * var(--sidebar-width));
                            }

                            @media (max-width: 768px) {
                                .sidebar {
                                    margin-left: calc(-1 * var(--sidebar-width));
                                }

                                .sidebar.active {
                                    margin-left: 0;
                                }

                                .main-content {
                                    margin-left: 0;
                                    padding: 15px;
                                }

                                .filter-group .btn {
                                    margin-bottom: 10px;
                                    width: 100%;
                                }

                                .dashboard-header {
                                    padding: 20px;
                                }

                                .stats-number {
                                    font-size: 2.2rem;
                                }
                            }
                        }
                    </style>
                </head>

                <body>
                    <!-- Sidebar -->
                    <nav class="sidebar">
                        <div class="sidebar-header">
                            <h3>Admin Panel</h3>
                        </div>
                        <ul class="sidebar-menu">
                            <li><a href="#" class="active"><i class="fas fa-home"></i> Dashboard</a></li>
                            <li><a href="/admin/user"><i class="fas fa-users"></i> Users</a></li>
                            <li><a href="/admin/schedules/processing"><i class="fas fa-calendar-check"></i> Phê duyệt
                                    lịch bận</a></li>
                            <li><a href="/admin/schedules/doctors"><i class="fas fa-user-md"></i> Lịch Bác Sĩ</a></li>
                            <li><a href="/feedback/list"><i class="fas fa-user-md"></i> Quản lí feedback</a></li>
                            <li><a href="/booking-receptionist/step-1"><i class="fas fa-user-md"></i> Đặt Lịch</a>
                            </li>
                            <li><a href="/admin"><i class="fas fa-sign-out-alt"></i> Home Page</a></li>
                        </ul>
                    </nav>

                    <div class="main-content">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2>Dashboard</h2>
                            <div class="dropdown">
                                <button class="btn btn-light dropdown-toggle" type="button" id="userDropdown"
                                    data-bs-toggle="dropdown">
                                    <i class="fas fa-user-circle"></i> Admin
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li><a class="dropdown-item" href="#"><i class="fas fa-user"></i> Profile</a></li>
                                    <li><a class="dropdown-item" href="#"><i class="fas fa-cog"></i> Settings</a></li>
                                    <li>
                                        <hr class="dropdown-divider">
                                    </li>
                                    <li><a class="dropdown-item" href="/logout"><i class="fas fa-sign-out-alt"></i>
                                            Logout</a></li>
                                </ul>
                            </div>
                        </div>

                        <div class="dashboard-header">
                            <h2>Thống Kê Y Tế</h2>
                            <div class="filter-group">
                                <div class="d-flex gap-2">
                                    <button class="btn btn-outline-primary filter-btn" data-filter="day">Theo
                                        Ngày</button>
                                    <button class="btn btn-outline-primary filter-btn" data-filter="week">Theo
                                        Tuần</button>
                                    <button class="btn btn-outline-primary filter-btn" data-filter="month">Theo
                                        Tháng</button>
                                </div>
                            </div>
                        </div>

                        <div class="container mt-4">
                            <h2 class="page-title">
                                <i class="fas fa-chart-line me-3"></i>
                                <span id="stats-title">Thống Kê Theo Ngày</span>
                            </h2>

                            <c:if test="${not empty error}">
                                <div class="alert alert-danger" role="alert" id="error-message">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    ${error}
                                </div>
                            </c:if>

                            <div class="row mb-5">
                                <div class="col-md-4 mb-4">
                                    <div class="card dashboard-card patient-card">
                                        <div class="card-body text-center">
                                            <i class="fas fa-users fa-2x mb-3"></i>
                                            <h5 class="stats-label">Tổng số bệnh nhân</h5>
                                            <p class="stats-number" id="total-patients">
                                                <fmt:formatNumber value="${totalPatients}" type="number" />
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4 mb-4">
                                    <div class="card dashboard-card appointment-card">
                                        <div class="card-body text-center">
                                            <i class="fas fa-calendar-check fa-2x mb-3"></i>
                                            <h5 class="stats-label">Tổng số cuộc hẹn</h5>
                                            <p class="stats-number" id="total-appointments">
                                                <fmt:formatNumber value="${totalAppointments}" type="number" />
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4 mb-4">
                                    <div class="card dashboard-card revenue-card">
                                        <div class="card-body text-center">
                                            <i class="fas fa-money-bill-wave fa-2x mb-3"></i>
                                            <h5 class="stats-label">Tổng doanh thu</h5>
                                            <p class="stats-number" id="total-revenue">
                                                <fmt:formatNumber value="${totalRevenue}" type="currency"
                                                    currencySymbol="VNĐ" />
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-lg-8 mb-4">
                                    <div class="card chart-card">
                                        <div class="card-header">
                                            <i class="fas fa-chart-bar me-2"></i>
                                            <span id="chart-title">Thống Kê Doanh Thu & Lượt Khám (7 ngày gần
                                                nhất)</span>
                                        </div>
                                        <div class="chart-container">
                                            <canvas id="combinedChart"></canvas>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-4 mb-4">
                                    <div class="card chart-card" style="height: 460px;">
                                        <div class="card-header">
                                            <i class="fas fa-chart-pie me-2"></i>
                                            Tỷ lệ trạng thái cuộc hẹn
                                        </div>
                                        <div class="chart-container" style="height: 380px;">
                                            <canvas id="statusChart"></canvas>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row mt-4">
                                <div class="col-lg-12">
                                    <div class="card chart-card doctor-revenue-card shadow-sm">
                                        <div class="card-header bg-primary text-white">
                                            <i class="fas fa-money-bill-wave me-2"></i>
                                            <span class="fw-bold" id="doctor-revenue-title">Doanh Thu Bác Sĩ</span>
                                        </div>
                                        <div class="card-body">
                                            <div class="table-responsive">
                                                <table class="table table-hover table-striped align-middle"
                                                    id="doctor-revenue-table">
                                                    <thead class="table-light">
                                                        <tr class="text-center">
                                                            <th width="5%">STT</th>
                                                            <th width="30%">Bác Sĩ</th>
                                                            <th width="20%">Phí Khám</th>
                                                            <th width="20%">Số Lượt Khám</th>
                                                            <th width="25%">Tổng Doanh Thu</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach items="${doctorRevenue}" var="revenue"
                                                            varStatus="status">
                                                            <tr class="text-center">
                                                                <td>${status.index + 1}</td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${not empty revenue.doctor and not empty revenue.doctor.user}">
                                                                            ${revenue.doctor.user.fullName}
                                                                        </c:when>
                                                                        <c:when test="${not empty revenue.doctorName}">
                                                                            ${revenue.doctorName}
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            ${revenue.doctor.user.firstName}
                                                                            ${revenue.doctor.user.lastName}
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <fmt:formatNumber value="${revenue.fee}"
                                                                        type="currency" currencySymbol="VND"
                                                                        maxFractionDigits="0" />
                                                                </td>
                                                                <td>${revenue.totalExaminations}</td>
                                                                <td>
                                                                    <fmt:formatNumber value="${revenue.totalRevenue}"
                                                                        type="currency" currencySymbol="VND"
                                                                        maxFractionDigits="0" />
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                        <c:if test="${empty doctorRevenue}">
                                                            <tr>
                                                                <td colspan="5" class="text-center">Không có dữ liệu
                                                                </td>
                                                            </tr>
                                                        </c:if>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
                    <script>
                        let combinedChartInstance = null;
                        let statusChartInstance = null;

                        function updateDashboard(filter) {
                            const now = new Date();
                            let startDate, endDate, chartStart;

                            switch (filter) {
                                case 'week':
                                    startDate = new Date(now.setDate(now.getDate() - now.getDay() + (now.getDay() === 0 ? -6 : 1)));
                                    startDate.setHours(0, 0, 0, 0);
                                    endDate = new Date(startDate);
                                    endDate.setDate(startDate.getDate() + 6);
                                    endDate.setHours(23, 59, 59, 999);
                                    chartStart = new Date(now.setDate(now.getDate() - 6));
                                    break;
                                case 'month':
                                    startDate = new Date(now.getFullYear(), now.getMonth(), 1);
                                    endDate = new Date(now.getFullYear(), now.getMonth() + 1, 0, 23, 59, 59, 999);
                                    chartStart = new Date(now.getFullYear(), now.getMonth() - 5, 1);
                                    break;
                                case 'day':
                                default:
                                    startDate = new Date(now.setHours(0, 0, 0, 0));
                                    endDate = new Date(now.setHours(23, 59, 59, 999));
                                    chartStart = new Date(now.setDate(now.getDate() - 6));
                                    break;
                            }

                            $.ajax({
                                url: '/admin/dashboard/overview',
                                method: 'GET',
                                data: {
                                    filter: filter,
                                    startDate: startDate.toISOString(),
                                    endDate: endDate.toISOString()
                                },
                                success: function (data) {
                                    $('#error-message').remove();
                                    $('#total-patients').text(new Intl.NumberFormat('vi-VN').format(data.totalPatients || 0));
                                    $('#total-appointments').text(new Intl.NumberFormat('vi-VN').format(data.totalAppointments || 0));
                                    $('#total-revenue').text(new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(data.totalRevenue || 0));

                                    $('#stats-title').text(filter === 'day' ? 'Thống Kê Theo Ngày' : filter === 'week' ? 'Thống Kê Theo Tuần' : 'Thống Kê Theo Tháng');
                                    $('#chart-title').text(filter === 'day' ? 'Thống Kê Doanh Thu & Lượt Khám (7 ngày gần nhất)' :
                                        filter === 'week' ? 'Thống Kê Doanh Thu & Lượt Khám (Tuần hiện tại)' :
                                            'Thống Kê Doanh Thu & Lượt Khám (6 tháng gần nhất)');

                                    // Update the doctor revenue title based on filter
                                    const titleMap = {
                                        'day': 'Doanh Thu Bác Sĩ Hôm Nay',
                                        'week': 'Doanh Thu Bác Sĩ Tuần Này',
                                        'month': 'Doanh Thu Bác Sĩ Tháng Này'
                                    };
                                    $('#doctor-revenue-title').text(titleMap[filter] || 'Doanh Thu Bác Sĩ');

                                    let dailyStats = [];
                                    $.ajax({
                                        url: '/admin/dashboard/' + (filter === 'month' ? 'monthly-stats' : 'daily-stats'),
                                        method: 'GET',
                                        data: {
                                            startDate: chartStart.toISOString(),
                                            endDate: endDate.toISOString()
                                        },
                                        success: function (statsData) {
                                            dailyStats = statsData || [];
                                            updateCharts(dailyStats, data, filter);
                                        },
                                        error: function (xhr, status, error) {
                                            console.error('Error fetching stats:', error);
                                            showError('Có lỗi xảy ra khi tải dữ liệu thống kê chi tiết');
                                            updateCharts([], data, filter);
                                        }
                                    });
                                },
                                error: function (xhr, status, error) {
                                    console.error('Error fetching overview:', error);
                                    showError('Có lỗi xảy ra khi tải dữ liệu tổng quan');
                                    resetDashboard();
                                }
                            });
                        }

                        function showError(message) {
                            $('#error-message').remove();
                            $('.container').prepend(`
                <div id="error-message" class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            `);
                        }

                        function resetDashboard() {
                            $('#total-patients').text('0');
                            $('#total-appointments').text('0');
                            $('#total-revenue').text('0 VNĐ');
                            $('#doctor-revenue-table').html(`
                <tr>
                    <td colspan="4" class="text-center py-4">
                        <div class="alert alert-info mb-0">
                            <i class="fas fa-info-circle me-2"></i>
                            Không có dữ liệu doanh thu.
                        </div>
                    </td>
                </tr>
            `);
                            if (combinedChartInstance) combinedChartInstance.destroy();
                            if (statusChartInstance) statusChartInstance.destroy();
                        }

                        function updateCharts(dailyStats, overviewData, filter) {
                            const dates = dailyStats.map((item, index) => {
                                try {
                                    if (filter === 'month' && item && item.yearMonth) {
                                        const date = new Date(item.yearMonth);
                                        return isNaN(date.getTime()) ? `Tháng ${index + 1}` : date.toLocaleDateString('vi-VN', { month: 'short', year: 'numeric' });
                                    } else if (item && item.date) {
                                        const date = new Date(item.date);
                                        return isNaN(date.getTime()) ? `Ngày ${index + 1}` : date.toLocaleDateString('vi-VN', { weekday: 'short', day: '2-digit', month: '2-digit' });
                                    }
                                    return filter === 'month' ? `Tháng ${index + 1}` : `Ngày ${index + 1}`;
                                } catch (e) {
                                    console.warn(`Error processing date at index ${index}:`, e);
                                    return filter === 'month' ? `Tháng ${index + 1}` : `Ngày ${index + 1}`;
                                }
                            });

                            const appointments = dailyStats.map(item => item?.appointmentCount || 0);
                            const revenues = dailyStats.map(item => item?.totalRevenue || 0);

                            updateCombinedChart(dates, appointments, revenues);
                            updateStatusChart(overviewData.statusDistribution || {});
                            updateDoctorRevenueTable(overviewData.doctorRevenue || []);
                        }

                        function updateCombinedChart(labels, appointments, revenues) {
                            if (combinedChartInstance) combinedChartInstance.destroy();
                            const combinedCtx = document.getElementById('combinedChart')?.getContext('2d');
                            if (combinedCtx) {
                                combinedChartInstance = new Chart(combinedCtx, {
                                    type: 'line',
                                    data: {
                                        labels: labels.length > 0 ? labels : ['Không có dữ liệu'],
                                        datasets: [{
                                            label: 'Doanh Thu (Triệu VNĐ)',
                                            data: revenues.map(r => r / 1000000),
                                            backgroundColor: 'rgba(96, 165, 250, 0.3)',
                                            borderColor: 'rgba(96, 165, 250, 1)',
                                            borderWidth: 3,
                                            tension: 0.4,
                                            fill: true,
                                            pointBackgroundColor: 'rgba(96, 165, 250, 1)',
                                            pointBorderColor: '#fff',
                                            pointBorderWidth: 2,
                                            pointRadius: 5,
                                            yAxisID: 'y'
                                        }, {
                                            label: 'Lượt Khám',
                                            data: appointments,
                                            backgroundColor: 'rgba(192, 132, 252, 0.3)',
                                            borderColor: 'rgba(192, 132, 252, 1)',
                                            borderWidth: 3,
                                            tension: 0.4,
                                            fill: true,
                                            pointBackgroundColor: 'rgba(192, 132, 252, 1)',
                                            pointBorderColor: '#fff',
                                            pointBorderWidth: 2,
                                            pointRadius: 5,
                                            yAxisID: 'y1'
                                        }]
                                    },
                                    options: {
                                        responsive: true,
                                        maintainAspectRatio: false,
                                        interaction: { mode: 'index', intersect: false },
                                        plugins: {
                                            legend: {
                                                position: 'top',
                                                labels: { usePointStyle: true, padding: 20, font: { size: 12, weight: '500' } }
                                            },
                                            tooltip: {
                                                backgroundColor: 'rgba(0, 0, 0, 0.8)',
                                                titleColor: '#fff',
                                                bodyColor: '#fff',
                                                borderColor: 'rgba(96, 165, 250, 1)',
                                                borderWidth: 1,
                                                cornerRadius: 8,
                                                displayColors: true,
                                                callbacks: {
                                                    label: function (context) {
                                                        let label = context.dataset.label || '';
                                                        if (label) label += ': ';
                                                        if (context.datasetIndex === 0) {
                                                            label += new Intl.NumberFormat('vi-VN').format(context.parsed.y) + ' triệu VNĐ';
                                                        } else {
                                                            label += context.parsed.y + ' lượt';
                                                        }
                                                        return label;
                                                    }
                                                }
                                            }
                                        },
                                        scales: {
                                            x: {
                                                grid: { display: true, color: 'rgba(0, 0, 0, 0.05)', lineWidth: 1 },
                                                ticks: { font: { size: 11, weight: '500' } }
                                            },
                                            y: {
                                                type: 'linear',
                                                display: true,
                                                position: 'left',
                                                beginAtZero: true,
                                                ticks: {
                                                    callback: function (value) { return new Intl.NumberFormat('vi-VN').format(value); },
                                                    font: { size: 11 }
                                                },
                                                grid: { display: true, color: 'rgba(0, 0, 0, 0.08)', lineWidth: 1 },
                                                title: { display: true, text: 'Doanh Thu (Triệu VNĐ)', font: { size: 12, weight: '600' }, color: 'rgba(96, 165, 250, 1)' }
                                            },
                                            y1: {
                                                type: 'linear',
                                                display: true,
                                                position: 'right',
                                                beginAtZero: true,
                                                grid: { display: false },
                                                ticks: { stepSize: 1, font: { size: 11 } },
                                                title: { display: true, text: 'Lượt Khám', font: { size: 12, weight: '600' }, color: 'rgba(192, 132, 252, 1)' }
                                            }
                                        }
                                    }
                                });
                            }
                        }

                        function updateStatusChart(statusData) {
                            if (statusChartInstance) {
                                statusChartInstance.destroy();
                            }

                            const statusColors = {
                                'Pending': '#ffc107',    // Vàng - đang chờ
                                'Confirmed': '#17a2b8',  // Xanh dương - đã xác nhận
                                'Completed': '#28a745',  // Xanh lá - hoàn thành
                                'Cancelled': '#dc3545',  // Đỏ - đã hủy
                                'Rejected': '#6c757d'    // Xám - từ chối
                            };

                            const statusLabels = {
                                'Pending': 'Đang chờ',
                                'Confirmed': 'Đã xác nhận',
                                'Completed': 'Hoàn thành',
                                'Cancelled': 'Đã hủy',
                                'Rejected': 'Từ chối'
                            };

                            const ctx = document.getElementById('statusChart').getContext('2d');

                            // Tính tổng số cuộc hẹn
                            const total = Object.values(statusData).reduce((sum, count) => sum + (count || 0), 0);

                            // Chuẩn bị dữ liệu cho biểu đồ
                            const labels = [];
                            const data = [];
                            const colors = [];

                            // Thứ tự hiển thị cố định
                            const statusOrder = ['Pending', 'Confirmed', 'Completed', 'Cancelled', 'Rejected'];

                            statusOrder.forEach(status => {
                                const count = statusData[status] || 0;
                                labels.push(statusLabels[status]);
                                data.push(count);
                                colors.push(statusColors[status]);
                            });

                            statusChartInstance = new Chart(ctx, {
                                type: 'doughnut',
                                data: {
                                    labels: labels,
                                    datasets: [{
                                        data: data,
                                        backgroundColor: colors,
                                        borderWidth: 2,
                                        borderColor: '#ffffff'
                                    }]
                                },
                                options: {
                                    responsive: true,
                                    maintainAspectRatio: false,
                                    plugins: {
                                        legend: {
                                            position: 'bottom',
                                            labels: {
                                                padding: 20,
                                                usePointStyle: true,
                                                font: {
                                                    size: 12,
                                                    weight: '600'
                                                }
                                            }
                                        },
                                        tooltip: {
                                            callbacks: {
                                                label: function (context) {
                                                    const value = context.raw;
                                                    const percentage = total > 0 ? ((value / total) * 100).toFixed(1) : 0;
                                                    return `${context.label}: ${value} (${percentage}%)`;
                                                }
                                            }
                                        }
                                    },
                                    cutout: '60%'
                                }
                            });
                        }

                        function updateDoctorRevenueTable(doctorRevenue) {
                            const tbody = $('#doctor-revenue-table tbody');
                            tbody.empty();

                            if (doctorRevenue && doctorRevenue.length > 0) {
                                doctorRevenue.forEach((revenue, index) => {
                                    const row = $('<tr>').addClass('text-center');
                                    row.append($('<td>').text(index + 1));

                                    // Handle doctor name display
                                    let doctorName = 'N/A';
                                    if (revenue.doctor && revenue.doctor.user) {
                                        doctorName = revenue.doctor.user.fullName || `${revenue.doctor.user.firstName} ${revenue.doctor.user.lastName}`;
                                    } else if (revenue.doctorName) {
                                        doctorName = revenue.doctorName;
                                    }
                                    row.append($('<td>').text(doctorName));

                                    row.append($('<td>').text(formatCurrency(revenue.fee)));
                                    row.append($('<td>').text(revenue.totalExaminations));
                                    row.append($('<td>').text(formatCurrency(revenue.totalRevenue)));
                                    tbody.append(row);
                                });
                            } else {
                                tbody.append(
                                    $('<tr>').append(
                                        $('<td>')
                                            .attr('colspan', '5')
                                            .addClass('text-center')
                                            .text('Không có dữ liệu')
                                    )
                                );
                            }
                        }

                        function formatCurrency(amount) {
                            return new Intl.NumberFormat('vi-VN', {
                                style: 'currency',
                                currency: 'VND',
                                maximumFractionDigits: 0
                            }).format(amount);
                        }

                        $(document).ready(function () {
                            $('.filter-btn').click(function () {
                                $('.filter-btn').removeClass('btn-primary').addClass('btn-outline-primary');
                                $(this).removeClass('btn-outline-primary').addClass('btn-primary');
                                const filter = $(this).data('filter');
                                updateDashboard(filter);
                            });

                            // Initial load with server-side data as fallback
                            updateDashboard('${filter}');
                        });

                        function viewInvoiceDetails(invoiceId) {
                            if (!invoiceId) {
                                alert('ID hóa đơn không hợp lệ!');
                                return;
                            }
                            try {
                                window.location.href = '${pageContext.request.contextPath}/admin/invoices/details/' + invoiceId;
                            } catch (error) {
                                console.error('Error navigating to invoice details:', error);
                                alert('Có lỗi xảy ra khi xem chi tiết hóa đơn. Vui lòng thử lại sau.');
                            }
                        }

                        function sendInvoiceNotification(invoiceId) {
                            if (!invoiceId) {
                                alert('ID hóa đơn không hợp lệ!');
                                return;
                            }
                            try {
                                const csrfToken = document.querySelector('meta[name="_csrf"]')?.getAttribute('content');
                                fetch('${pageContext.request.contextPath}/admin/invoices/notify/' + invoiceId, {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/json',
                                        'X-CSRF-TOKEN': csrfToken || ''
                                    }
                                })
                                    .then(response => {
                                        if (!response.ok) throw new Error('Network response was not ok');
                                        return response.json();
                                    })
                                    .then(data => {
                                        alert('Đã gửi thông báo thành công!');
                                    })
                                    .catch(error => {
                                        console.error('Error:', error);
                                        alert('Có lỗi xảy ra khi gửi thông báo. Vui lòng thử lại sau.');
                                    });
                            } catch (error) {
                                console.error('Error sending notification:', error);
                                alert('Có lỗi xảy ra khi gửi thông báo. Vui lòng thử lại sau.');
                            }
                        }
                    </script>
                </body>

                </html>