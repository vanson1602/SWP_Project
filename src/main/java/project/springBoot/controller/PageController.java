package project.springBoot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;
import project.springBoot.model.Doctor;
import project.springBoot.model.User;
import project.springBoot.repository.DoctorRepository;
import project.springBoot.service.NotificationService;

@Controller
public class PageController {
    @Autowired
    private DoctorRepository doctorRepository;

    @Autowired
    private NotificationService notificationService;

    @RequestMapping("/")
    public String getHomePage(Model model, HttpSession session, @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "6") int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<Doctor> doctorPage = doctorRepository.findAllActiveDoctors(pageable);

        // Add notification count if user is logged in
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null) {
            int notificationCount = notificationService.getUnreadNotificationsCount(currentUser.getUserID());
            model.addAttribute("notificationCount", notificationCount);
        }

        model.addAttribute("doctors", doctorPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", doctorPage.getTotalPages());
        model.addAttribute("totalItems", doctorPage.getTotalElements());
        model.addAttribute("currentUser", currentUser);
        return "authentication/homepage";
    }

    @RequestMapping("/login")
    public String getLoginPage(Model model) {
        return "authentication/form-login";
    }

    @RequestMapping("/admin")
    public String getAdminPage(Model model) {
        return "admin/dashboard";
    }

    @RequestMapping("/register")
    public String getRegisterPage(User user, Model model) {
        model.addAttribute("user", user);
        return "authentication/form-register";
    }

    @RequestMapping("/receptionist")
    public String getReceptionistDashboard(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !currentUser.getRole().equalsIgnoreCase("receptionist")) {
            return "redirect:/access-denied";
        }
        return "receptionist/dashboard";
    }

}
