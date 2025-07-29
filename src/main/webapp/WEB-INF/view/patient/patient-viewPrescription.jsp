<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

    <!DOCTYPE html>
    <html lang="en">

    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>Chi tiết Đơn thuốc</title>
      <!-- Include header with notifications -->
      <jsp:include page="../shared/head.jsp" />
      <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/base.css">
      <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/homepage.css">

      <!-- Required scripts -->
      <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/locale/vi.js"></script>
      <script defer src="/resources/js/notifications.js"></script>
    </head>

    <body>
      <!-- Include header with notifications -->
      <jsp:include page="../shared/header.jsp" />

      <div class="container mt-4">
        <h2>Chi tiết Đơn thuốc</h2>

        <c:if test="${not empty errorMessage}">
          <p class="error-message">${errorMessage}</p>
        </c:if>

        <c:if test="${not empty prescriptions}">
          <table class="table table-striped">
            <thead>
              <tr>
                <th>Tên thuốc</th>
                <th>Số lượng</th>
                <th>Liều lượng</th>
                <th>Thời gian sử dụng</th>
                <th>Hướng dẫn</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="p" items="${prescriptions}">
                <tr>
                  <td>${p.medication.medicationName}</td>
                  <td>${p.quantity}</td>
                  <td>${p.dosage}</td>
                  <td>${p.frequency}</td>
                  <td>${p.instructions}</td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </c:if>

        <a href="javascript:history.back()" class="btn btn-primary">← Quay lại</a>
      </div>

      <!-- Include footer -->
      <jsp:include page="../shared/footer.jsp" />
    </body>

    </html>