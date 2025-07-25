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
            }

            label {
              font-weight: 600;
              font-size: 18px;
              display: block;
              margin-bottom: 16px;
              color: #2d3e50;
            }

            .card-grid {
              display: grid;
              grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
              gap: 20px;
            }

            .card {
              background-color: #f8fafc;
              border: 2px solid transparent;
              padding: 20px;
              border-radius: 14px;
              text-align: center;
              cursor: pointer;
              transition: all 0.3s ease;
              position: relative;
              box-shadow: 0 4px 14px rgba(0, 0, 0, 0.03);
            }

            .card:hover {
              background-color: #f1f5f9;
              transform: translateY(-2px);
              box-shadow: 0 6px 18px rgba(0, 0, 0, 0.05);
            }

            .card img {
              width: 100px;
              height: 100px;
              object-fit: cover;
              border-radius: 50%;
              margin-bottom: 14px;
              border: 2px solid #dce3ed;
            }

            .card h4 {
              font-size: 18px;
              color: #007bff;
              margin: 8px 0 4px;
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
              background-color: #e9f3ff;
              box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.2);
              transform: scale(1.02);
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

            button[type="submit"] {
              width: 100%;
              background-color: #007bff;
              color: white;
              padding: 16px;
              font-size: 17px;
              font-weight: 600;
              border: none;
              border-radius: 12px;
              margin-top: 36px;
              cursor: pointer;
              transition: background-color 0.3s ease, transform 0.2s ease;
            }

            button[type="submit"]:hover {
              background-color: #0056b3;
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

            <button type="submit">Tiếp tục</button>
          </form>
        </body>

        </html>