<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%@ taglib
uri="http://www.springframework.org/tags/form" prefix="form" %> <%@ page
contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
  <head>
    <title>Đặt lịch khám</title>
    <style>
      .date-options {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        margin: 20px 0;
      }

      .date-card {
        border: 2px solid #ccc;
        border-radius: 10px;
        padding: 10px 16px;
        cursor: pointer;
        background-color: #f8f9fa;
        text-decoration: none;
        color: black;
        transition: 0.3s;
      }

      .date-card:hover {
        background-color: #e6f0ff;
        border-color: #007bff;
      }

      .selected-date {
        background-color: #007bff;
        color: white;
        border-color: #0056b3;
      }

      .time-slots {
        display: flex;
        flex-wrap: wrap;
        gap: 12px;
        margin-top: 20px;
      }

      .radio-hidden {
        display: none;
      }

      .time-slot-card {
        border: 2px solid #ccc;
        border-radius: 10px;
        padding: 12px 20px;
        background-color: #f8f9fa;
        color: black;
        cursor: pointer;
        transition: 0.3s;
        display: inline-block;
        min-width: 160px;
        text-align: center;
      }

      .time-slot-card:hover {
        background-color: #e6f0ff;
        border-color: #007bff;
      }

      .radio-hidden:checked + .time-slot-card {
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
        font-size: 12px;
        color: red;
        display: block;
        margin-top: 4px;
      }

      .text-green {
        color: green;
      }

      .appointment-types {
        display: flex;
        flex-wrap: wrap;
        gap: 12px;
        margin-top: 20px;
      }

      .appointment-type-card {
        border: 2px solid #ccc;
        border-radius: 10px;
        padding: 12px 20px;
        background-color: #f8f9fa;
        color: black;
        cursor: pointer;
        transition: 0.3s;
        display: inline-block;
        min-width: 200px;
        text-align: left;
      }

      .appointment-type-card:hover {
        background-color: #e6f0ff;
        border-color: #007bff;
      }

      .radio-hidden:checked + .appointment-type-card {
        background-color: #007bff;
        color: white;
        border-color: #0056b3;
      }

      .submit-button {
        margin-top: 30px;
        padding: 10px 25px;
        font-size: 16px;
        border: none;
        border-radius: 6px;
        background-color: #007bff;
        color: white;
        cursor: pointer;
      }

      .submit-button:hover {
        background-color: #0056b3;
      }
    </style>
  </head>
  <body>
    <c:if test="${not empty error}">
      <div class="alert alert-danger">${error}</div>
    </c:if>
    <h2>Chọn khung giờ khám cho ngày: <strong>${formattedDate}</strong></h2>

    <!-- Danh sách ngày -->
    <h3>Chọn ngày khám:</h3>
    <div class="date-options">
      <c:forEach var="day" items="${dateOptions}">
        <a
          href="/booking-receptionist/step-3?email=${email}&specializationId=${specializationId}&doctorId=${doctorId}&date=${day.value}"
        >
          <div
            class="date-card <c:if test='${day.value == selectedDate.toString()}'>selected-date</c:if>"
          >
            ${day.label}
          </div>
        </a>
      </c:forEach>
    </div>

    <!-- Form đặt lịch -->
    <form method="post" action="/booking-receptionist/step-3">
      <input type="hidden" name="email" value="${email}" />
      <input
        type="hidden"
        name="specializationId"
        value="${specializationId}"
      />
      <input type="hidden" name="doctorId" value="${doctorId}" />
      <input type="hidden" name="selectedDate" value="${selectedDate}" />

      <!-- Khung giờ -->
      <h3>Chọn khung giờ:</h3>
      <div class="time-slots">
        <c:forEach items="${allTimeSlots}" var="timeSlot">
          <c:set var="isAvailable" value="false" />
          <c:set var="slotId" value="" />

          <c:forEach items="${availableSlots}" var="availableSlot">
            <c:if
              test="${availableSlot.startTime.toLocalTime() eq timeSlot.toLocalTime()}"
            >
              <c:set var="isAvailable" value="true" />
              <c:set var="slotId" value="${availableSlot.slotID}" />
            </c:if>
          </c:forEach>

          <input type="radio" class="radio-hidden"
          id="slot-${timeSlot.toLocalTime()}" name="slotId" value="${slotId}"
          ${!isAvailable ? "disabled" : ""} required />
          <label
            for="slot-${timeSlot.toLocalTime()}"
            class="time-slot-card ${!isAvailable ? 'unavailable' : ''}"
          >
            <div class="time-range">
              ${timeSlot.toLocalTime()} → ${timeSlot.plusHours(1).toLocalTime()}
            </div>
            <c:if test="${!isAvailable}">
              <span class="booked-indicator">Đã đặt</span>
            </c:if>
            <c:if test="${isAvailable}">
              <span class="booked-indicator text-green">có sẵn</span>
            </c:if>
          </label>
        </c:forEach>
      </div>

      <!-- Loại cuộc hẹn -->
      <h3>Chọn loại cuộc hẹn:</h3>
      <div class="appointment-types">
        <c:forEach items="${appointmentTypes}" var="type">
          <input
            type="radio"
            class="radio-hidden"
            id="type-${type.appointmentTypeID}"
            name="appointmentTypeId"
            value="${type.appointmentTypeID}"
            required
          />
          <label
            for="type-${type.appointmentTypeID}"
            class="appointment-type-card"
          >
            <strong>${type.typeName}</strong><br />
            <span style="font-size: 14px; color: #555"
              >${type.description}</span
            >
          </label>
        </c:forEach>
      </div>

      <!-- Ghi chú -->
      <h3>Ghi chú (nếu có):</h3>
      <textarea
        name="note"
        rows="4"
        style="width: 100%; border-radius: 8px; padding: 10px"
      ></textarea>

      <!-- Submit -->
      <button type="submit" class="submit-button">Tiếp tục</button>
    </form>
  </body>
</html>
