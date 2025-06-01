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
        <title>Thông tin cá nhân</title>
        <style>
          .profile-header {
            background: linear-gradient(135deg, #4b6cb7 0%, #182848 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
          }

          .profile-avatar {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            border: 4px solid #fff;
            object-fit: cover;
            margin-bottom: 1rem;
            position: relative;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
          }

          .avatar-container {
            position: relative;
            display: inline-block;
            cursor: pointer;
            transition: all 0.3s ease;
            border-radius: 50%;
            padding: 3px;
            background: linear-gradient(135deg, #4b6cb7 0%, #182848 100%);
          }

          .avatar-container:hover .profile-avatar {
            transform: scale(0.95);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
          }

          .avatar-overlay {
            position: absolute;
            top: 3px;
            left: 3px;
            right: 3px;
            bottom: 3px;
            background: rgba(0, 0, 0, 0.4);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: all 0.3s ease;
            backdrop-filter: blur(2px);
          }

          .avatar-container:hover .avatar-overlay {
            opacity: 1;
          }

          .avatar-overlay i {
            color: white;
            font-size: 1.8rem;
            margin-bottom: 5px;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
          }

          .avatar-overlay-text {
            color: white;
            font-size: 0.85rem;
            font-weight: 500;
            text-align: center;
            text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
            letter-spacing: 0.5px;
          }

          .avatar-file-input {
            display: none;
          }

          .avatar-container:active {
            transform: scale(0.98);
          }

          .profile-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
          }

          .profile-card:hover {
            transform: translateY(-5px);
          }

          .profile-info {
            padding: 1.5rem;
          }

          .info-label {
            color: #6c757d;
            font-weight: 500;
          }

          .info-value {
            color: #2c3e50;
            font-weight: 600;
          }

          .btn-change-password {
            background: linear-gradient(135deg, #4b6cb7 0%, #182848 100%);
            border: none;
            color: white;
            padding: 0.5rem 1.5rem;
            border-radius: 25px;
            transition: all 0.3s ease;
          }

          .btn-change-password:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            color: white;
          }

          .modal-content {
            border-radius: 15px;
            border: none;
          }

          .modal-header {
            background: linear-gradient(135deg, #4b6cb7 0%, #182848 100%);
            color: white;
            border-radius: 15px 15px 0 0;
          }

          .form-control:focus {
            border-color: #4b6cb7;
            box-shadow: 0 0 0 0.2rem rgba(75, 108, 183, 0.25);
          }
        </style>
      </head>

      <body class="bg-light">
        <div class="profile-header">
          <div class="container">
            <div class="row align-items-center">
              <div class="col-md-3 text-center">
                <div class="avatar-container">
                  <img
                    src="${user.avatar != null ? user.avatar : 'https://cdn-icons-png.flaticon.com/512/149/149071.png'}"
                    alt="Profile Avatar" class="profile-avatar">
                  <div class="avatar-overlay">
                    <div class="text-center">
                      <i class="bi bi-camera"></i>
                      <div class="avatar-overlay-text">Thay đổi ảnh</div>
                    </div>
                  </div>
                  <input type="file" class="avatar-file-input" id="avatarInput" accept="images/*"
                    onchange="previewImage(this)">
                </div>

              </div>
              <div class="col-md-9">
                <h2 class="mb-2">${user.firstName} ${user.lastName}</h2>
                <p class="mb-0"><i class="bi bi-envelope"></i> ${user.email}</p>
                <p class="mb-0"><i class="bi bi-person-badge"></i> ${user.role}</p>
              </div>
            </div>
          </div>
        </div>

        <div class="container">
          <div class="row">
            <div class="col-md-8 mx-auto">
              <div class="profile-card bg-white mb-4">
                <div class="profile-info">
                  <h4 class="mb-4">Thông tin chi tiết</h4>

                  <div class="row mb-3">
                    <div class="col-md-4 info-label">Họ và tên</div>
                    <div class="col-md-8 info-value">${user.firstName} ${user.lastName}</div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-md-4 info-label">Email</div>
                    <div class="col-md-8 info-value">${user.email}</div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-md-4 info-label">Số điện thoại</div>
                    <div class="col-md-8 info-value">${user.phone}</div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-md-4 info-label">Địa chỉ</div>
                    <div class="col-md-8 info-value">${user.address}</div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-md-4 info-label">Ngày sinh</div>
                    <div class="col-md-8 info-value">${user.dob}</div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-md-4 info-label">Giới tính</div>
                    <div class="col-md-8 info-value">${user.gender}</div>
                  </div>
                </div>
              </div>

              <div class="d-flex justify-content-between mb-4">
                <a href="/" class="btn btn-secondary">
                  <i class="bi bi-arrow-left"></i> Quay lại
                </a>
                <div>
                  <a href="/profile/edit" class="btn btn-primary me-2">
                    <i class="bi bi-pencil"></i> Chỉnh sửa thông tin
                  </a>
                  <button type="button" class="btn btn-change-password" data-bs-toggle="modal"
                    data-bs-target="#changePasswordModal">
                    <i class="bi bi-key"></i> Đổi mật khẩu
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Change Password Modal -->
        <div class="modal fade" id="changePasswordModal" tabindex="-1" aria-labelledby="changePasswordModalLabel"
          aria-hidden="true">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="changePasswordModalLabel">Đổi mật khẩu</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                  aria-label="Close"></button>
              </div>
              <div class="modal-body">
                <form id="changePasswordForm" action="/profile/change-password" method="POST">
                  <div class="mb-3">
                    <label for="currentPassword" class="form-label">Mật khẩu hiện tại</label>
                    <div class="input-group">
                      <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                      <button class="btn btn-outline-secondary toggle-password" type="button">
                        <i class="bi bi-eye"></i>
                      </button>
                    </div>
                  </div>
                  <div class="mb-3">
                    <label for="newPassword" class="form-label">Mật khẩu mới</label>
                    <div class="input-group">
                      <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                      <button class="btn btn-outline-secondary toggle-password" type="button">
                        <i class="bi bi-eye"></i>
                      </button>
                    </div>
                  </div>
                  <div class="mb-3">
                    <label for="confirmPassword" class="form-label">Xác nhận mật khẩu mới</label>
                    <div class="input-group">
                      <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                      <button class="btn btn-outline-secondary toggle-password" type="button">
                        <i class="bi bi-eye"></i>
                      </button>
                    </div>
                  </div>
                  <div class="modal-footer px-0 pb-0">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>

        <!-- Alert Messages -->
        <c:if test="${not empty error}">
          <div
            class="alert alert-danger alert-dismissible fade show position-fixed top-0 start-50 translate-middle-x mt-3"
            role="alert">
            ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
          </div>
        </c:if>
        <c:if test="${not empty success}">
          <div
            class="alert alert-success alert-dismissible fade show position-fixed top-0 start-50 translate-middle-x mt-3"
            role="alert">
            ${success}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
          </div>
        </c:if>

        <script>
          function previewImage(input) {
            if (input.files && input.files[0]) {
              const reader = new FileReader();
              reader.onload = function (e) {
                document.querySelector('.profile-avatar').src = e.target.result;
              }
              reader.readAsDataURL(input.files[0]);
            }
          }

          // Thêm sự kiện click cho avatar container
          document.querySelector('.avatar-container').addEventListener('click', function () {
            document.getElementById('avatarInput').click();
          });

          // Password visibility toggle
          document.querySelectorAll('.toggle-password').forEach(button => {
            button.addEventListener('click', function () {
              const input = this.previousElementSibling;
              const type = input.getAttribute('type') === 'password' ? 'text' : 'password';
              input.setAttribute('type', type);
              this.querySelector('i').classList.toggle('bi-eye');
              this.querySelector('i').classList.toggle('bi-eye-slash');
            });
          });

          // Auto hide alerts after 5 seconds
          document.querySelectorAll('.alert').forEach(alert => {
            setTimeout(() => {
              const bsAlert = new bootstrap.Alert(alert);
              bsAlert.close();
            }, 5000);
          });
        </script>
      </body>

      </html>