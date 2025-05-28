<%@page contentType="text/html" pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib
uri="http://www.springframework.org/tags/form" prefix="form" %>

<!DOCTYPE html>
<html lang="vi">
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
    <!-- Dòng ngang: Ảnh - Navbar - Link Login/User -->
    <div class="container-fluid py-3">
      <div class="d-flex justify-content-between align-items-center">
        <!-- 1. Ảnh -->
        <div>
          <img src="<c:url value='/resources/images/TECH.png' />" alt="Logo" />
        </div>

        <!-- 2. Navbar ở giữa -->
        <nav class="flex-grow-1">
          <ul class="nav justify-content-center">
            <li class="nav-item">
              <a class="nav-link active text-primary" href="/">Home</a>
            </li>
            <li class="nav-item">
              <a class="nav-link text-secondary" href="#">Features</a>
            </li>
            <li class="nav-item">
              <a class="nav-link text-secondary" href="#">About</a>
            </li>
          </ul>
        </nav>

        <!-- 3. Login hoặc User dropdown -->
        <div class="ms-4">
          <c:choose>
            <c:when test="${not empty sessionScope.currentUser}">
              <div class="dropdown">
                <button class="btn btn-outline-primary dropdown-toggle btn-sm" type="button" data-bs-toggle="dropdown">
                  ${sessionScope.currentUser.firstName}
                </button>
                <ul class="dropdown-menu dropdown-menu-end">
                  <li><a class="dropdown-item" href="/profile">Trang cá nhân</a></li>
                  <li><hr class="dropdown-divider"></li>
                  <li><a class="dropdown-item" href="/logout">Đăng xuất</a></li>
                </ul>
              </div>
            </c:when>
            <c:otherwise>
              <a href="/login" class="btn btn-sm btn-outline-primary">Đăng nhập</a>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>
  </body>
</html>
