<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
  <head>
    <title>Chi tiết Đơn thuốc</title>
    <style>
      table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
      }

      th,
      td {
        padding: 12px;
        border: 1px solid #ccc;
        text-align: left;
      }

      th {
        background-color: #f2f2f2;
      }

      h2 {
        margin-bottom: 16px;
      }

      .error-message {
        color: red;
        margin-top: 10px;
      }
    </style>
  </head>
  <body>
    <h2>Chi tiết Đơn thuốc</h2>

    <c:if test="${not empty errorMessage}">
      <p class="error-message">${errorMessage}</p>
    </c:if>

    <c:if test="${not empty prescriptions}">
      <table>
        <thead>
          <tr>
            <th>Tên thuốc</th>
            <th>Số lượng</th>
            <th>Liều lượng</th>
            <th>Thời gian sử dụng</th>
            <th>Hướng dẫn</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="p" items="${prescriptions}">
            <tr>
              <td>${p.medication.medicationName}</td>
              <td>${p.quantity}</td>
              <td>${p.dosage}</td>
              <td>${p.frequency}</td>
              <td>${p.instructions}</td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:if>
  </body>
</html>
