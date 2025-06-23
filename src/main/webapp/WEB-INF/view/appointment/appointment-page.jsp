<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý lịch hẹn - HealthCare+</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <!-- Common CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/homepage.css">
        <style>
            .breadcrumb {
                margin: 1rem 0;
                font-size: 0.95rem;
            }

            .breadcrumb-item a {
                color: #0d6efd;
                text-decoration: none;
            }

            .breadcrumb-item.active {
                color: #6c757d;
            }

            .breadcrumb-item+.breadcrumb-item::before {
                content: "/"
            }

            .nav-pills {
                background: white;
                padding: 1rem;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                margin-bottom: 2rem;
            }

            .nav-pills .nav-link {
                color: #6c757d;
                padding: 1rem 2rem;
                border-radius: 8px;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 0.5rem;
                transition: all 0.3s ease;
            }

            .nav-pills .nav-link:hover {
                background-color: #f8f9fa;
                color: #0d6efd;
            }

            .nav-pills .nav-link.active {
                background: linear-gradient(135deg, #0061f2 0%, #00a7e1 100%);
                color: white;
            }

            .nav-pills .nav-link i {
                font-size: 1.2rem;
            }

            .content-section {
                background: white;
                border-radius: 15px;
                padding: 2rem;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }

            .section-title {
                color: #2c3e50;
                font-size: 1.8rem;
                font-weight: 600;
                margin-bottom: 1.5rem;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .section-description {
                color: #6c757d;
                margin-bottom: 2rem;
                line-height: 1.6;
            }

            .btn-primary {
                background: linear-gradient(135deg, #0061f2 0%, #00a7e1 100%);
                border: none;
                padding: 0.8rem 2rem;
                font-weight: 500;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                transition: all 0.3s ease;
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0, 97, 242, 0.3);
            }

            @media (max-width: 768px) {
                .nav-pills {
                    flex-direction: column;
                    gap: 0.5rem;
                }

                .nav-pills .nav-link {
                    width: 100%;
                    text-align: left;
                }
            }
        </style>
    </head>

    <body>
        <!-- Include shared header -->
        <jsp:include page="../shared/header.jsp" />

        <div class="main-content">
            <div class="container">
                <!-- Breadcrumb -->
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="/">Trang chủ</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Quản lý lịch hẹn</li>
                    </ol>
                </nav>

                <!-- Navigation Pills -->
                <ul class="nav nav-pills justify-content-center mb-4">
                    <li class="nav-item">
                        <a class="nav-link" href="/appointments/booking">
                            <i class="bi bi-calendar-plus"></i>
                            Đặt lịch hẹn
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/appointments/my-appointments">
                            <i class="bi bi-calendar-week"></i>
                            Lịch hẹn của tôi
                        </a>
                    </li>
                </ul>

                <!-- Content Section -->
                <div class="content-section">
                    <h2 class="section-title">
                        <i class="bi bi-calendar-check"></i>
                        Quản lý lịch hẹn
                    </h2>
                    <p class="section-description">
                        Chào mừng bạn đến với hệ thống quản lý lịch hẹn. Tại đây, bạn có thể dễ dàng đặt lịch hẹn mới
                        với bác sĩ hoặc xem và quản lý các lịch hẹn hiện có của mình.
                    </p>
                    <div class="row g-4">
                        <div class="col-md-6">
                            <div class="card h-100">
                                <div class="card-body">
                                    <h5 class="card-title">
                                        <i class="bi bi-calendar-plus text-primary"></i>
                                        Đặt lịch hẹn mới
                                    </h5>
                                    <p class="card-text">Đặt lịch hẹn mới với bác sĩ. Chọn thời gian phù hợp và điền
                                        thông tin cần thiết.</p>
                                    <a href="/appointments/booking" class="btn btn-primary">
                                        <i class="bi bi-plus-circle"></i>
                                        Đặt lịch ngay
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card h-100">
                                <div class="card-body">
                                    <h5 class="card-title">
                                        <i class="bi bi-calendar-week text-primary"></i>
                                        Xem lịch hẹn
                                    </h5>
                                    <p class="card-text">Xem danh sách các lịch hẹn của bạn. Theo dõi trạng thái và quản
                                        lý các cuộc hẹn.</p>
                                    <a href="/appointments/my-appointments" class="btn btn-primary">
                                        <i class="bi bi-eye"></i>
                                        Xem lịch hẹn
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Include shared footer -->
        <jsp:include page="../shared/footer.jsp" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Highlight active nav link based on current URL
            document.addEventListener('DOMContentLoaded', function () {
                const currentPath = window.location.pathname;
                const navLinks = document.querySelectorAll('.nav-pills .nav-link');

                navLinks.forEach(link => {
                    if (currentPath === link.getAttribute('href')) {
                        link.classList.add('active');
                    }
                });
            });
        </script>
    </body>

    </html>