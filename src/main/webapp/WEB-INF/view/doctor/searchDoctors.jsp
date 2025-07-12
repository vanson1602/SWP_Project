<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Tìm kiếm bác sĩ - HealthCare+</title>
            <link rel="stylesheet"
                href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="/css/homepage.css">
            <link rel="stylesheet" href="/resources/css/shared.css">
            <style>
                .search-section {
                    background: linear-gradient(135deg, #6f42c1, #8655e0);
                    padding: 3rem 0;
                    color: white;
                }

                .search-tabs {
                    background: white;
                    border-radius: 15px;
                    padding: 1.5rem;
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                }

                .search-tab {
                    color: #6c757d;
                    text-decoration: none;
                    padding: 0.5rem 1rem;
                    border-radius: 5px;
                    transition: all 0.3s ease;
                }

                .search-tab.active {
                    color: #6f42c1;
                    font-weight: 500;
                }

                .search-tab:hover {
                    color: #6f42c1;
                }

                .search-form {
                    margin-top: 1rem;
                }

                .search-button {
                    background-color: #6f42c1;
                    border: none;
                    padding: 0.5rem 2rem;
                    color: white;
                    border-radius: 5px;
                    transition: all 0.3s ease;
                }

                .search-button:hover {
                    background-color: #5a32a3;
                }

                .doctor-card {
                    transition: all 0.3s ease;
                    border: none;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
                }

                .doctor-card:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
                }

                .doctor-avatar {
                    width: 120px;
                    height: 120px;
                    object-fit: cover;
                    border-radius: 50%;
                    object-position: center;
                    image-rendering: -webkit-optimize-contrast;
                    image-rendering: crisp-edges;
                    border: 3px solid #fff;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                    transition: all 0.3s ease;
                }

                .doctor-card:hover .doctor-avatar {
                    transform: scale(1.05);
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
                }

                .doctor-info {
                    padding: 1rem;
                }

                .card-body {
                    padding: 1.5rem;
                }
            </style>
        </head>

        <body>

            <jsp:include page="../shared/header.jsp" />


            <section class="search-section">
                <div class="container">
                    <div class="search-tabs">
                        <div class="d-flex justify-content-start gap-4 mb-3">
                            <a href="#" class="search-tab active" data-tab="specialty">Tìm theo chuyên khoa</a>
                            <a href="#" class="search-tab" data-tab="doctor">Tìm theo tên bác sĩ</a>
                        </div>

                        <form action="/search/specialties" method="GET" class="search-form" id="specialtyForm">
                            <div class="row g-3">
                                <div class="col-md-9">
                                    <label class="form-label">Chuyên khoa</label>
                                    <input type="text" name="keyword" class="form-control"
                                        placeholder="Nhập tên chuyên khoa" required>
                                </div>
                                <div class="col-md-3 d-flex align-items-end">
                                    <button type="submit" class="search-button w-100">
                                        <i class="bi bi-search me-2"></i>Tìm kiếm
                                    </button>
                                </div>
                            </div>
                        </form>


                        <form action="/search/doctors" method="GET" class="search-form d-none" id="doctorForm">
                            <div class="row g-3">
                                <div class="col-md-9">
                                    <label class="form-label">Tên bác sĩ</label>
                                    <input type="text" name="keyword" class="form-control" placeholder="Nhập tên bác sĩ"
                                        required>
                                </div>
                                <div class="col-md-3 d-flex align-items-end">
                                    <button type="submit" class="search-button w-100">
                                        <i class="bi bi-search me-2"></i>Tìm kiếm
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </section>


            <section class="py-5">
                <div class="container-fluid px-4">
                    <div class="row">
                        <!-- Filter Sidebar -->
                        <div class="col-lg-2">
                            <div class="card border-0 shadow-sm mb-4 sticky-top" style="top: 20px;">
                                <div class="card-body p-3">
                                    <h5 class="card-title mb-3">Bộ lọc tìm kiếm</h5>

                                    <!-- Chuyên khoa -->
                                    <div class="mb-4">
                                        <h6 class="mb-3">Chuyên khoa</h6>
                                        <div class="d-flex flex-column gap-2">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" id="spec1">
                                                <label class="form-check-label" for="spec1">
                                                    Nội khoa
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" id="spec2">
                                                <label class="form-check-label" for="spec2">
                                                    Nhi khoa
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" id="spec3">
                                                <label class="form-check-label" for="spec3">
                                                    Tim mạch
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" id="spec4">
                                                <label class="form-check-label" for="spec4">
                                                    Da liễu
                                                </label>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Kinh nghiệm -->
                                    <div class="mb-4">
                                        <h6 class="mb-3">Kinh nghiệm</h6>
                                        <div class="d-flex flex-column gap-2">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="experience"
                                                    id="exp1">
                                                <label class="form-check-label" for="exp1">
                                                    Dưới 5 năm
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="experience"
                                                    id="exp2">
                                                <label class="form-check-label" for="exp2">
                                                    5 - 10 năm
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="experience"
                                                    id="exp3">
                                                <label class="form-check-label" for="exp3">
                                                    Trên 10 năm
                                                </label>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Phí khám -->
                                    <div class="mb-4">
                                        <h6 class="mb-3">Phí khám</h6>
                                        <div class="d-flex flex-column gap-2">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="fee" id="fee1">
                                                <label class="form-check-label" for="fee1">
                                                    Dưới 500.000đ
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="fee" id="fee2">
                                                <label class="form-check-label" for="fee2">
                                                    500.000đ - 1.000.000đ
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="fee" id="fee3">
                                                <label class="form-check-label" for="fee3">
                                                    Trên 1.000.000đ
                                                </label>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Đánh giá -->
                                    <div class="mb-4">
                                        <h6 class="mb-3">Đánh giá</h6>
                                        <div class="d-flex flex-column gap-2">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="rating" id="rate5">
                                                <label class="form-check-label" for="rate5">
                                                    <i class="bi bi-star-fill text-warning"></i>
                                                    <i class="bi bi-star-fill text-warning"></i>
                                                    <i class="bi bi-star-fill text-warning"></i>
                                                    <i class="bi bi-star-fill text-warning"></i>
                                                    <i class="bi bi-star-fill text-warning"></i>
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="rating" id="rate4">
                                                <label class="form-check-label" for="rate4">
                                                    <i class="bi bi-star-fill text-warning"></i>
                                                    <i class="bi bi-star-fill text-warning"></i>
                                                    <i class="bi bi-star-fill text-warning"></i>
                                                    <i class="bi bi-star-fill text-warning"></i>
                                                    <i class="bi bi-star text-warning"></i>
                                                    trở lên
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="rating" id="rate3">
                                                <label class="form-check-label" for="rate3">
                                                    <i class="bi bi-star-fill text-warning"></i>
                                                    <i class="bi bi-star-fill text-warning"></i>
                                                    <i class="bi bi-star-fill text-warning"></i>
                                                    <i class="bi bi-star text-warning"></i>
                                                    <i class="bi bi-star text-warning"></i>
                                                    trở lên
                                                </label>
                                            </div>
                                        </div>
                                    </div>

                                    <button class="btn btn-primary w-100">
                                        <i class="bi bi-funnel me-2"></i>Lọc kết quả
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Doctor List -->
                        <div class="col-lg-10">
                            <div class="row">
                                <c:choose>
                                    <c:when test="${empty doctors}">
                                        <div class="col-12 text-center">
                                            <p class="text-muted">Không tìm thấy kết quả nào cho "${searchKeyword}"</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="col-12 mb-4">
                                            <p class="text-muted">Tìm thấy ${doctors.size()} kết quả cho
                                                "${searchKeyword}"</p>
                                        </div>
                                        <c:forEach items="${doctors}" var="doctor">
                                            <div class="col-md-6 col-lg-4 mb-4">
                                                <div class="card doctor-card h-100" style="cursor: pointer;">
                                                    <div class="card-body"
                                                        onclick="window.location.href='/search/doctors/details/${doctor.doctorID}'">
                                                        <div class="d-flex align-items-center mb-3">
                                                            <img src="${empty doctor.user.avatarUrl ? '/images/default-avatar.png' : doctor.user.avatarUrl}"
                                                                alt="BS. ${doctor.user.firstName} ${doctor.user.lastName}"
                                                                class="rounded-circle doctor-avatar me-3">
                                                            <div>
                                                                <h5 class="card-title mb-1">BS. ${doctor.user.firstName}
                                                                    ${doctor.user.lastName}</h5>
                                                                <p class="text-muted small mb-0">
                                                                    <c:forEach items="${doctor.specializations}"
                                                                        var="spec" varStatus="status">
                                                                        ${spec.specializationName}${!status.last ? ', '
                                                                        : ''}
                                                                    </c:forEach>
                                                                </p>
                                                            </div>
                                                        </div>
                                                        <p class="card-text">
                                                            <i class="bi bi-briefcase-fill text-primary me-2"></i>
                                                            ${doctor.experienceYears} năm kinh nghiệm<br>
                                                            <i class="bi bi-award-fill text-primary me-2"></i>
                                                            ${doctor.qualification}
                                                        </p>
                                                        <div class="mt-3">
                                                            <p class="text-primary mb-2">
                                                                <i class="bi bi-cash me-2"></i>
                                                                Phí khám: ${doctor.consultationFee} VNĐ
                                                            </p>
                                                            <div class="d-flex gap-2" onclick="event.stopPropagation()">
                                                                <a href="/search/doctors/details/${doctor.doctorID}"
                                                                    class="btn btn-outline-secondary flex-grow-1">
                                                                    <i class="bi bi-info-circle me-2"></i>Xem chi tiết
                                                                </a>
                                                                <a href="/search/doctors/${doctor.doctorID}"
                                                                    class="btn btn-outline-primary flex-grow-1">
                                                                    <i class="bi bi-calendar-check me-2"></i>Đặt lịch
                                                                    khám
                                                                </a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Include Footer -->
            <jsp:include page="../shared/footer.jsp" />

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    const searchTabs = document.querySelectorAll('.search-tab');
                    const searchForms = {
                        specialty: document.getElementById('specialtyForm'),
                        doctor: document.getElementById('doctorForm')
                    };

                    searchTabs.forEach(tab => {
                        tab.addEventListener('click', (e) => {
                            e.preventDefault();
                            // Remove active class from all tabs
                            searchTabs.forEach(t => t.classList.remove('active'));
                            // Add active class to clicked tab
                            tab.classList.add('active');

                            // Hide all forms
                            Object.values(searchForms).forEach(form => {
                                form.classList.add('d-none');
                            });
                            // Show selected form
                            const formId = tab.dataset.tab;
                            searchForms[formId].classList.remove('d-none');
                        });
                    });
                });
            </script>
        </body>

        </html>