<%@page contentType="text/html" pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib
uri="http://www.springframework.org/tags/form" prefix="form" %>

<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <title>Edit User</title>
  </head>

  <body>
    <div class="container mt-5">
      <h2 class="mb-4">Thông tin cá nhân</h2>

      <table class="table table-bordered">
        <tr>
          <th>ID</th>
          <td>${user.id}</td>
        </tr>
        <tr>
          <th>Tên</th>
          <td>${user.firstName}</td>
        </tr>
        <tr>
          <th>Email</th>
          <td>${user.email}</td>
        </tr>
        <tr>
          <th>Số điện thoại</th>
          <td>${user.phone}</td>
        </tr>
        <tr>
          <th>Vai trò</th>
          <td>${user.role}</td>
        </tr>
      </table>
      <a href="/" class="btn btn-success">Back</a>
      <a href="/profile/edit" class="btn btn-secondary">Edit Profile</a>
    </div>
  </body>
</html>
