<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Chọn Bác Sĩ - HealthCare+</title>
            <link rel="stylesheet"
                href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/doctor-selection.css">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        </head>

        <body>
            <!-- Include shared header -->
            <jsp:include page="/WEB-INF/view/shared/header.jsp" />

            <!-- Main Content -->
            <main class="main-content">
                <div class="container">
                    <div class="page-title">
                        <h1>Đặt lịch khám bệnh</h1>
                        <p>Chọn bác sĩ phù hợp với bạn</p>
                    </div>

                    <div class="content-container">
                        <!-- Progress Steps -->
                        <div class="progress-steps">
                            <div class="step completed">
                                <div class="step-number">1</div>
                                <span>Chuyên khoa</span>
                            </div>
                            <div class="step active">
                                <div class="step-number">2</div>
                                <span>Bác sĩ</span>
                            </div>
                            <div class="step">
                                <div class="step-number">3</div>
                                <span>Thời gian</span>
                            </div>
                            <div class="step">
                                <div class="step-number">4</div>
                                <span>Xác nhận</span>
                            </div>
                            <div class="step">
                                <div class="step-number">5</div>
                                <span>Thanh toán</span>
                            </div>
                        </div>

                        <!-- Doctor Selection -->
                        <h3 style="margin-bottom: 1.5rem; color: #333;">Chọn bác sĩ</h3>
                        <div class="doctors-grid">
                            <c:forEach items="${doctors}" var="doctor">
                                <div class="doctor-card" onclick="handleSingleClick('${doctor.doctorID}', this)"
                                    ondblclick="handleDoubleClick('${doctor.doctorID}')"
                                    data-doctor-id="${doctor.doctorID}">
                                    <div class="doctor-avatar">
                                        <c:choose>
                                            <c:when test="${not empty doctor.user.avatarUrl}">
                                                <img src="${pageContext.request.contextPath}${doctor.user.avatarUrl}"
                                                    alt="Doctor Avatar">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/resources/images/defaultImg.jpg"
                                                    alt="Default Doctor Avatar">
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="doctor-info">
                                        <h3>BS. ${doctor.user.firstName} ${doctor.user.lastName}</h3>
                                        <p class="experience">Kinh nghiệm: ${doctor.experienceYears} năm</p>
                                        <p class="qualification">${doctor.qualification}</p>
                                        <p class="fee">Phí tư vấn: ${doctor.consultationFee}đ</p>
                                        <div class="rating">
                                            <c:choose>
                                                <c:when test="${doctor.averageRating != null}">
                                                    <c:forEach begin="1" end="5" var="i">
                                                        <span
                                                            class="star ${i <= doctor.averageRating ? 'filled' : ''}">★</span>
                                                    </c:forEach>
                                                    <span class="rating-count">(${doctor.totalFeedback} đánh giá)</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="no-rating">Chưa có đánh giá</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Navigation Buttons -->
                        <div class="nav-buttons">
                            <a href="${pageContext.request.contextPath}/appointments/specialty"
                                class="btn btn-secondary">
                                ← Quay lại
                            </a>
                            <a href="#" id="nextButton" class="btn btn-primary disabled"
                                onclick="proceedToTimeSelection(event)">
                                Tiếp tục →
                            </a>
                        </div>
                    </div>
                </div>
            </main>

            <!-- JavaScript for handling doctor selection -->
            <script>
                let selectedDoctorId = null;
                let clickTimeout = null;

                function handleSingleClick(doctorId, element) {
                    // Prevent double click from triggering single click
                    if (clickTimeout !== null) {
                        clearTimeout(clickTimeout);
                        clickTimeout = null;
                        return;
                    }

                    clickTimeout = setTimeout(() => {
                        // Remove selected class from all cards
                        document.querySelectorAll('.doctor-card').forEach(card => {
                            card.classList.remove('selected');
                        });

                        // Add selected class to clicked card
                        element.classList.add('selected');
                        selectedDoctorId = doctorId;

                        // Enable next button
                        document.getElementById('nextButton').classList.remove('disabled');

                        clickTimeout = null;
                    }, 200); // Wait for potential double click
                }

                function handleDoubleClick(doctorId) {
                    if (clickTimeout) {
                        clearTimeout(clickTimeout);
                        clickTimeout = null;
                    }
                    window.location.href = '/appointments/time?doctorId=' + doctorId;
                }

                function proceedToTimeSelection(event) {
                    event.preventDefault();
                    if (selectedDoctorId) {
                        window.location.href = '/appointments/time?doctorId=' + selectedDoctorId;
                    }
                }
            </script>

            <style>
                .doctor-card {
                    cursor: pointer;
                    transition: all 0.3s ease;
                    border: 2px solid transparent;
                }

                .doctor-card.selected {
                    border-color: #007bff;
                    box-shadow: 0 0 10px rgba(0, 123, 255, 0.3);
                }

                .btn.disabled {
                    opacity: 0.6;
                    cursor: not-allowed;
                    pointer-events: none;
                }
            </style>
        </body>

        </html>