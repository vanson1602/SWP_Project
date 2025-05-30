package project.springBoot.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import project.springBoot.model.User;
@Controller
public class PageController {
    @RequestMapping("/")
    public String getHomePage(Model model) {
        return "authentication/dashboard";
    }

    @RequestMapping("/login")
    public String getLoginPage(Model model) {
        return "authentication/form-login";
    }

    @RequestMapping("/register")
    public String getRegisterPage(Model model) {
        model.addAttribute("user",new User());
        return "authentication/form-register";
    }

    

    @RequestMapping("/admin")
    public String getAdminPage(Model model) {
        return "admin/admin-page";
    }
}
