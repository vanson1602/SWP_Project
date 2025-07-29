<%@page contentType="text/html" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

    <!DOCTYPE html>
    <html lang="vi">

    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>HealthCare+ - Đặt lịch khám chữa bệnh</title>
      <jsp:include page="../shared/head.jsp" />
      <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/base.css">
      <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/homepage.css">

      <!-- Required scripts -->
      <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/locale/vi.js"></script>
      <script defer src="/resources/js/notifications.js"></script>
      <style>
        /* Main Container Styles */
        .container {
          max-width: 1400px;
          margin: 0 auto;
          padding: 0 20px;
        }

        /* Featured Services Section */
        .services-section {
          background: linear-gradient(135deg, #6f42c1, #8655e0);
          padding: 3rem 0;
          margin-bottom: 2rem;
          border-radius: 0 0 30px 30px;
          box-shadow: 0 4px 20px rgba(111, 66, 193, 0.2);
        }

        .service-card {
          background: rgba(255, 255, 255, 0.95);
          border-radius: 15px;
          padding: 1.5rem;
          text-align: center;
          transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
          height: 100%;
          box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
          backdrop-filter: blur(10px);
          border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .service-card:hover {
          transform: translateY(-10px);
          box-shadow: 0 12px 40px rgba(111, 66, 193, 0.3);
        }

        .service-icon {
          width: 60px;
          height: 60px;
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          margin: 0 auto 1rem;
          font-size: 1.5rem;
          background: linear-gradient(45deg, #6f42c1, #8655e0);
          color: white;
          box-shadow: 0 4px 15px rgba(111, 66, 193, 0.3);
        }

        .service-card h5 {
          color: #2d3436;
          font-size: 1.1rem;
          margin-bottom: 0.75rem;
          font-weight: 600;
        }

        .service-card p {
          color: #636e72;
          font-size: 0.9rem;
          line-height: 1.5;
          margin-bottom: 0;
        }

        /* Search Section */
        .search-section {
          background: white;
          padding: 2rem 0;
          margin-bottom: 2rem;
        }

        .search-container {
          background: white;
          border-radius: 15px;
          padding: 1.5rem;
          box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
          max-width: 800px;
          margin: 0 auto;
        }

        .search-tabs {
          display: flex;
          gap: 0.75rem;
          margin-bottom: 1.5rem;
          border-bottom: 2px solid #f0f0f0;
          padding-bottom: 0.75rem;
        }

        .search-tab {
          padding: 0.5rem 1rem;
          border-radius: 8px;
          color: #636e72;
          font-weight: 500;
          transition: all 0.3s ease;
          text-decoration: none;
          font-size: 0.95rem;
        }

        .search-tab.active {
          background: linear-gradient(45deg, #6f42c1, #8655e0);
          color: white;
          box-shadow: 0 4px 15px rgba(111, 66, 193, 0.3);
        }

        .search-form input {
          border: 2px solid #f0f0f0;
          border-radius: 10px;
          padding: 0.75rem;
          font-size: 0.95rem;
          transition: all 0.3s ease;
        }

        .search-form input:focus {
          border-color: #6f42c1;
          box-shadow: 0 0 0 3px rgba(111, 66, 193, 0.1);
        }

        .search-button {
          background: linear-gradient(45deg, #6f42c1, #8655e0);
          color: white;
          border: none;
          border-radius: 10px;
          padding: 0.75rem 1.5rem;
          font-weight: 500;
          transition: all 0.3s ease;
          width: 100%;
          font-size: 0.95rem;
        }

        .search-button:hover {
          transform: translateY(-2px);
          box-shadow: 0 4px 15px rgba(111, 66, 193, 0.3);
        }

        /* Doctor Cards Section */
        .doctors-section {
          padding: 4rem 0;
          background: #f8f9fa;
          border-radius: 30px;
          margin: 2rem 0;
        }

        .section-title {
          text-align: center;
          margin-bottom: 3rem;
          color: #2d3436;
          font-size: 2.5rem;
          font-weight: 700;
        }

        .doctor-card {
          background: white;
          border-radius: 20px;
          overflow: hidden;
          transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
          margin-bottom: 2rem;
          box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
          text-decoration: none;
          display: block;
          color: inherit;
        }

        .doctor-card:hover {
          transform: translateY(-10px);
          box-shadow: 0 12px 40px rgba(111, 66, 193, 0.2);
        }

        .doctor-card-content {
          display: flex;
          padding: 1.5rem;
          gap: 1.5rem;
        }

        .doctor-avatar {
          width: 120px;
          height: 120px;
          border-radius: 15px;
          overflow: hidden;
          flex-shrink: 0;
        }

        .doctor-avatar img {
          width: 100%;
          height: 100%;
          object-fit: cover;
          transition: transform 0.4s ease;
        }

        .doctor-card:hover .doctor-avatar img {
          transform: scale(1.1);
        }

        .doctor-info {
          flex: 1;
        }

        .doctor-name {
          color: #2d3436;
          font-size: 1.25rem;
          font-weight: 600;
          margin-bottom: 0.75rem;
        }

        .specialties,
        .experience,
        .fee {
          display: flex;
          align-items: center;
          gap: 0.5rem;
          margin-bottom: 0.75rem;
          color: #636e72;
          font-size: 0.95rem;
        }

        .specialties i,
        .experience i,
        .fee i {
          color: #6f42c1;
          font-size: 1.1rem;
        }

        .view-profile {
          display: inline-flex;
          align-items: center;
          gap: 0.5rem;
          padding: 0.75rem 1.5rem;
          background: linear-gradient(45deg, #6f42c1, #8655e0);
          color: white;
          border-radius: 10px;
          text-decoration: none;
          font-weight: 500;
          transition: all 0.3s ease;
          margin-top: 1rem;
        }

        .view-profile:hover {
          transform: translateX(5px);
          box-shadow: 0 4px 15px rgba(111, 66, 193, 0.3);
          color: white;
        }

        /* Pagination */
        .pagination {
          margin-top: 3rem;
          justify-content: center;
        }

        .pagination .page-link {
          border: none;
          padding: 0.75rem 1.25rem;
          margin: 0 0.25rem;
          border-radius: 10px;
          color: #6f42c1;
          font-weight: 500;
          transition: all 0.3s ease;
        }

        .pagination .page-link:hover,
        .pagination .page-item.active .page-link {
          background: linear-gradient(45deg, #6f42c1, #8655e0);
          color: white;
          box-shadow: 0 4px 15px rgba(111, 66, 193, 0.3);
        }

        /* Responsive Design */
        @media (max-width: 992px) {
          .doctor-card-content {
            flex-direction: column;
            align-items: center;
            text-align: center;
          }

          .doctor-avatar {
            width: 150px;
            height: 150px;
          }

          .view-profile {
            width: 100%;
            justify-content: center;
          }
        }

        @media (max-width: 768px) {
          .services-section {
            padding: 3rem 0;
          }

          .service-card {
            margin-bottom: 1.5rem;
          }

          .search-tabs {
            flex-direction: column;
          }

          .search-tab {
            width: 100%;
            text-align: center;
          }

          .search-container {
            margin: 0 1rem;
          }
        }
      </style>
    </head>

    <jsp:include page="../shared/header.jsp" />

    <!-- Dịch vụ nổi bật -->
    <section class="services-section">
      <div class="container">
        <h2 class="section-title text-white mb-4">Dịch vụ nổi bật</h2>
        <div class="row g-4">
          <div class="col-lg-3 col-md-6">
            <div class="service-card">
              <div class="service-icon">
                <i class="bi bi-calendar-check"></i>
              </div>
              <h5>Đặt lịch khám</h5>
              <p>Đặt lịch hẹn với bác sĩ chuyên khoa phù hợp một cách nhanh chóng và thuận tiện</p>
            </div>
          </div>

          <div class="col-lg-3 col-md-6">
            <div class="service-card">
              <div class="service-icon">
                <i class="bi bi-person-badge"></i>
              </div>
              <h5>Tìm bác sĩ</h5>
              <p>Dễ dàng tìm kiếm bác sĩ theo chuyên khoa và địa điểm phù hợp với nhu cầu của bạn</p>
            </div>
          </div>

          <div class="col-lg-3 col-md-6">
            <div class="service-card">
              <div class="service-icon">
                <i class="bi bi-chat-dots"></i>
              </div>
              <h5>Tư vấn online</h5>
              <p>Được tư vấn sức khỏe trực tuyến 24/7 với đội ngũ bác sĩ chuyên nghiệp</p>
            </div>
          </div>

          <div class="col-lg-3 col-md-6">
            <div class="service-card">
              <div class="service-icon">
                <i class="bi bi-file-earmark-medical"></i>
              </div>
              <h5>Hồ sơ sức khỏe</h5>
              <p>Quản lý hồ sơ bệnh án điện tử an toàn và tiện lợi mọi lúc mọi nơi</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Search Section -->
    <section class="search-section">
      <div class="container">
        <div class="search-container">
          <div class="search-tabs">
            <a href="#" class="search-tab active" data-tab="specialty">Tìm theo chuyên khoa</a>
            <a href="#" class="search-tab" data-tab="doctor">Tìm theo tên bác sĩ</a>
          </div>

          <form action="/search/specialties" method="GET" class="search-form" id="specialtyForm">
            <div class="row g-3">
              <div class="col-md-9">
                <input type="text" name="keyword" class="form-control" placeholder="Nhập tên chuyên khoa" required>
              </div>
              <div class="col-md-3">
                <button type="submit" class="search-button">
                  <i class="bi bi-search me-2"></i>Tìm kiếm
                </button>
              </div>
            </div>
          </form>

          <form action="/search/doctors" method="GET" class="search-form d-none" id="doctorForm">
            <div class="row g-3">
              <div class="col-md-9">
                <input type="text" name="keyword" class="form-control" placeholder="Nhập tên bác sĩ" required>
              </div>
              <div class="col-md-3">
                <button type="submit" class="search-button">
                  <i class="bi bi-search me-2"></i>Tìm kiếm
                </button>
              </div>
            </div>
          </form>
        </div>
      </div>
    </section>

    <!-- Doctors Section -->
    <section class="doctors-section">
      <div class="container">
        <h2 class="section-title">Đội ngũ bác sĩ</h2>
        <div class="row">
          <c:forEach items="${doctors}" var="doctor">
            <div class="col-lg-6">
              <a href="/search/doctors/details/${doctor.doctorID}" class="doctor-card">
                <div class="doctor-card-content">
                  <div class="doctor-avatar">
                    <img
                      src="${not empty doctor.user.avatarUrl ? doctor.user.avatarUrl : '/resources/images/defaultImg.jpg'}"
                      alt="BS. ${doctor.user.firstName} ${doctor.user.lastName}">
                  </div>
                  <div class="doctor-info">
                    <h3 class="doctor-name">BS. ${doctor.user.firstName} ${doctor.user.lastName}</h3>
                    <div class="specialties">
                      <i class="bi bi-briefcase-fill"></i>
                      <span>
                        <c:forEach items="${doctor.specializations}" var="spec" varStatus="loop">
                          ${spec.specializationName}${!loop.last ? ', ' : ''}
                        </c:forEach>
                      </span>
                    </div>
                    <div class="experience">
                      <i class="bi bi-clock-history"></i>
                      <span>Kinh nghiệm: ${doctor.experienceYears} năm</span>
                    </div>
                    <div class="fee">
                      <i class="bi bi-cash"></i>
                      <span>Phí khám: ${doctor.consultationFee} VNĐ</span>
                    </div>
                  </div>
                </div>
              </a>
            </div>
          </c:forEach>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
          <nav aria-label="Doctor pagination">
            <ul class="pagination">
              <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                <a class="page-link" href="/?page=${currentPage - 1}">
                  <i class="bi bi-chevron-left"></i>
                </a>
              </li>
              <c:forEach begin="0" end="${totalPages - 1}" var="i">
                <li class="page-item ${currentPage == i ? 'active' : ''}">
                  <a class="page-link" href="/?page=${i}">${i + 1}</a>
                </li>
              </c:forEach>
              <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                <a class="page-link" href="/?page=${currentPage + 1}">
                  <i class="bi bi-chevron-right"></i>
                </a>
              </li>
            </ul>
          </nav>
        </c:if>
      </div>
    </section>

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
            searchTabs.forEach(t => t.classList.remove('active'));
            tab.classList.add('active');

            Object.values(searchForms).forEach(form => {
              form.classList.add('d-none');
            });

            const formId = tab.dataset.tab;
            searchForms[formId].classList.remove('d-none');
          });
        });
      });
    </script>
    </body>

    </html>