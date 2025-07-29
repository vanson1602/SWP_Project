<%@page contentType="text/html" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
      <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

        <!DOCTYPE html>
        <html lang="en">

        <head>
          <meta charset="UTF-8" />
          <meta name="viewport" content="width=device-width, initial-scale=1.0" />
          <title>Patient History Medical Record</title>
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
            <div class="card">
              <h1>Hồ sơ bệnh án</h1>

              <c:if test="${examination != null}">
                <div class="section-title">Dấu hiệu sinh tồn</div>
                <div class="info">
                  <span>Huyết áp:</span> ${examination.bloodPressureDiastolic}/3 mmHg
                </div>
                <div class="info">
                  <span>Nhịp tim:</span> ${examination.heartRate} bpm
                </div>
                <div class="info">
                  <span>Nhiệt độ:</span> ${examination.temperature}
                </div>
                <div class="info">
                  <span>Nhịp thở:</span> ${examination.respiratoryRate} lần/phút
                </div>
                <div class="info">
                  <span>SpO2:</span> ${examination.oxygenSaturation}
                </div>

                <div class="section-title">Tình trạng bệnh</div>
                <div class="info">
                  <span>Triệu chứng:</span> ${examination.symptoms}
                </div>
                <div class="info">
                  <span>Khám Lâm Sàng:</span> ${examination.physicalExamination}
                </div>
                <div class="info">
                  <span>Chẩn đoán:</span> ${examination.diseaseDiagnosis}
                </div>
                <div class="info">
                  <span>Ngày tái khám:</span>
                  <c:choose>
                    <c:when test="${examination.followUpDate != null}">
                      ${examination.followUpDate.format(date)}
                    </c:when>
                    <c:otherwise>Không có</c:otherwise>
                  </c:choose>
                </div>
              </c:if>

              <c:if test="${examination == null}">
                <div class="info" style="color: red; font-weight: bold">
                  Không có hồ sơ bệnh án
                </div>
              </c:if>

              <a href="javascript:history.back()" class="back-button">← Quay lại</a>
            </div>
          </div>

          <!-- Include footer -->
          <jsp:include page="../shared/footer.jsp" />
        </body>

        </html>