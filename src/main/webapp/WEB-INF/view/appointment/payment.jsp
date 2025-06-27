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
                            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
                                rel="stylesheet">
                            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/homepage.css">
                            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/shared.css">
                            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/payment.css">
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
                                            <li class="breadcrumb-item"><a href="/appointments">Quản lý lịch hẹn</a>
                                            </li>
                                            <li class="breadcrumb-item"><a href="/appointments/booking">Đặt lịch hẹn</a>
                                            </li>
                                            <li class="breadcrumb-item"><a href="/appointments/specialty">Chọn chuyên
                                                    khoa</a></li>
                                            <li class="breadcrumb-item"><a
                                                    href="/appointments/doctor?specializationId=${param.specializationId}">Chọn
                                                    bác sĩ</a></li>
                                            <li class="breadcrumb-item"><a
                                                    href="/appointments/time?doctorId=${param.doctorId}">Chọn thời
                                                    gian</a></li>
                                            <li class="breadcrumb-item"><a
                                                    href="/appointments/info?slotId=${appointment.bookingSlot.slotID}">Xác
                                                    nhận thông tin</a></li>
                                            <li class="breadcrumb-item active" aria-current="page">Thanh toán</li>
                                        </ol>
                                    </nav>

                                    <main class="main-content">
                                        <div class="booking-container">
                                            <div class="page-title text-center mb-5">
                                                <h1 class="h2 mb-3">Thanh toán phí khám</h1>
                                                <p class="text-muted">Vui lòng chọn phương thức thanh toán</p>
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

                                                <!-- Payment Summary -->
                                                <div class="payment-summary mb-4">
                                                    <h4 class="section-title">
                                                        <i class="bi bi-receipt me-2"></i>
                                                        Thông tin thanh toán
                                                    </h4>
                                                    <div class="summary-content">
                                                        <div class="summary-item">
                                                            <span>Bác sĩ:</span>
                                                            <span>BS.
                                                                ${appointment.bookingSlot.schedule.doctor.user.firstName}
                                                                ${appointment.bookingSlot.schedule.doctor.user.lastName}</span>
                                                        </div>
                                                        <div class="summary-item">
                                                            <span>Chuyên khoa:</span>
                                                            <span>
                                                                <c:forEach
                                                                    items="${appointment.bookingSlot.schedule.doctor.specializations}"
                                                                    var="spec" varStatus="loop">
                                                                    <c:if test="${loop.first}">
                                                                        ${spec.specializationName}</c:if>
                                                                </c:forEach>
                                                            </span>
                                                        </div>
                                                        <div class="summary-item">
                                                            <span>Thời gian khám:</span>
                                                            <span>${appointment.bookingSlot.startTime}</span>
                                                        </div>
                                                        <div class="summary-item total">
                                                            <span>Tổng thanh toán:</span>
                                                            <span
                                                                class="amount">${appointment.bookingSlot.schedule.doctor.consultationFee}đ</span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Payment Methods -->
                                                <div class="payment-methods mb-4">
                                                    <h4 class="section-title">
                                                        <i class="bi bi-credit-card me-2"></i>
                                                        Phương thức thanh toán
                                                    </h4>
                                                    <div class="methods-grid">
                                                        <div class="payment-method disabled">
                                                            <img src="${pageContext.request.contextPath}/resources/images/vnpay-logo.png"
                                                                alt="VNPAY">
                                                            <span>Thanh toán qua VNPAY</span>
                                                            <small class="text-muted">(Đang bảo trì)</small>
                                                        </div>
                                                        <div class="payment-method"
                                                            onclick="selectPaymentMethod('PAYOS')">
                                                            <img src="${pageContext.request.contextPath}/resources/images/payos-logo.png"
                                                                alt="PAYOS">
                                                            <span>Thanh toán qua PAYOS</span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Navigation Buttons -->
                                                <div class="nav-buttons">
                                                    <a href="${pageContext.request.contextPath}/appointments/info?slotId=${appointment.bookingSlot.slotID}"
                                                        class="btn btn-secondary">
                                                        <i class="bi bi-arrow-left me-2"></i>
                                                        Quay lại
                                                    </a>
                                                    <form id="paymentForm"
                                                        action="${pageContext.request.contextPath}/appointments/process-payment"
                                                        method="POST" style="display: inline;">
                                                        <input type="hidden" name="paymentMethod" id="paymentMethod">
                                                        <input type="hidden" name="appointmentId"
                                                            value="${appointment.appointmentID}">
                                                        <button type="submit" class="btn btn-primary" disabled
                                                            id="paymentButton">
                                                            <i class="bi bi-lock me-2"></i>
                                                            Thanh toán an toàn
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </main>
                                </div>
                            </div>
                            </div>

                            <!-- Include shared footer -->
                            <jsp:include page="/WEB-INF/view/shared/footer.jsp" />

                            <script
                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                            <script>
                                function selectPaymentMethod(method) {
                                    // Remove selected class from all methods
                                    document.querySelectorAll('.payment-method').forEach(el => {
                                        el.classList.remove('selected');
                                    });

                                    // Add selected class to clicked method
                                    event.currentTarget.classList.add('selected');

                                    // Update hidden input and enable button
                                    document.getElementById('paymentMethod').value = method;
                                    document.getElementById('paymentButton').disabled = false;
                                }
                            </script>

                            <style>
                                .payment-summary {
                                    background: white;
                                    border-radius: 10px;
                                    padding: 1.5rem;
                                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                                }

                                .summary-content {
                                    display: flex;
                                    flex-direction: column;
                                    gap: 1rem;
                                }

                                .summary-item {
                                    display: flex;
                                    justify-content: space-between;
                                    padding: 0.5rem 0;
                                    border-bottom: 1px solid #eee;
                                }

                                .summary-item.total {
                                    border-top: 2px solid #ddd;
                                    border-bottom: none;
                                    margin-top: 0.5rem;
                                    padding-top: 1rem;
                                    font-weight: bold;
                                }

                                .amount {
                                    color: #0061f2;
                                    font-size: 1.2rem;
                                }

                                .payment-methods {
                                    background: white;
                                    border-radius: 10px;
                                    padding: 1.5rem;
                                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                                }

                                .methods-grid {
                                    display: grid;
                                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                                    gap: 1rem;
                                    margin-top: 1rem;
                                }

                                .payment-method {
                                    border: 2px solid #eee;
                                    border-radius: 8px;
                                    padding: 1rem;
                                    text-align: center;
                                    cursor: pointer;
                                    transition: all 0.3s ease;
                                }

                                .payment-method:hover {
                                    border-color: #0061f2;
                                    transform: translateY(-2px);
                                }

                                .payment-method.selected {
                                    border-color: #0061f2;
                                    background: rgba(0, 97, 242, 0.05);
                                }

                                .payment-method img {
                                    height: 40px;
                                    margin-bottom: 0.5rem;
                                }

                                .payment-method span {
                                    display: block;
                                    color: #666;
                                    font-size: 0.9rem;
                                }

                                .payment-method.disabled {
                                    opacity: 0.6;
                                    cursor: not-allowed;
                                    border-color: #ddd;
                                }

                                .payment-method.disabled:hover {
                                    border-color: #ddd;
                                    transform: none;
                                }

                                .payment-method small {
                                    display: block;
                                    margin-top: 0.5rem;
                                    font-size: 0.8rem;
                                }

                                @media (max-width: 768px) {
                                    .methods-grid {
                                        grid-template-columns: 1fr;
                                    }
                                }
                            </style>
                        </body>

                        </html>