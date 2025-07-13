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
        <title>HealthCare+ - Trang chủ Bác sĩ</title>
      </head>

      <body>
        <!-- Header -->
        <header class="header">
          <div class="container">
            <nav class="nav">
              <!-- Logo -->
              <a href="<c:url value='/doctor/home' />" class="logo">
                <div class="logo-icon">⚕️</div>
                HealthCare+
              </a>

              <!-- Mobile Menu Button -->
              <button class="mobile-menu-btn" id="mobileMenuBtn">
                <i class="bi bi-list"></i>
              </button>

              <!-- Navigation Links -->
              <ul class="nav-links" id="navLinks">
                <li><a href="<c:url value='/doctor/home' />" class="active"><i class="bi bi-house-door"></i> Trang
                    chủ</a></li>
                <li><a href="/feedback/list"><i class="bi bi-person-badge"></i> Feedback</a></li>
                <li><a href="/doctor/schedules"><i class="bi bi-clipboard2-pulse"></i> Xem lịch làm việc </a></li>
                <li><a href="<c:url value='/doctor/appointments' />"><i class="bi bi-calendar-check"></i> Lịch hẹn</a>
                </li>
              </ul>

              <!-- User Menu -->
              <div class="user-menu">
                <c:choose>
                  <c:when test="${not empty currentUser}">
                    <button class="notification-btn">
                      <i class="bi bi-bell"></i>
                      <span class="notification-badge">2</span>
                    </button>
                    <div class="dropdown">
                      <button class="profile-btn" id="profileDropdownBtn">
                        <i class="bi bi-person-circle"></i>
                        ${currentUser.firstName} ${currentUser.lastName}
                      </button>
                      <ul class="dropdown-menu" id="profileDropdown">
                        <li><a class="dropdown-item" href="/doctor/profile"><i class="bi bi-person"></i> Trang cá
                            nhân</a></li>
                        <li><a class="dropdown-item" href="/doctor/settings"><i class="bi bi-gear"></i> Cài đặt</a></li>
                        <li>
                          <hr class="dropdown-divider">
                        </li>
                        <li><a class="dropdown-item" href="/doctor/logout"><i class="bi bi-box-arrow-right"></i> Đăng
                            xuất</a></li>
                      </ul>
                    </div>
                  </c:when>
                  <c:otherwise>
                    <form action="<c:url value='/doctor/login' />" method="post" class="d-inline">
                      <div class="input-group">
                        <input type="text" class="form-control" name="username" placeholder="Username" required>
                        <input type="password" class="form-control" name="password" placeholder="Password" required>
                        <button type="submit" class="btn btn-primary">Đăng nhập</button>
                      </div>
                      <c:if test="${not empty error}">
                        <p class="text-danger text-center">${error}</p>
                      </c:if>
                    </form>
                  </c:otherwise>
                </c:choose>
              </div>
            </nav>
          </div>
        </header>

        <!-- Custom JavaScript -->
        <script>
          document.addEventListener('DOMContentLoaded', function () {
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

            const profileBtn = document.getElementById('profileDropdownBtn');
            const profileDropdown = document.getElementById('profileDropdown');

            if (profileBtn && profileDropdown) {
              profileBtn.addEventListener('click', function (e) {
                e.stopPropagation();
                profileDropdown.classList.toggle('show');
              });

              document.addEventListener('click', function (e) {
                if (!profileDropdown.contains(e.target) && !profileBtn.contains(e.target)) {
                  profileDropdown.classList.remove('show');
                }
              });
            }

            document.addEventListener('click', function (e) {
              if (!e.target.closest('.nav-links') && !e.target.closest('.mobile-menu-btn') && navLinks.classList.contains('show')) {
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

        <section class="homepage-intro py-5" style="background: #e3f2fd;">
          <div class="container">
            <div class="row align-items-center">
              <div class="col-lg-7 mb-4 mb-lg-0">
                <h2 class="fw-bold mb-3" style="color: #1976d2;">🌿 Chào mừng đến với Phòng Khám HealthCare+</h2>
                <p class="lead" style="color: #333;">
                  HealthCare+ là hệ thống đặt lịch khám trực tuyến hiện đại, giúp bạn kết nối dễ dàng với đội ngũ bác sĩ
                  giàu kinh nghiệm tại phòng khám.<br>
                  Chúng tôi mang đến giải pháp chăm sóc sức khỏe tiện lợi, nhanh chóng và hiệu quả – giúp bạn chủ động
                  hơn trong việc bảo vệ sức khỏe cho bản thân và gia đình.
                </p>
                <div class="mt-4">
                  <h5 class="fw-semibold mb-3" style="color: #1976d2;">💡 Tại sao nên chọn HealthCare+?</h5>
                  <ul class="list-unstyled fs-5">
                    <li class="mb-2"><span class="me-2">🔍</span>Tìm bác sĩ dễ dàng theo chuyên khoa hoặc lịch làm việc
                    </li>
                    <li class="mb-2"><span class="me-2">📅</span>Đặt lịch khám nhanh chóng, không cần chờ đợi</li>
                    <li class="mb-2"><span class="me-2">📄</span>Xem lại lịch sử khám bệnh và theo dõi quá trình điều
                      trị</li>
                    <li class="mb-2"><span class="me-2">🔔</span>Nhắc lịch tự động qua email hoặc tin nhắn</li>
                    <li class="mb-2"><span class="me-2">⭐</span>Đánh giá & phản hồi sau mỗi buổi khám</li>
                  </ul>
                </div>
              </div>
              <div class="col-lg-5 text-center">
                <img src="/uploads/health.png" alt="HealthCare+ Welcome" class="img-fluid rounded-4 shadow w-100"
                  style="object-fit: cover; height: 100%;">
              </div>
            </div>
          </div>
        </section>

        <!-- Footer -->
        <footer class="footer mt-5" style="background: #e3f2fd; border-top: 1px solid #b3d1f5;">
          <div class="container py-4">
            <div class="row">
              <!-- Clinic Info -->
              <div class="col-md-4 mb-4 mb-md-0">
                <div class="p-3 rounded-4"
                  style="background: linear-gradient(135deg, #7ec6f7 0%, #42a5f5 100%); color: #fff; border: 4px solid #b3d1f5;">
                  <div class="mb-3 text-center">
                    <i class="bi bi-hospital fs-1 mb-2" style="display:block;"></i>
                    <div class="fw-bold" style="font-size: 1.1rem; line-height: 1.3;">
                      PHÒNG KHÁM NỘI TỔNG HỢP <br>
                      HealthCare+
                    </div>
                  </div>
                  <hr style="border-color: #b3d1f5; opacity: 0.5;">
                  <div class="mb-3 d-flex align-items-start">
                    <i class="bi bi-geo-alt fs-5 me-3 mt-1"></i>
                    <div style="line-height: 1.5;">
                      20-22 Dương Quang Trung,<br>
                      Phường 12,<br>
                      Quận Liên Chiểu, TP.Đà Nẵng
                    </div>
                  </div>
                  <hr style="border-color: #b3d1f5; opacity: 0.5;">
                  <div class="mb-3 d-flex align-items-center">
                    <i class="bi bi-telephone fs-5 me-3"></i>
                    <span class="fw-bold fs-5" style="letter-spacing: 1px;">1900 6923</span>
                  </div>
                  <hr style="border-color: #b3d1f5; opacity: 0.5;">
                  <div class="mb-3 d-flex align-items-start">
                    <i class="bi bi-envelope fs-5 me-3 mt-1"></i>
                    <a href="mailto:contact.us@umcclinic.com.vn"
                      style="color: #fff; text-decoration: none; word-break: break-all;">
                      contact.us@umcclinic.com.vn
                    </a>
                  </div>
                  <hr style="border-color: #b3d1f5; opacity: 0.5;">
                  <div class="d-flex align-items-start">
                    <i class="bi bi-clock fs-5 me-3 mt-1"></i>
                    <div>
                      <span class="fw-semibold">Lịch làm việc:</span><br>
                      Từ thứ 2 - thứ 7 (7:30 - 16:30)
                    </div>
                  </div>
                </div>
              </div>

              <!-- Policies -->
              <div class="col-md-4 mb-4 mb-md-0">
                <div class="p-3 rounded-4"
                  style="background: linear-gradient(135deg, #7ec6f7 0%, #42a5f5 100%); color: #fff; border: 4px solid #b3d1f5; height: 100%;">
                  <h6 class="fw-bold mb-3 text-center">CHÍNH SÁCH</h6>
                  <ul class="list-unstyled">
                    <li class="mb-3 text-center"><a href="#" class="text-decoration-none text-white"><i
                          class="bi bi-chevron-right me-2"></i>Chính sách bảo mật</a></li>
                    <li class="mb-3 text-center"><a href="#" class="text-decoration-none text-white"><i
                          class="bi bi-chevron-right me-2"></i>Điều khoản sử dụng</a></li>
                    <li class="mb-3 text-center"><a href="#" class="text-decoration-none text-white"><i
                          class="bi bi-chevron-right me-2"></i>Chính sách thanh toán</a></li>
                    <li class="mb-3 text-center"><a href="#" class="text-decoration-none text-white"><i
                          class="bi bi-chevron-right me-2"></i>Chính sách hoàn hủy</a></li>
                    <li class="mb-3 text-center"><a href="#" class="text-decoration-none text-white"><i
                          class="bi bi-chevron-right me-2"></i>Chính sách bảo hành</a></li>
                  </ul>
                </div>
              </div>

              <!-- Social Media & Support -->
              <div class="col-md-4 mb-4 mb-md-0">
                <div class="p-3 rounded-4"
                  style="background: linear-gradient(135deg, #7ec6f7 0%, #42a5f5 100%); color: #fff; border: 4px solid #b3d1f5; height: 100%;">
                  <h6 class="fw-bold mb-3 text-center">KẾT NỐI VỚI CHÚNG TÔI</h6>
                  <div class="d-flex justify-content-center gap-3 mb-4">
                    <a href="#" class="text-decoration-none">
                      <div class="rounded-circle bg-white d-flex align-items-center justify-content-center"
                        style="width: 40px; height: 40px;">
                        <i class="bi bi-facebook text-primary"></i>
                      </div>
                    </a>
                    <a href="#" class="text-decoration-none">
                      <div class="rounded-circle bg-white d-flex align-items-center justify-content-center"
                        style="width: 40px; height: 40px;">
                        <i class="bi bi-instagram text-danger"></i>
                      </div>
                    </a>
                    <a href="#" class="text-decoration-none">
                      <div class="rounded-circle bg-white d-flex align-items-center justify-content-center"
                        style="width: 40px; height: 40px;">
                        <i class="bi bi-twitter-x text-info"></i>
                      </div>
                    </a>
                    <a href="#" class="text-decoration-none">
                      <div class="rounded-circle bg-white d-flex align-items-center justify-content-center"
                        style="width: 40px; height: 40px;">
                        <i class="bi bi-whatsapp text-success"></i>
                      </div>
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </footer>
      </body>

      </html>