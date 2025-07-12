package project.springBoot.controller;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import lombok.extern.slf4j.Slf4j;
import project.springBoot.model.Doctor;
import project.springBoot.model.User;
import project.springBoot.service.AppointmentService;
import project.springBoot.service.UploadFileService;
import project.springBoot.service.UserService;

@Slf4j
@Controller 
public class UserController {
    private final UserService userService;
    private final UploadFileService uploadFileService;
    private final AppointmentService appointmentService;

    public UserController(UserService userService, UploadFileService uploadFileService, AppointmentService appointmentService) {
        this.userService = userService;
        this.uploadFileService = uploadFileService;
        this.appointmentService = appointmentService;
    }

    @RequestMapping("/admin/createUser")
    public String getCreateUserPage(Model model) {
        model.addAttribute("newUser", new User());
        return "user/create-user";
    }

    @RequestMapping(value = "/admin/create", method = RequestMethod.POST)
    public String getCreatePage(Model model, @ModelAttribute("newUser") User user,
            @RequestParam("image") MultipartFile image) {
        try {
            if (!image.isEmpty()) {
                String imageUrl = uploadFileService.uploadImage(image);
                user.setAvatarUrl(imageUrl);
                System.out.println("Image URL: " + imageUrl);
            }
            this.userService.handleSaveUser(user);
            System.out.println("User: " + user);
            return "redirect:user";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/admin/create";
        }
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

    @PostMapping("/users/update")
    public ResponseEntity<?> updateUser(@RequestParam(required = false) MultipartFile file,
            @RequestBody User updatedUser,
            @AuthenticationPrincipal UserDetails userDetails) {
        try {
            User currentUser = userService.findByUsername(userDetails.getUsername())
                    .orElseThrow(() -> new UsernameNotFoundException("User not found"));
            currentUser.setFirstName(updatedUser.getFirstName());
            currentUser.setLastName(updatedUser.getLastName());
            currentUser.setPhone(updatedUser.getPhone());
            currentUser.setAddress(updatedUser.getAddress());
            currentUser.setGender(updatedUser.getGender());
            currentUser.setDob(updatedUser.getDob());

            if (file != null && !file.isEmpty()) {
                String avatarUrl = uploadFileService.uploadImage(file);
                if (avatarUrl != null) {
                    currentUser.setAvatarUrl(avatarUrl);
                }
            }

            currentUser.setModifiedAt(LocalDateTime.now());
            User savedUser = userService.save(currentUser);

            return ResponseEntity.ok(savedUser);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error updating user: " + e.getMessage());
        }
    }

    @GetMapping("/admin/doctor/create")
    public String getCreateDoctorPage(Model model) {
        model.addAttribute("newDoctor", new Doctor());
        return "doctor/create-doctor";
    }
}
