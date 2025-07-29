package project.springBoot.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import project.springBoot.model.Message;
import project.springBoot.model.Conversation;
import project.springBoot.model.User;

import java.util.List;

@Repository
public interface MessageRepository extends JpaRepository<Message, Long> {
    List<Message> findByConversation(Conversation conversation);

    List<Message> findByConversationAndReceiverAndIsReadFalse(Conversation conversation, User receiver);

    List<Message> findByConversationOrderByCreatedAtDesc(Conversation conversation);
}
