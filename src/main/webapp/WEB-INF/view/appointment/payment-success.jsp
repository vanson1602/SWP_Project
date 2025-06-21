<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thanh toán thành công - HealthCare+</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>

    <body>
        <!-- Include shared header -->
        <jsp:include page="/WEB-INF/view/shared/header.jsp" />

        <!-- Main Content -->
        <main class="main-content">
            <div class="container">
                <div class="success-container text-center">
                    <div class="success-icon">
                        <i class="bi bi-check-circle-fill text-success" style="font-size: 5rem;"></i>
                    </div>
                    <h1 class="mt-4">Thanh toán thành công!</h1>
                    <p class="lead mb-4">Cảm ơn bạn đã đặt lịch khám. Chúng tôi sẽ gửi email xác nhận chi tiết đến địa
                        chỉ email của bạn.</p>

                    <div class="action-buttons mt-5">
                        <a href="/appointments/my-appointments" class="btn btn-primary me-3">
                            Xem lịch hẹn của tôi
                        </a>
                        <a href="/" class="btn btn-outline-primary">
                            Về trang chủ
                        </a>
                    </div>
                </div>
            </div>
        </main>

        <style>
            .success-container {
                max-width: 600px;
                margin: 4rem auto;
                padding: 2rem;
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }

            .success-icon {
                margin-bottom: 1rem;
            }

            .success-icon i {
                color: #28a745;
            }

            .action-buttons {
                margin-top: 2rem;
            }

            .btn {
                padding: 0.75rem 1.5rem;
                font-weight: 500;
            }
        </style>
    </body>

    </html>