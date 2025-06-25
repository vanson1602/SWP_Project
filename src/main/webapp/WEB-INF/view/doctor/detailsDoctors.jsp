<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${doctor.user.firstName} ${doctor.user.lastName} - HealthCare+</title>
            <link rel="stylesheet"
                href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="/css/homepage.css">
            <link rel="stylesheet" href="/resources/css/shared.css">
            <style>
                body {
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column;
                }

                main {
                    flex: 1;
                }

                .doctor-header {
                    background: linear-gradient(135deg, #6f42c1, #8655e0);
                    padding: 3rem 0;
                    color: white;
                }

                .doctor-avatar {
                    width: 150px;
                    height: 150px;
                    object-fit: cover;
                    border: 4px solid white;
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                }

                .info-card {
                    background: white;
                    border-radius: 10px;
                    padding: 1.5rem;
                    height: 100%;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                    margin-bottom: 1.5rem;
                }

                .booking-btn {
                    background-color: #6f42c1;
                    color: white;
                    border: none;
                    padding: 0.75rem 2rem;
                    border-radius: 5px;
                    transition: all 0.3s ease;
                    text-decoration: none;
                    display: inline-block;
                    width: 100%;
                    text-align: center;
                }

                .booking-btn:hover {
                    background-color: #5a32a3;
                    color: white;
                }

                .specialization-badge {
                    background-color: #e9ecef;
                    color: #495057;
                    padding: 0.35rem 0.75rem;
                    border-radius: 20px;
                    margin-right: 0.5rem;
                    margin-bottom: 0.5rem;
                    display: inline-block;
                }

                .contact-info {
                    margin-bottom: 0.5rem;
                }

                .contact-info i {
                    width: 20px;
                    text-align: center;
                    margin-right: 0.5rem;
                }
            </style>
        </head>

        <body>
            <!-- Include Header -->
            <jsp:include page="../shared/header.jsp" />

            <main>
                <!-- Doctor Header Section -->
                <section class="doctor-header">
                    <div class="container">
                        <div class="row align-items-center">
                            <div class="col-md-3 text-center">
                                <img src="${empty doctor.user.avatarUrl ? '/images/default-avatar.png' : doctor.user.avatarUrl}"
                                    alt="BS. ${doctor.user.firstName} ${doctor.user.lastName}"
                                    class="rounded-circle doctor-avatar mb-3">
                            </div>
                            <div class="col-md-9">
                                <h2 class="mb-2">BS. ${doctor.user.firstName} ${doctor.user.lastName}</h2>
                                <div class="mb-3">
                                    <c:forEach items="${doctor.specializations}" var="spec">
                                        <span class="specialization-badge">${spec.specializationName}</span>
                                    </c:forEach>
                                </div>
                                <p class="mb-2"><i class="bi bi-briefcase-fill me-2"></i>${doctor.experienceYears} năm
                                    kinh
                                    nghiệm</p>
                                <p class="mb-0"><i class="bi bi-award-fill me-2"></i>${doctor.qualification}</p>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Main Content Section -->
                <section class="py-5">
                    <div class="container">
                        <div class="row">
                            <!-- Left Column -->
                            <div class="col-lg-8">
                                <div class="info-card">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h5 class="mb-3">Chuyên khoa</h5>
                                            <ul class="list-unstyled">
                                                <c:forEach items="${doctor.specializations}" var="spec">
                                                    <li class="mb-3">
                                                        <div><i
                                                                class="bi bi-check-circle-fill text-success me-2"></i>${spec.specializationName}
                                                        </div>
                                                        <c:if test="${not empty spec.description}">
                                                            <small
                                                                class="text-muted d-block ms-4">${spec.description}</small>
                                                        </c:if>
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                        <div class="col-md-6">
                                            <h5 class="mb-3">Thông tin bằng cấp</h5>
                                            <p class="contact-info"><i
                                                    class="bi bi-award-fill text-primary"></i>${doctor.qualification}
                                            </p>
                                            <p class="contact-info"><i
                                                    class="bi bi-patch-check-fill text-primary"></i>Mã bác sĩ:
                                                ${doctor.doctorCode}</p>
                                            <p class="contact-info mb-0"><i
                                                    class="bi bi-shield-check text-primary"></i>Số giấy phép:
                                                ${doctor.licenseNumber}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Right Column -->
                            <div class="col-lg-4">
                                <div class="info-card">
                                    <h5 class="mb-3">Thông tin khám bệnh</h5>
                                    <p class="contact-info">
                                        <i class="bi bi-cash text-primary"></i>
                                        <strong>Phí khám:</strong> ${doctor.consultationFee} VNĐ
                                    </p>
                                    <p class="contact-info"><i class="bi bi-geo-alt-fill text-primary"></i>Phòng khám
                                        HealthCare+</p>
                                    <p class="contact-info"><i class="bi bi-building text-primary"></i>Tầng 2, Tòa nhà A
                                    </p>
                                    <p class="contact-info"><i class="bi bi-telephone-fill text-primary"></i>Hotline:
                                        1900 xxxx</p>

                                    <hr class="my-3">

                                    <h5 class="mb-3">Thông tin liên hệ</h5>
                                    <p class="contact-info"><i
                                            class="bi bi-envelope text-primary"></i>${doctor.user.email}</p>
                                    <c:if test="${not empty doctor.user.phone}">
                                        <p class="contact-info"><i
                                                class="bi bi-telephone text-primary"></i>${doctor.user.phone}</p>
                                    </c:if>
                                    <c:if test="${not empty doctor.user.address}">
                                        <p class="contact-info mb-4"><i
                                                class="bi bi-geo-alt text-primary"></i>${doctor.user.address}</p>
                                    </c:if>
                                    <a href="/appointments/time?doctorId=${doctor.doctorID}" class="booking-btn">
                                        <i class="bi bi-calendar-check me-2"></i>Đặt lịch khám
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            </main>

            <!-- Include Footer -->
            <jsp:include page="../shared/footer.jsp" />

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>