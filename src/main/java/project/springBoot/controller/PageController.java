package project.springBoot.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import ch.qos.logback.core.model.Model;
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
        return "authentication/form-register";
    }

    @RequestMapping("/admin")
    public String getAdminPage(Model model) {
        return "admin/admin-page";
    }
}
