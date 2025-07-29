<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <html>

        <head>
            <title>Nạp tiền thành công</title>
            <jsp:include page="../shared/head.jsp" />
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/base.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/homepage.css">
            <style>
                .wallet-success-container {
                    max-width: 500px;
                    margin: 4rem auto;
                    background: #f8f9fa;
                    border-radius: 1rem;
                    box-shadow: 0 4px 24px rgba(111, 66, 193, 0.08);
                    padding: 2.5rem 2rem;
                    text-align: center;
                }

                .wallet-success-icon {
                    font-size: 4rem;
                    color: #40c057;
                    margin-bottom: 1rem;
                }

                .wallet-success-title {
                    color: #40c057;
                    font-size: 2rem;
                    font-weight: bold;
                    margin-bottom: 1rem;
                }

                .wallet-success-desc {
                    color: #333;
                    font-size: 1.1rem;
                    margin-bottom: 2rem;
                }

                .wallet-success-btn {
                    background: #6f42c1;
                    color: white;
                    border: none;
                    border-radius: 0.5rem;
                    padding: 0.75rem 2rem;
                    font-size: 1rem;
                    font-weight: 500;
                    cursor: pointer;
                    transition: background 0.2s;
                }

                .wallet-success-btn:hover {
                    background: #5a32a3;
                }
            </style>
        </head>

        <body>
            <jsp:include page="../shared/header.jsp" />
            <div class="wallet-success-container">
                <div class="wallet-success-icon">
                    <i class="bi bi-patch-check-fill"></i>
                </div>
                <div class="wallet-success-title">Nạp tiền thành công!</div>
                <div class="wallet-success-desc">Số dư ví của bạn đã được cập nhật.<br> Cảm ơn bạn đã sử dụng dịch vụ.
                </div>
                <a href="/wallet" class="wallet-success-btn">Quay lại trang ví</a>
            </div>
            <jsp:include page="../shared/footer.jsp" />
        </body>

        </html>