<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Chat</title>
                <!-- External libraries -->
                <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/locale/vi.js"></script>
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />

                <!-- Chat User Data (hidden) -->
                <div id="chatData" hidden data-user-id="${currentUser.userID}" data-username="${currentUser.username}"
                    data-fullname="${currentUser.fullName}" data-role="${currentUser.role}"
                    data-conversation-id="${conversation.id != null ? conversation.id : ''}"
                    data-sender-id="${conversation.sender.userID}"
                    data-sender-username="${conversation.sender.username}"
                    data-sender-fullname="${conversation.sender.fullName}"
                    data-receiver-id="${conversation.receiver.userID}"
                    data-receiver-username="${conversation.receiver.username}"
                    data-receiver-fullname="${conversation.receiver.fullName}">
                </div>

                <style>
                    body {
                        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
                        margin: 0;
                        padding: 20px;
                        background-color: #f0f2f5;
                    }

                    .chat-container {
                        max-width: 900px;
                        margin: 0 auto;
                        background-color: white;
                        border-radius: 12px;
                        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.05);
                        display: flex;
                        flex-direction: column;
                        min-height: 300px;
                        max-height: 90vh;
                    }


                    .chat-header {
                        padding: 20px;
                        border-bottom: 1px solid #e0e0e0;
                        background: #007bff;
                        border-radius: 12px 12px 0 0;
                        color: white;
                    }

                    .chat-header h1 {
                        margin: 0;
                        font-size: 20px;
                    }

                    .message-area {
                        flex: 1;
                        padding: 20px;
                        overflow-y: auto;
                        background: #f9fafb;
                        max-height: 70vh;
                        /* Để khối tin nhắn không chiếm toàn bộ khung */
                    }


                    .message {
                        margin-bottom: 15px;
                        max-width: 75%;
                        min-width: auto;
                        width: auto;
                        clear: both;
                        display: block;
                    }

                    .message.sent {
                        margin-left: auto;
                    }

                    .message.received {
                        margin-right: auto;
                    }

                    .message-container {
                        display: flex;
                        align-items: center;
                        gap: 8px;
                    }

                    .avatar {
                        width: 32px;
                        height: 32px;
                        border-radius: 50%;
                        background-color: #e0e0e0;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-weight: bold;
                        color: #fff;
                        font-size: 14px;
                        flex-shrink: 0;
                        margin-top: 0;
                    }

                    .sent .avatar {
                        background-color: #007bff;
                        order: 2;
                    }

                    .received .avatar {
                        background-color: #6c757d;
                        order: 0;
                    }

                    .message-content-wrapper {
                        flex: 1;
                        max-width: calc(100% - 40px);
                    }

                    .sent .message-content-wrapper {
                        display: flex;
                        flex-direction: column;
                        align-items: flex-end;
                    }

                    .received .message-content-wrapper {
                        display: flex;
                        flex-direction: column;
                        align-items: flex-start;
                    }

                    .message-header {
                        font-size: 0.85em;
                        margin-bottom: 2px;
                        color: #666;
                    }

                    .message-content {
                        padding: 8px 12px;
                        border-radius: 15px;
                        font-size: 0.95em;
                        line-height: 1.4;
                        word-wrap: break-word;
                        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                    }

                    .sent {
                        float: right;
                        text-align: right;
                    }

                    .sent .message-content {
                        background-color: #007bff;
                        color: white;
                    }

                    .received {
                        float: left;
                        text-align: left;
                    }

                    .received .message-content {
                        background-color: #e9ecef;
                        color: #333;
                    }

                    .message-input-container {
                        padding: 15px 20px;
                        background: #ffffff;
                        border-top: 1px solid #e0e0e0;
                        border-radius: 0 0 12px 12px;
                        display: flex;
                        align-items: center;
                        gap: 12px;
                    }

                    #messageInput {
                        flex: 1;
                        padding: 12px 16px;
                        border: 1px solid #d0d0d0;
                        border-radius: 25px;
                        font-size: 0.95em;
                        transition: border-color 0.3s ease;
                    }

                    #messageInput:focus {
                        outline: none;
                        border-color: #007bff;
                        box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
                    }

                    .send-button {
                        background: #007bff;
                        color: white;
                        border: none;
                        padding: 12px 20px;
                        border-radius: 25px;
                        cursor: pointer;
                        font-size: 0.95em;
                        display: flex;
                        align-items: center;
                        transition: background 0.3s ease;
                    }

                    .send-button:hover {
                        background: #0056b3;
                    }

                    .send-button i {
                        margin-left: 8px;
                    }

                    .time {
                        font-size: 0.75em;
                        color: #aaa;
                        margin-left: 8px;
                    }

                    .image-button {
                        background: transparent;
                        color: #007bff;
                        border: none;
                        padding: 12px;
                        border-radius: 50%;
                        cursor: pointer;
                        font-size: 1.2em;
                        transition: background 0.3s ease;
                    }

                    .image-button:hover {
                        background: rgba(0, 123, 255, 0.1);
                    }

                    .message-content img {
                        width: 120px;
                        height: 120px;
                        object-fit: cover;
                        border-radius: 8px;
                        cursor: pointer;
                        transition: box-shadow 0.2s;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
                        display: inline-block;
                    }

                    .message-content img:hover {
                        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.18);
                    }

                    .time-divider {
                        text-align: center;
                        margin: 20px 0;
                        position: relative;
                    }

                    .time-divider::before {
                        content: '';
                        position: absolute;
                        left: 0;
                        top: 50%;
                        width: 100%;
                        height: 1px;
                        background: #e0e0e0;
                        z-index: 1;
                    }

                    .time-divider span {
                        background: #f9fafb;
                        padding: 0 15px;
                        color: #666;
                        font-size: 0.85em;
                        position: relative;
                        z-index: 2;
                        border-radius: 12px;
                        border: 1px solid #e0e0e0;
                    }

                    @media (max-width: 600px) {
                        .chat-container {
                            height: 100vh;
                            border-radius: 0;
                        }

                        .chat-header h1 {
                            font-size: 18px;
                        }

                        .send-button {
                            padding: 10px 16px;
                        }

                        .message-content {
                            font-size: 0.9em;
                        }
                    }
                </style>
            </head>

            <body>
                <div class="chat-container">
                    <div class="chat-header">
                        <c:choose>
                            <c:when test="${currentUser.role == 'receptionist'}">
                                <button onclick="window.location.href='/receptionist'"
                                    class="btn btn-outline-secondary me-3" style="margin-right: 16px;">
                                    <i class="fas fa-arrow-left"></i> Quay lại
                                </button>
                            </c:when>
                            <c:otherwise>
                                <button onclick="window.location.href='/'" class="btn btn-outline-secondary me-3"
                                    style="margin-right: 16px;">
                                    <i class="fas fa-arrow-left"></i> Quay lại
                                </button>
                            </c:otherwise>
                        </c:choose>
                        <h1 style="display: inline-block; vertical-align: middle; margin: 0; font-size: 20px;">
                            Chat với
                            ${conversation.sender.userID == currentUser.userID ? conversation.receiver.fullName :
                            conversation.sender.fullName}
                        </h1>
                    </div>

                    <div class="message-area" id="messageArea">
                        <c:forEach items="${conversation.messages}" var="message">
                            <div class="message ${message.sender.userID == currentUser.userID ? 'sent' : 'received'}"
                                data-timestamp="${message.createdAt}">
                                <div class="message-container">
                                    <div class="avatar">
                                        ${fn:substring(message.sender.fullName, 0, 1)}
                                    </div>
                                    <div class="message-content-wrapper">
                                        <div class="message-header">
                                            <strong>${message.sender.fullName}</strong>
                                            <span class="time" data-timestamp="${message.createdAt}"></span>
                                        </div>
                                        <div class="message-content">${message.content}</div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="message-input-container">
                        <input type="file" id="imageInput" accept="image/*" style="display: none;">
                        <button class="image-button" onclick="document.getElementById('imageInput').click()">
                            <i class="fas fa-image"></i>
                        </button>
                        <input type="text" id="messageInput" placeholder="Nhập tin nhắn...">
                        <button class="send-button" onclick="sendMessage()">
                            Gửi <i class="fas fa-paper-plane"></i>
                        </button>
                    </div>
                </div>

                <!-- Modal xem ảnh lớn -->
                <div class="modal fade" id="imageModal" tabindex="-1">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content" style="background: transparent; border: none; box-shadow: none;">
                            <img id="modalImage" src="" style="width: 100%; max-width: 600px; border-radius: 10px;" />
                        </div>
                    </div>
                </div>
                <!-- Bootstrap 5 modal (nếu chưa có) -->
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

                <!-- JavaScript xử lý gửi tin nhắn -->
                <script src="/resources/js/chat-utils.js"></script>
                <script src="/resources/js/chat.js"></script>
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        // Format all timestamps on page load
                        document.querySelectorAll('.time[data-timestamp]').forEach(function (timeElement) {
                            const timestamp = timeElement.dataset.timestamp;
                            timeElement.textContent = formatTime(timestamp);
                        });

                        // Scroll to bottom of message area
                        const messageArea = document.getElementById('messageArea');
                        if (messageArea) {
                            messageArea.scrollTop = messageArea.scrollHeight;
                        }

                        // Xử lý click vào ảnh để xem lớn
                        document.getElementById('messageArea').addEventListener('click', function (e) {
                            if (e.target.tagName === 'IMG') {
                                document.getElementById('modalImage').src = e.target.src;
                                const modal = new bootstrap.Modal(document.getElementById('imageModal'));
                                modal.show();
                            }
                        });

                        // Gọi API mark-read khi vào trang hội thoại
                        const chatData = document.getElementById('chatData');
                        const conversationId = chatData && chatData.dataset.conversationId ? chatData.dataset.conversationId : null;
                        if (conversationId) {
                            fetch(`/api/chat/conversation/${conversationId}/mark-read`, {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/json' }
                            }).catch(err => console.error('Error marking conversation as read:', err));
                        }
                    });
                </script>
            </body>

            </html>