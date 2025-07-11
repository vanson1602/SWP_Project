<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Medical Record</title>
                </head>

                <style>
                    body {
                        font-family: 'Segoe UI', sans-serif;
                        background-color: #f9fafb;
                        display: flex;
                        justify-content: center;
                        align-items: flex-start;
                        padding: 40px;
                        min-height: 100vh;
                    }

                    .card {
                        background-color: #ffffff;
                        padding: 32px;
                        border-radius: 16px;
                        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
                        width: 100%;
                        max-width: 640px;
                        transition: transform 0.2s;
                    }

                    .card:hover {
                        transform: translateY(-4px);
                    }

                    .card h1 {
                        font-size: 24px;
                        font-weight: 600;
                        text-align: center;
                        color: #1f2937;
                        margin-bottom: 24px;
                    }

                    .section-title {
                        font-size: 18px;
                        font-weight: 500;
                        color: #2563eb;
                        margin-top: 20px;
                        margin-bottom: 8px;
                        border-bottom: 1px solid #e5e7eb;
                        padding-bottom: 4px;
                    }

                    .info {
                        font-size: 16px;
                        color: #374151;
                        margin: 8px 0;
                        line-height: 1.6;
                    }

                    .info span {
                        font-weight: 600;
                        color: #111827;
                    }

                    .back-button {
                        display: block;
                        margin-top: 30px;
                        padding: 12px 20px;
                        background-color: #3b82f6;
                        color: white;
                        text-align: center;
                        border-radius: 8px;
                        text-decoration: none;
                        font-weight: 500;
                        transition: background-color 0.3s;
                    }

                    .back-button:hover {
                        background-color: #2563eb;
                    }
                </style>

                <body>
                    <div class="card">
                        <h1>Medical Record Details</h1>

                        <div class="section-title">Dấu hiệu sinh tồn</div>
                        <p class="info"><span>Huyết áp:</span> ${examination.bloodPressureDiastolic}/3 mmHg</p>
                        <p class="info"><span>Nhịp tim:</span> ${examination.heartRate} bpm</p>
                        <p class="info"><span>Nhiệt độ:</span> ${examination.temperature}</p>
                        <p class="info"><span>Nhịp thở:</span> ${examination.respiratoryRate} lần/phút</p>
                        <p class="info"><span>SpO2:</span> ${examination.oxygenSaturation}</p>

                        <div class="section-title">Tình trạng bệnh</div>
                        <p class="info"><span>Triệu chứng:</span> ${examination.symptoms}</p>
                        <p class="info"><span>Khám Lâm Sàng:</span> ${examination.physicalExamination}</p>
                        <p class="info"><span>Chẩn đoán:</span> ${examination.diseaseDiagnosis}</p>
                        <p class="info"><span>Ngày tái khám:</span> ${examination.followUpDate.format(date)}</p>

                        <a href="javascript:history.back()" class="back-button">← Quay lại</a>
                    </div>
                </body>

                </html>