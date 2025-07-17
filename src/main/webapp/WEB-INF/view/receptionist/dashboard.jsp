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
            <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
            <style>
                /* Existing styles ... */

                .conversation-message {
                    font-size: 14px;
                    color: #666;
                    white-space: nowrap;
                    overflow: hidden;
                    text-overflow: ellipsis;
                }

                .conversation-unread .conversation-name,
                .conversation-unread .conversation-message {
                    font-weight: bold;
                    color: #000;
                }

                .conversation-unread .conversation-message {
                    color: #333;
                }

                .conversation-item {
                    transition: background-color 0.2s ease;
                }

                .conversation-item:hover {
                    background-color: #f0f2f5;
                    cursor: pointer;
                }

                .conversation-content {
                    flex: 1;
                    min-width: 0;
                    /* Để text-overflow hoạt động tốt hơn */
                }
            </style>
        </head>

        <body>
            <div id="chatData" data-user-id="${currentUser.userID}" data-username="${currentUser.username}"
                data-fullname="${currentUser.firstName} ${currentUser.lastName}" data-role="${currentUser.role}">
            </div>

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
                    <div class="tab-pane fade show active" id="conversations" role="tabpanel">
                        <div class="conversation-list">
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
                                    data-conversation-id="${conv.id}" data-sender-id="${conv.sender.userID}"
                                    data-receiver-id="${conv.receiver.userID}"
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

            <script>
                let stompClient = null;
                const chatData = document.getElementById('chatData');
                const currentUser = {
                    userID: parseInt(chatData.dataset.userId),
                    username: chatData.dataset.username,
                    fullName: chatData.dataset.fullname,
                    role: chatData.dataset.role
                };

                function connect() {
                    const socket = new SockJS('/ws');
                    stompClient = Stomp.over(socket);
                    stompClient.debug = null;

                    stompClient.connect({}, function (frame) {
                        console.log('Connected: ' + frame);

                        // Subscribe to personal conversation updates
                        const personalUpdatesQueue = `/topic/user/${currentUser.userID}/conversations`;
                        stompClient.subscribe(personalUpdatesQueue, function (message) {
                            console.log('Received conversation update:', message.body);
                            const messageData = JSON.parse(message.body);
                            handleIncomingMessage(messageData);
                        });

                        // Subscribe to new conversations (for receptionist)
                        if (currentUser.role === 'receptionist') {
                            const newConversationsQueue = `/topic/conversations/${currentUser.userID}`;
                            stompClient.subscribe(newConversationsQueue, function (conversation) {
                                console.log('Received new conversation:', conversation.body);
                                const conversationData = JSON.parse(conversation.body);
                                handleIncomingMessage(conversationData);
                            });
                        }
                    }, function (error) {
                        console.error('WebSocket connection error:', error);
                        setTimeout(connect, 5000);
                    });
                }

                function findConversationItem(messageData) {
                    console.log('Finding conversation for:', messageData);

                    // Kiểm tra tất cả các ID có thể
                    const possibleIds = [
                        messageData.conversationId,
                        messageData.conversation?.id,
                        messageData.id
                    ].filter(id => id); // Lọc bỏ undefined/null

                    // Kiểm tra cả sender và receiver để tìm conversation
                    const senderId = messageData.sender?.userID || messageData.sender?.id;
                    const receiverId = messageData.receiver?.userID || messageData.receiver?.id;

                    const conversations = document.querySelectorAll('.conversation-item');
                    for (const conv of conversations) {
                        // Kiểm tra theo ID
                        const convId = conv.getAttribute('data-conversation-id');
                        if (possibleIds.includes(parseInt(convId))) {
                            console.log('Found by ID:', convId);
                            return conv;
                        }

                        // Kiểm tra theo người gửi/nhận
                        const convSenderId = conv.getAttribute('data-sender-id');
                        const convReceiverId = conv.getAttribute('data-receiver-id');
                        if ((convSenderId === senderId && convReceiverId === receiverId) ||
                            (convSenderId === receiverId && convReceiverId === senderId)) {
                            console.log('Found by participants:', convSenderId, convReceiverId);
                            return conv;
                        }
                    }
                    return null;
                }

                function handleIncomingMessage(messageData) {
                    console.log('Handling incoming message:', messageData);

                    // Normalize message data structure
                    const normalizedData = {
                        conversationId: messageData.conversationId || messageData.conversation?.id || messageData.id,
                        content: messageData.content || messageData.messages?.[messageData.messages.length - 1]?.content,
                        sender: messageData.sender,
                        receiver: messageData.receiver,
                        isRead: messageData.isRead || false
                    };

                    if (!normalizedData.sender || !normalizedData.receiver) {
                        console.error('Invalid message data - missing sender or receiver:', messageData);
                        return;
                    }

                    const conversationList = document.querySelector('.conversation-list');
                    if (!conversationList) {
                        console.error('Conversation list container not found');
                        return;
                    }

                    const existingItem = findConversationItem(normalizedData);

                    if (existingItem) {
                        console.log('Updating existing conversation:', existingItem);
                        // Update existing conversation
                        const messageDiv = existingItem.querySelector('.conversation-message');
                        if (messageDiv && normalizedData.content) {
                            messageDiv.textContent = normalizedData.content;

                            // Nếu tin nhắn mới đến và người nhận là người dùng hiện tại
                            if (normalizedData.receiver.userID === currentUser.userID && !normalizedData.isRead) {
                                existingItem.classList.add('conversation-unread');
                            }

                            conversationList.insertBefore(existingItem, conversationList.firstChild);
                        }
                    } else {
                        console.log('Creating new conversation item');
                        // Create new conversation item
                        const noConversationsDiv = conversationList.querySelector('.no-conversations');
                        if (noConversationsDiv) {
                            noConversationsDiv.remove();
                        }

                        const otherUser = normalizedData.sender.userID === currentUser.userID
                            ? normalizedData.receiver
                            : normalizedData.sender;

                        const newConversationDiv = document.createElement('div');
                        newConversationDiv.className = 'conversation-item d-flex align-items-center';

                        // Thêm class unread nếu tin nhắn chưa đọc và người nhận là người dùng hiện tại
                        if (normalizedData.receiver.userID === currentUser.userID && !normalizedData.isRead) {
                            newConversationDiv.classList.add('conversation-unread');
                        }

                        // Lưu thông tin người gửi/nhận để dễ dàng tìm kiếm sau này
                        newConversationDiv.setAttribute('data-conversation-id', normalizedData.conversationId);
                        newConversationDiv.setAttribute('data-sender-id', normalizedData.sender.userID);
                        newConversationDiv.setAttribute('data-receiver-id', normalizedData.receiver.userID);

                        newConversationDiv.onclick = function () {
                            markConversationAsRead(this);
                            window.location.href = '/chat/conversation/' + normalizedData.conversationId;
                        };

                        const avatarDiv = document.createElement('div');
                        avatarDiv.className = 'avatar';
                        avatarDiv.textContent = otherUser.firstName.charAt(0);

                        const contentDiv = document.createElement('div');
                        contentDiv.className = 'conversation-content';

                        const nameDiv = document.createElement('div');
                        nameDiv.className = 'conversation-name';
                        nameDiv.textContent = otherUser.firstName + ' ' + otherUser.lastName;
                        contentDiv.appendChild(nameDiv);

                        if (normalizedData.content) {
                            const messageDiv = document.createElement('div');
                            messageDiv.className = 'conversation-message';
                            messageDiv.textContent = normalizedData.content;
                            contentDiv.appendChild(messageDiv);
                        }

                        newConversationDiv.appendChild(avatarDiv);
                        newConversationDiv.appendChild(contentDiv);
                        conversationList.insertBefore(newConversationDiv, conversationList.firstChild);
                    }
                }

                function markConversationAsRead(conversationElement) {
                    if (conversationElement.classList.contains('conversation-unread')) {
                        conversationElement.classList.remove('conversation-unread');

                        // Gửi request để đánh dấu đã đọc trên server
                        const conversationId = conversationElement.getAttribute('data-conversation-id');
                        fetch(`/api/chat/conversation/${conversationId}/mark-read`, {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json'
                            }
                        }).catch(error => console.error('Error marking conversation as read:', error));
                    }
                }

                // Khởi tạo trạng thái unread cho các cuộc hội thoại hiện có
                document.addEventListener('DOMContentLoaded', function () {
                    connect();

                    // Đánh dấu các cuộc hội thoại chưa đọc
                    const conversations = document.querySelectorAll('.conversation-item');
                    conversations.forEach(conv => {
                        const lastMessage = conv.querySelector('.conversation-message');
                        if (lastMessage && lastMessage.dataset.isRead === 'false') {
                            conv.classList.add('conversation-unread');
                        }

                        // Thêm sự kiện click để đánh dấu đã đọc
                        conv.addEventListener('click', function () {
                            markConversationAsRead(this);
                        });
                    });
                });
            </script>
        </body>

        </html>