<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Chọn thời gian - HealthCare+</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/time-selection.css">
            </head>

            <body>
                <!-- Include shared header -->
                <jsp:include page="/WEB-INF/view/shared/header.jsp" />

                <!-- Main Content -->
                <main class="main-content">
                    <div class="container">
                        <div class="page-title">
                            <h1>Đặt lịch khám bệnh</h1>
                            <p>Chọn thời gian khám phù hợp với bạn</p>
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

                            <!-- Time Selection -->
                            <form action="${pageContext.request.contextPath}/appointments/info" method="GET"
                                id="timeSelectionForm">
                                <input type="hidden" name="slotId" id="selectedSlotId">

                                <h3 style="margin-bottom: 1.5rem; color: #333;">Chọn ngày khám</h3>
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

                                <h4 style="margin-bottom: 1rem; color: #333;">Chọn giờ khám</h4>

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
                                                <span class="booked-indicator">Đã đặt</span>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </div>

                                <!-- Navigation Buttons -->
                                <div class="nav-buttons">
                                    <a href="${pageContext.request.contextPath}/appointments/doctor?specializationId=${param.specializationId}"
                                        class="btn btn-secondary">
                                        ← Quay lại
                                    </a>
                                    <button type="submit" class="btn btn-primary" id="continueBtn" disabled>
                                        Tiếp tục →
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </main>

                <!-- JavaScript for handling time selection -->
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        const form = document.getElementById('timeSelectionForm');
                        const slotIdInput = document.getElementById('selectedSlotId');
                        const continueBtn = document.getElementById('continueBtn');

                        // Debug: Log all available slots
                        console.log('Available Slots:');
                        document.querySelectorAll('.time-slot').forEach(slot => {
                            console.log('Slot:', {
                                id: slot.dataset.slotId,
                                time: slot.dataset.time,
                                status: slot.dataset.status,
                                isUnavailable: slot.classList.contains('unavailable')
                            });
                        });

                        // Date selection
                        const dateOptions = document.querySelectorAll('.date-option');
                        dateOptions.forEach(option => {
                            option.addEventListener('click', function (e) {
                                e.preventDefault();
                                dateOptions.forEach(o => o.classList.remove('selected'));
                                this.classList.add('selected');
                                const date = this.dataset.date;
                                window.location.href = '${pageContext.request.contextPath}/appointments/time?doctorId=${param.doctorId}&date=' + date;
                            });
                        });

                        // Time slot selection
                        document.querySelectorAll('.time-slot').forEach(slot => {
                            // Debug: Log slot details
                            console.log('Adding click listener to slot:', slot.dataset.time);

                            slot.addEventListener('click', function () {
                                console.log('Slot clicked:', {
                                    id: this.dataset.slotId,
                                    time: this.dataset.time,
                                    status: this.dataset.status,
                                    isUnavailable: this.classList.contains('unavailable')
                                });

                                if (!this.classList.contains('unavailable')) {
                                    // Remove selected class from all slots
                                    document.querySelectorAll('.time-slot').forEach(s => s.classList.remove('selected'));

                                    // Add selected class to clicked slot
                                    this.classList.add('selected');

                                    // Update hidden input and enable continue button
                                    slotIdInput.value = this.dataset.slotId;
                                    continueBtn.disabled = false;

                                    console.log('Slot selected:', {
                                        selectedId: slotIdInput.value,
                                        buttonDisabled: continueBtn.disabled
                                    });
                                }
                            });
                        });

                        // Add keyboard navigation
                        document.addEventListener('keydown', function (e) {
                            const slots = Array.from(document.querySelectorAll('.time-slot:not(.unavailable)'));
                            const currentIndex = slots.findIndex(slot => slot.classList.contains('selected'));

                            if (e.key === 'ArrowRight' || e.key === 'ArrowDown') {
                                e.preventDefault();
                                const nextIndex = currentIndex < slots.length - 1 ? currentIndex + 1 : 0;
                                slots[nextIndex].click();
                            } else if (e.key === 'ArrowLeft' || e.key === 'ArrowUp') {
                                e.preventDefault();
                                const prevIndex = currentIndex > 0 ? currentIndex - 1 : slots.length - 1;
                                slots[prevIndex].click();
                            } else if (e.key === 'Enter' && !continueBtn.disabled) {
                                e.preventDefault();
                                form.submit();
                            }
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

                        // Show debug info in development
                        const debugInfo = document.getElementById('debugInfo');
                        if (debugInfo) {
                            const debugButton = document.createElement('button');
                            debugButton.textContent = 'Toggle Debug Info';
                            debugButton.className = 'btn btn-secondary';
                            debugButton.style.marginBottom = '1rem';
                            debugButton.onclick = function (e) {
                                e.preventDefault();
                                debugInfo.style.display = debugInfo.style.display === 'none' ? 'block' : 'none';
                            };
                            debugInfo.parentNode.insertBefore(debugButton, debugInfo);
                        }
                    });
                </script>
            </body>

            </html>