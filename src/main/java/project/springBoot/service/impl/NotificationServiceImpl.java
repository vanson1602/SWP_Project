package project.springBoot.service.impl;

import java.time.LocalDateTime;
import java.util.List;

import org.hibernate.Hibernate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import project.springBoot.model.Notification;
import project.springBoot.model.User;
import project.springBoot.repository.NotificationRepository;
import project.springBoot.repository.UserRepository;
import project.springBoot.service.NotificationService;

@Service
@Transactional
@RequiredArgsConstructor
public class NotificationServiceImpl implements NotificationService {
    private static final Logger logger = LoggerFactory.getLogger(NotificationServiceImpl.class);

    private final NotificationRepository notificationRepository;
    private final UserRepository userRepository;

    @Override
    public int getUnreadNotificationsCount(Long userId) {
        try {
            int count = notificationRepository.countByUserUserIDAndIsReadFalse(userId);
            logger.debug("Unread notifications count for user {}: {}", userId, count);
            return count;
        } catch (Exception e) {
            logger.error("Error getting unread count for user {}: {}", userId, e.getMessage(), e);
            throw e;
        }
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Notification> getAllNotifications(Long userId, Pageable pageable) {
        try {
            logger.debug("Getting all notifications for user {} with pageable: {}", userId, pageable);
            Page<Notification> notificationsPage = notificationRepository.findByUserUserIDOrderByCreatedAtDesc(userId,
                    pageable);
            logger.debug("Found {} notifications", notificationsPage.getNumberOfElements());
            initializeNotifications(notificationsPage.getContent());
            return notificationsPage;
        } catch (Exception e) {
            logger.error("Error getting all notifications for user {}: {}", userId, e.getMessage(), e);
            throw e;
        }
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Notification> getUnreadNotifications(Long userId, Pageable pageable) {
        logger.debug("Getting unread notifications for user {} with pageable: {}", userId, pageable);
        Page<Notification> notificationsPage = notificationRepository
                .findByUserUserIDAndIsReadFalseOrderByCreatedAtDesc(userId, pageable);
        logger.debug("Found {} unread notifications", notificationsPage.getNumberOfElements());
        initializeNotifications(notificationsPage.getContent());
        return notificationsPage;
    }

    @Override
    public boolean hasUnreadNotifications(Long userId) {
        boolean hasUnread = notificationRepository.existsByUserUserIDAndIsReadFalse(userId);
        logger.debug("User {} has unread notifications: {}", userId, hasUnread);
        return hasUnread;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Notification> getRecentNotifications(Long userId) {
        try {
            List<Notification> notifications = notificationRepository.findTop10ByUserUserIDOrderByCreatedAtDesc(userId);
            initializeNotifications(notifications);
            return notifications;
        } catch (Exception e) {
            logger.error("Error getting recent notifications for user {}: {}", userId, e.getMessage(), e);
            throw e;
        }
    }

    @Override
    public void markAsRead(Long notificationId, Long userId) {
        try {
            Notification notification = notificationRepository.findByNotificationIDAndUserUserID(notificationId, userId)
                    .orElseThrow(() -> new RuntimeException("Notification not found"));
            notification.setRead(true);
            notification.setReadAt(LocalDateTime.now());
            notificationRepository.save(notification);
        } catch (Exception e) {
            logger.error("Error marking notification {} as read for user {}: {}", notificationId, userId,
                    e.getMessage(), e);
            throw e;
        }
    }

    @Override
    public void markAllAsRead(Long userId) {
        try {
            List<Notification> unreadNotifications = notificationRepository.findByUserUserIDAndIsReadFalse(userId);
            LocalDateTime now = LocalDateTime.now();
            unreadNotifications.forEach(notification -> {
                notification.setRead(true);
                notification.setReadAt(now);
            });
            notificationRepository.saveAll(unreadNotifications);
        } catch (Exception e) {
            logger.error("Error marking all notifications as read for user {}: {}", userId, e.getMessage(), e);
            throw e;
        }
    }

    @Override
    public void createNotification(Long userId, String title, String message, String type) {
        try {
            User user = userRepository.findById(userId)
                    .orElseThrow(() -> new RuntimeException("User not found with ID: " + userId));

            Notification notification = new Notification();
            notification.setUser(user);
            notification.setTitle(title);
            notification.setMessage(message);
            notification.setNotificationType(type);
            notification.setSentAt(LocalDateTime.now());
            notification.setRead(false);
            notificationRepository.save(notification);

            logger.debug("Created notification for user {}: {}", userId, title);
        } catch (Exception e) {
            logger.error("Error creating notification for user {}: {}", userId, e.getMessage(), e);
            throw e;
        }
    }

    @Override
    public List<Notification> findAllByUser(Long userId) {
        try {
            List<Notification> notifications = notificationRepository.findByUserUserIDOrderByCreatedAtDesc(userId);
            initializeNotifications(notifications);
            return notifications;
        } catch (Exception e) {
            logger.error("Error getting all notifications for user {}: {}", userId, e.getMessage(), e);
            throw e;
        }
    }

    @Override
    public List<Notification> findByUserAndUnread(Long userId) {
        try {
            List<Notification> notifications = notificationRepository
                    .findByUserUserIDAndIsReadFalseOrderByCreatedAtDesc(userId);
            initializeNotifications(notifications);
            return notifications;
        } catch (Exception e) {
            logger.error("Error getting unread notifications for user {}: {}", userId, e.getMessage(), e);
            throw e;
        }
    }

    private void initializeNotifications(List<Notification> notifications) {
        logger.debug("Initializing {} notifications", notifications.size());
        for (Notification notification : notifications) {
            try {
                Hibernate.initialize(notification.getUser());

                if (notification.getAppointment() != null) {
                    Hibernate.initialize(notification.getAppointment());

                    if (notification.getAppointment().getBookingSlot() != null) {
                        Hibernate.initialize(notification.getAppointment().getBookingSlot());

                        if (notification.getAppointment().getBookingSlot().getSchedule() != null) {
                            Hibernate.initialize(notification.getAppointment().getBookingSlot().getSchedule());

                            if (notification.getAppointment().getBookingSlot().getSchedule().getDoctor() != null) {
                                Hibernate.initialize(
                                        notification.getAppointment().getBookingSlot().getSchedule().getDoctor());

                                if (notification.getAppointment().getBookingSlot().getSchedule().getDoctor()
                                        .getUser() != null) {
                                    Hibernate.initialize(notification.getAppointment().getBookingSlot().getSchedule()
                                            .getDoctor().getUser());
                                }
                            }
                        }
                    }

                    if (notification.getAppointment().getAppointmentType() != null) {
                        Hibernate.initialize(notification.getAppointment().getAppointmentType());
                    }
                }
            } catch (Exception e) {
                logger.error("Error initializing notification {}: {}", notification.getNotificationID(),
                        e.getMessage());
            }
        }
        logger.debug("Finished initializing notifications");
    }
}