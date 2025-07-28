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
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script
          src="${pageContext.request.contextPath}/resources/js/patient-stats.js?v=${System.currentTimeMillis()}"></script>
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

          /* CSS cho phần thống kê */
          .stats-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
            margin-bottom: 1.5rem;
          }

          .stats-card:hover {
            transform: translateY(-5px);
          }

          .stats-header {
            background: linear-gradient(135deg, #4b6cb7 0%, #182848 100%);
            color: white;
            border-radius: 15px 15px 0 0;
            padding: 1rem;
          }

          .stats-body {
            padding: 1.5rem;
          }

          .table-sm th {
            font-weight: 600;
            color: #495057;
            border-bottom: 2px solid #dee2e6;
          }

          .table-sm td {
            vertical-align: middle;
            color: #6c757d;
          }

          .badge {
            font-size: 0.8rem;
            padding: 0.4rem 0.6rem;
          }

          .stats-icon {
            font-size: 1.2rem;
            margin-right: 0.5rem;
          }

          .empty-state {
            color: #6c757d;
            font-style: italic;
          }

          .empty-state i {
            font-size: 3rem;
            opacity: 0.5;
          }

          /* CSS cho filter và chart */
          .filter-section {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            border: 1px solid #dee2e6;
            max-width: 900px;
            margin-left: auto;
            margin-right: auto;
          }

          .filter-controls-custom {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            align-items: flex-end;
            gap: 2rem;
            margin-bottom: 1rem;
          }

          .filter-group {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            min-width: 120px;
          }

          .filter-input {
            min-width: 120px;
            max-width: 160px;
          }

          @media (max-width: 700px) {
            .filter-section {
              padding: 1rem;
            }

            .filter-controls-custom {
              flex-direction: column;
              align-items: stretch;
              gap: 1rem;
            }

            .filter-group {
              width: 100%;
              min-width: unset;
              max-width: unset;
            }
          }

          .chart-container {
            position: relative;
            height: 300px;
            margin: 1rem 0;
          }

          .stats-summary {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            text-align: center;
          }

          .stats-summary h6 {
            margin-bottom: 0.5rem;
            font-weight: 600;
          }

          .stats-summary .number {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 0.25rem;
          }

          .stats-summary .label {
            font-size: 0.9rem;
            opacity: 0.9;
          }

          .btn-filter {
            background: linear-gradient(135deg, #3692eb 0%, #4b6cb7 100%);
            border: none;
            color: #fff;
            padding: 0.5rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            letter-spacing: 0.5px;
            box-shadow: 0 2px 8px rgba(54, 146, 235, 0.08);
            transition: all 0.2s;
          }

          .btn-filter:hover,
          .btn-filter:focus {
            background: linear-gradient(135deg, #4b6cb7 0%, #3692eb 100%);
            color: #fff;
            box-shadow: 0 4px 16px rgba(54, 146, 235, 0.18);
            transform: translateY(-2px) scale(1.04);
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
                    src="${pageContext.request.contextPath}${empty user.avatarUrl ? '/resources/images/defaultImg.jpg' : user.avatarUrl}"
                    alt="" class="profile-avatar">
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

              <!-- Thống kê cho bệnh nhân -->
              <c:if test="${user.role eq 'patient' and not empty patient}">
                <!-- Filter Section -->
                <div class="filter-section">
                  <h5 class="mb-3">
                    <i class="bi bi-funnel text-primary"></i>
                    Lọc thống kê
                  </h5>
                  <div class="filter-controls-custom">
                    <div class="filter-group">
                      <label for="yearFilter" class="form-label">Năm:</label>
                      <select id="yearFilter" class="form-select filter-input">
                        <c:forEach var="year" items="${availableYears}">
                          <option value="${year}" ${year==currentYear ? 'selected' : '' }>${year}</option>
                        </c:forEach>
                      </select>
                    </div>
                    <div class="filter-group">
                      <label for="monthFilter" class="form-label">Tháng:</label>
                      <select id="monthFilter" class="form-select filter-input">
                        <option value="0">Tất cả tháng</option>
                        <option value="1" ${currentMonth==1 ? 'selected' : '' }>Tháng 1</option>
                        <option value="2" ${currentMonth==2 ? 'selected' : '' }>Tháng 2</option>
                        <option value="3" ${currentMonth==3 ? 'selected' : '' }>Tháng 3</option>
                        <option value="4" ${currentMonth==4 ? 'selected' : '' }>Tháng 4</option>
                        <option value="5" ${currentMonth==5 ? 'selected' : '' }>Tháng 5</option>
                        <option value="6" ${currentMonth==6 ? 'selected' : '' }>Tháng 6</option>
                        <option value="7" ${currentMonth==7 ? 'selected' : '' }>Tháng 7</option>
                        <option value="8" ${currentMonth==8 ? 'selected' : '' }>Tháng 8</option>
                        <option value="9" ${currentMonth==9 ? 'selected' : '' }>Tháng 9</option>
                        <option value="10" ${currentMonth==10 ? 'selected' : '' }>Tháng 10</option>
                        <option value="11" ${currentMonth==11 ? 'selected' : '' }>Tháng 11</option>
                        <option value="12" ${currentMonth==12 ? 'selected' : '' }>Tháng 12</option>
                      </select>
                    </div>
                    <div class="filter-group">
                      <label for="chartMode" class="form-label">Kiểu biểu đồ:</label>
                      <select id="chartMode" class="form-select filter-input">
                        <option value="day">Theo ngày</option>
                        <option value="week">Theo tuần</option>
                      </select>
                    </div>
                    <div class="filter-group d-flex align-items-end">
                      <button type="button" class="btn btn-filter" onclick="filterStats()">
                        <i class="bi bi-search"></i> Lọc
                      </button>
                    </div>
                  </div>
                </div>

                <!-- Summary Cards -->
                <div class="row mb-4 justify-content-center" style="gap: 1rem;">
                  <div class="col-md-3 col-12">
                    <div class="stats-summary text-center">
                      <h6>Tổng số lần khám</h6>
                      <div class="number" id="totalAppointments">0</div>
                      <div class="label">trong <span id="summaryTime"></span></div>
                    </div>
                  </div>
                  <div class="col-md-3 col-12">
                    <div class="stats-summary text-center">
                      <h6>Chuyên khoa khám nhiều nhất</h6>
                      <div class="number" id="topSpecialization">-</div>
                      <div class="label">trong <span id="summaryTime2"></span></div>
                    </div>
                  </div>
                  <div class="col-md-3 col-12">
                    <div class="stats-summary text-center">
                      <h6>Tuần khám nhiều nhất trong tháng</h6>
                      <div class="number" id="topMonth">
                        <c:choose>
                          <c:when test="${not empty topWeek}">
                            Tuần ${topWeek} (<span style="color:#3692eb">${topWeekCount}</span> lần)
                          </c:when>
                          <c:otherwise>
                            -
                          </c:otherwise>
                        </c:choose>
                      </div>
                      <div class="label">
                        trong <span id="summaryTime3">
                          <c:if test="${not empty topWeekMonth && not empty topWeekYear}">
                            Tháng ${topWeekMonth}/${topWeekYear}
                          </c:if>
                        </span>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Chart Section -->
                <div class="row mb-4 justify-content-center">
                  <div class="col-12">
                    <div class="stats-card bg-white">
                      <div class="stats-header"
                        style="display: flex; align-items: center; justify-content: space-between;">
                        <h5 class="mb-0" style="display: flex; align-items: center;">
                          <i class="bi bi-graph-up stats-icon"></i>
                          Biểu đồ số lần khám theo <span id="chartTypeLabel">ngày</span>
                        </h5>
                        <div class="d-flex align-items-center gap-3">
                          <span style="display: flex; align-items: center;"><span
                              style="width: 18px; height: 18px; background: #28a745; display: inline-block; margin-right: 5px; border-radius: 3px;"></span>
                            Hoàn thành</span>
                          <span style="display: flex; align-items: center;"><span
                              style="width: 18px; height: 18px; background: #3692eb; display: inline-block; margin-right: 5px; border-radius: 3px;"></span>
                            Đặt lịch</span>
                          <span style="display: flex; align-items: center;"><span
                              style="width: 18px; height: 18px; background: #dc3545; display: inline-block; margin-right: 5px; border-radius: 3px;"></span>
                            Hủy</span>
                        </div>
                      </div>
                      <div class="stats-body">
                        <div class="chart-container">
                          <canvas id="appointmentChart"></canvas>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="row">
                  <!-- Thống kê theo tháng/năm -->
                  <div class="col-md-6 mb-4">
                    <div class="stats-card bg-white">
                      <div class="stats-header">
                        <h5 class="mb-0">
                          <i class="bi bi-calendar-check stats-icon"></i>
                          Số lần khám theo tháng cao nhất
                        </h5>
                      </div>
                      <div class="stats-body">
                        <div id="monthlyStatsTable">
                          <c:choose>
                            <c:when test="${not empty monthlyStats}">
                              <div class="table-responsive">
                                <table class="table table-sm">
                                  <thead>
                                    <tr>
                                      <th>Tháng/Năm</th>
                                      <th class="text-center">Số lần khám</th>
                                    </tr>
                                  </thead>
                                  <tbody>
                                    <c:forEach var="stat" items="${monthlyStats}">
                                      <tr>
                                        <td>
                                          <c:choose>
                                            <c:when test="${stat.month == 1}">Tháng 1</c:when>
                                            <c:when test="${stat.month == 2}">Tháng 2</c:when>
                                            <c:when test="${stat.month == 3}">Tháng 3</c:when>
                                            <c:when test="${stat.month == 4}">Tháng 4</c:when>
                                            <c:when test="${stat.month == 5}">Tháng 5</c:when>
                                            <c:when test="${stat.month == 6}">Tháng 6</c:when>
                                            <c:when test="${stat.month == 7}">Tháng 7</c:when>
                                            <c:when test="${stat.month == 8}">Tháng 8</c:when>
                                            <c:when test="${stat.month == 9}">Tháng 9</c:when>
                                            <c:when test="${stat.month == 10}">Tháng 10</c:when>
                                            <c:when test="${stat.month == 11}">Tháng 11</c:when>
                                            <c:when test="${stat.month == 12}">Tháng 12</c:when>
                                          </c:choose>
                                          / ${stat.year}
                                        </td>
                                        <td class="text-center">
                                          <span class="badge bg-primary">${stat.appointmentCount}</span>
                                        </td>
                                      </tr>
                                    </c:forEach>
                                  </tbody>
                                </table>
                              </div>
                            </c:when>
                            <c:otherwise>
                              <div class="text-center empty-state py-4">
                                <i class="bi bi-inbox"></i>
                                <p class="mt-2 mb-0">Chưa có dữ liệu khám bệnh</p>
                              </div>
                            </c:otherwise>
                          </c:choose>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- Thống kê theo chuyên khoa -->
                  <div class="col-md-6 mb-4">
                    <div class="stats-card bg-white">
                      <div class="stats-header">
                        <h5 class="mb-0">
                          <i class="bi bi-heart-pulse stats-icon"></i>
                          Số lần khám theo chuyên khoa
                        </h5>
                      </div>
                      <div class="stats-body">
                        <div id="specializationStatsTable">
                          <c:choose>
                            <c:when test="${not empty specializationStats}">
                              <div class="table-responsive">
                                <table class="table table-sm">
                                  <thead>
                                    <tr>
                                      <th>Chuyên khoa</th>
                                      <th class="text-center">Số lần khám</th>
                                    </tr>
                                  </thead>
                                  <tbody>
                                    <c:forEach var="stat" items="${specializationStats}">
                                      <tr>
                                        <td>${stat.specializationName}</td>
                                        <td class="text-center">
                                          <span class="badge bg-success">${stat.appointmentCount}</span>
                                        </td>
                                      </tr>
                                    </c:forEach>
                                  </tbody>
                                </table>
                              </div>
                            </c:when>
                            <c:otherwise>
                              <div class="text-center empty-state py-4">
                                <i class="bi bi-inbox"></i>
                                <p class="mt-2 mb-0">Chưa có dữ liệu khám bệnh</p>
                              </div>
                            </c:otherwise>
                          </c:choose>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </c:if>
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