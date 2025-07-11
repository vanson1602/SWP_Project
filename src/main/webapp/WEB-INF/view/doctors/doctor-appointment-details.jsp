<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <%@ page import="java.time.format.DateTimeFormatter" %>
                    <%@ page import="java.time.LocalDateTime" %>
                        <%! private String formatDateTime(LocalDateTime dateTime) { if (dateTime==null) return "" ;
                            return dateTime.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")); } %>
                            <!DOCTYPE html>
                            <html lang="vi">

                            <head>
                                <meta charset="UTF-8" />
                                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                                <link rel="stylesheet"
                                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
                                <link rel="stylesheet" href="/css/homepage.css">
                                <link rel="stylesheet" href="/css/doctor-appointment-details.css">
                                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
                                    rel="stylesheet">
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

                                    /* Thêm style cho bảng đơn thuốc */
                                    .prescription-list {
                                        background: #fff;
                                        border-radius: 8px;
                                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                                        margin-bottom: 20px;
                                    }

                                    .prescription-list .table {
                                        margin-bottom: 0;
                                    }

                                    .prescription-list .table th {
                                        background-color: #f8f9fa;
                                        border-bottom: 2px solid #dee2e6;
                                        font-weight: 600;
                                        color: #495057;
                                    }

                                    .prescription-list .table td {
                                        vertical-align: middle;
                                        padding: 12px;
                                    }

                                    .prescription-list .table tbody tr:hover {
                                        background: linear-gradient(135deg, #e3f2fd 0%, #f0f8ff 100%);
                                        transform: scale(1.01);
                                        transition: all 0.3s ease;
                                        box-shadow: 0 2px 8px rgba(33, 150, 243, 0.1);
                                    }

                                    .prescription-list .badge {
                                        padding: 6px 10px;
                                        font-weight: 500;
                                    }

                                    .prescription-list small.text-muted {
                                        font-size: 85%;
                                    }

                                    /* Styles for action buttons */
                                    .btn-group .btn {
                                        margin: 0 2px;
                                    }

                                    .btn-group .btn-sm {
                                        padding: 0.25rem 0.5rem;
                                        border-radius: 0.25rem;
                                    }

                                    .btn-group .btn-sm i {
                                        font-size: 0.875rem;
                                    }

                                    /* Prescription form styles */
                                    .prescription-form-container {
                                        background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                                        border: 2px dashed #dee2e6;
                                        border-radius: 16px;
                                        padding: 30px;
                                        margin-bottom: 25px;
                                        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
                                        position: relative;
                                        overflow: hidden;
                                    }

                                    .prescription-form-container::before {
                                        content: '';
                                        position: absolute;
                                        top: 0;
                                        left: 0;
                                        right: 0;
                                        bottom: 0;
                                        background: linear-gradient(45deg, transparent 30%, rgba(13, 110, 253, 0.03) 50%, transparent 70%);
                                        opacity: 0;
                                        transition: opacity 0.3s ease;
                                    }

                                    .prescription-form-container.active {
                                        border-color: #0d6efd;
                                        background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
                                        box-shadow:
                                            0 8px 25px rgba(13, 110, 253, 0.15),
                                            0 4px 10px rgba(0, 0, 0, 0.1),
                                            inset 0 1px 0 rgba(255, 255, 255, 0.6);
                                        border-style: solid;
                                        transform: translateY(-2px);
                                    }

                                    .prescription-form-container.active::before {
                                        opacity: 1;
                                    }

                                    .add-prescription-btn {
                                        width: 100%;
                                        padding: 20px;
                                        border: 2px dashed #6c757d;
                                        background: linear-gradient(135deg, transparent 0%, rgba(108, 117, 125, 0.05) 100%);
                                        color: #6c757d;
                                        border-radius: 12px;
                                        font-size: 16px;
                                        font-weight: 500;
                                        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
                                        cursor: pointer;
                                        position: relative;
                                        overflow: hidden;
                                        letter-spacing: 0.5px;
                                    }

                                    .add-prescription-btn::before {
                                        content: '';
                                        position: absolute;
                                        top: 0;
                                        left: -100%;
                                        width: 100%;
                                        height: 100%;
                                        background: linear-gradient(90deg, transparent, rgba(13, 110, 253, 0.1), transparent);
                                        transition: left 0.5s ease;
                                    }

                                    .add-prescription-btn:hover {
                                        border-color: #0d6efd;
                                        color: #0d6efd;
                                        background: linear-gradient(135deg, rgba(13, 110, 253, 0.08) 0%, rgba(13, 110, 253, 0.15) 100%);
                                        transform: translateY(-2px);
                                        box-shadow: 0 8px 20px rgba(13, 110, 253, 0.2);
                                    }

                                    .add-prescription-btn:hover::before {
                                        left: 100%;
                                    }

                                    .add-prescription-btn:active {
                                        transform: translateY(0);
                                        box-shadow: 0 4px 10px rgba(13, 110, 253, 0.2);
                                    }

                                    .prescription-row {
                                        background: linear-gradient(135deg, #ffffff 0%, #fafbfc 100%);
                                        border: 1px solid #e9ecef;
                                        border-radius: 16px;
                                        padding: 25px;
                                        margin-bottom: 20px;
                                        position: relative;
                                        transition: all 0.3s ease;
                                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
                                    }

                                    .prescription-row:hover {
                                        transform: translateY(-1px);
                                        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                                        border-color: #0d6efd;
                                    }

                                    .prescription-row .row-number {
                                        position: absolute;
                                        top: -12px;
                                        left: 20px;
                                        background: linear-gradient(135deg, #0d6efd 0%, #0056b3 100%);
                                        color: white;
                                        width: 28px;
                                        height: 28px;
                                        border-radius: 50%;
                                        display: flex;
                                        align-items: center;
                                        justify-content: center;
                                        font-size: 12px;
                                        font-weight: bold;
                                        box-shadow: 0 2px 8px rgba(13, 110, 253, 0.3);
                                        border: 2px solid white;
                                    }

                                    .prescription-row .remove-btn {
                                        position: absolute;
                                        top: 15px;
                                        right: 15px;
                                        width: 32px;
                                        height: 32px;
                                        border-radius: 50%;
                                        border: none;
                                        background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
                                        color: white;
                                        display: flex;
                                        align-items: center;
                                        justify-content: center;
                                        cursor: pointer;
                                        font-size: 14px;
                                        transition: all 0.3s ease;
                                        box-shadow: 0 2px 8px rgba(220, 53, 69, 0.3);
                                    }

                                    .prescription-row .remove-btn:hover {
                                        background: linear-gradient(135deg, #c82333 0%, #bd2130 100%);
                                        transform: scale(1.1);
                                        box-shadow: 0 4px 12px rgba(220, 53, 69, 0.4);
                                    }

                                    .prescription-row .remove-btn:active {
                                        transform: scale(0.95);
                                    }

                                    /* Enhanced form controls */
                                    .prescription-row .form-control {
                                        border: 2px solid #e9ecef;
                                        border-radius: 8px;
                                        padding: 12px 16px;
                                        font-size: 14px;
                                        transition: all 0.3s ease;
                                        background: #ffffff;
                                    }

                                    .prescription-row .form-control:focus {
                                        border-color: #0d6efd;
                                        box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.15);
                                        background: #ffffff;
                                    }

                                    .prescription-row .form-label {
                                        font-weight: 600;
                                        color: #495057;
                                        margin-bottom: 8px;
                                        font-size: 14px;
                                    }

                                    /* Enhanced action buttons */
                                    #prescriptionForm .btn {
                                        padding: 12px 24px;
                                        border-radius: 8px;
                                        font-weight: 500;
                                        transition: all 0.3s ease;
                                        border: none;
                                        position: relative;
                                        overflow: hidden;
                                    }

                                    #prescriptionForm .btn-secondary {
                                        background: linear-gradient(135deg, #6c757d 0%, #5a6268 100%);
                                        color: white;
                                    }

                                    #prescriptionForm .btn-secondary:hover {
                                        background: linear-gradient(135deg, #5a6268 0%, #545b62 100%);
                                        transform: translateY(-1px);
                                        box-shadow: 0 4px 12px rgba(108, 117, 125, 0.3);
                                    }

                                    #prescriptionForm .btn-success {
                                        background: linear-gradient(135deg, #198754 0%, #157347 100%);
                                        color: white;
                                    }

                                    #prescriptionForm .btn-success:hover:not(:disabled) {
                                        background: linear-gradient(135deg, #157347 0%, #146c43 100%);
                                        transform: translateY(-1px);
                                        box-shadow: 0 4px 12px rgba(25, 135, 84, 0.3);
                                    }

                                    #prescriptionForm .btn:disabled {
                                        opacity: 0.6;
                                        cursor: not-allowed;
                                        transform: none !important;
                                        box-shadow: none !important;
                                    }

                                    /* Medication search results styling */
                                    .search-results {
                                        position: absolute;
                                        width: 100%;
                                        max-height: 200px;
                                        overflow-y: auto;
                                        background: white;
                                        border: 1px solid #ddd;
                                        border-radius: 4px;
                                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
                                        z-index: 1000;
                                        margin-top: 2px;
                                    }

                                    .search-results .list-group-item {
                                        cursor: pointer;
                                        padding: 8px 12px;
                                        border-left: none;
                                        border-right: none;
                                        transition: background-color 0.2s;
                                        font-size: 14px;
                                    }

                                    .search-results .list-group-item:hover {
                                        background-color: #f8f9fa;
                                    }

                                    .medication-form {
                                        position: relative;
                                    }

                                    /* Button styling to match btn-action */
                                    .btn-action {
                                        border: none;
                                        background: inherit;
                                        color: inherit;
                                        text-decoration: none;
                                        display: inline-flex;
                                        align-items: center;
                                        justify-content: center;
                                        cursor: pointer;
                                    }

                                    /* Medication info styling */
                                    .medication-info {
                                        display: flex;
                                        justify-content: space-between;
                                        align-items: center;
                                        width: 100%;
                                    }

                                    .medication-name {
                                        font-weight: 500;
                                        color: #333;
                                    }

                                    .medication-details {
                                        color: #6c757d;
                                        font-size: 0.875rem;
                                        margin-top: 2px;
                                    }



                                    /* Form validation styling */
                                    .form-control:invalid {
                                        border-color: #dc3545;
                                    }

                                    .form-control:valid {
                                        border-color: #198754;
                                    }

                                    /* Disabled button styling */
                                    .btn:disabled {
                                        opacity: 0.6;
                                        cursor: not-allowed;
                                    }

                                    /* Modern Status Badge Styles */
                                    .status-badge-horizontal {
                                        padding: 8px 16px;
                                        border-radius: 20px;
                                        font-weight: 600;
                                        font-size: 0.875rem;
                                        display: inline-flex;
                                        align-items: center;
                                        gap: 6px;
                                        letter-spacing: 0.3px;
                                        text-transform: uppercase;
                                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                                        transition: all 0.3s ease;
                                    }

                                    .status-pending {
                                        background: linear-gradient(135deg, #fff3cd 0%, #ffe69c 100%);
                                        color: #b45309;
                                        border: 1px solid #ffd43b;
                                    }

                                    .status-confirmed {
                                        background: linear-gradient(135deg, #d4edda 0%, #a3d5a5 100%);
                                        color: #0f5132;
                                        border: 1px solid #75b798;
                                    }

                                    .status-completed {
                                        background: linear-gradient(135deg, #cff4fc 0%, #9eeaf9 100%);
                                        color: #055160;
                                        border: 1px solid #6edff6;
                                    }

                                    .status-cancelled {
                                        background: linear-gradient(135deg, #f8d7da 0%, #f1aeb5 100%);
                                        color: #58151c;
                                        border: 1px solid #ea868f;
                                    }

                                    /* Info Card Styles */
                                    .info-card {
                                        background: linear-gradient(135deg, #ffffff 0%, #f8fafe 100%);
                                        border: 1px solid #e3f2fd;
                                        border-radius: 12px;
                                        padding: 16px;
                                        transition: all 0.3s ease;
                                        box-shadow: 0 2px 8px rgba(33, 150, 243, 0.08);
                                        height: 100%;
                                        position: relative;
                                        overflow: hidden;
                                    }

                                    .info-card::before {
                                        content: '';
                                        position: absolute;
                                        top: 0;
                                        left: 0;
                                        width: 4px;
                                        height: 100%;
                                        background: linear-gradient(135deg, #2196f3 0%, #21cbf3 100%);
                                        transition: width 0.3s ease;
                                    }

                                    .info-card:hover {
                                        transform: translateY(-2px);
                                        box-shadow: 0 4px 20px rgba(33, 150, 243, 0.15);
                                        border-color: #2196f3;
                                    }

                                    .info-card:hover::before {
                                        width: 6px;
                                    }

                                    .info-label-horizontal {
                                        font-size: 0.875rem;
                                        font-weight: 600;
                                        color: #546e7a;
                                        margin-bottom: 8px;
                                    }

                                    .info-value-horizontal {
                                        font-size: 1rem;
                                        font-weight: 500;
                                        color: #263238;
                                        word-break: break-word;
                                    }

                                    /* Modern Tabs Styles */
                                    .modern-tabs {
                                        border-bottom: 2px solid #e9ecef;
                                        background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
                                        border-radius: 12px 12px 0 0;
                                        padding: 8px 16px 0;
                                    }

                                    .modern-tabs .nav-link {
                                        border: none;
                                        border-radius: 8px 8px 0 0;
                                        padding: 12px 20px;
                                        color: #6c757d;
                                        font-weight: 500;
                                        transition: all 0.3s ease;
                                        position: relative;
                                        margin-right: 4px;
                                        background: transparent;
                                    }

                                    .modern-tabs .nav-link:hover {
                                        color: #2196f3;
                                        background: linear-gradient(135deg, #e3f2fd 0%, #f0f8ff 100%);
                                        transform: translateY(-2px);
                                    }

                                    .modern-tabs .nav-link.active {
                                        color: #2196f3;
                                        background: linear-gradient(135deg, #ffffff 0%, #f8fafe 100%);
                                        border: 1px solid #e3f2fd;
                                        border-bottom: 2px solid #2196f3;
                                        box-shadow: 0 -2px 8px rgba(33, 150, 243, 0.1);
                                    }

                                    .modern-tabs .nav-link.active::after {
                                        content: '';
                                        position: absolute;
                                        bottom: -2px;
                                        left: 0;
                                        right: 0;
                                        height: 2px;
                                        background: linear-gradient(135deg, #2196f3 0%, #21cbf3 100%);
                                    }

                                    .modern-tabs .badge {
                                        font-size: 0.7rem;
                                        padding: 2px 6px;
                                        animation: pulse 2s infinite;
                                    }

                                    @keyframes pulse {
                                        0% {
                                            transform: scale(1);
                                        }

                                        50% {
                                            transform: scale(1.1);
                                        }

                                        100% {
                                            transform: scale(1);
                                        }
                                    }

                                    /* Modern Button Styles */
                                    .modern-btn {
                                        position: relative;
                                        overflow: hidden;
                                        border-radius: 12px !important;
                                        padding: 12px 24px !important;
                                        font-weight: 600;
                                        text-decoration: none;
                                        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                                        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                                    }

                                    .modern-btn::before {
                                        content: '';
                                        position: absolute;
                                        top: 0;
                                        left: -100%;
                                        width: 100%;
                                        height: 100%;
                                        background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
                                        transition: left 0.5s ease;
                                    }

                                    .modern-btn:hover::before {
                                        left: 100%;
                                    }

                                    .modern-btn:hover {
                                        transform: translateY(-3px);
                                        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
                                    }

                                    .btn-create.modern-btn {
                                        background: linear-gradient(135deg, #2196f3 0%, #21cbf3 100%);
                                        color: white;
                                    }

                                    .btn-create.modern-btn:hover {
                                        background: linear-gradient(135deg, #1976d2 0%, #039be5 100%);
                                        color: white;
                                    }

                                    .btn-history.modern-btn {
                                        background: linear-gradient(135deg, #7b1fa2 0%, #9c27b0 100%);
                                        color: white;
                                    }

                                    .btn-history.modern-btn:hover {
                                        background: linear-gradient(135deg, #6a1b9a 0%, #8e24aa 100%);
                                        color: white;
                                    }

                                    .btn-back.modern-btn {
                                        background: linear-gradient(135deg, #546e7a 0%, #607d8b 100%);
                                        color: white;
                                    }

                                    .btn-back.modern-btn:hover {
                                        background: linear-gradient(135deg, #455a64 0%, #546e7a 100%);
                                        color: white;
                                    }
                                </style>
                            </head>

                            <body>
                                <!-- Header -->
                                <jsp:include page="../shared/header-doctor.jsp" />

                                <!-- Main Content (Merged Details and Actions) -->
                                <section class="appointment-details-section">
                                    <div class="container">
                                        <div class="details-card">
                                            <h1 class="page-title">Chi tiết Lịch hẹn</h1>
                                            <c:if test="${not empty appointment}">
                                                <div class="patient-info patient-info-horizontal">
                                                    <!-- Patient Header: Avatar + Name + Code -->
                                                    <div
                                                        class="patient-header-horizontal d-flex align-items-center mb-4">
                                                        <div class="d-flex align-items-center">
                                                            <div class="patient-icon-horizontal me-3">
                                                                <c:choose>
                                                                    <c:when
                                                                        test="${not empty appointment.patient.user.avatarUrl}">
                                                                        <img src="${appointment.patient.user.avatarUrl}"
                                                                            alt="Patient Avatar"
                                                                            class="patient-avatar-horizontal">
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <div class="avatar-placeholder-horizontal">
                                                                            <i
                                                                                class="bi bi-person-circle fs-2 text-primary"></i>
                                                                        </div>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                            <div>
                                                                <div
                                                                    class="patient-name-horizontal h2 mb-0 d-flex align-items-center">
                                                                    <i class="bi bi-person-fill me-2 text-info"></i>
                                                                    ${appointment.patient.user.firstName}
                                                                    ${appointment.patient.user.lastName}
                                                                </div>
                                                                <div
                                                                    class="patient-id-horizontal text-muted d-flex align-items-center mt-1">
                                                                    <i class="bi bi-credit-card-2-front me-1"></i>
                                                                    Mã BN: <span
                                                                        class="ms-1 fw-semibold">${appointment.patient.patientCode}</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Appointment Status and Number -->
                                                    <div
                                                        class="appointment-header d-flex align-items-center flex-wrap gap-3 mb-4">
                                                        <span
                                                            class="status-badge-horizontal ${appointment.status == 'Pending' ? 'status-pending' : appointment.status == 'Confirmed' ? 'status-confirmed' : appointment.status == 'Completed' ? 'status-completed' : 'status-cancelled'} d-flex align-items-center">
                                                            <i class="bi bi-info-circle me-1"></i>
                                                            <c:choose>
                                                                <c:when test="${appointment.status eq 'Pending'}">Chờ
                                                                    khám</c:when>
                                                                <c:when test="${appointment.status eq 'Confirmed'}">Đã
                                                                    xác nhận</c:when>
                                                                <c:when test="${appointment.status eq 'Completed'}">Đã
                                                                    khám</c:when>
                                                                <c:when test="${appointment.status eq 'Cancelled'}">Đã
                                                                    hủy</c:when>
                                                                <c:otherwise>${appointment.status}</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                        <span
                                                            class="appointment-number-horizontal d-flex align-items-center">
                                                            <i class="bi bi-bookmark-check me-1"></i>
                                                            <span class="fw-semibold">Mã lịch hẹn:</span> <span
                                                                class="ms-1">${appointment.appointmentNumber}</span>
                                                        </span>
                                                    </div>

                                                    <!-- Patient Details Row -->
                                                    <div class="patient-details-row mt-3">
                                                        <div class="row g-3">
                                                            <div class="col-12 col-md-6 col-lg-3">
                                                                <div class="info-card">
                                                                    <div
                                                                        class="info-label-horizontal d-flex align-items-center">
                                                                        <i
                                                                            class="bi bi-gender-ambiguous me-2 text-primary"></i>
                                                                        Giới tính
                                                                    </div>
                                                                    <div class="info-value-horizontal">
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${not empty appointment.patient.user.gender}">
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${appointment.patient.user.gender eq 'Male'}">
                                                                                        Nam</c:when>
                                                                                    <c:when
                                                                                        test="${appointment.patient.user.gender eq 'Female'}">
                                                                                        Nữ</c:when>
                                                                                    <c:otherwise>Khác</c:otherwise>
                                                                                </c:choose>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="text-muted">Chưa cập
                                                                                    nhật</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="col-12 col-md-6 col-lg-3">
                                                                <div class="info-card">
                                                                    <div
                                                                        class="info-label-horizontal d-flex align-items-center">
                                                                        <i
                                                                            class="bi bi-telephone me-2 text-success"></i>
                                                                        Số điện thoại
                                                                    </div>
                                                                    <div class="info-value-horizontal">
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${not empty appointment.patient.user.phone}">
                                                                                ${appointment.patient.user.phone}
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="text-muted">Chưa cập
                                                                                    nhật</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="col-12 col-md-6 col-lg-3">
                                                                <div class="info-card">
                                                                    <div
                                                                        class="info-label-horizontal d-flex align-items-center">
                                                                        <i class="bi bi-envelope-at me-2 text-info"></i>
                                                                        Email
                                                                    </div>
                                                                    <div class="info-value-horizontal">
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${not empty appointment.patient.user.email}">
                                                                                ${appointment.patient.user.email}
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="text-muted">Chưa cập
                                                                                    nhật</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="col-12 col-md-6 col-lg-3">
                                                                <div class="info-card">
                                                                    <div
                                                                        class="info-label-horizontal d-flex align-items-center">
                                                                        <i class="bi bi-geo-alt me-2 text-danger"></i>
                                                                        Địa chỉ
                                                                    </div>
                                                                    <div class="info-value-horizontal">
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${not empty appointment.patient.user.address}">
                                                                                ${appointment.patient.user.address}
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="text-muted">Chưa cập
                                                                                    nhật</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <!-- Notes -->
                                                    <c:if test="${not empty appointment.patientNotes}">
                                                        <div class="notes-group-horizontal mt-3">
                                                            <div
                                                                class="info-label-horizontal d-flex align-items-center">
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
                                                    <ul class="nav nav-tabs modern-tabs" id="medicalRecordTabs"
                                                        role="tablist">
                                                        <li class="nav-item" role="presentation">
                                                            <button class="nav-link active" id="medical-record-tab"
                                                                data-bs-toggle="tab" data-bs-target="#medical-record"
                                                                type="button" role="tab">
                                                                <i class="bi bi-file-earmark-medical me-2"></i>Bệnh án
                                                            </button>
                                                        </li>
                                                        <li class="nav-item" role="presentation">
                                                            <button class="nav-link" id="prescription-tab"
                                                                data-bs-toggle="tab" data-bs-target="#prescription"
                                                                type="button" role="tab">
                                                                <i class="bi bi-file-text me-2"></i>Đơn thuốc
                                                            </button>
                                                        </li>
                                                        <li class="nav-item" role="presentation">
                                                            <button class="nav-link" id="notification-tab"
                                                                data-bs-toggle="tab" data-bs-target="#notification"
                                                                type="button" role="tab">
                                                                <i class="bi bi-bell me-2"></i>Thông báo
                                                                <span
                                                                    class="badge bg-gradient bg-danger rounded-pill ms-1">2</span>
                                                            </button>
                                                        </li>
                                                        <li class="nav-item" role="presentation">
                                                            <button class="nav-link" id="notes-tab" data-bs-toggle="tab"
                                                                data-bs-target="#notes" type="button" role="tab">
                                                                <i class="bi bi-journal-text me-2"></i>Ghi chú
                                                            </button>
                                                        </li>
                                                    </ul>

                                                    <div class="tab-content" id="medicalRecordTabContent">
                                                        <!-- Medical Record Tab -->
                                                        <div class="tab-pane fade show active" id="medical-record"
                                                            role="tabpanel">
                                                            <div class="medical-record-content">
                                                                <c:choose>
                                                                    <c:when test="${not empty examination}">
                                                                        <div class="medical-record-details">
                                                                            <div class="row g-3">
                                                                                <div class="col-md-6">
                                                                                    <h5 class="text-primary"><i
                                                                                            class="bi bi-heart-pulse me-2"></i>Tổng
                                                                                        quát</h5>
                                                                                    <div
                                                                                        class="vital-signs p-3 bg-light rounded">
                                                                                        <p><strong>Huyết áp:</strong>
                                                                                            ${examination.bloodPressureSystolic}/${examination.bloodPressureDiastolic}
                                                                                            mmHg</p>
                                                                                        <p><strong>Nhịp tim:</strong>
                                                                                            ${examination.heartRate} bpm
                                                                                        </p>
                                                                                        <p><strong>Nhiệt độ:</strong>
                                                                                            ${examination.temperature}°C
                                                                                        </p>
                                                                                        <p><strong>Nhịp thở:</strong>
                                                                                            ${examination.respiratoryRate}
                                                                                            lần/phút</p>
                                                                                        <p><strong>SpO2:</strong>
                                                                                            ${examination.oxygenSaturation}%
                                                                                        </p>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="col-md-6">
                                                                                    <h5 class="text-primary"><i
                                                                                            class="bi bi-clipboard2-pulse me-2"></i>Triệu
                                                                                        chứng & Chẩn đoán</h5>
                                                                                    <div
                                                                                        class="symptoms-diagnosis p-3 bg-light rounded">
                                                                                        <p><strong>Triệu chứng:</strong>
                                                                                            ${examination.symptoms}</p>
                                                                                        <p><strong>Triệu chứng
                                                                                                chính:</strong>
                                                                                            ${examination.chiefComplaint}
                                                                                        </p>
                                                                                        <p><strong>Khám lâm
                                                                                                sàng:</strong>
                                                                                            ${examination.physicalExamination}
                                                                                        </p>
                                                                                        <p><strong>Chẩn đoán:</strong>
                                                                                            ${examination.diseaseDiagnosis}
                                                                                        </p>
                                                                                        <p><strong>Mã ICD:</strong>
                                                                                            ${examination.icdDiagnosis.icdCode}
                                                                                            -
                                                                                            ${examination.icdDiagnosis.description}
                                                                                        </p>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="col-12">
                                                                                    <h5 class="text-primary"><i
                                                                                            class="bi bi-journal-medical me-2"></i>Kế
                                                                                        hoạch điều trị</h5>
                                                                                    <div
                                                                                        class="treatment-plan p-3 bg-light rounded">
                                                                                        <p>${examination.conclusionTreatmentPlan}
                                                                                        </p>
                                                                                        <p class="mt-2"><strong>Ngày tái
                                                                                                khám:</strong>
                                                                                            ${followUpDateStr}</p>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <div class="empty-state">
                                                                            <i class="bi bi-clipboard-x"></i>
                                                                            <p>Chưa có bệnh án cho lịch hẹn này.</p>
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
                                                                        <!-- Form kê đơn thuốc -->
                                                                        <div class="prescription-form-container"
                                                                            id="prescriptionFormContainer">
                                                                            <button type="button"
                                                                                class="add-prescription-btn"
                                                                                id="addPrescriptionBtn">
                                                                                <i class="bi bi-plus-circle me-2"></i>
                                                                                Thêm thuốc mới
                                                                            </button>

                                                                            <form id="prescriptionForm"
                                                                                style="display: none;" class="mt-3">
                                                                                <input type="hidden" name="_csrf"
                                                                                    value="${_csrf.token}" />
                                                                                <div id="prescriptionRows"></div>

                                                                                <div
                                                                                    class="d-flex justify-content-end gap-2 mt-3">
                                                                                    <button type="button"
                                                                                        class="btn btn-secondary"
                                                                                        id="cancelPrescriptionBtn">
                                                                                        <i
                                                                                            class="bi bi-x-circle me-1"></i>Hủy
                                                                                    </button>
                                                                                    <button type="submit"
                                                                                        class="btn btn-success"
                                                                                        id="savePrescriptionBtn">
                                                                                        <i
                                                                                            class="bi bi-save me-1"></i>Lưu
                                                                                        đơn thuốc
                                                                                    </button>
                                                                                </div>
                                                                            </form>
                                                                        </div>

                                                                        <!-- Danh sách đơn thuốc hiện có -->
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${not empty examination.prescriptions}">
                                                                                <div class="prescription-list">
                                                                                    <h6 class="mb-3">
                                                                                        <i
                                                                                            class="bi bi-list-ul me-2"></i>Đơn
                                                                                        thuốc đã kê
                                                                                    </h6>
                                                                                    <div class="table-responsive">
                                                                                        <table
                                                                                            class="table table-hover">
                                                                                            <thead class="table-light">
                                                                                                <tr>
                                                                                                    <th>STT</th>
                                                                                                    <th>Tên thuốc</th>
                                                                                                    <th>Số lượng</th>
                                                                                                    <th>Liều lượng</th>
                                                                                                    <th>Tần suất</th>
                                                                                                    <th>Thời gian dùng
                                                                                                    </th>
                                                                                                    <th>Hướng dẫn</th>
                                                                                                    <th>Thao tác</th>
                                                                                                </tr>
                                                                                            </thead>
                                                                                            <tbody
                                                                                                id="existingPrescriptions">
                                                                                                <c:forEach
                                                                                                    var="prescription"
                                                                                                    items="${examination.prescriptions}"
                                                                                                    varStatus="status">
                                                                                                    <tr
                                                                                                        data-prescription-id="${prescription.prescriptionID}">
                                                                                                        <td>${status.index
                                                                                                            + 1}</td>
                                                                                                        <td>
                                                                                                            <strong>${prescription.medication.medicationName}</strong>
                                                                                                        </td>
                                                                                                        <td>${prescription.quantity}
                                                                                                        </td>
                                                                                                        <td>${prescription.dosage}
                                                                                                        </td>
                                                                                                        <td>${prescription.frequency}
                                                                                                        </td>
                                                                                                        <td>${prescription.duration}
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <div
                                                                                                                class="text-muted small">
                                                                                                                ${not
                                                                                                                empty
                                                                                                                prescription.instructions
                                                                                                                ?
                                                                                                                prescription.instructions
                                                                                                                : 'Không
                                                                                                                có hướng
                                                                                                                dẫn'}
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <div class="btn-group"
                                                                                                                role="group">
                                                                                                                <button
                                                                                                                    type="button"
                                                                                                                    class="btn btn-sm btn-outline-primary"
                                                                                                                    onclick="editPrescriptionInline('${prescription.prescriptionID}')"
                                                                                                                    title="Sửa đơn thuốc">
                                                                                                                    <i
                                                                                                                        class="bi bi-pencil"></i>
                                                                                                                </button>
                                                                                                                <button
                                                                                                                    type="button"
                                                                                                                    class="btn btn-sm btn-outline-danger"
                                                                                                                    onclick="deletePrescription('${prescription.prescriptionID}')"
                                                                                                                    title="Xóa đơn thuốc">
                                                                                                                    <i
                                                                                                                        class="bi bi-trash"></i>
                                                                                                                </button>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </c:forEach>
                                                                                            </tbody>
                                                                                        </table>
                                                                                    </div>
                                                                                </div>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <div class="empty-state"
                                                                                    id="emptyPrescriptionState">
                                                                                    <i
                                                                                        class="bi bi-file-earmark-medical"></i>
                                                                                    <p>Chưa có đơn thuốc nào được tạo
                                                                                    </p>
                                                                                </div>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <div class="empty-state">
                                                                            <i class="bi bi-file-earmark-x"></i>
                                                                            <p>Vui lòng tạo bệnh án trước khi kê đơn
                                                                                thuốc</p>
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
                                                                            <i
                                                                                class="bi bi-calendar-check fs-4 text-primary"></i>
                                                                        </div>
                                                                        <div class="notification-content flex-grow-1">
                                                                            <h6 class="mb-1">Lịch hẹn mới</h6>
                                                                            <p class="mb-1">Bệnh nhân Nguyễn Văn A đã
                                                                                đặt lịch khám vào ngày 20/06/2025</p>
                                                                            <small class="text-muted">2 giờ
                                                                                trước</small>
                                                                        </div>
                                                                        <div class="notification-actions">
                                                                            <button
                                                                                class="btn btn-sm btn-outline-primary">Xác
                                                                                nhận</button>
                                                                            <button
                                                                                class="btn btn-sm btn-outline-danger">Từ
                                                                                chối</button>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="notification-item">
                                                                    <div class="d-flex align-items-center">
                                                                        <div class="notification-icon">
                                                                            <i
                                                                                class="bi bi-info-circle fs-4 text-info"></i>
                                                                        </div>
                                                                        <div class="notification-content flex-grow-1">
                                                                            <h6 class="mb-1">Cập nhật hệ thống</h6>
                                                                            <p class="mb-1">Hệ thống sẽ bảo trì vào ngày
                                                                                25/06/2025</p>
                                                                            <small class="text-muted">1 ngày
                                                                                trước</small>
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
                                                                    <label for="doctorNotes"
                                                                        class="form-label d-flex align-items-center">
                                                                        <i
                                                                            class="bi bi-pencil-square me-2 text-primary"></i>
                                                                        <span>Ghi chú của bác sĩ</span>
                                                                    </label>
                                                                    <textarea class="form-control" id="doctorNotes"
                                                                        placeholder="Nhập ghi chú của bạn tại đây...">${appointment.adminNotes}</textarea>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label class="form-label d-flex align-items-center">
                                                                        <i
                                                                            class="bi bi-chat-left-text me-2 text-info"></i>
                                                                        <span>Ghi chú của bệnh nhân</span>
                                                                    </label>
                                                                    <div class="patient-notes">
                                                                        ${not empty appointment.patientNotes ?
                                                                        appointment.patientNotes : 'Không có ghi chú từ
                                                                        bệnh nhân'}
                                                                    </div>
                                                                </div>
                                                                <div class="text-end">
                                                                    <button class="btn btn-primary"
                                                                        onclick="saveNotes()">
                                                                        <i class="bi bi-save me-2"></i>Lưu ghi chú
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="action-card mt-4">
                                                    <div
                                                        class="action-buttons d-flex justify-content-around mb-3 gap-3">
                                                        <c:choose>
                                                            <c:when test="${not empty examination}">
                                                                <a href="<c:url value='/doctor/appointments/${appointment.appointmentID}/examination/edit' />"
                                                                    class="btn-action btn-create modern-btn">
                                                                    <i class="bi bi-pencil-square me-2"></i>
                                                                    Sửa Hồ sơ Khám bệnh
                                                                </a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <a href="<c:url value='/doctor/appointments/${appointment.appointmentID}/examination/create' />"
                                                                    class="btn-action btn-create modern-btn">
                                                                    <i class="bi bi-file-earmark-medical me-2"></i>
                                                                    Tạo Hồ sơ Khám bệnh
                                                                </a>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <a href="patient/history/${appointment.patient.patientID}"
                                                            class="btn-action btn-history modern-btn">
                                                            <i class="bi bi-clock-history me-2"></i>
                                                            Xem Lịch sử Khám bệnh
                                                        </a>
                                                        <a href="/doctor/appointments"
                                                            class="btn-action btn-back modern-btn">
                                                            <i class="bi bi-arrow-left me-2"></i>
                                                            Quay lại Lịch hẹn
                                                        </a>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </section>

                                <!-- Bootstrap JS -->
                                <script
                                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                                <script>
                                    document.addEventListener('DOMContentLoaded', function () {
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
                                            Object.keys(tabs).forEach(function (tabId) {
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
                                                if (targetTabId === 'examination') {
                                                    var hasExamination = '${not empty examination}' === 'true';
                                                    if (!hasExamination) {
                                                        showEmptyState(
                                                            selectedTab.content,
                                                            'bi-file-earmark-x',
                                                            'Chưa có bệnh án cho lịch hẹn này.'
                                                        );
                                                    }
                                                } else if (targetTabId === 'prescription') {
                                                    var hasExamination = '${not empty examination}' === 'true';
                                                    if (!hasExamination) {
                                                        showEmptyState(
                                                            selectedTab.content,
                                                            'bi-file-earmark-x',
                                                            'Vui lòng tạo bệnh án trước khi kê đơn thuốc'
                                                        );
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
                                        Object.keys(tabs).forEach(function (tabId) {
                                            var tab = tabs[tabId].tab;
                                            if (tab) {
                                                tab.addEventListener('click', function (e) {
                                                    e.preventDefault();
                                                    switchTab(tabId);
                                                });
                                            }
                                        });

                                        // Show medical record tab by default
                                        switchTab('medical-record');

                                        // Function to save notes
                                        window.saveNotes = function () {
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
                                                .then(function (response) {
                                                    if (!response.ok) {
                                                        throw new Error('Network response was not ok');
                                                    }
                                                    return response.text();
                                                })
                                                .then(function () {
                                                    showToast('Thành công', 'Ghi chú đã được lưu thành công!', 'success');
                                                })
                                                .catch(function () {
                                                    showToast('Lỗi', 'Có lỗi xảy ra khi lưu ghi chú. Vui lòng thử lại!', 'danger');
                                                })
                                                .finally(function () {
                                                    saveButton.innerHTML = originalText;
                                                    saveButton.disabled = false;
                                                });
                                        };

                                        // Function to show toast notification (moved to global scope later)
                                        // showToast function moved to global scope below

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

                                        // Load medications on page load
                                        if (typeof loadMedications === 'function') {
                                            loadMedications();
                                        }

                                        // Add prescription button
                                        const addPrescriptionBtn = document.getElementById('addPrescriptionBtn');
                                        if (addPrescriptionBtn) {
                                            addPrescriptionBtn.addEventListener('click', function () {
                                                if (typeof showPrescriptionForm === 'function') {
                                                    showPrescriptionForm();
                                                }
                                            });
                                        }

                                        // Cancel button
                                        const cancelPrescriptionBtn = document.getElementById('cancelPrescriptionBtn');
                                        if (cancelPrescriptionBtn) {
                                            cancelPrescriptionBtn.addEventListener('click', function () {
                                                if (typeof hidePrescriptionForm === 'function') {
                                                    hidePrescriptionForm();
                                                }
                                            });
                                        }

                                        // Form submission
                                        const prescriptionForm = document.getElementById('prescriptionForm');
                                        if (prescriptionForm) {
                                            prescriptionForm.addEventListener('submit', function (e) {
                                                e.preventDefault();
                                                if (typeof savePrescriptions === 'function') {
                                                    savePrescriptions();
                                                }
                                            });
                                        }
                                    });

                                    // Variables for prescription management
                                    let prescriptionRowCount = 0;
                                    let allMedications = [];
                                    let prescriptionData = [];

                                    // Function to handle network errors
                                    async function handleResponse(response, errorMessage) {
                                        if (!response.ok) {
                                            let error = errorMessage;
                                            try {
                                                const data = await response.json();
                                                error = data.message || errorMessage;
                                            } catch (e) {
                                                try {
                                                    error = await response.text() || errorMessage;
                                                } catch (e2) {
                                                    // Use default error message
                                                }
                                            }
                                            throw new Error(error);
                                        }
                                        return response.json();
                                    }

                                    // Function to show error message
                                    function showError(message) {
                                        const errorDiv = document.createElement('div');
                                        errorDiv.className = 'alert alert-danger alert-dismissible fade show';
                                        errorDiv.innerHTML = `
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        `;
                                        const container = document.getElementById('prescriptionFormContainer');
                                        container.insertBefore(errorDiv, container.firstChild);

                                        // Auto dismiss after 5 seconds
                                        setTimeout(() => {
                                            if (errorDiv.parentNode) {
                                                errorDiv.remove();
                                            }
                                        }, 5000);
                                    }

                                    // Function to show success message
                                    function showSuccess(message) {
                                        const successDiv = document.createElement('div');
                                        successDiv.className = 'alert alert-success alert-dismissible fade show';
                                        successDiv.innerHTML = `
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        `;
                                        const container = document.getElementById('prescriptionFormContainer');
                                        container.insertBefore(successDiv, container.firstChild);

                                        // Auto dismiss after 3 seconds
                                        setTimeout(() => {
                                            if (successDiv.parentNode) {
                                                successDiv.remove();
                                            }
                                        }, 3000);
                                    }

                                    // Function to load medications with improved error handling
                                    async function loadMedications() {
                                        try {
                                            console.log('Loading medications from API...');
                                            const controller = new AbortController();
                                            const timeoutId = setTimeout(() => controller.abort(), 5000); // 5 second timeout

                                            const response = await fetch('/api/medications', {
                                                signal: controller.signal
                                            });
                                            clearTimeout(timeoutId);

                                            console.log('Medications response status:', response.status);
                                            const data = await handleResponse(response, 'Không thể tải danh sách thuốc');
                                            allMedications = data;
                                            console.log('Medications loaded from API:', allMedications.length, 'items');
                                        } catch (error) {
                                            console.warn('Error loading medications from API:', error.message);
                                            // Use mock data if API fails for testing
                                            allMedications = [
                                                {
                                                    medicationID: 1,
                                                    medicationName: 'Paracetamol',
                                                    genericName: 'Acetaminophen',
                                                    stockQuantity: 100,
                                                    contraindications: 'Dị ứng Paracetamol'
                                                },
                                                {
                                                    medicationID: 2,
                                                    medicationName: 'Amoxicillin',
                                                    genericName: 'Amoxicillin trihydrate',
                                                    stockQuantity: 50,
                                                    contraindications: 'Dị ứng Penicillin'
                                                },
                                                {
                                                    medicationID: 3,
                                                    medicationName: 'Ibuprofen',
                                                    genericName: 'Ibuprofen',
                                                    stockQuantity: 75,
                                                    contraindications: 'Loét dạ dày'
                                                },
                                                {
                                                    medicationID: 4,
                                                    medicationName: 'Vitamin C',
                                                    genericName: 'Ascorbic acid',
                                                    stockQuantity: 200,
                                                    contraindications: null
                                                }
                                            ];
                                            console.log('Using mock data for medications:', allMedications.length, 'items');
                                            console.log('Mock medications:', allMedications);
                                        }
                                    }

                                    // Simple function to create prescription row with minimal HTML
                                    function createPrescriptionRow() {
                                        console.log('=== STARTING ROW CREATION ===');
                                        prescriptionRowCount++;
                                        const rowId = 'prescription-row-' + prescriptionRowCount;
                                        console.log('Target row ID:', rowId);

                                        const prescriptionRows = document.getElementById('prescriptionRows');
                                        console.log('Container found:', !!prescriptionRows);

                                        if (!prescriptionRows) {
                                            console.error('prescriptionRows element not found!');
                                            return;
                                        }

                                        // Create element using DOM API instead of innerHTML
                                        const rowDiv = document.createElement('div');
                                        rowDiv.id = rowId;
                                        rowDiv.className = 'prescription-row border rounded p-3 mb-3';

                                        // Simple inner HTML - only one prescription form
                                        rowDiv.innerHTML = `
             <div class="row">
                 <div class="col-md-6 mb-3">
                     <label class="form-label">Tên thuốc *</label>
                     <input type="text" class="form-control medication-search" placeholder="Tìm kiếm thuốc...">
                     <input type="hidden" class="medication-id">
                     <div class="search-results list-group d-none"></div>
                 </div>
                 <div class="col-md-3 mb-3">
                     <label class="form-label">Số lượng *</label>
                     <input type="number" class="form-control quantity" min="1" required>
                 </div>
                 <div class="col-md-3 mb-3">
                     <label class="form-label">Liều dùng *</label>
                     <input type="text" class="form-control dosage" placeholder="VD: 1 viên" required>
                 </div>
             </div>
             
             <div class="row">
                 <div class="col-md-4 mb-3">
                     <label class="form-label">Tần suất *</label>
                     <input type="text" class="form-control frequency" placeholder="VD: 2 lần/ngày" required>
                 </div>
                 <div class="col-md-4 mb-3">
                     <label class="form-label">Thời gian</label>
                     <input type="text" class="form-control duration" placeholder="VD: 7 ngày">
                 </div>
                 <div class="col-md-4 mb-3">
                     <label class="form-label">Hướng dẫn</label>
                     <input type="text" class="form-control instructions" placeholder="Hướng dẫn sử dụng">
                 </div>
             </div>
         `;

                                        console.log('Row element created:', rowDiv);
                                        console.log('Row ID set:', rowDiv.id);
                                        console.log('Row className:', rowDiv.className);

                                        // Append using DOM API
                                        prescriptionRows.appendChild(rowDiv);
                                        console.log('Row appended to container');

                                        // Immediate check
                                        const immediateCheck = document.getElementById(rowId);
                                        console.log('IMMEDIATE CHECK - Element found:', !!immediateCheck);

                                        if (immediateCheck) {
                                            console.log('✅ Row found immediately! Setting up...');
                                            try {
                                                setupMedicationSearch(rowId);
                                                setupFormValidation(rowId);
                                                updateRowNumbers();
                                                console.log('✅ Row setup completed successfully for:', rowId);
                                            } catch (error) {
                                                console.error('❌ Error during setup:', error);
                                            }
                                        } else {
                                            console.log('❌ Row not found immediately. Trying with delay...');

                                            // Multiple attempts with increasing delays
                                            let attempts = 0;
                                            const checkRow = function () {
                                                attempts++;
                                                console.log(`Attempt ${attempts}: Looking for ${rowId}...`);

                                                const delayed = document.getElementById(rowId);
                                                console.log(`Attempt ${attempts} result:`, !!delayed);

                                                if (delayed) {
                                                    console.log(`✅ Row found on attempt ${attempts}!`);
                                                    try {
                                                        setupMedicationSearch(rowId);
                                                        setupFormValidation(rowId);
                                                        updateRowNumbers();
                                                        console.log('✅ Setup completed on attempt', attempts);
                                                    } catch (error) {
                                                        console.error('❌ Setup error on attempt', attempts, ':', error);
                                                    }
                                                } else if (attempts < 5) {
                                                    console.log(`Retrying in ${attempts * 50}ms...`);
                                                    setTimeout(checkRow, attempts * 50);
                                                } else {
                                                    console.error('❌ FAILED: Row not found after 5 attempts');
                                                    console.log('Final DOM state:');
                                                    console.log('- All .prescription-row:', document.querySelectorAll('.prescription-row'));
                                                    console.log('- Container content:', prescriptionRows.innerHTML);
                                                }
                                            };

                                            setTimeout(checkRow, 50);
                                        }

                                        console.log('=== ROW CREATION END ===');
                                    }

                                    // Function to remove prescription row (not used anymore - single prescription only)
                                    function removePrescriptionRow(rowId) {
                                        console.log('removePrescriptionRow called but not implemented for single prescription mode');
                                    }

                                    // Function to update row numbers (not needed for single prescription)
                                    function updateRowNumbers() {
                                        console.log('updateRowNumbers called but not needed for single prescription mode');
                                    }

                                    // Function to setup medication search for a row
                                    function setupMedicationSearch(rowId) {
                                        const row = document.getElementById(rowId);
                                        if (!row) {
                                            console.error('Row element not found:', rowId);
                                            return;
                                        }

                                        const searchInput = row.querySelector('.medication-search');
                                        const searchResults = row.querySelector('.search-results');
                                        const medicationIdInput = row.querySelector('.medication-id');

                                        if (!searchInput || !searchResults || !medicationIdInput) {
                                            console.error('Required elements not found in row:', rowId, {
                                                searchInput: !!searchInput,
                                                searchResults: !!searchResults,
                                                medicationIdInput: !!medicationIdInput
                                            });
                                            return;
                                        }

                                        searchInput.addEventListener('focus', function () {
                                            if (allMedications.length > 0) {
                                                displayMedications(allMedications, searchResults);
                                            }
                                        });

                                        searchInput.addEventListener('input', function () {
                                            const searchTerm = this.value.toLowerCase().trim();
                                            if (searchTerm === '') {
                                                displayMedications(allMedications, searchResults);
                                                return;
                                            }
                                            const filteredMedications = allMedications.filter(function (med) {
                                                return (med.medicationName && med.medicationName.toLowerCase().includes(searchTerm)) ||
                                                    (med.genericName && med.genericName.toLowerCase().includes(searchTerm));
                                            });
                                            displayMedications(filteredMedications, searchResults);
                                        });

                                        searchResults.addEventListener('click', function (e) {
                                            const item = e.target.closest('.list-group-item');
                                            if (item) {
                                                const medId = item.dataset.id;
                                                const selectedMed = allMedications.find(m => m.medicationID == medId);
                                                if (selectedMed) {
                                                    searchInput.value = selectedMed.medicationName;
                                                    medicationIdInput.value = selectedMed.medicationID;
                                                    searchResults.classList.add('d-none');
                                                    // Validate form after medication selection
                                                    validatePrescriptionForm();
                                                }
                                            }
                                        });

                                        // Hide results when clicking outside
                                        document.addEventListener('click', function (e) {
                                            if (!row.contains(e.target)) {
                                                searchResults.classList.add('d-none');
                                            }
                                        });
                                    }

                                    // Function to setup form validation for a row
                                    function setupFormValidation(rowId) {
                                        const row = document.getElementById(rowId);
                                        if (!row) {
                                            console.error('Row element not found for validation:', rowId);
                                            return;
                                        }

                                        const inputs = row.querySelectorAll('.medication-search, .quantity, .dosage, .frequency');

                                        inputs.forEach(function (input) {
                                            input.addEventListener('input', validatePrescriptionForm);
                                            input.addEventListener('change', validatePrescriptionForm);
                                        });
                                    }

                                    // Function to display medications in search results
                                    function displayMedications(medications, resultsContainer) {
                                        if (medications && medications.length > 0) {
                                            const html = medications.map(function (med) {
                                                return '<div class="list-group-item list-group-item-action" data-id="' + med.medicationID + '">' +
                                                    '<div class="medication-info">' +
                                                    '<div>' +
                                                    '<div class="medication-name">' + (med.medicationName || 'Không có tên thuốc') + '</div>' +
                                                    '<div class="medication-details">' +
                                                    (med.genericName ? 'Tên gốc: ' + med.genericName + '<br/>' : '') +
                                                    (med.contraindications ? '<span class="text-danger">Chống chỉ định: ' + med.contraindications + '</span>' : '') +
                                                    '</div>' +
                                                    '</div>' +
                                                    '</div>' +
                                                    '</div>';
                                            }).join('');
                                            resultsContainer.innerHTML = html;
                                            resultsContainer.classList.remove('d-none');
                                        } else {
                                            resultsContainer.innerHTML = '<div class="list-group-item">Không tìm thấy thuốc</div>';
                                            resultsContainer.classList.remove('d-none');
                                        }
                                    }

                                    // Function to show prescription form
                                    function showPrescriptionForm() {
                                        console.log('Showing prescription form...');
                                        const addBtn = document.getElementById('addPrescriptionBtn');
                                        const form = document.getElementById('prescriptionForm');
                                        const container = document.getElementById('prescriptionFormContainer');

                                        console.log('Elements found:', {
                                            addBtn: !!addBtn,
                                            form: !!form,
                                            container: !!container
                                        });

                                        if (addBtn) addBtn.style.display = 'none';
                                        if (form) form.style.display = 'block';
                                        if (container) container.classList.add('active');

                                        // Clear any existing rows first
                                        const prescriptionRows = document.getElementById('prescriptionRows');
                                        if (prescriptionRows) {
                                            prescriptionRows.innerHTML = '';
                                            prescriptionRowCount = 0;
                                        }

                                        // Create only one prescription row
                                        createPrescriptionRow();

                                        // Initial validation
                                        setTimeout(function () {
                                            validatePrescriptionForm();
                                        }, 100);
                                    }

                                    // Function to hide prescription form
                                    function hidePrescriptionForm() {
                                        document.getElementById('addPrescriptionBtn').style.display = 'block';
                                        document.getElementById('prescriptionForm').style.display = 'none';
                                        document.getElementById('prescriptionFormContainer').classList.remove('active');
                                        document.getElementById('prescriptionRows').innerHTML = '';
                                        prescriptionRowCount = 0;

                                        // Clear any error/success messages
                                        const alerts = document.querySelectorAll('#prescriptionFormContainer .alert');
                                        alerts.forEach(function (alert) {
                                            alert.remove();
                                        });

                                        // Restore any temporarily hidden rows
                                        const hiddenRows = document.querySelectorAll('tr[data-prescription-id][style*="opacity"]');
                                        hiddenRows.forEach(function (row) {
                                            row.style.opacity = '';
                                            row.style.pointerEvents = '';
                                        });

                                        // Reset save button text
                                        const saveButton = document.getElementById('savePrescriptionBtn');
                                        if (saveButton) {
                                            saveButton.innerHTML = '<i class="bi bi-save me-1"></i>Lưu đơn thuốc';
                                        }
                                    }

                                    // Function to validate prescription form (single prescription)
                                    function validatePrescriptionForm() {
                                        const row = document.querySelector('.prescription-row');
                                        let isValid = false;

                                        if (row) {
                                            const medicationId = row.querySelector('.medication-id').value;
                                            const quantity = row.querySelector('.quantity').value;
                                            const dosage = row.querySelector('.dosage').value;
                                            const frequency = row.querySelector('.frequency').value;

                                            if (medicationId && quantity && dosage && frequency) {
                                                isValid = true;
                                            }
                                        }

                                        const saveButton = document.getElementById('savePrescriptionBtn');
                                        if (saveButton) {
                                            saveButton.disabled = !isValid;
                                        }

                                        return isValid;
                                    }

                                    // Function to collect prescription data (single prescription)
                                    function collectPrescriptionData() {
                                        const row = document.querySelector('.prescription-row');
                                        const prescriptions = [];

                                        if (row) {
                                            const medicationId = row.querySelector('.medication-id').value;
                                            const quantity = row.querySelector('.quantity').value;
                                            const dosage = row.querySelector('.dosage').value;
                                            const frequency = row.querySelector('.frequency').value;
                                            const duration = row.querySelector('.duration').value;
                                            const instructions = row.querySelector('.instructions').value;
                                            const editId = row.getAttribute('data-edit-id');

                                            if (medicationId && quantity && dosage && frequency) {
                                                const prescriptionData = {
                                                    medication_id: parseInt(medicationId),
                                                    quantity: parseInt(quantity),
                                                    dosage: dosage,
                                                    frequency: frequency,
                                                    duration: duration || null,
                                                    instructions: instructions || null
                                                };

                                                // If editing, include the prescription ID
                                                if (editId) {
                                                    prescriptionData.prescription_id = parseInt(editId);
                                                }

                                                prescriptions.push(prescriptionData);
                                            }
                                        }

                                        return prescriptions;
                                    }

                                    // Function to remove prescription row
                                    function removePrescriptionRow(rowId) {
                                        document.getElementById(rowId).remove();
                                        updateRowNumbers();

                                        if (document.querySelectorAll('.prescription-row').length === 0) {
                                            hidePrescriptionForm();
                                        }
                                    }

                                    // Function to validate prescription data
                                    function validatePrescriptionData(prescriptions) {
                                        for (let i = 0; i < prescriptions.length; i++) {
                                            const prescription = prescriptions[i];
                                            const selectedMed = allMedications.find(m => m.medicationID == prescription.medication_id);

                                            if (!selectedMed) {
                                                throw new Error(`Không tìm thấy thông tin thuốc ở dòng ${i + 1}. Vui lòng thử lại.`);
                                            }

                                            if (selectedMed.stockQuantity !== undefined && prescription.quantity > selectedMed.stockQuantity) {
                                                throw new Error(`Số lượng yêu cầu ở dòng ${i + 1} (${prescription.quantity}) vượt quá khả năng cung cấp của thuốc ${selectedMed.medicationName}. Vui lòng điều chỉnh lại.`);
                                            }
                                        }
                                        return true;
                                    }

                                    // Function to save prescriptions (following doctor-prescription.jsp logic)
                                    async function savePrescriptions() {
                                        const prescriptions = collectPrescriptionData();

                                        if (prescriptions.length === 0) {
                                            showError('Vui lòng thêm ít nhất một thuốc');
                                            return;
                                        }

                                        // Declare variables outside try block to avoid scope issues
                                        const saveButton = document.getElementById('savePrescriptionBtn');
                                        const originalButtonText = saveButton ? saveButton.innerHTML : '<i class="bi bi-save me-1"></i>Lưu đơn thuốc';

                                        try {
                                            // Validate prescription data
                                            validatePrescriptionData(prescriptions);

                                            // Disable save button
                                            if (saveButton) {
                                                saveButton.disabled = true;
                                                saveButton.innerHTML = '<i class="bi bi-hourglass-split"></i> Đang lưu...';
                                            }

                                            // Save each prescription individually (like doctor-prescription.jsp)
                                            const savedPrescriptions = [];
                                            for (let i = 0; i < prescriptions.length; i++) {
                                                const prescription = prescriptions[i];

                                                console.log('Saving prescription', i + 1, ':', prescription);

                                                const appointmentId = '${appointment.appointmentID}';
                                                const url = '/doctor/appointments/' + appointmentId + '/prescriptions/save';
                                                console.log('Making request to:', url);

                                                // Validate required data
                                                const examinationId = '${examination != null ? examination.examinationID : ""}';
                                                const doctorId = '${examination != null && examination.doctor != null ? examination.doctor.doctorID : ""}';

                                                if (!examinationId || !doctorId) {
                                                    throw new Error('Thiếu thông tin khám bệnh hoặc bác sĩ. Vui lòng tạo bệnh án trước.');
                                                }

                                                const requestData = {
                                                    prescription_id: prescription.prescription_id || null,
                                                    medication_id: prescription.medication_id,
                                                    examination_id: parseInt(examinationId),
                                                    prescribed_by: parseInt(doctorId),
                                                    quantity: prescription.quantity,
                                                    dosage: prescription.dosage,
                                                    frequency: prescription.frequency,
                                                    duration: prescription.duration,
                                                    instructions: prescription.instructions,
                                                    is_refillable: false,
                                                    status: 'PENDING'
                                                };
                                                console.log('Request data:', requestData);

                                                const response = await fetch(url, {
                                                    method: 'POST',
                                                    headers: {
                                                        'Content-Type': 'application/json',
                                                        'X-CSRF-TOKEN': '${_csrf.token}'
                                                    },
                                                    body: JSON.stringify(requestData)
                                                });

                                                console.log('Response status for prescription', i + 1, ':', response.status);
                                                console.log('Response headers:', [...response.headers.entries()]);

                                                if (response.status >= 200 && response.status < 300) {
                                                    const contentType = response.headers.get('content-type');
                                                    console.log('Response content-type:', contentType);

                                                    if (contentType && contentType.includes('application/json')) {
                                                        const data = await response.json();
                                                        console.log('Response data:', data);

                                                        if (data.success) {
                                                            savedPrescriptions.push(prescription);
                                                            console.log('✅ Prescription', i + 1, 'saved successfully');
                                                        } else {
                                                            throw new Error(`Lỗi lưu thuốc ${i + 1}: ${data.message || 'Không thể lưu đơn thuốc'}`);
                                                        }
                                                    } else {
                                                        const text = await response.text();
                                                        console.log('Response text:', text);
                                                        throw new Error(`Lỗi lưu thuốc ${i + 1}: Unexpected response format - ${text.substring(0, 200)}`);
                                                    }
                                                } else {
                                                    const errorText = await response.text();
                                                    console.log('Error response text:', errorText);
                                                    throw new Error(`Lỗi lưu thuốc ${i + 1}: HTTP ${response.status} - ${errorText || 'Không thể lưu đơn thuốc'}`);
                                                }
                                            }

                                            console.log('✅ All prescriptions saved:', savedPrescriptions.length);
                                            showSuccess(`Đã lưu thành công ${savedPrescriptions.length} đơn thuốc!`);

                                            // Hide form and reload page
                                            hidePrescriptionForm();
                                            setTimeout(function () {
                                                console.log('Reloading page to show updated prescriptions...');
                                                window.location.reload();
                                            }, 1500);

                                        } catch (error) {
                                            console.error('Error saving prescriptions:', error);
                                            showError(error.message);
                                        } finally {
                                            // Re-enable save button
                                            if (saveButton) {
                                                saveButton.disabled = false;
                                                saveButton.innerHTML = originalButtonText;
                                            }
                                        }
                                    }

                                    // Function to edit prescription inline
                                    function editPrescriptionInline(prescriptionId) {
                                        // Get prescription data from the table row
                                        const row = document.querySelector(`tr[data-prescription-id="${prescriptionId}"]`);
                                        if (!row) {
                                            showToast('Lỗi', 'Không tìm thấy đơn thuốc để chỉnh sửa', 'danger');
                                            return;
                                        }

                                        // Extract data from the row
                                        const medicationName = row.querySelector('td:nth-child(2) strong').textContent;
                                        const quantity = row.querySelector('td:nth-child(3)').textContent;
                                        const dosage = row.querySelector('td:nth-child(4)').textContent;
                                        const frequency = row.querySelector('td:nth-child(5)').textContent;
                                        const duration = row.querySelector('td:nth-child(6)').textContent;
                                        const instructions = row.querySelector('td:nth-child(7) .text-muted').textContent;

                                        // Show prescription form
                                        showPrescriptionForm();

                                        // Wait for form to be created then populate it
                                        setTimeout(function () {
                                            const prescriptionRow = document.querySelector('.prescription-row');
                                            if (prescriptionRow) {
                                                // Find the medication in allMedications array
                                                const medication = allMedications.find(m => m.medicationName === medicationName);
                                                if (medication) {
                                                    prescriptionRow.querySelector('.medication-search').value = medicationName;
                                                    prescriptionRow.querySelector('.medication-id').value = medication.medicationID;
                                                }

                                                prescriptionRow.querySelector('.quantity').value = quantity;
                                                prescriptionRow.querySelector('.dosage').value = dosage;
                                                prescriptionRow.querySelector('.frequency').value = frequency;
                                                prescriptionRow.querySelector('.duration').value = duration;
                                                prescriptionRow.querySelector('.instructions').value = instructions.replace('Không có hướng dẫn', '');

                                                // Store the prescription ID for updating
                                                prescriptionRow.setAttribute('data-edit-id', prescriptionId);

                                                // Update button text
                                                const saveButton = document.getElementById('savePrescriptionBtn');
                                                if (saveButton) {
                                                    saveButton.innerHTML = '<i class="bi bi-save me-1"></i>Cập nhật đơn thuốc';
                                                }

                                                // Validate form
                                                validatePrescriptionForm();

                                                // Hide the original row temporarily
                                                row.style.opacity = '0.5';
                                                row.style.pointerEvents = 'none';
                                            }
                                        }, 200);
                                    }

                                    // Function to delete prescription
                                    function deletePrescription(prescriptionId) {
                                        if (confirm('Bạn có chắc chắn muốn xóa đơn thuốc này không?')) {
                                            const appointmentId = '${appointment.appointmentID}';
                                            const deleteUrl = '/doctor/appointments/' + appointmentId + '/prescriptions/' + prescriptionId + '/delete';
                                            console.log('Making delete request to:', deleteUrl);

                                            fetch(deleteUrl, {
                                                method: 'POST',
                                                headers: {
                                                    'X-CSRF-TOKEN': '${_csrf.token}'
                                                }
                                            })
                                                .then(function (response) {
                                                    console.log('Response status:', response.status);
                                                    if (!response.ok) {
                                                        return response.text().then(function (text) {
                                                            throw new Error(text || 'Không thể xóa đơn thuốc');
                                                        });
                                                    }
                                                    return response.json();
                                                })
                                                .then(function (data) {
                                                    console.log('Success response:', data);
                                                    if (data.success) {
                                                        showToast('Thành công', 'Đơn thuốc đã được xóa thành công!', 'success');
                                                        // Remove row from table
                                                        const row = document.querySelector(`tr[data-prescription-id="${prescriptionId}"]`);
                                                        if (row) {
                                                            row.remove();
                                                            // Update row numbers in table
                                                            const tableRows = document.querySelectorAll('#existingPrescriptions tr');
                                                            tableRows.forEach((tr, index) => {
                                                                const firstCell = tr.querySelector('td:first-child');
                                                                if (firstCell) {
                                                                    firstCell.textContent = index + 1;
                                                                }
                                                            });

                                                            // Show empty state if no prescriptions left
                                                            if (tableRows.length === 0) {
                                                                document.querySelector('.prescription-list').style.display = 'none';
                                                                document.getElementById('emptyPrescriptionState').style.display = 'block';
                                                            }
                                                        }
                                                    } else {
                                                        throw new Error(data.message || 'Có lỗi xảy ra khi xóa đơn thuốc');
                                                    }
                                                })
                                                .catch(function (error) {
                                                    console.error('Error:', error);
                                                    showToast('Lỗi', 'Có lỗi xảy ra khi xóa đơn thuốc: ' + error.message, 'danger');
                                                });
                                        }
                                    }

                                    // Function to switch to prescription tab and show form
                                    function switchToPrescriptionTab() {
                                        console.log('Switching to prescription tab...');
                                        // Switch to prescription tab
                                        if (typeof switchTab === 'function') {
                                            switchTab('prescription');
                                        } else {
                                            console.error('switchTab function not found!');
                                        }

                                        // Wait a bit for tab to load, then show the prescription form
                                        setTimeout(function () {
                                            const addBtn = document.getElementById('addPrescriptionBtn');
                                            console.log('Add button found:', !!addBtn, 'Display:', addBtn ? addBtn.style.display : 'N/A');
                                            if (addBtn && addBtn.style.display !== 'none') {
                                                showPrescriptionForm();
                                            } else {
                                                console.log('Add button not available or hidden');
                                            }
                                        }, 100);
                                    }

                                    // Debug function to check page state
                                    function debugPageState() {
                                        console.log('===== PAGE DEBUG STATE =====');
                                        console.log('All required elements:');
                                        console.log('- addPrescriptionBtn:', !!document.getElementById('addPrescriptionBtn'));
                                        console.log('- prescriptionForm:', !!document.getElementById('prescriptionForm'));
                                        console.log('- prescriptionFormContainer:', !!document.getElementById('prescriptionFormContainer'));
                                        console.log('- prescriptionRows:', !!document.getElementById('prescriptionRows'));
                                        console.log('- savePrescriptionBtn:', !!document.getElementById('savePrescriptionBtn'));

                                        const prescriptionRows = document.getElementById('prescriptionRows');
                                        if (prescriptionRows) {
                                            console.log('- prescriptionRows content:', prescriptionRows.innerHTML);
                                            console.log('- prescriptionRows children:', prescriptionRows.children);
                                        }

                                        console.log('Available functions:');
                                        console.log('- showPrescriptionForm:', typeof showPrescriptionForm);
                                        console.log('- createPrescriptionRow:', typeof createPrescriptionRow);
                                        console.log('- setupMedicationSearch:', typeof setupMedicationSearch);
                                        console.log('- displayMedications:', typeof displayMedications);

                                        console.log('Global variables:');
                                        console.log('- allMedications:', allMedications ? allMedications.length + ' items' : 'undefined');
                                        console.log('- prescriptionRowCount:', prescriptionRowCount);

                                        console.log('Current prescription rows in DOM:', document.querySelectorAll('.prescription-row'));
                                        console.log('================================');
                                    }

                                    // Test function to manually create a row
                                    function testCreateRow() {
                                        console.log('===== TESTING ROW CREATION =====');
                                        const container = document.getElementById('prescriptionRows');
                                        console.log('Container found:', !!container);

                                        if (container) {
                                            const testId = 'test-row-' + Date.now();
                                            const testHtml = `<div id="${testId}" class="prescription-row">Test Row</div>`;

                                            console.log('Inserting test HTML...');
                                            container.insertAdjacentHTML('beforeend', testHtml);

                                            const found = document.getElementById(testId);
                                            console.log('Test row found:', !!found);
                                            console.log('Container content:', container.innerHTML);

                                            if (found) {
                                                found.remove();
                                                console.log('Test row removed successfully');
                                            }
                                        }
                                        console.log('================================');
                                    }

                                    // Initialize with debug
                                    document.addEventListener('DOMContentLoaded', function () {
                                        console.log('DOM content loaded - initializing prescription system...');

                                        setTimeout(function () {
                                            debugPageState();
                                            loadMedications();

                                            // Add event listeners
                                            const savePrescriptionBtn = document.getElementById('savePrescriptionBtn');
                                            const cancelPrescriptionBtn = document.getElementById('cancelPrescriptionBtn');
                                            const addPrescriptionBtn = document.getElementById('addPrescriptionBtn');
                                            const prescriptionForm = document.getElementById('prescriptionForm');

                                            // Form submit event listener
                                            if (prescriptionForm) {
                                                console.log('Setting up form submit event listener');
                                                prescriptionForm.addEventListener('submit', function (e) {
                                                    e.preventDefault();
                                                    console.log('Form submitted');
                                                    savePrescriptions();
                                                });
                                            }

                                            if (savePrescriptionBtn) {
                                                console.log('Setting up save button event listener');
                                                savePrescriptionBtn.addEventListener('click', function (e) {
                                                    e.preventDefault();
                                                    console.log('Save button clicked');
                                                    savePrescriptions();
                                                });
                                            } else {
                                                console.warn('Save prescription button not found');
                                            }

                                            if (cancelPrescriptionBtn) {
                                                console.log('Setting up cancel button event listener');
                                                cancelPrescriptionBtn.addEventListener('click', function (e) {
                                                    e.preventDefault();
                                                    console.log('Cancel button clicked');
                                                    hidePrescriptionForm();
                                                });
                                            }

                                            if (addPrescriptionBtn) {
                                                console.log('Setting up add button event listener');
                                                addPrescriptionBtn.addEventListener('click', function (e) {
                                                    e.preventDefault();
                                                    console.log('Add prescription button clicked');
                                                    showPrescriptionForm();
                                                });
                                            }

                                        }, 500); // Wait for all elements to be rendered
                                    });

                                    // Make functions globally available for onclick handlers
                                    window.removePrescriptionRow = removePrescriptionRow;
                                    window.createPrescriptionRow = createPrescriptionRow;
                                    window.editPrescriptionInline = editPrescriptionInline;
                                    window.deletePrescription = deletePrescription;
                                    window.switchToPrescriptionTab = switchToPrescriptionTab;
                                    window.debugPageState = debugPageState;
                                    window.testCreateRow = testCreateRow;
                                    window.showPrescriptionForm = showPrescriptionForm;
                                    window.savePrescriptions = savePrescriptions;
                                    window.hidePrescriptionForm = hidePrescriptionForm;

                                    console.log('Prescription functions loaded:', {
                                        removePrescriptionRow: typeof window.removePrescriptionRow,
                                        createPrescriptionRow: typeof window.createPrescriptionRow,
                                        editPrescriptionInline: typeof window.editPrescriptionInline,
                                        deletePrescription: typeof window.deletePrescription,
                                        switchToPrescriptionTab: typeof window.switchToPrescriptionTab,
                                        showPrescriptionForm: typeof showPrescriptionForm,
                                        loadMedications: typeof loadMedications,
                                        debugPageState: typeof debugPageState,
                                        testCreateRow: typeof testCreateRow
                                    });
                                </script>
                            </body>

                            </html>