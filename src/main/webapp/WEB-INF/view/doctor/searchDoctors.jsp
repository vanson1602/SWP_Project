<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
                        padding: 2rem 0;
                        color: white;
                    }

                    .search-container {
                        background: white;
                        border-radius: 10px;
                        padding: 2rem;
                        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                    }

                    .search-input {
                        border: 1px solid #ced4da;
                        border-radius: 5px;
                        padding: 0.5rem 1rem;
                    }

                    .search-button {
                        background-color: #6f42c1;
                        border: none;
                        color: white;
                        padding: 0.5rem 2rem;
                        border-radius: 5px;
                        transition: all 0.3s ease;
                    }

                    .search-button:hover {
                        background-color: #5a32a3;
                    }

                    .filter-section {
                        background: #f8f9fa;
                        border-radius: 10px;
                        padding: 1.5rem;
                        margin-bottom: 1rem;
                        position: sticky;
                        top: 20px;
                    }

                    .filter-section h5 {
                        color: #333;
                        margin-bottom: 1.5rem;
                    }

                    .filter-group {
                        margin-bottom: 1.5rem;
                    }

                    .filter-group h6 {
                        color: #495057;
                        margin-bottom: 1rem;
                        font-weight: 600;
                    }

                    .form-check {
                        margin-bottom: 0.5rem;
                        padding-left: 2rem;
                    }

                    .form-check-input {
                        margin-top: 0.3rem;
                    }

                    .form-check-label {
                        color: #495057;
                        cursor: pointer;
                    }

                    .form-check-input:checked {
                        background-color: #6f42c1;
                        border-color: #6f42c1;
                    }

                    .doctor-card {
                        border: none;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                        transition: transform 0.2s;
                    }

                    .doctor-card:hover {
                        transform: translateY(-5px);
                    }

                    .doctor-card .card-body {
                        padding: 1.5rem;
                    }

                    .doctor-card .card-title {
                        color: #333;
                        margin-bottom: 1rem;
                    }

                    .doctor-card .btn-outline-primary {
                        color: #6f42c1;
                        border-color: #6f42c1;
                    }

                    .doctor-card .btn-outline-primary:hover {
                        background-color: #6f42c1;
                        color: white;
                    }

                    .doctor-image {
                        width: 120px;
                        height: 120px;
                        border-radius: 50%;
                        object-fit: cover;
                        margin-bottom: 1rem;
                        border: 3px solid #6f42c1;
                    }

                    .doctor-info {
                        display: flex;
                        align-items: start;
                        gap: 1rem;
                    }

                    .doctor-details {
                        flex: 1;
                    }

                    .results-section {
                        padding: 2rem 0;
                    }

                    .no-results {
                        text-align: center;
                        padding: 3rem 0;
                        color: #6c757d;
                    }

                    @media (max-width: 991.98px) {
                        .filter-section {
                            position: static;
                            margin-bottom: 2rem;
                        }
                    }
                </style>
            </head>

            <body>
                <jsp:include page="../shared/header.jsp" />

                <section class="search-section">
                    <div class="container">
                        <div class="search-container">
                            <div class="row">
                                <div class="col-12">
                                    <form action="${currentPath}" method="GET" class="mb-0">
                                        <input type="hidden" name="searchType" value="${searchType}">
                                        <div class="row align-items-end">
                                            <div class="col-md-9">
                                                <label class="form-label text-dark mb-2">
                                                    ${searchType == 'doctor' ? 'Tìm kiếm theo tên bác sĩ' : 'Tìm kiếm
                                                    theo
                                                    chuyên khoa'}
                                                </label>
                                                <input type="text" name="keyword" class="form-control search-input"
                                                    placeholder="${searchType == 'doctor' ? 'Nhập tên bác sĩ cần tìm...' : 'Nhập tên chuyên khoa cần tìm...'}"
                                                    value="${searchKeyword}" required>
                                            </div>
                                            <div class="col-md-3">
                                                <button type="submit" class="btn search-button w-100">
                                                    <i class="bi bi-search me-2"></i>Tìm kiếm
                                                </button>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <section class="results-section">
                    <div class="container">
                        <div class="row">
                            <!-- Filters - Left Column -->
                            <div class="col-lg-3">
                                <form action="${currentPath}" method="GET" class="mb-4">
                                    <input type="hidden" name="searchType" value="${searchType}">
                                    <input type="hidden" name="keyword" value="${searchKeyword}">

                                    <div class="filter-section">
                                        <h5 class="mb-4">Bộ lọc tìm kiếm</h5>

                                        <!-- Specialization Filter -->
                                        <div class="filter-group">
                                            <h6>Chuyên khoa</h6>
                                            <c:forEach var="specialization" items="${specializations}">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox"
                                                        name="specializationName"
                                                        value="${specialization.specializationName}"
                                                        id="spec_${specialization.specializationID}"
                                                        ${selectedSpecializations.contains(specialization.specializationName)
                                                        ? 'checked' : '' }>
                                                    <label class="form-check-label"
                                                        for="spec_${specialization.specializationID}">${specialization.specializationName}</label>
                                                </div>
                                            </c:forEach>
                                        </div>

                                        <!-- Experience Filter -->
                                        <div class="filter-group">
                                            <h6>Kinh nghiệm</h6>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="experienceYears"
                                                    value="5" id="exp1" ${param.experienceYears=='5' ? 'checked' : '' }>
                                                <label class="form-check-label" for="exp1">Từ 5 năm</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="experienceYears"
                                                    value="10" id="exp2" ${param.experienceYears=='10' ? 'checked' : ''
                                                    }>
                                                <label class="form-check-label" for="exp2">Từ 10 năm</label>
                                            </div>
                                        </div>

                                        <!-- Fee Filter -->
                                        <div class="filter-group">
                                            <h6>Phí khám</h6>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="consultationFee"
                                                    value="500000" id="fee1" ${param.consultationFee=='500000'
                                                    ? 'checked' : '' }>
                                                <label class="form-check-label" for="fee1">Dưới 500.000đ</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="consultationFee"
                                                    value="1000000" id="fee2" ${param.consultationFee=='1000000'
                                                    ? 'checked' : '' }>
                                                <label class="form-check-label" for="fee2">Dưới 1.000.000đ</label>
                                            </div>
                                        </div>

                                        <button type="submit" class="btn search-button w-100">
                                            <i class="bi bi-funnel me-2"></i>Áp dụng bộ lọc
                                        </button>
                                    </div>
                                </form>
                            </div>

                            <!-- Results - Right Column -->
                            <div class="col-lg-9">
                                <c:choose>
                                    <c:when test="${empty doctors}">
                                        <div class="no-results">
                                            <i class="bi bi-search mb-3" style="font-size: 2rem;"></i>
                                            <p class="mb-0">Không tìm thấy kết quả nào cho "${searchKeyword}"</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="row">
                                            <c:forEach items="${doctors}" var="doctor">
                                                <div class="col-md-6 mb-4">
                                                    <div class="card doctor-card h-100">
                                                        <div class="card-body">
                                                            <div class="doctor-info">
                                                                <img src="${doctor.user.avatarUrl}"
                                                                    alt="BS. ${doctor.user.firstName} ${doctor.user.lastName}"
                                                                    class="doctor-image"
                                                                    onerror="this.src='/resources/images/defaultImg.jpg'">
                                                                <div class="doctor-details">
                                                                    <h5 class="card-title">BS. ${doctor.user.firstName}
                                                                        ${doctor.user.lastName}</h5>
                                                                    <p class="card-text mb-3">
                                                                        <i
                                                                            class="bi bi-briefcase-fill me-2 text-primary"></i>
                                                                        <c:forEach items="${doctor.specializations}"
                                                                            var="spec" varStatus="loop">
                                                                            ${spec.specializationName}${!loop.last ? ',
                                                                            ' :
                                                                            ''}
                                                                        </c:forEach>
                                                                    </p>
                                                                    <p class="mb-2">
                                                                        <i
                                                                            class="bi bi-clock-history me-2 text-primary"></i>
                                                                        Kinh nghiệm: ${doctor.experienceYears} năm
                                                                    </p>
                                                                    <p class="mb-3">
                                                                        <i class="bi bi-cash me-2 text-primary"></i>
                                                                        Phí khám: ${doctor.consultationFee} VNĐ
                                                                    </p>
                                                                    <a href="/search/doctors/details/${doctor.doctorID}"
                                                                        class="btn btn-outline-primary w-100">
                                                                        <i class="bi bi-info-circle me-2"></i>Xem chi
                                                                        tiết
                                                                    </a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </section>

                <jsp:include page="../shared/footer.jsp" />
            </body>

            </html>

            <script>