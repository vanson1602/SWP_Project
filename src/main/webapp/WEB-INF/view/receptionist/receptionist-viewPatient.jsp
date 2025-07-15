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
      body {
        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        background-color: #f5f7fa;
        padding: 20px;
      }

      h2 {
        text-align: center;
        color: #333;
      }

      .card-container {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
        gap: 20px;
        margin-top: 30px;
      }

      .card {
        background-color: white;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        padding: 20px;
        text-align: center;
        transition: transform 0.3s ease;
      }

      .card:hover {
        transform: translateY(-5px);
      }

      .card img {
        width: 100px;
        height: 100px;
        object-fit: cover;
        border-radius: 50%;
        margin-bottom: 15px;
      }

      .card h3 {
        margin: 10px 0 5px;
        font-size: 18px;
        color: #2c3e50;
      }

      .card p {
        margin: 5px 0;
        font-size: 14px;
        color: #555;
      }

      .back-button {
        display: inline-block;
        margin-top: 30px;
        text-decoration: none;
        color: #3498db;
        font-weight: bold;
      }
    </style>
  </head>
  <body>
    <h2>Danh sách bệnh nhân</h2>

    <div class="card-container">
      <c:forEach var="patient" items="${listPatient}">
        <div class="card">
          <h3>${patient.fullName}</h3>
          <p><strong>Email:</strong> ${patient.email}</p>
          <p><strong>Điện thoại:</strong> ${patient.phone}</p>
          <p><strong>Địa chỉ:</strong> ${patient.address}</p>
        </div>
      </c:forEach>
    </div>

    <div style="text-align: center">
      <a href="javascript:history.back()" class="back-button">← Quay lại</a>
    </div>
  </body>
</html>
