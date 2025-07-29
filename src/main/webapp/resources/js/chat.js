let stompClient = null;
let currentConversation = null;
let currentImageFile = null;

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
    stompClient = initializeWebSocket(currentUser, function (messageData) {
        if (currentConversation && messageData.conversationId === currentConversation.id) {
            displayMessage(messageData);
        }
    });
}

function sendMessage() {
    const messageInput = document.getElementById('messageInput');
    const content = messageInput.value.trim();

    if (!currentConversation) {
        console.error('Invalid state: no conversation');
        return;
    }

    if (!content && !currentImageFile) {
        console.error('No message content or image');
        return;
    }

    if (stompClient && stompClient.connected) {
        const receiver = currentUser.id === currentConversation.sender.id
            ? currentConversation.receiver
            : currentConversation.sender;

        if (currentImageFile) {
            uploadAndSendImage(currentImageFile, receiver);
            currentImageFile = null;
            return;
        }

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

document.getElementById('imageInput')?.addEventListener('change', function (e) {
    const file = e.target.files[0];
    if (file) {
        if (file.size > 5 * 1024 * 1024) { // 5MB limit
            alert('Kích thước file không được vượt quá 5MB');
            this.value = '';
            return;
        }
        currentImageFile = file;
        sendMessage();
    }
});

async function uploadAndSendImage(file, receiver) {
    try {
        const formData = new FormData();
        formData.append('file', file);

        const response = await fetch('/api/upload/images', {
            method: 'POST',
            body: formData
        });

        if (!response.ok) {
            throw new Error('Upload failed');
        }

        const imageUrl = await response.text();

        const message = {
            conversationId: currentConversation.id,
            senderId: currentUser.id,
            receiverId: receiver.id,
            content: `<img src="${imageUrl}" alt="Uploaded image">`
        };

        stompClient.send("/app/chat.send", {}, JSON.stringify(message));

    } catch (error) {
        console.error('Error uploading image:', error);
        alert('Không thể tải lên hình ảnh. Vui lòng thử lại.');
    }
}

function formatTime(timestamp) {
    if (!timestamp) return 'Không xác định';

    try {
        // Chuyển đổi timestamp sang đối tượng moment
        const momentDate = moment(timestamp);
        if (!momentDate.isValid()) return 'Không xác định';

        // Đặt locale cho moment.js là tiếng Việt
        moment.locale('vi');

        const now = moment();
        const diff = now.diff(momentDate, 'days');

        // Trong ngày
        if (diff < 1 && momentDate.isSame(now, 'day')) {
            return momentDate.format('HH:mm');
        }

        // Trong tuần
        if (diff < 7) {
            // Sử dụng dddd để lấy tên thứ đầy đủ, sau đó lấy chữ cái đầu và số thứ tự
            const weekday = momentDate.format('dddd');
            const dayNumber = weekday === 'Chủ Nhật' ? 'CN' : 'T' + (momentDate.day() + 1);
            return momentDate.format('HH:mm ') + dayNumber;
        }

        // Sau 1 tuần
        return momentDate.format('HH:mm D [Tháng] M, YYYY');
    } catch (error) {
        console.error('Error formatting date:', error);
        return 'Không xác định';
    }
}

function shouldShowTimeDivider(currentMessageTime, previousMessageTime) {
    if (!previousMessageTime) return true;

    const current = moment(currentMessageTime);
    const previous = moment(previousMessageTime);

    // Hiển thị divider nếu khác ngày hoặc cách nhau hơn 1 giờ
    return !current.isSame(previous, 'day') ||
        Math.abs(current.diff(previous, 'hours')) >= 1;
}

function displayMessage(message) {
    const messageArea = document.getElementById('messageArea');
    if (!messageArea) return;

    const sender = message.sender || {};
    const currentUserId = currentUser.id;
    const senderId = sender.userID || sender.id;
    const messageTime = moment(message.createdAt);

    // Tìm tin nhắn cuối cùng để so sánh thời gian
    const lastMessage = messageArea.lastElementChild;
    let lastMessageTime = null;
    if (lastMessage && lastMessage.dataset.timestamp) {
        lastMessageTime = lastMessage.dataset.timestamp;
    }

    // Kiểm tra và thêm time divider nếu cần
    if (shouldShowTimeDivider(message.createdAt, lastMessageTime)) {
        const timeDivider = document.createElement('div');
        timeDivider.className = 'time-divider';
        timeDivider.innerHTML = `<span>${formatTime(message.createdAt)}</span>`;
        messageArea.appendChild(timeDivider);
    }

    const isSent = senderId === currentUserId;
    const senderFullName = sender.fullName ||
        (`${sender.firstName || ''} ${sender.lastName || ''}`.trim()) ||
        'Người dùng';
    const firstLetter = senderFullName.charAt(0).toUpperCase();

    const messageDiv = document.createElement('div');
    messageDiv.className = `message ${isSent ? 'sent' : 'received'}`;
    messageDiv.dataset.timestamp = message.createdAt;

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
    scrollToBottom(messageArea);
}

function loadConversation(conversationId) {
    fetch(`/api/chat/conversation/${conversationId}`)
        .then(response => response.json())
        .then(conversation => {
            currentConversation = conversation;
            const messageArea = document.getElementById('messageArea');
            messageArea.innerHTML = '';

            let lastMessageTime = null;
            if (conversation.messages) {
                conversation.messages.forEach(message => {

                    if (shouldShowTimeDivider(message.createdAt, lastMessageTime)) {
                        const timeDivider = document.createElement('div');
                        timeDivider.className = 'time-divider';
                        timeDivider.innerHTML = `<span>${formatTime(message.createdAt)}</span>`;
                        messageArea.appendChild(timeDivider);
                    }
                    lastMessageTime = message.createdAt;

                    displayMessage(message);
                });
            }

            // Cuộn xuống cuối sau khi tất cả tin nhắn đã được hiển thị
            scrollToBottom(messageArea);
        })
        .catch(error => console.error('Error loading conversation:', error));
}

function findConversationItem(conversationId) {

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

        const lastMessageDiv = conversationItem.querySelector('.last-message');
        if (lastMessageDiv) {
            lastMessageDiv.textContent = messageData.content;
        }


        const parent = conversationItem.parentNode;
        if (parent && parent.firstChild) {
            parent.insertBefore(conversationItem, parent.firstChild);
        }
    } else {
        console.warn('Conversation not found for update:', messageData.conversationId);
    }
}

function addNewConversationToUI(conversation) {

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

        // Đảm bảo cuộn xuống cuối sau khi trang đã load hoàn toàn
        const messageArea = document.getElementById('messageArea');
        if (messageArea) {
            // Sử dụng requestAnimationFrame để đảm bảo DOM đã được render
            requestAnimationFrame(() => {
                messageArea.scrollTop = messageArea.scrollHeight;
            });
        }
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

// Cập nhật hàm scrollToBottom để sử dụng requestAnimationFrame
function scrollToBottom(element) {
    if (!element) return;

    // Sử dụng requestAnimationFrame để đảm bảo DOM đã được render
    requestAnimationFrame(() => {
        element.scrollTop = element.scrollHeight;
    });
}
