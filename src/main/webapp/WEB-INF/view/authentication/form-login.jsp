<%@page contentType="text/html" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

      <!DOCTYPE html>
      <html lang="en">

      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="/css/login.css">
        <title>Đăng Nhập - HealthCare+</title>
      </head>

      <body>
        <div class="login-page-container">
          <!-- Left Section with Image -->
          <div class="login-image-section">
            <div class="login-image-overlay">
              <div class="login-image-text">
                <h1>Chào mừng đến với HealthCare+</h1>
                <p>Hệ thống chăm sóc sức khỏe toàn diện, kết nối bạn với các bác sĩ chuyên nghiệp và dịch vụ y tế
                  chất
                  lượng cao.</p>
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

              <form class="login-form" id="loginForm" method="post" action="/login">
                <div class="form-group">
                  <label class="form-label" for="username">Email hoặc tên đăng nhập</label>
                  <input type="text" id="username" class="form-input" placeholder="Nhập email hoặc tên đăng nhập"
                    name="emailorusername" required>
                </div>
                <div class="form-group">
                  <label class="form-label" for="password">Mật khẩu</label>
                  <input type="password" id="password" class="form-input" placeholder="Nhập mật khẩu" name="password"
                    required>
                  <span class="password-toggle" onclick="togglePassword()">🙈</span>
                </div>
                <c:if test="${not empty error}">
                  <div class="error-message">
                    ${error}
                  </div>
                </c:if>
                <div class="remember-me">
                  <div class="checkbox" id="rememberCheckbox" onclick="toggleRemember()"></div>
                  <label class="remember-label" for="rememberCheckbox">Ghi nhớ đăng nhập</label>
                </div>

                <div class="forgot-password">
                  <a href="#" onclick="forgotPassword()">Quên mật khẩu?</a>
                </div>

                <button type="submit" class="login-btn" id="loginBtn">
                  Đăng nhập
                </button>
              </form>

              <!-- Divider -->
              <div class="divider">
                <span>hoặc</span>
              </div>

              <!-- Google Login -->
              <a href="https://accounts.google.com/o/oauth2/v2/auth?client_id=466371957964-j3qsb2g0fn7j46rh4q58vq95e7qdah6a.apps.googleusercontent.com&redirect_uri=http://localhost:8080/oauth2/callback&response_type=code&scope=openid%20email%20profile&access_type=online"
                class="google-btn">
                <div class="google-icon">G</div>
                Đăng nhập bằng Google
              </a>

              <!-- Signup Link -->
              <div class="signup-link">
                Chưa có tài khoản? <a href="/register">Đăng ký ngay</a>
              </div>
            </div>
          </div>
        </div>

        <script>
          let isPasswordVisible = false;
          let isRemembered = false;

          function togglePassword() {
            const passwordInput = document.getElementById('password');
            const toggleIcon = document.querySelector('.password-toggle');

            if (isPasswordVisible) {
              passwordInput.type = 'password';
              toggleIcon.textContent = '🙈';
            } else {
              passwordInput.type = 'text';
              toggleIcon.textContent = '👁️';
            }
            isPasswordVisible = !isPasswordVisible;
          }

        </script>
      </body>

      </html>