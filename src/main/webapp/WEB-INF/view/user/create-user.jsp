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
    <title>Document</title>
  </head>

  <body>
    <div class="container mt-5">
      <div class="row">
        <div class="col-md-6 col-12 mx-auto">
          <h3>Create User</h3>
          <hr />
          <form:form
            method="post"
            action="/admin/create"
            modelAttribute="newUser"
          >
            <div class="mb-3">
              <label class="form-label">Email: </label>
              <form:input path="email" class="form-control" />
            </div>
            <div class="mb-3">
              <label class="form-label">Password: </label>
              <form:password path="password" class="form-control" />
            </div>
            <div class="mb-3">
              <label class="form-label">firstName: </label>
              <form:input path="firstName" class="form-control" />
            </div>
            <div class="mb-3">
              <label class="form-label">lastName: </label>
              <form:input path="lastName" class="form-control" />
            </div>
            <div class="mb-3">
              <label class="form-label">Address: </label>
              <form:input path="address" class="form-control" />
            </div>
            <div class="mb-3">
              <label class="form-label">Phone: </label>
              <form:input path="phone" class="form-control" />
            </div>
            <div class="mb-3">
              <label class="form-label">Role: </label>
              <form:select path="role" class="form-select">
                <form:option value="" label="-- Select role --" />
                <form:option value="admin" label="Admin" />
                <form:option value="patient" label="Patient" />
                <form:option value="doctor" label="Doctor" />
                <form:option value="receptionist" label="Receptionist" />
              </form:select>
            </div>
            <button type="submit" class="btn btn-primary">Submit</button>
          </form:form>
        </div>
      </div>
    </div>
  </body>
</html>
