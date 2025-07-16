<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8" />
                    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                    <title>Lịch sử khám bệnh</title>
                    <style>
                        body {
                            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            margin: 0;
                            padding: 30px;
                            min-height: 100vh;
                        }

                        .container {
                            max-width: 1400px;
                            margin: 0 auto;
                        }

                        h2 {
                            text-align: center;
                            color: #fff;
                            margin-bottom: 50px;
                            font-size: 3rem;
                            font-weight: 700;
                            text-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
                            position: relative;
                            padding: 20px 0;
                            letter-spacing: 1px;
                        }

                        h2::before {
                            content: '';
                            position: absolute;
                            top: 0;
                            left: 50%;
                            transform: translateX(-50%);
                            width: 100px;
                            height: 4px;
                            background: linear-gradient(90deg, #fff, rgba(255, 255, 255, 0.5));
                            border-radius: 2px;
                        }

                        h2::after {
                            content: '';
                            position: absolute;
                            bottom: 0;
                            left: 50%;
                            transform: translateX(-50%);
                            width: 200px;
                            height: 2px;
                            background: linear-gradient(90deg, rgba(255, 255, 255, 0.3), #fff, rgba(255, 255, 255, 0.3));
                            border-radius: 1px;
                        }

                        .card-container {
                            display: grid;
                            grid-template-columns: repeat(auto-fit, minmax(420px, 1fr));
                            gap: 35px;
                            margin-bottom: 50px;
                        }

                        .card {
                            background: linear-gradient(145deg, #ffffff 0%, #f8f9fa 100%);
                            border-radius: 20px;
                            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15);
                            padding: 35px;
                            transition: all 0.3s ease;
                            border: 1px solid rgba(255, 255, 255, 0.2);
                            position: relative;
                            overflow: hidden;
                            min-height: 320px;
                        }

                        .card::before {
                            content: '';
                            position: absolute;
                            top: 0;
                            left: 0;
                            right: 0;
                            height: 5px;
                            background: linear-gradient(90deg, #667eea, #764ba2);
                        }

                        .card:hover {
                            transform: translateY(-10px);
                            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.25);
                        }

                        .card h3 {
                            margin: 0 0 25px;
                            color: #2c3e50;
                            font-size: 1.5rem;
                            font-weight: 700;
                            display: flex;
                            align-items: center;
                            padding-bottom: 15px;
                            border-bottom: 2px solid #e2e8f0;
                        }

                        .card h3::before {
                            content: "📋";
                            margin-right: 12px;
                            font-size: 1.3rem;
                        }

                        .card p {
                            margin: 15px 0;
                            color: #4a5568;
                            font-size: 1.1rem;
                            line-height: 1.6;
                        }

                        .label {
                            font-weight: 600;
                            color: #2d3748;
                            display: inline-block;
                            min-width: 140px;
                            font-size: 1rem;
                        }

                        .status {
                            display: inline-block;
                            padding: 6px 16px;
                            border-radius: 25px;
                            font-size: 0.9rem;
                            font-weight: 600;
                            text-transform: uppercase;
                            letter-spacing: 0.5px;
                        }

                        .status.completed {
                            background-color: #d4edda;
                            color: #155724;
                        }

                        .status.pending {
                            background-color: #fff3cd;
                            color: #856404;
                        }

                        .status.confirmed {
                            background-color: #cce5ff;
                            color: #004085;
                        }

                        .status.cancelled {
                            background-color: #f8d7da;
                            color: #721c24;
                        }

                        .detail-button {
                            display: inline-flex;
                            align-items: center;
                            gap: 10px;
                            padding: 14px 28px;
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            color: white;
                            text-decoration: none;
                            border-radius: 30px;
                            font-weight: 600;
                            font-size: 1rem;
                            transition: all 0.3s ease;
                            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
                            margin-top: 20px;
                        }

                        .detail-button:hover {
                            transform: translateY(-3px);
                            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.6);
                            text-decoration: none;
                            color: white;
                        }

                        .detail-button::after {
                            content: "👁️";
                            font-size: 1.1rem;
                        }

                        .appointment-info {
                            display: grid;
                            grid-template-columns: 1fr;
                            gap: 12px;
                        }

                        .info-row {
                            display: flex;
                            justify-content: space-between;
                            align-items: flex-start;
                            padding: 8px 0;
                        }

                        .info-value {
                            flex: 1;
                            text-align: right;
                            margin-left: 15px;
                            font-weight: 500;
                        }

                        .no-data {
                            text-align: center;
                            color: #fff;
                            font-style: italic;
                            margin-top: 60px;
                            font-size: 1.2rem;
                            background: rgba(255, 255, 255, 0.1);
                            padding: 40px;
                            border-radius: 16px;
                            backdrop-filter: blur(10px);
                        }

                        .back-button {
                            display: inline-flex;
                            align-items: center;
                            gap: 8px;
                            margin-top: 30px;
                            padding: 12px 24px;
                            background: rgba(255, 255, 255, 0.9);
                            color: #2d3748;
                            border-radius: 25px;
                            text-decoration: none;
                            transition: all 0.3s ease;
                            font-weight: 600;
                            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                            backdrop-filter: blur(10px);
                        }

                        .back-button:hover {
                            background: white;
                            transform: translateY(-2px);
                            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
                            text-decoration: none;
                            color: #2d3748;
                        }

                        .back-button::before {
                            content: "←";
                            font-size: 1.2rem;
                        }

                        @media (max-width: 768px) {
                            .container {
                                padding: 0 15px;
                            }

                            .card-container {
                                grid-template-columns: 1fr;
                                gap: 20px;
                            }

                            .card {
                                padding: 20px;
                            }

                            h2 {
                                font-size: 1.8rem;
                                margin-bottom: 30px;
                            }

                            .info-row {
                                flex-direction: column;
                                gap: 4px;
                            }

                            .info-value {
                                text-align: left;
                                margin-left: 0;
                            }
                        }

                        @media (max-width: 480px) {
                            body {
                                padding: 15px;
                            }

                            .card {
                                padding: 15px;
                            }

                            .label {
                                min-width: auto;
                                display: block;
                                margin-bottom: 4px;
                            }
                        }
                    </style>
                </head>

                <body>
                    <div class="container">
                        <h2>Lịch sử khám bệnh của bệnh nhân</h2>

                        <c:if test="${not empty appointment}">
                            <div class="card-container">
                                <c:forEach var="a" items="${appointment}" varStatus="i">
                                    <div class="card">
                                        <h3>Lịch hẹn: ${a.appointmentNumber}</h3>
                                        <div class="appointment-info">
                                            <div class="info-row">
                                                <span class="label">Ngày khám:</span>
                                                <span class="info-value">${a.appointmentDate.format(formatter)}</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="label">Thời gian:</span>
                                                <span class="info-value">${a.appointmentDate.format(startTime)} - ${endTimes[i.index]}</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="label">Thể loại:</span>
                                                <span class="info-value">${a.appointmentType.typeName}</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="label">Bác sĩ:</span>
                                                <span class="info-value">${a.doctor.user.fullName}</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="label">Trạng thái:</span>
                                                <span class="info-value">
                                                    <span class="status ${a.status.toLowerCase()}">${a.status}</span>
                                                </span>
                                            </div>
                                            <div class="info-row">
                                                <span class="label">Ghi chú bệnh nhân:</span>
                                                <span class="info-value">
                                                    <c:choose>
                                                        <c:when test="${not empty a.patientNotes}">${a.patientNotes}</c:when>
                                                        <c:otherwise><i style="color: #aaa;">Không có</i></c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                        </div>
                                        <a href="/history/medicalRecord/${a.appointmentID}" class="detail-button">
                                            Xem chi tiết hồ sơ bệnh án
                                        </a>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>

                        <c:if test="${empty appointment}">
                            <p class="no-data">Không có lịch sử khám bệnh nào.</p>
                        </c:if>
                        
                        <a href="javascript:history.back()" class="back-button">Quay lại</a>
                    </div>
                </body>

                </html>