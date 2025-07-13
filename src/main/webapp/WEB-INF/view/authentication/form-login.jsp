<%@page contentType="text/html" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

      <!DOCTYPE html>
      <html lang="vi">

      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="/css/login.css">
        <title>Đăng Nhập - HealthCare+</title>
      </head>

      <body>
        <div class="login-page-container">
          <!-- Left Section with Image -->
          <div class="login-image-section">
            <div class="login-image-overlay">
              <div class="login-image-text">
                <h1>Chào mừng trở lại!</h1>
                <p>Đăng nhập để tiếp tục trải nghiệm dịch vụ chăm sóc sức khỏe toàn diện cùng đội ngũ bác sĩ chuyên
                  nghiệp.</p>
              </div>
            </div>
          </div>

          <!-- Right Section with Login Form -->
          <div class="login-form-section">
            <div class="login-container">
              <!-- Logo Section -->
              <div class="logo-section">
                <div class="logo">
                  <div class="logo-icon">⚕️</div>
                  <div class="logo-text">HealthCare+</div>
                </div>
              </div>

              <!-- Messages -->
              <c:if test="${not empty message}">
                <div class="alert alert-success">
                  <i class="bi bi-check-circle"></i>
                  ${message}
                </div>
              </c:if>
              <c:if test="${not empty error}">
                <div class="alert alert-danger">
                  <i class="bi bi-exclamation-circle"></i>
                  ${error}
                </div>
              </c:if>

              <form action="${pageContext.request.contextPath}/login" method="post" class="login-form">
                <div class="form-group">
                  <label class="form-label">Email hoặc tên đăng nhập</label>
                  <div class="input-with-icon">
                    <i class="bi bi-person"></i>
                    <input type="text" name="emailOrUsername" class="form-input"
                      placeholder="Nhập email hoặc tên đăng nhập" required value="${emailOrUsername}">
                  </div>
                </div>
                <div class="form-group">
                  <label class="form-label">Mật khẩu</label>
                  <div class="input-with-icon">
                    <i class="bi bi-lock"></i>
                    <input type="password" name="password" class="form-input" placeholder="Nhập mật khẩu" required>
                  </div>
                </div>
                <div class="form-options">
                  <div class="remember-me">
                    <input type="checkbox" id="remember" name="remember">
                    <label for="remember">Ghi nhớ đăng nhập</label>
                  </div>
                  <a href="/forgot-password" class="forgot-password">Quên mật khẩu?</a>
                </div>
                <button type="submit" class="login-btn">
                  Đăng nhập
                </button>
                <div class="register-link">
                  Chưa có tài khoản? <a href="/register">Đăng ký ngay</a>
                </div>
              </form>

              <!-- Divider -->
              <div class="divider">
                <span>hoặc</span>
              </div>

              <!-- Google Login -->
              <a href="${googleLoginUrl}" class="google-btn">
                <div class="google-icon">G</div>
                Đăng nhập bằng Google
              </a>
            </div>
          </div>
        </div>
      </body>

      </html>