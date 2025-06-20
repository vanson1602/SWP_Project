package project.springBoot.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import project.springBoot.model.Notification;
import project.springBoot.model.User;
import project.springBoot.service.NotificationService;

import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/notifications")
public class NotificationController {
    private final NotificationService notificationService;
    private final ObjectMapper objectMapper;

    public NotificationController(NotificationService notificationService, ObjectMapper objectMapper) {
        this.notificationService = notificationService;
        this.objectMapper = objectMapper;
        this.objectMapper.registerModule(new JavaTimeModule());
    }

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
    public ResponseEntity<List<Notification>> getNotifications(HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return ResponseEntity.badRequest().build();
        }

        List<Notification> notifications = notificationService.getRecentNotifications(currentUser.getUserID());

        try {
            System.out.println("Debug - Notifications JSON: " + objectMapper.writeValueAsString(notifications));
        } catch (Exception e) {
            e.printStackTrace();
        }

        return ResponseEntity.ok(notifications);
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