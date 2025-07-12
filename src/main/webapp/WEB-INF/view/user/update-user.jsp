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
        <title>Edit User</title>
      </head>

  <body>
    <div class="container mt-5">
      <div class="row">
        <div class="col-12 mx-auto">
          <div class="d-flex justify-content-between">
            <h3>Edit User With ID = ${user.id}</h3>
          </div>
          <hr />
          <div class="card" style="width: 60%">
            <div class="card-header">User information</div>
            <div class="card-body">
              <form:form
                modelAttribute="user"
                method="post"
                action="/admin/update"
              >
                <form:hidden path="id" />

                    <div class="mb-3">
                      <label class="form-label">Email</label>
                      <form:input path="email" cssClass="form-control" />
                    </div>

                    <div class="mb-3">
                      <label class="form-label">First Name</label>
                      <form:input path="firstName" cssClass="form-control" />
                    </div>

                    <div class="mb-3">
                      <label class="form-label">Address</label>
                      <form:input path="address" cssClass="form-control" />
                    </div>

                    <div class="mb-3">
                      <label class="form-label">Role</label>
                      <form:input path="role" cssClass="form-control" />
                    </div>

                <div class="d-flex justify-content-between">
                  <a
                    href="${pageContext.request.contextPath}/admin/user"
                    class="btn btn-secondary"
                    >Cancel</a
                  >
                  <button type="submit" class="btn btn-primary">Update</button>
                </div>
              </form:form>
            </div>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>
