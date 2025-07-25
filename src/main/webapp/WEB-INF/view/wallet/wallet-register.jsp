<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Đăng ký ví điện tử - HealthCare+</title>
            <jsp:include page="../shared/head.jsp" />
            <meta name="_csrf" content="${_csrf.token}">
            <meta name="_csrf_header" content="${_csrf.headerName}">

            <style>
                .register-container {
                    max-width: 800px;
                    margin: 3rem auto;
                    padding: 0 1rem;
                }

                .register-card {
                    background: white;
                    border-radius: 1rem;
                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
                    overflow: hidden;
                }

                .register-header {
                    background: linear-gradient(135deg, #6f42c1, #8655e0);
                    color: white;
                    padding: 2rem;
                    text-align: center;
                }

                .register-header h1 {
                    margin: 0;
                    font-size: 2rem;
                    font-weight: 600;
                }

                .register-header p {
                    margin: 1rem 0 0;
                    opacity: 0.9;
                }

                .register-content {
                    padding: 2rem;
                }

                .feature-list {
                    list-style: none;
                    padding: 0;
                    margin: 0 0 2rem;
                }

                .feature-item {
                    display: flex;
                    align-items: center;
                    gap: 1rem;
                    padding: 1rem;
                    border-radius: 0.5rem;
                    transition: all 0.3s ease;
                }

                .feature-item:hover {
                    background: #f8f9fa;
                }

                .feature-icon {
                    width: 48px;
                    height: 48px;
                    border-radius: 50%;
                    background: #e7f5ff;
                    color: #228be6;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 1.5rem;
                    flex-shrink: 0;
                }

                .feature-content h3 {
                    margin: 0 0 0.5rem;
                    color: #1c1e21;
                    font-size: 1.25rem;
                }

                .feature-content p {
                    margin: 0;
                    color: #65676b;
                    font-size: 0.875rem;
                }

                .register-button {
                    display: block;
                    width: 100%;
                    padding: 1rem;
                    border: none;
                    border-radius: 0.5rem;
                    background: #6f42c1;
                    color: white;
                    font-size: 1.125rem;
                    font-weight: 500;
                    text-align: center;
                    cursor: pointer;
                    transition: all 0.3s ease;
                }

                .register-button:hover {
                    background: #5a32a3;
                    transform: translateY(-2px);
                }

                .register-button:disabled {
                    background: #e4e6eb;
                    cursor: not-allowed;
                    transform: none;
                }

                .bonus-badge {
                    display: inline-block;
                    padding: 0.5rem 1rem;
                    background: rgba(255, 255, 255, 0.2);
                    border-radius: 2rem;
                    font-size: 0.875rem;
                    margin-top: 1rem;
                }

                @media (max-width: 768px) {
                    .register-container {
                        margin: 1rem auto;
                    }

                    .register-header {
                        padding: 1.5rem;
                    }

                    .register-content {
                        padding: 1.5rem;
                    }

                    .feature-item {
                        flex-direction: column;
                        text-align: center;
                    }

                    .feature-icon {
                        margin: 0 auto;
                    }
                }
            </style>
        </head>

        <body>
            <jsp:include page="../shared/header.jsp" />

            <div class="register-container">
                <div class="register-card">
                    <div class="register-header">
                        <h1>Đăng ký ví điện tử</h1>
                        <p>Thanh toán dễ dàng, nhanh chóng và an toàn</p>
                    </div>

                    <div class="register-content">
                        <ul class="feature-list">
                            <li class="feature-item">
                                <div class="feature-icon">
                                    <i class="bi bi-shield-check"></i>
                                </div>
                                <div class="feature-content">
                                    <h3>An toàn & Bảo mật</h3>
                                    <p>Mọi giao dịch đều được mã hóa và bảo vệ theo tiêu chuẩn bảo mật cao nhất</p>
                                </div>
                            </li>
                            <li class="feature-item">
                                <div class="feature-icon">
                                    <i class="bi bi-lightning-charge"></i>
                                </div>
                                <div class="feature-content">
                                    <h3>Thanh toán nhanh chóng</h3>
                                    <p>Thanh toán các dịch vụ y tế chỉ với vài thao tác đơn giản</p>
                                </div>
                            </li>
                            <li class="feature-item">
                                <div class="feature-icon">
                                    <i class="bi bi-arrow-repeat"></i>
                                </div>
                                <div class="feature-content">
                                    <h3>Hoàn tiền dễ dàng</h3>
                                    <p>Nhận hoàn tiền tự động khi hủy lịch hẹn theo quy định</p>
                                </div>
                            </li>
                        </ul>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger" style="margin: 1rem 0;">${error}</div>
                        </c:if>
                        <c:if test="${not empty message}">
                            <div class="alert alert-success" style="margin: 1rem 0;">${message}</div>
                        </c:if>

                        <form method="post" action="/wallet/register" style="margin-top: 2rem;">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <button type="submit" class="register-button">Đăng ký ngay</button>
                        </form>
                    </div>
                </div>
            </div>
        </body>

        </html>