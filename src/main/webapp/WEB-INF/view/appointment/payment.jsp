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
                            <title>Thanh toán - HealthCare+</title>
                            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
                                rel="stylesheet">
                            <link rel="stylesheet"
                                href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
                            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
                            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
                            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/payment.css">
                        </head>

                        <body>
                            <!-- Include shared header -->
                            <jsp:include page="/WEB-INF/view/shared/header.jsp" />

                            <!-- Main Content -->
                            <main class="main-content">
                                <div class="container">
                                    <div class="page-title">
                                        <h1>Thanh toán phí khám bệnh</h1>
                                        <p>Vui lòng chọn phương thức thanh toán</p>
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
                                            <div class="step completed">
                                                <div class="step-number">4</div>
                                                <span>Xác nhận</span>
                                            </div>
                                            <div class="step active">
                                                <div class="step-number">5</div>
                                                <span>Thanh toán</span>
                                            </div>
                                        </div>

                                        <!-- Payment Information -->
                                        <div class="payment-container">
                                            <h3 class="mb-4">Thông tin thanh toán</h3>

                                            <!-- Error Message -->
                                            <c:if test="${not empty error}">
                                                <div class="alert alert-danger" role="alert">
                                                    ${error}
                                                </div>
                                            </c:if>

                                            <!-- Appointment Summary -->
                                            <div class="card mb-4">
                                                <div class="card-header">
                                                    <h5 class="mb-0 text-white">Chi tiết lịch hẹn</h5>
                                                </div>
                                                <div class="card-body">
                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <p><strong>Mã lịch hẹn:</strong>
                                                                ${appointment.appointmentNumber}</p>
                                                            <p><strong>Bệnh nhân:</strong>
                                                                ${appointment.patient.user.firstName}
                                                                ${appointment.patient.user.lastName}</p>
                                                            <p><strong>Ngày khám:</strong>
                                                                ${appointment.appointmentDate.format(dateFormatter)}</p>
                                                            <p><strong>Giờ khám:</strong>
                                                                ${appointment.appointmentDate.format(timeFormatter)} →
                                                                ${appointment.appointmentDate.plusHours(1).format(timeFormatter)}
                                                            </p>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <p><strong>Bác sĩ:</strong> BS.
                                                                ${appointment.bookingSlot.schedule.doctor.user.firstName}
                                                                ${appointment.bookingSlot.schedule.doctor.user.lastName}
                                                            </p>
                                                            <p><strong>Chuyên khoa:</strong>
                                                                <c:forEach
                                                                    items="${appointment.bookingSlot.schedule.doctor.specializations}"
                                                                    var="spec" varStatus="loop">
                                                                    <c:if test="${loop.first}">
                                                                        ${spec.specializationName}</c:if>
                                                                </c:forEach>
                                                            </p>
                                                            <p><strong>Phí khám:</strong>
                                                                <span
                                                                    class="text-primary fw-bold">${appointment.bookingSlot.schedule.doctor.consultationFee}đ</span>
                                                            </p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Payment Methods -->
                                            <form
                                                action="${pageContext.request.contextPath}/appointments/process-payment"
                                                method="POST" id="paymentForm">
                                                <input type="hidden" name="appointmentId"
                                                    value="${appointment.appointmentID}">

                                                <div class="payment-methods">
                                                    <h5 class="mb-3">Chọn phương thức thanh toán</h5>
                                                    <div class="row g-3">
                                                        <div class="col-md-4">
                                                            <div class="payment-method-card">
                                                                <input type="radio" name="paymentMethod" id="momo"
                                                                    value="momo" required>
                                                                <label for="momo">
                                                                    <i class="fas fa-wallet fa-2x text-danger"></i>
                                                                    <span>MoMo</span>
                                                                </label>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <div class="payment-method-card">
                                                                <input type="radio" name="paymentMethod" id="vnpay"
                                                                    value="vnpay" required>
                                                                <label for="vnpay">
                                                                    <i class="fas fa-credit-card fa-2x text-primary"></i>
                                                                    <span>VNPay</span>
                                                                </label>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <div class="payment-method-card">
                                                                <input type="radio" name="paymentMethod" id="banking"
                                                                    value="banking" required>
                                                                <label for="banking">
                                                                    <i class="fas fa-university fa-2x text-success"></i>
                                                                    <span>Banking</span>
                                                                </label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Navigation Buttons -->
                                                <div class="nav-buttons">
                                                    <a href="${pageContext.request.contextPath}/appointments/info?slotId=${appointment.bookingSlot.slotID}"
                                                        class="btn btn-secondary">
                                                        <i class="bi bi-arrow-left"></i> Quay lại
                                                    </a>
                                                    <button type="submit" class="btn btn-primary">
                                                        Thanh toán <i class="bi bi-arrow-right"></i>
                                                    </button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </main>

                            <!-- Payment Validation Script -->
                            <script>
                                document.getElementById('paymentForm').addEventListener('submit', function (e) {
                                    const selectedMethod = document.querySelector('input[name="paymentMethod"]:checked');
                                    if (!selectedMethod) {
                                        e.preventDefault();
                                        alert('Vui lòng chọn phương thức thanh toán');
                                    }
                                });

                                // Add active state to payment method cards
                                document.querySelectorAll('.payment-method-card input[type="radio"]').forEach(radio => {
                                    radio.addEventListener('change', function () {
                                        document.querySelectorAll('.payment-method-card').forEach(card => {
                                            card.classList.remove('active');
                                        });
                                        if (this.checked) {
                                            this.closest('.payment-method-card').classList.add('active');
                                        }
                                    });
                                });
                            </script>
                        </body>

                        </html>