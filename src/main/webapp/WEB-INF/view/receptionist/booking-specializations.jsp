<%@page contentType="text/html" pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib
uri="http://www.springframework.org/tags/form" prefix="form" %> <%@ taglib
prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <%@ taglib
uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>email and specialization selection</title>

    <style>
      .card-grid {
        display: flex;
        flex-wrap: wrap;
        gap: 16px;
      }

      .card {
        display: block;
        width: 200px;
        padding: 16px;
        border: 1px solid #ccc;
        border-radius: 12px;
        text-align: center;
        cursor: pointer;
        transition: 0.2s;
      }

      input[type="radio"] {
        display: none;
      }

      input[type="radio"]:checked + label {
        border-color: #007bff;
        background-color: #e7f1ff;
      }

      label.card:hover {
        background-color: #f0f0f0;
      }
    </style>
  </head>
  <body>
    <form action="/booking-receptionist/step-1" method="post">
      <label>Email bệnh nhân:</label><br />
      <input type="email" name="email" value="${email}" required />

      <c:if test="${not empty error}">
        <p style="color: red">${error}</p>
      </c:if>

      <br /><br />

      <label>Chọn chuyên khoa:</label>
      <div class="card-grid">
        <c:forEach var="spec" items="${specializations}">
          <input
            type="radio"
            name="specializationId"
            id="spec-${spec.specializationID}"
            value="${spec.specializationID}"
            required
          />
          <label for="spec-${spec.specializationID}" class="card">
            <h4>${spec.specializationName}</h4>
            <p>${spec.description}</p>
          </label>
        </c:forEach>
      </div>

      <br />
      <button type="submit">Tiếp tục</button>
    </form>
  </body>
</html>
