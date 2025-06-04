<%@page contentType="text/html" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

      <!DOCTYPE html>
      <html lang="vi">

      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="/css/homepage.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <title>HealthCare+ - Đặt lịch khám chữa bệnh</title>
      </head>

      <body>
        <!-- Header -->
        <header class="header">
          <div class="container">
            <nav class="nav">
              <!-- Logo -->
              <a href="/" class="logo">
                <div class="logo-icon">⚕️</div>
                HealthCare+
              </a>

              <!-- Mobile Menu Button -->
              <button class="mobile-menu-btn" id="mobileMenuBtn">
                <i class="bi bi-list"></i>
              </button>

              <!-- Navigation Links -->
              <ul class="nav-links" id="navLinks">
                <li><a href="/" class="active"><i class="bi bi-house-door"></i> Trang chủ</a></li>
                <li><a href="/doctors"><i class="bi bi-person-badge"></i> Bác sĩ</a></li>
                <li><a href="/specialties"><i class="bi bi-clipboard2-pulse"></i> Chuyên khoa</a></li>
                <li><a href="/appointments"><i class="bi bi-calendar-check"></i> Lịch hẹn</a></li>
              </ul>

              <!-- User Menu -->
              <div class="user-menu">
                <c:choose>
                  <c:when test="${not empty sessionScope.currentUser}">
                    <button class="notification-btn">
                      <i class="bi bi-bell"></i>
                      <span class="notification-badge">2</span>
                    </button>
                    <div class="dropdown">
                      <button class="profile-btn" id="profileDropdownBtn">
                        <i class="bi bi-person-circle"></i>
                        ${sessionScope.currentUser.firstName} ${sessionScope.currentUser.lastName}
                      </button>
                      <ul class="dropdown-menu" id="profileDropdown">
                        <li><a class="dropdown-item" href="/profile"><i class="bi bi-person"></i> Trang cá nhân</a></li>
                        <li><a class="dropdown-item" href="/settings"><i class="bi bi-gear"></i> Cài đặt</a></li>
                        <li>
                          <hr class="dropdown-divider">
                        </li>
                        <li><a class="dropdown-item" href="/logout"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a>
                        </li>
                      </ul>
                    </div>
                  </c:when>
                  <c:otherwise>
                    <a href="/login" class="profile-btn">
                      <i class="bi bi-box-arrow-in-right"></i>
                      Đăng nhập
                    </a>
                  </c:otherwise>
                </c:choose>
              </div>
            </nav>
          </div>
        </header>

        <!-- Custom JavaScript -->
        <script>
          document.addEventListener('DOMContentLoaded', function () {
            // Mobile menu handling
            const mobileMenuBtn = document.getElementById('mobileMenuBtn');
            const navLinks = document.getElementById('navLinks');

            mobileMenuBtn.addEventListener('click', function () {
              navLinks.classList.toggle('show');
              const icon = this.querySelector('i');
              if (navLinks.classList.contains('show')) {
                icon.classList.remove('bi-list');
                icon.classList.add('bi-x-lg');
              } else {
                icon.classList.remove('bi-x-lg');
                icon.classList.add('bi-list');
              }
            });

            // Profile dropdown handling
            const profileBtn = document.getElementById('profileDropdownBtn');
            const profileDropdown = document.getElementById('profileDropdown');

            if (profileBtn && profileDropdown) {
              profileBtn.addEventListener('click', function (e) {
                e.stopPropagation();
                profileDropdown.classList.toggle('show');
              });

              // Close dropdown when clicking outside
              document.addEventListener('click', function (e) {
                if (!profileDropdown.contains(e.target) && !profileBtn.contains(e.target)) {
                  profileDropdown.classList.remove('show');
                }
              });
            }

            // Close mobile menu when clicking outside
            document.addEventListener('click', function (e) {
              if (!e.target.closest('.nav-links') &&
                !e.target.closest('.mobile-menu-btn') &&
                navLinks.classList.contains('show')) {
                navLinks.classList.remove('show');
                const icon = mobileMenuBtn.querySelector('i');
                icon.classList.remove('bi-x-lg');
                icon.classList.add('bi-list');
              }
            });
          });
        </script>

        <!-- Hero Section -->
        <section class="text-center text-white py-5" style="background: linear-gradient(135deg, #667eea, #764ba2);">
          <div class="container">
            <h1 class="fw-bold display-5">Chăm sóc sức khỏe thông minh</h1>
            <p class="lead">Đặt lịch khám với các bác sĩ hàng đầu một cách nhanh chóng và tiện lợi</p>
            <form class="row justify-content-center g-2 mt-4">
              <div class="col-md-3">
                <input type="text" class="form-control" placeholder="Tìm bác sĩ, chuyên khoa">
              </div>
              <div class="col-md-3">
                <input type="date" class="form-control">
              </div>
              <div class="col-auto">
                <button class="btn btn-light text-primary fw-semibold">
                  <i class="bi bi-search"></i> Tìm kiếm
                </button>
              </div>
            </form>
          </div>
        </section>

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

      </body>

      </html>