<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%@ page
contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
  <head>
    <title>Xác nhận đặt lịch</title>
    <style>
      .confirm-box {
        border: 2px solid #ccc;
        border-radius: 10px;
        padding: 20px;
        max-width: 600px;
        margin: 30px auto;
        background-color: #f8f9fa;
      }
      .confirm-box h2 {
        text-align: center;
      }
      .confirm-box p {
        font-size: 18px;
        margin: 10px 0;
      }
      .confirm-actions {
        text-align: center;
        margin-top: 20px;
      }
      .confirm-actions button {
        padding: 10px 20px;
        font-size: 16px;
        margin: 0 10px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
      }
      .btn-confirm {
        background-color: #007bff;
        color: white;
      }
      .btn-cancel {
        background-color: #ccc;
      }
    </style>
  </head>
  <body>
    <c:if test="${not empty error}">
      <div class="alert alert-danger">${error}</div>
    </c:if>
    <h2>Xác nhận lịch khám</h2>
    <p>Bệnh nhân: <strong>${patient.user.username}</strong></p>
    <p>Bác sĩ: <strong>${doctor.user.username}</strong></p>
    <p>Thời gian: <strong>${slot.startTime} - ${slot.endTime}</strong></p>
    <p>
      Loại cuộc hẹn:
      <strong
        >${appointmentType.typeName} (${doctor.consultationFee} VND)</strong
      >
    </p>
    <p>Ghi chú: <strong>${note}</strong></p>

    <form method="post" action="/booking-receptionist/step-4">
      <input type="hidden" name="email" value="${patient.user.email}" />
      <input type="hidden" name="doctorId" value="${doctor.doctorID}" />
      <input
        type="hidden"
        name="specializationId"
        value="${specializationId}"
      />
      <input type="hidden" name="slotId" value="${slot.slotID}" />
      <input
        type="hidden"
        name="appointmentTypeId"
        value="${appointmentType.appointmentTypeID}"
      />
      <input type="hidden" name="note" value="${note}" />
      <p>Phương thức thanh toán:</p>
      <label>
        <input type="radio" name="paymentMethod" value="CASH" checked />
        Thanh toán tiền mặt </label
      ><br />
      <label>
        <input type="radio" name="paymentMethod" value="PAYOS" />
        Thanh toán qua PayOS
      </label>
      <button type="submit">Xác nhận đặt lịch</button>
    </form>
  </body>
</html>
