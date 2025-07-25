package project.springBoot.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import project.springBoot.model.Notification;
import java.util.List;
import java.util.Optional;

public interface NotificationRepository extends JpaRepository<Notification, Long> {
    Page<Notification> findByUserUserIDOrderByCreatedAtDesc(Long userId, Pageable pageable);

    Page<Notification> findByUserUserIDAndIsReadFalseOrderByCreatedAtDesc(Long userId, Pageable pageable);

    List<Notification> findByUserUserIDAndIsReadFalse(Long userId);

    Optional<Notification> findByNotificationIDAndUserUserID(Long notificationId, Long userId);

    List<Notification> findTop10ByUserUserIDOrderByCreatedAtDesc(Long userId);

    int countByUserUserIDAndIsReadFalse(Long userId);

    boolean existsByUserUserIDAndIsReadFalse(Long userId);

    // Thêm các phương thức mới
    List<Notification> findByUserUserIDOrderByCreatedAtDesc(Long userId);

    List<Notification> findByUserUserIDAndIsReadFalseOrderByCreatedAtDesc(Long userId);
}