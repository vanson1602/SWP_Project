<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Đặt Lịch Khám - HealthCare+</title>
            <link rel="stylesheet"
                href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/appointment-style.css">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        </head>

        <body>
            <!-- Include shared header -->
            <jsp:include page="/WEB-INF/view/shared/header.jsp" />

            <!-- Main Content -->
            <main class="main-content">
                <div class="container">
                    <!-- Page Title -->
                    <div class="page-title text-center">
                        <h1>Đặt Lịch Khám</h1>
                        <p>Chọn phương thức đặt lịch phù hợp với bạn</p>
                    </div>

                    <!-- Booking Options -->
                    <div class="row justify-content-center mt-5">
                        <!-- Option 1: Đặt theo chuyên khoa -->
                        <div class="col-md-6 col-lg-4 mb-4">
                            <div class="card h-100 border-0 shadow-sm">
                                <div class="card-body text-center p-4">
                                    <div class="specialty-icon mb-3">
                                        <i class="fas fa-stethoscope fa-3x text-primary"></i>
                                    </div>
                                    <h3 class="card-title h4 mb-3">Đặt theo chuyên khoa</h3>
                                    <p class="card-text text-muted mb-4">
                                        Chọn chuyên khoa phù hợp với nhu cầu khám của bạn
                                    </p>
                                    <a href="${pageContext.request.contextPath}/appointments/specialty"
                                        class="btn btn-primary btn-lg w-100">
                                        <i class="fas fa-chevron-right me-2"></i>
                                        Chọn chuyên khoa
                                    </a>
                                </div>
                            </div>
                        </div>

                    </div>

                    <!-- Additional Information -->
                    <div class="row mt-5">
                        <div class="col-12">
                            <div class="card border-0 shadow-sm">
                                <div class="card-body p-4">
                                    <h4 class="mb-4">Thông tin cần biết</h4>
                                    <div class="row g-4">
                                        <div class="col-md-6">
                                            <div class="d-flex align-items-start">
                                                <i class="fas fa-clock text-primary me-3 mt-1"></i>
                                                <div>
                                                    <h5 class="h6 mb-2">Thời gian khám</h5>
                                                    <p class="text-muted mb-0">
                                                        Thứ 2 - Thứ 7: 7:30 - 17:00<br>
                                                        Chủ nhật: 7:30 - 12:00
                                                    </p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="d-flex align-items-start">
                                                <i class="fas fa-info-circle text-primary me-3 mt-1"></i>
                                                <div>
                                                    <h5 class="h6 mb-2">Chuẩn bị</h5>
                                                    <p class="text-muted mb-0">
                                                        CMND/CCCD<br>
                                                        Thẻ BHYT (nếu có)
                                                    </p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="d-flex align-items-start">
                                                <i class="fas fa-phone-alt text-primary me-3 mt-1"></i>
                                                <div>
                                                    <h5 class="h6 mb-2">Hỗ trợ</h5>
                                                    <p class="text-muted mb-0">
                                                        Hotline: 1900 1234<br>
                                                        Email: support@medicare.com
                                                    </p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="d-flex align-items-start">
                                                <i class="fas fa-map-marker-alt text-primary me-3 mt-1"></i>
                                                <div>
                                                    <h5 class="h6 mb-2">Địa chỉ</h5>
                                                    <p class="text-muted mb-0">
                                                        Đại học FPT<br>
                                                        Khu CNC Hòa Lạc, Thạch Thất, Hà Nội
                                                    </p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>

            <!-- Footer -->
            <footer class="bg-light mt-5 py-4">
                <div class="container">
                    <div class="text-center text-muted">
                        <p class="mb-0">&copy; 2024 MediCare. All rights reserved.</p>
                    </div>
                </div>
            </footer>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>