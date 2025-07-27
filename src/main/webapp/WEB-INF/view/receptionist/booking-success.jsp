<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
      <title>Đặt lịch thành công</title>
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <style>
        body {
          font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
          background-color: #f0f4f8;
          margin: 0;
          padding: 0;
        }

        .container {
          max-width: 600px;
          margin: 80px auto;
          background-color: #ffffff;
          border-radius: 12px;
          padding: 40px;
          box-shadow: 0 8px 30px rgba(0, 0, 0, 0.05);
          text-align: center;
        }

        h2 {
          color: #28a745;
          font-size: 28px;
          margin-bottom: 20px;
        }

        p {
          font-size: 18px;
          color: #333;
          margin: 10px 0;
        }

        a {
          display: inline-block;
          margin-top: 30px;
          padding: 12px 24px;
          background-color: #007bff;
          color: #fff;
          text-decoration: none;
          border-radius: 8px;
          transition: background-color 0.3s ease;
        }

        a:hover {
          background-color: #0056b3;
        }

        .icon {
          font-size: 40px;
        }
      </style>
    </head>

    <body>
      <div class="container">
        <div class="icon">🎉</div>
        <h2>Đặt lịch thành công!</h2>
        <p>Cảm ơn bạn đã sử dụng dịch vụ.</p>
        <p>Hãy kiểm tra email của bạn để xem chi tiết lịch hẹn.</p>
        <c:choose>
          <c:when test="${role == 'admin'}">
            <a href="/admin">Quay về trang chính</a>
          </c:when>
          <c:otherwise>
            <a href="/receptionist">Quay về trang chính</a>
          </c:otherwise>
        </c:choose>
      </div>
    </body>

    </html>