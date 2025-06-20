package project.springBoot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import project.springBoot.model.User;
import project.springBoot.service.UserService;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;
import java.util.UUID;
import lombok.extern.slf4j.Slf4j;
import java.time.LocalDateTime;

@Slf4j
@Controller
public class ProfileController {

    private final UserService userService;

    private static final String UPLOAD_DIR = "uploads/avatars/";
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024;
    private static final String[] ALLOWED_EXTENSIONS = { ".jpg", ".jpeg", ".png", ".gif" };

    @Autowired
    public ProfileController(UserService userService) {
        this.userService = userService;
    }

    @RequestMapping("/profile")
    public String getProfileUserPage(Model model, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }
        model.addAttribute("user", user);
        return "user/profile";
    }

    @RequestMapping("/profile/edit")
    public String editProfile(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        model.addAttribute("user", currentUser);
        return "user/edit-profile";
    }

    @RequestMapping(value = "/profile/update", method = RequestMethod.POST)
    public String updateProfile(@ModelAttribute("user") User user,
            @RequestParam(value = "avatarFile", required = false) MultipartFile file,
            HttpSession session,
            RedirectAttributes ra) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        // Keep unchanged values from the current user
        user.setUserID(currentUser.getUserID());
        user.setUsername(currentUser.getUsername());
        user.setEmail(currentUser.getEmail());
        user.setRole(currentUser.getRole());
        user.setPassword(currentUser.getPassword());
        user.setAvatarUrl(currentUser.getAvatarUrl());
        user.setVerificationToken(currentUser.getVerificationToken());
        user.setVerified(currentUser.isVerified());
        user.setResetToken(currentUser.getResetToken());
        user.setResetTokenExpiry(currentUser.getResetTokenExpiry());
        user.setLastLogin(currentUser.getLastLogin());
        user.setState(currentUser.getState());
        user.setCreatedAt(currentUser.getCreatedAt());
        user.setModifiedAt(LocalDateTime.now());
        user.setModifiedBy(currentUser.getModifiedBy());

        // Handle avatar upload if provided
        if (file != null && !file.isEmpty()) {
            try {
                String avatarUrl = handleAvatarUpload(file, user);
                if (avatarUrl != null) {
                    user.setAvatarUrl(avatarUrl);
                }
            } catch (IllegalArgumentException e) {
                ra.addFlashAttribute("error", e.getMessage());
                return "redirect:/profile/edit";
            } catch (RuntimeException e) {
                ra.addFlashAttribute("error", "Có lỗi xảy ra khi tải lên ảnh. Vui lòng thử lại sau!");
                return "redirect:/profile/edit";
            }
        }

        try {
            userService.handleSaveUser(user);
            session.setAttribute("currentUser", user);
            ra.addFlashAttribute("success", "Cập nhật thông tin thành công!");
            return "redirect:/profile";
        } catch (Exception e) {
            log.error("Error updating user profile", e);
            ra.addFlashAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại sau!");
            return "redirect:/profile/edit";
        }
    }

    @PostMapping("/profile/change-password")
    public String changePassword(@RequestParam("currentPassword") String currentPassword,
            @RequestParam("newPassword") String newPassword,
            @RequestParam("confirmPassword") String confirmPassword,
            HttpSession session,
            RedirectAttributes ra) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return "redirect:/login";
            }

            // Validate current password
            if (!BCrypt.checkpw(currentPassword, currentUser.getPassword())) {
                ra.addFlashAttribute("error", "Mật khẩu hiện tại không đúng");
                return "redirect:/profile";
            }

            // Validate new password
            if (!newPassword.equals(confirmPassword)) {
                ra.addFlashAttribute("error", "Mật khẩu xác nhận không khớp");
                return "redirect:/profile";
            }

            // Update password
            String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
            currentUser.setPassword(hashedPassword);
            userService.handleUpdateUser(currentUser);
            session.setAttribute("currentUser", currentUser);

            ra.addFlashAttribute("success", "Đổi mật khẩu thành công!");
            return "redirect:/profile";
        } catch (Exception e) {
            e.printStackTrace();
            ra.addFlashAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại sau!");
            return "redirect:/profile";
        }
    }

    private String handleAvatarUpload(MultipartFile file, User user) {
        if (file == null || file.isEmpty()) {
            return null;
        }

        // Validate file size
        if (file.getSize() > MAX_FILE_SIZE) {
            throw new IllegalArgumentException("File size exceeds maximum limit of 5MB");
        }

        // Validate file extension
        String originalFilename = file.getOriginalFilename();
        String extension = originalFilename != null
                ? originalFilename.substring(originalFilename.lastIndexOf(".")).toLowerCase()
                : "";
        boolean isValidExtension = Arrays.asList(ALLOWED_EXTENSIONS).contains(extension);
        if (!isValidExtension) {
            throw new IllegalArgumentException(
                    "Invalid file type. Allowed types: " + String.join(", ", ALLOWED_EXTENSIONS));
        }

        try {
            // Create upload directory if it doesn't exist
            Path uploadPath = Paths.get(UPLOAD_DIR);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            // Generate unique filename
            String filename = String.format("avatar_%d_%s%s",
                    user.getUserID(),
                    UUID.randomUUID().toString().substring(0, 8),
                    extension);

            // Save file
            Path filePath = uploadPath.resolve(filename);
            Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

            return "/uploads/avatars/" + filename;

        } catch (IOException e) {
            throw new RuntimeException("Failed to store avatar file", e);
        }
    }
}