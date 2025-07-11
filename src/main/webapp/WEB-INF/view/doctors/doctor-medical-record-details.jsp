<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Chi tiết hồ sơ bệnh án</title>
                    <style>
                        body {
                            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            margin: 0;
                            padding: 40px 20px;
                            min-height: 100vh;
                            display: flex;
                            justify-content: center;
                            align-items: flex-start;
                        }

                        .card {
                            background: linear-gradient(145deg, #ffffff 0%, #f8f9fa 100%);
                            padding: 35px;
                            border-radius: 20px;
                            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15);
                            width: 100%;
                            max-width: 800px;
                            transition: all 0.3s ease;
                            position: relative;
                            overflow: hidden;
                            margin-bottom: 40px;
                        }

                        .card::before {
                            content: '';
                            position: absolute;
                            top: 0;
                            left: 0;
                            right: 0;
                            height: 4px;
                            background: linear-gradient(90deg, #667eea, #764ba2);
                        }

                        .card:hover {
                            transform: translateY(-5px);
                            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.2);
                        }

                        h1 {
                            font-size: 2rem;
                            font-weight: 700;
                            text-align: center;
                            color: #2d3748;
                            margin-bottom: 35px;
                            position: relative;
                            padding-bottom: 15px;
                        }

                        h1::after {
                            content: '';
                            position: absolute;
                            bottom: 0;
                            left: 50%;
                            transform: translateX(-50%);
                            width: 100px;
                            height: 3px;
                            background: linear-gradient(90deg, #667eea, #764ba2);
                            border-radius: 2px;
                        }

                        .section-title {
                            font-size: 1.4rem;
                            font-weight: 600;
                            color: #4a5568;
                            margin: 30px 0 20px;
                            padding-bottom: 10px;
                            border-bottom: 2px solid #e2e8f0;
                            display: flex;
                            align-items: center;
                            gap: 10px;
                        }

                        .section-title.vital-signs {
                            color: #667eea;
                            border-bottom-color: #a5b4fc;
                        }

                        .section-title.vital-signs::before {
                            content: '❤️';
                            font-size: 1.4rem;
                        }

                        .section-title.medical-condition {
                            color: #764ba2;
                            border-bottom-color: #c084fc;
                        }

                        .section-title.medical-condition::before {
                            content: '🩺';
                            font-size: 1.4rem;
                        }

                        .info-grid {
                            display: grid;
                            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                            gap: 20px;
                            margin-bottom: 25px;
                        }

                        .info {
                            background: rgba(237, 242, 247, 0.7);
                            padding: 15px 20px;
                            border-radius: 12px;
                            margin: 0;
                            font-size: 1rem;
                            line-height: 1.6;
                            color: #4a5568;
                            transition: all 0.2s ease;
                            border-left: 4px solid transparent;
                        }

                        .info.blood-pressure {
                            background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%);
                            border-left-color: #667eea;
                        }

                        .info.heart-rate {
                            background: linear-gradient(135deg, #ddd6fe 0%, #c4b5fd 100%);
                            border-left-color: #7c3aed;
                        }

                        .info.temperature {
                            background: linear-gradient(135deg, #ede9fe 0%, #ddd6fe 100%);
                            border-left-color: #8b5cf6;
                        }

                        .info.respiratory {
                            background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%);
                            border-left-color: #6366f1;
                        }

                        .info.oxygen {
                            background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
                            border-left-color: #3b82f6;
                        }

                        .info.symptoms {
                            background: linear-gradient(135deg, #f3e8ff 0%, #e9d5ff 100%);
                            border-left-color: #a855f7;
                        }

                        .info.examination {
                            background: linear-gradient(135deg, #ede9fe 0%, #ddd6fe 100%);
                            border-left-color: #9333ea;
                        }

                        .info.diagnosis {
                            background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%);
                            border-left-color: #667eea;
                        }

                        .info.follow-up {
                            background: linear-gradient(135deg, #ddd6fe 0%, #c4b5fd 100%);
                            border-left-color: #764ba2;
                        }

                        .info:hover {
                            transform: translateY(-3px);
                            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
                        }

                        .info span {
                            font-weight: 600;
                            color: #2d3748;
                            display: flex;
                            align-items: center;
                            gap: 8px;
                            margin-bottom: 8px;
                            font-size: 0.9rem;
                            text-transform: uppercase;
                            letter-spacing: 0.5px;
                        }

                        .info.blood-pressure span::before {
                            content: '🩸';
                            font-size: 1.1rem;
                        }

                        .info.heart-rate span::before {
                            content: '💓';
                            font-size: 1.1rem;
                        }

                        .info.temperature span::before {
                            content: '🌡️';
                            font-size: 1.1rem;
                        }

                        .info.respiratory span::before {
                            content: '🫁';
                            font-size: 1.1rem;
                        }

                        .info.oxygen span::before {
                            content: '🫧';
                            font-size: 1.1rem;
                        }

                        .info.symptoms span::before {
                            content: '🤒';
                            font-size: 1.1rem;
                        }

                        .info.examination span::before {
                            content: '👨‍⚕️';
                            font-size: 1.1rem;
                        }

                        .info.diagnosis span::before {
                            content: '📋';
                            font-size: 1.1rem;
                        }

                        .info.follow-up span::before {
                            content: '📅';
                            font-size: 1.1rem;
                        }

                        .value {
                            font-size: 1.1rem;
                            color: #1a202c;
                            font-weight: 500;
                            padding: 8px 12px;
                            background: rgba(255, 255, 255, 0.8);
                            border-radius: 8px;
                            margin-top: 5px;
                        }

                        .back-button {
                            display: inline-flex;
                            align-items: center;
                            gap: 8px;
                            margin-top: 30px;
                            padding: 12px 24px;
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            color: white;
                            text-decoration: none;
                            border-radius: 25px;
                            font-weight: 600;
                            font-size: 1rem;
                            transition: all 0.3s ease;
                            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
                        }

                        .back-button:hover {
                            transform: translateY(-2px);
                            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
                        }

                        .back-button::before {
                            content: "🔙";
                            font-size: 1rem;
                        }

                        @media (max-width: 768px) {
                            body {
                                padding: 20px 15px;
                            }

                            .card {
                                padding: 25px;
                            }

                            h1 {
                                font-size: 1.8rem;
                            }

                            .section-title {
                                font-size: 1.2rem;
                            }

                            .info-grid {
                                grid-template-columns: 1fr;
                            }
                        }

                        @media (max-width: 480px) {
                            .card {
                                padding: 20px;
                            }

                            h1 {
                                font-size: 1.5rem;
                            }

                            .info {
                                padding: 12px 15px;
                            }
                        }
                    </style>
                </head>

                <body>
                    <div class="card">
                        <h1>Chi tiết hồ sơ bệnh án</h1>

                        <div class="section-title vital-signs">Dấu hiệu sinh tồn</div>
                        <div class="info-grid">
                            <div class="info blood-pressure">
                                <span>Huyết áp</span>
                                <div class="value">${examination.bloodPressureDiastolic}/3 mmHg</div>
                            </div>
                            <div class="info heart-rate">
                                <span>Nhịp tim</span>
                                <div class="value">${examination.heartRate} bpm</div>
                            </div>
                            <div class="info temperature">
                                <span>Nhiệt độ</span>
                                <div class="value">${examination.temperature}°C</div>
                            </div>
                            <div class="info respiratory">
                                <span>Nhịp thở</span>
                                <div class="value">${examination.respiratoryRate} lần/phút</div>
                            </div>
                            <div class="info oxygen">
                                <span>SpO2</span>
                                <div class="value">${examination.oxygenSaturation}%</div>
                            </div>
                        </div>

                        <div class="section-title medical-condition">Tình trạng bệnh</div>
                        <div class="info-grid">
                            <div class="info symptoms">
                                <span>Triệu chứng</span>
                                <div class="value">${examination.symptoms}</div>
                            </div>
                            <div class="info examination">
                                <span>Khám Lâm Sàng</span>
                                <div class="value">${examination.physicalExamination}</div>
                            </div>
                            <div class="info diagnosis">
                                <span>Chẩn đoán</span>
                                <div class="value">${examination.diseaseDiagnosis}</div>
                            </div>
                            <div class="info follow-up">
                                <span>Ngày tái khám</span>
                                <div class="value">${examination.followUpDate.format(date)}</div>
                            </div>
                        </div>

                        <a href="javascript:history.back()" class="back-button">Quay lại</a>
                    </div>
                </body>

                </html>