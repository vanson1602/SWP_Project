<%@page contentType="text/html" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
      <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
        <%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
          <!DOCTYPE html>
          <html lang="en">

          <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Email và chọn chuyên khoa</title>

            <style>
              body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #eef2f7;
                margin: 0;
                padding: 20px;
              }

              form {
                max-width: 900px;
                margin: 0 auto;
                background-color: #ffffff;
                padding: 40px;
                border-radius: 16px;
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
              }

              label {
                font-weight: 600;
                display: block;
                margin-bottom: 10px;
                font-size: 17px;
                color: #333;
              }

              input[type="email"] {
                width: 100%;
                padding: 12px 16px;
                font-size: 16px;
                border: 1px solid #ccc;
                border-radius: 10px;
                margin-bottom: 24px;
                box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.05);
              }

              .card-grid {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 20px;
                margin-top: 10px;
              }

              .card {
                background-color: #f9fafc;
                padding: 20px;
                border: 2px solid #dbe2ea;
                border-radius: 12px;
                text-align: center;
                cursor: pointer;
                transition: all 0.3s ease;
                height: 100%;
                position: relative;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
              }

              .card h4 {
                margin: 10px 0 6px;
                color: #007bff;
                font-size: 18px;
              }

              .card p {
                font-size: 14px;
                color: #555;
              }

              input[type="radio"] {
                display: none;
              }

              input[type="radio"]:checked+label.card {
                border-color: #007bff;
                background-color: #e6f0ff;
                box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.2);
              }

              input[type="radio"]:checked+label.card::after {
                content: "✔";
                position: absolute;
                top: 12px;
                right: 16px;
                background-color: #007bff;
                color: #fff;
                font-size: 14px;
                padding: 4px 6px;
                border-radius: 50%;
              }

              label.card:hover {
                background-color: #f1f5f9;
                transform: translateY(-2px);
                box-shadow: 0 6px 15px rgba(0, 0, 0, 0.04);
              }

              .error-msg {
                color: red;
                font-size: 15px;
                margin-bottom: 16px;
              }

              button[type="submit"] {
                display: block;
                width: 100%;
                background-color: #007bff;
                color: white;
                padding: 14px;
                font-size: 17px;
                border: none;
                border-radius: 10px;
                cursor: pointer;
                transition: background-color 0.3s ease, transform 0.2s ease;
                margin-top: 30px;
              }

              button[type="submit"]:hover {
                background-color: #0056b3;
                transform: translateY(-1px);
              }

              @media (max-width: 768px) {
                .card-grid {
                  grid-template-columns: repeat(2, 1fr);
                }
              }

              @media (max-width: 480px) {
                .card-grid {
                  grid-template-columns: 1fr;
                }
              }
            </style>
          </head>

          <body>
            <form action="/booking-receptionist/step-1" method="post">
              <label>Email bệnh nhân:</label>
              <input type="email" name="email" value="${email}" required />

              <c:if test="${not empty error}">
                <p class="error-msg">${error}</p>
              </c:if>

              <label>Chọn chuyên khoa:</label>
              <div class="card-grid">
                <c:forEach var="spec" items="${specializations}">
                  <input type="radio" name="specializationId" id="spec-${spec.specializationID}"
                    value="${spec.specializationID}" required />
                  <label for="spec-${spec.specializationID}" class="card">
                    <h4>${spec.specializationName}</h4>
                    <p>${spec.description}</p>
                  </label>
                </c:forEach>
              </div>

              <button type="submit">Tiếp tục</button>
            </form>
          </body>

          </html>