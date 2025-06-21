<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="/css/homepage.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <title>HealthCare+ - Tạo Hồ sơ Khám bệnh</title>
    <style>
        .exam-form-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 2rem 0;
        }
        
        .exam-form-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            padding: 2rem;
            margin-bottom: 2rem;
        }
        
        .form-title {
            color: #2c3e50;
            font-size: 2.2rem;
            font-weight: 700;
            text-align: center;
            margin-bottom: 2rem;
            position: relative;
        }
        
        .form-title::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            border-radius: 2px;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-label {
            font-weight: 600;
            color: #34495e;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .form-label i {
            font-size: 1.1rem;
        }
        
        .form-control {
            border: 2px solid #e9ecef;
            border-radius: 12px;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            transition: all 0.3s ease;
            width: 100%;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .number-input-group {
            position: relative;
            display: flex;
            align-items: center;
        }
        
        .number-input {
            flex: 1;
            border: 2px solid #e9ecef;
            border-radius: 12px;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            text-align: center;
            transition: all 0.3s ease;
            width: 100%;
        }
        
        .number-input:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            outline: none;
        }
        
        .number-btn {
            width: 40px;
            height: 40px;
            border: none;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            font-size: 1.2rem;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .number-btn:hover {
            transform: scale(1.1);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .number-btn:active {
            transform: scale(0.95);
        }
        
        .btn-decrease {
            margin-right: 0.5rem;
        }
        
        .btn-increase {
            margin-left: 0.5rem;
        }
        
        .date-input-group {
            position: relative;
        }
        
        .date-input {
            width: 100%;
            border: 2px solid #e9ecef;
            border-radius: 12px;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .date-input:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            outline: none;
        }
        
        .textarea-group {
            position: relative;
        }
        
        .form-textarea {
            border: 2px solid #e9ecef;
            border-radius: 12px;
            padding: 1rem;
            font-size: 1rem;
            resize: vertical;
            min-height: 100px;
            transition: all 0.3s ease;
            width: 100%;
        }
        
        .form-textarea:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            outline: none;
        }
        
        .btn-group {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 2rem;
        }
        
        .btn-save {
            background: linear-gradient(135deg, #28a745, #20c997);
            border: none;
            border-radius: 12px;
            padding: 0.75rem 2rem;
            font-size: 1.1rem;
            font-weight: 600;
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(40, 167, 69, 0.4);
            color: white;
            text-decoration: none;
        }
        
        .btn-cancel {
            background: linear-gradient(135deg, #6c757d, #495057);
            border: none;
            border-radius: 12px;
            padding: 0.75rem 2rem;
            font-size: 1.1rem;
            font-weight: 600;
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .btn-cancel:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(108, 117, 125, 0.4);
            color: white;
            text-decoration: none;
        }
        
        .section-divider {
            height: 2px;
            background: linear-gradient(90deg, transparent, #667eea, transparent);
            margin: 2rem 0;
            border-radius: 1px;
        }
        
        @media (max-width: 768px) {
            .exam-form-card {
                padding: 1.5rem;
                margin: 1rem;
            }
            
            .btn-group {
                flex-direction: column;
            }
            
            .number-input-group {
                flex-direction: column;
                gap: 0.5rem;
            }
            
            .number-btn {
                width: 35px;
                height: 35px;
                font-size: 1rem;
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
                    <li><a href="<c:url value='/doctor/home' />"><i class="bi bi-house-door"></i> Trang chủ</a></li>
                    <li><a href="/doctor/doctors"><i class="bi bi-person-badge"></i> Bác sĩ</a></li>
                    <li><a href="/doctor/specialties"><i class="bi bi-clipboard2-pulse"></i> Chuyên khoa</a></li>
                    <li><a href="<c:url value='/doctor/appointments' />" class="active"><i class="bi bi-calendar-check"></i> Lịch hẹn</a></li>
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
                                    <li><a class="dropdown-item" href="/doctor/profile"><i class="bi bi-person"></i> Trang cá nhân</a></li>
                                    <li><a class="dropdown-item" href="/doctor/settings"><i class="bi bi-gear"></i> Cài đặt</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="/doctor/logout"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a></li>
                                </ul>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="<c:url value='/doctor/login' />" class="profile-btn">
                                <i class="bi bi-box-arrow-in-right"></i>
                                Đăng nhập
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </nav>
        </div>
    </header>

    <!-- Custom JavaScript -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const mobileMenuBtn = document.getElementById('mobileMenuBtn');
            const navLinks = document.getElementById('navLinks');

            mobileMenuBtn.addEventListener('click', function () {
                navLinks.classList.toggle('show');
                const icon = this.querySelector('i');
                if (navLinks.classList.contains('show')) {
                    icon.classList.remove('bi-list');
                    icon.classList.add('bi-x-lg');
                } else {
                    icon.classList.remove('bi-x-lg');
                    icon.classList.add('bi-list');
                }
            });

            const profileBtn = document.getElementById('profileDropdownBtn');
            const profileDropdown = document.getElementById('profileDropdown');

            if (profileBtn && profileDropdown) {
                profileBtn.addEventListener('click', function (e) {
                    e.stopPropagation();
                    profileDropdown.classList.toggle('show');
                });

                document.addEventListener('click', function (e) {
                    if (!profileDropdown.contains(e.target) && !profileBtn.contains(e.target)) {
                        profileDropdown.classList.remove('show');
                    }
                });
            }

            document.addEventListener('click', function (e) {
                if (!e.target.closest('.nav-links') && !e.target.closest('.mobile-menu-btn') && navLinks.classList.contains('show')) {
                    navLinks.classList.remove('show');
                    const icon = mobileMenuBtn.querySelector('i');
                    icon.classList.remove('bi-x-lg');
                    icon.classList.add('bi-list');
                }
            });

            // Thêm sự kiện xác nhận trước khi gửi form
            const saveButton = document.querySelector('.btn-save');
            if (saveButton) {
                saveButton.onclick = function(e) {
                    if (confirm('Bạn có chắc chắn muốn lưu hồ sơ này?')) {
                        // Cho phép gửi form
                        document.querySelector('form').submit();
                    } else {
                        e.preventDefault(); // Hủy gửi form
                    }
                };
            }
        });
    </script>

    <!-- Form Tạo Hồ sơ Khám bệnh -->
    <div class="exam-form-container">
        <div class="container">
            <div class="exam-form-card">
                <h2 class="form-title">Tạo Hồ sơ Khám bệnh</h2>
                
                <form:form modelAttribute="examination" method="post" action="${pageContext.request.contextPath}/doctor/appointments/${appointmentId}/examination/save">
                    <!-- Ngày khám -->
                    <div class="form-group">
                        <label for="examinationDate" class="form-label">
                            <i class="bi bi-calendar-event text-primary"></i>
                            Ngày khám
                        </label>
                        <div class="date-input-group">
                            <form:input path="examinationDate" type="datetime-local" class="date-input" value="${examination.examinationDate}" required="true" />
                        </div>
                    </div>

                    <!-- Huyết áp tâm thu -->
                    <div class="form-group">
                        <label for="bloodPressureSystolic" class="form-label">
                            <i class="bi bi-heart-pulse text-danger"></i>
                            Huyết áp tâm thu (mmHg)
                        </label>
                        <div class="number-input-group">
                            <button type="button" class="number-btn btn-decrease" onclick="decreaseValue('bloodPressureSystolic')">-</button>
                            <form:input path="bloodPressureSystolic" type="number" class="number-input" min="0" max="300" id="bloodPressureSystolic" required="true"/>
                            <button type="button" class="number-btn btn-increase" onclick="increaseValue('bloodPressureSystolic')">+</button>
                        </div>
                    </div>

                    <!-- Huyết áp tâm trương -->
                    <div class="form-group">
                        <label for="bloodPressureDiastolic" class="form-label">
                            <i class="bi bi-heart-pulse text-danger"></i>
                            Huyết áp tâm trương (mmHg)
                        </label>
                        <div class="number-input-group">
                            <button type="button" class="number-btn btn-decrease" onclick="decreaseValue('bloodPressureDiastolic')">-</button>
                            <form:input path="bloodPressureDiastolic" type="number" class="number-input" min="0" max="300" id="bloodPressureDiastolic" required="true"/>
                            <button type="button" class="number-btn btn-increase" onclick="increaseValue('bloodPressureDiastolic')">+</button>
                        </div>
                    </div>

                    <!-- Nhịp tim -->
                    <div class="form-group">
                        <label for="heartRate" class="form-label">
                            <i class="bi bi-heart-pulse text-danger"></i>
                            Nhịp tim (bpm)
                        </label>
                        <div class="number-input-group">
                            <button type="button" class="number-btn btn-decrease" onclick="decreaseValue('heartRate')">-</button>
                            <form:input path="heartRate" type="number" class="number-input" min="0" max="300" id="heartRate" required="true"/>
                            <button type="button" class="number-btn btn-increase" onclick="increaseValue('heartRate')">+</button>
                        </div>
                    </div>

                    <!-- Nhiệt độ -->
                    <div class="form-group">
                        <label for="temperature" class="form-label">
                            <i class="bi bi-thermometer-half text-warning"></i>
                            Nhiệt độ (độ C)
                        </label>
                        <div class="number-input-group">
                            <button type="button" class="number-btn btn-decrease" onclick="decreaseValue('temperature', 0.1)">-</button>
                            <form:input path="temperature" type="number" class="number-input" step="0.1" min="30" max="45" id="temperature" required="true"/>
                            <button type="button" class="number-btn btn-increase" onclick="increaseValue('temperature', 0.1)">+</button>
                        </div>
                    </div>

                    <!-- Nhịp thở -->
                    <div class="form-group">
                        <label for="respiratoryRate" class="form-label">
                            <i class="bi bi-lungs text-info"></i>
                            Nhịp thở (lần/phút)
                        </label>
                        <div class="number-input-group">
                            <button type="button" class="number-btn btn-decrease" onclick="decreaseValue('respiratoryRate')">-</button>
                            <form:input path="respiratoryRate" type="number" class="number-input" min="0" max="100" id="respiratoryRate" required="true"/>
                            <button type="button" class="number-btn btn-increase" onclick="increaseValue('respiratoryRate')">+</button>
                        </div>
                    </div>

                    <!-- Độ bão hòa oxy -->
                    <div class="form-group">
                        <label for="oxygenSaturation" class="form-label">
                            <i class="bi bi-droplet text-info"></i>
                            Độ bão hòa oxy (%)
                        </label>
                        <div class="number-input-group">
                            <button type="button" class="number-btn btn-decrease" onclick="decreaseValue('oxygenSaturation', 0.1)">-</button>
                            <form:input path="oxygenSaturation" type="number" class="number-input" step="0.1" min="0" max="100" id="oxygenSaturation" required="true"/>
                            <button type="button" class="number-btn btn-increase" onclick="increaseValue('oxygenSaturation', 0.1)">+</button>
                        </div>
                    </div>

                    <div class="section-divider"></div>

                    <!-- Triệu chứng -->
                    <div class="form-group">
                        <label for="symptoms" class="form-label">
                            <i class="bi bi-clipboard2-pulse text-danger"></i>
                            Triệu chứng
                        </label>
                        <div class="textarea-group">
                            <form:textarea path="symptoms" class="form-textarea" rows="3" placeholder="Mô tả các triệu chứng của bệnh nhân..." required="true" />
                        </div>
                    </div>

                    <!-- Khám lâm sàng -->
                    <div class="form-group">
                        <label for="physicalExamination" class="form-label">
                            <i class="bi bi-stethoscope text-success"></i>
                            Khám lâm sàng
                        </label>
                        <div class="textarea-group">
                            <form:textarea path="physicalExamination" class="form-textarea" rows="3" placeholder="Ghi chú kết quả khám lâm sàng..." required="true" />
                        </div>
                    </div>

                    <!-- Triệu chứng chính -->
                    <div class="form-group">
                        <label for="chiefComplaint" class="form-label">
                            <i class="bi bi-clipboard2-pulse text-danger"></i>
                            Triệu chứng chính
                        </label>
                        <div class="textarea-group">
                            <form:textarea path="chiefComplaint" class="form-textarea" rows="3" placeholder="Mô tả triệu chứng chính của bệnh nhân..." required="true" />
                        </div>
                    </div>

                    <!-- Chẩn đoán bệnh -->
                    <div class="form-group">
                        <label for="diseaseDiagnosis" class="form-label">
                            <i class="bi bi-file-medical text-success"></i>
                            Chẩn đoán bệnh
                        </label>
                        <div class="textarea-group">
                            <form:textarea path="diseaseDiagnosis" class="form-textarea" rows="3" placeholder="Nhập chẩn đoán của bác sĩ..." required="true" />
                        </div>
                    </div>

                    <!-- Mã ICD -->
                    <div class="form-group">
                        <label for="icdDiagnosis" class="form-label">
                            <i class="bi bi-clipboard2-check text-primary"></i>
                            Mã ICD
                        </label>
                        <div class="date-input-group">
                            <form:select path="icdDiagnosis" class="form-control" required="true">
                                <form:option value="" label="Chọn mã ICD"/>
                                <form:options items="${icdCodes}" itemValue="icdCode" itemLabel="codeAndDescription"/>
                            </form:select>
                        </div>
                    </div>

                    <!-- Kế hoạch điều trị -->
                    <div class="form-group">
                        <label for="conclusionTreatmentPlan" class="form-label">
                            <i class="bi bi-journal-medical text-primary"></i>
                            Kế hoạch điều trị
                        </label>
                        <div class="textarea-group">
                            <form:textarea path="conclusionTreatmentPlan" class="form-textarea" rows="3" placeholder="Mô tả kế hoạch điều trị chi tiết..." required="true" />
                        </div>
                    </div>

                    <!-- Ngày tái khám -->
                    <div class="form-group">
                        <label for="followUpDate" class="form-label">
                            <i class="bi bi-calendar-check text-primary"></i>
                            Ngày tái khám
                        </label>
                        <div class="date-input-group">
                            <form:input path="followUpDate" type="datetime-local" class="date-input" required="true" />
                        </div>
                    </div>

                    <!-- Trạng thái -->
                    <div class="form-group">
                        <label for="status" class="form-label">
                            <i class="bi bi-info-circle text-info"></i>
                            Trạng thái
                        </label>
                        <div class="date-input-group">
                            <form:select path="status" class="form-control" required="true">
                                <form:option value="" label="Chọn trạng thái" />
                                <form:option value="In Progress" label="In Progress" />
                                <form:option value="Completed" label="Completed" />
                                <form:option value="Cancelled" label="Cancelled" />
                            </form:select>
                        </div>
                    </div>

                    <div class="section-divider"></div>

                    <!-- Buttons -->
                    <div class="btn-group">
                        <button type="submit" class="btn-save">
                            <i class="bi bi-check-circle"></i>
                            Lưu Hồ sơ
                        </button>
                        <a href="<c:url value='/doctor/appointments/${appointmentId}' />" class="btn-cancel">
                            <i class="bi bi-x-circle"></i>
                            Hủy
                        </a>
                    </div>
                </form:form>
            </div>
        </div>
    </div>

    <!-- JavaScript for number inputs -->
    <script>
        function increaseValue(fieldId, step = 1) {
            const input = document.getElementById(fieldId);
            const max = parseFloat(input.getAttribute('max'));
            let value = parseFloat(input.value) || 0;
            value = Math.min(value + step, max);
            input.value = value.toFixed(step < 1 ? 1 : 0);
        }

        function decreaseValue(fieldId, step = 1) {
            const input = document.getElementById(fieldId);
            const min = parseFloat(input.getAttribute('min'));
            let value = parseFloat(input.value) || 0;
            value = Math.max(value - step, min);
            input.value = value.toFixed(step < 1 ? 1 : 0);
        }

        // Prevent form submission on enter key in number inputs
        document.querySelectorAll('.number-input').forEach(input => {
            input.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                }
            });
        });

        // Initialize date input with current date and time
        document.addEventListener('DOMContentLoaded', function() {
            const dateInput = document.getElementById('examinationDate');
            if (!dateInput.value) {
                const now = new Date();
                now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
                dateInput.value = now.toISOString().slice(0,16);
            }
        });
    </script>
</body>
</html>