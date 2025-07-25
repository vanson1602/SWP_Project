<%@page contentType="text/html" pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib
uri="http://www.springframework.org/tags/form" prefix="form" %> <%@ taglib
prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Lịch sử khám bệnh</title>
    <link
      href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap"
      rel="stylesheet"
    />
    <style>
      body {
        font-family: "Inter", sans-serif;
        background: #f8fafc;
        padding: 40px 20px;
        color: #333;
      }

      h2 {
        text-align: center;
        font-size: 30px;
        color: #1e3a8a;
        margin-bottom: 40px;
      }

      table {
        width: 100%;
        border-collapse: collapse;
        background: #fff;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.06);
      }

      th,
      td {
        padding: 14px 16px;
        text-align: left;
        font-size: 14px;
      }

      th {
        background-color: #1e3a8a;
        color: white;
        font-weight: 600;
      }

      tbody tr:nth-child(even) {
        background-color: #f1f5f9;
      }

      .status {
        padding: 4px 10px;
        border-radius: 999px;
        font-size: 13px;
        font-weight: 600;
        display: inline-block;
        text-transform: capitalize;
      }

      .status-pending {
        background: #fff4e5;
        color: #d97706;
      }

      .status-confirmed {
        background: #dcfce7;
        color: #15803d;
      }

      .status-completed {
        background: #e0f2fe;
        color: #0284c7;
      }

      .status-cancelled {
        background: #fee2e2;
        color: #b91c1c;
      }

      a.link {
        color: #1d4ed8;
        text-decoration: none;
        font-weight: 500;
      }

      a.link:hover {
        text-decoration: underline;
      }

      .no-data {
        text-align: center;
        font-style: italic;
        margin-top: 50px;
        color: #777;
      }

      .back-button {
        display: block;
        margin: 40px auto 0;
        background: #2563eb;
        color: white;
        padding: 10px 24px;
        border-radius: 10px;
        text-decoration: none;
        font-weight: 500;
        width: fit-content;
        transition: background 0.3s ease;
      }

      .back-button:hover {
        background: #1e40af;
      }

      @media (max-width: 768px) {
        table,
        thead,
        tbody,
        th,
        td,
        tr {
          display: block;
        }

        thead {
          display: none;
        }

        tr {
          margin-bottom: 16px;
          background: white;
          padding: 12px;
          border-radius: 10px;
        }

        td {
          padding: 10px;
          border: none;
          position: relative;
        }

        td::before {
          content: attr(data-label);
          position: absolute;
          left: 10px;
          font-weight: bold;
          color: #475569;
        }

        td {
          padding-left: 120px;
        }
      }
    </style>
  </head>

  <body>
    <h2>Lịch sử khám bệnh của bạn</h2>

    <c:if test="${not empty appointment}">
      <div style="overflow-x: auto">
        <table>
          <thead>
            <tr>
              <th>#</th>
              <th>Ngày khám</th>
              <th>Thời gian</th>
              <th>Thể loại</th>
              <th>Bác sĩ</th>
              <th>Trạng thái</th>
              <th>Ghi chú</th>
              <th>Bệnh án</th>
              <th>Đơn thuốc</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="a" items="${appointment}" varStatus="i">
              <tr>
                <td data-label="#">${a.appointmentNumber}</td>
                <td data-label="Ngày khám">
                  ${a.appointmentDate.format(formatter)}
                </td>
                <td data-label="Thời gian">
                  ${a.appointmentDate.format(startTime)} - ${endTimes[i.index]}
                </td>
                <td data-label="Thể loại">${a.appointmentType.typeName}</td>
                <td data-label="Bác sĩ">${a.doctor.user.fullName}</td>
                <td data-label="Trạng thái">
                  <span class="status status-${a.status.toLowerCase()}"
                    >${a.status}</span
                  >
                </td>
                <td data-label="Ghi chú">
                  <c:choose>
                    <c:when test="${not empty a.patientNotes}"
                      >${a.patientNotes}</c:when
                    >
                    <c:otherwise
                      ><i style="color: #aaa">Không có</i></c:otherwise
                    >
                  </c:choose>
                </td>
                <td data-label="Bệnh án">
                  <a
                    class="link"
                    href="/medical-history/medical-record/${a.appointmentID}"
                    >Xem</a
                  >
                </td>
                <td data-label="Đơn thuốc">
                  <a
                    class="link"
                    href="/medical-history/prescription/${a.appointmentID}"
                    >Xem</a
                  >
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
        <div
          class="pagination"
          id="pagination"
          style="margin-top: 20px; text-align: center"
        ></div>
      </div>
    </c:if>

    <c:if test="${empty appointment}">
      <p class="no-data">Không có lịch sử khám bệnh nào.</p>
    </c:if>

    <a href="javascript:history.back()" class="back-button">← Quay lại</a>
  </body>
  <script>
    const rowsPerPage = 5;
    const rows = document.querySelectorAll("tbody tr");
    const pagination = document.getElementById("pagination");

    function displayPage(page) {
      const start = (page - 1) * rowsPerPage;
      const end = start + rowsPerPage;
      rows.forEach((row, index) => {
        row.style.display = index >= start && index < end ? "" : "none";
      });

      const buttons = pagination.querySelectorAll("button");
      buttons.forEach((btn) => btn.classList.remove("active"));
      if (buttons[page - 1]) buttons[page - 1].classList.add("active");
    }

    function setupPagination() {
      const totalPages = Math.ceil(rows.length / rowsPerPage);
      pagination.innerHTML = ""; // Clear old buttons
      for (let i = 1; i <= totalPages; i++) {
        const btn = document.createElement("button");
        btn.textContent = i;
        btn.style.margin = "0 4px";
        btn.style.padding = "6px 12px";
        btn.style.border = "none";
        btn.style.borderRadius = "6px";
        btn.style.background = "#1e3a8a";
        btn.style.color = "white";
        btn.style.cursor = "pointer";
        btn.addEventListener("click", () => displayPage(i));
        pagination.appendChild(btn);
      }
      displayPage(1);
    }

    setupPagination();
  </script>
</html>
