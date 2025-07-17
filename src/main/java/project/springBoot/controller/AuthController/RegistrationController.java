package project.springBoot.controller.AuthController;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import project.springBoot.model.Patient;
import project.springBoot.model.User;
import project.springBoot.repository.PatientRepository;
import project.springBoot.repository.UserRepository;
import project.springBoot.service.EmailService;
import project.springBoot.service.UserService;
import project.springBoot.utils.JwtTokenUtil;

@Controller
public class RegistrationController {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private UserService userService;

    @Autowired
    private EmailService emailService;

    @Autowired
    private JwtTokenUtil jwtTokenUtil;

    @PostMapping("/register")
    public String register(@ModelAttribute User user, RedirectAttributes redirectAttributes) {
        try {
            User existingUser = userRepository.findByEmail(user.getEmail());
            if (existingUser != null) {
                if (existingUser.getIsVerified()) {
                    redirectAttributes.addFlashAttribute("error", "Email đã được đăng ký và xác thực!");
                    return "redirect:/register";
                } else {
                    String verificationToken = JwtTokenUtil.generateToken(existingUser.getEmail());
                    existingUser.setVerificationToken(verificationToken);
                    userRepository.save(existingUser);
                    emailService.sendVerificationEmail(existingUser.getEmail(), verificationToken);
                    redirectAttributes.addFlashAttribute("message",
                            "Email xác thực đã được gửi lại, vui lòng kiểm tra hộp thư của bạn!");
                    return "redirect:/login";
                }
            }

            userService.handleSaveUser(user);
            String verificationToken = JwtTokenUtil.generateToken(user.getEmail());
            user.setVerificationToken(verificationToken);
            user.setRole("patient");
            userRepository.save(user);
            Patient patient = new Patient();
            patient.setUser(user);
            patientRepository.save(patient);

            emailService.sendVerificationEmail(user.getEmail(), verificationToken);

            redirectAttributes.addFlashAttribute("message",
                    "Đăng ký thành công! Vui lòng kiểm tra email để xác thực tài khoản.");
            return "redirect:/login";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            return "redirect:/register";
        }
    }
}
