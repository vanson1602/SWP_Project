<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Kết Quả Khám Bệnh</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="/resources/css/appointment-style.css">
    <link rel="stylesheet" href="/resources/css/common.css">
</head>
<style>
    :root {
        --primary-color: #4e73df;
        --secondary-color: #858796;
        --success-color: #1cc88a;
        --info-color: #36b9cc;
        --warning-color: #f6c23e;
        --danger-color: #e74a3b;
        --light-color: #f8f9fc;
        --dark-color: #2c3e50;
        --border-color: #e3e6f0;
        --bg-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        --bg-light: rgba(102, 126, 234, 0.1);
    }

    .empty-state {
    text-align: center;
    padding: 2rem;
        color: var(--secondary-color);
}

.empty-state i {
    font-size: 4rem;
        color: var(--danger-color);
}

.tab-content {
        border: 1px solid var(--border-color);
    border-top: none;
        padding: 2rem;
        border-radius: 0 0 1rem 1rem;
        background-color: #fff;
        box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
    }

    .nav-tabs {
        border: none;
        display: flex;
        background: transparent;
        padding: 0;
        border-radius: 0;
        box-shadow: none;
        margin-bottom: 1rem;
        justify-content: flex-start;
    }

    .nav-tabs .nav-item {
        margin: 0 0.25rem 0 0;
    }

    .nav-tabs .nav-item:last-child {
        margin-right: 0;
}

.nav-tabs .nav-link {
        color: var(--secondary-color);
        border: 2px solid var(--border-color);
        padding: 1rem 2rem;
        border-radius: 1rem;
        font-weight: 600;
        transition: all 0.3s ease-in-out;
        display: flex;
        align-items: center;
        gap: 0.75rem;
        background: white;
        min-width: 160px;
        justify-content: center;
        text-decoration: none;
        position: relative;
        overflow: hidden;
    }

    .nav-tabs .nav-link::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
        transition: left 0.6s;
    }

    .nav-tabs .nav-link:hover::before {
        left: 100%;
    }

    .nav-tabs .nav-link i {
        font-size: 1.2rem;
        transition: transform 0.3s ease;
    }

    .nav-tabs .nav-link:hover {
        color: var(--primary-color);
        background: var(--light-color);
        border-color: var(--primary-color);
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(78, 115, 223, 0.15);
    }

    .nav-tabs .nav-link:hover i {
        transform: scale(1.1);
}

.nav-tabs .nav-link.active {
        color: white;
        background: linear-gradient(135deg, var(--primary-color), #3658d4);
        border-color: var(--primary-color);
        font-weight: 700;
        box-shadow: 0 10px 30px rgba(78, 115, 223, 0.3);
        transform: translateY(-3px);
    }

    .nav-tabs .nav-link.active i {
        transform: scale(1.15);
    }

    .medical-record-details {
        background-color: #fff;
        border-radius: 1rem;
    }

    .vital-signs, .symptoms-diagnosis, .treatment-plan {
        background-color: var(--light-color);
        border-radius: 0.75rem;
        padding: 1.5rem;
        margin-bottom: 1rem;
        border: 1px solid var(--border-color);
        transition: all 0.2s ease-in-out;
    }

    .vital-signs:hover, .symptoms-diagnosis:hover, .treatment-plan:hover {
        box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
        transform: translateY(-2px);
    }

    .vital-signs p, .symptoms-diagnosis p, .treatment-plan p {
        margin-bottom: 0.75rem;
        line-height: 1.6;
        color: var(--dark-color);
    }

    .text-primary {
        color: var(--primary-color) !important;
        margin-bottom: 1rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .text-primary i {
        font-size: 1.2rem;
    }

    .table {
        background-color: #fff;
        border-radius: 0.5rem;
        overflow: hidden;
    }

    .table thead th {
        background-color: var(--light-color);
        border-bottom: 2px solid var(--border-color);
        padding: 1rem;
        font-weight: 600;
        color: var(--dark-color);
    }

    .table tbody td {
        padding: 1rem;
        vertical-align: middle;
        color: var(--dark-color);
}

.badge {
        font-size: 0.875rem;
        padding: 0.5em 1em;
        border-radius: 0.5rem;
    }

    .page-title {
        color: white;
        font-weight: 700;
        margin-bottom: 2rem;
        position: relative;
        padding-bottom: 0.5rem;
        text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        font-size: 2.5rem;
    }

    .page-title:after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        width: 80px;
        height: 4px;
        background: linear-gradient(90deg, rgba(255,255,255,0.8), rgba(255,255,255,0.4));
        border-radius: 3px;
    }

    .btn-secondary {
        background-color: var(--secondary-color);
        border: none;
        padding: 0.75rem 1.5rem;
        font-weight: 500;
        border-radius: 0.5rem;
        transition: all 0.2s ease-in-out;
        color: white;
    }

    .btn-secondary:hover {
        background-color: #717584;
        transform: translateY(-1px);
        box-shadow: 0 4px 6px rgba(58, 59, 69, 0.15);
    }

    .header-section {
        background: var(--bg-gradient);
        min-height: 280px;
        padding: 2rem 0;
        position: relative;
        overflow: hidden;
    }

    .header-section::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 100" fill="white" opacity="0.1"><polygon points="0,0 0,100 1000,80 1000,0"/></svg>');
        background-size: cover;
    }

    .header-content {
        position: relative;
        z-index: 2;
    }

    .container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 1rem;
    }

    .content-section {
        background: white;
        margin-top: -80px;
        border-radius: 20px 20px 0 0;
        padding: 2rem;
        position: relative;
        z-index: 3;
        box-shadow: 0 -10px 30px rgba(0,0,0,0.1);
    }

            @media (max-width: 768px) {
            .container {
                padding: 0 0.5rem;
            }

            .header-section {
                min-height: 220px;
                padding: 1.5rem 0;
            }

            .page-title {
                font-size: 2rem;
                margin-bottom: 1.5rem;
            }

            .content-section {
                margin-top: -60px;
                padding: 1.5rem;
                border-radius: 15px 15px 0 0;
            }
            
            .vital-signs, .symptoms-diagnosis, .treatment-plan {
                padding: 1rem;
            }
            
            .nav-tabs {
                flex-wrap: wrap;
                gap: 0.5rem;
            }
            
            .nav-tabs .nav-item {
                margin: 0;
                flex: 1;
                min-width: calc(50% - 0.25rem);
            }
            
            .nav-tabs .nav-link {
                padding: 0.75rem 1rem;
                white-space: nowrap;
                min-width: auto;
    font-size: 0.9rem;
            }
            
            .nav-tabs .nav-link i {
                font-size: 1rem;
            }
        }

    .examination-date {
        font-size: 1.1rem;
        margin-top: 0.5rem;
        color: rgba(255,255,255,0.9);
        font-weight: 500;
        text-shadow: 0 1px 2px rgba(0,0,0,0.2);
    }
    
    .page-title {
        display: flex;
        flex-direction: column;
        align-items: flex-start;
    }

    /* Prescription table styling */
    .prescription-table {
        background: white;
        border-radius: 0.75rem;
        border: 1px solid var(--border-color);
        box-shadow: 0 2px 10px rgba(0,0,0,0.08);
    }

    .prescription-table .table {
        background: white;
        border-radius: 0.75rem;
        overflow: hidden;
        margin-bottom: 0;
    }

    .prescription-table .table thead th {
        background-color: var(--light-color);
        color: var(--dark-color);
        border: none;
        padding: 1rem;
        font-weight: 600;
        text-align: center;
        font-size: 0.95rem;
        border-bottom: 2px solid var(--border-color);
    }

    .prescription-table .table tbody td {
        padding: 1rem;
        border-bottom: 1px solid #f1f3f4;
        vertical-align: middle;
        text-align: center;
    }

    .prescription-table .table tbody tr:hover {
        background-color: var(--light-color);
        transition: all 0.2s ease;
    }

    .medication-name {
        font-weight: 600;
        color: var(--dark-color);
        font-size: 1.05rem;
        margin-bottom: 0.5rem;
    }

    .contraindications {
        background-color: #dc3545;
        color: white;
        padding: 0.4rem 0.6rem;
        border-radius: 0.3rem;
        font-size: 0.8rem;
        font-weight: 500;
        display: inline-block;
        margin-top: 0.25rem;
    }

    .contraindications::before {
        content: "⚠ ";
        margin-right: 0.25rem;
    }

    .no-contraindications {
        color: var(--success-color);
        font-style: italic;
        font-size: 0.85rem;
    }

    .quantity-info {
        background-color: #e3f2fd;
        color: #1976d2;
        padding: 0.3rem 0.6rem;
        border-radius: 0.3rem;
        font-weight: 600;
        display: inline-block;
    }

    .dosage-info {
        font-weight: 500;
        color: var(--dark-color);
    }

    .frequency-info {
        background-color: #fff3e0;
        color: #f57c00;
        padding: 0.3rem 0.6rem;
        border-radius: 0.3rem;
        font-weight: 500;
    }

    .duration-info {
        background-color: #e8f5e8;
        color: #2e7d32;
        padding: 0.3rem 0.6rem;
        border-radius: 0.3rem;
        font-weight: 500;
    }

    .instructions-text {
        background-color: #f5f5f5;
        padding: 0.5rem 0.75rem;
        border-radius: 0.3rem;
        color: var(--dark-color);
        font-style: italic;
        border-left: 3px solid var(--primary-color);
    }

    /* Medical Record Styling */
    .medical-record-details {
        background: white;
        border-radius: 0.75rem;
        border: 1px solid var(--border-color);
        box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        padding: 1.5rem;
    }

    .vital-signs, .symptoms-diagnosis, .treatment-plan {
        background-color: white;
        border-radius: 0.5rem;
        padding: 1.5rem;
        margin-bottom: 1rem;
        border: 1px solid var(--border-color);
        transition: all 0.2s ease-in-out;
        box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        height: 100%;
        display: flex;
        flex-direction: column;
    }

    .vital-signs:hover, .symptoms-diagnosis:hover, .treatment-plan:hover {
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        transform: translateY(-1px);
    }

    .vital-signs {
        border-left: 4px solid #e91e63;
    }

    .symptoms-diagnosis {
        border-left: 4px solid #2196f3;
    }

    .treatment-plan {
        border-left: 4px solid #4caf50;
    }

    .medical-record-details .row {
        display: flex;
        align-items: stretch;
    }

    .medical-record-details .col-md-6 {
        display: flex;
        flex-direction: column;
    }

    .medical-record-details .col-md-6 > h5 {
        margin-bottom: 1.5rem;
    }

    .medical-record-details .col-md-6 > div {
        flex: 1;
    }

    .vital-signs p, .symptoms-diagnosis p, .treatment-plan p {
        margin-bottom: 0.75rem;
        line-height: 1.6;
        color: var(--dark-color);
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }

    .vital-signs p i, .symptoms-diagnosis p i, .treatment-plan p i {
        width: 16px;
        height: 16px;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
        font-size: 14px;
    }

    .vital-signs p:last-child, .symptoms-diagnosis p:last-child, .treatment-plan p:last-child {
        margin-bottom: 0;
    }

    .text-primary {
        color: var(--primary-color) !important;
        margin-bottom: 1.5rem;
        display: flex;
        align-items: center;
        gap: 0.75rem;
        font-size: 1.1rem;
        font-weight: 600;
        border-bottom: 2px solid #f0f0f0;
        padding-bottom: 0.75rem;
    }

    .text-primary i {
        font-size: 1.3rem;
        color: var(--primary-color);
    }

    /* Individual value styling */
    .vital-value {
        color: #c2185b;
        font-weight: 600;
        margin-left: auto;
    }

    .symptom-value {
        color: #1976d2;
        font-weight: 500;
        flex: 1;
        text-align: left;
        margin-left: 0.5rem;
    }

    .diagnosis-value {
        color: #2e7d32;
        font-weight: 500;
        flex: 1;
        text-align: left;
        margin-left: 0.5rem;
    }

    .icd-code {
        color: #f57c00;
        font-weight: 600;
        display: inline-block;
        margin-top: 0.25rem;
    }

    .follow-up-date {
        color: #7b1fa2;
        font-weight: 600;
        display: inline-block;
    }

    .text-purple {
        color: #7b1fa2 !important;
}
</style>
<body>
    <jsp:include page="../shared/header.jsp" />
    
    <!-- Header Section -->
<div class="header-section">
    <div class="container">
        <div class="header-content">
            <h1 class="page-title mb-4">
                Kết Quả Khám Bệnh
                <c:if test="${not empty examination}">
                    <div class="examination-date">
                        Ngày khám: 
                        <fmt:parseDate value="${examination.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="examDate" />
                        <fmt:formatDate value="${examDate}" pattern="dd/MM/yyyy HH:mm"/>
                    </div>
                </c:if>
            </h1>
        </div>
    </div>
</div>

<!-- Content Section -->
<div class="content-section">
    <div class="container">
        <!-- Tabs Navigation -->
        <div class="mb-4">
        <ul class="nav nav-tabs" id="medicalResultsTab" role="tablist">
            <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="medical-record-tab" data-bs-toggle="tab" data-bs-target="#medical-record" type="button" role="tab">
                        <i class="bi bi-journal-medical"></i>Bệnh Án
                    </button>
            </li>
            <li class="nav-item" role="presentation">
                    <button class="nav-link" id="prescription-tab" data-bs-toggle="tab" data-bs-target="#prescription" type="button" role="tab">
                        <i class="bi bi-capsule"></i>Đơn Thuốc
                    </button>
            </li>
        </ul>
        </div>

        <!-- Tab Content -->
        <div class="tab-content" id="medicalResultsTabContent">
            <!-- Medical Record Tab -->
            <div class="tab-pane fade show active" id="medical-record" role="tabpanel">
                <div class="medical-record-content">
                    <c:choose>
                        <c:when test="${not empty examination}">
                            <div class="medical-record-details">
                                <div class="row g-4">
                                    <div class="col-md-6">
                                        <h5 class="text-primary"><i class="bi bi-heart-pulse"></i>Tổng quát</h5>
                                        <div class="vital-signs">
                                            <p><i class="bi bi-droplet-half text-danger"></i><strong>Huyết áp:</strong> <span class="vital-value">${examination.bloodPressureSystolic}/${examination.bloodPressureDiastolic} mmHg</span></p>
                                            <p><i class="bi bi-heart text-danger"></i><strong>Nhịp tim:</strong> <span class="vital-value">${examination.heartRate} bpm</span></p>
                                            <p><i class="bi bi-thermometer-half text-warning"></i><strong>Nhiệt độ:</strong> <span class="vital-value">${examination.temperature}°C</span></p>
                                            <p><i class="bi bi-lungs text-info"></i><strong>Nhịp thở:</strong> <span class="vital-value">${examination.respiratoryRate} lần/phút</span></p>
                                            <p><i class="bi bi-percent text-success"></i><strong>SpO2:</strong> <span class="vital-value">${examination.oxygenSaturation}%</span></p>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <h5 class="text-primary"><i class="bi bi-clipboard2-pulse"></i>Triệu chứng & Chẩn đoán</h5>
                                        <div class="symptoms-diagnosis">
                                            <p><i class="bi bi-exclamation-triangle text-warning"></i><strong>Triệu chứng:</strong> <span class="symptom-value">${examination.symptoms}</span></p>
                                            <p><i class="bi bi-arrow-right-circle text-primary"></i><strong>Triệu chứng chính:</strong> <span class="symptom-value">${examination.chiefComplaint}</span></p>
                                            <p><i class="bi bi-search text-info"></i><strong>Khám lâm sàng:</strong> <span class="diagnosis-value">${examination.physicalExamination}</span></p>
                                            <p><i class="bi bi-file-medical text-success"></i><strong>Chẩn đoán:</strong> <span class="diagnosis-value">${examination.diseaseDiagnosis}</span></p>
                                            <p><i class="bi bi-qr-code text-warning"></i><strong>Mã ICD:</strong> <span class="icd-code">${examination.icdDiagnosis.icdCode} - ${examination.icdDiagnosis.description}</span></p>
                                        </div>
                                    </div>
                                    <div class="col-12">
                                        <h5 class="text-primary"><i class="bi bi-journal-medical"></i>Kế hoạch điều trị</h5>
                                        <div class="treatment-plan">
                                            <p><i class="bi bi-bandaid text-success"></i><strong>Kế hoạch:</strong> <span class="diagnosis-value">${examination.conclusionTreatmentPlan}</span></p>
                                            <p class="mt-2"><i class="bi bi-calendar-event text-purple"></i><strong>Ngày tái khám:</strong> 
                                                <c:if test="${not empty examination.followUpDate}">
                                                    <span class="follow-up-date">
                                                        <fmt:parseDate value="${examination.followUpDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" />
                                                        <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </span>
                                                </c:if>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <i class="bi bi-clipboard-x"></i>
                                <p class="mt-3">Chưa có bệnh án cho lịch hẹn này.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Prescription Tab -->
            <div class="tab-pane fade" id="prescription" role="tabpanel">
                <div class="prescription-content">
                    <c:choose>
                        <c:when test="${not empty examination && not empty examination.prescriptions}">
                            <div class="prescription-table">
                                        <div class="table-responsive">
                                            <table class="table table-hover">
                                        <thead>
                                                    <tr>
                                                        <th>STT</th>
                                                        <th>Tên thuốc</th>
                                                        <th>Số lượng</th>
                                                        <th>Liều lượng</th>
                                                        <th>Tần suất</th>
                                                        <th>Thời gian dùng</th>
                                                <th>Hướng dẫn sử dụng</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="prescription" items="${examination.prescriptions}" varStatus="status">
                                                        <tr>
                                                    <td><strong>${status.index + 1}</strong></td>
                                                    <td>
                                                        <div class="medication-name">${prescription.medication.medicationName}</div>
                                                        <c:choose>
                                                            <c:when test="${not empty prescription.medication.contraindications}">
                                                                <div class="contraindications">${prescription.medication.contraindications}</div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="no-contraindications">Không có chống chỉ định</div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <span class="quantity-info">${prescription.quantity}</span>
                                                    </td>
                                                    <td>
                                                        <div class="dosage-info">${prescription.dosage}</div>
                                                    </td>
                                                    <td>
                                                        <span class="frequency-info">${prescription.frequency}</span>
                                                    </td>
                                                    <td>
                                                        <span class="duration-info">${prescription.duration}</span>
                                                    </td>
                                                            <td>
                                                                <c:choose>
                                                            <c:when test="${not empty prescription.instructions}">
                                                                <div class="instructions-text">${prescription.instructions}</div>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                <span class="text-muted">Không có hướng dẫn cụ thể</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                            <div class="empty-state">
                                <i class="bi bi-file-earmark-medical"></i>
                                        <p class="mt-3">Chưa có đơn thuốc nào được tạo</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Back Button -->
        <div class="mt-4">
            <a href="/appointments" class="btn btn-secondary">
                <i class="fas fa-arrow-left me-2"></i>Quay lại
            </a>
        </div>
        </div>
    </div>

<jsp:include page="../shared/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>