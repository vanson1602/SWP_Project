<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Appointment Page</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="/resources/css/appointment-style.css">
</head>
<body>
    <div class="appointment-container">
        <h1 class="page-title">Quản lý lịch hẹn & khám bệnh</h1>
        
        <div class="button-grid">
            <a href="/appointments/booking" class="action-button">
                <i class="fas fa-calendar-plus"></i>
                <span>Đặt lịch khám</span>
            </a>
            
            <a href="/appointments/my-appointments" class="action-button">
                <i class="fas fa-calendar-check"></i>
                <span>Lịch hẹn của tôi</span>
            </a>
            
            <a href="/appointments/medical-result" class="action-button">
                <i class="fas fa-file-medical"></i>
                <span>Kết quả khám bệnh</span>
            </a>
            
            <a href="/medical-history" class="action-button">
                <i class="fas fa-history"></i>
                <span>Lịch sử khám bệnh</span>
            </a>
        </div>
    </div>
</body>
</html>