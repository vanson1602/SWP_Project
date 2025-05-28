<%@page contentType="text/html" pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="form"
uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
      rel="stylesheet"
    />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <title>Register</title>
  </head>
  <body>
    <section class="vh-100 bg-light">
      <div class="container py-5 h-100">
        <div class="row justify-content-center align-items-center h-100">
          <div class="col-12 col-lg-9 col-xl-7">
            <div
              class="card shadow card-registration"
              style="border-radius: 15px"
            >
              <div class="card-body p-4 p-md-5">
                <h3 class="mb-4 text-center">Register Form</h3>

                <form:form
                  method="post"
                  modelAttribute="user"
                  action="/register"
                >
                  <!-- Username & Password -->
                  <div class="row">
                    <div class="col-md-6 mb-4">
                      <label class="form-label">Username</label>
                      <form:input
                        path="username"
                        cssClass="form-control form-control-lg"
                      />
                    </div>
                    <div class="col-md-6 mb-4">
                      <label class="form-label">Password</label>
                      <form:password
                        path="password"
                        cssClass="form-control form-control-lg"
                      />
                    </div>
                  </div>

                  <!-- First & Last Name -->
                  <div class="row">
                    <div class="col-md-6 mb-4">
                      <label class="form-label">First Name</label>
                      <form:input
                        path="firstName"
                        cssClass="form-control form-control-lg"
                      />
                    </div>
                    <div class="col-md-6 mb-4">
                      <label class="form-label">Last Name</label>
                      <form:input
                        path="lastName"
                        cssClass="form-control form-control-lg"
                      />
                    </div>
                  </div>

                  <!-- DOB & Gender -->
                  <div class="row">
                    <div class="col-md-6 mb-4">
                      <label class="form-label">Birthday</label>
                      <form:input
                        path="dob"
                        type="date"
                        cssClass="form-control form-control-lg"
                      />
                    </div>
                    <div class="col-md-6 mb-4">
                      <label class="form-label d-block mb-2">Gender</label>
                      <div class="form-check form-check-inline">
                        <form:radiobutton
                          path="gender"
                          value="female"
                          cssClass="form-check-input"
                        />
                        <label class="form-check-label">Female</label>
                      </div>
                      <div class="form-check form-check-inline">
                        <form:radiobutton
                          path="gender"
                          value="male"
                          cssClass="form-check-input"
                        />
                        <label class="form-check-label">Male</label>
                      </div>
                      <div class="form-check form-check-inline">
                        <form:radiobutton
                          path="gender"
                          value="other"
                          cssClass="form-check-input"
                        />
                        <label class="form-check-label">Other</label>
                      </div>
                    </div>
                  </div>

                  <!-- Email & Phone -->
                  <div class="row">
                    <div class="col-md-6 mb-4">
                      <label class="form-label">Email</label>
                      <form:input
                        path="email"
                        type="email"
                        cssClass="form-control form-control-lg"
                      />
                    </div>
                    <div class="col-md-6 mb-4">
                      <label class="form-label">Phone</label>
                      <form:input
                        path="phone"
                        type="text"
                        cssClass="form-control form-control-lg"
                      />
                    </div>
                  </div>

                  <!-- Address -->
                  <div class="mb-4">
                    <label class="form-label">Address</label>
                    <form:input
                      path="address"
                      cssClass="form-control form-control-lg"
                    />
                  </div>
                  <!-- Submit Button -->
                  <div class="mt-4 pt-2 text-center">
                    <input
                      class="btn btn-primary btn-lg"
                      type="submit"
                      value="Register"
                    />
                  </div>
                </form:form>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </body>
</html>
