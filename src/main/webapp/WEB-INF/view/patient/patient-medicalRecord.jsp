<%@page contentType="text/html" pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib
uri="http://www.springframework.org/tags/form" prefix="form" %> <%@ taglib
prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Patient History Medical Record</title>
  </head>
  <style>
    body {
      font-family: "Segoe UI", "Helvetica Neue", sans-serif;
      background: linear-gradient(135deg, #e0f2fe, #fef9c3);
      display: flex;
      justify-content: center;
      align-items: flex-start;
      padding: 40px;
      min-height: 100vh;
      color: #1f2937;
    }

    .card {
      background-color: #ffffff;
      padding: 32px;
      border-radius: 16px;
      box-shadow: 0 12px 32px rgba(0, 0, 0, 0.1);
      width: 100%;
      max-width: 700px;
      border: 1px solid #e5e7eb;
      animation: fadeIn 0.4s ease-in-out;
    }

    @keyframes fadeIn {
      from {
        opacity: 0;
        transform: translateY(16px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    .card h1 {
      font-size: 28px;
      font-weight: 700;
      text-align: center;
      color: #1e40af;
      margin-bottom: 32px;
    }

    .section-title {
      font-size: 20px;
      font-weight: 600;
      color: #0ea5e9;
      margin-top: 24px;
      margin-bottom: 12px;
      border-bottom: 2px solid #bae6fd;
      padding-bottom: 6px;
      letter-spacing: 0.5px;
    }

    .info {
      font-size: 16px;
      color: #374151;
      margin: 10px 0;
      line-height: 1.6;
      padding-left: 8px;
      border-left: 3px solid #93c5fd;
      background-color: #f8fafc;
      padding: 10px 12px;
      border-radius: 6px;
    }

    .info span {
      font-weight: 600;
      color: #111827;
    }

    .back-button {
      display: inline-block;
      margin-top: 30px;
      padding: 12px 24px;
      background-color: #1d4ed8;
      color: white;
      border: none;
      border-radius: 8px;
      text-decoration: none;
      font-weight: 600;
      font-size: 16px;
      transition: all 0.3s ease;
      box-shadow: 0 4px 14px rgba(29, 78, 216, 0.25);
    }

    .back-button:hover {
      background-color: #2563eb;
      transform: translateY(-2px);
    }

    .info[style*="red"] {
      background-color: #fef2f2;
      color: #dc2626;
      border-left-color: #f87171;
    }
  </style>

  <body>
    <div class="card">
      <h1>Hồ Sơ Bệnh Án</h1>

      <c:if test="${examination != null}">
        <div class="section-title">Dấu hiệu sinh tồn</div>
        <p class="info">
          <span>Huyết áp:</span> ${examination.bloodPressureDiastolic}/3 mmHg
        </p>
        <p class="info"><span>Nhịp tim:</span> ${examination.heartRate} bpm</p>
        <p class="info"><span>Nhiệt độ:</span> ${examination.temperature}</p>
        <p class="info">
          <span>Nhịp thở:</span> ${examination.respiratoryRate} lần/phút
        </p>
        <p class="info"><span>SpO2:</span> ${examination.oxygenSaturation}</p>

        <div class="section-title">Tình trạng bệnh</div>
        <p class="info"><span>Triệu chứng:</span> ${examination.symptoms}</p>
        <p class="info">
          <span>Khám Lâm Sàng:</span> ${examination.physicalExamination}
        </p>
        <p class="info">
          <span>Chẩn đoán:</span> ${examination.diseaseDiagnosis}
        </p>
        <p class="info">
          <span>Ngày tái khám:</span>
          <c:choose>
            <c:when test="${examination.followUpDate != null}">
              ${examination.followUpDate.format(date)}
            </c:when>
            <c:otherwise>Không có</c:otherwise>
          </c:choose>
        </p>
      </c:if>

      <c:if test="${examination == null}">
        <p class="info" style="color: red; font-weight: bold">
          Không có hồ sơ bệnh án
        </p>
      </c:if>

      <a href="javascript:history.back()" class="back-button">← Quay lại</a>
    </div>
  </body>
</html>
