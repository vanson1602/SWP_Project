<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Hóa Đơn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .invoice-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.05);
        }
        .invoice-header {
            background: linear-gradient(135deg, #4e54c8 0%, #8f94fb 100%);
            color: white;
            padding: 20px;
            border-radius: 15px 15px 0 0;
        }
        .invoice-body {
            padding: 30px;
        }
        .info-group {
            margin-bottom: 20px;
        }
        .info-label {
            font-weight: 600;
            color: #4a5568;
            margin-bottom: 5px;
        }
        .info-value {
            color: #2d3748;
        }
        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 500;
        }
        @media print {
            .no-print {
                display: none !important;
            }
            .invoice-card {
                box-shadow: none;
            }
            body {
                background: white !important;
            }
        }
    </style>
</head>
<body class="bg-light">
    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card invoice-card">
                    <div class="invoice-header">
                        <h3 class="mb-0">
                            <i class="fas fa-file-invoice me-2"></i>
                            Chi Tiết Hóa Đơn #${invoice.invoiceNumber}
                        </h3>
                    </div>
                    <div class="invoice-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="info-group">
                                    <div class="info-label">Mã Hóa Đơn</div>
                                    <div class="info-value">${invoice.invoiceNumber}</div>
                                </div>
                                <div class="info-group">
                                    <div class="info-label">Ngày Tạo</div>
                                    <div class="info-value">
                                        <fmt:formatDate value="${invoice.invoiceDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </div>
                                </div>
                                <div class="info-group">
                                    <div class="info-label">Trạng Thái</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${invoice.paymentStatus == 'Paid' || invoice.paymentStatus == 'Đã thanh toán'}">
                                                <span class="status-badge bg-success">Đã thanh toán</span>
                                            </c:when>
                                            <c:when test="${invoice.paymentStatus == 'Pending' || invoice.paymentStatus == 'Chờ thanh toán'}">
                                                <span class="status-badge bg-warning">Chờ thanh toán</span>
                                            </c:when>
                                            <c:when test="${invoice.paymentStatus == 'Cancelled' || invoice.paymentStatus == 'Đã hủy'}">
                                                <span class="status-badge bg-danger">Đã hủy</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge bg-secondary">${invoice.paymentStatus}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-group">
                                    <div class="info-label">Bệnh Nhân</div>
                                    <div class="info-value">
                                        ${invoice.patient.user.fullName}
                                    </div>
                                </div>
                                <div class="info-group">
                                    <div class="info-label">Tổng Tiền</div>
                                    <div class="info-value">
                                        <fmt:formatNumber value="${invoice.finalAmount}" type="number" pattern="#,##0"/> VNĐ
                                    </div>
                                </div>
                            </div>
                        </div>

                        <hr class="my-4">

                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Dịch Vụ</th>
                                        <th class="text-end">Đơn Giá</th>
                                        <th class="text-end">Số Lượng</th>
                                        <th class="text-end">Thành Tiền</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="detail" items="${invoice.invoiceDetails}">
                                        <tr>
                                            <td>${detail.description}</td>
                                            <td class="text-end">
                                                <fmt:formatNumber value="${detail.unitPrice}" type="number" pattern="#,##0"/> VNĐ
                                            </td>
                                            <td class="text-end">${detail.quantity}</td>
                                            <td class="text-end">
                                                <fmt:formatNumber value="${detail.totalPrice}" type="number" pattern="#,##0"/> VNĐ
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <td colspan="3" class="text-end fw-bold">Tổng cộng:</td>
                                        <td class="text-end fw-bold">
                                            <fmt:formatNumber value="${invoice.finalAmount}" type="number" pattern="#,##0"/> VNĐ
                                        </td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>

                        <div class="d-flex justify-content-between mt-4 no-print">
                            <a href="${pageContext.request.contextPath}/admin/dashboard-${param.filter != null ? param.filter : 'day'}" class="btn btn-secondary">
                                <i class="fas fa-arrow-left me-2"></i>Quay lại
                            </a>
                            <button class="btn btn-primary" onclick="window.print()">
                                <i class="fas fa-print me-2"></i>In hóa đơn
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 