package project.springBoot.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import project.springBoot.model.Notification;
import project.springBoot.repository.NotificationRepository;
import project.springBoot.service.NotificationService;

import java.time.LocalDateTime;
import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class NotificationServiceImpl implements NotificationService {
    private final NotificationRepository notificationRepository;

    @Override
    public long getUnreadCount(Long userId) {
        return notificationRepository.countByUserUserIDAndIsReadFalse(userId);
    }

    @Override
    public List<Notification> getRecentNotifications(Long userId) {
        return notificationRepository.findTop10ByUserUserIDOrderByCreatedAtDesc(userId);
    }

    @Override
    public void markAsRead(Long notificationId, Long userId) {
        Notification notification = notificationRepository.findByNotificationIDAndUserUserID(notificationId, userId)
                .orElseThrow(() -> new RuntimeException("Notification not found"));

        notification.setRead(true);
        notification.setReadAt(LocalDateTime.now());
        notificationRepository.save(notification);
    }

    @Override
    public void markAllAsRead(Long userId) {
        List<Notification> unreadNotifications = notificationRepository.findByUserUserIDAndIsReadFalse(userId);
        LocalDateTime now = LocalDateTime.now();

        unreadNotifications.forEach(notification -> {
            notification.setRead(true);
            notification.setReadAt(now);
        });

        notificationRepository.saveAll(unreadNotifications);
    }

    @Override
    public void createNotification(Long userId, String title, String message, String type) {
        Notification notification = new Notification();
        notification.setTitle(title);
        notification.setMessage(message);
        notification.setNotificationType(type);
        notification.setSentAt(LocalDateTime.now());
        notificationRepository.save(notification);
    }
}