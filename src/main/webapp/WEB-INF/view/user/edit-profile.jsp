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
    <h2>Cập nhật thông tin cá nhân</h2>

    <form:form method="POST" modelAttribute="user" action="/profile/update">
      <div class="mb-3">
        <label>ID</label>
        <form:input path="id" cssClass="form-control" readonly="true" />
      </div>
      <div class="mb-3">
        <label>Name</label>
        <form:input path="firstName" cssClass="form-control" />
      </div>
      <div class="mb-3">
        <label>Email</label>
        <form:input path="email" cssClass="form-control" readonly="true" />
      </div>
      <div class="mb-3">
        <label>phone</label>
        <form:input path="phone" cssClass="form-control" />
      </div>
      <div class="mb-3">
        <label>Address</label>
        <form:input path="address" cssClass="form-control" />
      </div>

      <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
      <a href="/profile" class="btn btn-secondary">Hủy</a>
    </form:form>
  </body>
</html>
