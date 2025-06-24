<%@page contentType="text/html" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
      <!DOCTYPE html>
      <html lang="vi">

      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tạo Mới Bác Sĩ - HealthCare</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
        <!-- Select2 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <style>
          .form-section {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
          }

          .form-section h3 {
            color: #0d6efd;
            margin-bottom: 20px;
            font-size: 1.5rem;
          }

          .required-field::after {
            content: " *";
            color: red;
          }
        </style>
      </head>

      <body>
        <div class="container mt-5">
          <h2 class="mb-4">Tạo Mới Bác Sĩ</h2>
          <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
              ${error}
            </div>
          </c:if>
          <form:form method="post" action="/admin/doctor/create" modelAttribute="newDoctor"
            enctype="multipart/form-data">
            <!-- Thông tin đăng nhập -->
            <div class="form-section">
              <h3><i class="bi bi-person-badge"></i> Thông Tin Đăng Nhập</h3>
              <div class="mb-3">
                <label class="form-label required-field">Tên đăng nhập</label>
                <div class="input-group">
                  <span class="input-group-text"><i class="bi bi-person"></i></span>
                  <form:input path="user.username" class="form-control" placeholder="Nhập tên đăng nhập"
                    required="true" />
                </div>
              </div>
              <div class="mb-3">
                <label class="form-label required-field">Email</label>
                <div class="input-group">
                  <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                  <form:input path="user.email" type="email" class="form-control" placeholder="Nhập email"
                    required="true" />
                </div>
              </div>
              <div class="mb-3">
                <label class="form-label required-field">Mật khẩu</label>
                <div class="input-group">
                  <span class="input-group-text"><i class="bi bi-lock"></i></span>
                  <form:password path="user.password" class="form-control" placeholder="Nhập mật khẩu"
                    required="true" />
                </div>
              </div>
            </div>

            <!-- Thông tin cá nhân -->
            <div class="form-section">
              <h3><i class="bi bi-person-lines-fill"></i> Thông Tin Cá Nhân</h3>
              <div class="row">
                <div class="col-md-6 mb-3">
                  <label class="form-label required-field">Họ</label>
                  <form:input path="user.firstName" class="form-control" placeholder="Nhập họ" required="true" />
                </div>
                <div class="col-md-6 mb-3">
                  <label class="form-label required-field">Tên</label>
                  <form:input path="user.lastName" class="form-control" placeholder="Nhập tên" required="true" />
                </div>
              </div>
              <div class="mb-3">
                <label class="form-label required-field">Giới tính</label>
                <form:select path="user.gender" class="form-select" required="true">
                  <form:option value="" label="Chọn giới tính" />
                  <form:option value="Male" label="Nam" />
                  <form:option value="Female" label="Nữ" />
                  <form:option value="Other" label="Khác" />
                </form:select>
              </div>
              <div class="mb-3">
                <label class="form-label required-field">Ngày sinh</label>
                <form:input path="user.dob" class="form-control" type="date" required="true" />
              </div>
              <div class="mb-3">
                <label class="form-label required-field">Địa chỉ</label>
                <div class="input-group">
                  <span class="input-group-text"><i class="bi bi-geo-alt"></i></span>
                  <form:input path="user.address" class="form-control" placeholder="Nhập địa chỉ" required="true" />
                </div>
              </div>
              <div class="mb-3">
                <label class="form-label required-field">Số điện thoại</label>
                <div class="input-group">
                  <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                  <form:input path="user.phone" class="form-control" placeholder="Nhập số điện thoại" required="true" />
                </div>
              </div>
            </div>

            <!-- Thông tin chuyên môn -->
            <div class="form-section">
              <h3><i class="bi bi-briefcase"></i> Thông Tin Chuyên Môn</h3>
              <div class="mb-3">
                <label class="form-label required-field">Mã bác sĩ</label>
                <div class="input-group">
                  <span class="input-group-text"><i class="bi bi-hash"></i></span>
                  <form:input path="doctorCode" class="form-control" placeholder="Nhập mã bác sĩ" required="true" />
                </div>
                <small class="text-muted">Mã bác sĩ phải là duy nhất trong hệ thống</small>
              </div>
              <div class="mb-3">
                <label class="form-label required-field">Số giấy phép hành nghề</label>
                <div class="input-group">
                  <span class="input-group-text"><i class="bi bi-card-text"></i></span>
                  <form:input path="licenseNumber" class="form-control" placeholder="Nhập số giấy phép hành nghề"
                    required="true" />
                </div>
              </div>
              <div class="mb-3">
                <label class="form-label required-field">Số năm kinh nghiệm</label>
                <div class="input-group">
                  <span class="input-group-text"><i class="bi bi-calendar-check"></i></span>
                  <form:input path="experienceYears" class="form-control" type="number" min="0"
                    placeholder="Nhập số năm kinh nghiệm" required="true" />
                </div>
              </div>
              <div class="mb-3">
                <label class="form-label required-field">Phí tư vấn (VNĐ)</label>
                <div class="input-group">
                  <span class="input-group-text"><i class="bi bi-cash-coin"></i></span>
                  <form:input path="consultationFee" class="form-control" type="number" min="0" step="1000"
                    placeholder="Nhập phí tư vấn" required="true" />
                </div>
              </div>
              <div class="mb-3">
                <label class="form-label required-field">Bằng cấp/Chứng chỉ</label>
                <div class="input-group">
                  <span class="input-group-text"><i class="bi bi-mortarboard"></i></span>
                  <form:input path="qualification" class="form-control" placeholder="Nhập thông tin bằng cấp/chứng chỉ"
                    required="true" />
                </div>
              </div>
              <div class="mb-3">
                <label class="form-label required-field">Chuyên khoa</label>
                <div class="input-group">
                  <span class="input-group-text"><i class="bi bi-briefcase-fill"></i></span>
                  <select name="specializationIds" multiple="multiple" class="form-control select2" required>
                    <c:forEach items="${specializations}" var="spec">
                      <option value="${spec.specializationID}">${spec.specializationName} - ${spec.description}</option>
                    </c:forEach>
                  </select>
                </div>
                <small class="text-muted">Có thể chọn nhiều chuyên khoa</small>
              </div>
            </div>

            <!-- Ảnh đại diện -->
            <div class="form-section">
              <h3><i class="bi bi-image"></i> Ảnh Đại Diện</h3>
              <div class="mb-3">
                <label class="form-label">Ảnh</label>
                <input type="file" name="image" class="form-control" accept="image/*" />
                <small class="text-muted">Chọn ảnh đại diện cho bác sĩ (không bắt buộc)</small>
              </div>
            </div>

            <div class="mb-3">
              <button type="submit" class="btn btn-primary btn-lg">
                <i class="bi bi-check-circle"></i> Tạo Mới Bác Sĩ
              </button>
              <a href="/admin/doctors" class="btn btn-secondary btn-lg">
                <i class="bi bi-x-circle"></i> Hủy
              </a>
            </div>
          </form:form>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <!-- Select2 JS -->
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
        <script>
          $(document).ready(function () {
            $('.select2').select2({
              placeholder: "Chọn chuyên khoa",
              allowClear: true,
              width: '100%'
            });
          });
        </script>
      </body>

      </html>