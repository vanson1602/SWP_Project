let stompClient = null;
let currentConversation = null;

const chatData = document.getElementById('chatData');

const currentUser = {
    id: parseInt(chatData.dataset.userId),
    username: chatData.dataset.username,
    fullName: chatData.dataset.fullname,
    role: chatData.dataset.role
};

const initialConversation = {
    id: parseInt(chatData.dataset.conversationId),
    sender: {
        id: parseInt(chatData.dataset.senderId),
        username: chatData.dataset.senderUsername,
        fullName: chatData.dataset.senderFullname
    },
    receiver: {
        id: parseInt(chatData.dataset.receiverId),
        username: chatData.dataset.receiverUsername,
        fullName: chatData.dataset.receiverFullname
    }
};

function connect() {
    const socket = new SockJS('/ws');
    stompClient = Stomp.over(socket);
    stompClient.debug = null;

    stompClient.connect({}, function (frame) {
        console.log('Connected: ' + frame);

        // Subscribe to personal conversation updates
        const personalUpdatesQueue = `/topic/user/${currentUser.id}/conversations`;
        stompClient.subscribe(personalUpdatesQueue, function (message) {
            const messageData = JSON.parse(message.body);
            updateConversationLastMessage(messageData);
        });

        if (currentConversation) {
            const conversationQueue = `/topic/conversation/${currentConversation.id}`;
            console.log('Subscribing to conversation topic:', conversationQueue);

            stompClient.subscribe(conversationQueue, function (message) {
                const messageBody = JSON.parse(message.body);
                console.log('Received message from topic:', messageBody);
                displayMessage(messageBody);
            });
        }

        if (currentUser.role === 'receptionist') {
            const newConversationsQueue = `/topic/conversations/${currentUser.id}`;
            console.log('Subscribing to new conversations topic:', newConversationsQueue);

            stompClient.subscribe(newConversationsQueue, function (conversation) {
                const conversationData = JSON.parse(conversation.body);
                console.log('Received new conversation:', conversationData);
                addNewConversationToUI(conversationData);
            });
        }

    }, function (error) {
        console.error('WebSocket error:', error);
        setTimeout(connect, 5000); // reconnect nếu mất kết nối
    });
}

function sendMessage() {
    const messageInput = document.getElementById('messageInput');
    const content = messageInput.value.trim();

    if (!currentConversation || !content) {
        console.error('Invalid state: no conversation or message empty');
        return;
    }

    if (stompClient && stompClient.connected) {
        const receiver = currentUser.id === currentConversation.sender.id
            ? currentConversation.receiver
            : currentConversation.sender;

        const message = {
            conversationId: currentConversation.id,
            senderId: currentUser.id,
            receiverId: receiver.id,
            content: content
        };

        console.log('Sending message:', message);
        stompClient.send("/app/chat.send", {}, JSON.stringify(message));

        messageInput.value = '';
        messageInput.focus();
    } else {
        console.error('WebSocket not connected. Reconnecting...');
        connect();
    }
}

function formatTime(timestamp) {
    if (!timestamp) return 'Không xác định';

    try {
        const momentDate = moment(timestamp);
        if (!momentDate.isValid()) return 'Không xác định';

        const now = moment();
        const diff = now.diff(momentDate, 'minutes');

        if (diff < 1) return 'Vừa xong';
        if (diff < 60) return `${diff} phút trước`;
        if (diff < 1440) return momentDate.format('HH:mm [hôm nay]');
        if (diff < 2880) return momentDate.format('HH:mm [hôm qua]');
        if (diff < 7200) return momentDate.format('HH:mm [•] DD/MM');
        return momentDate.format('HH:mm [•] DD/MM/YYYY');
    } catch (error) {
        console.error('Error formatting date:', error);
        return 'Không xác định';
    }
}

function displayMessage(message) {
    const messageArea = document.getElementById('messageArea');
    if (!messageArea) return;

    const sender = message.sender || {};
    const currentUserId = currentUser.userID || currentUser.id;
    const senderId = sender.userID || sender.id;

    const isSent = senderId === currentUserId;

    const senderFullName = sender.fullName ||
        (`${sender.firstName || ''} ${sender.lastName || ''}`.trim()) ||
        'Người dùng';

    const firstLetter = senderFullName.charAt(0).toUpperCase();

    const messageDiv = document.createElement('div');
    messageDiv.className = `message ${isSent ? 'sent' : 'received'}`;

    messageDiv.innerHTML = `
        <div class="message-container">
            <div class="avatar">${firstLetter}</div>
            <div class="message-content-wrapper">
                <div class="message-header">
                    <strong>${senderFullName}</strong>
                    <span class="time">${formatTime(message.createdAt)}</span>
                </div>
                <div class="message-content">${message.content}</div>
            </div>
        </div>
    `;

    messageArea.appendChild(messageDiv);
    messageArea.scrollTop = messageArea.scrollHeight;
}

function loadConversation(conversationId) {
    fetch(`/api/chat/conversation/${conversationId}`)
        .then(response => response.json())
        .then(conversation => {
            currentConversation = conversation;
            const messageArea = document.getElementById('messageArea');
            messageArea.innerHTML = '';

            if (conversation.messages) {
                conversation.messages.forEach(message => {
                    displayMessage(message);
                });
            }
        })
        .catch(error => console.error('Error loading conversation:', error));
}

function findConversationItem(conversationId) {
    // Try different possible selectors since the data attribute might be in different formats
    const selectors = [
        `.conversation-item[data-conversation-id="${conversationId}"]`,
        `.conversation-item[data-id="${conversationId}"]`,
        `.conversation-item[data-conversationid="${conversationId}"]`
    ];

    for (const selector of selectors) {
        const item = document.querySelector(selector);
        if (item) return item;
    }
    return null;
}

function updateConversationLastMessage(messageData) {
    const conversationItem = findConversationItem(messageData.conversationId);

    if (conversationItem) {
        // Update existing conversation
        const lastMessageDiv = conversationItem.querySelector('.last-message');
        if (lastMessageDiv) {
            lastMessageDiv.textContent = messageData.content;
        }

        // Move conversation to top of list
        const parent = conversationItem.parentNode;
        if (parent && parent.firstChild) {
            parent.insertBefore(conversationItem, parent.firstChild);
        }
    } else {
        console.warn('Conversation not found for update:', messageData.conversationId);
    }
}

function addNewConversationToUI(conversation) {
    // Check if conversation already exists
    const existingConversation = findConversationItem(conversation.id);
    if (existingConversation) {
        console.log('Conversation already exists, updating instead of creating new');
        return updateConversationLastMessage({
            conversationId: conversation.id,
            content: conversation.messages?.[conversation.messages.length - 1]?.content || ''
        });
    }

    const conversationsContainer = document.querySelector('.tab-pane#conversations') ||
        document.querySelector('#conversations') ||
        document.querySelector('.conversations-container');

    if (!conversationsContainer) {
        console.error('Could not find conversations container');
        return;
    }

    const noConversationsDiv = conversationsContainer.querySelector('.no-conversations');
    if (noConversationsDiv) {
        noConversationsDiv.remove();
    }

    const otherUser = conversation.sender.userID === currentUser.id ? conversation.receiver : conversation.sender;
    const firstName = otherUser.firstName || otherUser.fullName?.split(' ')[0] || 'U';

    const conversationDiv = document.createElement('div');
    conversationDiv.className = 'conversation-item';
    conversationDiv.setAttribute('data-conversation-id', conversation.id);
    conversationDiv.onclick = () => window.location.href = `/chat/conversation/${conversation.id}`;

    conversationDiv.innerHTML = `
        <div class="avatar">${firstName.charAt(0).toUpperCase()}</div>
        <div class="user-info">
            <div class="user-name">
                ${otherUser.firstName || ''} ${otherUser.lastName || ''}
            </div>
            ${conversation.messages && conversation.messages.length > 0 ? `
                <div class="last-message">
                    ${conversation.messages[conversation.messages.length - 1].content}
                </div>
            ` : ''}
        </div>
    `;

    conversationsContainer.insertBefore(conversationDiv, conversationsContainer.firstChild);
}

document.addEventListener('DOMContentLoaded', function () {
    console.log('Initializing chat...');
    console.log('Current user:', currentUser);

    if (typeof initialConversation !== 'undefined') {
        currentConversation = initialConversation;
        console.log('Initial conversation:', currentConversation);
    }

    const conversationItems = document.querySelectorAll('.conversation-item');
    conversationItems.forEach(item => {
        item.addEventListener('click', function () {
            const conversationId = this.getAttribute('data-conversation-id');
            loadConversation(conversationId);
        });
    });

    const messageInput = document.getElementById('messageInput');
    if (messageInput) {
        messageInput.addEventListener('keypress', function (e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                sendMessage();
            }
        });
    }

    connect();
});

async function startChatWithReceptionist() {
    try {
        const receptionistResponse = await fetch('/chat/receptionist');
        if (!receptionistResponse.ok) {
            throw new Error('Không tìm thấy lễ tân');
        }
        const receptionistData = await receptionistResponse.json();
        const receptionistId = receptionistData.id;

        const response = await fetch('/chat/conversations?receiverId=' + receptionistId, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            }
        });

        if (!response.ok) {
            const errorData = await response.text();
            throw new Error('Không thể tạo cuộc hội thoại: ' + errorData);
        }

        const conversation = await response.json();
        if (conversation && conversation.id) {
            window.location.href = '/chat/conversation/' + conversation.id;
        } else {
            throw new Error('Dữ liệu cuộc hội thoại không hợp lệ');
        }
    } catch (error) {
        alert('Lỗi: ' + error.message);
        console.error(error);
    }
}
