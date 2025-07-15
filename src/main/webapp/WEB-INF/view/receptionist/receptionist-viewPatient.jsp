<%@page contentType="text/html" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
      <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
          <meta charset="UTF-8" />
          <meta name="viewport" content="width=device-width, initial-scale=1.0" />
          <title>Danh sách bệnh nhân</title>
          <style>
            body {
              font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
              background-color: #f5f7fa;
              margin: 0;
              padding: 20px;
            }

            h2 {
              text-align: center;
              color: #2c3e50;
              margin-bottom: 30px;
            }

            table {
              width: 100%;
              border-collapse: collapse;
              background-color: #fff;
              border-radius: 12px;
              overflow: hidden;
              box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            }

            th,
            td {
              padding: 16px 20px;
              text-align: left;
              border-bottom: 1px solid #e0e0e0;
            }

            th {
              background-color: #007bff;
              color: white;
              font-weight: 600;
            }

            tr:hover {
              background-color: #f1f9ff;
            }

            td {
              color: #333;
            }

            .back-button {
              display: inline-block;
              margin-top: 30px;
              padding: 10px 20px;
              background-color: #007bff;
              color: white;
              text-decoration: none;
              border-radius: 6px;
              transition: background-color 0.3s ease;
            }

            .back-button:hover {
              background-color: #0056b3;
            }

            .table-container {
              max-width: 1000px;
              margin: 0 auto;
              overflow-x: auto;
            }
          </style>
        </head>

        <body>
          <h2>Danh sách bệnh nhân</h2>

          <div class="table-container">
            <table>
              <thead>
                <tr>
                  <th>Họ và tên</th>
                  <th>Email</th>
                  <th>Điện thoại</th>
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
          </div>

          <div style="text-align: center">
            <a href="javascript:history.back()" class="back-button">← Quay lại</a>
          </div>
        </body>

        </html>