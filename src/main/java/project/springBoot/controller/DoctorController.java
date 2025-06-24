package project.springBoot.controller;

import lombok.extern.slf4j.Slf4j;
import project.springBoot.model.Doctor;
import project.springBoot.model.Specialization;
import project.springBoot.model.User;
import project.springBoot.service.DoctorService;
import project.springBoot.service.SpecializationService;
import project.springBoot.service.UploadFileService;
import project.springBoot.service.UserService;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Controller
@Slf4j
public class DoctorController {
    private final DoctorService doctorService;
    private final UploadFileService uploadFileService;
    private final UserService userService;
    private final SpecializationService specializationService;

    public DoctorController(DoctorService doctorService, UploadFileService uploadFileService,
            UserService userService, SpecializationService specializationService) {
        this.doctorService = doctorService;
        this.uploadFileService = uploadFileService;
        this.userService = userService;
        this.specializationService = specializationService;
    }

    @RequestMapping("/admin/doctor/create")
    public String getCreateDoctorPage(Model model) {
        Doctor newDoctor = new Doctor();
        newDoctor.setUser(new User()); // Initialize the User object
        model.addAttribute("newDoctor", newDoctor);
        model.addAttribute("specializations", specializationService.getAllActiveSpecializations());
        return "doctor/create-doctor";
    }

    @RequestMapping(value = "/admin/doctor/create", method = RequestMethod.POST)
    public String createDoctor(Model model, @ModelAttribute("newDoctor") Doctor doctor,
            @RequestParam("image") MultipartFile image,
            @RequestParam(value = "specializationIds", required = false) List<Long> specializationIds) {
        try {
            if (!image.isEmpty()) {
                String imageUrl = uploadFileService.uploadImage(image);
                doctor.getUser().setAvatarUrl(imageUrl);
                log.info("Image URL: {}", imageUrl);
                doctor.getUser().setRole("doctor");
                doctor.getUser().setIsVerified(true);
            }

            User savedUser = userService.handleSaveUser(doctor.getUser());
            doctor.setUser(savedUser);

            if (specializationIds != null && !specializationIds.isEmpty()) {
                Set<Specialization> specializations = specializationIds.stream()
                        .map(specializationService::getSpecializationById)
                        .collect(Collectors.toSet());
                doctor.setSpecializations(specializations);
            }

            Doctor savedDoctor = doctorService.save(doctor);

            log.info("Created doctor: {}", savedDoctor);
            return "redirect:/admin/user"; // Redirect to doctor list page
        } catch (Exception e) {
            log.error("Error creating doctor: ", e);
            // Add back the specializations list for the form
            model.addAttribute("specializations", specializationService.getAllActiveSpecializations());
            model.addAttribute("error", "Failed to create doctor: " + e.getMessage());
            return "doctor/create-doctor";
        }
    }
}
