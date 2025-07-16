package project.springBoot.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import project.springBoot.model.Conversation;
import project.springBoot.model.User;

import java.util.List;

@Repository
public interface ConversationRepository extends JpaRepository<Conversation, Long> {
        List<Conversation> findByReceiverOrSenderOrderByLastMessageTimeDesc(User receiver, User sender);
}
