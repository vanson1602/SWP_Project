<%@page contentType="text/html" pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib
uri="http://www.springframework.org/tags/form" prefix="form" %> <%@ taglib
prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>doctor selection</title>

    <style>
      .card-grid {
        display: flex;
        flex-wrap: wrap;
        gap: 16px;
      }
      .card {
        display: block;
        width: 220px;
        padding: 16px;
        border: 1px solid #ccc;
        border-radius: 12px;
        text-align: center;
        cursor: pointer;
      }
      input[type="radio"] {
        display: none;
      }
      input[type="radio"]:checked + label {
        border-color: #007bff;
        background-color: #e7f1ff;
      }
    </style>
  </head>
  <body>
    <form action="/booking-receptionist/step-2" method="post">
      <input type="hidden" name="email" value="${email}" />
      <input
        type="hidden"
        name="specializationId"
        value="${selectedSpecializationId}"
      />

      <label>Chọn bác sĩ:</label>
      <div class="card-grid">
        <c:forEach var="doctor" items="${doctors}">
          <input
            type="radio"
            name="doctorId"
            id="doctor-${doctor.doctorID}"
            value="${doctor.doctorID}"
            required
          />
          <label for="doctor-${doctor.doctorID}" class="card">
            <h4>${doctor.user.fullName}</h4>
            <p>${doctor.qualification}</p>
            <p>Phí khám: ${doctor.consultationFee} đ</p>
          </label>
        </c:forEach>
      </div>
      <br />
      <button type="submit">Tiếp tục</button>
    </form>
  </body>
</html>
