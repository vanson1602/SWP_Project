<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Lỗi - HealthCare+</title>
            <link rel="stylesheet"
                href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/base.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/homepage.css">
            <style>
                .error-container {
                    min-height: 60vh;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    padding: 2rem;
                }

                .error-content {
                    text-align: center;
                    max-width: 600px;
                    padding: 2rem;
                    background: white;
                    border-radius: 15px;
                    box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
                }

                .error-icon {
                    font-size: 4rem;
                    color: #dc3545;
                    margin-bottom: 1rem;
                }

                .error-title {
                    color: #dc3545;
                    font-size: 1.5rem;
                    margin-bottom: 1rem;
                }

                .error-message {
                    color: #6c757d;
                    margin-bottom: 2rem;
                }

                .action-buttons {
                    display: flex;
                    gap: 1rem;
                    justify-content: center;
                }

                .btn-back {
                    background: linear-gradient(135deg, #0061f2 0%, #00a7e1 100%);
                    color: white;
                    border: none;
                    padding: 0.7rem 1.5rem;
                    border-radius: 10px;
                    font-weight: 500;
                    display: inline-flex;
                    align-items: center;
                    gap: 8px;
                    transition: all 0.3s ease;
                }

                .btn-back:hover {
                    background: linear-gradient(135deg, #0052cc 0%, #0095c8 100%);
                    transform: translateY(-2px);
                    color: white;
                }

                .btn-home {
                    background: white;
                    color: #0061f2;
                    border: 2px solid #0061f2;
                    padding: 0.7rem 1.5rem;
                    border-radius: 10px;
                    font-weight: 500;
                    display: inline-flex;
                    align-items: center;
                    gap: 8px;
                    transition: all 0.3s ease;
                }

                .btn-home:hover {
                    background: #f8f9fa;
                    transform: translateY(-2px);
                    color: #0052cc;
                }
            </style>
        </head>

        <body>
            <jsp:include page="../shared/header.jsp" />

            <div class="main-content">
                <div class="container">
                    <!-- Breadcrumb -->
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/appointments">Quản
                                    lý lịch hẹn</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Lỗi</li>
                        </ol>
                    </nav>

                    <div class="error-container">
                        <div class="error-content">
                            <i class="bi bi-exclamation-circle-fill error-icon"></i>
                            <h1 class="error-title">Đã xảy ra lỗi</h1>
                            <p class="error-message">
                                <c:choose>
                                    <c:when test="${not empty error}">
                                        ${error}
                                    </c:when>
                                    <c:otherwise>
                                        Đã có lỗi xảy ra trong quá trình xử lý yêu cầu của bạn. Vui lòng thử lại sau.
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <div class="action-buttons">
                                <a href="javascript:history.back()" class="btn btn-back">
                                    <i class="bi bi-arrow-left"></i>
                                    Quay lại
                                </a>
                                <a href="${pageContext.request.contextPath}/" class="btn btn-home">
                                    <i class="bi bi-house"></i>
                                    Trang chủ
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <jsp:include page="../shared/footer.jsp" />
        </body>

        </html>