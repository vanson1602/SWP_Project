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
            color: #1a1a1a;
          }

          h2,
          h3 {
            color: #1a1a1a;
            margin-top: 30px;
            font-weight: 600;
          }

          .alert {
            background-color: #ffe5e5;
            color: #cc0000;
            padding: 12px 20px;
            border-left: 6px solid #cc0000;
            border-radius: 6px;
            margin-bottom: 20px;
          }

          form {
            max-width: 960px;
            margin: 0 auto;
            background-color: #ffffff;
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
          }

          .date-options,
          .time-slots,
          .appointment-types {
            display: flex;
            flex-wrap: wrap;
            gap: 14px;
            margin-top: 15px;
          }

          .date-card,
          .time-slot-card,
          .appointment-type-card {
            border: 2px solid #ccc;
            border-radius: 12px;
            padding: 14px 20px;
            background-color: #f9fafb;
            transition: 0.3s;
            cursor: pointer;
            text-align: center;
            flex: 1 1 160px;
            min-width: 160px;
            font-size: 15px;
            font-weight: 500;
          }

          .date-card:hover,
          .time-slot-card:hover,
          .appointment-type-card:hover {
            background-color: #e9f2ff;
            border-color: #0066cc;
          }

          .selected-date {
            background-color: #0066cc !important;
            color: #fff !important;
            border-color: #005bb5 !important;
          }

          .radio-hidden {
            display: none;
          }

          .radio-hidden:checked+label {
            background-color: #0066cc;
            color: #fff;
            border-color: #005bb5;
          }

          .time-slot-card.unavailable {
            opacity: 0.5;
            background-color: #eeeeee;
            border-color: #bbb;
            cursor: not-allowed;
          }

          .booked-indicator {
            display: block;
            font-size: 13px;
            margin-top: 6px;
            font-weight: 500;
          }

          .text-green {
            color: #2e8b57;
          }

          textarea {
            width: 100%;
            border-radius: 10px;
            padding: 12px;
            font-size: 15px;
            border: 1.5px solid #ccc;
            margin-top: 10px;
            resize: vertical;
            transition: border-color 0.3s ease;
          }

          textarea:focus {
            border-color: #0066cc;
            outline: none;
          }

          .submit-button {
            margin-top: 30px;
            padding: 16px;
            font-size: 16px;
            border: none;
            border-radius: 10px;
            background-color: #0066cc;
            color: white;
            cursor: pointer;
            width: 100%;
            font-weight: 600;
            transition: background-color 0.3s ease, transform 0.2s ease;
          }

          .date-options a {
            text-decoration: none;
            color: inherit;
          }

          .appointment-type-card span {
            font-size: 14px;
            color: black;
          }

          .submit-button:hover {
            background-color: #004f9e;
            transform: translateY(-1px);
          }

          /* Hover rõ ràng hơn cho các card */
          .date-card:hover,
          .time-slot-card:hover,
          .appointment-type-card:hover {
            background-color: #d0e7ff;
            border-color: #3399ff;
            box-shadow: 0 0 0 3px rgba(0, 102, 204, 0.2);
            transform: translateY(-2px);
          }

          /* Chọn radio thì hiện hiệu ứng */
          .radio-hidden:checked+label {
            background-color: #3399ff;
            color: #fff;
            border-color: #2a85d0;
            box-shadow: 0 0 0 3px rgba(51, 153, 255, 0.4);
            transform: translateY(-1px);
          }

          /* Hover cho nút submit */
          .submit-button:hover {
            background-color: #0053b3;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 83, 179, 0.3);
          }

          /* Loại cuộc hẹn - mô tả nhẹ nhàng */
          .appointment-type-card span {
            font-size: 14px;
            color: #444;
          }

          /* Tăng hiệu ứng khi di chuột vào ô ghi chú */
          textarea:focus {
            border-color: #3399ff;
            box-shadow: 0 0 5px rgba(0, 102, 204, 0.2);
          }

          /* Nhẹ nhàng hơn cho phần chọn ngày */
          .date-options a {
            text-decoration: none;
            color: inherit;
            transition: transform 0.2s ease;
          }


          @media (max-width: 768px) {

            .date-options,
            .time-slots,
            .appointment-types {
              flex-direction: column;
            }

            .date-card,
            .time-slot-card,
            .appointment-type-card {
              min-width: 100%;
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
                <strong>${type.typeName}</strong><br /><br />
                <span style="font-size: 14px; color: #2e8b57">${type.description}</span>
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