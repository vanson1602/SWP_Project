<%@page contentType="text/html" pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib
uri="http://www.springframework.org/tags/form" prefix="form" %> <%@ taglib
prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Thông tin bệnh nhân</title>
    <style>
      table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
      }

      th,
      td {
        border: 1px solid #ccc;
        padding: 8px;
        text-align: left;
      }

      th {
        background-color: #f2f2f2;
      }

      .back-button {
        margin-top: 20px;
        display: inline-block;
      }
    </style>
  </head>
  <body>
    <h2>Danh sách bệnh nhân</h2>

    <table>
      <thead>
        <tr>
          <th>Họ tên</th>
          <th>Email</th>
          <th>Số điện thoại</th>
          <th>Địa chỉ</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="patient" items="${listPatient}">
          <tr>
            <td>${patient.fullName}</td>
            <td>${patient.email}</td>
            <td>${patient.phone}</td>
            <td>${patient.address}</td>
          </tr>
        </c:forEach>
      </tbody>
    </table>

    <a href="javascript:history.back()" class="back-button">← Quay lại</a>
  </body>
</html>
