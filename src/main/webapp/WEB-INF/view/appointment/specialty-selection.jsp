<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Chọn chuyên khoa - HealthCare+</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet"
                href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/homepage.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/shared.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/specialty-selection.css">
        </head>

        <body>
            <jsp:include page="../shared/header.jsp" />

            <!-- Main Content -->
            <div class="main-content">
                <div class="container">
                    <!-- Breadcrumb -->
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="/">Trang chủ</a></li>
                            <li class="breadcrumb-item"><a href="/appointments">Quản lý lịch hẹn</a></li>
                            <li class="breadcrumb-item"><a href="/appointments/booking">Đặt lịch hẹn</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Chọn chuyên khoa</li>
                        </ol>
                    </nav>

                    <main class="main-content">
                        <div class="booking-container">
                            <div class="page-title text-center mb-5">
                                <h1 class="h2 mb-3">Đặt lịch khám bệnh</h1>
                                <p class="text-muted">Chọn chuyên khoa phù hợp với nhu cầu của bạn</p>
                            </div>

                            <div class="content-container">
                                <!-- Progress Steps -->
                                <div class="progress-steps">
                                    <div class="step active">
                                        <div class="step-number">1</div>
                                        <span>Chuyên khoa</span>
                                    </div>
                                    <div class="step">
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

                                <!-- Specialty Selection -->
                                <h3 style="margin-bottom: 1.5rem; color: #333;">Chọn chuyên khoa</h3>
                                <div class="specialties-grid">
                                    <c:forEach items="${specializations}" var="spec">
                                        <div class="specialty-card"
                                            onclick="handleSpecialtyClick(this, '${spec.specializationID}')">
                                            <div class="specialty-icon">
                                                <img src="/resources/images/specialties/${spec.specializationID}.png"
                                                    alt="${spec.specializationName}">
                                            </div>
                                            <h3>${spec.specializationName}</h3>
                                            <p>${spec.description}</p>
                                        </div>
                                    </c:forEach>
                                </div>

                                <!-- Navigation Buttons -->
                                <div class="nav-buttons">
                                    <a href="${pageContext.request.contextPath}/appointments/booking"
                                        class="btn btn-secondary">
                                        ← Quay lại
                                    </a>
                                    <button id="continueBtn" class="btn btn-primary" disabled
                                        onclick="selectSpecialty()">
                                        Tiếp tục →
                                    </button>
                                </div>
                            </div>
                        </div>
                    </main>
                </div>
            </div>

            <!-- Include shared footer -->
            <jsp:include page="/WEB-INF/view/shared/footer.jsp" />

            <script>
                let selectedSpecialtyId = null;
                let clickCount = 0;

                function handleSpecialtyClick(card, specializationId) {
                    // Remove selected class from all cards
                    document.querySelectorAll('.specialty-card').forEach(c => {
                        c.classList.remove('selected');
                    });

                    // Add selected class to clicked card
                    card.classList.add('selected');

                    // Store selected specialty ID
                    selectedSpecialtyId = specializationId;

                    // Enable continue button
                    document.getElementById('continueBtn').disabled = false;

                    // Handle double click
                    clickCount++;
                    if (clickCount === 2) {
                        selectSpecialty();
                        clickCount = 0;
                    }

                    // Reset click count after delay
                    setTimeout(() => {
                        clickCount = 0;
                    }, 500);
                }

                function selectSpecialty() {
                    if (selectedSpecialtyId) {
                        window.location.href = '/appointments/doctor?specializationId=' + selectedSpecialtyId;
                    }
                }
            </script>
        </body>

        </html>