<%@page contentType="text/html" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
      <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
          <meta charset="UTF-8" />
          <meta name="viewport" content="width=device-width, initial-scale=1.0" />
          <title>Danh sách bệnh nhân</title>
          <style>
            body {
              font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
              background-color: #f8fafc;
              margin: 0;
              padding: 20px;
            }

            h2 {
              text-align: center;
              color: #1e3a8a;
              margin-bottom: 30px;
            }

            .search-form {
              text-align: center;
              margin-bottom: 20px;
            }

            .search-form input[type="text"] {
              padding: 10px;
              width: 250px;
              border: 1px solid #ccc;
              border-radius: 6px;
            }

            .search-form button {
              padding: 10px 15px;
              background-color: #2563eb;
              border: none;
              color: white;
              border-radius: 6px;
              margin-left: 8px;
              cursor: pointer;
            }

            .search-form a {
              margin-left: 10px;
              text-decoration: none;
              color: #2563eb;
            }

            .search-form button:hover {
              background-color: #1d4ed8;
            }

            .table-container {
              max-width: 1100px;
              margin: 0 auto;
              overflow-x: auto;
            }

            table {
              width: 100%;
              border-collapse: collapse;
              background-color: #ffffff;
              border-radius: 12px;
              overflow: hidden;
              box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            }

            th,
            td {
              padding: 16px 20px;
              text-align: left;
              border-bottom: 1px solid #e2e8f0;
            }

            th {
              background-color: #2563eb;
              color: white;
              font-weight: bold;
              text-transform: uppercase;
              font-size: 14px;
            }

            tr:hover {
              background-color: #f1f5f9;
            }

            td {
              color: #334155;
            }

            .back-button {
              display: inline-block;
              margin-top: 30px;
              padding: 10px 20px;
              background-color: #2563eb;
              color: white;
              text-decoration: none;
              border-radius: 6px;
              transition: background-color 0.3s ease;
            }

            .back-button:hover {
              background-color: #1d4ed8;
            }

            .pagination {
              text-align: center;
              margin-top: 25px;
            }

            .pagination a {
              display: inline-block;
              margin: 0 4px;
              padding: 8px 14px;
              border-radius: 6px;
              color: #2563eb;
              text-decoration: none;
              border: 1px solid #cbd5e1;
              background-color: white;
              cursor: pointer;
            }

            .pagination a:hover {
              background-color: #e0f2fe;
            }

            .pagination .active-page {
              background-color: #2563eb;
              color: white;
              font-weight: bold;
              border-color: #2563eb;
            }

            .error-message {
              color: red;
              text-align: center;
              margin-bottom: 15px;
            }
          </style>
        </head>

        <body>
          <h2>Danh sách bệnh nhân</h2>

          <form method="get" action="/booking-receptionist/searchPatient" class="search-form">
            <input type="text" name="nameOrEmail" placeholder="Nhập tên hoặc email" value="${nameOrEmail}" />
            <button type="submit">🔍 Tìm kiếm</button>
            <a href="/booking-receptionist/patientInfor">Tất cả bệnh nhân</a>
          </form>

          <c:if test="${not empty error}">
            <p class="error-message">${error}</p>
          </c:if>

          <div class="table-container">
            <table>
              <thead>
                <tr>
                  <th>UserName</th>
                  <th>Họ và tên</th>
                  <th>Email</th>
                  <th>Điện thoại</th>
                  <th>Địa chỉ</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="patient" items="${listPatient}">
                  <tr>
                    <td>${patient.username}</td>
                    <td>${patient.fullName}</td>
                    <td>${patient.email}</td>
                    <td>${patient.phone}</td>
                    <td>${patient.address}</td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>

          <div id="pagination" class="pagination"></div>



          <script>
            const rowsPerPage = 7;
            let currentPage = 1;

            const table = document.querySelector("table tbody");
            const rows = table.querySelectorAll("tr");
            const totalPages = Math.ceil(rows.length / rowsPerPage);

            function showPage(page) {
              currentPage = page;
              const start = (page - 1) * rowsPerPage;
              const end = start + rowsPerPage;

              rows.forEach((row, index) => {
                row.style.display = index >= start && index < end ? "" : "none";
              });

              renderPagination();
            }

            function renderPagination() {
              const pagination = document.getElementById("pagination");
              pagination.innerHTML = "";

              if (totalPages <= 1) return;

              if (currentPage > 1) {
                const prev = document.createElement("a");
                prev.href = "#";
                prev.innerText = "« Trước";
                prev.onclick = () => showPage(currentPage - 1);
                pagination.appendChild(prev);
              }

              for (let i = 1; i <= totalPages; i++) {
                const pageLink = document.createElement("a");
                pageLink.href = "#";
                pageLink.innerText = i;
                if (i === currentPage) pageLink.className = "active-page";
                pageLink.onclick = () => showPage(i);
                pagination.appendChild(pageLink);
              }

              if (currentPage < totalPages) {
                const next = document.createElement("a");
                next.href = "#";
                next.innerText = "Sau »";
                next.onclick = () => showPage(currentPage + 1);
                pagination.appendChild(next);
              }
            }

            showPage(1);
          </script>
        </body>

        </html>