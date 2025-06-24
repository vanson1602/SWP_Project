<%@page contentType="text/html" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

    <!DOCTYPE html>
    <html lang="vi">

    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>HealthCare+ - Đặt lịch khám chữa bệnh</title>
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
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

        /* Modern Card Design */
        .card {
          transition: all 0.4s ease;
          border: none !important;
          overflow: hidden;
          background: white;
          max-width: 260px;
          margin: 0 auto;
          border-radius: 8px;
          box-shadow: rgba(17, 17, 26, 0.1) 0px 4px 16px, rgba(17, 17, 26, 0.05) 0px 8px 32px;
          cursor: pointer;
          text-decoration: none;
          display: block;
          color: inherit;
        }

        .card:hover {
          transform: translateY(-5px);
          box-shadow: rgba(17, 17, 26, 0.1) 0px 4px 16px, rgba(17, 17, 26, 0.1) 0px 8px 32px;
        }

        .doctor-image-wrapper {
          width: 100%;
          height: 160px;
          position: relative;
          overflow: hidden;
          background: #f8f9fa;
          margin: 12px 12px 0;
          width: calc(100% - 24px);
          border-radius: 6px;
        }

        .card-img-top {
          width: 100%;
          height: 100%;
          object-fit: cover;
          transition: transform 0.5s ease;
          image-rendering: -webkit-optimize-contrast;
          backface-visibility: hidden;
          transform: translateZ(0);
          -webkit-font-smoothing: subpixel-antialiased;
        }

        .card:hover .card-img-top {
          transform: scale(1.1);
        }

        .card-body {
          padding: 1rem;
          background: white;
          position: relative;
        }

        .card-title {
          color: #1a1a1a;
          font-weight: 600;
          margin-bottom: 0.5rem;
          font-size: 1rem;
          letter-spacing: -0.02em;
          line-height: 1.4;
        }

        .specialty-text {
          color: #6f42c1;
          font-size: 0.85rem;
          margin-bottom: 1rem;
          font-weight: 500;
          line-height: 1.5;
        }

        .info-group {
          display: flex;
          align-items: center;
          margin-bottom: 0.5rem;
          padding: 0.5rem;
          background: #f8f9fa;
          border-radius: 6px;
          transition: all 0.3s ease;
        }

        .info-group:last-child {
          margin-bottom: 0;
        }

        .info-group i {
          color: #6f42c1;
          font-size: 1rem;
          margin-right: 0.75rem;
          flex-shrink: 0;
        }

        .info-text {
          color: #4a4a4a;
          font-size: 0.85rem;
          margin: 0;
          line-height: 1.4;
        }

        .btn-outline-primary {
          margin-top: 0.5rem;
          border: 1.5px solid #6f42c1;
          color: #6f42c1;
          padding: 0.75rem 1.25rem;
          font-weight: 500;
          transition: all 0.3s ease;
          border-radius: 6px;
          font-size: 0.95rem;
          background: transparent;
          display: flex;
          align-items: center;
          justify-content: center;
          gap: 0.75rem;
          height: 45px;

        }

        .btn-outline-primary:hover {
          background-color: #6f42c1;
          border-color: #6f42c1;
          color: white;
          transform: translateY(-2px);
          box-shadow: 0 5px 15px rgba(111, 66, 193, 0.2);


        }

        .btn-outline-primary i {
          font-size: 1rem;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
          .card {
            max-width: 100%;
          }

          .doctor-image-wrapper {
            height: 180px;
            margin: 8px 8px 0;
            width: calc(100% - 16px);
          }
        }

        /* Add animation delay for each card */
        .col-lg-3:nth-child(1) .card {
          animation-delay: 0.1s;
        }

        .col-lg-3:nth-child(2) .card {
          animation-delay: 0.2s;
        }

        .col-lg-3:nth-child(3) .card {
          animation-delay: 0.3s;
        }

        .col-lg-3:nth-child(4) .card {
          animation-delay: 0.4s;
        }

        /* Background decoration */
        .hexagon-bg {
          position: absolute;
          width: 30px;
          height: 30px;
          background: rgba(111, 66, 193, 0.1);
          clip-path: polygon(50% 0%, 100% 25%, 100% 75%, 50% 100%, 0% 75%, 0% 25%);
          z-index: -1;
        }

        .hexagon-1 {
          top: -15px;
          left: 10%;
        }

        .hexagon-2 {
          bottom: 15px;
          right: 10%;
        }

        /* Icon styles */
        .card-text i {
          color: #6f42c1;
        }

        /* Pagination styles */
        .pagination .page-link {
          color: #6f42c1;
          border: none;
          padding: 0.5rem 1rem;
          margin: 0 0.2rem;
          border-radius: 5px;
        }

        .pagination .page-item.active .page-link {
          background-color: #6f42c1;
          color: white;
        }

        .pagination .page-link:hover {
          background-color: #f8f9fa;
          color: #5a32a3;
        }

        /* Filter styles */
        .form-check-input:checked {
          background-color: #6f42c1;
          border-color: #6f42c1;
        }

        .form-check-label {
          color: #4a4a4a;
          font-size: 0.9rem;
        }

        .card-title {
          color: #1a1a1a;
          font-size: 1.1rem;
          font-weight: 600;
        }

        .btn-primary {
          background-color: #6f42c1;
          border-color: #6f42c1;
        }

        .btn-primary:hover {
          background-color: #5a32a3;
          border-color: #5a32a3;
        }

        /* Responsive adjustments */
        @media (max-width: 992px) {
          .col-lg-3 {
            margin-bottom: 2rem;
          }
        }

        /* Additional styles for new layout */
        .container-fluid {
          max-width: 1800px;
        }

        .sticky-top {
          z-index: 100;
        }

        @media (max-width: 992px) {
          .sticky-top {
            position: static !important;
          }
        }
      </style>
    </head>


    <jsp:include page="../shared/header.jsp" />


    <!-- Dịch vụ nổi bật -->
    <section class="py-4">
      <div class="container">
        <h2 class="fw-bold mb-4 text-center">Dịch vụ nổi bật</h2>
        <div class="row g-3">
          <div class="col-md-3 col-sm-6">
            <div class="card h-100 shadow-sm border-0 p-3">
              <div
                class="bg-primary text-white rounded-circle d-flex justify-content-center align-items-center mx-auto mb-2"
                style="width: 50px; height: 50px;">
                <i class="bi bi-calendar-check fs-5"></i>
              </div>
              <h5 class="fw-semibold mb-2 text-center">Đặt lịch khám</h5>
              <p class="text-muted small mb-0 text-center">Đặt lịch hẹn với bác sĩ chuyên khoa phù hợp</p>
            </div>
          </div>

          <div class="col-md-3 col-sm-6">
            <div class="card h-100 shadow-sm border-0 p-3">
              <div
                class="bg-danger text-white rounded-circle d-flex justify-content-center align-items-center mx-auto mb-2"
                style="width: 50px; height: 50px;">
                <i class="bi bi-person-badge fs-5"></i>
              </div>
              <h5 class="fw-semibold mb-2 text-center">Tìm bác sĩ</h5>
              <p class="text-muted small mb-0 text-center">Tìm kiếm bác sĩ theo chuyên khoa và địa điểm</p>
            </div>
          </div>

          <div class="col-md-3 col-sm-6">
            <div class="card h-100 shadow-sm border-0 p-3">
              <div
                class="bg-info text-white rounded-circle d-flex justify-content-center align-items-center mx-auto mb-2"
                style="width: 50px; height: 50px;">
                <i class="bi bi-chat-dots fs-5"></i>
              </div>
              <h5 class="fw-semibold mb-2 text-center">Tư vấn online</h5>
              <p class="text-muted small mb-0 text-center">Tư vấn sức khỏe trực tuyến 24/7</p>
            </div>
          </div>

          <div class="col-md-3 col-sm-6">
            <div class="card h-100 shadow-sm border-0 p-3">
              <div
                class="bg-success text-white rounded-circle d-flex justify-content-center align-items-center mx-auto mb-2"
                style="width: 50px; height: 50px;">
                <i class="bi bi-file-earmark-medical fs-5"></i>
              </div>
              <h5 class="fw-semibold mb-2 text-center">Hồ sơ sức khỏe</h5>
              <p class="text-muted small mb-0 text-center">Quản lý hồ sơ bệnh án điện tử</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section class="search-section py-4">
      <div class="container">
        <div class="search-tabs">
          <div class="d-flex justify-content-start gap-3 mb-3">
            <a href="#" class="search-tab active" data-tab="specialty">Tìm theo chuyên khoa</a>
            <a href="#" class="search-tab" data-tab="doctor">Tìm theo tên bác sĩ</a>
          </div>

          <form action="/search/specialties" method="GET" class="search-form" id="specialtyForm">
            <div class="row g-2">
              <div class="col-md-9">
                <label class="form-label small mb-1">Chuyên khoa</label>
                <input type="text" name="keyword" class="form-control" placeholder="Nhập tên chuyên khoa" required>
              </div>
              <div class="col-md-3 d-flex align-items-end">
                <button type="submit" class="search-button w-100">
                  <i class="bi bi-search me-2"></i>Tìm kiếm
                </button>
              </div>
            </div>
          </form>

          <form action="/search/doctors" method="GET" class="search-form d-none" id="doctorForm">
            <div class="row g-2">
              <div class="col-md-9">
                <label class="form-label small mb-1">Tên bác sĩ</label>
                <input type="text" name="keyword" class="form-control" placeholder="Nhập tên bác sĩ" required>
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

    <!-- Hero Section -->



    <!-- Danh sách bác sĩ -->
    <section class="py-4">
      <div class="container">
        <h2 class="fw-bold text-center mb-4">Đội ngũ bác sĩ</h2>
        <div class="row g-3">
          <c:forEach items="${doctors}" var="doctor">
            <div class="col-lg-4 col-md-6">
              <a href="/search/doctors/details/${doctor.doctorID}" class="card h-100">
                <div class="doctor-image-wrapper">
                  <c:choose>
                    <c:when test="${not empty doctor.user.avatarUrl}">
                      <img src="${doctor.user.avatarUrl}" class="card-img-top"
                        alt="BS. ${doctor.user.firstName} ${doctor.user.lastName}">
                    </c:when>
                    <c:otherwise>
                      <img src="/resources/images/defaultImg.jpg" class="card-img-top" alt="Default doctor photo">
                    </c:otherwise>
                  </c:choose>
                </div>
                <div class="card-body">
                  <h5 class="card-title mb-2">BS. ${doctor.user.firstName} ${doctor.user.lastName}</h5>
                  <div class="specialty-text mb-3">
                    <c:forEach items="${doctor.specializations}" var="spec" varStatus="status">
                      ${spec.specializationName}${!status.last ? ', ' : ''}
                    </c:forEach>
                  </div>
                  <div class="info-group mb-2">
                    <i class="bi bi-briefcase-fill"></i>
                    <p class="info-text">${doctor.experienceYears} năm kinh nghiệm</p>
                  </div>
                  <div class="info-group">
                    <i class="bi bi-cash"></i>
                    <p class="info-text">Phí tư vấn: ${doctor.consultationFee} VNĐ</p>
                  </div>
                </div>
              </a>
            </div>
          </c:forEach>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
          <nav class="mt-4">
            <ul class="pagination justify-content-center">
              <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                <a class="page-link" href="/?page=${currentPage - 1}">Trước</a>
              </li>
              <c:forEach begin="0" end="${totalPages - 1}" var="i">
                <li class="page-item ${currentPage == i ? 'active' : ''}">
                  <a class="page-link" href="/?page=${i}">${i + 1}</a>
                </li>
              </c:forEach>
              <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                <a class="page-link" href="/?page=${currentPage + 1}">Sau</a>
              </li>
            </ul>
          </nav>
        </c:if>
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