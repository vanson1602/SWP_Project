<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Chọn thời gian - HealthCare+</title>
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/base.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/homepage.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/time-selection.css">
            </head>

            <body>
                <jsp:include page="../shared/header.jsp" />

                <!-- Main Content -->
                <div class="main-content">
                    <div class="container">
                        <!-- Breadcrumb -->
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Trang chủ</a>
                                </li>
                                <li class="breadcrumb-item"><a
                                        href="${pageContext.request.contextPath}/appointments">Quản lý lịch hẹn</a></li>
                                <li class="breadcrumb-item"><a
                                        href="${pageContext.request.contextPath}/appointments/booking">Đặt lịch hẹn</a>
                                </li>
                                <li class="breadcrumb-item"><a
                                        href="${pageContext.request.contextPath}/appointments/specialty">Chọn chuyên
                                        khoa</a></li>
                                <li class="breadcrumb-item"><a
                                        href="${pageContext.request.contextPath}/appointments/doctor?specializationId=${param.specializationId}">Chọn
                                        bác sĩ</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Chọn thời gian</li>
                            </ol>
                        </nav>

                        <div class="booking-container">
                            <div class="page-title text-center mb-5">
                                <h1 class="h2 mb-3">Đặt lịch khám bệnh</h1>
                                <p class="text-muted">Chọn thời gian khám phù hợp với bạn</p>
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
                                    <div class="step active">
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

                                <!-- Time Selection Form -->
                                <form action="${pageContext.request.contextPath}/appointments/info" method="GET"
                                    id="timeSelectionForm">
                                    <input type="hidden" name="slotId" id="selectedSlotId">

                                    <h3 class="section-title">Chọn ngày khám</h3>
                                    <div class="date-selector">
                                        <c:forEach var="i" begin="0" end="6">
                                            <c:set var="date" value="${today.plusDays(i)}" />
                                            <div class="date-option ${i == 0 ? 'selected' : ''}" data-date="${date}">
                                                <div class="date-day">
                                                    <c:choose>
                                                        <c:when test="${date.dayOfWeek.value == 1}">Thứ 2</c:when>
                                                        <c:when test="${date.dayOfWeek.value == 2}">Thứ 3</c:when>
                                                        <c:when test="${date.dayOfWeek.value == 3}">Thứ 4</c:when>
                                                        <c:when test="${date.dayOfWeek.value == 4}">Thứ 5</c:when>
                                                        <c:when test="${date.dayOfWeek.value == 5}">Thứ 6</c:when>
                                                        <c:when test="${date.dayOfWeek.value == 6}">Thứ 7</c:when>
                                                        <c:otherwise>Chủ nhật</c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="date-number">
                                                    ${date.dayOfMonth}/${date.monthValue}
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>

                                    <h4 class="section-subtitle">Chọn giờ khám</h4>
                                    <div class="time-slots">
                                        <c:forEach items="${allTimeSlots}" var="timeSlot">
                                            <c:set var="isAvailable" value="false" />
                                            <c:set var="slotId" value="" />

                                            <c:forEach items="${availableSlots}" var="availableSlot">
                                                <c:if
                                                    test="${availableSlot.startTime.toLocalTime() eq timeSlot.toLocalTime()}">
                                                    <c:set var="isAvailable" value="true" />
                                                    <c:set var="slotId" value="${availableSlot.slotID}" />
                                                </c:if>
                                            </c:forEach>

                                            <div class="time-slot ${!isAvailable ? 'unavailable' : ''}"
                                                data-slot-id="${slotId}" data-time="${timeSlot.toLocalTime()}"
                                                data-status="${isAvailable ? 'Available' : 'Booked'}"
                                                title="${isAvailable ? 'Có thể đặt lịch' : 'Đã được đặt'}">
                                                <div class="time-range">
                                                    ${timeSlot.toLocalTime()} → ${timeSlot.plusHours(1).toLocalTime()}
                                                </div>
                                                <c:if test="${!isAvailable}">
                                                    <span class="booked-indicator">
                                                        <i class="bi bi-x-circle-fill"></i>
                                                    </span>
                                                </c:if>
                                            </div>
                                        </c:forEach>
                                    </div>

                                    <!-- Navigation Buttons -->
                                    <div class="nav-buttons">
                                        <a href="${pageContext.request.contextPath}/appointments/doctor?specializationId=${param.specializationId}"
                                            class="btn btn-secondary">
                                            <i class="bi bi-arrow-left"></i> Quay lại
                                        </a>
                                        <button type="submit" class="btn btn-primary" id="continueBtn" disabled>
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

                <!-- JavaScript for handling time selection -->
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        const form = document.getElementById('timeSelectionForm');
                        const slotIdInput = document.getElementById('selectedSlotId');
                        const continueBtn = document.getElementById('continueBtn');

                        // Date selection
                        const dateOptions = document.querySelectorAll('.date-option');
                        dateOptions.forEach(option => {
                            option.addEventListener('click', function () {
                                dateOptions.forEach(o => o.classList.remove('selected'));
                                this.classList.add('selected');
                                const date = this.dataset.date;
                                window.location.href = '${pageContext.request.contextPath}/appointments/time?doctorId=${param.doctorId}&date=' + date;
                            });
                        });

                        // Time slot selection
                        document.querySelectorAll('.time-slot').forEach(slot => {
                            slot.addEventListener('click', function () {
                                if (!this.classList.contains('unavailable')) {
                                    document.querySelectorAll('.time-slot').forEach(s => s.classList.remove('selected'));
                                    this.classList.add('selected');
                                    slotIdInput.value = this.dataset.slotId;
                                    continueBtn.disabled = false;
                                }
                            });
                        });

                        // Highlight current date if previously selected
                        const urlParams = new URLSearchParams(window.location.search);
                        const selectedDate = urlParams.get('date');
                        if (selectedDate) {
                            const dateOption = document.querySelector(`.date-option[data-date="${selectedDate}"]`);
                            if (dateOption) {
                                dateOptions.forEach(o => o.classList.remove('selected'));
                                dateOption.classList.add('selected');
                            }
                        }

                        // Re-select time slot if previously selected
                        const selectedSlotId = urlParams.get('slotId');
                        if (selectedSlotId) {
                            const timeSlot = document.querySelector(`.time-slot[data-slot-id="${selectedSlotId}"]`);
                            if (timeSlot && !timeSlot.classList.contains('unavailable')) {
                                document.querySelectorAll('.time-slot').forEach(s => s.classList.remove('selected'));
                                timeSlot.classList.add('selected');
                                slotIdInput.value = selectedSlotId;
                                continueBtn.disabled = false;
                            }
                        }
                    });
                </script>
            </body>

            </html>