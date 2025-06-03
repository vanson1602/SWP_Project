<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Quên Mật Khẩu - HealthCare+</title>
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                    height: 100vh;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }

                .forgot-password-container {
                    background: white;
                    padding: 2rem;
                    border-radius: 10px;
                    box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
                    width: 100%;
                    max-width: 400px;
                }

                .logo-section {
                    text-align: center;
                    margin-bottom: 2rem;
                }

                .logo {
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    gap: 0.5rem;
                    margin-bottom: 1rem;
                }

                .logo-icon {
                    font-size: 2rem;
                }

                .logo-text {
                    font-size: 1.5rem;
                    font-weight: bold;
                    color: #2563eb;
                }

                h2 {
                    color: #1e293b;
                    text-align: center;
                    margin-bottom: 0.5rem;
                }

                .description {
                    color: #64748b;
                    text-align: center;
                    margin-bottom: 2rem;
                    font-size: 0.9rem;
                }

                .form-group {
                    margin-bottom: 1.5rem;
                }

                .form-label {
                    display: block;
                    margin-bottom: 0.5rem;
                    color: #1e293b;
                    font-weight: 500;
                }

                .form-input {
                    width: 100%;
                    padding: 0.75rem;
                    border: 1px solid #e2e8f0;
                    border-radius: 0.5rem;
                    font-size: 1rem;
                    transition: border-color 0.2s;
                }

                .form-input:focus {
                    outline: none;
                    border-color: #2563eb;
                    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
                }

                .submit-btn {
                    width: 100%;
                    padding: 0.75rem;
                    background-color: #2563eb;
                    color: white;
                    border: none;
                    border-radius: 0.5rem;
                    font-size: 1rem;
                    font-weight: 500;
                    cursor: pointer;
                    transition: background-color 0.2s;
                }

                .submit-btn:hover {
                    background-color: #1d4ed8;
                }

                .back-to-login {
                    text-align: center;
                    margin-top: 1.5rem;
                }

                .back-to-login a {
                    color: #2563eb;
                    text-decoration: none;
                    font-weight: 500;
                }

                .back-to-login a:hover {
                    text-decoration: underline;
                }

                .error-message {
                    background-color: #fee2e2;
                    color: #dc2626;
                    padding: 0.75rem;
                    border-radius: 0.5rem;
                    margin-bottom: 1rem;
                    text-align: center;
                }

                .success-message {
                    background-color: #dcfce7;
                    color: #16a34a;
                    padding: 0.75rem;
                    border-radius: 0.5rem;
                    margin-bottom: 1rem;
                    text-align: center;
                }
            </style>
        </head>

        <body>
            <div class="forgot-password-container">
                <div class="logo-section">
                    <div class="logo">
                        <div class="logo-icon">⚕️</div>
                        <div class="logo-text">HealthCare+</div>
                    </div>
                    <h2>Quên Mật Khẩu</h2>
                    <p class="description">Nhập email của bạn để nhận hướng dẫn đặt lại mật khẩu</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="error-message">
                        ${error}
                    </div>
                </c:if>

                <c:if test="${not empty message}">
                    <div class="success-message">
                        ${message}
                    </div>
                </c:if>

                <form action="/forgot-password" method="post">
                    <div class="form-group">
                        <label class="form-label" for="email">Email</label>
                        <input type="email" id="email" name="email" class="form-input" placeholder="Nhập email của bạn"
                            required>
                    </div>

                    <button type="submit" class="submit-btn">Gửi Yêu Cầu</button>
                </form>

                <div class="back-to-login">
                    <a href="/login">← Quay lại trang đăng nhập</a>
                </div>
            </div>
        </body>

        </html>