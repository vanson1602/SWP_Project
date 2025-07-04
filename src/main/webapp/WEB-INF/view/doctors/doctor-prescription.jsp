<%-- view/doctors/doctor-prescription.jsp --%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="dateUtils" uri="http://example.com/dateUtils" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link rel="stylesheet" href="/css/homepage.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <title>HealthCare+ - Kê Đơn Thuốc</title>
    <style>
        :root {
            --primary-color: #0d6efd;
            --secondary-color: #6c757d;
            --success-color: #198754;
            --danger-color: #dc3545;
            --light-bg: #f8f9fa;
            --border-color: #dee2e6;
        }

        body {
            background-color: var(--light-bg);
        }

        .prescription-section {
            padding: 2rem 0;
        }

        .card {
            border: none;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            margin-bottom: 1.5rem;
            border-radius: 0.5rem;
        }

        .card-title {
            color: var(--primary-color);
            font-weight: 600;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
        }

        .card-title i {
            margin-right: 0.5rem;
            font-size: 1.25rem;
        }

        .prescription-item {
            border: 1px solid var(--border-color);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border-radius: 1rem;
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.07);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .prescription-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(135deg, var(--primary-color), #6f42c1);
        }

        .prescription-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
            border-color: var(--primary-color);
        }

        .prescription-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #e9ecef;
        }

        .prescription-title {
            display: flex;
            align-items: center;
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--primary-color);
        }

        .prescription-title i {
            margin-right: 0.5rem;
            font-size: 1.4rem;
        }

        .prescription-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .prescription-field {
            display: flex;
            align-items: flex-start;
            padding: 0.75rem;
            background: rgba(255, 255, 255, 0.8);
            border-radius: 0.5rem;
            border-left: 3px solid var(--primary-color);
        }

        .prescription-field i {
            width: 24px;
            height: 24px;
            margin-right: 0.75rem;
            color: var(--primary-color);
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(13, 110, 253, 0.1);
            border-radius: 50%;
            flex-shrink: 0;
        }

        .prescription-field-content {
            flex: 1;
        }

        .prescription-field-label {
            font-weight: 600;
            color: #495057;
            font-size: 0.875rem;
            margin-bottom: 0.25rem;
        }

        .prescription-field-value {
            color: #212529;
            font-size: 0.95rem;
            margin: 0;
        }

        .prescription-actions {
            display: flex;
            gap: 0.75rem;
            justify-content: flex-end;
            padding-top: 1rem;
            border-top: 1px solid #e9ecef;
        }

        .prescription-actions .btn {
            border-radius: 0.5rem;
            padding: 0.5rem 1rem;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .prescription-actions .btn-outline-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(13, 110, 253, 0.3);
        }

        .prescription-actions .btn-outline-danger:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(220, 53, 69, 0.3);
        }

        .form-label {
            font-weight: 500;
            color: var(--secondary-color);
            display: flex;
            align-items: center;
        }

        .form-label i {
            margin-right: 0.5rem;
            color: var(--primary-color);
        }

        .form-control {
            border-radius: 0.375rem;
            border: 1px solid var(--border-color);
            padding: 0.5rem 0.75rem;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        }

        /* Custom number input styling */
        .quantity-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }

        .quantity-wrapper .form-control {
            text-align: center;
            padding-right: 30px;
            padding-left: 30px;
        }

        .quantity-btn {
            position: absolute;
            border: none;
            background: none;
            color: var(--primary-color);
            padding: 0.25rem 0.5rem;
            cursor: pointer;
            transition: color 0.2s;
        }

        .quantity-btn:hover {
            color: var(--primary-color);
        }

        .quantity-btn.minus {
            left: 0;
        }

        .quantity-btn.plus {
            right: 0;
        }

        /* Medication search results styling */
        .search-results {
            position: absolute;
            width: 100%;
            max-height: 300px;
            overflow-y: auto;
            background: white;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            z-index: 1000;
        }

        .search-results .list-group-item {
            cursor: pointer;
            padding: 10px 15px;
            border-left: none;
            border-right: none;
            transition: background-color 0.2s;
        }

        .search-results .list-group-item:hover {
            background-color: #f8f9fa;
        }

        .search-results .list-group-item:first-child {
            border-top: none;
        }

        .search-results .list-group-item:last-child {
            border-bottom: none;
        }

        .medication-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .medication-name {
            font-weight: 500;
        }

        .medication-details {
            color: #6c757d;
            font-size: 0.875rem;
        }

        .stock-badge {
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
        }

        .medication-form {
            position: relative;
        }

        /* Toast styling */
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1050;
        }

        .toast {
            background-color: white;
            border: none;
            box-shadow: 0 0.25rem 0.5rem rgba(0, 0, 0, 0.1);
        }

        /* Custom checkbox styling */
        .form-check {
            padding-left: 2rem;
        }

        .form-check-input {
            border-color: var(--primary-color);
        }

        .form-check-input:checked {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .form-check-label {
            display: flex;
            align-items: center;
        }

        .form-check-label i {
            margin-right: 0.5rem;
            color: var(--primary-color);
        }

        /* Button styling */
        .btn {
            padding: 0.5rem 1rem;
            border-radius: 0.375rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn i {
            font-size: 1.1em;
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-outline-danger {
            color: var(--danger-color);
            border-color: var(--danger-color);
        }

        .btn-outline-danger:hover {
            background-color: var(--danger-color);
            color: white;
        }

        /* Empty state styling */
        .empty-state {
            text-align: center;
            padding: 2rem;
            color: var(--secondary-color);
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: var(--primary-color);
        }

        .empty-state p {
            font-size: 1.1rem;
            margin-bottom: 0;
        }

        /* Row styling for form layout */
        .row {
            margin-bottom: 0.5rem;
        }

        .row .col-md-6 .mb-3 {
            margin-bottom: 1rem;
        }

        /* Responsive design for mobile */
        @media (max-width: 768px) {
            .row {
                margin-bottom: 1rem;
            }
            
            .col-md-6 .mb-3 {
                margin-bottom: 1.5rem;
            }
            
            .card {
                margin: 0.5rem;
            }
            
            .prescription-section {
                padding: 1rem 0;
            }

            .prescription-content {
                grid-template-columns: 1fr;
                gap: 0.75rem;
            }

            .prescription-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }

            .prescription-title {
                font-size: 1.1rem;
            }

            .prescription-actions {
                flex-direction: column;
                align-items: stretch;
            }

            .prescription-actions .btn {
                justify-content: center;
            }

            .prescription-item {
                padding: 1rem;
                margin-bottom: 1rem;
            }
        }

        /* Extra small devices */
        @media (max-width: 576px) {
            .prescription-field {
                padding: 0.5rem;
            }

            .prescription-field i {
                width: 20px;
                height: 20px;
                font-size: 1rem;
            }

            .prescription-field-label {
                font-size: 0.8rem;
            }

            .prescription-field-value {
                font-size: 0.9rem;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <jsp:include page="../shared/header-doctor.jsp" />

    <!-- Main Content -->
    <section class="prescription-section">
        <div class="container">
            <h1 class="page-title mb-4">Kê Đơn Thuốc</h1>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            <c:if test="${not empty appointment}">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Thông tin Lịch hẹn</h5>
                        <p><strong>Mã lịch hẹn:</strong> ${appointment.appointmentNumber}</p>
                        <p><strong>Bệnh nhân:</strong> ${appointment.patient.user.firstName} ${appointment.patient.user.lastName}</p>
                        <p><strong>Ngày khám:</strong> <fmt:formatDate value="${dateUtils:toDate(examination.examinationDate)}" pattern="dd/MM/yyyy HH:mm"/></p>
                    </div>
                </div>

                <!-- Prescription Form -->
                <div class="card mt-4">
                    <div class="card-body">
                        <h5 class="card-title">
                            <i class="bi bi-file-medical"></i>
                            ${not empty edit ? 'Sửa Đơn Thuốc' : 'Thêm Đơn Thuốc Mới'}
                        </h5>
                        <form id="prescriptionForm" action="/doctor/appointments/${appointment.appointmentID}/prescriptions/save" method="post">
                            <input type="hidden" name="_csrf" value="${_csrf.token}" />
                            <input type="hidden" name="prescriptionID" value="${prescription.prescriptionID}"/>
                            <div class="mb-3 medication-form">
                                <label for="medicationSearch" class="form-label">
                                    <i class="bi bi-capsule"></i>Tên thuốc
                                </label>
                                <input type="text" class="form-control" id="medicationSearch" 
                                       placeholder="Nhập tên thuốc để tìm kiếm" autocomplete="off" required/>
                                <input type="hidden" id="medicationID" name="medication.medicationID" value="${prescription.medication.medicationID}"/>
                                <div id="searchResults" class="search-results list-group d-none"></div>
                            </div>
                            <!-- Số lượng và Liều lượng -->
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="quantity" class="form-label">
                                            <i class="bi bi-123"></i>Số lượng
                                        </label>
                                        <input type="number" class="form-control" id="quantity" name="quantity" 
                                               min="1" required value="${prescription.quantity}"/>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="dosage" class="form-label">
                                            <i class="bi bi-droplet"></i>Liều lượng
                                        </label>
                                        <input type="text" class="form-control" id="dosage" name="dosage" 
                                               required maxlength="100" value="${prescription.dosage}"
                                               pattern="^[0-9]+\s+(viên|ml|mg|g|mcg|IU)/lần$"
                                               title="Vui lòng nhập theo định dạng: số + đơn vị/lần (ví dụ: 1 viên/lần, 5 ml/lần)"
                                               placeholder="VD: 1 viên/lần"/>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Tần suất và Thời gian dùng -->
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="frequency" class="form-label">
                                            <i class="bi bi-clock"></i>Tần suất
                                        </label>
                                        <input type="text" class="form-control" id="frequency" name="frequency" 
                                               required maxlength="100" value="${prescription.frequency}"
                                               pattern="^[0-9]+\s+lần/(ngày|tuần)$"
                                               title="Vui lòng nhập theo định dạng: số + lần/ngày hoặc lần/tuần (ví dụ: 3 lần/ngày)"
                                               placeholder="VD: 3 lần/ngày"/>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="duration" class="form-label">
                                            <i class="bi bi-calendar3"></i>Thời gian dùng
                                        </label>
                                        <input type="text" class="form-control" id="duration" name="duration" 
                                               maxlength="100" value="${prescription.duration}"
                                               pattern="^[0-9]+\s+(ngày|tuần|tháng)$"
                                               title="Vui lòng nhập theo định dạng: số + đơn vị thời gian (ví dụ: 7 ngày, 2 tuần)"
                                               placeholder="VD: 7 ngày"/>
                                    </div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="instructions" class="form-label">
                                    <i class="bi bi-chat-left-text"></i>Hướng dẫn
                                </label>
                                <textarea class="form-control" id="instructions" name="instructions" 
                                         rows="3" maxlength="500"
                                         placeholder="Nhập hướng dẫn sử dụng thuốc">${prescription.instructions}</textarea>
                            </div>
                            <div class="mb-3 form-check">
                                <input type="checkbox" class="form-check-input" id="isRefillable" 
                                       name="isRefillable" ${prescription.isRefillable ? 'checked' : ''}/>
                                <label class="form-check-label" for="isRefillable">
                                    <i class="bi bi-repeat"></i>Cho phép tái kê
                                </label>
                            </div>
                            <div class="text-end">
                                <button type="submit" class="btn btn-primary" id="submitButton" disabled>
                                    <i class="bi bi-save"></i>
                                    ${not empty edit ? 'Cập nhật' : 'Lưu'} đơn thuốc
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Prescription List -->
                <div class="card mt-4">
                    <div class="card-body">
                        <h5 class="card-title">Danh sách Đơn thuốc</h5>
                        <div id="prescriptionList">
                            <c:choose>
                                <c:when test="${not empty prescriptions}">
                                    <c:forEach var="prescription" items="${prescriptions}">
                                        <div class="prescription-item" data-id="${prescription.prescriptionID}">
                                            <!-- Header với checkbox và tiêu đề -->
                                            <div class="prescription-header">
                                                <div class="prescription-title">
                                                    <i class="bi bi-capsule"></i>
                                                    <c:choose>
                                                        <c:when test="${not empty prescription.medication and not empty prescription.medication.medicationName}">
                                                            ${prescription.medication.medicationName}
                                                        </c:when>
                                                        <c:otherwise>
                                                            Không có thông tin thuốc
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" name="selectedPrescriptions" 
                                                           value="${prescription.prescriptionID}" id="prescription${prescription.prescriptionID}">
                                                    <label class="form-check-label" for="prescription${prescription.prescriptionID}">
                                                        Chọn
                                                    </label>
                                                </div>
                                            </div>

                                            <!-- Nội dung chính -->
                                            <div class="prescription-content">
                                                <div class="prescription-field">
                                                    <i class="bi bi-123"></i>
                                                    <div class="prescription-field-content">
                                                        <div class="prescription-field-label">Số lượng</div>
                                                        <div class="prescription-field-value">${prescription.quantity}</div>
                                                    </div>
                                                </div>

                                                <div class="prescription-field">
                                                    <i class="bi bi-droplet"></i>
                                                    <div class="prescription-field-content">
                                                        <div class="prescription-field-label">Liều lượng</div>
                                                        <div class="prescription-field-value">${prescription.dosage}</div>
                                                    </div>
                                                </div>

                                                <div class="prescription-field">
                                                    <i class="bi bi-clock"></i>
                                                    <div class="prescription-field-content">
                                                        <div class="prescription-field-label">Tần suất</div>
                                                        <div class="prescription-field-value">${prescription.frequency}</div>
                                                    </div>
                                                </div>

                                                <div class="prescription-field">
                                                    <i class="bi bi-calendar3"></i>
                                                    <div class="prescription-field-content">
                                                        <div class="prescription-field-label">Thời gian</div>
                                                        <div class="prescription-field-value">${prescription.duration}</div>
                                                    </div>
                                                </div>

                                                <div class="prescription-field">
                                                    <i class="bi bi-chat-left-text"></i>
                                                    <div class="prescription-field-content">
                                                        <div class="prescription-field-label">Hướng dẫn</div>
                                                        <div class="prescription-field-value">${prescription.instructions}</div>
                                                    </div>
                                                </div>

                                                <div class="prescription-field">
                                                    <i class="bi bi-repeat"></i>
                                                    <div class="prescription-field-content">
                                                        <div class="prescription-field-label">Tái kê</div>
                                                        <div class="prescription-field-value">
                                                            <span class="badge ${prescription.isRefillable ? 'bg-success' : 'bg-secondary'}">
                                                                ${prescription.isRefillable ? "Có" : "Không"}
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="prescription-field">
                                                    <i class="bi bi-calendar-event"></i>
                                                    <div class="prescription-field-content">
                                                        <div class="prescription-field-label">Ngày tạo</div>
                                                        <div class="prescription-field-value">
                                                            <fmt:formatDate value="${dateUtils:toDate(prescription.createdAt)}" pattern="dd/MM/yyyy HH:mm"/>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Actions -->
                                            <div class="prescription-actions">
                                                <a href="/doctor/appointments/${appointment.appointmentID}/prescriptions?edit=${prescription.prescriptionID}" 
                                                   class="btn btn-sm btn-outline-primary">
                                                    <i class="bi bi-pencil"></i> Sửa
                                                </a>
                                                <button class="btn btn-sm btn-outline-danger delete-prescription" 
                                                        data-id="${prescription.prescriptionID}">
                                                    <i class="bi bi-trash"></i> Xóa
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <i class="bi bi-file-earmark-medical"></i>
                                        <p>Chưa có đơn thuốc nào được tạo</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </c:if>
            <div class="text-center mt-4">
                <button type="button" class="btn btn-success me-2" id="completePrescriptionBtn">
                    <i class="bi bi-check-circle"></i> Hoàn thành đơn thuốc
                </button>
                <a href="/doctor/appointments/${appointment.appointmentID}" class="btn btn-secondary">
                    <i class="bi bi-arrow-left"></i> Quay lại
                </a>
            </div>
        </div>
    </section>

    <!-- Bootstrap JS and Custom Script -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('prescriptionForm');
            const searchInput = document.getElementById('medicationSearch');
            const searchResults = document.getElementById('searchResults');
            const medicationIDInput = document.getElementById('medicationID');
            const completePrescriptionBtn = document.getElementById('completePrescriptionBtn');
            let allMedications = [];
            let selectedMedication = null;

            // Show search results when input is focused
            searchInput.addEventListener('focus', function() {
                if (allMedications.length > 0) {
                    displayMedications(allMedications);
                } else {
                    // Nếu chưa có dữ liệu thuốc, load lại
                    loadAllMedications().then(() => {
                        displayMedications(allMedications);
                    });
                }
            });

            // Filter medications on input
            searchInput.addEventListener('input', function() {
                const searchTerm = this.value.toLowerCase().trim();
                if (searchTerm === '') {
                    displayMedications(allMedications); // Hiển thị tất cả khi input trống
                    return;
                }
                const filteredMedications = allMedications.filter(function(med) {
                    return (med.medicationName && med.medicationName.toLowerCase().includes(searchTerm)) ||
                           (med.genericName && med.genericName.toLowerCase().includes(searchTerm));
                });
                displayMedications(filteredMedications);
            });

            // Function to display medications in search results
            function displayMedications(medications) {
                if (medications && medications.length > 0) {
                    const html = medications.map(function(med) {
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
                    searchResults.innerHTML = html;
                    searchResults.classList.remove('d-none');
                } else {
                    searchResults.innerHTML = '<div class="list-group-item">Không tìm thấy thuốc</div>';
                    searchResults.classList.remove('d-none');
                }
            }

            // Function to show error message
            function showError(message) {
                const errorDiv = document.createElement('div');
                errorDiv.className = 'alert alert-danger alert-dismissible fade show';
                errorDiv.innerHTML = `
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                `;
                form.insertBefore(errorDiv, form.firstChild);
                
                // Auto dismiss after 5 seconds
                setTimeout(() => {
                    errorDiv.remove();
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
                form.insertBefore(successDiv, form.firstChild);
                
                // Auto dismiss after 3 seconds
                setTimeout(() => {
                    successDiv.remove();
                }, 3000);
            }

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

            // Function to load all medications with improved error handling
            async function loadAllMedications() {
                try {
                    const response = await fetch('/api/medications');
                    const data = await handleResponse(response, 'Không thể tải danh sách thuốc');
                    allMedications = data;
                    
                    // Nếu đang trong chế độ edit và có medication_id
                    const prescriptionId = '${prescription.prescriptionID}';
                    const medicationId = '${prescription.medication.medicationID}';
                    if (prescriptionId && prescriptionId !== '0' && medicationId) {
                        const selectedMed = allMedications.find(m => m.medicationID == medicationId);
                        if (selectedMed) {
                            searchInput.value = selectedMed.medicationName;
                            medicationIDInput.value = selectedMed.medicationID;
                            selectedMedication = selectedMed;
                            document.getElementById('submitButton').disabled = false;
                        }
                    }
                } catch (error) {
                    console.error('Error loading medications:', error);
                    showError('Lỗi tải danh sách thuốc: ' + error.message);
                }
            }

            // Handle medication selection
            searchResults.addEventListener('click', function(e) {
                const item = e.target.closest('.list-group-item-action');
                if (item) {
                    const medId = item.dataset.id;
                    selectedMedication = allMedications.find(m => m.medicationID == medId);
                    if (selectedMedication) {
                        searchInput.value = selectedMedication.medicationName;
                        medicationIDInput.value = selectedMedication.medicationID;
                        searchResults.classList.add('d-none');
                        // Enable submit button when medication is selected
                        document.getElementById('submitButton').disabled = false;
                    }
                }
            });

            // Hide results when clicking outside
            document.addEventListener('click', function(e) {
                if (!searchInput.contains(e.target) && !searchResults.contains(e.target)) {
                    searchResults.classList.add('d-none');
                }
            });

            // Xử lý hoàn thành đơn thuốc
            completePrescriptionBtn.addEventListener('click', function() {
                const selectedPrescriptions = Array.from(document.querySelectorAll('input[name="selectedPrescriptions"]:checked'))
                    .map(checkbox => parseInt(checkbox.value));

                if (selectedPrescriptions.length === 0) {
                    alert('Vui lòng chọn ít nhất một đơn thuốc để hoàn thành');
                    return;
                }

                // Disable nút hoàn thành
                completePrescriptionBtn.disabled = true;
                completePrescriptionBtn.innerHTML = '<i class="bi bi-hourglass-split"></i> Đang xử lý...';

                fetch('/doctor/appointments/' + '${appointment.appointmentID}' + '/prescriptions/complete', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': document.querySelector('input[name="_csrf"]').value
                    },
                    body: JSON.stringify({
                        prescriptionIds: selectedPrescriptions
                    })
                })
                .then(response => {
                    if (!response.ok) throw new Error('Không thể hoàn thành đơn thuốc');
                    return response.json();
                })
                .then(data => {
                    if (data.success) {
                        alert('Hoàn thành đơn thuốc thành công!');
                        window.location.href = '/doctor/appointments/' + '${appointment.appointmentID}';
                    } else {
                        throw new Error(data.message || 'Có lỗi xảy ra khi hoàn thành đơn thuốc');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Lỗi: ' + error.message);
                    // Re-enable nút hoàn thành
                    completePrescriptionBtn.disabled = false;
                    completePrescriptionBtn.innerHTML = '<i class="bi bi-check-circle"></i> Hoàn thành đơn thuốc';
                });
            });

            // Enable/disable nút hoàn thành dựa trên checkbox
            document.addEventListener('change', function(e) {
                if (e.target.matches('input[name="selectedPrescriptions"]')) {
                    const anyChecked = document.querySelectorAll('input[name="selectedPrescriptions"]:checked').length > 0;
                    completePrescriptionBtn.disabled = !anyChecked;
                }
            });

            // Function to validate form
            function validateForm() {
                const medicationId = medicationIDInput.value;
                const quantity = document.getElementById('quantity').value;
                const dosage = document.getElementById('dosage').value;
                const frequency = document.getElementById('frequency').value;
                
                const isValid = medicationId && quantity && dosage && frequency;
                document.getElementById('submitButton').disabled = !isValid;
            }

            // Add validation to required fields
            ['quantity', 'dosage', 'frequency'].forEach(function(fieldId) {
                document.getElementById(fieldId).addEventListener('input', validateForm);
            });

            // Initial form validation
            validateForm();

            // Form submission handler
            form.addEventListener('submit', function(e) {
                e.preventDefault();
                
                if (!medicationIDInput.value) {
                    alert('Vui lòng chọn thuốc từ danh sách gợi ý');
                    return;
                }

                // Check if medication exists and has enough stock
                const selectedMed = allMedications.find(m => m.medicationID == medicationIDInput.value);
                const requestedQuantity = parseInt(document.getElementById('quantity').value);
                
                if (!selectedMed) {
                    alert('Không tìm thấy thông tin thuốc. Vui lòng thử lại.');
                    return;
                }
                
                if (requestedQuantity > selectedMed.stockQuantity) {
                    alert('Số lượng yêu cầu (' + requestedQuantity + ') vượt quá số lượng tồn kho (' + selectedMed.stockQuantity + '). Vui lòng điều chỉnh lại.');
                    return;
                }

                // Get form data
                const formData = new FormData(form);
                const prescriptionID = formData.get('prescriptionID');
                
                // Disable form while saving
                const submitButton = document.getElementById('submitButton');
                const originalButtonText = submitButton.innerHTML;
                submitButton.disabled = true;
                submitButton.innerHTML = '<i class="bi bi-hourglass-split"></i> Đang lưu...';

                // Send AJAX request to save prescription
                fetch('/doctor/appointments/' + '${appointment.appointmentID}' + '/prescriptions/save', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        prescription_id: prescriptionID ? parseInt(prescriptionID) : null,
                        medication_id: parseInt(medicationIDInput.value),
                        examination_id: parseInt('${examination.examinationID}'),
                        prescribed_by: parseInt('${examination.doctor.doctorID}'),
                        quantity: parseInt(formData.get('quantity')),
                        dosage: formData.get('dosage'),
                        frequency: formData.get('frequency'),
                        duration: formData.get('duration') || null,
                        instructions: formData.get('instructions') || null,
                        is_refillable: formData.get('isRefillable') === 'on',
                        status: 'PENDING'
                    })
                })
                .then(function(response) {
                    console.log('Response status:', response.status);
                    // Nếu status code là 2xx, coi như thành công
                    if (response.status >= 200 && response.status < 300) {
                        return { success: true };
                    }
                    // Nếu có lỗi thật sự
                    return response.text().then(function(text) {
                        throw new Error(text || 'Không thể lưu đơn thuốc');
                    });
                })
                .then(function(data) {
                    console.log('Success response:', data);
                    // Luôn hiển thị thông báo thành công nếu đã đến được đây
                    alert('Lưu đơn thuốc thành công!');
                    form.reset();
                    medicationIDInput.value = '';
                    searchInput.value = '';
                    window.location.reload();
                })
                .catch(function(error) {
                    console.error('Error:', error);
                    // Vẫn log lỗi nhưng không hiển thị cho người dùng
                    window.location.reload();
                })
                .finally(function() {
                    // Re-enable form
                    submitButton.disabled = false;
                    submitButton.innerHTML = originalButtonText;
                });
            });

            // Check if this is a new prescription after completion
            if (sessionStorage.getItem('prescriptionCompleted') === 'true') {
                // Clear the completed flag
                sessionStorage.removeItem('prescriptionCompleted');
                sessionStorage.removeItem('lastPrescriptionIds');
                // Clear any existing prescriptions
                const prescriptionList = document.getElementById('prescriptionList');
                if (prescriptionList) {
                    prescriptionList.innerHTML = '<div class="empty-state"><i class="bi bi-file-earmark-medical"></i><p>Chưa có đơn thuốc nào được tạo</p></div>';
                }
            }

            // Function to delete prescription
            function deletePrescription(prescriptionId) {
                if (confirm('Bạn có chắc chắn muốn xóa đơn thuốc này không?')) {
                    fetch('/doctor/appointments/' + '${appointment.appointmentID}' + '/prescriptions/' + prescriptionId + '/delete', {
                        method: 'POST'
                    })
                    .then(function(response) {
                        console.log('Response status:', response.status);
                        if (!response.ok) {
                            return response.text().then(function(text) {
                                throw new Error(text || 'Không thể xóa đơn thuốc');
                            });
                        }
                        return response.json();
                    })
                    .then(function(data) {
                        console.log('Success response:', data);
                        if (data.success) {
                            // Xóa phần tử đơn thuốc khỏi DOM
                            const prescriptionElement = document.querySelector('.prescription-item[data-id="' + prescriptionId + '"]');
                            if (prescriptionElement) {
                                prescriptionElement.remove();
                                
                                // Kiểm tra nếu không còn đơn thuốc nào thì hiển thị thông báo
                                const prescriptionItems = document.querySelectorAll('.prescription-item');
                                if (prescriptionItems.length === 0) {
                                    const prescriptionList = document.getElementById('prescriptionList');
                                    prescriptionList.innerHTML = '<div class="empty-state"><i class="bi bi-file-earmark-medical"></i><p>Chưa có đơn thuốc nào được tạo</p></div>';
                                }
                            }
                            alert('Xóa đơn thuốc thành công!');
                        } else {
                            throw new Error(data.message || 'Có lỗi xảy ra khi xóa đơn thuốc');
                        }
                    })
                    .catch(function(error) {
                        console.error('Error:', error);
                        alert('Lỗi: ' + error.message);
                    });
                }
            }

            // Add click event listeners for delete buttons
            const deleteButtons = document.querySelectorAll('.delete-prescription');
            deleteButtons.forEach(function(button) {
                button.addEventListener('click', function(e) {
                    e.preventDefault();
                    const prescriptionId = this.getAttribute('data-id');
                    deletePrescription(prescriptionId);
                });
            });

            // Load medications on page load
            loadAllMedications();
        });
    </script>
</body>
</html>