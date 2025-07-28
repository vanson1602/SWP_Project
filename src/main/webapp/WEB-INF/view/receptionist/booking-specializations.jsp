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
                font-family: "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
                background-color: #f0f4f8;
                margin: 0;
                padding: 30px;
              }

              form {
                max-width: 900px;
                margin: auto;
                background-color: #ffffff;
                padding: 40px;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.06);
                transition: all 0.3s ease;
              }

              label {
                font-weight: 600;
                font-size: 18px;
                display: block;
                margin-bottom: 16px;
                color: #2d3e50;
              }

              input[type="email"] {
                width: 100%;
                padding: 14px 18px;
                font-size: 16px;
                border: 1.5px solid #ccc;
                border-radius: 12px;
                margin-bottom: 28px;
                transition: border 0.3s ease;
              }

              input[type="email"]:focus {
                border-color: #007bff;
                outline: none;
                box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.15);
              }

              .card-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
                gap: 24px;
                margin-top: 10px;
              }

              .card {
                background-color: #f8fafc;
                border: 2px solid transparent;
                padding: 0;
                border-radius: 16px;
                text-align: center;
                cursor: pointer;
                transition: all 0.3s ease;
                position: relative;
                box-shadow: 0 4px 14px rgba(0, 0, 0, 0.03);
                overflow: hidden;
                height: 100%;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
              }

              .card img {
                width: 100%;
                height: 160px;
                object-fit: cover;
                display: block;
                transition: transform 0.3s ease;
              }

              .card:hover img {
                transform: scale(1.02);
              }

              .card-content {
                padding: 16px 16px 20px;
                flex-grow: 1;
              }

              .card h4 {
                font-size: 18px;
                color: #007bff;
                margin-bottom: 8px;
                font-weight: 600;
              }

              .card p {
                font-size: 14px;
                color: #555;
                line-height: 1.5;
              }

              input[type="radio"] {
                display: none;
              }

              input[type="radio"]:checked+label.card {
                border-color: #007bff;
                background-color: #e9f3ff;
                box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.2);
                transform: scale(1.01);
              }

              input[type="radio"]:checked+label.card::after {
                content: "✔";
                position: absolute;
                top: 12px;
                right: 16px;
                background-color: #007bff;
                color: #fff;
                font-size: 14px;
                padding: 5px 7px;
                border-radius: 50%;
              }

              label.card:hover {
                background-color: #f1f5f9;
                box-shadow: 0 6px 18px rgba(0, 0, 0, 0.05);
                transform: translateY(-2px);
              }

              .error-msg {
                color: #d9534f;
                font-size: 15px;
                margin-bottom: 20px;
              }

              .action-buttons {
                display: flex;
                justify-content: center;
                gap: 20px;
                margin-top: 40px;
              }

              .back-button,
              .continue-button {
                padding: 12px 24px;
                font-size: 15px;
                font-weight: 500;
                border-radius: 8px;
                border: none;
                text-decoration: none;
                cursor: pointer;
                transition: background-color 0.3s ease, transform 0.2s ease;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
              }

              .back-button {
                background-color: #f1f5f9;
                color: #334155;
                border: 1px solid #cbd5e1;
              }

              .back-button:hover {
                background-color: #e2e8f0;
              }

              .continue-button {
                background-color: #3b82f6;
                color: white;
              }

              .continue-button:hover {
                background-color: #2563eb;
                transform: translateY(-1px);
              }

              @media (max-width: 768px) {
                form {
                  padding: 30px 24px;
                }

                button[type="submit"] {
                  font-size: 16px;
                }

                .card img {
                  height: 140px;
                }
              }

              @media (max-width: 480px) {
                .card-grid {
                  grid-template-columns: 1fr;
                }

                .card img {
                  height: 120px;
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
                    <img src="/resources/images/specialties/${spec.specializationID}.png"
                      alt="${spec.specializationName}">
                    <div class="card-content">
                      <h4>${spec.specializationName}</h4>
                      <p>${spec.description}</p>
                    </div>
                  </label>
                </c:forEach>
              </div>
              <div class="action-buttons">
                <a href="javascript:history.back()" class="back-button">← Quay lại</a>
                <button type="submit" class="continue-button">Tiếp tục</button>
              </div>
            </form>
          </body>

          </html>