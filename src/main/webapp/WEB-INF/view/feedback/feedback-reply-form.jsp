<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Phản hồi Feedback</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
            <style>
                body {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    min-height: 100vh;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-family: 'Segoe UI', sans-serif;
                }

                .reply-container {
                    background: white;
                    padding: 2rem;
                    border-radius: 20px;
                    box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
                    max-width: 700px;
                    width: 100%;
                }

                .reply-header {
                    text-align: center;
                    margin-bottom: 1.5rem;
                }

                .reply-header h2 {
                    font-weight: 600;
                    color: #4a00e0;
                }

                .info-block {
                    margin-bottom: 1rem;
                }

                .info-label {
                    font-weight: 600;
                    color: #555;
                }

                textarea.form-control {
                    resize: vertical;
                    min-height: 120px;
                    border-radius: 12px;
                }

                .btn-submit {
                    background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
                    border: none;
                    border-radius: 50px;
                    padding: 0.75rem 2rem;
                    font-weight: 600;
                    color: white;
                    box-shadow: 0 10px 25px rgba(0, 242, 254, 0.3);
                    transition: all 0.3s ease;
                }

                .btn-submit:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 15px 35px rgba(0, 242, 254, 0.4);
                }

                .btn-back {
                    background: transparent;
                    border: 1px solid #aaa;
                    border-radius: 50px;
                    padding: 0.5rem 1.5rem;
                    color: #333;
                    margin-right: 1rem;
                }

                .btn-back:hover {
                    background: #f8f9fa;
                }
            </style>
        </head>

        <body>
            <div class="reply-container">
                <div class="reply-header">
                    <h2><i class="bi bi-reply-fill me-2"></i>Phản hồi Feedback</h2>
                </div>

                <form action="${pageContext.request.contextPath}/feedback/${feedback.feedbackID}/reply" method="post">
                    <div class="info-block">
                        <span class="info-label"><i class="bi bi-person-circle me-1"></i>Bệnh nhân:</span>
                        <span>
                            <c:choose>
                                <c:when test="${feedback.anonymous}">
                                    Ẩn danh <i class="bi bi-eye-slash-fill text-muted"></i>
                                </c:when>
                                <c:otherwise>
                                    ${feedback.patient.user.firstName} ${feedback.patient.user.lastName}
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <div class="info-block">
                        <span class="info-label"><i class="bi bi-person-badge-fill me-1"></i>Bác sĩ:</span>
                        <span>${feedback.doctor.user.firstName} ${feedback.doctor.user.lastName}</span>
                    </div>

                    <div class="info-block">
                        <span class="info-label"><i class="bi bi-chat-dots me-1"></i>Bình luận:</span>
                        <span>
                            <c:choose>
                                <c:when test="${not empty feedback.comment}">
                                    ${feedback.comment}
                                </c:when>
                                <c:otherwise><em class="text-muted">Không có bình luận</em></c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <div class="mb-4">
                        <label for="response" class="form-label"><i class="bi bi-pencil-square me-1"></i>Phản hồi của
                            bạn:</label>
                        <textarea name="response" id="response" class="form-control"
                            placeholder="Nhập phản hồi tại đây...">${feedback.response}</textarea>
                    </div>

                    <div class="d-flex justify-content-end">
                        <a href="${pageContext.request.contextPath}/feedback/list" class="btn btn-back">
                            <i class="bi bi-arrow-left-circle"></i> Trở về
                        </a>
                        <button type="submit" class="btn btn-submit">
                            <i class="bi bi-send-fill me-1"></i> Gửi phản hồi
                        </button>
                    </div>
                </form>
            </div>
        </body>

        </html>