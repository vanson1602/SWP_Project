package project.springBoot.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import project.springBoot.model.User;
import project.springBoot.service.UserService;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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

    @RequestMapping(value = "/admin/create", method = RequestMethod.POST)
    public String getCreatePage(Model model, @ModelAttribute("newUser") User user) {
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
    public String getDetailUserPage(Model model, @PathVariable long id) {
        User user = this.userService.getUserById(id);
        model.addAttribute("userDetail", user);
        return "user/detail-user";
    }

    @RequestMapping("/admin/user/update/{id}")
    public String getEditUserPage(Model model, @PathVariable Long id) {
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

    @RequestMapping("/profile")
    public String getProfileUserPage(Model model, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "/authentication/form-login";
        }
        model.addAttribute("user", user);
        return "user/profile";
    }

    @RequestMapping("/profile/edit")
    public String editProfile(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "/authentication/form-login";
        }
        model.addAttribute("user", currentUser);
        return "user/edit-profile";
    }

    @RequestMapping(value = "/profile/update", method = RequestMethod.POST)
    public String updateProfile(@ModelAttribute("user") User user, HttpSession session, RedirectAttributes ra) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "/authentication/form-login";
        }
        user.setId(currentUser.getId());
        user.setEmail(currentUser.getEmail());
        user.setRole(currentUser.getRole());
        user.setPassword(currentUser.getPassword());
        this.userService.handleSaveUser(user);
        session.setAttribute("currentUser", user);
        return "redirect:/profile";
    }

    @PostMapping("/register")
    public String processRegister(@ModelAttribute("user") User user, Model model) {
        user.setRole("patient");
        this.userService.handleSaveUser(user);
        model.addAttribute("message", "Đăng ký thành công!");
        return "redirect:/login";
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
