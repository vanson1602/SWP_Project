<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
        <%@ page contentType="text/html;charset=UTF-8" language="java" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>Danh sách Feedback</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
                    rel="stylesheet">
                <style>
                    body {
                        background: linear-gradient(135deg, #667eea, #764ba2);
                        font-family: 'Segoe UI', sans-serif;
                        padding: 0.5rem;
                        color: #333;
                    }

                    .card {
                        border-radius: 15px;
                        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
                        overflow: hidden;
                    }

                    .card-header {
                        background: linear-gradient(135deg, #4facfe, #7B76C8);
                        color: white;
                        padding: 1.5rem;
                    }

                    .card-header h4 {
                        margin: 0;
                        font-weight: 600;
                    }

                    .btn-back {
                        background: white;
                        border: none;
                        color: #333;
                        font-weight: 500;
                        border-radius: 30px;
                        padding: 0.5rem 1rem;
                    }

                    .search-bar {
                        margin-top: 1rem;
                    }

                    .search-bar .form-select,
                    .search-bar .form-control {
                        border-radius: 10px;
                    }

                    .table td,
                    .table th {
                        vertical-align: middle !important;
                    }

                    .pagination {
                        justify-content: center;
                        margin-top: 1.5rem;
                    }
                </style>
            </head>

            <body>

                <div class="container">
                    <div class="card mb-4">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h4><i class="bi bi-chat-dots me-2"></i>Danh sách Feedback</h4>
                            <button class="btn btn-back" onclick="history.back()">
                                <i class="bi bi-arrow-left-circle me-1"></i> Quay lại
                            </button>
                        </div>

                        <div class="card-body">
                            <!-- SEARCH BAR -->
                            <form method="get" action="${pageContext.request.contextPath}/feedback/list"
                                class="row g-2 search-bar mb-4">
                                <c:if test="${role != 'doctor'}">
                                    <div class="col-md-5">
                                        <input type="text" name="doctorName" class="form-control"
                                            placeholder="Tìm theo tên bác sĩ..." value="${param.doctorName}">
                                    </div>
                                </c:if>
                                <div class="col-md-3">
                                    <select name="rating" class="form-select">
                                        <option value="">Tất cả đánh giá</option>
                                        <c:forEach begin="1" end="5" var="i">
                                            <option value="${i}" ${param.rating==i ? 'selected' : '' }>${i} ★</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-search me-1"></i> Tìm kiếm
                                    </button>
                                    <a href="${pageContext.request.contextPath}/feedback/list"
                                        class="btn btn-secondary ms-2">
                                        <i class="bi bi-x-circle"></i>
                                    </a>
                                </div>
                            </form>

                            <!-- TABLE -->
                            <c:if test="${not empty feedbacks}">
                                <div class="table-responsive">
                                    <table class="table table-bordered table-hover bg-white align-middle">
                                        <thead class="table-light">
                                            <tr>
                                                <th>#</th>
                                                <th>Khám</th>
                                                <th>Bệnh nhân</th>
                                                <c:if test="${role != 'doctor'}">
                                                    <th>Bác sĩ</th>
                                                </c:if>
                                                <th>Đánh giá</th>
                                                <th>Bình luận</th>
                                                <th>Phản hồi</th>
                                                <th>Trạng thái</th>
                                                <th>Hành động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${feedbacks}" var="feedback" varStatus="loop">
                                                <tr>
                                                    <td>${loop.index + 1}</td>
                                                    <td>#${feedback.examination.examinationID}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${feedback.anonymous}">
                                                                <i class="bi bi-person-fill-lock text-muted"></i> Ẩn
                                                                danh
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${feedback.patient.user.firstName}
                                                                ${feedback.patient.user.lastName}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <c:if test="${role != 'doctor'}">
                                                        <td>
                                                            ${feedback.doctor.user.firstName}
                                                            ${feedback.doctor.user.lastName}
                                                        </td>
                                                    </c:if>
                                                    <td><span class="badge bg-warning text-dark">${feedback.rating}
                                                            ★</span></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty feedback.comment}">
                                                                ${feedback.comment}</c:when>
                                                            <c:otherwise><em class="text-muted">Không có</em>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty feedback.response}">
                                                                ${feedback.response}</c:when>
                                                            <c:otherwise><em class="text-muted">Chưa phản hồi</em>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${feedback.isApproved}">
                                                                <span class="badge bg-success"><i
                                                                        class="bi bi-check-circle"></i> Đã duyệt</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary"><i
                                                                        class="bi bi-clock-history"></i> Chờ
                                                                    duyệt</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/feedback/${feedback.feedbackID}/reply"
                                                            class="btn btn-sm btn-outline-primary">
                                                            <i class="bi bi-reply-fill"></i> Phản hồi
                                                        </a>
                                                        <c:if test="${!feedback.isApproved}">
                                                            <form method="post"
                                                                action="${pageContext.request.contextPath}/feedback/${feedback.feedbackID}/approve"
                                                                style="display:inline;">
                                                                <button type="submit" class="btn btn-sm btn-success">
                                                                    <i class="bi bi-check-circle-fill"></i> Duyệt
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- PAGINATION -->
                                <nav>
                                    <ul class="pagination">
                                        <c:forEach begin="1" end="${totalPages}" var="page">
                                            <li class="page-item ${page == currentPage ? 'active' : ''}">
                                                <a class="page-link"
                                                    href="${pageContext.request.contextPath}/feedback/list?page=${page}&doctorName=${param.doctorName}&rating=${param.rating}">
                                                    ${page}
                                                </a>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </nav>
                            </c:if>

                            <c:if test="${empty feedbacks}">
                                <div class="alert alert-info text-center">
                                    <i class="bi bi-info-circle"></i> Không tìm thấy feedback nào khớp với tiêu chí.
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

            </body>

            </html>