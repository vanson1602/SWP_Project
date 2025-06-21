package project.springBoot.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import project.springBoot.model.Notification;
import project.springBoot.model.User;

import java.util.List;
import java.util.Optional;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Long> {
    List<Notification> findByUserOrderByCreatedAtDesc(User user);

    List<Notification> findByUserAndIsReadOrderByCreatedAtDesc(User user, boolean isRead);

    long countByUserAndIsRead(User user, boolean isRead);

    long countByUserUserIDAndIsReadFalse(Long userId);

    List<Notification> findTop10ByUserUserIDOrderByCreatedAtDesc(Long userId);

    Optional<Notification> findByNotificationIDAndUserUserID(Long notificationId, Long userId);

    List<Notification> findByUserUserIDAndIsReadFalse(Long userId);
}