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
                            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
                                rel="stylesheet">
                            <link rel="stylesheet"
                                href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
                            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
                            <link rel="stylesheet"
                                href="${pageContext.request.contextPath}/resources/css/patient-info.css">
                        </head>

                        <body>
                            <!-- Include shared header -->
                            <jsp:include page="/WEB-INF/view/shared/header.jsp" />

                            <!-- Main Content -->
                            <main class="main-content">
                                <div class="container">
                                    <div class="page-title">
                                        <h1>Đặt lịch khám bệnh</h1>
                                        <p>Vui lòng xác nhận thông tin đặt khám</p>
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

                                        <!-- Patient Information Form -->
                                        <h3 class="section-title">Xác nhận thông tin đặt khám</h3>
                                        <form action="${pageContext.request.contextPath}/appointments/payment"
                                            method="POST" id="patientInfoForm" novalidate>
                                            <input type="hidden" name="slotId" value="${slot.slotID}">

                                            <div class="info-section">
                                                <h4>Thông tin bệnh nhân</h4>
                                                <div class="form-row">
                                                    <div class="form-group">
                                                        <label>Họ và tên</label>
                                                        <input type="text" class="form-control"
                                                            value="${patient.user.firstName} ${patient.user.lastName}"
                                                            readonly>
                                                    </div>
                                                    <div class="form-group">
                                                        <label>Số điện thoại</label>
                                                        <input type="tel" class="form-control"
                                                            value="${patient.user.phone}" readonly>
                                                    </div>
                                                </div>

                                                <div class="form-row">
                                                    <div class="form-group">
                                                        <label>Ngày sinh</label>
                                                        <input type="text" class="form-control"
                                                            value="${patient.user.dob}" readonly>
                                                    </div>
                                                    <div class="form-group">
                                                        <label>Giới tính</label>
                                                        <input type="text" class="form-control"
                                                            value="${patient.user.gender == 'Male' ? 'Nam' : patient.user.gender == 'Female' ? 'Nữ' : 'Khác'}"
                                                            readonly>
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label>Địa chỉ</label>
                                                    <input type="text" class="form-control"
                                                        value="${patient.user.address}" readonly>
                                                </div>

                                                <div class="form-group">
                                                    <label>BHYT</label>
                                                    <input type="text" class="form-control"
                                                        value="${patient.insuranceNumber}" readonly>
                                                </div>
                                            </div>

                                            <!-- Thông tin lịch khám -->
                                            <div class="info-section">
                                                <h4>Thông tin lịch khám</h4>
                                                <div class="form-row">
                                                    <div class="form-group">
                                                        <label>Chuyên khoa</label>
                                                        <input type="text" class="form-control"
                                                            value="${specialization.specializationName}" readonly>
                                                    </div>
                                                    <div class="form-group">
                                                        <label>Bác sĩ</label>
                                                        <input type="text" class="form-control"
                                                            value="BS. ${slot.schedule.doctor.user.firstName} ${slot.schedule.doctor.user.lastName}"
                                                            readonly>
                                                    </div>
                                                </div>

                                                <div class="form-row">
                                                    <div class="form-group">
                                                        <label>Loại khám</label>
                                                        <select name="appointmentTypeId" class="form-control" required>
                                                            <option value="">-- Chọn loại khám --</option>
                                                            <c:forEach items="${appointmentTypes}" var="type">
                                                                <option value="${type.appointmentTypeID}">
                                                                    ${type.typeName}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                    <div class="form-group">
                                                        <label>Phí khám</label>
                                                        <input type="text" class="form-control"
                                                            value="${slot.schedule.doctor.consultationFee}đ" readonly>
                                                    </div>
                                                </div>

                                                <div class="form-row">
                                                    <div class="form-group">
                                                        <label>Ngày khám</label>
                                                        <input type="text" class="form-control"
                                                            value="${slot.startTime.format(dateFormatter)}" readonly>
                                                    </div>
                                                    <div class="form-group">
                                                        <label>Giờ khám</label>
                                                        <input type="text" class="form-control"
                                                            value="${slot.startTime.format(timeFormatter)} → ${slot.startTime.plusHours(1).format(timeFormatter)}"
                                                            readonly>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label for="notes">Ghi chú</label>
                                                <textarea id="notes" name="notes" class="form-control" rows="3"
                                                    placeholder="Nhập triệu chứng hoặc ghi chú thêm (nếu có)"></textarea>
                                            </div>

                                            <!-- Navigation Buttons -->
                                            <div class="nav-buttons">
                                                <a href="${pageContext.request.contextPath}/appointments/time?doctorId=${slot.schedule.doctor.doctorID}&date=${slot.startTime.toLocalDate()}"
                                                    class="btn btn-secondary">
                                                    ← Quay lại
                                                </a>
                                                <button type="submit" class="btn btn-primary">
                                                    Xác nhận và Thanh toán →
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </main>

                            <style>
                                .info-section {
                                    background: #f8f9fa;
                                    border-radius: 8px;
                                    padding: 1.5rem;
                                    margin-bottom: 1.5rem;
                                }

                                .info-section h4 {
                                    color: #2c5282;
                                    margin-bottom: 1.5rem;
                                    font-size: 1.1rem;
                                }

                                .form-row {
                                    display: grid;
                                    grid-template-columns: 1fr 1fr;
                                    gap: 1rem;
                                    margin-bottom: 1rem;
                                }

                                .form-control[readonly] {
                                    background-color: #fff;
                                    opacity: 1;
                                }
                            </style>

                            <!-- JavaScript for form validation -->
                            <script>
                                document.addEventListener('DOMContentLoaded', function () {
                                    const form = document.getElementById('patientInfoForm');

                                    form.addEventListener('submit', function (event) {
                                        event.preventDefault();

                                        if (form.checkValidity()) {
                                            form.submit();
                                        } else {
                                            event.stopPropagation();
                                            const inputs = form.querySelectorAll('input, select');
                                            inputs.forEach(input => {
                                                if (!input.validity.valid) {
                                                    input.classList.add('is-invalid');
                                                } else {
                                                    input.classList.remove('is-invalid');
                                                }
                                            });
                                        }
                                    });

                                    // Remove is-invalid class when user starts typing
                                    const inputs = form.querySelectorAll('input, select');
                                    inputs.forEach(input => {
                                        input.addEventListener('input', function () {
                                            if (this.validity.valid) {
                                                this.classList.remove('is-invalid');
                                            }
                                        });
                                    });
                                });
                            </script>
                        </body>

                        </html>