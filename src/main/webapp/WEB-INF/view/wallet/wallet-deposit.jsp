<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <html>

        <head>
            <title>Nạp tiền vào ví</title>
            <jsp:include page="../shared/head.jsp" />
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/base.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/homepage.css">

            <!-- Required scripts -->
            <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/locale/vi.js"></script>
            <script defer src="/resources/js/notifications.js"></script>
            <style>
                .wallet-deposit-container {
                    max-width: 500px;
                    margin: 4rem auto;
                    background: #f8f9fa;
                    border-radius: 1rem;
                    box-shadow: 0 4px 24px rgba(111, 66, 193, 0.08);
                    padding: 2.5rem 2rem;
                    text-align: center;
                }

                .wallet-deposit-title {
                    color: #6f42c1;
                    font-size: 2rem;
                    font-weight: bold;
                    margin-bottom: 1.5rem;
                }

                .wallet-deposit-form {
                    display: flex;
                    flex-direction: column;
                    gap: 1.5rem;
                }

                .wallet-deposit-label {
                    font-weight: 500;
                    color: #1c1e21;
                    margin-bottom: 0.5rem;
                    text-align: left;
                }

                .wallet-deposit-input {
                    width: 100%;
                    padding: 0.75rem;
                    border: 2px solid #e4e6eb;
                    border-radius: 0.5rem;
                    font-size: 1rem;
                    transition: border 0.2s;
                }

                .wallet-deposit-input:focus {
                    border-color: #6f42c1;
                    outline: none;
                    box-shadow: 0 0 0 3px rgba(111, 66, 193, 0.08);
                }

                .wallet-deposit-btn {
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

                .wallet-deposit-btn:hover {
                    background: #5a32a3;
                }
            </style>
        </head>

        <body>
            <jsp:include page="../shared/header.jsp" />
            <div class="wallet-deposit-container">
                <div class="wallet-deposit-title">Nạp tiền vào ví</div>
                <form action="/wallet/deposit" method="post" class="wallet-deposit-form">
                    <div>
                        <label for="amount" class="wallet-deposit-label">Số tiền muốn nạp (VNĐ):</label>
                        <input type="number" id="amount" name="amount" min="1000" step="1000" required
                            class="wallet-deposit-input" />
                    </div>
                    <button type="submit" class="wallet-deposit-btn">Nạp tiền</button>
                </form>
            </div>
            <jsp:include page="../shared/footer.jsp" />
        </body>

        </html>