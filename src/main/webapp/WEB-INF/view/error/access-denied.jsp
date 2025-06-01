<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Không có quyền truy cập - HealthCare+</title>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                display: flex;
                align-items: center;
                justify-content: center;
                min-height: 100vh;
                margin: 0;
                background: #f5f5f5;
            }

            .error-container {
                text-align: center;
                padding: 2rem;
                background: white;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                max-width: 500px;
                width: 90%;
            }

            h1 {
                color: #dc3545;
                margin-bottom: 1rem;
            }

            p {
                color: #6c757d;
                margin-bottom: 2rem;
            }

            .btn {
                display: inline-block;
                padding: 10px 20px;
                background: #007bff;
                color: white;
                text-decoration: none;
                border-radius: 5px;
                transition: background 0.3s;
            }

            .btn:hover {
                background: #0056b3;
            }
        </style>
    </head>

    <body>
        <div class="error-container">
            <h1>⚠️ Không có quyền truy cập</h1>
            <p>Bạn không có quyền truy cập vào trang này. Vui lòng liên hệ quản trị viên nếu bạn cho rằng đây là một sự
                nhầm lẫn.</p>
            <a href="/" class="btn">Quay về trang chủ</a>
        </div>
    </body>

    </html>