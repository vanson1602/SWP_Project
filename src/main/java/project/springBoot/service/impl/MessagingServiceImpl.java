package project.springBoot.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import project.springBoot.model.Conversation;
import project.springBoot.model.Message;
import project.springBoot.model.User;
import project.springBoot.repository.ConversationRepository;
import project.springBoot.repository.MessageRepository;
import project.springBoot.repository.UserRepository;
import project.springBoot.service.MessagingService;

import jakarta.transaction.Transactional;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;

@Service
public class MessagingServiceImpl implements MessagingService {

    @Autowired
    private ConversationRepository conversationRepository;

    @Autowired
    private MessageRepository messageRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @Override
    public List<Conversation> getConversations(User user) {
        System.out.println("Getting conversations for user: " + user.getUsername() + " with role: " + user.getRole());
        List<Conversation> conversations = conversationRepository.findByReceiverOrSenderOrderByLastMessageTimeDesc(user,
                user);
        System.out.println("Found " + conversations.size() + " conversations");
        return conversations;
    }

    @Override
    public Conversation getConversation(User user, Long conversationId) {
        System.out.println("Getting conversation " + conversationId + " for user: " + user.getUsername());
        Conversation conversation = conversationRepository.findById(conversationId)
                .orElseThrow(() -> new RuntimeException("Conversation not found"));

        if (!Objects.equals(conversation.getSender().getUserID(), user.getUserID()) &&
                !Objects.equals(conversation.getReceiver().getUserID(), user.getUserID())) {
            throw new RuntimeException("User does not have access to this conversation");
        }

        return conversation;
    }

    @Override
    @Transactional
    public Conversation createConversation(User sender, User receiver) {
        System.out.println("Creating conversation between sender: " + sender.getUsername() + " and receiver: "
                + receiver.getUsername());

        List<Conversation> existingConversations = getConversations(sender);
        for (Conversation conv : existingConversations) {
            if ((Objects.equals(conv.getSender().getUserID(), sender.getUserID()) &&
                    Objects.equals(conv.getReceiver().getUserID(), receiver.getUserID())) ||
                    (Objects.equals(conv.getSender().getUserID(), receiver.getUserID()) &&
                            Objects.equals(conv.getReceiver().getUserID(), sender.getUserID()))) {
                System.out.println("Found existing conversation: " + conv.getId());
                return conv;
            }
        }

        Conversation conversation = new Conversation();
        conversation.setSender(sender);
        conversation.setReceiver(receiver);
        conversation = conversationRepository.save(conversation);
        System.out.println("Created new conversation: " + conversation.getId());
        return conversation;
    }

    @Override
    @Transactional
    public Message addMessageToConversation(Long conversationId, User sender, Long receiverId, String content) {
        System.out.println("Adding message to conversation " + conversationId + " from " + sender.getUsername());

        Conversation conversation = conversationRepository.findById(conversationId)
                .orElseThrow(() -> new RuntimeException("Conversation not found"));

        User receiver = userRepository.findById(receiverId)
                .orElseThrow(() -> new RuntimeException("Receiver not found"));

        if (!Objects.equals(conversation.getSender().getUserID(), sender.getUserID()) &&
                !Objects.equals(conversation.getReceiver().getUserID(), sender.getUserID())) {
            throw new RuntimeException("User does not have access to this conversation");
        }

        Message message = new Message();
        message.setConversation(conversation);
        message.setSender(sender);
        message.setReceiver(receiver);
        message.setContent(content);
        message.setCreatedAt(LocalDateTime.now());
        message.setRead(false);

        System.out.println("Saving message content: " + content);

        // Add message to conversation and update last message time
        conversation.addMessage(message);
        conversation = conversationRepository.save(conversation);

        // Không cần lưu message riêng vì đã được lưu cùng với conversation
        System.out.println("Saved message with conversation: " + conversation.getId());

        return message;
    }
}
