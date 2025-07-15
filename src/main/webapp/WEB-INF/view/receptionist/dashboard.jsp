<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Dashboard | Receptionist</title>
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
            <link rel="stylesheet" href="/resources/css/receptionist-dashboard.css">
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        </head>

        <body>
            <div class="dashboard-container">
                <div class="dashboard-header">
                    <h3 class="dashboard-title">📋 Dashboard - Lễ tân</h3>
                    <button class="logout-btn" onclick="window.location.href='/logout'">Đăng xuất</button>
                </div>

                <ul class="nav nav-tabs" id="dashboardTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="conversations-tab" data-bs-toggle="tab"
                            data-bs-target="#conversations" type="button" role="tab">
                            💬 Cuộc hội thoại
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="appointment-tab" data-bs-toggle="tab" data-bs-target="#appointment"
                            type="button" role="tab">
                            📅 Đặt lịch
                        </button>
                    </li>
                </ul>

                <div class="tab-content" id="dashboardTabsContent">
                    <!-- Cuộc hội thoại tab -->
                    <div class="tab-pane fade show active conversation-list" id="conversations" role="tabpanel">
                        <c:if test="${empty conversations}">
                            <div class="no-conversations">
                                <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" fill="currentColor"
                                    class="bi bi-chat-dots mb-3" viewBox="0 0 16 16">
                                    <path
                                        d="M5 8a1 1 0 1 1-2 0 1 1 0 0 1 2 0m4 0a1 1 0 1 1-2 0 1 1 0 0 1 2 0m3 1a1 1 0 1 0 0-2 1 1 0 0 0 0 2" />
                                    <path
                                        d="m2.165 15.803.02-.004c1.83-.363 2.948-.842 3.468-1.105A9.06 9.06 0 0 0 8 15c4.418 0 8-3.134 8-7s-3.582-7-8-7-8 3.134-8 7c0 1.76.743 3.37 1.97 4.6a10.437 10.437 0 0 1-.524 2.318l-.003.011a10.722 10.722 0 0 1-.244.637c-.079.186.074.394.273.362a21.673 21.673 0 0 0 .693-.125zm.8-3.108a1 1 0 0 0-.287-.801C1.618 10.83 1 9.468 1 8c0-3.192 3.004-6 7-6s7 2.808 7 6c0 3.193-3.004 6-7 6a8.06 8.06 0 0 1-2.088-.272 1 1 0 0 0-.711.074c-.387.196-1.24.57-2.634.893a10.97 10.97 0 0 0 .398-2" />
                                </svg>
                                <div>Không có cuộc hội thoại nào.</div>
                            </div>
                        </c:if>
                        <c:forEach items="${conversations}" var="conv">
                            <div class="conversation-item d-flex align-items-center"
                                onclick="window.location.href='/chat/conversation/${conv.id}'">
                                <div class="avatar">
                                    ${conv.receiver.userID == currentUser.userID ? conv.sender.firstName.charAt(0) :
                                    conv.receiver.firstName.charAt(0)}
                                </div>
                                <div class="conversation-content">
                                    <div class="conversation-name">
                                        ${conv.receiver.userID == currentUser.userID ?
                                        conv.sender.firstName.concat(' ').concat(conv.sender.lastName) :
                                        conv.receiver.firstName.concat(' ').concat(conv.receiver.lastName)}
                                    </div>
                                    <c:if test="${not empty conv.messages}">
                                        <div class="conversation-message">
                                            ${conv.messages[conv.messages.size()-1].content}
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Đặt lịch tab -->
                    <div class="tab-pane fade" id="appointment" role="tabpanel">
                        <div class="appointment-section">
                            <p class="appointment-description">👩‍⚕️ Tại đây bạn có thể hỗ trợ đặt lịch khám cho bệnh
                                nhân.</p>

                            <div class="appointment-actions">
                                <button class="create-appointment-btn"
                                    onclick="window.location.href='/appointment/create'">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                                        class="bi bi-plus-lg" viewBox="0 0 16 16">
                                        <path
                                            d="M8 2a.5.5 0 0 1 .5.5v5h5a.5.5 0 0 1 0 1h-5v5a.5.5 0 0 1-1 0v-5h-5a.5.5 0 0 1 0-1h5v-5A.5.5 0 0 1 8 2" />
                                    </svg>
                                    Tạo lịch hẹn mới
                                </button>

                                <div class="action-links">
                                    <a href="/booking-receptionist/step-1" class="action-link">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                            fill="currentColor" class="bi bi-calendar-plus me-2" viewBox="0 0 16 16">
                                            <path
                                                d="M8 7a.5.5 0 0 1 .5.5V9H10a.5.5 0 0 1 0 1H8.5v1.5a.5.5 0 0 1-1 0V10H6a.5.5 0 0 1 0-1h1.5V7.5A.5.5 0 0 1 8 7" />
                                            <path
                                                d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5M1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4z" />
                                        </svg>
                                        Đặt lịch cho bệnh nhân
                                    </a>
                                    <a href="/booking-receptionist/patientInfor" class="action-link">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                            fill="currentColor" class="bi bi-person me-2" viewBox="0 0 16 16">
                                            <path
                                                d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664z" />
                                        </svg>
                                        Xem thông tin bệnh nhân
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </body>

        </html>