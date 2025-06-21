package project.springBoot.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import project.springBoot.model.Patient;
import project.springBoot.model.User;
import project.springBoot.service.PatientService;
import project.springBoot.service.UserService;

import java.security.Principal;
import java.time.LocalDateTime;

@Controller
@RequestMapping("/patients")
@RequiredArgsConstructor
public class PatientController {
    private final PatientService patientService;
    private final UserService userService;

    @GetMapping("/profile")
    public String viewProfile(Principal principal, Model model) {
        Patient patient = patientService.getPatientByUsername(principal.getName());
        model.addAttribute("patient", patient);
        return "patient/profile";
    }

    @GetMapping("/edit")
    public String showEditForm(Principal principal, Model model) {
        Patient patient = patientService.getPatientByUsername(principal.getName());
        model.addAttribute("patient", patient);
        return "patient/edit-profile";
    }

    @PostMapping("/update")
    public String updateProfile(
            @ModelAttribute Patient updatedPatient,
            Principal principal,
            Model model) {
        try {
            Patient existingPatient = patientService.getPatientByUsername(principal.getName());

            // Update only allowed fields
            existingPatient.setEmergencyContactName(updatedPatient.getEmergencyContactName());
            existingPatient.setEmergencyContactPhone(updatedPatient.getEmergencyContactPhone());
            existingPatient.setInsuranceNumber(updatedPatient.getInsuranceNumber());
            existingPatient.setOccupation(updatedPatient.getOccupation());
            existingPatient.setMaritalStatus(updatedPatient.getMaritalStatus());
            existingPatient.setModifiedAt(LocalDateTime.now());

            patientService.save(existingPatient);
            return "redirect:/patients/profile?success=true";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "patient/edit-profile";
        }
    }

    @PostMapping("/register")
    public String registerPatient(@ModelAttribute User user, Model model) {
        try {
            User savedUser = userService.save(user);

            Patient patient = new Patient();
            patient.setUser(savedUser);
            patient.setPatientCode("P" + String.format("%06d", savedUser.getUserID()));

            patientService.save(patient);
            return "redirect:/login?registered=true";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("user", user);
            return "authentication/form-register";
        }
    }
}