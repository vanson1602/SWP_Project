package project.springBoot.service;

import project.springBoot.model.Conversation;
import project.springBoot.model.Message;
import project.springBoot.model.User;

import java.util.List;

public interface MessagingService {
    List<Conversation> getConversations(User user);

    Conversation getConversation(User user, Long conversationId);

    Conversation createConversation(User sender, User receiver);

    Message addMessageToConversation(Long conversationId, User sender, Long receiverId, String content);
}
