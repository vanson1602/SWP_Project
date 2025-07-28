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
              font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
              background-color: #f8fafc;
              margin: 0;
              padding: 30px;
            }

            form {
              max-width: 960px;
              margin: auto;
              background-color: #ffffff;
              padding: 50px 40px;
              border-radius: 20px;
              box-shadow: 0 12px 32px rgba(0, 0, 0, 0.05);
            }

            label {
              font-weight: 600;
              font-size: 20px;
              display: block;
              margin-bottom: 20px;
              color: #1e293b;
            }

            .card-grid {
              display: grid;
              grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
              gap: 24px;
            }

            .card {
              background-color: #f1f5f9;
              border: 2px solid transparent;
              padding: 24px;
              border-radius: 16px;
              text-align: center;
              position: relative;
              cursor: pointer;
              transition: all 0.3s ease;
              box-shadow: 0 4px 14px rgba(0, 0, 0, 0.03);
            }

            .card:hover {
              background-color: #e2e8f0;
              transform: translateY(-2px);
              box-shadow: 0 6px 20px rgba(0, 0, 0, 0.06);
            }

            .card img {
              width: 96px;
              height: 96px;
              object-fit: cover;
              border-radius: 50%;
              margin-bottom: 14px;
              border: 2px solid #d1d5db;
            }

            .card h4 {
              font-size: 17px;
              font-weight: 600;
              color: #0f172a;
              margin-bottom: 6px;
            }

            .card p {
              font-size: 14px;
              color: #475569;
              margin: 4px 0;
            }

            input[type="radio"] {
              display: none;
            }

            input[type="radio"]:checked+label.card {
              border-color: #3b82f6;
              background-color: #e0f2fe;
              box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.25);
              transform: scale(1.02);
            }

            input[type="radio"]:checked+label.card::after {
              content: "✔";
              position: absolute;
              top: 12px;
              right: 16px;
              background-color: #3b82f6;
              color: white;
              font-size: 14px;
              padding: 5px 7px;
              border-radius: 50%;
            }

            .action-buttons {
              display: flex;
              justify-content: center;
              gap: 20px;
              margin-top: 40px;
              flex-wrap: wrap;
            }

            .back-button,
            .continue-button {
              padding: 14px 26px;
              font-size: 15px;
              font-weight: 500;
              border-radius: 10px;
              text-decoration: none;
              cursor: pointer;
              transition: background-color 0.3s ease, transform 0.2s ease;
              box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
              display: inline-block;
            }

            .back-button {
              background-color: #f1f5f9;
              color: #334155;
              border: 1px solid #cbd5e1;
            }

            .back-button:hover {
              background-color: #e2e8f0;
              transform: translateY(-1px);
            }

            .continue-button {
              background-color: #3b82f6;
              color: white;
              border: none;
            }

            .continue-button:hover {
              background-color: #2563eb;
              transform: translateY(-1px);
            }

            @media (max-width: 600px) {
              form {
                padding: 30px 20px;
              }

              .card img {
                width: 80px;
                height: 80px;
              }

              .action-buttons {
                flex-direction: column;
                align-items: stretch;
              }

              .back-button,
              .continue-button {
                width: 100%;
                text-align: center;
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
                  <c:choose>
                    <c:when test="${not empty doctor.user.avatarUrl}">
                      <img src="${doctor.user.avatarUrl}" class="card-img-top"
                        alt="BS. ${doctor.user.firstName} ${doctor.user.lastName}">
                    </c:when>
                    <c:otherwise>
                      <img src="/resources/images/defaultImg.jpg" class="card-img-top" alt="Default doctor photo">
                    </c:otherwise>
                  </c:choose>
                  <h4>${doctor.user.fullName}</h4>
                  <p>${doctor.qualification}</p>
                  <p>kinh nghiệm:
                    <fmt:formatNumber value="${doctor.experienceYears}" type="currency" currencySymbol="năm " />
                  </p>
                  <p>Phí khám:
                    <fmt:formatNumber value="${doctor.consultationFee}" type="currency" currencySymbol="₫" />
                  </p>
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