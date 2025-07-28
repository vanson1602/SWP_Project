<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Ví điện tử - HealthCare+</title>
                    <jsp:include page="../shared/head.jsp" />
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/base.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/homepage.css">

                    <!-- Required scripts -->
                    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
                    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/locale/vi.js"></script>
                    <script defer src="/resources/js/notifications.js"></script>

                    <style>
                        .wallet-container {
                            max-width: 1200px;
                            margin: 2rem auto;
                            padding: 0 1rem;
                        }

                        .wallet-header {
                            background: linear-gradient(135deg, #6f42c1, #8655e0);
                            color: white;
                            padding: 2rem;
                            border-radius: 1rem;
                            margin-bottom: 2rem;
                            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
                        }

                        .wallet-balance {
                            font-size: 2.5rem;
                            font-weight: bold;
                            margin: 1rem 0;
                        }

                        .wallet-actions {
                            display: flex;
                            gap: 1rem;
                            margin-top: 1rem;
                        }

                        .wallet-btn {
                            padding: 0.75rem 1.5rem;
                            border: none;
                            border-radius: 0.5rem;
                            font-weight: 500;
                            cursor: pointer;
                            transition: all 0.3s ease;
                            display: flex;
                            align-items: center;
                            gap: 0.5rem;
                        }

                        .wallet-btn-primary {
                            background: white;
                            color: #6f42c1;
                        }

                        .wallet-btn-primary:hover {
                            transform: translateY(-2px);
                            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                        }

                        .wallet-btn-outline {
                            background: transparent;
                            border: 2px solid white;
                            color: white;
                        }

                        .wallet-btn-outline:hover {
                            background: rgba(255, 255, 255, 0.1);
                            transform: translateY(-2px);
                        }

                        .transaction-list {
                            background: white;
                            border-radius: 1rem;
                            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
                            overflow: hidden;
                        }

                        .transaction-header {
                            padding: 1.5rem;
                            border-bottom: 1px solid #e4e6eb;
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                        }

                        .transaction-header h2 {
                            margin: 0;
                            font-size: 1.5rem;
                            color: #1c1e21;
                        }

                        .transaction-item {
                            padding: 1.5rem;
                            border-bottom: 1px solid #f0f2f5;
                            display: flex;
                            align-items: center;
                            gap: 1rem;
                            transition: all 0.3s ease;
                        }

                        .transaction-item:hover {
                            background: #f8f9fa;
                        }

                        .transaction-icon {
                            width: 48px;
                            height: 48px;
                            border-radius: 50%;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            flex-shrink: 0;
                        }

                        .transaction-icon.deposit {
                            background: #e7f5ff;
                            color: #228be6;
                        }

                        .transaction-icon.withdraw {
                            background: #fff5f5;
                            color: #fa5252;
                        }

                        .transaction-icon.refund {
                            background: #ebfbee;
                            color: #40c057;
                        }

                        .transaction-icon.payment {
                            background: #f8f0fc;
                            color: #be4bdb;
                        }

                        .transaction-content {
                            flex: 1;
                        }

                        .transaction-title {
                            font-weight: 500;
                            color: #1c1e21;
                            margin: 0 0 0.25rem;
                        }

                        .transaction-description {
                            color: #65676b;
                            font-size: 0.875rem;
                            margin: 0;
                        }

                        .transaction-amount {
                            font-weight: 600;
                            font-size: 1.125rem;
                        }

                        .amount-positive {
                            color: #40c057;
                        }

                        .amount-negative {
                            color: #fa5252;
                        }

                        .transaction-time {
                            color: #65676b;
                            font-size: 0.875rem;
                            margin-top: 0.25rem;
                        }

                        .pagination {
                            display: flex;
                            justify-content: center;
                            gap: 0.5rem;
                            margin-top: 2rem;
                        }

                        .pagination-btn {
                            padding: 0.5rem 1rem;
                            border: none;
                            border-radius: 0.5rem;
                            background: white;
                            color: #6f42c1;
                            cursor: pointer;
                            transition: all 0.3s ease;
                        }

                        .pagination-btn:hover:not(.active) {
                            background: #f8f9fa;
                        }

                        .pagination-btn.active {
                            background: #6f42c1;
                            color: white;
                        }

                        /* Modal styles */
                        .modal {
                            display: none;
                            position: fixed;
                            top: 0;
                            left: 0;
                            width: 100%;
                            height: 100%;
                            background: rgba(0, 0, 0, 0.5);
                            z-index: 1000;
                        }

                        .modal-content {
                            position: relative;
                            background: white;
                            width: 90%;
                            max-width: 500px;
                            margin: 2rem auto;
                            padding: 2rem;
                            border-radius: 1rem;
                            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
                        }

                        .modal-close {
                            position: absolute;
                            top: 1rem;
                            right: 1rem;
                            background: none;
                            border: none;
                            font-size: 1.5rem;
                            cursor: pointer;
                            color: #65676b;
                        }

                        .modal-header {
                            margin-bottom: 1.5rem;
                        }

                        .modal-title {
                            margin: 0;
                            font-size: 1.5rem;
                            color: #1c1e21;
                        }

                        .form-group {
                            margin-bottom: 1.5rem;
                        }

                        .form-label {
                            display: block;
                            margin-bottom: 0.5rem;
                            color: #1c1e21;
                            font-weight: 500;
                        }

                        .form-control {
                            width: 100%;
                            padding: 0.75rem;
                            border: 2px solid #e4e6eb;
                            border-radius: 0.5rem;
                            font-size: 1rem;
                            transition: all 0.3s ease;
                        }

                        .form-control:focus {
                            border-color: #6f42c1;
                            outline: none;
                            box-shadow: 0 0 0 3px rgba(111, 66, 193, 0.1);
                        }

                        .btn-submit {
                            width: 100%;
                            padding: 0.75rem;
                            border: none;
                            border-radius: 0.5rem;
                            background: #6f42c1;
                            color: white;
                            font-weight: 500;
                            cursor: pointer;
                            transition: all 0.3s ease;
                        }

                        .btn-submit:hover {
                            background: #5a32a3;
                            transform: translateY(-2px);
                        }

                        @media (max-width: 768px) {
                            .wallet-actions {
                                flex-direction: column;
                            }

                            .wallet-btn {
                                width: 100%;
                                justify-content: center;
                            }

                            .transaction-item {
                                flex-direction: column;
                                text-align: center;
                            }

                            .transaction-icon {
                                margin: 0 auto;
                            }

                            .transaction-amount {
                                margin-top: 1rem;
                            }
                        }
                    </style>
                </head>

                <body>
                    <jsp:include page="../shared/header.jsp" />

                    <div class="wallet-container">
                        <!-- Wallet Header -->
                        <div class="wallet-header">
                            <h1>Ví điện tử</h1>
                            <div class="wallet-balance">
                                <fmt:formatNumber value="${wallet.balance}" type="currency" currencySymbol="₫"
                                    maxFractionDigits="0" />
                            </div>
                            <div class="wallet-actions">
                                <button class="wallet-btn wallet-btn-primary"
                                    onclick="window.location.href='/wallet/deposit'">
                                    <i class="bi bi-plus-circle"></i> Nạp tiền
                                </button>
                                <button class="wallet-btn wallet-btn-outline" onclick="openWithdrawModal()">
                                    <i class="bi bi-dash-circle"></i> Rút tiền
                                </button>
                            </div>
                        </div>

                        <!-- Transaction List -->
                        <div class="transaction-list">
                            <div class="transaction-header">
                                <h2>Lịch sử giao dịch</h2>
                            </div>

                            <c:forEach items="${transactions.content}" var="transaction">
                                <div class="transaction-item">
                                    <div class="transaction-icon ${fn:toLowerCase(transaction.type)}">
                                        <c:choose>
                                            <c:when test="${transaction.type == 'DEPOSIT'}">
                                                <i class="bi bi-plus-circle"></i>
                                            </c:when>
                                            <c:when test="${transaction.type == 'WITHDRAW'}">
                                                <i class="bi bi-dash-circle"></i>
                                            </c:when>
                                            <c:when test="${transaction.type == 'REFUND'}">
                                                <i class="bi bi-arrow-counterclockwise"></i>
                                            </c:when>
                                            <c:when test="${transaction.type == 'PAYMENT'}">
                                                <i class="bi bi-credit-card"></i>
                                            </c:when>
                                        </c:choose>
                                    </div>

                                    <div class="transaction-content">
                                        <h3 class="transaction-title">
                                            <c:choose>
                                                <c:when test="${transaction.type == 'DEPOSIT'}">Nạp tiền</c:when>
                                                <c:when test="${transaction.type == 'WITHDRAW'}">Rút tiền</c:when>
                                                <c:when test="${transaction.type == 'REFUND'}">Hoàn tiền</c:when>
                                                <c:when test="${transaction.type == 'PAYMENT'}">Thanh toán</c:when>
                                            </c:choose>
                                        </h3>
                                        <p class="transaction-description">${transaction.description}</p>
                                        <p class="transaction-time">
                                            ${transaction.createdAt != null ?
                                            transaction.createdAt.toString().replace('T', ' ').substring(0, 16) : ''}
                                        </p>
                                    </div>

                                    <div
                                        class="transaction-amount ${transaction.type == 'DEPOSIT' || transaction.type == 'REFUND' ? 'amount-positive' : 'amount-negative'}">
                                        <c:choose>
                                            <c:when
                                                test="${transaction.type == 'DEPOSIT' || transaction.type == 'REFUND'}">
                                                +</c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                        <fmt:formatNumber value="${transaction.amount}" type="currency"
                                            currencySymbol="₫" maxFractionDigits="0" />
                                    </div>
                                </div>
                            </c:forEach>

                            <!-- Pagination -->
                            <c:if test="${transactions.totalPages > 1}">
                                <div class="pagination">
                                    <c:forEach begin="0" end="${transactions.totalPages - 1}" var="i">
                                        <a href="?page=${i}"
                                            class="pagination-btn ${currentPage == i ? 'active' : ''}">${i
                                            + 1}</a>
                                    </c:forEach>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Deposit Modal -->
                    <div id="depositModal" class="modal">
                        <div class="modal-content">
                            <button class="modal-close" onclick="closeModal('depositModal')">&times;</button>
                            <div class="modal-header">
                                <h2 class="modal-title">Nạp tiền vào ví</h2>
                            </div>
                            <form id="depositForm" onsubmit="handleDeposit(event)">
                                <div class="form-group">
                                    <label class="form-label" for="depositAmount">Số tiền</label>
                                    <input type="number" id="depositAmount" name="amount" class="form-control" required
                                        min="10000" step="10000">
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="depositDescription">Ghi chú</label>
                                    <textarea id="depositDescription" name="description" class="form-control"
                                        rows="3"></textarea>
                                </div>
                                <button type="submit" class="btn-submit">Xác nhận</button>
                            </form>
                        </div>
                    </div>

                    <!-- Withdraw Modal -->
                    <div id="withdrawModal" class="modal">
                        <div class="modal-content">
                            <button class="modal-close" onclick="closeModal('withdrawModal')">&times;</button>
                            <div class="modal-header">
                                <h2 class="modal-title">Rút tiền từ ví</h2>
                            </div>
                            <form id="withdrawForm" onsubmit="handleWithdraw(event)">
                                <div class="form-group">
                                    <label class="form-label" for="withdrawAmount">Số tiền</label>
                                    <input type="number" id="withdrawAmount" name="amount" class="form-control" required
                                        min="10000" step="10000">
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="withdrawDescription">Ghi chú</label>
                                    <textarea id="withdrawDescription" name="description" class="form-control"
                                        rows="3"></textarea>
                                </div>
                                <button type="submit" class="btn-submit">Xác nhận</button>
                            </form>
                        </div>
                    </div>

                    <script>
                        // CSRF token
                        const csrfToken = document.querySelector("meta[name='_csrf']").getAttribute("content");
                        const csrfHeader = document.querySelector("meta[name='_csrf_header']").getAttribute("content");

                        // Modal functions
                        function openDepositModal() {
                            document.getElementById('depositModal').style.display = 'block';
                        }

                        function openWithdrawModal() {
                            document.getElementById('withdrawModal').style.display = 'block';
                        }

                        function closeModal(modalId) {
                            document.getElementById(modalId).style.display = 'none';
                        }

                        // Close modal when clicking outside
                        window.onclick = function (event) {
                            if (event.target.className === 'modal') {
                                event.target.style.display = 'none';
                            }
                        }

                        // Handle deposit
                        async function handleDeposit(event) {
                            event.preventDefault();
                            const form = event.target;
                            const amount = form.amount.value;
                            const description = form.description.value;

                            try {
                                const response = await fetch('/wallet/deposit', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/x-www-form-urlencoded',
                                        [csrfHeader]: csrfToken
                                    },
                                    body: `amount=${amount}&description=${description}`
                                });

                                const data = await response.json();
                                if (data.success) {
                                    alert(data.message);
                                    location.reload();
                                } else {
                                    alert(data.error || 'Có lỗi xảy ra');
                                }
                            } catch (error) {
                                alert('Có lỗi xảy ra');
                            }
                        }

                        // Handle withdraw
                        async function handleWithdraw(event) {
                            event.preventDefault();
                            const form = event.target;
                            const amount = form.amount.value;
                            const description = form.description.value;

                            try {
                                const response = await fetch('/wallet/withdraw', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/x-www-form-urlencoded',
                                        [csrfHeader]: csrfToken
                                    },
                                    body: `amount=${amount}&description=${description}`
                                });

                                const data = await response.json();
                                if (data.success) {
                                    alert(data.message);
                                    location.reload();
                                } else {
                                    alert(data.error || 'Có lỗi xảy ra');
                                }
                            } catch (error) {
                                alert('Có lỗi xảy ra');
                            }
                        }
                    </script>
                </body>

                </html>