<%@page contentType="text/html" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

      <!DOCTYPE html>
      <html lang="vi">

      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <title>Chỉnh sửa thông tin cá nhân</title>
        <style>
          body {
            background: #f8f9fa;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
          }

          .edit-profile-header {
            background: linear-gradient(135deg, #4b6cb7 0%, #182848 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
          }

          .edit-profile-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem;
          }

          .edit-profile-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.05);
            padding: 2rem;
            margin-bottom: 2rem;
          }

          .form-label {
            color: #2c3e50;
            font-weight: 500;
            margin-bottom: 0.5rem;
          }

          .form-control {
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
          }

          .form-control:focus {
            border-color: #4b6cb7;
            box-shadow: 0 0 0 0.2rem rgba(75, 108, 183, 0.15);
          }

          .form-control[readonly] {
            background-color: #f8f9fa;
            cursor: not-allowed;
          }

          .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
          }

          .btn-primary {
            background: linear-gradient(135deg, #4b6cb7 0%, #182848 100%);
            border: none;
          }

          .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(75, 108, 183, 0.3);
          }

          .btn-secondary {
            background: #6c757d;
            border: none;
          }

          .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(108, 117, 125, 0.3);
          }

          .form-group {
            margin-bottom: 1.5rem;
          }

          .form-text {
            color: #6c757d;
            font-size: 0.875rem;
            margin-top: 0.25rem;
          }

          .input-group-text {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
          }

          .form-floating>.form-control {
            height: calc(3.5rem + 2px);
            padding: 1rem 0.75rem;
          }

          .form-floating>label {
            padding: 1rem 0.75rem;
          }
        </style>
      </head>

      <body>
        <div class="edit-profile-header">
          <div class="container">
            <div class="row align-items-center">
              <div class="col">
                <h2 class="mb-0">
                  <i class="bi bi-person-gear me-2"></i>
                  Chỉnh sửa thông tin cá nhân
                </h2>
              </div>
            </div>
          </div>
        </div>

        <div class="container edit-profile-container">
          <div class="edit-profile-card">
            <form:form method="POST" modelAttribute="user" action="/profile/update">
              <div class="row">
                <div class="col-md-6">
                  <div class="form-group">
                    <label class="form-label">Họ</label>
                    <form:input path="firstName" cssClass="form-control" placeholder="Nhập họ của bạn" />
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="form-group">
                    <label class="form-label">Tên</label>
                    <form:input path="lastName" cssClass="form-control" placeholder="Nhập tên của bạn" />
                  </div>
                </div>
              </div>

              <div class="form-group">
                <label class="form-label">Email</label>
                <div class="input-group">
                  <span class="input-group-text">
                    <i class="bi bi-envelope"></i>
                  </span>
                  <form:input path="email" cssClass="form-control" readonly="true" />
                </div>
                <div class="form-text">Email không thể thay đổi</div>
              </div>

              <div class="form-group">
                <label class="form-label">Số điện thoại</label>
                <div class="input-group">
                  <span class="input-group-text">
                    <i class="bi bi-phone"></i>
                  </span>
                  <form:input path="phone" cssClass="form-control" placeholder="Nhập số điện thoại của bạn" />
                </div>
              </div>

              <div class="form-group">
                <label class="form-label">Địa chỉ</label>
                <div class="input-group">
                  <span class="input-group-text">
                    <i class="bi bi-geo-alt"></i>
                  </span>
                  <form:input path="address" cssClass="form-control" placeholder="Nhập địa chỉ của bạn" />
                </div>
              </div>
              <div class="form-group">
                <label class="form-label">Gender</label>
                <div class="input-group">
                  <span class="input-group-text">
                    <i class="bi bi-geo-alt"></i>
                  </span>
                  <form:select path="gender" cssClass="form-select">
                    <form:option value="" label="Chọn giới tính" />
                    <form:option value="Male" label="Male" />
                    <form:option value="Female" label="Female" />
                    <form:option value="Another" label="Another" />
                  </form:select>
                </div>
              </div>
              <div class="form-group">
                <label class="form-label">Date of Birth</label>
                <div class="input-group">
                  <span class="input-group-text">
                    <i class="bi bi-geo-alt"></i>
                  </span>
                  <form:input path="dob" cssClass="form-control" placeholder="Nhập ngày sinh của bạn" type="date" />
                </div>
              </div>


              <div class="d-flex justify-content-end gap-2 mt-4">
                <a href="/profile" class="btn btn-secondary">
                  <i class="bi bi-x-circle me-2"></i>Hủy
                </a>
                <button type="submit" class="btn btn-primary">
                  <i class="bi bi-check-circle me-2"></i>Lưu thay đổi
                </button>
              </div>
            </form:form>
          </div>
        </div>


      </body>

      </html>