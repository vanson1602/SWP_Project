<%@page contentType="text/html" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

      <!DOCTYPE html>
      <html lang="vi">

      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <title>Document</title>
      </head>

      <body>
        <div class="container mt-5">
          <div class="row">
            <div class="col-md-7 col-lg-6 col-12 mx-auto">
              <div class="card shadow-lg border-0 rounded-4 p-4">
                <h3 class="mb-3 text-center text-primary"><i class="bi bi-person-plus me-2"></i>Create User</h3>
                <hr />
                <form:form method="post" action="/api/admin/create" modelAttribute="newUser">
                <form:form method="post" action="/admin/createUser" modelAttribute="newUser"
                  enctype="multipart/form-data">
                  <div class="mb-3">
                    <label class="form-label">Username</label>
                    <div class="input-group">
                      <span class="input-group-text"><i class="bi bi-person"></i></span>
                      <form:input path="username" class="form-control" placeholder="Enter username" required="true" />
                      <form:errors path="username" cssClass="text-danger" />
                    </div>
                  </div>
                  <div class="mb-3">
                    <label class="form-label">Email</label>
                    <div class="input-group">
                      <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                      <form:input path="email" class="form-control" placeholder="Enter email" required="true" />
                      <form:errors path="email" cssClass="text-danger" />
                    </div>
                  </div>
                  <div class="mb-3">
                    <label class="form-label">Password</label>
                    <div class="input-group">
                      <span class="input-group-text"><i class="bi bi-lock"></i></span>
                      <form:password path="password" class="form-control" placeholder="Enter password"
                        required="true" />
                      <form:errors path="password" cssClass="text-danger" />
                    </div>
                  </div>
                  <div class="row">
                    <div class="col-md-6 mb-3">
                      <label class="form-label">First Name</label>
                      <form:input path="firstName" class="form-control" placeholder="Enter first name" />
                    </div>
                    <div class="col-md-6 mb-3">
                      <label class="form-label">Last Name</label>
                      <form:input path="lastName" class="form-control" placeholder="Enter last name" />
                    </div>
                  </div>
                  <div class="mb-3">
                    <label class="form-label">Gender</label>
                    <form:select path="gender" class="form-select">
                      <form:option value="" label="Select gender" />
                      <form:option value="Male" label="Male" />
                      <form:option value="Female" label="Female" />
                      <form:option value="Another" label="Another" />
                    </form:select>
                  </div>
                  <div class="mb-3">
                    <label class="form-label">Date of Birth</label>
                    <form:input path="dob" class="form-control" type="date" placeholder="Select date of birth" />
                  </div>
                  <div class="mb-3">
                    <label class="form-label">Address</label>
                    <div class="input-group">
                      <span class="input-group-text"><i class="bi bi-geo-alt"></i></span>
                      <form:input path="address" class="form-control" placeholder="Enter address" />
                    </div>
                  </div>
                  <div class="mb-3">
                    <label class="form-label">Phone</label>
                    <div class="input-group">
                      <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                      <form:input path="phone" class="form-control" placeholder="Enter phone number" />
                    </div>
                  </div>
                  <div class="mb-3">
                    <label class="form-label">Role</label>
                    <form:select path="role" class="form-select" required="true">
                      <form:errors path="role" cssClass="text-danger" />
                      <form:option value="" label="-- Select role --" />
                      <form:option value="admin" label="Admin" />
                      <form:option value="patient" label="Patient" />
                      <form:option value="doctor" label="Doctor" />
                      <form:option value="receptionist" label="Receptionist" />
                    </form:select>
                  </div>
                  <div class="mb-3">
                    <label class="form-label">Image</label>
                    <input type="file" name="image" class="form-control" accept="image/*" />
                  </div>

                  <div class="d-flex justify-content-end gap-2 mt-3">
                    <button type="submit" class="btn btn-primary px-4">
                      <i class="bi bi-check-circle me-2"></i>Submit
                    </button>
                  </div>
                </form:form>
              </div>
            </div>
          </div>
        </div>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
      </body>

      </html>