<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thanh toán thành công - HealthCare+</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }

            .main-content {
                flex: 1;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 2rem;
            }

            .success-container {
                background: white;
                border-radius: 15px;
                padding: 3rem;
                text-align: center;
                max-width: 600px;
                width: 100%;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                animation: fadeInUp 0.5s ease-out;
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .success-icon {
                width: 80px;
                height: 80px;
                background: #28a745;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 2rem;
                animation: scaleIn 0.3s ease-out;
            }

            @keyframes scaleIn {
                from {
                    transform: scale(0);
                }

                to {
                    transform: scale(1);
                }
            }

            .success-icon i {
                font-size: 40px;
                color: white;
            }

            h1 {
                color: #28a745;
                margin-bottom: 1rem;
                font-weight: 600;
            }

            p {
                color: #6c757d;
                font-size: 1.1rem;
                margin-bottom: 2rem;
            }

            .btn-group {
                display: flex;
                gap: 1rem;
                justify-content: center;
            }

            .btn {
                padding: 0.75rem 2rem;
                font-weight: 500;
                border-radius: 50px;
                transition: all 0.3s ease;
            }

            .btn-primary {
                background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
                border: none;
            }

            .btn-outline-primary {
                border: 2px solid #007bff;
                color: #007bff;
            }

            .btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            }

            @media (max-width: 576px) {
                .success-container {
                    padding: 2rem;
                }

                .btn-group {
                    flex-direction: column;
                }

                .btn {
                    width: 100%;
                }
            }
        </style>
    </head>

    <body>
        <!-- Include shared header -->
        <jsp:include page="/WEB-INF/view/shared/header.jsp" />

        <!-- Main Content -->
        <main class="main-content">
            <div class="success-container">
                <div class="success-icon">
                    <i class="bi bi-check-lg"></i>
                </div>
                <h1>Thanh toán thành công!</h1>
                <p>Cảm ơn bạn đã đặt lịch khám tại HealthCare+. Chúng tôi đã gửi email xác nhận đến địa chỉ email của
                    bạn.</p>
                <div class="btn-group">
                    <a href="/appointments/my-appointments" class="btn btn-primary">
                        <i class="bi bi-calendar2-check"></i> Xem lịch hẹn của tôi
                    </a>
                    <a href="/" class="btn btn-outline-primary">
                        <i class="bi bi-house"></i> Về trang chủ
                    </a>
                </div>
            </div>
        </main>
    </body>

    </html>