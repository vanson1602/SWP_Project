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
          color: #1a1a1a;
        }

        .confirm-box {
          border-radius: 16px;
          padding: 40px;
          max-width: 720px;
          margin: 40px auto;
          background: #ffffff;
          box-shadow: 0 12px 30px rgba(0, 0, 0, 0.05);
          border-left: 6px solid #3cb371;
          transition: all 0.3s ease;
        }

        .confirm-box h2 {
          text-align: center;
          color: #2e8b57;
          font-size: 26px;
          margin-bottom: 30px;
          font-weight: 600;
        }

        .confirm-box p {
          font-size: 17px;
          margin: 14px 0;
          color: #333;
          line-height: 1.6;
        }

        .confirm-box strong {
          color: #2e8b57;
        }

        .payment-methods {
          margin: 30px 0;
        }

        .payment-methods p {
          font-weight: 600;
          margin-bottom: 10px;
          color: #2e8b57;
        }

        .payment-methods label {
          display: inline-block;
          background-color: #f0fdf4;
          border: 2px solid #c6f6d5;
          padding: 10px 16px;
          border-radius: 10px;
          margin-right: 15px;
          cursor: pointer;
          font-size: 15px;
          transition: 0.3s ease;
          color: #1a1a1a;
        }

        .payment-methods input[type="radio"] {
          margin-right: 6px;
        }

        .payment-methods label:hover {
          background-color: #d9fbe6;
          border-color: #a0e6b1;
        }

        .confirm-actions {
          text-align: center;
          margin-top: 35px;
        }

        .confirm-actions button {
          padding: 14px 32px;
          font-size: 16px;
          border: none;
          border-radius: 10px;
          background-color: #2e8b57;
          color: white;
          cursor: pointer;
          font-weight: 600;
          box-shadow: 0 6px 16px rgba(46, 139, 87, 0.2);
          transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .confirm-actions button:hover {
          background-color: #24824d;
          transform: translateY(-2px);
        }

        .alert {
          background-color: #ffe5e5;
          color: #b30000;
          padding: 14px 20px;
          border-left: 5px solid #b30000;
          border-radius: 8px;
          margin-bottom: 20px;
          font-weight: 500;
        }

        .action-buttons {
          display: flex;
          justify-content: center;
          gap: 20px;
          margin-top: 40px;
        }

        .back-button,
        .continue-button {
          padding: 12px 28px;
          font-size: 15px;
          font-weight: 500;
          border-radius: 10px;
          border: none;
          text-decoration: none;
          cursor: pointer;
          transition: all 0.3s ease;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        .back-button {
          background-color: #f1f5f9;
          color: #334155;
          border: 1px solid #cbd5e1;
        }

        .back-button:hover {
          background-color: #e2e8f0;
          transform: translateY(-1px);
        }

        .continue-button {
          background-color: #3b82f6;
          color: white;
          border: 1px solid #2563eb;
        }

        .continue-button:hover {
          background-color: #2563eb;
          transform: translateY(-1px);
        }


        @media (max-width: 600px) {
          .confirm-box {
            padding: 25px;
          }

          .payment-methods label {
            display: block;
            margin-bottom: 10px;
          }

          .confirm-actions button {
            width: 100%;
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
        <p>Thời gian: <strong>${date} | ${startTime} - ${endTime}</strong></p>
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
            <a href="javascript:history.back()" class="back-button">← Quay lại</a>
            <button type="submit" class="btn-confirm">Xác nhận đặt lịch</button>
          </div>
        </form>
      </div>
    </body>

    </html>