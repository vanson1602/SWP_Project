<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <%@ page import="java.time.format.DateTimeFormatter" %>
                    <% DateTimeFormatter dateFormatter=DateTimeFormatter.ofPattern("dd/MM/yyyy"); DateTimeFormatter
                        timeFormatter=DateTimeFormatter.ofPattern("HH:mm"); request.setAttribute("dateFormatter",
                        dateFormatter); request.setAttribute("timeFormatter", timeFormatter); %>
                        <!DOCTYPE html>
                        <html lang="vi">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Thông tin bệnh nhân - HealthCare+</title>
                            <link rel="stylesheet"
                                href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
                            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
                                rel="stylesheet">
                            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/base.css">
                            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/homepage.css">
                            <link rel="stylesheet"
                                href="${pageContext.request.contextPath}/resources/css/patient-info.css">
                            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
                        </head>

                        <body>
                            <jsp:include page="../shared/header.jsp" />

                            <!-- Main Content -->
                            <div class="main-content">
                                <div class="container">
                                    <!-- Breadcrumb -->
                                    <nav aria-label="breadcrumb">
                                        <ol class="breadcrumb">
                                            <li class="breadcrumb-item"><a
                                                    href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                                            <li class="breadcrumb-item"><a
                                                    href="${pageContext.request.contextPath}/appointments">Quản lý lịch
                                                    hẹn</a></li>
                                            <li class="breadcrumb-item"><a
                                                    href="${pageContext.request.contextPath}/appointments/booking">Đặt
                                                    lịch hẹn</a></li>
                                            <li class="breadcrumb-item"><a
                                                    href="${pageContext.request.contextPath}/appointments/specialty">Chọn
                                                    chuyên khoa</a></li>
                                            <li class="breadcrumb-item"><a
                                                    href="${pageContext.request.contextPath}/appointments/doctor?specializationId=${param.specializationId}">Chọn
                                                    bác sĩ</a></li>
                                            <li class="breadcrumb-item"><a
                                                    href="${pageContext.request.contextPath}/appointments/time?doctorId=${param.doctorId}">Chọn
                                                    thời gian</a></li>
                                            <li class="breadcrumb-item active" aria-current="page">Xác nhận thông tin
                                            </li>
                                        </ol>
                                    </nav>

                                    <div class="booking-container">
                                        <div class="page-title text-center mb-5">
                                            <h1 class="h2 mb-3">Đặt lịch khám bệnh</h1>
                                            <p class="text-muted">Vui lòng kiểm tra thông tin và chọn loại khám</p>
                                        </div>

                                        <div class="content-container">
                                            <!-- Progress Steps -->
                                            <div class="progress-steps">
                                                <div class="step completed">
                                                    <div class="step-number">1</div>
                                                    <span>Chuyên khoa</span>
                                                </div>
                                                <div class="step completed">
                                                    <div class="step-number">2</div>
                                                    <span>Bác sĩ</span>
                                                </div>
                                                <div class="step completed">
                                                    <div class="step-number">3</div>
                                                    <span>Thời gian</span>
                                                </div>
                                                <div class="step active">
                                                    <div class="step-number">4</div>
                                                    <span>Xác nhận</span>
                                                </div>
                                                <div class="step">
                                                    <div class="step-number">5</div>
                                                    <span>Thanh toán</span>
                                                </div>
                                            </div>

                                            <!-- Error Alert -->
                                            <c:if test="${not empty error}">
                                                <div class="alert alert-danger alert-dismissible fade show"
                                                    role="alert">
                                                    ${error}
                                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                                        aria-label="Close"></button>
                                                </div>
                                            </c:if>

                                            <form id="appointmentForm"
                                                action="${pageContext.request.contextPath}/appointments/payment"
                                                method="POST" class="confirmation-form">
                                                <input type="hidden" name="slotId" value="${slot.slotID}">

                                                <!-- Thông tin bệnh nhân -->
                                                <div class="info-section">
                                                    <h4 class="section-title">
                                                        <i class="bi bi-person-circle me-2"></i>
                                                        Thông tin bệnh nhân
                                                    </h4>
                                                    <div class="info-content">
                                                        <div class="info-row">
                                                            <label>Họ và tên:</label>
                                                            <span>${patient.user.firstName}
                                                                ${patient.user.lastName}</span>
                                                        </div>
                                                        <div class="info-row">
                                                            <label>Email:</label>
                                                            <span>${patient.user.email}</span>
                                                        </div>
                                                        <div class="info-row">
                                                            <label>Số điện thoại:</label>
                                                            <span>${patient.user.phone}</span>
                                                        </div>
                                                        <div class="info-row">
                                                            <label>Ngày sinh:</label>
                                                            <span>
                                                                <c:if test="${not empty patient.user.dob}">
                                                                    ${patient.user.dob.format(dateFormatter)}
                                                                </c:if>
                                                                <c:if test="${empty patient.user.dob}">
                                                                    Chưa cập nhật
                                                                </c:if>
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Thông tin lịch hẹn -->
                                                <div class="info-section mt-4">
                                                    <h4 class="section-title">
                                                        <i class="bi bi-calendar-check me-2"></i>
                                                        Thông tin lịch hẹn
                                                    </h4>
                                                    <div class="info-content">
                                                        <div class="info-row">
                                                            <label>Bác sĩ:</label>
                                                            <span>BS. ${slot.schedule.doctor.user.firstName}
                                                                ${slot.schedule.doctor.user.lastName}</span>
                                                        </div>
                                                        <div class="info-row">
                                                            <label>Chuyên khoa:</label>
                                                            <span>${specialization.specializationName}</span>
                                                        </div>
                                                        <div class="info-row">
                                                            <label>Ngày khám:</label>
                                                            <span>${slot.startTime.format(dateFormatter)}</span>
                                                        </div>
                                                        <div class="info-row">
                                                            <label>Giờ khám:</label>
                                                            <span>${slot.startTime.format(timeFormatter)} →
                                                                ${slot.startTime.plusHours(1).format(timeFormatter)}</span>
                                                        </div>
                                                        <div class="info-row">
                                                            <label>Phí khám:</label>
                                                            <span
                                                                class="fee">${slot.schedule.doctor.consultationFee}đ</span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Chọn loại khám -->
                                                <div class="info-section mt-4">
                                                    <h4 class="section-title">
                                                        <i class="bi bi-clipboard2-pulse me-2"></i>
                                                        Chọn loại khám
                                                    </h4>
                                                    <div class="appointment-types">
                                                        <c:forEach items="${appointmentTypes}" var="type">
                                                            <div class="appointment-type-card"
                                                                onclick="selectAppointmentType('${type.appointmentTypeID}', this)">
                                                                <div class="type-header">
                                                                    <h5>${type.typeName}</h5>
                                                                    <div class="type-icon">
                                                                        <i class="bi bi-check-circle"></i>
                                                                    </div>
                                                                </div>
                                                                <p class="type-description">${type.description}</p>
                                                            </div>
                                                        </c:forEach>
                                                        <input type="hidden" name="appointmentTypeId"
                                                            id="appointmentTypeId" required>
                                                    </div>
                                                </div>

                                                <!-- Ghi chú -->
                                                <div class="info-section mt-4">
                                                    <h4 class="section-title">
                                                        <i class="bi bi-pencil-square me-2"></i>
                                                        Ghi chú
                                                    </h4>
                                                    <div class="form-group">
                                                        <textarea name="notes" class="form-control" rows="3"
                                                            placeholder="Nhập ghi chú về tình trạng bệnh (nếu có)"></textarea>
                                                    </div>
                                                </div>

                                                <!-- Navigation Buttons -->
                                                <div class="nav-buttons mt-4">
                                                    <a href="${pageContext.request.contextPath}/appointments/time?doctorId=${slot.schedule.doctor.doctorID}"
                                                        class="btn btn-secondary">
                                                        <i class="bi bi-arrow-left"></i> Quay lại
                                                    </a>
                                                    <button type="submit" class="btn btn-primary" id="continueBtn"
                                                        disabled>
                                                        Tiếp tục <i class="bi bi-arrow-right"></i>
                                                    </button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Include shared footer -->
                            <jsp:include page="/WEB-INF/view/shared/footer.jsp" />

                            <script>
                                function selectAppointmentType(typeId, element) {
                                    // Remove selected class from all cards
                                    document.querySelectorAll('.appointment-type-card').forEach(card => {
                                        card.classList.remove('selected');
                                    });

                                    // Add selected class to clicked card
                                    element.classList.add('selected');

                                    // Update hidden input
                                    document.getElementById('appointmentTypeId').value = typeId;

                                    // Enable continue button
                                    document.getElementById('continueBtn').disabled = false;
                                }

                                // Prevent form submission on Enter key
                                document.getElementById('appointmentForm').addEventListener('keypress', function (e) {
                                    if (e.key === 'Enter') {
                                        e.preventDefault();
                                        return false;
                                    }
                                });
                            </script>
                        </body>

                        </html>