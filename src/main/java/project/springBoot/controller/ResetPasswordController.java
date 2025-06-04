package project.springBoot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import project.springBoot.model.User;
import project.springBoot.repository.UserRepository;
import project.springBoot.service.UserService;
import project.springBoot.utils.JwtTokenUtil;

@Controller
public class ResetPasswordController {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserService userService;

    @Autowired
    private JwtTokenUtil jwtTokenUtil;

    @GetMapping("/reset-password")
    public String showResetPasswordForm(@RequestParam("token") String token, RedirectAttributes redirectAttributes) {
        try {
            String email = jwtTokenUtil.extractEmail(token);
            User user = userRepository.findByEmail(email);

            if (user == null || user.getResetToken() == null) {
                redirectAttributes.addFlashAttribute("error", "Link đặt lại mật khẩu không hợp lệ!");
                return "redirect:/login";
            }

            if (!jwtTokenUtil.validateToken(token) || !user.getResetToken().equals(token)) {
                redirectAttributes.addFlashAttribute("error", "Link đặt lại mật khẩu đã hết hạn!");
                return "redirect:/login";
            }

            return "authentication/reset-password";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            return "redirect:/login";
        }
    }

    @PostMapping("/reset-password")
    public String processResetPassword(
            @RequestParam("token") String token,
            @RequestParam("password") String password,
            @RequestParam("confirmPassword") String confirmPassword,
            RedirectAttributes redirectAttributes) {
        try {
            String email = jwtTokenUtil.extractEmail(token);
            User user = userRepository.findByEmail(email);

            if (user == null || user.getResetToken() == null) {
                redirectAttributes.addFlashAttribute("error", "Link đặt lại mật khẩu không hợp lệ!");
                return "redirect:/login";
            }

            if (!jwtTokenUtil.validateToken(token) || !user.getResetToken().equals(token)) {
                redirectAttributes.addFlashAttribute("error", "Link đặt lại mật khẩu đã hết hạn!");
                return "redirect:/login";
            }

            if (!password.equals(confirmPassword)) {
                redirectAttributes.addFlashAttribute("error", "Mật khẩu xác nhận không khớp!");
                return "redirect:/reset-password?token=" + token;
            }

            user.setPassword(password);
            user.setResetToken(null);
            userService.handleUpdateUser(user);

            redirectAttributes.addFlashAttribute("message", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập.");
            return "redirect:/login";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            return "redirect:/reset-password?token=" + token;
        }
    }
}