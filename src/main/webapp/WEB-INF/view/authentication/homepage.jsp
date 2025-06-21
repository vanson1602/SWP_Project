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
        <!-- Include shared header -->
        <jsp:include page="/WEB-INF/view/shared/header.jsp" />

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
                  <h5 class="fw-semibold"><a href="/appointments">Đặt lịch khám</a></h5>
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