package project.springBoot.controller.receptionistController;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.RequiredArgsConstructor;
import project.springBoot.model.Doctor;
import project.springBoot.model.Patient;
import project.springBoot.model.User;
import project.springBoot.service.PatientService;
import project.springBoot.service.UserService;

@Controller
@RequiredArgsConstructor
public class ReceptionistController {
    private final PatientService patientService;
    private final UserService userService;

    @GetMapping("/booking-repceptionist/patientInfor")
    public String viewPatientInfor(Model model) {
        List<User> listPatient = userService.findUserByRole("patient");
        model.addAttribute("listPatient", listPatient);
        return "receptionist/receptionist-viewPatient";
    }
}
