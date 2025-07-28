// Các hàm tiện ích dùng chung cho chat
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

function initializeWebSocket(currentUser, messageHandler) {
    const socket = new SockJS('/ws');
    const stompClient = Stomp.over(socket);
    stompClient.debug = null;

    stompClient.connect({}, function (frame) {
        console.log('Connected: ' + frame);

        // Subscribe to personal conversation updates
        const personalUpdatesQueue = `/topic/user/${currentUser.id || currentUser.userID}/conversations`;
        stompClient.subscribe(personalUpdatesQueue, function (message) {
            const messageData = JSON.parse(message.body);
            messageHandler(messageData);
        });

        // Subscribe to new conversations (for receptionist)
        if (currentUser.role === 'receptionist') {
            const newConversationsQueue = `/topic/conversations/${currentUser.id || currentUser.userID}`;
            stompClient.subscribe(newConversationsQueue, function (conversation) {
                const conversationData = JSON.parse(conversation.body);
                messageHandler(conversationData);
            });
        }
    }, function (error) {
        console.error('WebSocket connection error:', error);
        setTimeout(() => initializeWebSocket(currentUser, messageHandler), 5000);
    });

    return stompClient;
}

function findConversationItem(messageData) {
    console.log('Finding conversation for:', messageData);

    // Kiểm tra tất cả các ID có thể, ép về chuỗi
    const possibleIds = [
        messageData.conversationId,
        messageData.conversation?.id,
        messageData.id
    ].filter(id => id !== undefined && id !== null).map(id => id.toString());

    const senderId = (messageData.sender?.userID || messageData.sender?.id || '').toString();
    const receiverId = (messageData.receiver?.userID || messageData.receiver?.id || '').toString();

    const conversations = document.querySelectorAll('.conversation-item');
    for (const conv of conversations) {
        // Kiểm tra theo ID
        const convId = conv.getAttribute('data-conversation-id');
        if (possibleIds.includes(convId)) {
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