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
            <title>Chỉnh sửa thông tin bác sĩ</title>
            <style>
                .profile-edit-container {
                    max-width: 600px;
                    margin: 40px auto;
                    background: #fff;
                    border-radius: 15px;
                    box-shadow: 0 0 20px rgba(0, 0, 0, 0.08);
                    padding: 2rem 2.5rem;
                }

                .avatar-preview {
                    width: 120px;
                    height: 120px;
                    border-radius: 50%;
                    object-fit: cover;
                    border: 3px solid #4b6cb7;
                    margin-bottom: 1rem;
                }

                .form-label {
                    font-weight: 500;
                }

                .btn-save {
                    background: linear-gradient(135deg, #4b6cb7 0%, #182848 100%);
                    color: #fff;
                    border: none;
                }

                .btn-save:hover {
                    background: linear-gradient(135deg, #182848 0%, #4b6cb7 100%);
                }
            </style>
        </head>

        <body class="bg-light">
            <div class="profile-edit-container">
                <h3 class="mb-4 text-center">Chỉnh sửa thông tin bác sĩ</h3>
                <form action="${pageContext.request.contextPath}/doctor/profile/update" method="post"
                    enctype="multipart/form-data">
                    <div class="text-center mb-3">
                        <img id="avatarPreview" class="avatar-preview"
                            src="${pageContext.request.contextPath}${empty doctor.user.avatarUrl ? '/resources/images/defaultImg.jpg' : doctor.user.avatarUrl}"
                            alt="Avatar">
                        <div class="mt-2">
                            <input type="file" name="avatarFile" id="avatarFile" accept="image/*" class="form-control"
                                style="display:inline-block; width:auto;">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Họ và tên</label>
                        <input type="text" class="form-control" name="user.firstName" value="${doctor.user.firstName}"
                            required placeholder="Họ">
                        <input type="text" class="form-control mt-2" name="user.lastName"
                            value="${doctor.user.lastName}" required placeholder="Tên">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control" name="user.email" value="${doctor.user.email}"
                            required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Số điện thoại</label>
                        <input type="text" class="form-control" name="user.phone" value="${doctor.user.phone}">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Địa chỉ</label>
                        <input type="text" class="form-control" name="user.address" value="${doctor.user.address}">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Ngày sinh</label>
                        <input type="date" class="form-control" name="user.dob" value="${doctor.user.dob}">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Giới tính</label>
                        <select class="form-select" name="user.gender">
                            <option value="Nam" ${doctor.user.gender=='Nam' ? 'selected' : '' }>Nam</option>
                            <option value="Nữ" ${doctor.user.gender=='Nữ' ? 'selected' : '' }>Nữ</option>
                            <option value="Khác" ${doctor.user.gender=='Khác' ? 'selected' : '' }>Khác</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Số năm kinh nghiệm</label>
                        <input type="number" class="form-control" name="experienceYears"
                            value="${doctor.experienceYears}" min="0">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Phí khám</label>
                        <input type="number" class="form-control" name="consultationFee"
                            value="${doctor.consultationFee}" min="0" step="0.01">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Chuyên khoa</label>
                        <input type="text" class="form-control"
                            value="<c:forEach var='spec' items='${doctor.specializations}' varStatus='status'>${spec.specializationName}<c:if test='${!status.last}'>, </c:if></c:forEach>"
                            readonly>
                    </div>
                    <div class="text-center mt-4">
                        <button type="submit" class="btn btn-save px-4">Lưu thay đổi</button>
                        <a href="${pageContext.request.contextPath}/doctor/profile"
                            class="btn btn-secondary ms-2">Hủy</a>
                    </div>
                </form>
            </div>
            <script>
                document.getElementById('avatarFile').addEventListener('change', function (e) {
                    if (e.target.files && e.target.files[0]) {
                        const reader = new FileReader();
                        reader.onload = function (ev) {
                            document.getElementById('avatarPreview').src = ev.target.result;
                        }
                        reader.readAsDataURL(e.target.files[0]);
                    }
                });
            </script>
        </body>

        </html>