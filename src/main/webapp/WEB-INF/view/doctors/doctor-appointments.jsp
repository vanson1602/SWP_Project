<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>HealthCare+ - Lịch hẹn Bác sĩ</title>
            <jsp:include page="../shared/head.jsp" />
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/base.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/homepage.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/doctor-appointments.css">
        </head>

        <body>
            <!-- Include shared header -->
            <jsp:include page="../shared/header-doctor.jsp" />

            <!-- Appointment Section -->
            <section class="appointments-section">
                <div class="container">
                    <h1 class="page-title">Lịch hẹn của bạn</h1>

                    <!-- Today's Bookings -->
                    <h2 class="section-title">
                        <i class="bi bi-calendar-day"></i>
                        Lịch hẹn hôm nay
                    </h2>
                    <div class="appointment-cards">
                        <c:choose>
                            <c:when test="${not empty bookingSlots}">
                                <c:forEach var="slot" items="${bookingSlots}">
                                    <div class="appointment-card">
                                        <div class="appointment-item">
                                            <div class="appointment-info">
                                                <div class="appointment-time">
                                                    <i class="bi bi-clock"></i>
                                                    ${slot.startTime} - ${slot.endTime}
                                                </div>
                                                <c:if test="${not empty slot.appointment.patient}">
                                                    <div class="appointment-patient">
                                                        <i class="bi bi-person"></i>
                                                        ${slot.appointment.patient.user.firstName}
                                                        ${slot.appointment.patient.user.lastName}
                                                    </div>
                                                </c:if>
                                            </div>
                                            <div class="d-flex align-items-center gap-3">
                                                <span
                                                    class="status-badge ${slot.status == 'Available' ? 'status-available' : 'status-confirmed'}">
                                                    ${slot.status}
                                                </span>
                                                <c:if test="${not empty slot.appointment.patient}">
                                                    <a href="<c:url value='/doctor/appointments/${slot.appointment.appointmentID}' />"
                                                        class="action-button view-btn">
                                                        <i class="bi bi-eye"></i> Xem chi tiết
                                                    </a>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="bi bi-calendar-x"></i>
                                    <p>Không có lịch hẹn nào trong ngày hôm nay</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                </div>
            </section>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>