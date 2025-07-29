<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <html>

        <head>
            <title>Hủy nạp tiền</title>
            <jsp:include page="../shared/head.jsp" />
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/base.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/homepage.css">
            <style>
                .wallet-cancel-container {
                    max-width: 500px;
                    margin: 4rem auto;
                    background: #fff0f0;
                    border-radius: 1rem;
                    box-shadow: 0 4px 24px rgba(250, 82, 82, 0.08);
                    padding: 2.5rem 2rem;
                    text-align: center;
                }

                .wallet-cancel-icon {
                    font-size: 4rem;
                    color: #fa5252;
                    margin-bottom: 1rem;
                }

                .wallet-cancel-title {
                    color: #fa5252;
                    font-size: 2rem;
                    font-weight: bold;
                    margin-bottom: 1rem;
                }

                .wallet-cancel-desc {
                    color: #333;
                    font-size: 1.1rem;
                    margin-bottom: 2rem;
                }

                .wallet-cancel-btn {
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

                .wallet-cancel-btn:hover {
                    background: #5a32a3;
                }
            </style>
        </head>

        <body>
            <jsp:include page="../shared/header.jsp" />
            <div class="wallet-cancel-container">
                <div class="wallet-cancel-icon">
                    <i class="bi bi-x-octagon-fill"></i>
                </div>
                <div class="wallet-cancel-title">Bạn đã hủy giao dịch nạp tiền</div>
                <div class="wallet-cancel-desc">Không có thay đổi nào đối với số dư ví của bạn.</div>
                <a href="/wallet" class="wallet-cancel-btn">Quay lại trang ví</a>
            </div>
            <jsp:include page="../shared/footer.jsp" />
        </body>

        </html>