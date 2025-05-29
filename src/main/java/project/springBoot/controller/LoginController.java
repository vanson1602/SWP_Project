package project.springBoot.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import org.springframework.ui.Model;
import jakarta.servlet.http.HttpSession;
import project.springBoot.model.User;
import project.springBoot.service.UserService;

@Controller
public class LoginController {
     private final UserService userService;

    @Value("${google.client.id}")
    private String clientId;

    @Value("${google.redirect.uri}")
    private String redirectUri;

     public LoginController(UserService userService) {
        this.userService = userService;
     }

    @GetMapping("/login")
    public String loginPage(Model model) {
    String googleLoginUrl = "https://accounts.google.com/o/oauth2/v2/auth?" +
            "client_id=" + clientId +
            "&redirect_uri=" + redirectUri +
            "&response_type=code" +
            "&scope=openid%20email%20profile" +
            "&access_type=online";
    model.addAttribute("googleLoginUrl", googleLoginUrl);
    return "authentication/form-login";
}

    @PostMapping("/login")
    public String handleLogin(@RequestParam String email,
                          @RequestParam String password,
                          HttpSession session,
                          Model model) {
        User user = userService.login(email, password);
        if (user != null) {
            session.setAttribute("currentUser", user);

            String role = user.getRole(); // Giả sử User có getRole()

            if ("admin".equalsIgnoreCase(role)) {
            return "redirect:/admin";
            } else if ("patient".equalsIgnoreCase(role) || 
                   "doctor".equalsIgnoreCase(role) || 
                   "receptionist".equalsIgnoreCase(role)) {
            return "redirect:/";
            } else {
            return "redirect:/";
            }
        } else {
            model.addAttribute("error", "Sai email hoặc mật khẩu!");
            return "authentication/form-login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }
     
}
