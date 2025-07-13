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
                            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/base.css">
                            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/homepage.css">
                            <style>
                                body {
                                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                                    background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                                    min-height: 100vh;
                                }

                                .appointments-container {
                                    padding: 2rem 0;
                                }

                                .page-title {
                                    color: #2c3e50;
                                    margin-bottom: 2rem;
                                    text-align: center;
                                    font-weight: 600;
                                    font-size: 2.2rem;
                                }

                                /* Filter Styles */
                                .filter-container {
                                    background: white;
                                    padding: 1.5rem;
                                    border-radius: 15px;
                                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                                    margin-bottom: 2rem;
                                }

                                .filter-container .btn {
                                    padding: 0.8rem 1.5rem;
                                    border-radius: 10px;
                                    font-weight: 500;
                                    transition: all 0.3s ease;
                                    min-width: 140px;
                                    display: flex;
                                    align-items: center;
                                    justify-content: center;
                                    gap: 8px;
                                }

                                .filter-container .btn i {
                                    font-size: 1.1rem;
                                }

                                .filter-container .btn-outline-primary:hover {
                                    background: #007bff;
                                    color: white;
                                    transform: translateY(-2px);
                                }

                                .filter-container .btn-outline-warning:hover {
                                    background: #ffc107;
                                    color: #000;
                                    transform: translateY(-2px);
                                }

                                .filter-container .btn-outline-success:hover {
                                    background: #28a745;
                                    color: white;
                                    transform: translateY(-2px);
                                }

                                .filter-container .btn-outline-danger:hover {
                                    background: #dc3545;
                                    color: white;
                                    transform: translateY(-2px);
                                }

                                /* Card Styles */
                                .appointment-card {
                                    background: white;
                                    border-radius: 15px;
                                    margin-bottom: 1.5rem;
                                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
                                    transition: transform 0.3s ease, box-shadow 0.3s ease;
                                    border: none;
                                    overflow: hidden;
                                }

                                .appointment-card:hover {
                                    transform: translateY(-5px);
                                    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
                                }

                                .appointment-header {
                                    background: linear-gradient(135deg, #0061f2 0%, #00a7e1 100%);
                                    color: white;
                                    padding: 1.2rem 1.5rem;
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
                                    border: 3px solid #0061f2;
                                }

                                .doctor-name {
                                    font-size: 1.2rem;
                                    font-weight: 600;
                                    color: #2c3e50;
                                    margin-bottom: 0.5rem;
                                }

                                .doctor-specialty {
                                    color: #666;
                                    font-size: 0.95rem;
                                    margin-bottom: 1rem;
                                    font-style: italic;
                                }

                                .appointment-details {
                                    flex: 1;
                                    padding: 0 1rem;
                                }

                                .appointment-info {
                                    display: flex;
                                    align-items: center;
                                    gap: 12px;
                                    margin-bottom: 1rem;
                                    color: #555;
                                    padding: 0.8rem;
                                    border-radius: 10px;
                                    background: #f8f9fa;
                                    transition: all 0.3s ease;
                                }

                                .appointment-info:hover {
                                    background: #e9ecef;
                                    transform: translateX(5px);
                                }

                                .appointment-info i {
                                    color: #0061f2;
                                    font-size: 1.2rem;
                                    width: 24px;
                                }

                                /* Status Badge Styles */
                                .status-badge {
                                    padding: 0.6rem 1.2rem;
                                    border-radius: 25px;
                                    font-weight: 500;
                                    display: inline-flex;
                                    align-items: center;
                                    gap: 8px;
                                    font-size: 0.95rem;
                                    text-transform: uppercase;
                                    letter-spacing: 0.5px;
                                }

                                .status-pending {
                                    background-color: #fff3cd;
                                    color: #856404;
                                    border: 1px solid #ffeeba;
                                }

                                .status-confirmed {
                                    background-color: #d4edda;
                                    color: #155724;
                                    border: 1px solid #c3e6cb;
                                }

                                .status-cancelled {
                                    background-color: #f8d7da;
                                    color: #721c24;
                                    border: 1px solid #f5c6cb;
                                }

                                /* Action Buttons */
                                .action-buttons {
                                    display: flex;
                                    gap: 1rem;
                                    margin-top: 1.5rem;
                                }

                                .btn {
                                    padding: 0.7rem 1.5rem;
                                    border-radius: 10px;
                                    font-weight: 500;
                                    display: inline-flex;
                                    align-items: center;
                                    gap: 8px;
                                    transition: all 0.3s ease;
                                }

                                .btn:hover {
                                    transform: translateY(-2px);
                                }

                                .btn-payment {
                                    background: linear-gradient(135deg, #0061f2 0%, #00a7e1 100%);
                                    color: white;
                                    border: none;
                                }

                                .btn-payment:hover {
                                    background: linear-gradient(135deg, #0052cc 0%, #0095c8 100%);
                                    box-shadow: 0 4px 15px rgba(0, 97, 242, 0.2);
                                }

                                .btn-cancel {
                                    background: linear-gradient(135deg, #dc3545 0%, #ff6b6b 100%);
                                    color: white;
                                    border: none;
                                }

                                .btn-cancel:hover {
                                    background: linear-gradient(135deg, #c82333 0%, #ff5252 100%);
                                    box-shadow: 0 4px 15px rgba(220, 53, 69, 0.2);
                                }

                                /* Modal Styles */
                                .modal-content {
                                    border-radius: 15px;
                                    border: none;
                                }

                                .modal-header {
                                    background: linear-gradient(135deg, #dc3545 0%, #ff6b6b 100%);
                                    color: white;
                                    border-radius: 15px 15px 0 0;
                                    padding: 1.5rem;
                                }

                                .modal-body {
                                    padding: 2rem;
                                }

                                .modal-footer {
                                    border-top: none;
                                    padding: 1.5rem;
                                }

                                .form-control {
                                    border-radius: 10px;
                                    padding: 0.8rem 1rem;
                                    border: 1px solid #dee2e6;
                                }

                                .form-control:focus {
                                    border-color: #0061f2;
                                    box-shadow: 0 0 0 0.2rem rgba(0, 97, 242, 0.25);
                                }

                                /* Responsive Design */
                                @media (max-width: 768px) {
                                    .appointment-content {
                                        flex-direction: column;
                                        gap: 1.5rem;
                                    }

                                    .doctor-info {
                                        border-right: none;
                                        border-bottom: 1px solid rgba(0, 0, 0, 0.1);
                                        padding-bottom: 1.5rem;
                                        flex: none;
                                    }

                                    .action-buttons {
                                        flex-direction: column;
                                    }

                                    .btn {
                                        width: 100%;
                                        justify-content: center;
                                    }

                                    .filter-container .btn {
                                        padding: 0.6rem 1rem;
                                        min-width: auto;
                                    }
                                }

                                /* Alert Styles */
                                .alert {
                                    border-radius: 10px;
                                    padding: 1rem 1.5rem;
                                    margin-bottom: 1.5rem;
                                    border: none;
                                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                                }

                                .alert-success {
                                    background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
                                    color: #155724;
                                }

                                .alert-danger {
                                    background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
                                    color: #721c24;
                                }

                                .alert-info {
                                    background: linear-gradient(135deg, #d1ecf1 0%, #bee5eb 100%);
                                    color: #0c5460;
                                }

                                /* Pagination Styles */
                                .pagination {
                                    gap: 5px;
                                }

                                .page-link {
                                    border-radius: 8px;
                                    padding: 8px 16px;
                                    color: #0061f2;
                                    border: 1px solid #dee2e6;
                                    transition: all 0.3s ease;
                                }

                                .page-link:hover {
                                    background-color: #e9ecef;
                                    color: #0056b3;
                                    border-color: #dee2e6;
                                    transform: translateY(-2px);
                                }

                                .page-item.active .page-link {
                                    background-color: #0061f2;
                                    border-color: #0061f2;
                                    color: white;
                                }

                                .page-item.disabled .page-link {
                                    color: #6c757d;
                                    pointer-events: none;
                                    background-color: #fff;
                                    border-color: #dee2e6;
                                }

                                /* Breadcrumb Styles */
                                .breadcrumb {
                                    margin: 1rem 0;
                                    font-size: 0.95rem;
                                    background: white;
                                    padding: 1rem;
                                    border-radius: 10px;
                                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                                }

                                .breadcrumb-item a {
                                    color: #0061f2;
                                    text-decoration: none;
                                    transition: color 0.3s ease;
                                }

                                .breadcrumb-item a:hover {
                                    color: #0056b3;
                                }

                                .breadcrumb-item.active {
                                    color: #6c757d;
                                }

                                .breadcrumb-item+.breadcrumb-item::before {
                                    content: "/"
                                }
                            </style>
                        </head>

                        <body>
                            <!-- Include shared header -->
                            <jsp:include page="/WEB-INF/view/shared/header.jsp" />

                            <div class="main-content">
                                <div class="container">
                                    <!-- Breadcrumb -->
                                    <nav aria-label="breadcrumb">
                                        <ol class="breadcrumb">
                                            <li class="breadcrumb-item"><a href="/">Trang chủ</a></li>
                                            <li class="breadcrumb-item"><a href="/appointments">Quản lý lịch hẹn</a>
                                            </li>
                                            <li class="breadcrumb-item active" aria-current="page">Lịch hẹn của tôi</li>
                                        </ol>
                                    </nav>

                                    <div class="appointments-container">
                                        <h2 class="page-title">
                                            <i class="bi bi-calendar2-check"></i>
                                            Lịch hẹn của tôi
                                        </h2>

                                        <!-- Filter Options -->
                                        <div class="filter-container mb-4">
                                            <div class="d-flex justify-content-center gap-2">
                                                <a href="/appointments/my-appointments${empty param.status ? '?status=all' : '?status=all'}"
                                                    class="btn ${empty param.status || param.status == 'all' ? 'btn-primary' : 'btn-outline-primary'}">
                                                    <i class="bi bi-list-check"></i> Tất cả
                                                </a>
                                                <a href="/appointments/my-appointments?status=Pending"
                                                    class="btn ${param.status == 'Pending' ? 'btn-warning' : 'btn-outline-warning'}">
                                                    <i class="bi bi-hourglass-split"></i> Đang xử lý
                                                </a>
                                                <a href="/appointments/my-appointments?status=Confirmed"
                                                    class="btn ${param.status == 'Confirmed' ? 'btn-success' : 'btn-outline-success'}">
                                                    <i class="bi bi-check-circle"></i> Đã xác nhận
                                                </a>
                                                <a href="/appointments/my-appointments?status=Cancelled"
                                                    class="btn ${param.status == 'Cancelled' ? 'btn-danger' : 'btn-outline-danger'}">
                                                    <i class="bi bi-x-circle"></i> Đã hủy
                                                </a>
                                            </div>
                                        </div>

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
                                                            <c:choose>
                                                                <c:when test="${appointment.doctor != null}">
                                                                    BS. ${appointment.doctor.user.firstName}
                                                                    ${appointment.doctor.user.lastName}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    BS.
                                                                    ${appointment.bookingSlot.schedule.doctor.user.firstName}
                                                                    ${appointment.bookingSlot.schedule.doctor.user.lastName}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div class="doctor-specialty">
                                                            <c:choose>
                                                                <c:when test="${appointment.doctor != null}">
                                                                    <c:forEach
                                                                        items="${appointment.doctor.specializations}"
                                                                        var="spec" varStatus="loop">
                                                                        <c:if test="${loop.first}">
                                                                            ${spec.specializationName}</c:if>
                                                                    </c:forEach>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <c:forEach
                                                                        items="${appointment.bookingSlot.schedule.doctor.specializations}"
                                                                        var="spec" varStatus="loop">
                                                                        <c:if test="${loop.first}">
                                                                            ${spec.specializationName}</c:if>
                                                                    </c:forEach>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                    <div class="appointment-details">
                                                        <div class="appointment-info">
                                                            <i class="bi bi-calendar-date"></i>
                                                            <span>Ngày khám:
                                                                ${appointment.appointmentDate.format(dateFormatter)}</span>
                                                        </div>
                                                        <div class="appointment-info">
                                                            <i class="bi bi-clock"></i>
                                                            <span>Giờ khám:
                                                                ${appointment.appointmentDate.format(timeFormatter)} →
                                                                ${appointment.appointmentDate.plusHours(1).format(timeFormatter)}</span>
                                                        </div>
                                                        <div class="appointment-info">
                                                            <i class="bi bi-cash"></i>
                                                            <span>Phí khám:
                                                                <c:choose>
                                                                    <c:when test="${appointment.doctor != null}">
                                                                        ${appointment.doctor.consultationFee}đ
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        ${appointment.bookingSlot.schedule.doctor.consultationFee}đ
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </div>
                                                        <div class="appointment-info">
                                                            <i class="bi bi-card-text"></i>
                                                            <span>Ghi chú: ${not empty appointment.patientNotes ?
                                                                appointment.patientNotes : 'Không có'}</span>
                                                        </div>

                                                        <!-- Action Buttons -->
                                                        <div class="action-buttons">
                                                            <c:if test="${appointment.status == 'Pending'}">
                                                                <a href="${pageContext.request.contextPath}/appointments/payment?appointmentId=${appointment.appointmentID}"
                                                                    class="btn btn-payment">
                                                                    <i class="bi bi-credit-card"></i>
                                                                    Thanh toán ngay
                                                                </a>
                                                            </c:if>
                                                            <c:if
                                                                test="${appointment.status != 'Cancelled' && appointment.status != 'Completed'}">
                                                                <button type="button" class="btn btn-cancel"
                                                                    data-bs-toggle="modal"
                                                                    data-bs-target="#cancelModal${appointment.appointmentID}">
                                                                    <i class="bi bi-x-circle"></i>
                                                                    Hủy lịch hẹn
                                                                </button>
                                                            </c:if>
                                                        </div>
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
                                                                    <textarea class="form-control" id="reason"
                                                                        name="reason" rows="3"
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

                                        <!-- Pagination -->
                                        <c:if test="${totalPages > 1}">
                                            <nav aria-label="Page navigation" class="mt-4">
                                                <ul class="pagination justify-content-center">
                                                    <!-- Previous button -->
                                                    <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                                                        <a class="page-link"
                                                            href="/appointments/my-appointments?status=${currentStatus}&page=${currentPage - 1}">
                                                            <i class="bi bi-chevron-left"></i>
                                                        </a>
                                                    </li>

                                                    <!-- Page numbers -->
                                                    <c:forEach begin="0" end="${totalPages - 1}" var="i">
                                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                            <a class="page-link"
                                                                href="/appointments/my-appointments?status=${currentStatus}&page=${i}">
                                                                ${i + 1}
                                                            </a>
                                                        </li>
                                                    </c:forEach>

                                                    <!-- Next button -->
                                                    <li
                                                        class="page-item ${currentPage + 1 >= totalPages ? 'disabled' : ''}">
                                                        <a class="page-link"
                                                            href="/appointments/my-appointments?status=${currentStatus}&page=${currentPage + 1}">
                                                            <i class="bi bi-chevron-right"></i>
                                                        </a>
                                                    </li>
                                                </ul>
                                            </nav>

                                            <div class="text-center mt-3">
                                                <small class="text-muted">
                                                    Hiển thị ${currentPage * 5 + 1} đến
                                                    ${Math.min((currentPage + 1) * 5, totalItems)}
                                                    trong tổng số ${totalItems} lịch hẹn
                                                </small>
                                            </div>
                                        </c:if>
                                    </div>
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