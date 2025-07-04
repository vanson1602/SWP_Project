package project.springBoot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import project.springBoot.model.Doctor;
import project.springBoot.model.User;
import project.springBoot.repository.DoctorRepository;

@Controller
public class PageController {
    @Autowired
    private DoctorRepository doctorRepository;

    @RequestMapping("/")
    public String getHomePage(Model model, @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "8") int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<Doctor> doctorPage = doctorRepository.findAllActiveDoctors(pageable);

        model.addAttribute("doctors", doctorPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", doctorPage.getTotalPages());
        model.addAttribute("totalItems", doctorPage.getTotalElements());
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

    @RequestMapping("/doctor")
    public String getDoctorPage(Model model) {
        return "doctor/doctorpage";
    }

}
