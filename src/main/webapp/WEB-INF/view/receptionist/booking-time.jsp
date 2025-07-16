<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
  <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
      <!DOCTYPE html>
      <html>

      <head>
        <title>Đặt lịch khám</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <style>
          body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 20px;
          }

          h2,
          h3 {
            color: #333;
            margin-top: 30px;
          }

          .alert {
            background-color: #f8d7da;
            color: #721c24;
            padding: 12px 20px;
            border-radius: 6px;
            margin-bottom: 20px;
          }

          form {
            max-width: 960px;
            margin: 0 auto;
            background-color: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.05);
          }

          .date-options {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 10px;
          }

          .date-card {
            border: 2px solid #ccc;
            border-radius: 10px;
            padding: 12px 20px;
            background-color: #f8f9fa;
            cursor: pointer;
            transition: 0.3s;
            text-decoration: none;
            color: #000;
          }

          .date-card:hover {
            background-color: #e6f0ff;
            border-color: #007bff;
          }

          .selected-date {
            background-color: #007bff !important;
            color: white !important;
            border-color: #0056b3 !important;
          }

          .time-slots,
          .appointment-types {
            display: flex;
            flex-wrap: wrap;
            gap: 16px;
            margin-top: 15px;
          }

          .radio-hidden {
            display: none;
          }

          .time-slot-card,
          .appointment-type-card {
            border: 2px solid #ccc;
            border-radius: 10px;
            padding: 16px;
            background-color: #f8f9fa;
            color: black;
            cursor: pointer;
            transition: 0.3s;
            min-width: 180px;
            text-align: center;
            flex-grow: 1;
          }

          .time-slot-card:hover,
          .appointment-type-card:hover {
            background-color: #e6f0ff;
            border-color: #007bff;
          }

          .radio-hidden:checked+label.time-slot-card,
          .radio-hidden:checked+label.appointment-type-card {
            background-color: #007bff;
            color: white;
            border-color: #0056b3;
          }

          .time-slot-card.unavailable {
            opacity: 0.5;
            cursor: not-allowed;
            background-color: #eee;
            border-color: #bbb;
          }

          .booked-indicator {
            font-size: 13px;
            display: block;
            margin-top: 6px;
          }

          .text-green {
            color: green;
          }

          textarea {
            width: 100%;
            border-radius: 10px;
            padding: 12px;
            font-size: 15px;
            border: 1px solid #ccc;
            margin-top: 10px;
            resize: vertical;
          }

          .submit-button {
            margin-top: 30px;
            padding: 14px 28px;
            font-size: 16px;
            border: none;
            border-radius: 8px;
            background-color: #007bff;
            color: white;
            cursor: pointer;
            width: 100%;
            transition: background-color 0.3s ease;
          }

          .submit-button:hover {
            background-color: #0056b3;
          }

          @media (max-width: 768px) {

            .time-slot-card,
            .appointment-type-card {
              min-width: 100%;
            }

            .date-options {
              flex-direction: column;
            }
          }
        </style>
      </head>

      <body>
        <form method="post" action="/booking-receptionist/step-3">
          <c:if test="${not empty error}">
            <div class="alert">${error}</div>
          </c:if>

          <h2>Chọn khung giờ khám cho ngày: <strong>${formattedDate}</strong></h2>

          <!-- Danh sách ngày -->
          <h3>Chọn ngày khám:</h3>
          <div class="date-options">
            <c:forEach var="day" items="${dateOptions}">
              <a
                href="/booking-receptionist/step-3?email=${email}&specializationId=${specializationId}&doctorId=${doctorId}&date=${day.value}">
                <div class="date-card <c:if test='${day.value == selectedDate.toString()}'>selected-date</c:if>">
                  ${day.label}
                </div>
              </a>
            </c:forEach>
          </div>

          <input type="hidden" name="email" value="${email}" />
          <input type="hidden" name="specializationId" value="${specializationId}" />
          <input type="hidden" name="doctorId" value="${doctorId}" />
          <input type="hidden" name="selectedDate" value="${selectedDate}" />

          <!-- Khung giờ -->
          <h3>Chọn khung giờ:</h3>
          <div class="time-slots">
            <c:forEach items="${allTimeSlots}" var="timeSlot">
              <c:set var="isAvailable" value="false" />
              <c:set var="slotId" value="" />

              <c:forEach items="${availableSlots}" var="availableSlot">
                <c:if test="${availableSlot.startTime.toLocalTime() eq timeSlot.toLocalTime()}">
                  <c:set var="isAvailable" value="true" />
                  <c:set var="slotId" value="${availableSlot.slotID}" />
                </c:if>
              </c:forEach>

              <input type="radio" class="radio-hidden" id="slot-${timeSlot.toLocalTime()}" name="slotId"
                value="${slotId}" ${!isAvailable ? "disabled" : "" } required />
              <label for="slot-${timeSlot.toLocalTime()}" class="time-slot-card ${!isAvailable ? 'unavailable' : ''}">
                ${timeSlot.toLocalTime()} → ${timeSlot.plusHours(1).toLocalTime()}
                <c:if test="${!isAvailable}">
                  <span class="booked-indicator">Đã đặt</span>
                </c:if>
                <c:if test="${isAvailable}">
                  <span class="booked-indicator text-green">Có sẵn</span>
                </c:if>
              </label>
            </c:forEach>
          </div>

          <!-- Loại cuộc hẹn -->
          <h3>Chọn loại cuộc hẹn:</h3>
          <div class="appointment-types">
            <c:forEach items="${appointmentTypes}" var="type">
              <input type="radio" class="radio-hidden" id="type-${type.appointmentTypeID}" name="appointmentTypeId"
                value="${type.appointmentTypeID}" required />
              <label for="type-${type.appointmentTypeID}" class="appointment-type-card">
                <strong>${type.typeName}</strong><br />
                <span style="font-size: 14px; color: #eee">${type.description}</span>
              </label>
            </c:forEach>
          </div>

          <!-- Ghi chú -->
          <h3>Ghi chú (nếu có):</h3>
          <textarea name="note" rows="4" placeholder="Nhập ghi chú thêm nếu cần..."></textarea>

          <!-- Submit -->
          <button type="submit" class="submit-button">Tiếp tục</button>
        </form>
      </body>

      </html>