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
      </style>
    </head>

    <body>
      <!-- Include Header -->
      <jsp:include page="../shared/header.jsp" />

      <!-- Search Section -->
      <section class="search-section">
        <div class="container">
          <div class="search-tabs">
            <div class="d-flex justify-content-start gap-4 mb-3">
              <a href="#" class="search-tab active" data-tab="specialty">Tìm theo chuyên khoa</a>
              <a href="#" class="search-tab" data-tab="doctor">Tìm theo tên bác sĩ</a>
            </div>

            <!-- Specialty Search Form -->
            <form action="/search/specialties" method="GET" class="search-form" id="specialtyForm">
              <div class="row g-3">
                <div class="col-md-9">
                  <label class="form-label">Chuyên khoa</label>
                  <input type="text" name="keyword" class="form-control" placeholder="Nhập tên chuyên khoa" required>
                </div>
                <div class="col-md-3 d-flex align-items-end">
                  <button type="submit" class="search-button w-100">
                    <i class="bi bi-search me-2"></i>Tìm kiếm
                  </button>
                </div>
              </div>
            </form>

            <!-- Doctor Search Form -->
            <form action="/search/doctors" method="GET" class="search-form d-none" id="doctorForm">
              <div class="row g-3">
                <div class="col-md-9">
                  <label class="form-label">Tên bác sĩ</label>
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


      <!-- Dịch vụ nổi bật -->
      <section class="py-5 bg-light">
        <div class="container text-center">
          <h2 class="fw-bold mb-5">Dịch vụ nổi bật</h2>
          <div class="row g-4">
            <div class="col-md-3 col-sm-6">
              <div class="card h-100 shadow-sm border-0 p-3">
                <div
                  class="bg-primary text-white rounded-circle d-flex justify-content-center align-items-center mx-auto mb-3"
                  style="width: 60px; height: 60px;">
                  <i class="bi bi-calendar-check fs-4"></i>
                </div>
                <h5 class="fw-semibold">Đặt lịch khám</h5>
                <p class="text-muted small">Đặt lịch hẹn với bác sĩ chuyên khoa phù hợp</p>
              </div>
            </div>

            <div class="col-md-3 col-sm-6">
              <div class="card h-100 shadow-sm border-0 p-3">
                <div
                  class="bg-danger text-white rounded-circle d-flex justify-content-center align-items-center mx-auto mb-3"
                  style="width: 60px; height: 60px;">
                  <i class="bi bi-person-badge fs-4"></i>
                </div>
                <h5 class="fw-semibold">Tìm bác sĩ</h5>
                <p class="text-muted small">Tìm kiếm bác sĩ theo chuyên khoa và địa điểm</p>
              </div>
            </div>

            <div class="col-md-3 col-sm-6">
              <div class="card h-100 shadow-sm border-0 p-3">
                <div
                  class="bg-info text-white rounded-circle d-flex justify-content-center align-items-center mx-auto mb-3"
                  style="width: 60px; height: 60px;">
                  <i class="bi bi-chat-dots fs-4"></i>
                </div>
                <h5 class="fw-semibold">Tư vấn online</h5>
                <p class="text-muted small">Tư vấn sức khỏe trực tuyến 24/7</p>
              </div>
            </div>

            <div class="col-md-3 col-sm-6">
              <div class="card h-100 shadow-sm border-0 p-3">
                <div
                  class="bg-success text-white rounded-circle d-flex justify-content-center align-items-center mx-auto mb-3"
                  style="width: 60px; height: 60px;">
                  <i class="bi bi-file-earmark-medical fs-4"></i>
                </div>
                <h5 class="fw-semibold">Hồ sơ sức khỏe</h5>
                <p class="text-muted small">Quản lý hồ sơ bệnh án điện tử</p>
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