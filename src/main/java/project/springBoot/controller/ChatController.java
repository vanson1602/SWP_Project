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

        Message savedMessage = messagingService.addMessageToConversation(
                conversationId,
                sender,
                receiverId,
                content);

        // Gửi tin nhắn đến topic của cuộc trò chuyện
        messagingTemplate.convertAndSend(
                "/topic/conversation/" + conversationId,
                savedMessage);

        // Gửi thông báo về cuộc hội thoại mới cho receptionist
        User receiver = userRepository.findById(receiverId)
                .orElseThrow(() -> new RuntimeException("Receiver not found"));
        if (receiver.getRole().equals("receptionist")) {
            Conversation updatedConversation = messagingService.getConversation(sender, conversationId);
            messagingTemplate.convertAndSend(
                    "/topic/conversations/" + receiverId,
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

        return "chat/chat"; // ✅ Luôn hiển thị giao diện chat
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
        model.addAttribute("conversations", conversations);
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
}
