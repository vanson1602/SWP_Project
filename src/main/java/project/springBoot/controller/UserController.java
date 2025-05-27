package project.springBoot.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import project.springBoot.model.User;
import project.springBoot.service.UserService;

@Controller
public class UserController {
    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @RequestMapping("/admin/create")
    public String getCreateUserPage(Model model) {
        model.addAttribute("newUser", new User());
        return "user/create-user";
    }

    @RequestMapping(value="/admin/create", method = RequestMethod.POST)
    public String getCreatePage(Model model,@ModelAttribute("newUser") User user) {
        this.userService.handleSaveUser(user);
        return "redirect:user";
    }

    @RequestMapping("/admin/user")
    public String getUserPage(Model model) {
        List<User> users = this.userService.getAllUser();
        model.addAttribute("users", users);
        return "user/list-user";
    }

    @RequestMapping("/admin/user/{id}")
    public String getDetailUserPage(Model model,@PathVariable long id) {
        User user = this.userService.getUserById(id);
        model.addAttribute("userDetail", user);
        return "user/detail-user";
    }

    @RequestMapping("/admin/user/update/{id}")
    public String getEditUserPage(Model model,@PathVariable Long id) {
        User user = this.userService.getUserById(id);
        model.addAttribute("user", user);
        return "user/update-user";
    }

    @RequestMapping(value = "/admin/update", method = RequestMethod.POST)
        public String updateUser(@ModelAttribute("update") User user) {
        userService.handleUpdateUser(user);
        return "redirect:/admin/user";      
    }

    @RequestMapping("/admin/user/delete/{id}")
        public String deleteUser(@PathVariable Long id) {
        userService.deleteUserById(id);
        return "redirect:/admin/user";
    }
}   
