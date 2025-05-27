<%@page contentType="text/html" pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib
uri="http://www.springframework.org/tags/form" prefix="form" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <!-- Latest compiled and minified CSS -->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
      rel="stylesheet"
    />
    <!-- Latest compiled JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <!-- <link rel="stylesheet" href="/css/demo.css"> -->
    <title>Document</title>
  </head>

  <body class="bg-light">
    <div class="container mt-5">
      <div class="row justify-content-center">
        <div class="col-md-4">
          <div class="card p-4 shadow rounded">
            <h3 class="text-center mb-3">Đăng nhập</h3>
            <form method="post" action="/login">
              <div class="mb-3">
                <label class="form-label">Email</label>
                <input
                  type="email"
                  class="form-control"
                  name="email"
                  required
                />
              </div>
              <div class="mb-3">
                <label class="form-label">Mật khẩu</label>
                <input
                  type="password"
                  class="form-control"
                  name="password"
                  required
                />
              </div>
              <button type="submit" class="btn btn-primary w-100">
                Đăng nhập
              </button>
            </form>

            <c:if test="${not empty error}">
              <div class="text-danger mt-2 text-center">${error}</div>
            </c:if>

            <hr />
            <div class="text-center">
              <span>Bạn chưa có tài khoản?</span>
              <a href="/register" class="btn btn-primary">Đăng ký</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>
