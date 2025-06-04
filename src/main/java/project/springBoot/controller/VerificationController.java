package project.springBoot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import project.springBoot.model.User;
import project.springBoot.repository.UserRepository;
import project.springBoot.utils.JwtTokenUtil;

@Controller
public class VerificationController {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JwtTokenUtil jwtUtil;

    @GetMapping("/register/verify")
    public String verifyEmail(@RequestParam("token") String token, RedirectAttributes redirectAttributes) {
        try {
            String emailString = jwtUtil.extractEmail(token);
            User user = userRepository.findByEmail(emailString);

            if (user == null || user.getVerificationToken() == null) {
                redirectAttributes.addFlashAttribute("error", "Token không hợp lệ!");
                return "redirect:/login";
            }

            if (!jwtUtil.validateToken(token) || !user.getVerificationToken().equals(token)) {
                redirectAttributes.addFlashAttribute("error", "Token đã hết hạn!");
                return "redirect:/login";
            }

            user.setVerificationToken(null);
            user.setVerified(true);
            userRepository.save(user);

            redirectAttributes.addFlashAttribute("message", "Xác thực email thành công! Vui lòng đăng nhập.");
            return "redirect:/login";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            return "redirect:/login";
        }
    }
}
