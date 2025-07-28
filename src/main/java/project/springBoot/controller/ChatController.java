package project.springBoot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import project.springBoot.model.Conversation;
import project.springBoot.model.Message;
import project.springBoot.model.User;
import project.springBoot.repository.UserRepository;
import project.springBoot.service.MessagingService;

import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;

@Controller
public class ChatController {

    @Autowired
    private MessagingService messagingService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @MessageMapping("/chat.send")
    public void sendMessage(@Payload Map<String, Object> messageData) {
        System.out.println("Received message data: " + messageData);

        Long conversationId = ((Number) messageData.get("conversationId")).longValue();
        Long senderId = ((Number) messageData.get("senderId")).longValue();
        Long receiverId = ((Number) messageData.get("receiverId")).longValue();
        String content = (String) messageData.get("content");

        User sender = userRepository.findById(senderId)
                .orElseThrow(() -> new RuntimeException("Sender not found"));
        User receiver = userRepository.findById(receiverId)
                .orElseThrow(() -> new RuntimeException("Receiver not found"));

        Message savedMessage = messagingService.addMessageToConversation(
                conversationId,
                sender,
                receiverId,
                content);

        System.out.println("Saved message with timestamp: " + savedMessage.getCreatedAt()); // Add logging

        // Lấy conversation đã cập nhật
        Conversation updatedConversation = messagingService.getConversation(sender, conversationId);

        // Gửi tin nhắn đến topic của cuộc trò chuyện
        messagingTemplate.convertAndSend(
                "/topic/conversation/" + conversationId,
                savedMessage);

        // Gửi cập nhật conversation cho cả người gửi và người nhận
        Map<String, Object> conversationUpdate = Map.of(
                "conversationId", conversationId,
                "content", content,
                "createdAt", savedMessage.getCreatedAt().toString(), // Add timestamp
                "sender", Map.of(
                        "userID", sender.getUserID(),
                        "firstName", sender.getFirstName(),
                        "lastName", sender.getLastName()),
                "receiver", Map.of(
                        "userID", receiver.getUserID(),
                        "firstName", receiver.getFirstName(),
                        "lastName", receiver.getLastName()),
                "isRead", savedMessage.isRead() // Thêm trường này để JS nhận biết
        );

        System.out.println("Sending conversation update: " + conversationUpdate); // Add logging

        messagingTemplate.convertAndSend(
                "/topic/user/" + senderId + "/conversations",
                conversationUpdate);

        messagingTemplate.convertAndSend(
                "/topic/user/" + receiverId + "/conversations",
                conversationUpdate);

        if (receiver.getRole().equals("receptionist") || sender.getRole().equals("receptionist")) {
            messagingTemplate.convertAndSend(
                    "/topic/conversations/" + (receiver.getRole().equals("receptionist") ? receiverId : senderId),
                    updatedConversation);
        }
    }

    @GetMapping("/chat/conversation/{conversationId}")
    public String getConversationPage(@PathVariable Long conversationId, Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            return "redirect:/login";
        }

        Conversation conversation = messagingService.getConversation(currentUser, conversationId);
        model.addAttribute("conversation", conversation);
        model.addAttribute("currentUser", currentUser);

        return "chat/chat";
    }

    @GetMapping("/api/chat/conversation/{conversationId}")
    @ResponseBody
    public Conversation getConversationData(@PathVariable Long conversationId, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            throw new RuntimeException("User not authenticated");
        }
        return messagingService.getConversation(currentUser, conversationId);
    }

    @GetMapping("/chat")
    public String getChatPage(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            return "redirect:/login";
        }

        if (currentUser.getRole().equals("receptionist")) {
            List<Conversation> conversations = messagingService.getConversations(currentUser);
            model.addAttribute("conversations", conversations);
            model.addAttribute("currentUser", currentUser);
            return "receptionist/dashboard";
        }

        User receptionist = userRepository.findByRoleAndUsername("receptionist", "receptionist1");
        if (receptionist == null) {
            receptionist = userRepository.findFirstByRole("receptionist");
        }

        Conversation conversation = messagingService.createConversation(currentUser, receptionist);
        model.addAttribute("conversation", conversation);
        model.addAttribute("currentUser", currentUser);

        return "chat/chat";
    }

    @GetMapping("/receptionist")
    public String getReceptionistDashboard(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            return "redirect:/login";
        }

        if (!currentUser.getRole().equals("receptionist")) {
            return "redirect:/access-denied";
        }

        List<Conversation> conversations = messagingService.getConversations(currentUser);
        java.util.Map<Long, Boolean> unreadMap = new java.util.HashMap<>();
        for (Conversation conv : conversations) {
            boolean unread = false;
            java.util.List<project.springBoot.model.Message> messages = conv.getMessages();
            if (messages != null && !messages.isEmpty()) {
                project.springBoot.model.Message last = messages.get(messages.size() - 1);
                unread = Long.valueOf(last.getReceiver().getUserID()).equals(currentUser.getUserID()) && !last.isRead();
            }
            unreadMap.put(conv.getId(), unread);
        }
        model.addAttribute("conversations", conversations);
        model.addAttribute("unreadMap", unreadMap);
        model.addAttribute("currentUser", currentUser);
        return "receptionist/dashboard";
    }

    @GetMapping("/chat/receptionist")
    @ResponseBody
    public ResponseEntity<?> getReceptionist(HttpSession session) {
        User receptionist = userRepository.findByRoleAndUsername("receptionist", "receptionist1");
        if (receptionist == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok().body(Map.of("id", receptionist.getUserID()));
    }

    @PostMapping("/chat/conversations")
    @ResponseBody
    public ResponseEntity<?> createConversation(
            @RequestParam("receiverId") Long receiverId,
            HttpSession session) {

        User sender = (User) session.getAttribute("currentUser");

        if (sender == null) {
            return ResponseEntity.status(401).body("Unauthorized");
        }

        User receiver = userRepository.findById(receiverId).orElse(null);
        if (receiver == null) {
            return ResponseEntity.status(404).body("Receiver not found");
        }

        try {
            Conversation conversation = messagingService.createConversation(sender, receiver);
            return ResponseEntity.ok(conversation);
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error creating conversation: " + e.getMessage());
        }
    }

    @PostMapping("/api/chat/conversation/{conversationId}/mark-read")
    @ResponseBody
    public ResponseEntity<?> markConversationAsRead(
            @PathVariable Long conversationId,
            HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return ResponseEntity.status(401).body("User not authenticated");
            }
            Conversation conversation = messagingService.findById(conversationId);
            if (conversation == null) {
                return ResponseEntity.notFound().build();
            }
            boolean updated = messagingService.markConversationAsRead(conversation, currentUser);
            return updated ? ResponseEntity.ok().build() : ResponseEntity.badRequest().build();
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }
}
