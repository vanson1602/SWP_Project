<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
  <head>
    <title>Chi tiết Đơn thuốc</title>
    <style>
      body {
        font-family: "Segoe UI", Tahoma, sans-serif;
        background: #f4f8fb;
        padding: 30px;
        color: #2d3436;
      }

      h2 {
        color: #0984e3;
        text-align: center;
        margin-bottom: 30px;
        font-size: 28px;
      }

      .error-message {
        color: #d63031;
        background: #ffeaea;
        border: 1px solid #fab1a0;
        padding: 12px 20px;
        border-radius: 10px;
        max-width: 600px;
        margin: 10px auto;
        text-align: center;
        font-weight: bold;
      }

      table {
        width: 100%;
        border-collapse: collapse;
        background: #ffffff;
        border-radius: 12px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        overflow: hidden;
      }

      th {
        background-color: #0984e3;
        color: #fff;
        padding: 14px;
        text-align: left;
        font-weight: 600;
      }

      td {
        padding: 14px;
        border-bottom: 1px solid #ecf0f1;
      }

      tbody tr:nth-child(even) {
        background-color: #f1f9ff;
      }

      tbody tr:hover {
        background-color: #dff0ff;
        transition: 0.3s;
      }

      .back-button {
        display: inline-block;
        margin-top: 25px;
        background-color: #0984e3;
        color: white;
        padding: 10px 18px;
        border-radius: 8px;
        text-decoration: none;
        font-weight: 600;
        transition: background 0.3s;
      }

      .back-button:hover {
        background-color: #0652dd;
      }

      @media (max-width: 768px) {
        table,
        thead,
        tbody,
        th,
        td,
        tr {
          display: block;
        }

        th {
          display: none;
        }

        td {
          position: relative;
          padding-left: 50%;
          border-bottom: 1px solid #ccc;
        }

        td::before {
          position: absolute;
          top: 14px;
          left: 14px;
          width: 45%;
          padding-right: 10px;
          white-space: nowrap;
          font-weight: bold;
          color: #3498db;
          content: attr(data-label);
        }
      }
    </style>
  </head>
  <body>
    <h2>Chi tiết Đơn thuốc Của Bạn</h2>

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
              <td data-label="Tên thuốc">${p.medication.medicationName}</td>
              <td data-label="Số lượng">${p.quantity}</td>
              <td data-label="Liều lượng">${p.dosage}</td>
              <td data-label="Thời gian sử dụng">${p.frequency}</td>
              <td data-label="Hướng dẫn">${p.instructions}</td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:if>

    <div style="text-align: center">
      <a href="javascript:history.back()" class="back-button">← Quay lại</a>
    </div>
  </body>
</html>
