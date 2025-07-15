package project.springBoot.controller;

import java.time.LocalDateTime;

import org.mindrot.jbcrypt.BCrypt;
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
import lombok.extern.slf4j.Slf4j;
import project.springBoot.model.User;
import project.springBoot.service.UploadFileService;
import project.springBoot.service.UserService;

@Slf4j
@Controller
public class ProfileController {

    private final UserService userService;
    private final UploadFileService uploadFileService;

    private static final String UPLOAD_DIR = "uploads/avatars/";
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024;
    private static final String[] ALLOWED_EXTENSIONS = { ".jpg", ".jpeg", ".png", ".gif" };

    @Autowired
    public ProfileController(UserService userService, UploadFileService uploadFileService) {
        this.userService = userService;
        this.uploadFileService = uploadFileService;
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
        user.setIsVerified(currentUser.getIsVerified());
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
                String avatarUrl = uploadFileService.uploadImage(file);
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

}