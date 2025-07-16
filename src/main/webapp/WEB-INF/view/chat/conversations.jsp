<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Conversations | HealthCare+</title>
            <link href="<c:url value='/resources/css/base.css'/>" rel="stylesheet">
          
            <style>
                body {
                    font-family: 'Segoe UI', sans-serif;
                    background-color: #f8fafc;
                    margin: 0;
                    padding: 0;
                }

                .container {
                    max-width: 900px;
                    margin: 40px auto;
                    background: white;
                    padding: 30px;
                    border-radius: 10px;
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                }

                .header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 25px;
                }

                .header h2 {
                    color: #0d6efd;
                }

                .header .buttons {
                    display: flex;
                    gap: 10px;
                }

                .button {
                    background-color: #0d6efd;
                    color: white;
                    padding: 8px 14px;
                    border: none;
                    border-radius: 6px;
                    cursor: pointer;
                    font-size: 14px;
                    transition: background-color 0.2s;
                }

                .button:hover {
                    background-color: #0b5ed7;
                }

                .conversation-item {
                    display: flex;
                    align-items: center;
                    padding: 15px;
                    margin-bottom: 12px;
                    border-radius: 8px;
                    background-color: #f1f5f9;
                    cursor: pointer;
                    transition: background-color 0.2s;
                }

                .conversation-item:hover {
                    background-color: #e3f2fd;
                }

                .avatar {
                    width: 50px;
                    height: 50px;
                    border-radius: 50%;
                    background-color: #dbeafe;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 20px;
                    font-weight: bold;
                    color: #0d6efd;
                    margin-right: 15px;
                }

                .user-info {
                    flex: 1;
                }

                .user-name {
                    font-weight: bold;
                    margin-bottom: 4px;
                    font-size: 16px;
                    color: #222;
                }

                .last-message {
                    font-size: 14px;
                    color: #666;
                    white-space: nowrap;
                    overflow: hidden;
                    text-overflow: ellipsis;
                }

                .no-conversations {
                    text-align: center;
                    color: #999;
                    padding: 40px 0;
                }
            </style>
        </head>

        <body>

            <div class="container">
                <div class="header">
                    <h2>🗨️ Cuộc hội thoại</h2>
                    <div class="buttons">
                        <button class="button" onclick="startChatWithReceptionist()">Chat với lễ tân</button>
                        <button class="button" onclick="window.location.href='/'">Trang chủ</button>
                    </div>
                </div>

                <c:if test="${empty conversations}">
                    <div class="no-conversations">
                        Bạn chưa có cuộc hội thoại nào.<br>
                        Hãy bắt đầu trò chuyện với lễ tân!
                    </div>
                </c:if>

                <c:forEach items="${conversations}" var="conv">
                    <div class="conversation-item" onclick="location.href='/chat/conversation/${conv.id}'">
                        <div class="avatar">
                            ${conv.receiver.userID == currentUser.userID ? conv.sender.firstName.charAt(0) :
                            conv.receiver.firstName.charAt(0)}
                        </div>
                        <div class="user-info">
                            <div class="user-name">
                                ${conv.receiver.userID == currentUser.userID ?
                                conv.sender.firstName.concat(' ').concat(conv.sender.lastName) :
                                conv.receiver.firstName.concat(' ').concat(conv.receiver.lastName)}
                            </div>
                            <c:if test="${not empty conv.messages}">
                                <div class="last-message">
                                    ${conv.messages[conv.messages.size()-1].content}
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>


            <script src="<c:url value='/resources/js/chat.js'/>"></script>
        </body>

        </html>