<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
                <%@ page import="java.time.format.DateTimeFormatter" %>
                    <% pageContext.setAttribute("dateFormatter", DateTimeFormatter.ofPattern("dd/MM/yyyy"));
                        pageContext.setAttribute("timeFormatter", DateTimeFormatter.ofPattern("HH:00")); %>
                        <!DOCTYPE html>
                        <html lang="vi">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Lịch hẹn của tôi - HealthCare+</title>
                            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                rel="stylesheet">
                            <link rel="stylesheet"
                                href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
                            <link rel="stylesheet" href="/css/homepage.css">
                            <style>
                                body {
                                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                                    min-height: 100vh;
                                }

                                .appointments-container {
                                    padding: 2rem 0;
                                }

                                .page-title {
                                    color: white;
                                    margin-bottom: 2rem;
                                    text-align: center;
                                    font-weight: 600;
                                }

                                .appointment-card {
                                    background: rgba(255, 255, 255, 0.95);
                                    border-radius: 15px;
                                    margin-bottom: 1.5rem;
                                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
                                    transition: transform 0.3s ease;
                                    border: none;
                                    overflow: hidden;
                                }

                                .appointment-card:hover {
                                    transform: translateY(-5px);
                                }

                                .appointment-header {
                                    background: linear-gradient(to right, #4CAF50, #81C784);
                                    color: white;
                                    padding: 1rem 1.5rem;
                                    display: flex;
                                    justify-content: space-between;
                                    align-items: center;
                                }

                                .appointment-number {
                                    font-weight: 600;
                                    font-size: 1.1rem;
                                    display: flex;
                                    align-items: center;
                                    gap: 8px;
                                }

                                .appointment-content {
                                    padding: 1.5rem;
                                    display: flex;
                                    gap: 2rem;
                                }

                                .doctor-info {
                                    flex: 0 0 250px;
                                    text-align: center;
                                    padding: 1rem;
                                    border-right: 1px solid rgba(0, 0, 0, 0.1);
                                }

                                .doctor-avatar {
                                    width: 120px;
                                    height: 120px;
                                    border-radius: 50%;
                                    margin: 0 auto 1rem;
                                    object-fit: cover;
                                    border: 3px solid #4CAF50;
                                }

                                .doctor-name {
                                    font-size: 1.2rem;
                                    font-weight: 600;
                                    color: #2c3e50;
                                    margin-bottom: 0.5rem;
                                }

                                .doctor-specialty {
                                    color: #666;
                                    font-size: 0.9rem;
                                    margin-bottom: 1rem;
                                }

                                .appointment-details {
                                    flex: 1;
                                }

                                .appointment-info {
                                    display: flex;
                                    align-items: center;
                                    gap: 8px;
                                    margin-bottom: 1rem;
                                    color: #555;
                                    padding: 0.5rem;
                                    border-radius: 8px;
                                    transition: background-color 0.2s ease;
                                }

                                .appointment-info:hover {
                                    background-color: rgba(76, 175, 80, 0.1);
                                }

                                .appointment-info i {
                                    color: #4CAF50;
                                    font-size: 1.1rem;
                                    width: 24px;
                                }

                                .status-badge {
                                    padding: 0.5rem 1rem;
                                    border-radius: 25px;
                                    font-weight: 500;
                                    display: inline-flex;
                                    align-items: center;
                                    gap: 6px;
                                }

                                .status-pending {
                                    background-color: #fff3cd;
                                    color: #856404;
                                }

                                .status-confirmed {
                                    background-color: #d4edda;
                                    color: #155724;
                                }

                                .status-cancelled {
                                    background-color: #f8d7da;
                                    color: #721c24;
                                }

                                .cancel-btn {
                                    background-color: #dc3545;
                                    color: white;
                                    border: none;
                                    padding: 0.6rem 1.2rem;
                                    border-radius: 25px;
                                    font-weight: 500;
                                    transition: all 0.3s ease;
                                }

                                .cancel-btn:hover {
                                    background-color: #c82333;
                                    transform: translateY(-2px);
                                }

                                .modal-content {
                                    border-radius: 15px;
                                }

                                .modal-header {
                                    background: #dc3545;
                                    color: white;
                                    border-radius: 15px 15px 0 0;
                                }

                                .modal-footer {
                                    border-top: none;
                                }

                                @media (max-width: 768px) {
                                    .appointment-content {
                                        flex-direction: column;
                                        gap: 1rem;
                                    }

                                    .doctor-info {
                                        border-right: none;
                                        border-bottom: 1px solid rgba(0, 0, 0, 0.1);
                                        padding-bottom: 1rem;
                                        flex: none;
                                    }
                                }
                            </style>
                        </head>

                        <body>
                            <!-- Include shared header -->
                            <jsp:include page="/WEB-INF/view/shared/header.jsp" />

                            <div class="appointments-container">
                                <div class="container">
                                    <h2 class="page-title">
                                        <i class="bi bi-calendar2-check"></i>
                                        Lịch hẹn của tôi
                                    </h2>

                                    <c:if test="${param.success != null}">
                                        <div class="alert alert-success" role="alert">
                                            <i class="bi bi-check-circle-fill me-2"></i>
                                            Thao tác thành công!
                                        </div>
                                    </c:if>

                                    <c:if test="${param.error != null}">
                                        <div class="alert alert-danger" role="alert">
                                            <i class="bi bi-exclamation-circle-fill me-2"></i>
                                            ${param.error}
                                        </div>
                                    </c:if>

                                    <c:forEach items="${appointments}" var="appointment">
                                        <div class="appointment-card">
                                            <div class="appointment-header">
                                                <div class="appointment-number">
                                                    <i class="bi bi-bookmark-check"></i>
                                                    Mã lịch hẹn: #${appointment.appointmentNumber}
                                                </div>
                                                <span class="status-badge 
                                            ${appointment.status == 'Pending' ? 'status-pending' : ''}
                                            ${appointment.status == 'Confirmed' ? 'status-confirmed' : ''}
                                            ${appointment.status == 'Cancelled' ? 'status-cancelled' : ''}">
                                                    <i class="bi 
                                                ${appointment.status == 'Pending' ? 'bi-hourglass-split' : ''}
                                                ${appointment.status == 'Confirmed' ? 'bi-check-circle' : ''}
                                                ${appointment.status == 'Cancelled' ? 'bi-x-circle' : ''}">
                                                    </i>
                                                    ${appointment.status}
                                                </span>
                                            </div>
                                            <div class="appointment-content">
                                                <div class="doctor-info">
                                                    <img src="${pageContext.request.contextPath}/resources/images/defaultImg.jpg"
                                                        alt="Doctor Avatar" class="doctor-avatar">
                                                    <div class="doctor-name">
                                                        BS. ${appointment.bookingSlot.schedule.doctor.user.firstName}
                                                        ${appointment.bookingSlot.schedule.doctor.user.lastName}
                                                    </div>
                                                    <div class="doctor-specialty">
                                                        ${appointment.bookingSlot.schedule.doctor.specializations.iterator().next().specializationName}
                                                    </div>
                                                </div>
                                                <div class="appointment-details">
                                                    <div class="appointment-info">
                                                        <i class="bi bi-calendar2"></i>
                                                        <strong>Ngày:</strong>
                                                        ${appointment.appointmentDate.format(dateFormatter)}
                                                    </div>

                                                    <div class="appointment-info">
                                                        <i class="bi bi-clock"></i>
                                                        <strong>Giờ khám:</strong>
                                                        ${appointment.appointmentDate.format(timeFormatter)} -
                                                        ${appointment.appointmentDate.plusHours(1).format(timeFormatter)}
                                                    </div>

                                                    <div class="appointment-info">
                                                        <i class="bi bi-clipboard2-pulse"></i>
                                                        <strong>Loại khám:</strong>
                                                        ${appointment.appointmentType.typeName}
                                                    </div>

                                                    <div class="appointment-info">
                                                        <i class="bi bi-hospital"></i>
                                                        <strong>Phòng khám:</strong>
                                                        ${appointment.bookingSlot.schedule.clinicRoom}
                                                    </div>

                                                    <c:if test="${not empty appointment.patientNotes}">
                                                        <div class="appointment-info">
                                                            <i class="bi bi-chat-left-text"></i>
                                                            <strong>Ghi chú:</strong>
                                                            ${appointment.patientNotes}
                                                        </div>
                                                    </c:if>

                                                    <c:if
                                                        test="${appointment.status != 'Cancelled' && appointment.status != 'Completed'}">
                                                        <div class="mt-3">
                                                            <button type="button" class="cancel-btn"
                                                                data-bs-toggle="modal"
                                                                data-bs-target="#cancelModal${appointment.appointmentID}">
                                                                <i class="bi bi-x-circle me-2"></i>
                                                                Hủy lịch hẹn
                                                            </button>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Cancel Modal -->
                                        <div class="modal fade" id="cancelModal${appointment.appointmentID}"
                                            tabindex="-1">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title">
                                                            <i class="bi bi-exclamation-triangle me-2"></i>
                                                            Xác nhận hủy lịch hẹn
                                                        </h5>
                                                        <button type="button" class="btn-close btn-close-white"
                                                            data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <form action="/appointments/${appointment.appointmentID}/cancel"
                                                        method="post">
                                                        <div class="modal-body">
                                                            <div class="mb-3">
                                                                <label for="reason" class="form-label">Lý do hủy
                                                                    lịch</label>
                                                                <textarea class="form-control" id="reason" name="reason"
                                                                    rows="3"
                                                                    placeholder="Vui lòng cho chúng tôi biết lý do bạn muốn hủy lịch hẹn"
                                                                    required></textarea>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary"
                                                                data-bs-dismiss="modal">
                                                                <i class="bi bi-x me-2"></i>Đóng
                                                            </button>
                                                            <button type="submit" class="btn btn-danger">
                                                                <i class="bi bi-check2 me-2"></i>Xác nhận hủy
                                                            </button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>

                                    <c:if test="${empty appointments}">
                                        <div class="alert alert-info" role="alert">
                                            <i class="bi bi-info-circle me-2"></i>
                                            Bạn chưa có lịch hẹn nào.
                                        </div>
                                    </c:if>
                                </div>
                            </div>

                            <script
                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                            <script>
                                // Toggle dropdown menu
                                document.getElementById('profileDropdownBtn')?.addEventListener('click', function () {
                                    document.getElementById('profileDropdown').classList.toggle('show');
                                });

                                // Close dropdown when clicking outside
                                window.addEventListener('click', function (e) {
                                    if (!e.target.matches('#profileDropdownBtn')) {
                                        const dropdown = document.getElementById('profileDropdown');
                                        if (dropdown?.classList.contains('show')) {
                                            dropdown.classList.remove('show');
                                        }
                                    }
                                });
                            </script>
                        </body>

                        </html>