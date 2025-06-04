package project.springBoot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import project.springBoot.model.User;
import project.springBoot.repository.UserRepository;
import project.springBoot.service.EmailService;
import project.springBoot.utils.JwtTokenUtil;

@Controller
public class ForgotPasswordController {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private EmailService emailService;

    @Autowired
    private JwtTokenUtil jwtTokenUtil;

    @GetMapping("/forgot-password")
    public String showForgotPasswordForm() {
        return "authentication/forgot-password";
    }

    @PostMapping("/forgot-password")
    public String processForgotPassword(@RequestParam("email") String email, RedirectAttributes redirectAttributes) {
        try {
            User user = userRepository.findByEmail(email);

            if (user == null) {
                redirectAttributes.addFlashAttribute("error", "Email không tồn tại trong hệ thống!");
                return "redirect:/forgot-password";
            }

            String resetToken = JwtTokenUtil.generateToken(email);
            user.setResetToken(resetToken);
            userRepository.save(user);

            emailService.sendForgotPasswordEmail(email, resetToken);

            redirectAttributes.addFlashAttribute("message",
                    "Email đã được gửi đến bạn. Vui lòng kiểm tra hộp thư!");
            return "redirect:/login";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            return "redirect:/forgot-password";
        }
    }
}