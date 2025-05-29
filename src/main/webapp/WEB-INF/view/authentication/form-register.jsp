<%@page contentType="text/html" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

      <!DOCTYPE html>
      <html lang="vi">

      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="/css/register.css">
        <title>Đăng Ký - HealthCare+</title>
      </head>

      <body>
        <div class="register-page-container">
          <!-- Left Section with Image -->
          <div class="register-image-section">
            <div class="register-image-overlay">
              <div class="register-image-text">
                <h1>Tham gia cùng HealthCare+</h1>
                <p>Đăng ký tài khoản để trải nghiệm dịch vụ chăm sóc sức khỏe toàn diện cùng đội ngũ bác sĩ chuyên
                  nghiệp.</p>
              </div>
            </div>
          </div>

          <!-- Right Section with Register Form -->
          <div class="register-form-section">
            <div class="register-container">
              <!-- Logo Section -->
              <div class="logo-section">
                <div class="logo">
                  <div class="logo-icon">⚕️</div>
                  <div class="logo-text">HealthCare+</div>
                </div>
              </div>

              <form:form method="post" modelAttribute="user" action="/register" cssClass="register-form">
                <!-- Username & Password -->
                <div class="form-row">
                  <div class="form-group">
                    <label class="form-label">Tên đăng nhập</label>
                    <form:input path="username" cssClass="form-input" placeholder="Nhập tên đăng nhập" />
                  </div>
                  <div class="form-group">
                    <label class="form-label">Mật khẩu</label>
                    <form:password path="password" cssClass="form-input" placeholder="Nhập mật khẩu" />
                  </div>
                </div>

                <!-- First & Last Name -->
                <div class="form-row">
                  <div class="form-group">
                    <label class="form-label">Họ</label>
                    <form:input path="firstName" cssClass="form-input" placeholder="Nhập họ" />
                  </div>
                  <div class="form-group">
                    <label class="form-label">Tên</label>
                    <form:input path="lastName" cssClass="form-input" placeholder="Nhập tên" />
                  </div>
                </div>

                <!-- DOB & Gender -->
                <div class="form-row">
                  <div class="form-group">
                    <label class="form-label">Ngày sinh</label>
                    <form:input path="dob" type="date" cssClass="form-input" />
                  </div>
                  <div class="form-group">
                    <label class="form-label">Giới tính</label>
                    <div class="radio-group">
                      <label class="radio-option">
                        <form:radiobutton path="gender" value="female" cssClass="radio-input" />
                        <span>Nữ</span>
                      </label>
                      <label class="radio-option">
                        <form:radiobutton path="gender" value="male" cssClass="radio-input" />
                        <span>Nam</span>
                      </label>
                      <label class="radio-option">
                        <form:radiobutton path="gender" value="other" cssClass="radio-input" />
                        <span>Khác</span>
                      </label>
                    </div>
                  </div>
                </div>

                <!-- Email & Phone -->
                <div class="form-row">
                  <div class="form-group">
                    <label class="form-label">Email</label>
                    <form:input path="email" type="email" cssClass="form-input" placeholder="Nhập email" />
                  </div>
                  <div class="form-group">
                    <label class="form-label">Số điện thoại</label>
                    <form:input path="phone" cssClass="form-input" type="text" pattern="[0-9]*"
                      placeholder="Nhập số điện thoại" value="" />
                  </div>
                </div>

                <!-- Address -->
                <div class="form-group">
                  <label class="form-label">Địa chỉ</label>
                  <form:input path="address" cssClass="form-input" placeholder="Nhập địa chỉ" />
                </div>

                <!-- Error Message -->
                <c:if test="${not empty error}">
                  <div class="error-message">
                    ${error}
                  </div>
                </c:if>

                <!-- Submit Button -->
                <button type="submit" class="register-btn">
                  Đăng ký
                </button>

                <!-- Login Link -->
                <div class="login-link">
                  Đã có tài khoản? <a href="/login">Đăng nhập ngay</a>
                </div>
              </form:form>
            </div>
          </div>
        </div>
      </body>

      </html>