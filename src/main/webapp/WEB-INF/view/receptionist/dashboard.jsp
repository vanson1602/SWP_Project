<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Dashboard | Receptionist</title>
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <style>
                body {
                    background-color: #f8fafc;
                }

                .tab-content {
                    margin-top: 20px;
                }

                .conversation-item {
                    cursor: pointer;
                    transition: background-color 0.2s ease-in-out;
                }

                .conversation-item:hover {
                    background-color: #e3f2fd;
                }

                .avatar {
                    width: 45px;
                    height: 45px;
                    background-color: #dbeafe;
                    border-radius: 50%;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    font-weight: bold;
                    color: #0d6efd;
                    margin-right: 15px;
                }

                .no-conversations {
                    text-align: center;
                    color: #777;
                    padding: 40px 0;
                }
            </style>
        </head>

        <body>

            <div class="container mt-5 bg-white p-4 rounded shadow">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3>📋 Dashboard - Lễ tân</h3>
                    <button class="btn btn-danger" onclick="window.location.href='/logout'">Đăng xuất</button>
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
                    <div class="tab-pane fade show active" id="conversations" role="tabpanel">
                        <c:if test="${empty conversations}">
                            <div class="no-conversations">
                                Không có cuộc hội thoại nào.
                            </div>
                        </c:if>
                        <c:forEach items="${conversations}" var="conv">
                            <div class="d-flex align-items-center p-3 border rounded mb-2 conversation-item"
                                onclick="window.location.href='/chat/conversation/${conv.id}'">
                                <div class="avatar">
                                    ${conv.receiver.userID == currentUser.userID ? conv.sender.firstName.charAt(0) :
                                    conv.receiver.firstName.charAt(0)}
                                </div>
                                <div>
                                    <div class="fw-bold">
                                        ${conv.receiver.userID == currentUser.userID ?
                                        conv.sender.firstName.concat(' ').concat(conv.sender.lastName) :
                                        conv.receiver.firstName.concat(' ').concat(conv.receiver.lastName)}
                                    </div>
                                    <c:if test="${not empty conv.messages}">
                                        <div class="text-muted small">
                                            ${conv.messages[conv.messages.size()-1].content}
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Đặt lịch tab -->
                    <div class="tab-pane fade" id="appointment" role="tabpanel">
                        <p class="mt-3">👩‍⚕️ Tại đây bạn có thể hỗ trợ đặt lịch khám cho bệnh nhân.</p>
                        <button class="btn btn-primary" onclick="window.location.href='/appointment/create'">+ Tạo lịch
                            hẹn mới</button>
                    </div>

                </div>
            </div>

        </body>

        </html>