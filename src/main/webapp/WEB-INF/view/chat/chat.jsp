<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Chat</title>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/locale/vi.js"></script>
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
            <link href="/resources/css/chat-dashboard.css" rel="stylesheet">

            <div id="chatData" hidden data-user-id="${currentUser.userID}" data-username="${currentUser.username}"
                data-fullname="${currentUser.fullName}" data-role="${currentUser.role}"
                data-conversation-id="${conversation.id}" data-sender-id="${conversation.sender.userID}"
                data-sender-username="${conversation.sender.username}"
                data-sender-fullname="${conversation.sender.fullName}"
                data-receiver-id="${conversation.receiver.userID}"
                data-receiver-username="${conversation.receiver.username}"
                data-receiver-fullname="${conversation.receiver.fullName}">
            </div>

            <style>
                body {
                    font-family: Arial, sans-serif;
                    margin: 0;
                    padding: 20px;
                    background-color: #f0f2f5;
                }

                .chat-container {
                    max-width: 900px;
                    margin: 0 auto;
                    background: white;
                    border-radius: 10px;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                }

                .chat-header {
                    padding: 20px;
                    border-bottom: 1px solid #e0e0e0;
                    background: #ffffff;
                    border-radius: 10px 10px 0 0;
                }

                .chat-header h1 {
                    margin: 0;
                    font-size: 1.5em;
                    color: #1a1a1a;
                }

                .message-area {
                    height: 500px;
                    padding: 20px;
                    overflow-y: auto;
                    background: #fff;
                }

                .message {
                    margin-bottom: 15px;
                    max-width: 80%;
                    clear: both;
                }

                .message-header {
                    font-size: 0.9em;
                    margin-bottom: 5px;
                    color: #666;
                }

                .message-content {
                    padding: 10px 15px;
                    border-radius: 15px;
                    font-size: 0.95em;
                    line-height: 1.4;
                }

                .sent {
                    float: right;
                }

                .sent .message-content {
                    background: #0084ff;
                    color: white;
                }

                .received {
                    float: left;
                }

                .received .message-content {
                    background: #e9ecef;
                    color: black;
                }

                .message-input-container {
                    padding: 20px;
                    background: #fff;
                    border-top: 1px solid #e0e0e0;
                    border-radius: 0 0 10px 10px;
                    display: flex;
                    align-items: center;
                }

                #messageInput {
                    flex: 1;
                    padding: 12px;
                    border: 1px solid #e0e0e0;
                    border-radius: 20px;
                    margin-right: 10px;
                    font-size: 0.95em;
                }

                #messageInput:focus {
                    outline: none;
                    border-color: #0084ff;
                }

                .send-button {
                    background: #0084ff;
                    color: white;
                    border: none;
                    padding: 12px 20px;
                    border-radius: 20px;
                    cursor: pointer;
                    font-size: 0.95em;
                    display: flex;
                    align-items: center;
                }

                .send-button:hover {
                    background: #0073e6;
                }

                .send-button i {
                    margin-left: 5px;
                }

                .time {
                    font-size: 0.8em;
                    color: #999;
                    margin-left: 10px;
                }
            </style>
        </head>

        <body>
            <div class="chat-container">
                <div class="chat-header">
                    <h1>Chat with ${conversation.sender.userID == currentUser.userID ? conversation.receiver.fullName :
                        conversation.sender.fullName}</h1>
                </div>

                <div class="message-area" id="messageArea">
                    <c:forEach items="${conversation.messages}" var="message">
                        <div class="message ${message.sender.userID == currentUser.userID ? 'sent' : 'received'}">
                            <div class="message-header">
                                <strong>${message.sender.fullName}</strong>
                                <span class="time">${message.createdAt}</span>
                            </div>
                            <div class="message-content">${message.content}</div>
                        </div>
                    </c:forEach>
                </div>

                <div class="message-input-container">
                    <input type="text" id="messageInput" placeholder="Type your message...">
                    <button class="send-button" onclick="sendMessage()">
                        Send <i class="fas fa-paper-plane"></i>
                    </button>
                </div>
            </div>

            <script src="/resources/js/chat.js"></script>
        </body>

        </html>