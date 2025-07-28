<%@page contentType="text/html" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
      <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

        <!DOCTYPE html>
        <html lang="en">

        <head>
          <meta charset="UTF-8" />
          <meta name="viewport" content="width=device-width, initial-scale=1.0" />
          <title>Patient History</title>
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
            <h2>Lịch sử khám bệnh của bạn</h2>

            <!-- Test button for notifications -->
            <div class="mb-3">
              <button type="button" class="btn btn-warning btn-sm" onclick="createTestNotification()">
                <i class="bi bi-bell"></i> Tạo thông báo test
              </button>
              <button type="button" class="btn btn-info btn-sm ms-2" onclick="createSimpleTestNotification()">
                <i class="bi bi-bell"></i> Tạo thông báo test đơn giản
              </button>
            </div>

            <c:if test="${not empty appointment}">
              <div class="card-container">
                <c:forEach var="a" items="${appointment}" varStatus="i">
                  <div class="card">
                    <h3>Lịch hẹn: ${a.appointmentNumber}</h3>
                    <p>
                      <span class="label">Ngày khám:</span>
                      ${a.appointmentDate.format(formatter)}
                    </p>
                    <p>
                      <span class="label">thời gian:</span>
                      ${a.appointmentDate.format(startTime)} - ${endTimes[i.index]}
                    </p>
                    <p>
                      <span class="label">Thể loại:</span> ${a.appointmentType.typeName}
                    </p>
                    <p><span class="label">Bác sĩ:</span> ${a.doctor.user.fullName}</p>
                    <p><span class="label">Trạng thái:</span> ${a.status}</p>
                    <p>
                      <span class="label">Ghi chú bệnh nhân:</span>
                      <c:choose>
                        <c:when test="${not empty a.patientNotes}">${a.patientNotes}</c:when>
                        <c:otherwise><i style="color: #aaa">Không có</i></c:otherwise>
                      </c:choose>
                    </p>
                    <p>
                      <span class="label">Hồ sơ bệnh án: </span><a
                        href="/medical-history/medical-record/${a.appointmentID}">chi tiết</a>
                    </p>
                    <p>
                      <span class="label">Đơn thuốc khám bệnh: </span><a
                        href="/medical-history/prescription/${a.appointmentID}">chi tiết</a>
                    </p>
                  </div>
                </c:forEach>
              </div>
            </c:if>

            <c:if test="${empty appointment}">
              <p class="no-data">Không có lịch sử khám bệnh nào.</p>
            </c:if>
            <a href="javascript:history.back()" class="back-button">← Quay lại</a>
          </div>

          <!-- Include footer -->
          <jsp:include page="../shared/footer.jsp" />

          <!-- Test notification function -->
          <script>
            // Function to create a test notification
            async function createTestNotification() {
              try {
                console.log('=== CREATING TEST NOTIFICATION ===');

                // Get CSRF token
                const csrfToken = document.querySelector("meta[name='_csrf']")?.getAttribute("content");
                const csrfHeader = document.querySelector("meta[name='_csrf_header']")?.getAttribute("content");

                // Create headers
                const headers = new Headers();
                headers.append('Content-Type', 'application/json');
                headers.append('Accept', 'application/json');
                if (csrfHeader && csrfToken) {
                  headers.append(csrfHeader, csrfToken);
                }

                const response = await fetch('/api/notifications/create-test', {
                  credentials: 'include',
                  mode: 'same-origin',
                  method: 'POST',
                  headers: headers
                });

                console.log('Create test response status:', response.status);
                console.log('Create test response ok:', response.ok);

                if (!response.ok) {
                  throw new Error('Failed to create test notification');
                }

                const data = await response.json();
                console.log('Create test response data:', data);

                alert('Thông báo test đã được tạo thành công!');

                // Refresh notifications if available
                if (typeof updateUnreadCount === 'function') {
                  await updateUnreadCount();
                }
                if (typeof loadNotifications === 'function') {
                  await loadNotifications(true);
                }
              } catch (error) {
                console.error('Error creating test notification:', error);
                alert('Lỗi khi tạo thông báo test: ' + error.message);
              }
            }

            // Function to create a simple test notification
            async function createSimpleTestNotification() {
              try {
                console.log('=== CREATING SIMPLE TEST NOTIFICATION ===');

                // Get CSRF token
                const csrfToken = document.querySelector("meta[name='_csrf']")?.getAttribute("content");
                const csrfHeader = document.querySelector("meta[name='_csrf_header']")?.getAttribute("content");

                // Create headers
                const headers = new Headers();
                headers.append('Content-Type', 'application/json');
                headers.append('Accept', 'application/json');
                if (csrfHeader && csrfToken) {
                  headers.append(csrfHeader, csrfToken);
                }

                const response = await fetch('/api/notifications/create-test-simple', {
                  credentials: 'include',
                  mode: 'same-origin',
                  method: 'POST',
                  headers: headers
                });

                console.log('Create simple test response status:', response.status);
                console.log('Create simple test response ok:', response.ok);

                if (!response.ok) {
                  throw new Error('Failed to create simple test notification');
                }

                const data = await response.json();
                console.log('Create simple test response data:', data);

                alert('Thông báo test đơn giản đã được tạo thành công! ID: ' + data.notificationId);

                // Refresh notifications if available
                if (typeof updateUnreadCount === 'function') {
                  await updateUnreadCount();
                }
                if (typeof loadNotifications === 'function') {
                  await loadNotifications(true);
                }
              } catch (error) {
                console.error('Error creating simple test notification:', error);
                alert('Lỗi khi tạo thông báo test đơn giản: ' + error.message);
              }
            }
          </script>
        </body>

        </html>