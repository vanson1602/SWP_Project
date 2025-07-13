<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
<%!
    private String formatDateTime(LocalDateTime dateTime) {
        if (dateTime == null) return "";
        return dateTime.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="/css/homepage.css">
    <link rel="stylesheet" href="/css/doctor-appointment-details.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <title>HealthCare+ - Chi tiết Lịch hẹn</title>
    <style>
        .prescription-item {
            border: 1px solid #e0e0e0;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 8px;
            background-color: #f9f9f9;
        }
        .prescription-item p {
            margin: 0 0 5px;
        }
        .empty-state {
            text-align: center;
            padding: 20px;
            color: #6c757d;
        }
        .empty-state i {
            font-size: 2rem;
            margin-bottom: 10px;
        }
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1050;
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
                    <li><a href="<c:url value='/doctor/home' />"><i class="bi bi-house-door"></i> Trang chủ</a></li>
                    <li><a href="/doctors"><i class="bi bi-person-badge"></i> Bác sĩ</a></li>
                    <li><a href="/specialties"><i class="bi bi-clipboard2-pulse"></i> Chuyên khoa</a></li>
                    <li><a href="<c:url value='/doctor/appointments' />" class="active"><i class="bi bi-calendar-check"></i> Lịch hẹn</a></li>
                </ul>

                <!-- User Menu -->
                <div class="user-menu">
                    <c:if test="${not empty currentUser}">
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
                                <li><a class="dropdown-item" href="/doctor/profile"><i class="bi bi-person"></i> Trang cá nhân</a></li>
                                <li><a class="dropdown-item" href="/doctor/settings"><i class="bi bi-gear"></i> Cài đặt</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="/doctor/logout"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a></li>
                            </ul>
                        </div>
                    </c:if>
                </div>
            </nav>
        </div>
    </header>

    <!-- Main Content (Merged Details and Actions) -->
    <section class="appointment-details-section">
        <div class="container">
            <div class="details-card">
                <h1 class="page-title">Chi tiết Lịch hẹn</h1>
                <c:if test="${not empty appointment}">
                    <div class="patient-info patient-info-horizontal">
                        <!-- Patient Header: Avatar + Name + Code -->
                        <div class="patient-header-horizontal d-flex align-items-center mb-4">
                            <div class="d-flex align-items-center">
                                <div class="patient-icon-horizontal me-3">
                                    <c:choose>
                                        <c:when test="${not empty appointment.patient.user.avatarUrl}">
                                            <img src="${appointment.patient.user.avatarUrl}" alt="Patient Avatar" class="patient-avatar-horizontal">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="avatar-placeholder-horizontal">
                                                <i class="bi bi-person-circle fs-2 text-primary"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div>
                                    <div class="patient-name-horizontal h2 mb-0 d-flex align-items-center">
                                        <i class="bi bi-person-fill me-2 text-info"></i>
                                        ${appointment.patient.user.firstName} ${appointment.patient.user.lastName}
                                    </div>
                                    <div class="patient-id-horizontal text-muted d-flex align-items-center mt-1">
                                        <i class="bi bi-credit-card-2-front me-1"></i>
                                        Mã BN: <span class="ms-1 fw-semibold">${appointment.patient.patientCode}</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Appointment Status and Number -->
                        <div class="appointment-header d-flex align-items-center flex-wrap gap-3 mb-4">
                            <span class="status-badge-horizontal ${appointment.status == 'Pending' ? 'status-pending' : appointment.status == 'Confirmed' ? 'status-confirmed' : appointment.status == 'Completed' ? 'status-completed' : 'status-cancelled'} d-flex align-items-center">
                                <i class="bi bi-info-circle me-1"></i>
                                <c:choose>
                                    <c:when test="${appointment.status eq 'Pending'}">Chờ khám</c:when>
                                    <c:when test="${appointment.status eq 'Confirmed'}">Đã xác nhận</c:when>
                                    <c:when test="${appointment.status eq 'Completed'}">Đã khám</c:when>
                                    <c:when test="${appointment.status eq 'Cancelled'}">Đã hủy</c:when>
                                    <c:otherwise>${appointment.status}</c:otherwise>
                                </c:choose>
                            </span>
                            <span class="appointment-number-horizontal d-flex align-items-center">
                                <i class="bi bi-bookmark-check me-1"></i>
                                <span class="fw-semibold">Mã lịch hẹn:</span> <span class="ms-1">${appointment.appointmentNumber}</span>
                            </span>
                        </div>

                        <!-- Patient Details Row -->
                        <div class="patient-details-row mt-3">
                            <div class="row g-3">
                                <div class="col-12 col-md-6 col-lg-3">
                                    <div class="info-label-horizontal d-flex align-items-center">
                                        <i class="bi bi-gender-ambiguous me-1 text-secondary"></i> Giới tính
                                    </div>
                                    <div class="info-value-horizontal">
                                        <c:choose>
                                            <c:when test="${not empty appointment.patient.user.gender}">
                                                <c:choose>
                                                    <c:when test="${appointment.patient.user.gender eq 'Male'}">Nam</c:when>
                                                    <c:when test="${appointment.patient.user.gender eq 'Female'}">Nữ</c:when>
                                                    <c:otherwise>Khác</c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Chưa cập nhật</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="col-12 col-md-6 col-lg-3">
                                    <div class="info-label-horizontal d-flex align-items-center">
                                        <i class="bi bi-telephone me-1 text-success"></i> Số điện thoại
                                    </div>
                                    <div class="info-value-horizontal">
                                        <c:choose>
                                            <c:when test="${not empty appointment.patient.user.phone}">
                                                ${appointment.patient.user.phone}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Chưa cập nhật</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="col-12 col-md-6 col-lg-3">
                                    <div class="info-label-horizontal d-flex align-items-center">
                                        <i class="bi bi-envelope-at me-1 text-warning"></i> Email
                                    </div>
                                    <div class="info-value-horizontal">
                                        <c:choose>
                                            <c:when test="${not empty appointment.patient.user.email}">
                                                ${appointment.patient.user.email}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Chưa cập nhật</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="col-12 col-md-6 col-lg-3">
                                    <div class="info-label-horizontal d-flex align-items-center">
                                        <i class="bi bi-geo-alt me-1 text-danger"></i> Địa chỉ
                                    </div>
                                    <div class="info-value-horizontal">
                                        <c:choose>
                                            <c:when test="${not empty appointment.patient.user.address}">
                                                ${appointment.patient.user.address}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Chưa cập nhật</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Notes -->
                        <c:if test="${not empty appointment.patientNotes}">
                            <div class="notes-group-horizontal mt-3">
                                <div class="info-label-horizontal d-flex align-items-center">
                                    <i class="bi bi-journal-text me-1 text-primary"></i>
                                    Ghi chú của bệnh nhân
                                </div>
                                <div class="info-value-horizontal notes-content-horizontal">
                                    ${appointment.patientNotes}
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <!-- Medical Records and Prescriptions Section -->
                    <div class="medical-records-section mt-4">
                        <ul class="nav nav-tabs" id="medicalRecordTabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" id="medical-record-tab" data-bs-toggle="tab" 
                                        data-bs-target="#medical-record" type="button" role="tab">
                                    <i class="bi bi-file-earmark-medical"></i>Bệnh án
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="prescription-tab" data-bs-toggle="tab" 
                                        data-bs-target="#prescription" type="button" role="tab">
                                    <i class="bi bi-file-text"></i>Đơn thuốc
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="notification-tab" data-bs-toggle="tab" 
                                        data-bs-target="#notification" type="button" role="tab">
                                    <i class="bi bi-bell"></i>Thông báo
                                    <span class="badge bg-danger rounded-pill">2</span>
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="notes-tab" data-bs-toggle="tab" 
                                        data-bs-target="#notes" type="button" role="tab">
                                    <i class="bi bi-journal-text"></i>Ghi chú
                                </button>
                            </li>
                        </ul>
                        
                        <div class="tab-content" id="medicalRecordTabContent">
                            <!-- Medical Record Tab -->
                            <div class="tab-pane fade show active" id="medical-record" role="tabpanel">
                                <div class="medical-record-content">
                                    <c:choose>
                                        <c:when test="${not empty examination}">
                                            <div class="medical-record-details">
                                                <div class="row g-3">
                                                    <div class="col-md-6">
                                                        <h5 class="text-primary"><i class="bi bi-heart-pulse me-2"></i>Tổng quát</h5>
                                                        <div class="vital-signs p-3 bg-light rounded">
                                                            <p><strong>Huyết áp:</strong> ${examination.bloodPressureSystolic}/${examination.bloodPressureDiastolic} mmHg</p>
                                                            <p><strong>Nhịp tim:</strong> ${examination.heartRate} bpm</p>
                                                            <p><strong>Nhiệt độ:</strong> ${examination.temperature}°C</p>
                                                            <p><strong>Nhịp thở:</strong> ${examination.respiratoryRate} lần/phút</p>
                                                            <p><strong>SpO2:</strong> ${examination.oxygenSaturation}%</p>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <h5 class="text-primary"><i class="bi bi-clipboard2-pulse me-2"></i>Triệu chứng & Chẩn đoán</h5>
                                                        <div class="symptoms-diagnosis p-3 bg-light rounded">
                                                            <p><strong>Triệu chứng:</strong> ${examination.symptoms}</p>
                                                            <p><strong>Triệu chứng chính:</strong> ${examination.chiefComplaint}</p>
                                                            <p><strong>Khám lâm sàng:</strong> ${examination.physicalExamination}</p>
                                                            <p><strong>Chẩn đoán:</strong> ${examination.diseaseDiagnosis}</p>
                                                            <p><strong>Mã ICD:</strong> ${examination.icdDiagnosis.icdCode} - ${examination.icdDiagnosis.description}</p>
                                                        </div>
                                                    </div>
                                                    <div class="col-12">
                                                        <h5 class="text-primary"><i class="bi bi-journal-medical me-2"></i>Kế hoạch điều trị</h5>
                                                        <div class="treatment-plan p-3 bg-light rounded">
                                                            <p>${examination.conclusionTreatmentPlan}</p>
                                                            <p class="mt-2"><strong>Ngày tái khám:</strong> ${followUpDateStr}</p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="empty-state">
                                                <i class="bi bi-clipboard-x"></i>
                                                <p>Chưa có bệnh án cho lịch hẹn này.</p>
                                                <a href="<c:url value='/doctor/appointments/${appointment.appointmentID}/examination/create' />" class="btn btn-primary mt-2">
                                                    <i class="bi bi-plus-circle me-2"></i>Tạo bệnh án mới
                                                </a>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            
                            <!-- Prescription Tab -->
                            <div class="tab-pane fade" id="prescription" role="tabpanel">
                                <div class="prescription-content">
                                    <c:choose>
                                        <c:when test="${not empty examination}">
                                            <c:choose>
                                                <c:when test="${not empty prescriptions}">
                                                    <div class="completed-prescription mb-4">
                                                        <h5 class="text-success mb-3">
                                                            <i class="bi bi-check-circle-fill me-2"></i>
                                                            Đơn thuốc đã hoàn thành
                                                        </h5>
                                                        <div class="table-responsive">
                                                            <table class="table table-hover">
                                                                <thead class="table-light">
                                                                    <tr>
                                                                        <th>Tên thuốc</th>
                                                                        <th>Số lượng</th>
                                                                        <th>Liều lượng</th>
                                                                        <th>Tần suất</th>
                                                                        <th>Thời gian</th>
                                                                        <th>Hướng dẫn</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <c:forEach var="prescription" items="${prescriptions}">
                                                                        <tr>
                                                                            <td><strong>${prescription.medication.medicationName}</strong></td>
                                                                            <td>${prescription.quantity}</td>
                                                                            <td>${prescription.dosage}</td>
                                                                            <td>${prescription.frequency}</td>
                                                                            <td>${prescription.duration}</td>
                                                                            <td>${prescription.instructions}</td>
                                                                        </tr>
                                                                    </c:forEach>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </div>
                                                    <div class="text-end mt-3">
                                                <a href="/doctor/appointments/${appointment.appointmentID}/prescriptions" class="btn btn-primary">
                                                    <i class="bi bi-plus-circle me-2"></i>Thêm đơn thuốc mới
                                                </a>
                                            </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="empty-state">
                                                        <i class="bi bi-file-earmark-medical"></i>
                                                        <p>Chưa có đơn thuốc nào được tạo</p>
                                                        <a href="/doctor/appointments/${appointment.appointmentID}/prescriptions" class="btn btn-primary mt-3">
                                                            <i class="bi bi-plus-circle me-2"></i>Tạo đơn thuốc mới
                                                        </a>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="empty-state">
                                                <i class="bi bi-file-earmark-x"></i>
                                                <p>Vui lòng tạo bệnh án trước khi kê đơn thuốc</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Notification Tab -->
                            <div class="tab-pane fade" id="notification" role="tabpanel">
                                <div class="loading-spinner">
                                    <div class="spinner-border text-primary" role="status">
                                        <span class="visually-hidden">Đang tải...</span>
                                    </div>
                                    <p>Đang tải thông báo...</p>
                                </div>
                                <div class="notification-list">
                                    <div class="notification-item">
                                        <div class="d-flex align-items-center">
                                            <div class="notification-icon">
                                                <i class="bi bi-calendar-check fs-4 text-primary"></i>
                                            </div>
                                            <div class="notification-content flex-grow-1">
                                                <h6 class="mb-1">Lịch hẹn mới</h6>
                                                <p class="mb-1">Bệnh nhân Nguyễn Văn A đã đặt lịch khám vào ngày 20/06/2025</p>
                                                <small class="text-muted">2 giờ trước</small>
                                            </div>
                                            <div class="notification-actions">
                                                <button class="btn btn-sm btn-outline-primary">Xác nhận</button>
                                                <button class="btn btn-sm btn-outline-danger">Từ chối</button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="notification-item">
                                        <div class="d-flex align-items-center">
                                            <div class="notification-icon">
                                                <i class="bi bi-info-circle fs-4 text-info"></i>
                                            </div>
                                            <div class="notification-content flex-grow-1">
                                                <h6 class="mb-1">Cập nhật hệ thống</h6>
                                                <p class="mb-1">Hệ thống sẽ bảo trì vào ngày 25/06/2025</p>
                                                <small class="text-muted">1 ngày trước</small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Notes Tab -->
                            <div class="tab-pane fade" id="notes" role="tabpanel">
                                <div class="loading-spinner">
                                    <div class="spinner-border text-primary" role="status">
                                        <span class="visually-hidden">Đang tải...</span>
                                    </div>
                                    <p>Đang tải ghi chú...</p>
                                </div>
                                <div class="notes-content">
                                    <div class="mb-4">
                                        <label for="doctorNotes" class="form-label d-flex align-items-center">
                                            <i class="bi bi-pencil-square me-2 text-primary"></i>
                                            <span>Ghi chú của bác sĩ</span>
                                        </label>
                                        <textarea class="form-control" id="doctorNotes" 
                                                placeholder="Nhập ghi chú của bạn tại đây...">${appointment.adminNotes}</textarea>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label d-flex align-items-center">
                                            <i class="bi bi-chat-left-text me-2 text-info"></i>
                                            <span>Ghi chú của bệnh nhân</span>
                                        </label>
                                        <div class="patient-notes">
                                            ${not empty appointment.patientNotes ? appointment.patientNotes : 'Không có ghi chú từ bệnh nhân'}
                                        </div>
                                    </div>
                                    <div class="text-end">
                                        <button class="btn btn-primary" onclick="saveNotes()">
                                            <i class="bi bi-save me-2"></i>Lưu ghi chú
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="action-card mt-4">
                        <div class="action-buttons d-flex justify-content-around mb-3 gap-2">
                            <a href="<c:url value='/doctor/appointments/${appointment.appointmentID}/examination/create' />" class="btn-action btn-create">
                                <i class="bi bi-file-earmark-medical"></i>
                                Tạo Hồ sơ Khám bệnh
                            </a>
                            <!-- <a href="#" class="btn-action btn-prescription">
                                <i class="bi bi-file-text"></i>
                                Kê Đơn Thuốc
                            </a> -->
                            <a href="/doctor/appointments/${appointment.appointmentID}/prescriptions" class="btn-action btn-prescription">
                                <i class="bi bi-file-text"></i>
                                Kê Đơn Thuốc
                            </a>
                            <a href="#" class="btn-action btn-history">
                                <i class="bi bi-clock-history"></i>
                                Xem Lịch sử Khám bệnh
                            </a>                  
                            <a href="/doctor/appointments" class="btn-action btn-back">
                                <i class="bi bi-arrow-left"></i>
                                Quay lại Lịch hẹn
                            </a>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </section>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        // Initialize all tabs
        var tabs = {
            'medical-record': {
                tab: document.getElementById('medical-record-tab'),
                content: document.getElementById('medical-record')
            },
            'prescription': {
                tab: document.getElementById('prescription-tab'),
                content: document.getElementById('prescription')
            },
            'notification': {
                tab: document.getElementById('notification-tab'),
                content: document.getElementById('notification')
            },
            'notes': {
                tab: document.getElementById('notes-tab'),
                content: document.getElementById('notes')
            }
        };

        // Function to show loading spinner
        // function showLoading(container) {
        //     var spinner = document.createElement('div');
        //     spinner.className = 'loading-spinner';
        //     spinner.innerHTML = 
        //         '<div class="spinner-border text-primary" role="status">' +
        //         '<span class="visually-hidden">Đang tải...</span>' +
        //         '</div>' +
        //         '<p class="mt-2 text-muted">Đang tải nội dung...</p>';
        //     container.innerHTML = '';
        //     container.appendChild(spinner);
        //     spinner.style.display = 'block';
        //     return spinner;
        // }

        // Function to hide loading spinner
        // function hideLoading(spinner) {
        //     if (spinner) {
        //         spinner.style.display = 'none';
        //     }
        // }

        // Function to show empty state message
        function showEmptyState(container, icon, message) {
            var content = document.createElement('div');
            content.className = 'empty-state';
            content.innerHTML = 
                '<i class="bi ' + icon + '"></i>' +
                '<p>' + message + '</p>';
            container.innerHTML = '';
            container.appendChild(content);
        }

        // Function to handle tab switching
        function switchTab(targetTabId) {
            // Hide all tab contents first
            Object.keys(tabs).forEach(function(tabId) {
                var currentTab = tabs[tabId];
                if (currentTab.tab && currentTab.content) {
                    currentTab.tab.classList.remove('active');
                    currentTab.content.classList.remove('show', 'active');
                }
            });

            // Show the selected tab and its content
            var selectedTab = tabs[targetTabId];
            if (selectedTab && selectedTab.tab && selectedTab.content) {
                selectedTab.tab.classList.add('active');
                selectedTab.content.classList.add('show', 'active');

                // Handle content for each tab
                if (targetTabId === 'prescription') {
                    var hasExamination = '${not empty examination}' === 'true';
                    if (!hasExamination) {
                        showEmptyState(
                            selectedTab.content,
                            'bi-file-earmark-x',
                            'Vui lòng tạo bệnh án trước khi kê đơn thuốc'
                        );
                    } else {
                        selectedTab.content.innerHTML = 
                            '<div class="prescription-content">' +
                            '<div class="text-end mb-3">' +
                            '<button class="btn btn-primary" onclick="addNewPrescription()">' +
                            '<i class="bi bi-plus-circle me-2"></i>Thêm đơn thuốc mới' +
                            '</button>' +
                            '</div>' +
                            '<div class="empty-state">' +
                            '<i class="bi bi-file-earmark-medical"></i>' +
                            '<p>Chưa có đơn thuốc nào được tạo</p>' +
                            '</div>' +
                            '</div>';
                    }
                } else if (targetTabId === 'notification') {
                    selectedTab.content.innerHTML = 
                        '<div class="notification-list">' +
                        '<div class="notification-item">' +
                        '<div class="d-flex align-items-center">' +
                        '<div class="notification-icon">' +
                        '<i class="bi bi-calendar-check fs-4 text-primary"></i>' +
                        '</div>' +
                        '<div class="notification-content flex-grow-1">' +
                        '<h6 class="mb-1">Lịch hẹn mới</h6>' +
                        '<p class="mb-1">Bệnh nhân Nguyễn Văn A đã đặt lịch khám vào ngày 20/06/2025</p>' +
                        '<small class="text-muted">2 giờ trước</small>' +
                        '</div>' +
                        '<div class="notification-actions">' +
                        '<button class="btn btn-sm btn-outline-primary">Xác nhận</button>' +
                        '<button class="btn btn-sm btn-outline-danger">Từ chối</button>' +
                        '</div>' +
                        '</div>' +
                        '</div>' +
                        '</div>';
                } else if (targetTabId === 'notes') {
                    var adminNotes = '${appointment.adminNotes}';
                    var patientNotes = '${appointment.patientNotes}';
                    
                    selectedTab.content.innerHTML = 
                        '<div class="notes-content">' +
                        '<div class="mb-4">' +
                        '<label for="doctorNotes" class="form-label d-flex align-items-center">' +
                        '<i class="bi bi-pencil-square me-2 text-primary"></i>' +
                        '<span>Ghi chú của bác sĩ</span>' +
                        '</label>' +
                        '<textarea class="form-control" id="doctorNotes" ' +
                        'placeholder="Nhập ghi chú của bạn tại đây...">' + 
                        (adminNotes || '') + 
                        '</textarea>' +
                        '</div>' +
                        '<div class="mb-3">' +
                        '<label class="form-label d-flex align-items-center">' +
                        '<i class="bi bi-chat-left-text me-2 text-info"></i>' +
                        '<span>Ghi chú của bệnh nhân</span>' +
                        '</label>' +
                        '<div class="patient-notes">' +
                        (patientNotes || 'Không có ghi chú từ bệnh nhân') +
                        '</div>' +
                        '</div>' +
                        '<div class="text-end">' +
                        '<button class="btn btn-primary" onclick="saveNotes()">' +
                        '<i class="bi bi-save me-2"></i>Lưu ghi chú' +
                        '</button>' +
                        '</div>' +
                        '</div>';
                }
            }
        }

        // Add click event listeners to all tabs
        Object.keys(tabs).forEach(function(tabId) {
            var tab = tabs[tabId].tab;
            if (tab) {
                tab.addEventListener('click', function(e) {
                    e.preventDefault();
                    switchTab(tabId);
                });
            }
        });

        // Show medical record tab by default
        switchTab('medical-record');

        // Function to save notes
        window.saveNotes = function() {
            var notes = document.getElementById('doctorNotes').value;
            var appointmentId = '${appointment.appointmentID}';
            
            // Show loading state
            var saveButton = document.querySelector('#notes button.btn-primary');
            var originalText = saveButton.innerHTML;
            saveButton.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Đang lưu...';
            saveButton.disabled = true;

            fetch('/doctor/appointments/' + appointmentId + '/notes/save', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'notes=' + encodeURIComponent(notes)
            })
            .then(function(response) {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.text();
            })
            .then(function() {
                showToast('Thành công', 'Ghi chú đã được lưu thành công!', 'success');
            })
            .catch(function() {
                showToast('Lỗi', 'Có lỗi xảy ra khi lưu ghi chú. Vui lòng thử lại!', 'danger');
            })
            .finally(function() {
                saveButton.innerHTML = originalText;
                saveButton.disabled = false;
            });
        };

        // Function to show toast notification
        function showToast(title, message, type) {
            var toastContainer = document.createElement('div');
            toastContainer.className = 'toast-container';
            var iconClass = type === 'success' ? 'check-circle-fill text-success' : 'x-circle-fill text-danger';
            toastContainer.innerHTML = 
                '<div class="toast show" role="alert" aria-live="assertive" aria-atomic="true">' +
                '<div class="toast-header">' +
                '<i class="bi bi-' + iconClass + ' me-2"></i>' +
                '<strong class="me-auto">' + title + '</strong>' +
                '<button type="button" class="btn-close" data-bs-dismiss="toast"></button>' +
                '</div>' +
                '<div class="toast-body">' + message + '</div>' +
                '</div>';
            document.body.appendChild(toastContainer);
            
            setTimeout(function() {
                toastContainer.remove();
            }, 3000);
        }

        // Function to add new prescription (placeholder)
        window.addNewPrescription = function() {
            alert('Tính năng đang được phát triển');
        };

        // Check if URL has #prescription hash
        if (window.location.hash === '#prescription') {
            // Get the prescription tab element
            const prescriptionTab = document.getElementById('prescription-tab');
            if (prescriptionTab) {
                // Create a new bootstrap tab instance and show it
                const tab = new bootstrap.Tab(prescriptionTab);
                tab.show();
    }
}
    });
    </script>
</body>
</html>