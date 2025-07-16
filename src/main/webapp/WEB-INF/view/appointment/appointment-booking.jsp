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
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/base.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/homepage.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/appointment-style.css">
            <style>
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

                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                    min-height: 100vh;
                }

                .main-content {
                    padding: 2rem 0;
                }

                .booking-container {
                    background: white;
                    border-radius: 15px;
                    padding: 2rem;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                    margin-bottom: 2rem;
                }

                .page-title {
                    color: #2c3e50;
                    margin-bottom: 2rem;
                    font-weight: 600;
                    font-size: 2rem;
                    display: flex;
                    align-items: center;
                    gap: 0.5rem;
                }

                .step-container {
                    background: white;
                    border-radius: 10px;
                    padding: 1.5rem;
                    margin-bottom: 1.5rem;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                }

                .step-title {
                    color: #0061f2;
                    font-size: 1.2rem;
                    font-weight: 600;
                    margin-bottom: 1rem;
                    display: flex;
                    align-items: center;
                    gap: 0.5rem;
                }

                .form-label {
                    color: #2c3e50;
                    font-weight: 500;
                }

                .form-control {
                    border-radius: 8px;
                    border: 1px solid #dee2e6;
                    padding: 0.8rem;
                }

                .form-control:focus {
                    border-color: #0061f2;
                    box-shadow: 0 0 0 0.2rem rgba(0, 97, 242, 0.25);
                }

                .btn-primary {
                    background: linear-gradient(135deg, #0061f2 0%, #00a7e1 100%);
                    border: none;
                    padding: 0.8rem 2rem;
                    font-weight: 500;
                    border-radius: 8px;
                    display: inline-flex;
                    align-items: center;
                    gap: 0.5rem;
                    transition: all 0.3s ease;
                }

                .btn-primary:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 4px 15px rgba(0, 97, 242, 0.3);
                }

                .btn-outline-primary {
                    color: #0061f2;
                    border-color: #0061f2;
                    background: white;
                    padding: 0.8rem 2rem;
                    font-weight: 500;
                    border-radius: 8px;
                    display: inline-flex;
                    align-items: center;
                    gap: 0.5rem;
                    transition: all 0.3s ease;
                }

                .btn-outline-primary:hover {
                    background: #0061f2;
                    color: white;
                    transform: translateY(-2px);
                    box-shadow: 0 4px 15px rgba(0, 97, 242, 0.3);
                }

                .specialty-card {
                    background: white;
                    border: 1px solid #dee2e6;
                    border-radius: 10px;
                    padding: 1.5rem;
                    margin-bottom: 1rem;
                    transition: all 0.3s ease;
                    cursor: pointer;
                }

                .specialty-card:hover {
                    border-color: #0061f2;
                    transform: translateY(-2px);
                    box-shadow: 0 4px 15px rgba(0, 97, 242, 0.1);
                }

                .specialty-card.selected {
                    border-color: #0061f2;
                    background: rgba(0, 97, 242, 0.05);
                }

                .doctor-card {
                    background: white;
                    border: 1px solid #dee2e6;
                    border-radius: 10px;
                    overflow: hidden;
                    transition: all 0.3s ease;
                }

                .doctor-card:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 4px 15px rgba(0, 97, 242, 0.1);
                }

                .doctor-image {
                    width: 120px;
                    height: 120px;
                    border-radius: 50%;
                    object-fit: cover;
                    margin: 1rem auto;
                    border: 3px solid #0061f2;
                }

                .doctor-info {
                    padding: 1.5rem;
                    text-align: center;
                }

                .doctor-name {
                    color: #2c3e50;
                    font-weight: 600;
                    margin-bottom: 0.5rem;
                }

                .doctor-specialty {
                    color: #6c757d;
                    font-size: 0.9rem;
                    margin-bottom: 1rem;
                }

                .time-slot {
                    background: white;
                    border: 1px solid #dee2e6;
                    border-radius: 8px;
                    padding: 1rem;
                    margin-bottom: 0.5rem;
                    cursor: pointer;
                    transition: all 0.3s ease;
                }

                .time-slot:hover {
                    border-color: #0061f2;
                    background: rgba(0, 97, 242, 0.05);
                }

                .time-slot.selected {
                    border-color: #0061f2;
                    background: rgba(0, 97, 242, 0.05);
                }

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

                @media (max-width: 768px) {
                    .booking-container {
                        padding: 1.5rem;
                    }

                    .page-title {
                        font-size: 1.5rem;
                    }

                    .btn-primary,
                    .btn-outline-primary {
                        width: 100%;
                        justify-content: center;
                    }
                }
            </style>
        </head>

        <body>
            <!-- Include shared header -->
            <jsp:include page="/WEB-INF/view/shared/header.jsp" />

            <!-- Add after header include -->
            <div class="main-content">
                <div class="container">
                    <!-- Breadcrumb -->
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="/">Trang chủ</a></li>
                            <li class="breadcrumb-item"><a href="/appointments">Quản lý lịch hẹn</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Đặt lịch hẹn</li>
                        </ol>
                    </nav>

                    <!-- Main Content -->
                    <main class="main-content">
                        <div class="container">
                            <!-- Page Title -->
                            <div class="page-title text-center mb-5">
                                <h1 class="h2 mb-3">
                                    <i class="bi bi-calendar-plus me-2"></i>
                                    Đặt Lịch Khám
                                </h1>
                                <p class="text-muted">Vui lòng đọc kỹ các lưu ý trước khi đặt lịch</p>
                            </div>

                            <!-- Important Notices -->
                            <div class="row mb-5">
                                <div class="col-12">
                                    <div class="booking-container">
                                        <h3 class="h4 mb-4">
                                            <i class="bi bi-exclamation-circle me-2 text-primary"></i>
                                            Lưu ý quan trọng
                                        </h3>

                                        <div class="notice-list">
                                            <div class="notice-item mb-4">
                                                <h5 class="text-primary">
                                                    <i class="bi bi-clock me-2"></i>
                                                    Thời gian khám bệnh
                                                </h5>
                                                <ul class="list-unstyled ps-4 text-muted">
                                                    <li class="mb-2">• Thứ 2 - Thứ 7: 7:30 - 17:00</li>
                                                    <li>• Chủ nhật: 7:30 - 12:00</li>
                                                </ul>
                                            </div>

                                            <div class="notice-item mb-4">
                                                <h5 class="text-primary">
                                                    <i class="bi bi-file-text me-2"></i>
                                                    Giấy tờ cần mang theo
                                                </h5>
                                                <ul class="list-unstyled ps-4 text-muted">
                                                    <li class="mb-2">• CMND/CCCD (bắt buộc)</li>
                                                    <li class="mb-2">• Thẻ BHYT (nếu có)</li>
                                                    <li>• Các giấy tờ, kết quả khám bệnh trước đây (nếu có)</li>
                                                </ul>
                                            </div>

                                            <div class="notice-item mb-4">
                                                <h5 class="text-primary">
                                                    <i class="bi bi-info-circle me-2"></i>
                                                    Quy trình đặt lịch
                                                </h5>
                                                <ul class="list-unstyled ps-4 text-muted">
                                                    <li class="mb-2">• Chọn chuyên khoa phù hợp</li>
                                                    <li class="mb-2">• Chọn bác sĩ và thời gian khám</li>
                                                    <li class="mb-2">• Điền thông tin cá nhân</li>
                                                    <li>• Thanh toán phí khám để hoàn tất đặt lịch</li>
                                                </ul>
                                            </div>

                                            <div class="notice-item">
                                                <h5 class="text-primary">
                                                    <i class="bi bi-telephone me-2"></i>
                                                    Hỗ trợ
                                                </h5>
                                                <ul class="list-unstyled ps-4 text-muted">
                                                    <li class="mb-2">• Hotline: 999999999</li>
                                                    <li class="mb-2">• Email: support@medicare.com</li>
                                                    <li>• Địa chỉ: Đại học FPT, Đà Nẵng</li>
                                                </ul>
                                            </div>
                                        </div>

                                        <hr class="my-4">

                                        <!-- Confirmation -->
                                        <div class="confirmation-section">
                                            <form id="bookingForm"
                                                action="${pageContext.request.contextPath}/appointments/specialty"
                                                method="GET">
                                                <div class="form-check mb-4">
                                                    <input class="form-check-input" type="checkbox" id="confirmCheck"
                                                        required>
                                                    <label class="form-check-label" for="confirmCheck">
                                                        Tôi đã đọc và hiểu rõ các lưu ý trên
                                                    </label>
                                                </div>

                                                <button type="submit" class="btn btn-primary btn-lg" id="proceedBtn"
                                                    disabled>
                                                    <i class="bi bi-arrow-right-circle me-2"></i>
                                                    Tiếp tục đặt lịch
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </main>
                </div>
            </div>

            <!-- Include shared footer -->
            <jsp:include page="/WEB-INF/view/shared/footer.jsp" />

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                const form = document.getElementById('bookingForm');
                const checkbox = document.getElementById('confirmCheck');
                const submitBtn = document.getElementById('proceedBtn');

                checkbox.addEventListener('change', function () {
                    submitBtn.disabled = !this.checked;
                });

                form.addEventListener('submit', function (e) {
                    if (!checkbox.checked) {
                        e.preventDefault();
                        alert('Vui lòng đọc và đồng ý với các lưu ý trước khi tiếp tục.');
                    }
                });
            </script>
        </body>

        </html>