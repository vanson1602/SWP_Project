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
            padding: 1.25rem;
            margin-bottom: 1rem;
            border-radius: 0.5rem;
            background-color: white;
            transition: transform 0.2s ease-in-out;
        }

        .prescription-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 0.25rem 0.5rem rgba(0, 0, 0, 0.1);
        }

        .prescription-item p {
            margin: 0 0 0.5rem;
            display: flex;
            align-items: center;
        }

        .prescription-item p i {
            width: 20px;
            margin-right: 0.5rem;
            color: var(--primary-color);
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
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="container">
            <nav class="nav">
                <a href="<c:url value='/doctor/home' />" class="logo">
                    <div class="logo-icon">⚕️</div>
                    HealthCare+
                </a>
                <ul class="nav-links">
                    <li><a href="<c:url value='/doctor/home' />"><i class="bi bi-house-door"></i> Trang chủ</a></li>
                    <li><a href="/doctor/doctors"><i class="bi bi-person-badge"></i> Bác sĩ</a></li>
                    <li><a href="/doctor/specialties"><i class="bi bi-clipboard2-pulse"></i> Chuyên khoa</a></li>
                    <li><a href="<c:url value='/doctor/appointments' />" class="active"><i class="bi bi-calendar-check"></i> Lịch hẹn</a></li>
                </ul>
            </nav>
        </div>
    </header>

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
                            <div class="mb-3">
                                <label for="quantity" class="form-label">
                                    <i class="bi bi-123"></i>Số lượng
                                </label>
                                <input type="number" class="form-control" id="quantity" name="quantity" 
                                       min="1" required value="${prescription.quantity}"/>
                            </div>
                            <div class="mb-3">
                                <label for="dosage" class="form-label">
                                    <i class="bi bi-droplet"></i>Liều lượng
                                </label>
                                <input type="text" class="form-control" id="dosage" name="dosage" 
                                       required maxlength="100" value="${prescription.dosage}"
                                       placeholder="VD: 1 viên/lần"/>
                            </div>
                            <div class="mb-3">
                                <label for="frequency" class="form-label">
                                    <i class="bi bi-clock"></i>Tần suất
                                </label>
                                <input type="text" class="form-control" id="frequency" name="frequency" 
                                       required maxlength="100" value="${prescription.frequency}"
                                       placeholder="VD: 3 lần/ngày"/>
                            </div>
                            <div class="mb-3">
                                <label for="duration" class="form-label">
                                    <i class="bi bi-calendar3"></i>Thời gian dùng
                                </label>
                                <input type="text" class="form-control" id="duration" name="duration" 
                                       maxlength="100" value="${prescription.duration}"
                                       placeholder="VD: 7 ngày"/>
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
                                            <p><strong>Thuốc:</strong> 
                                                <c:choose>
                                                    <c:when test="${not empty prescription.medication and not empty prescription.medication.medicationName}">
                                                        ${prescription.medication.medicationName}
                                                    </c:when>
                                                    <c:otherwise>
                                                        Không có thông tin
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                            <p><strong>Số lượng:</strong> ${prescription.quantity}</p>
                                            <p><strong>Liều lượng:</strong> ${prescription.dosage}</p>
                                            <p><strong>Tần suất:</strong> ${prescription.frequency}</p>
                                            <p><strong>Thời gian:</strong> ${prescription.duration}</p>
                                            <p><strong>Hướng dẫn:</strong> ${prescription.instructions}</p>
                                            <p><strong>Tái kê:</strong> ${prescription.isRefillable ? "Có" : "Không"}</p>
                                            <p><strong>Ngày tạo:</strong> <fmt:formatDate value="${dateUtils:toDate(prescription.createdAt)}" pattern="dd/MM/yyyy HH:mm"/></p>
                                            <div class="text-end">
                                                <a href="/doctor/appointments/${appointment.appointmentID}/prescriptions?edit=${prescription.prescriptionID}" class="btn btn-sm btn-outline-primary"><i class="bi bi-pencil"></i> Sửa</a>
                                                <button class="btn btn-sm btn-outline-danger delete-prescription" data-id="${prescription.prescriptionID}"><i class="bi bi-trash"></i> Xóa</button>
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
                <button type="button" class="btn btn-success me-2" onclick="completePrescriptions()">
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

            // Function to load all medications
            async function loadAllMedications() {
                try {
                    const response = await fetch('/api/medications');
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    const data = await response.json();
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
                    searchResults.innerHTML = '<div class="list-group-item text-danger">Lỗi tải danh sách thuốc</div>';
                    searchResults.classList.remove('d-none');
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

            // Function to complete prescriptions
            function completePrescriptions() {
                const selectedPrescriptions = Array.from(document.querySelectorAll('input[name="selectedPrescriptions"]:checked'))
                    .map(checkbox => parseInt(checkbox.value));

                if (selectedPrescriptions.length === 0) {
                    alert('Vui lòng chọn ít nhất một đơn thuốc để hoàn thành');
                    return;
                }

                fetch('/doctor/appointments/' + '${appointment.appointmentID}' + '/prescriptions/complete', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        prescriptionIds: selectedPrescriptions
                    })
                })
                .then(function(response) {
                    console.log('Response status:', response.status);
                    if (!response.ok) {
                        return response.text().then(function(text) {
                            throw new Error(text || 'Không thể hoàn thành đơn thuốc');
                        });
                    }
                    return response.json();
                })
                .then(function(data) {
                    console.log('Success response:', data);
                    if (data.success) {
                        // Lưu trạng thái hoàn thành vào sessionStorage
                        sessionStorage.setItem('prescriptionCompleted', 'true');
                        sessionStorage.setItem('lastPrescriptionIds', JSON.stringify(selectedPrescriptions));
                        
                        alert('Hoàn thành đơn thuốc thành công!');
                        // Chuyển hướng về trang chi tiết lịch hẹn
                        window.location.href = '/doctor/appointments/' + '${appointment.appointmentID}' + '#prescriptions';
                    } else {
                        throw new Error(data.message || 'Có lỗi xảy ra khi hoàn thành đơn thuốc');
                    }
                })
                .catch(function(error) {
                    console.error('Error:', error);
                    alert('Lỗi: ' + error.message);
                });
            }

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
                    if (!response.ok) {
                        return response.text().then(function(text) {
                            throw new Error(text || 'Không thể lưu đơn thuốc');
                        });
                    }
                    return response.json();
                })
                .then(function(data) {
                    console.log('Success response:', data);
                    if (data.success) {
                        alert('Lưu đơn thuốc thành công!');
                        form.reset();
                        medicationIDInput.value = '';
                        searchInput.value = '';
                        window.location.reload();
                    } else {
                        throw new Error(data.message || 'Có lỗi xảy ra khi lưu đơn thuốc');
                    }
                })
                .catch(function(error) {
                    console.error('Error:', error);
                    alert('Lỗi: ' + error.message);
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