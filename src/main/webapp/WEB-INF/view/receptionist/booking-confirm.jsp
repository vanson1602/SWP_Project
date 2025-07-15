<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
  <%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
      <title>Xác nhận đặt lịch</title>
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <style>
        body {
          font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
          background-color: #f4f6f9;
          padding: 20px;
          margin: 0;
        }

        .confirm-box {
          border: 1px solid #ddd;
          border-radius: 12px;
          padding: 30px;
          max-width: 700px;
          margin: 40px auto;
          background-color: #ffffff;
          box-shadow: 0 8px 20px rgba(0, 0, 0, 0.05);
        }

        .confirm-box h2 {
          text-align: center;
          color: #007bff;
          margin-bottom: 30px;
        }

        .confirm-box p {
          font-size: 17px;
          margin: 12px 0;
          color: #333;
        }

        .confirm-box strong {
          color: #007bff;
        }

        .confirm-box label {
          font-size: 16px;
          margin-right: 15px;
          display: inline-block;
          margin-top: 10px;
        }

        .payment-methods {
          margin: 20px 0;
        }

        .confirm-actions {
          text-align: center;
          margin-top: 30px;
        }

        .confirm-actions button {
          padding: 12px 30px;
          font-size: 16px;
          border: none;
          border-radius: 8px;
          cursor: pointer;
          transition: 0.3s;
        }

        .btn-confirm {
          background-color: #007bff;
          color: white;
        }

        .btn-confirm:hover {
          background-color: #0056b3;
        }

        .btn-cancel {
          background-color: #ccc;
          margin-left: 10px;
        }

        .alert {
          background-color: #f8d7da;
          color: #721c24;
          padding: 12px 20px;
          border-radius: 6px;
          margin-bottom: 20px;
        }

        @media (max-width: 600px) {
          .confirm-box {
            padding: 20px;
          }

          .confirm-actions button {
            width: 100%;
            margin-bottom: 10px;
          }
        }
      </style>
    </head>

    <body>
      <div class="confirm-box">
        <c:if test="${not empty error}">
          <div class="alert">${error}</div>
        </c:if>

        <h2>Xác nhận lịch khám</h2>

        <p>Bệnh nhân: <strong>${patient.user.username}</strong></p>
        <p>Bác sĩ: <strong>${doctor.user.username}</strong></p>
        <p>Thời gian: <strong>${slot.startTime} - ${slot.endTime}</strong></p>
        <p>Loại cuộc hẹn: <strong>${appointmentType.typeName} (${doctor.consultationFee} VND)</strong></p>
        <p>Ghi chú: <strong>${note}</strong></p>

        <form method="post" action="/booking-receptionist/step-4">
          <input type="hidden" name="email" value="${patient.user.email}" />
          <input type="hidden" name="doctorId" value="${doctor.doctorID}" />
          <input type="hidden" name="specializationId" value="${specializationId}" />
          <input type="hidden" name="slotId" value="${slot.slotID}" />
          <input type="hidden" name="appointmentTypeId" value="${appointmentType.appointmentTypeID}" />
          <input type="hidden" name="note" value="${note}" />

          <div class="payment-methods">
            <p>Phương thức thanh toán:</p>
            <label>
              <input type="radio" name="paymentMethod" value="CASH" checked />
              Thanh toán tiền mặt
            </label>
            <label>
              <input type="radio" name="paymentMethod" value="PAYOS" />
              Thanh toán qua PayOS
            </label>
          </div>

          <div class="confirm-actions">
            <button type="submit" class="btn-confirm">Xác nhận đặt lịch</button>
          </div>
        </form>
      </div>
    </body>

    </html>