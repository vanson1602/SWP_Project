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
                            <link rel="stylesheet"
                                href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
                            <link rel="stylesheet"
                                href="${pageContext.request.contextPath}/resources/css/appointment-style.css">
                            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
                                rel="stylesheet">
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
                                                <div class="card-header bg-primary text-white">
                                                    <h5 class="mb-0">Chi tiết lịch hẹn</h5>
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
                                                                ${appointment.bookingSlot.schedule.doctor.consultationFee}đ
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
                                                    <div class="row">
                                                        <div class="col-md-4">
                                                            <div class="payment-method-card">
                                                                <input type="radio" name="paymentMethod" id="momo"
                                                                    value="momo" required>
                                                                <label for="momo">
                                                                    <img src="${pageContext.request.contextPath}/resources/images/momo-logo.png"
                                                                        alt="MoMo">
                                                                    <span>MoMo</span>
                                                                </label>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <div class="payment-method-card">
                                                                <input type="radio" name="paymentMethod" id="vnpay"
                                                                    value="vnpay" required>
                                                                <label for="vnpay">
                                                                    <img src="${pageContext.request.contextPath}/resources/images/vnpay-logo.png"
                                                                        alt="VNPay">
                                                                    <span>VNPay</span>
                                                                </label>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <div class="payment-method-card">
                                                                <input type="radio" name="paymentMethod" id="banking"
                                                                    value="banking" required>
                                                                <label for="banking">
                                                                    <img src="${pageContext.request.contextPath}/resources/images/banking-logo.png"
                                                                        alt="Banking">
                                                                    <span>Banking</span>
                                                                </label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Navigation Buttons -->
                                                <div class="nav-buttons mt-4">
                                                    <a href="${pageContext.request.contextPath}/appointments/info?slotId=${appointment.bookingSlot.slotID}"
                                                        class="btn btn-secondary">
                                                        ← Quay lại
                                                    </a>
                                                    <button type="submit" class="btn btn-primary">
                                                        Thanh toán →
                                                    </button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </main>

                            <style>
                                .payment-container {
                                    background: #fff;
                                    border-radius: 10px;
                                    padding: 2rem;
                                }

                                .payment-methods {
                                    margin-top: 2rem;
                                }

                                .payment-method-card {
                                    border: 2px solid #e9ecef;
                                    border-radius: 10px;
                                    padding: 1rem;
                                    text-align: center;
                                    cursor: pointer;
                                    transition: all 0.3s ease;
                                    height: 100%;
                                }

                                .payment-method-card:hover {
                                    border-color: #007bff;
                                    transform: translateY(-2px);
                                }

                                .payment-method-card input[type="radio"] {
                                    display: none;
                                }

                                .payment-method-card label {
                                    cursor: pointer;
                                    margin: 0;
                                    display: flex;
                                    flex-direction: column;
                                    align-items: center;
                                    gap: 0.5rem;
                                }

                                .payment-method-card img {
                                    max-width: 80px;
                                    height: auto;
                                    margin-bottom: 0.5rem;
                                }

                                .payment-method-card input[type="radio"]:checked+label {
                                    color: #007bff;
                                }

                                .payment-method-card input[type="radio"]:checked+label img {
                                    transform: scale(1.05);
                                }

                                .card {
                                    box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
                                }

                                .card-header {
                                    background-color: #007bff !important;
                                }

                                .nav-buttons {
                                    display: flex;
                                    justify-content: space-between;
                                    margin-top: 2rem;
                                }

                                .btn {
                                    padding: 0.5rem 1.5rem;
                                    font-weight: 500;
                                }

                                .btn-primary {
                                    background-color: #007bff;
                                    border-color: #007bff;
                                }

                                .btn-primary:hover {
                                    background-color: #0056b3;
                                    border-color: #0056b3;
                                }

                                .alert {
                                    border-radius: 8px;
                                    margin-bottom: 1.5rem;
                                }
                            </style>

                            <script>
                                document.addEventListener('DOMContentLoaded', function () {
                                    const paymentCards = document.querySelectorAll('.payment-method-card');

                                    paymentCards.forEach(card => {
                                        card.addEventListener('click', function () {
                                            const radio = this.querySelector('input[type="radio"]');
                                            radio.checked = true;

                                            // Remove active class from all cards
                                            paymentCards.forEach(c => c.style.borderColor = '#e9ecef');

                                            // Add active class to selected card
                                            this.style.borderColor = '#007bff';
                                        });
                                    });

                                    // Form validation
                                    const form = document.getElementById('paymentForm');
                                    form.addEventListener('submit', function (event) {
                                        const selectedMethod = form.querySelector('input[name="paymentMethod"]:checked');
                                        if (!selectedMethod) {
                                            event.preventDefault();
                                            alert('Vui lòng chọn phương thức thanh toán');
                                        }
                                    });
                                });
                            </script>
                        </body>

                        </html>