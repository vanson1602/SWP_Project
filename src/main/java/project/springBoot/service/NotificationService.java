package project.springBoot.service;

import project.springBoot.model.Notification;
import java.util.List;

public interface NotificationService {
    long getUnreadCount(Long userId);

    List<Notification> getRecentNotifications(Long userId);

    void markAsRead(Long notificationId, Long userId);

    void markAllAsRead(Long userId);

    void createNotification(Long userId, String title, String message, String type);
}