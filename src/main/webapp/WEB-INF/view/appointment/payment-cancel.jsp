<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Thanh toán thất bại - Healthcare</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"
                    rel="stylesheet">
                <style>
                    .card {
                        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                    }

                    .btn {
                        margin: 5px;
                    }

                    .alert-info {
                        background-color: #f8f9fa;
                        border-color: #ddd;
                    }
                </style>
            </head>

            <body>
                <%@ include file="../shared/header.jsp" %>

                    <% java.time.format.DateTimeFormatter
                        dateFormatter=java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");
                        java.time.format.DateTimeFormatter
                        timeFormatter=java.time.format.DateTimeFormatter.ofPattern("HH:mm");
                        request.setAttribute("dateFormatter", dateFormatter); request.setAttribute("timeFormatter",
                        timeFormatter); %>

                        <div class="container mt-5">
                            <div class="row justify-content-center">
                                <div class="col-md-8">
                                    <div class="card border-danger">
                                        <div class="card-body text-center">
                                            <i class="fas fa-times-circle text-danger" style="font-size: 64px;"></i>
                                            <h2 class="card-title mt-3 text-danger">Thanh toán thất bại</h2>
                                            <p class="card-text">
                                                Rất tiếc, giao dịch của bạn không thể hoàn thành.
                                                <br>
                                                Vui lòng thử lại hoặc chọn phương thức thanh toán khác.
                                            </p>

                                            <div class="mt-4">
                                                <c:if test="${not empty appointment}">
                                                    <div class="alert alert-info">
                                                        <h5>Thông tin lịch hẹn:</h5>
                                                        <p>Mã lịch hẹn: ${appointment.appointmentNumber}</p>
                                                        <p>Bác sĩ:
                                                            ${appointment.bookingSlot.schedule.doctor.user.fullName}</p>
                                                        <p>Ngày khám:
                                                            ${appointment.appointmentDate.format(dateFormatter)}</p>
                                                        <p>Giờ khám:
                                                            ${appointment.appointmentDate.format(timeFormatter)} →
                                                            ${appointment.appointmentDate.plusHours(1).format(timeFormatter)}
                                                        </p>
                                                        <p>Loại khám: ${appointment.appointmentType.typeName}</p>
                                                    </div>
                                                </c:if>
                                            </div>

                                            <div class="mt-4">
                                                <a href="/appointments/payment?appointmentId=${appointment.appointmentID}"
                                                    class="btn btn-primary">
                                                    <i class="fas fa-redo"></i> Thử thanh toán lại
                                                </a>
                                                <a href="/appointments/my-appointments" class="btn btn-secondary">
                                                    <i class="fas fa-list"></i> Xem danh sách lịch hẹn
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%@ include file="../shared/footer.jsp" %>

                            <!-- Bootstrap JS and dependencies -->
                            <script
                                src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
                            <script
                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js"></script>
            </body>

            </html>