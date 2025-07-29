<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>Dashboard | Receptionist</title>
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
                <link rel="stylesheet" href="/resources/css/receptionist-dashboard.css">
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/locale/vi.js"></script>
                <script src="/resources/js/chat-utils.js"></script>
                <style>
                    /* Reset CSS */
                    * {
                        margin: 0;
                        padding: 0;
                        box-sizing: border-box;
                    }

                    html,
                    body {
                        height: 100%;
                        width: 100%;
                        margin: 0;
                        padding: 0;
                        overflow: hidden;
                    }

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
                        padding: 10px;
                        border-bottom: 1px solid #eee;
                    }

                    .conversation-item:hover {
                        background-color: #f0f2f5;
                        cursor: pointer;
                    }

                    .conversation-content {
                        flex: 1;
                        min-width: 0;
                    }

                    /* New Sidebar Styles */
                    .dashboard-container {
                        display: flex;
                        height: 100vh;
                        width: 100vw;
                    }

                    .sidebar {
                        width: 280px;
                        background-color: #2c3e50;
                        color: white;
                        height: 100vh;
                        display: flex;
                        flex-direction: column;
                        position: fixed;
                        left: 0;
                        top: 0;
                        z-index: 1000;
                    }

                    .sidebar-header {
                        padding: 20px;
                        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                    }

                    .sidebar-title {
                        font-size: 24px;
                        color: #00d4ff;
                        margin: 0;
                    }

                    .sidebar-nav {
                        list-style: none;
                        padding: 0;
                        margin: 0;
                        flex-grow: 1;
                    }

                    .sidebar-nav-item {
                        padding: 15px 20px;
                        cursor: pointer;
                        transition: all 0.3s ease;
                        display: flex;
                        align-items: center;
                        color: #ecf0f1;
                        text-decoration: none;
                        border-left: 4px solid transparent;
                    }

                    .sidebar-nav-item:hover,
                    .sidebar-nav-item.active {
                        background-color: rgba(255, 255, 255, 0.1);
                        color: #00d4ff;
                        border-left-color: #00d4ff;
                    }

                    .sidebar-nav-item i {
                        margin-right: 10px;
                        width: 20px;
                        text-align: center;
                    }

                    .sidebar-footer {
                        padding: 20px;
                        border-top: 1px solid rgba(255, 255, 255, 0.1);
                    }

                    .text-danger {
                        color: #e74c3c !important;
                    }

                    .text-danger:hover {
                        background-color: rgba(231, 76, 60, 0.1) !important;
                        color: #ff6b6b !important;
                    }

                    .main-content {
                        margin-left: 280px;
                        width: calc(100% - 280px);
                        height: 100vh;
                        background-color: white;
                        position: relative;
                        overflow: hidden;
                    }

                    .tab-content {
                        height: 100%;
                        width: 100%;
                    }

                    .tab-pane {
                        height: 100%;
                        width: 100%;
                        position: relative;
                    }

                    .tab-pane iframe {
                        width: 100%;
                        height: 100%;
                        border: none;
                        display: block;
                    }

                    .conversation-list {
                        padding: 20px;
                        height: 100%;
                        overflow-y: auto;
                    }

                    /* Conversation styles */
                    .conversation-item {
                        padding: 15px;
                        border-bottom: 1px solid #eee;
                        transition: background-color 0.2s;
                    }

                    .conversation-item:hover {
                        background-color: #f8f9fa;
                    }

                    .conversation-name {
                        font-weight: 500;
                        margin-bottom: 5px;
                    }

                    .conversation-message {
                        color: #666;
                        font-size: 14px;
                    }

                    .avatar {
                        width: 40px;
                        height: 40px;
                        background-color: #3498db;
                        color: white;
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        margin-right: 15px;
                        font-weight: bold;
                    }

                    .no-conversations {
                        text-align: center;
                        padding: 40px;
                        color: #666;
                    }

                    /* Custom scrollbar */
                    ::-webkit-scrollbar {
                        width: 6px;
                    }

                    ::-webkit-scrollbar-track {
                        background: #f1f1f1;
                    }

                    ::-webkit-scrollbar-thumb {
                        background: #888;
                        border-radius: 3px;
                    }

                    ::-webkit-scrollbar-thumb:hover {
                        background: #555;
                    }

                    .conversation-container {
                        height: 100%;
                        width: 100%;
                        background-color: white;
                    }

                    .conversation-list {
                        height: 100%;
                        width: 100%;
                        overflow-y: auto;
                        background-color: white;
                        padding: 0;
                    }

                    .conversation-item {
                        padding: 15px 20px;
                        border-bottom: 1px solid #eee;
                        transition: all 0.2s ease;
                        background-color: white;
                    }

                    .conversation-item:hover {
                        background-color: #f8f9fa;
                        cursor: pointer;
                    }

                    .conversation-content {
                        flex: 1;
                        min-width: 0;
                        padding-right: 15px;
                    }

                    .conversation-name {
                        font-weight: 500;
                        font-size: 15px;
                        margin-bottom: 4px;
                        color: #2c3e50;
                    }

                    .conversation-message {
                        color: #666;
                        font-size: 14px;
                        white-space: nowrap;
                        overflow: hidden;
                        text-overflow: ellipsis;
                    }

                    .avatar {
                        width: 45px;
                        height: 45px;
                        background-color: #3498db;
                        color: white;
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        margin-right: 15px;
                        font-size: 18px;
                        font-weight: 500;
                    }

                    .no-conversations {
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        justify-content: center;
                        height: 100%;
                        color: #666;
                        font-size: 16px;
                        background-color: white;
                    }

                    .no-conversations svg {
                        margin-bottom: 15px;
                        color: #3498db;
                    }

                    /* Tab pane styles */
                    .tab-pane {
                        height: 100%;
                        width: 100%;
                        position: relative;
                    }

                    .tab-pane.fade {
                        opacity: 0;
                        transition: opacity 0.15s linear;
                    }

                    .tab-pane.fade.show {
                        opacity: 1;
                    }

                    /* Main content styles */
                    .main-content {
                        margin-left: 280px;
                        width: calc(100% - 280px);
                        height: 100vh;
                        background-color: white;
                        position: relative;
                        overflow: hidden;
                    }

                    .tab-content {
                        height: 100%;
                        width: 100%;
                    }

                    /* Custom scrollbar */
                    ::-webkit-scrollbar {
                        width: 6px;
                    }

                    ::-webkit-scrollbar-track {
                        background: #f1f1f1;
                    }

                    ::-webkit-scrollbar-thumb {
                        background: #888;
                        border-radius: 3px;
                    }

                    ::-webkit-scrollbar-thumb:hover {
                        background: #555;
                    }

                    /* Fade animation */
                    .fade {
                        transition: opacity 0.15s linear;
                    }

                    .fade:not(.show) {
                        opacity: 0;
                    }
                </style>
            </head>

            <body>
                <div id="chatData" data-user-id="${currentUser.userID}" data-username="${currentUser.username}"
                    data-fullname="${currentUser.firstName} ${currentUser.lastName}" data-role="${currentUser.role}">
                </div>

                <div class="dashboard-container">
                    <!-- Sidebar -->
                    <div class="sidebar">
                        <div class="sidebar-header">
                            <h3 class="sidebar-title">Lễ tân Panel</h3>
                        </div>
                        <ul class="sidebar-nav">
                            <li>
                                <a href="#patientInfo" class="sidebar-nav-item active" data-bs-toggle="tab">
                                    <i class="bi bi-person"></i>
                                    Xem thông tin bệnh nhân
                                </a>
                            </li>
                            <li>
                                <a href="#conversations" class="sidebar-nav-item" data-bs-toggle="tab">
                                    <i class="bi bi-chat-dots"></i>
                                    Cuộc hội thoại
                                </a>
                            </li>
                            <li>
                                <a href="/booking-receptionist/step-1" class="sidebar-nav-item">
                                    <i class="bi bi-calendar-plus"></i>
                                    Đặt lịch cho bệnh nhân
                                </a>
                            </li>
                        </ul>
                        <div class="sidebar-footer">
                            <a href="/logout" class="sidebar-nav-item text-danger">
                                <i class="bi bi-box-arrow-right"></i>
                                Đăng xuất
                            </a>
                        </div>
                    </div>

                    <!-- Main Content -->
                    <div class="main-content">
                        <div class="tab-content" id="dashboardTabsContent">
                            <!-- Xem thông tin bệnh nhân tab -->
                            <div class="tab-pane fade show active h-100" id="patientInfo" role="tabpanel">
                                <iframe id="mainFrame" class="frame-content"
                                    src="/booking-receptionist/patientInfor"></iframe>

                            </div>

                            <!-- Cuộc hội thoại tab -->
                            <div class="tab-pane fade h-100" id="conversations" role="tabpanel">
                                <div class="conversation-container">
                                    <div class="conversation-list">
                                        <c:if test="${empty conversations}">
                                            <div class="no-conversations">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48"
                                                    fill="currentColor" class="bi bi-chat-dots mb-3"
                                                    viewBox="0 0 16 16">
                                                    <path
                                                        d="M5 8a1 1 0 1 1-2 0 1 1 0 0 1 2 0m4 0a1 1 0 1 1-2 0 1 1 0 0 1 2 0m3 1a1 1 0 1 0 0-2 1 1 0 0 0 0 2" />
                                                    <path
                                                        d="m2.165 15.803.02-.004c1.83-.363 2.948-.842 3.468-1.105A9.06 9.06 0 0 0 8 15c4.418 0 8-3.134 8-7s-3.582-7-8-7-8 3.134-8 7c0 1.76.743 3.37 1.97 4.6a10.437 10.437 0 0 1-.524 2.318l-.003.011a10.722 10.722 0 0 1-.244.637c-.079.186.074.394.273.362a21.673 21.673 0 0 0 .693-.125zm.8-3.108a1 1 0 0 0-.287-.801C1.618 10.83 1 9.468 1 8c0-3.192 3.004-6 7-6s7 2.808 7 6c0 3.193-3.004 6-7 6a8.06 8.06 0 0 1-2.088-.272 1 1 0 0 0-.711.074c-.387.196-1.24.57-2.634.893a10.97 10.97 0 0 0 .398-2" />
                                                </svg>
                                                <div>Không có cuộc hội thoại nào.</div>
                                            </div>
                                        </c:if>
                                        <c:forEach items="${conversations}" var="conv">
                                            <div class="conversation-item d-flex align-items-center${unreadMap[conv.id] ? ' conversation-unread' : ''}"
                                                data-conversation-id="${conv.id}" data-sender-id="${conv.sender.userID}"
                                                data-receiver-id="${conv.receiver.userID}"
                                                onclick="window.location.href='/chat/conversation/${conv.id}'">
                                                <div class="avatar">
                                                    ${conv.receiver.userID == currentUser.userID ?
                                                    conv.sender.firstName.charAt(0) :
                                                    conv.receiver.firstName.charAt(0)}
                                                </div>
                                                <div class="conversation-content">
                                                    <div class="conversation-name">
                                                        ${conv.receiver.userID == currentUser.userID ?
                                                        conv.sender.firstName.concat(' ').concat(conv.sender.lastName) :
                                                        conv.receiver.firstName.concat('
                                                        ').concat(conv.receiver.lastName)}
                                                    </div>
                                                    <c:if test="${not empty conv.messages}">
                                                        <div class="conversation-message">
                                                            <c:set var="lastMessage"
                                                                value="${conv.messages[conv.messages.size()-1]}" />
                                                            <c:choose>
                                                                <c:when test="${fn:contains(lastMessage.content, 'data:image') || 
                                                                  fn:contains(lastMessage.content, '.jpg') || 
                                                                  fn:contains(lastMessage.content, '.png') || 
                                                                  fn:contains(lastMessage.content, '.jpeg') || 
                                                                  fn:contains(lastMessage.content, '.gif') ||
                                                                  fn:contains(lastMessage.content, 'cloudinary.com') ||
                                                                  fn:contains(lastMessage.content, '<img')}">
                                                                    <i class="bi bi-image"></i> Đã gửi 1 ảnh
                                                                </c:when>
                                                                <c:otherwise>
                                                                    ${lastMessage.content}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </c:forEach>
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
                        id: parseInt(chatData.dataset.userId),
                        username: chatData.dataset.username,
                        fullName: chatData.dataset.fullname,
                        role: chatData.dataset.role
                    };
                    function goToPatientInfor() {
                        window.location.href = "/booking-receptionist/patientInfor";
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

                        // Function to check if content is an image
                        function isImageContent(content) {
                            if (!content) return false;
                            return content.includes('data:image') ||
                                content.includes('.jpg') ||
                                content.includes('.png') ||
                                content.includes('.jpeg') ||
                                content.includes('.gif') ||
                                content.includes('cloudinary.com') ||
                                content.includes('<img');
                        }

                        // Function to format message content
                        function formatMessageContent(content) {
                            if (isImageContent(content)) {
                                return '<i class="bi bi-image"></i> Đã gửi 1 ảnh';
                            }
                            return content;
                        }

                        const existingItem = findConversationItem(normalizedData);

                        if (existingItem) {
                            // Update nội dung tin nhắn cuối cùng
                            const messageDiv = existingItem.querySelector('.conversation-message');
                            if (messageDiv && normalizedData.content) {
                                messageDiv.innerHTML = formatMessageContent(normalizedData.content);
                            }
                            // Sửa điều kiện kiểm tra người nhận
                            const receiverId = normalizedData.receiver.id || normalizedData.receiver.userID;
                            if ((receiverId == currentUser.id) && !normalizedData.isRead) {
                                existingItem.classList.add('conversation-unread');
                                console.log('Added conversation-unread to:', existingItem);
                            } else {
                                existingItem.classList.remove('conversation-unread');
                                console.log('Removed conversation-unread from:', existingItem);
                            }
                            conversationList.insertBefore(existingItem, conversationList.firstChild);
                        } else {
                            console.log('Creating new conversation item');
                            // Create new conversation item
                            const noConversationsDiv = conversationList.querySelector('.no-conversations');
                            if (noConversationsDiv) {
                                noConversationsDiv.remove();
                            }

                            const otherUser = normalizedData.sender.id === currentUser.id
                                ? normalizedData.receiver
                                : normalizedData.sender;

                            const newConversationDiv = document.createElement('div');
                            newConversationDiv.className = 'conversation-item d-flex align-items-center';

                            // Thêm class unread nếu tin nhắn chưa đọc và người nhận là người dùng hiện tại
                            if (normalizedData.receiver.id === currentUser.id && !normalizedData.isRead) {
                                newConversationDiv.classList.add('conversation-unread');
                            }

                            // Lưu thông tin người gửi/nhận để dễ dàng tìm kiếm sau này
                            newConversationDiv.setAttribute('data-conversation-id', normalizedData.conversationId);
                            newConversationDiv.setAttribute('data-sender-id', normalizedData.sender.id);
                            newConversationDiv.setAttribute('data-receiver-id', normalizedData.receiver.id);

                            newConversationDiv.onclick = function () {
                                this.classList.remove('conversation-unread');
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
                                messageDiv.innerHTML = formatMessageContent(normalizedData.content);
                                contentDiv.appendChild(messageDiv);
                            }

                            newConversationDiv.appendChild(avatarDiv);
                            newConversationDiv.appendChild(contentDiv);
                            conversationList.insertBefore(newConversationDiv, conversationList.firstChild);
                        }
                    }

                    // Khởi tạo trạng thái unread cho các cuộc hội thoại hiện có
                    document.addEventListener('DOMContentLoaded', function () {
                        stompClient = initializeWebSocket(currentUser, handleIncomingMessage);

                        // Đánh dấu các cuộc hội thoại chưa đọc
                        const conversations = document.querySelectorAll('.conversation-item');
                        conversations.forEach(conv => {
                            const lastMessage = conv.querySelector('.conversation-message');
                            if (lastMessage && lastMessage.dataset.isRead === 'false') {
                                conv.classList.add('conversation-unread');
                            }

                            // Thêm sự kiện click để đánh dấu đã đọc
                            conv.addEventListener('click', function () {
                                this.classList.remove('conversation-unread');
                                window.location.href = '/chat/conversation/' + this.getAttribute('data-conversation-id');
                            });
                        });
                    });

                    // Add tab switching logic
                    document.addEventListener('DOMContentLoaded', function () {
                        const sidebarLinks = document.querySelectorAll('.sidebar-nav-item');

                        sidebarLinks.forEach(link => {
                            link.addEventListener('click', function (e) {
                                // Only handle tab links
                                if (this.getAttribute('data-bs-toggle') === 'tab') {
                                    e.preventDefault();

                                    // Remove active class from all links
                                    sidebarLinks.forEach(l => l.classList.remove('active'));

                                    // Add active class to clicked link
                                    this.classList.add('active');

                                    // Show corresponding tab content
                                    const targetId = this.getAttribute('href').substring(1);
                                    document.querySelectorAll('.tab-pane').forEach(pane => {
                                        pane.classList.remove('show', 'active');
                                    });
                                    document.getElementById(targetId).classList.add('show', 'active');
                                }
                            });
                        });
                    });
                </script>
            </body>

            </html>