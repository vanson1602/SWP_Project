package project.springBoot.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import project.springBoot.model.Notification;
import java.util.List;

public interface NotificationService {
    Page<Notification> getAllNotifications(Long userId, Pageable pageable);

    Page<Notification> getUnreadNotifications(Long userId, Pageable pageable);

    void markAsRead(Long notificationId, Long userId);

    void markAllAsRead(Long userId);

    boolean hasUnreadNotifications(Long userId);

    int getUnreadNotificationsCount(Long userId);

    List<Notification> getRecentNotifications(Long userId);

    void createNotification(Long userId, String title, String message, String type);

    // Thêm các phương thức mới
    List<Notification> findAllByUser(Long userId);

    List<Notification> findByUserAndUnread(Long userId);
}