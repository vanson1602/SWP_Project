package project.springBoot.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import project.springBoot.model.Notification;
import project.springBoot.model.User;
import project.springBoot.service.NotificationService;

import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/api/notifications")
public class NotificationController {
    private static final Logger logger = LoggerFactory.getLogger(NotificationController.class);

    @Autowired
    private NotificationService notificationService;

    @GetMapping("/unread-count")
    @ResponseBody
    public ResponseEntity<?> getUnreadCount(HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return ResponseEntity.badRequest().body(Map.of("error", "User not authenticated"));
            }

            int count = notificationService.getUnreadNotificationsCount(currentUser.getUserID());
            return ResponseEntity.ok(Map.of("count", count));
        } catch (Exception e) {
            logger.error("Error getting unread count: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/all")
    @ResponseBody
    public ResponseEntity<?> getAllNotifications(
            HttpSession session,
            @RequestParam(defaultValue = "all") String filter) {

        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return ResponseEntity.status(401).body(Map.of("error", "Please login to view notifications"));
            }

            List<Notification> notifications;
            if ("unread".equals(filter)) {
                notifications = notificationService.findByUserAndUnread(currentUser.getUserID());
            } else {
                notifications = notificationService.findAllByUser(currentUser.getUserID());
            }

            List<Map<String, Object>> notificationList = notifications.stream()
                    .map(notification -> {
                        Map<String, Object> notificationMap = new HashMap<>();
                        try {
                            notificationMap.put("id", notification.getNotificationID());
                            notificationMap.put("title", notification.getTitle());
                            notificationMap.put("message", notification.getMessage());
                            notificationMap.put("type", notification.getNotificationType());
                            notificationMap.put("isRead", notification.isRead());
                            notificationMap.put("createdAt", notification.getSentAt());
                            notificationMap.put("readAt", notification.getReadAt());

                            if (notification.getAppointment() != null) {
                                notificationMap.put("appointmentId", notification.getAppointment().getAppointmentID());
                            }
                        } catch (Exception e) {
                            logger.error("Error mapping notification {}: {}", notification.getNotificationID(),
                                    e.getMessage());
                        }
                        return notificationMap;
                    })
                    .collect(Collectors.toList());

            Map<String, Object> response = new HashMap<>();
            response.put("notifications", notificationList);
            response.put("totalItems", notificationList.size());
            response.put("hasUnread", notificationService.hasUnreadNotifications(currentUser.getUserID()));

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            logger.error("Error getting notifications: {}", e.getMessage(), e);
            return ResponseEntity.status(500).body(Map.of("error", "Internal server error: " + e.getMessage()));
        }
    }

    @GetMapping("/list")
    @ResponseBody
    public ResponseEntity<?> getNotificationsList(
            HttpSession session,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "5") int size,
            @RequestParam(defaultValue = "all") String filter) {

        try {
            logger.debug("Session ID: {}", session.getId());
            logger.debug("Session attributes: {}", session.getAttributeNames());

            User currentUser = (User) session.getAttribute("currentUser");
            logger.debug("Current user from session: {}", currentUser);

            if (currentUser == null) {
                logger.error("No user found in session");
                return ResponseEntity.status(401).body(Map.of("error", "Please login to view notifications"));
            }

            // Giới hạn kích thước trang tối đa là 100
            if (size > 100) {
                size = 100;
            }

            logger.debug("Getting notifications for user: {}, page: {}, size: {}, filter: {}",
                    currentUser.getUserID(), page, size, filter);

            PageRequest pageRequest = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "sentAt"));
            Page<Notification> notifications;

            if ("unread".equals(filter)) {
                notifications = notificationService.getUnreadNotifications(currentUser.getUserID(), pageRequest);
            } else {
                notifications = notificationService.getAllNotifications(currentUser.getUserID(), pageRequest);
            }

            List<Map<String, Object>> notificationList = notifications.getContent().stream()
                    .map(notification -> {
                        Map<String, Object> notificationMap = new HashMap<>();
                        try {
                            notificationMap.put("id", notification.getNotificationID());
                            notificationMap.put("title", notification.getTitle());
                            notificationMap.put("message", notification.getMessage());
                            notificationMap.put("type", notification.getNotificationType());
                            notificationMap.put("isRead", notification.isRead());
                            notificationMap.put("createdAt", notification.getSentAt());
                            notificationMap.put("readAt", notification.getReadAt());

                            if (notification.getAppointment() != null) {
                                notificationMap.put("appointmentId", notification.getAppointment().getAppointmentID());
                            }
                        } catch (Exception e) {
                            logger.error("Error mapping notification {}: {}", notification.getNotificationID(),
                                    e.getMessage());
                        }
                        return notificationMap;
                    })
                    .collect(Collectors.toList());

            Map<String, Object> response = new HashMap<>();
            response.put("notifications", notificationList);
            response.put("currentPage", notifications.getNumber());
            response.put("totalPages", notifications.getTotalPages());
            response.put("totalItems", notifications.getTotalElements());
            response.put("pageSize", size);
            response.put("hasUnread", notificationService.hasUnreadNotifications(currentUser.getUserID()));

            logger.debug("Returning {} notifications out of {} total", notificationList.size(),
                    notifications.getTotalElements());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            logger.error("Error getting notifications: {}", e.getMessage(), e);
            return ResponseEntity.status(500).body(Map.of("error", "Internal server error: " + e.getMessage()));
        }
    }

    @PostMapping("/{id}/mark-read")
    @ResponseBody
    public ResponseEntity<?> markAsRead(@PathVariable Long id, HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return ResponseEntity.badRequest().body(Map.of("error", "User not authenticated"));
            }

            notificationService.markAsRead(id, currentUser.getUserID());
            int unreadCount = notificationService.getUnreadNotificationsCount(currentUser.getUserID());

            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "unreadCount", unreadCount));
        } catch (Exception e) {
            logger.error("Error marking notification as read: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/mark-all-read")
    @ResponseBody
    public ResponseEntity<?> markAllAsRead(HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return ResponseEntity.badRequest().body(Map.of("error", "User not authenticated"));
            }

            notificationService.markAllAsRead(currentUser.getUserID());
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "unreadCount", 0));
        } catch (Exception e) {
            logger.error("Error marking all notifications as read: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
}