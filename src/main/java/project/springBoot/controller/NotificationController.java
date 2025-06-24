package project.springBoot.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import project.springBoot.model.Notification;
import project.springBoot.model.NotificationDTO;
import project.springBoot.model.User;
import project.springBoot.service.NotificationService;

import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/notifications")
@RequiredArgsConstructor
public class NotificationController {
    private final NotificationService notificationService;

    @GetMapping("/unread-count")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getUnreadCount(HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return ResponseEntity.badRequest().body(Map.of("error", "User not logged in"));
        }

        long unreadCount = notificationService.getUnreadCount(currentUser.getUserID());
        return ResponseEntity.ok(Map.of("count", unreadCount));
    }

    @GetMapping("/list")
    @ResponseBody
    public ResponseEntity<List<NotificationDTO>> getNotifications(HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return ResponseEntity.badRequest().build();
        }

        List<Notification> notifications = notificationService.getRecentNotifications(currentUser.getUserID());
        List<NotificationDTO> notificationDTOs = notifications.stream()
                .map(NotificationDTO::fromEntity)
                .collect(Collectors.toList());

        return ResponseEntity.ok(notificationDTOs);
    }

    @PostMapping("/{id}/mark-read")
    @ResponseBody
    public ResponseEntity<Void> markAsRead(@PathVariable("id") Long notificationId, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return ResponseEntity.badRequest().build();
        }

        notificationService.markAsRead(notificationId, currentUser.getUserID());
        return ResponseEntity.ok().build();
    }

    @PostMapping("/mark-all-read")
    @ResponseBody
    public ResponseEntity<Void> markAllAsRead(HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return ResponseEntity.badRequest().build();
        }

        notificationService.markAllAsRead(currentUser.getUserID());
        return ResponseEntity.ok().build();
    }
}