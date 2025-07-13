<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
        <%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

            <!DOCTYPE html>
            <html>

            <head>
                <title>Gửi Feedback</title>
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/base.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/homepage.css">
                <style>
                    body {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    }

                    .feedback-form-wrapper {
                        max-width: 800px;
                        margin: 2rem auto;
                        background: white;
                        border-radius: 15px;
                        padding: 2rem 3rem;
                        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
                    }

                    .feedback-form-wrapper h2 {
                        text-align: center;
                        margin-bottom: 1.5rem;
                        color: #5a3ec8;
                    }

                    .form-label {
                        font-weight: bold;
                        margin-bottom: 0.5rem;
                    }

                    .star-rating {
                        display: flex;
                        gap: 0.3rem;
                        font-size: 1.8rem;
                        color: #ccc;
                        cursor: pointer;
                        transition: 0.3s;
                    }

                    .star-rating .star.active,
                    .star-rating .star:hover {
                        color: #ffc107;
                        transform: scale(1.1);
                    }

                    .rating-section {
                        margin-bottom: 1.5rem;
                    }

                    .form-control,
                    .form-check-input {
                        border-radius: 10px;
                    }

                    .form-check-label {
                        margin-left: 0.5rem;
                        font-weight: 500;
                    }

                    .btn-submit {
                        background: linear-gradient(135deg, #00f2fe, #4facfe);
                        border: none;
                        color: white;
                        padding: 0.75rem 2rem;
                        font-weight: bold;
                        font-size: 1.1rem;
                        border-radius: 30px;
                        width: 100%;
                        transition: 0.3s;
                    }

                    .btn-submit:hover {
                        background: linear-gradient(135deg, #4facfe, #00f2fe);
                        transform: translateY(-2px);
                    }
                </style>
            </head>

            <body>

                <jsp:include page="/WEB-INF/view/shared/header.jsp" />

                <div class="feedback-form-wrapper">
                    <h2><i class="bi bi-chat-left-dots-fill me-2"></i> Gửi Feedback</h2>

                    <form:form method="post" modelAttribute="feedback"
                        action="${pageContext.request.contextPath}/feedback/submit">
                        <form:hidden path="examination.examinationID" />
                        <form:hidden path="patient.patientID" />
                        <form:hidden path="doctor.doctorID" />

                        <!-- Đánh giá chung -->
                        <div class="rating-section">
                            <label class="form-label">Đánh giá chung</label>
                            <form:input path="rating" type="number" id="ratingInput" cssClass="d-none"
                                required="required" />
                            <div class="star-rating" data-target="ratingInput">
                                <span class="star" data-value="1">★</span>
                                <span class="star" data-value="2">★</span>
                                <span class="star" data-value="3">★</span>
                                <span class="star" data-value="4">★</span>
                                <span class="star" data-value="5">★</span>
                            </div>
                        </div>

                        <!-- Đánh giá dịch vụ -->
                        <div class="rating-section">
                            <label class="form-label">Đánh giá dịch vụ</label>
                            <form:input path="serviceRating" type="hidden" id="serviceRatingInput" />
                            <div class="star-rating" data-target="serviceRatingInput">
                                <span class="star" data-value="1">★</span>
                                <span class="star" data-value="2">★</span>
                                <span class="star" data-value="3">★</span>
                                <span class="star" data-value="4">★</span>
                                <span class="star" data-value="5">★</span>
                            </div>
                        </div>

                        <!-- Đánh giá vệ sinh -->
                        <div class="rating-section">
                            <label class="form-label">Đánh giá vệ sinh</label>
                            <form:input path="cleanlinessRating" type="hidden" id="cleanlinessRatingInput" />
                            <div class="star-rating" data-target="cleanlinessRatingInput">
                                <span class="star" data-value="1">★</span>
                                <span class="star" data-value="2">★</span>
                                <span class="star" data-value="3">★</span>
                                <span class="star" data-value="4">★</span>
                                <span class="star" data-value="5">★</span>
                            </div>
                        </div>

                        <!-- Bình luận -->
                        <div class="mb-3">
                            <label class="form-label">Bình luận</label>
                            <form:textarea path="comment" cssClass="form-control" rows="4"
                                placeholder="Chia sẻ trải nghiệm của bạn..." />
                        </div>

                        <!-- Ẩn danh -->
                        <div class="form-check mb-4">
                            <form:checkbox path="anonymous" cssClass="form-check-input" id="anonymousCheckbox" />
                            <label class="form-check-label" for="anonymousCheckbox">
                                <i class="bi bi-eye-slash-fill"></i> Gửi feedback ẩn danh
                            </label>
                        </div>

                        <!-- Gửi -->
                        <button type="submit" class="btn btn-submit">
                            <i class="bi bi-send-fill me-2"></i> Gửi Feedback
                        </button>
                    </form:form>
                </div>

                <script>
                    // Xử lý chấm sao
                    document.querySelectorAll(".star-rating").forEach(starGroup => {
                        const inputId = starGroup.dataset.target;
                        const input = document.getElementById(inputId);
                        let stars = starGroup.querySelectorAll(".star");

                        stars.forEach(star => {
                            star.addEventListener("click", () => {
                                const rating = parseInt(star.dataset.value);
                                input.value = rating;
                                stars.forEach(s => s.classList.remove("active"));
                                for (let i = 0; i < rating; i++) {
                                    stars[i].classList.add("active");
                                }
                            });
                        });
                    });
                </script>

            </body>

            </html>