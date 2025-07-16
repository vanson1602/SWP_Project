<%@page contentType="text/html" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
      <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

        <!DOCTYPE html>
        <html lang="en">

        <head>
          <meta charset="UTF-8" />
          <meta name="viewport" content="width=device-width, initial-scale=1.0" />
          <title>Chọn bác sĩ</title>

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

            .card-grid {
              display: grid;
              grid-template-columns: repeat(3, 1fr);
              gap: 20px;
              margin-top: 16px;
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
              margin: 4px 0;
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
          <form action="/booking-receptionist/step-2" method="post">
            <input type="hidden" name="email" value="${email}" />
            <input type="hidden" name="specializationId" value="${selectedSpecializationId}" />

            <label>Chọn bác sĩ:</label>
            <div class="card-grid">
              <c:forEach var="doctor" items="${doctors}">
                <input type="radio" name="doctorId" id="doctor-${doctor.doctorID}" value="${doctor.doctorID}"
                  required />
                <label for="doctor-${doctor.doctorID}" class="card">
                  <h4>${doctor.user.fullName}</h4>
                  <p>${doctor.qualification}</p>
                  <p>Phí khám:
                    <fmt:formatNumber value="${doctor.consultationFee}" type="currency" currencySymbol="₫" />
                  </p>
                </label>
              </c:forEach>
            </div>

            <button type="submit">Tiếp tục</button>
          </form>
        </body>

        </html>