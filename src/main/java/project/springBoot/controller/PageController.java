package project.springBoot.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import ch.qos.logback.core.model.Model;
@Controller
public class PageController {
    @RequestMapping("/")
    public String getHomePage(Model model) {
        return "authentication/form-login";
    }
}
