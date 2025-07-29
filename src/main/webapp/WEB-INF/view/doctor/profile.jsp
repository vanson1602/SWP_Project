<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
            <link rel="stylesheet"
                href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
            <title>Thông tin bác sĩ</title>
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
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                }

                .profile-card {
                    border: none;
                    border-radius: 15px;
                    box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
                    margin-bottom: 2rem;
                }

                .stats-card {
                    border: none;
                    border-radius: 15px;
                    box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
                    margin-bottom: 2rem;
                }

                .stats-header {
                    background: linear-gradient(135deg, #4b6cb7 0%, #182848 100%);
                    color: white;
                    border-radius: 15px 15px 0 0;
                    padding: 1rem;
                }

                .stats-summary {
                    background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                    color: white;
                    border-radius: 10px;
                    padding: 1rem;
                    text-align: center;
                }

                .stats-summary .number {
                    font-size: 2rem;
                    font-weight: bold;
                }

                .filter-section {
                    background: #f8f9fa;
                    border-radius: 15px;
                    padding: 1.5rem;
                    margin-bottom: 2rem;
                    border: 1px solid #dee2e6;
                }

                .chart-container {
                    position: relative;
                    height: 300px;
                    margin: 1rem 0;
                }
            </style>
        </head>

        <body class="bg-light">
            <div class="profile-header">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-md-3 text-center">
                            <img src="${pageContext.request.contextPath}${empty doctor.user.avatarUrl ? '/resources/images/defaultImg.jpg' : doctor.user.avatarUrl}"
                                alt="" class="profile-avatar">
                        </div>
                        <div class="col-md-9">
                            <h2 class="mb-2">${doctor.user.firstName} ${doctor.user.lastName}</h2>
                            <p class="mb-0"><i class="bi bi-envelope"></i> ${doctor.user.email}</p>
                            <p class="mb-0"><i class="bi bi-person-badge"></i> Bác sĩ</p>
                            <c:if test="${not empty doctor.specializations}">
                                <p class="mb-0"><i class="bi bi-heart-pulse"></i>
                                    <c:forEach var="spec" items="${doctor.specializations}" varStatus="status">
                                        ${spec.specializationName}<c:if test="${!status.last}">, </c:if>
                                    </c:forEach>
                                </p>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

            <div class="container">
                <div class="row">
                    <div class="col-md-8 mx-auto">
                        <!-- Thông tin cá nhân -->
                        <div class="profile-card bg-white">
                            <div class="card-body p-4">
                                <h4 class="mb-4">Thông tin chi tiết</h4>
                                <div class="row mb-3">
                                    <div class="col-md-4 text-muted">Họ và tên</div>
                                    <div class="col-md-8 fw-bold">${doctor.user.firstName} ${doctor.user.lastName}</div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-4 text-muted">Email</div>
                                    <div class="col-md-8 fw-bold">${doctor.user.email}</div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-4 text-muted">Số điện thoại</div>
                                    <div class="col-md-8 fw-bold">${doctor.user.phone}</div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-4 text-muted">Địa chỉ</div>
                                    <div class="col-md-8 fw-bold">${doctor.user.address}</div>
                                </div>
                                <c:if test="${not empty doctor.experienceYears}">
                                    <div class="row mb-3">
                                        <div class="col-md-4 text-muted">Số năm kinh nghiệm</div>
                                        <div class="col-md-8 fw-bold">${doctor.experienceYears} năm</div>
                                    </div>
                                </c:if>
                                <c:if test="${not empty doctor.consultationFee}">
                                    <div class="row mb-3">
                                        <div class="col-md-4 text-muted">Phí khám</div>
                                        <div class="col-md-8 fw-bold">${doctor.consultationFee} VNĐ</div>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <div class="text-end mt-3">
                            <button type="button" class="btn btn-warning" data-bs-toggle="modal"
                                data-bs-target="#changePasswordModal">
                                <i class="bi bi-key"></i> Đổi mật khẩu
                            </button>
                        </div>

                        <!-- Modal đổi mật khẩu -->
                        <div class="modal fade" id="changePasswordModal" tabindex="-1"
                            aria-labelledby="changePasswordModalLabel" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="changePasswordModalLabel">Đổi mật khẩu</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/doctor/profile/change-password"
                                        method="post">
                                        <div class="modal-body">
                                            <div class="mb-3">
                                                <label for="currentPassword" class="form-label">Mật khẩu hiện
                                                    tại</label>
                                                <input type="password" class="form-control" id="currentPassword"
                                                    name="currentPassword" required>
                                            </div>
                                            <div class="mb-3">
                                                <label for="newPassword" class="form-label">Mật khẩu mới</label>
                                                <input type="password" class="form-control" id="newPassword"
                                                    name="newPassword" required>
                                            </div>
                                            <div class="mb-3">
                                                <label for="confirmPassword" class="form-label">Xác nhận mật khẩu
                                                    mới</label>
                                                <input type="password" class="form-control" id="confirmPassword"
                                                    name="confirmPassword" required>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary"
                                                data-bs-dismiss="modal">Hủy</button>
                                            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Thống kê tổng quan -->
                        <div class="row mb-4 d-flex justify-content-center">
                            <div class="col-md-6">
                                <div class="stats-summary">
                                    <h6>Tổng số bệnh nhân đã khám</h6>
                                    <div class="number">${totalPatients}</div>
                                    <div class="label">trong năm ${currentYear}</div>
                                </div>
                            </div>
                        </div>

                        <!-- Filter Section -->
                        <div class="filter-section">
                            <h5 class="mb-3">
                                <i class="bi bi-funnel text-primary"></i>
                                Lọc thống kê
                            </h5>
                            <div class="row g-3 align-items-end">
                                <div class="col-md-3">
                                    <label for="doctorYearFilter" class="form-label">Năm:</label>
                                    <select id="doctorYearFilter" class="form-select"></select>
                                </div>
                                <div class="col-md-3">
                                    <label for="doctorMonthFilter" class="form-label">Tháng:</label>
                                    <select id="doctorMonthFilter" class="form-select">
                                        <option value="0">Tất cả tháng</option>
                                        <c:forEach var="i" begin="1" end="12">
                                            <option value="${i}" ${i==currentMonth ? 'selected' : '' }>Tháng ${i}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label for="doctorChartMode" class="form-label">Kiểu biểu đồ:</label>
                                    <select id="doctorChartMode" class="form-select">
                                        <option value="day">Theo ngày</option>
                                        <option value="week">Theo tuần</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <button class="btn btn-primary w-100" onclick="filterDoctorStats()">
                                        <i class="bi bi-search"></i> Lọc
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Chart Section -->
                        <div class="stats-card bg-white">
                            <div class="stats-header">
                                <h5 class="mb-0">
                                    <i class="bi bi-graph-up"></i>
                                    Biểu đồ số bệnh nhân đã khám
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="chart-container">
                                    <canvas id="doctorPatientChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script
                src="${pageContext.request.contextPath}/resources/js/doctor-patient-stats.js?v=${System.currentTimeMillis()}"></script>
        </body>

        </html>