<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Patient History</title>
                </head>
                <style>
                    body {
                        font-family: "Segoe UI", sans-serif;
                        background-color: #f1f4f9;
                        margin: 0;
                        padding: 20px;
                    }

                    h2 {
                        text-align: center;
                        color: #34495e;
                        margin-bottom: 30px;
                    }

                    .card-container {
                        display: flex;
                        flex-wrap: wrap;
                        gap: 20px;
                        justify-content: center;
                    }

                    .card {
                        background-color: #fff;
                        border-radius: 12px;
                        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
                        padding: 20px;
                        width: 320px;
                        transition: transform 0.2s ease;
                    }

                    .card:hover {
                        transform: translateY(-5px);
                    }

                    .card h3 {
                        margin: 0 0 10px;
                        color: #2980b9;
                        font-size: 18px;
                    }

                    .card p {
                        margin: 6px 0;
                        color: #555;
                    }

                    .label {
                        font-weight: bold;
                        color: #2c3e50;
                    }

                    .no-data {
                        text-align: center;
                        color: #888;
                        font-style: italic;
                        margin-top: 40px;
                    }

                    .back-button {
                        display: inline-block;
                        margin-top: 24px;
                        padding: 10px 20px;
                        background-color: #3b82f6;
                        color: white;
                        border-radius: 8px;
                        text-decoration: none;
                        transition: background-color 0.3s ease;
                    }

                    .back-button:hover {
                        background-color: #2563eb;
                    }

                    @media (max-width: 600px) {
                        .card {
                            width: 90%;
                        }
                    }
                </style>

                <body>
                    <h2>Lịch sử khám bệnh của bạn</h2>

                    <c:if test="${not empty appointment}">
                        <div class="card-container">
                            <c:forEach var="a" items="${appointment}" varStatus="i">
                                <div class="card">
                                    <h3>Lịch hẹn: ${a.appointmentNumber}</h3>
                                    <p><span class="label">Ngày khám:</span> ${a.appointmentDate.format(formatter)}</p>
                                    <p><span class="label">thời gian:</span> ${a.appointmentDate.format(startTime)} -
                                        ${endTimes[i.index]}
                                    </p>
                                    <p><span class="label">Thể loại:</span> ${a.appointmentType.typeName}</p>
                                    <p><span class="label">Bác sĩ:</span> ${a.doctor.user.fullName}</p>
                                    <p><span class="label">Trạng thái:</span> ${a.status}</p>
                                    <p><span class="label">Ghi chú bệnh nhân:</span>
                                        <c:choose>
                                            <c:when test="${not empty a.patientNotes}">${a.patientNotes}</c:when>
                                            <c:otherwise><i style="color: #aaa;">Không có</i></c:otherwise>
                                        </c:choose>
                                    </p>
                                    <p><span class="label">Hồ sơ bệnh án: </span><a
                                            href="/medical-history/medical-record/${a.appointmentID}">chi
                                            tiết</a></p>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>

                    <c:if test="${empty appointment}">
                        <p class="no-data">Không có lịch sử khám bệnh nào.</p>
                    </c:if>
                    <a href="javascript:history.back()" class="back-button">← Quay lại</a>
                </body>

                </html>