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
    <title>Detail-user ${userDetail.id}</title>
  </head>

  <body>
    <div class="container mt-5">
      <div class="row">
        <div class="col-12 mx-auto">
          <div class="d-flex justify-content-between">
            <h3>User Detail With ID = ${userDetail.id}</h3>
          </div>
          <hr />
          <div class="card" style="width: 60%">
            <div class="card-header">User information</div>
            <ul class="list-group list-group-flush">
              <li class="list-group-item">ID: ${userDetail.id}</li>
              <li class="list-group-item">Email: ${userDetail.email}</li>
              <li class="list-group-item">
                First Name: ${userDetail.firstName}
              </li>
              <li class="list-group-item">Address: ${userDetail.address}</li>
              <li class="list-group-item">Role: ${userDetail.role}</li>
            </ul>
          </div>
          <div><a class="btn btn-success mt-2" href="/admin/user">Back</a></div>
        </div>
      </div>
    </div>
  </body>
</html>
