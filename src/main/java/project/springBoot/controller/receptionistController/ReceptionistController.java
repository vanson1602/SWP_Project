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

    @GetMapping("/booking-receptionist/patientInfor")
    public String viewPatientInfor(Model model) {
        List<User> listPatient = userService.findUserByRole("patient");
        model.addAttribute("listPatient", listPatient);
        return "receptionist/receptionist-viewPatient";
    }

    @GetMapping("/booking-receptionist/searchPatient")
    public String searchPatient(@RequestParam("nameOrEmail") String nameOrEmail, Model model) {
        if (nameOrEmail.contains("@")) {
            if (!nameOrEmail.matches("^[\\w.-]+@[\\w.-]+\\.(com|fpt\\.edu\\.vn)$")) {
                model.addAttribute("error", "Email phải kết thúc bằng @gmail.com hoặc @fpt.edu.vn");
                model.addAttribute("listPatient", List.of());
                return "receptionist/receptionist-viewPatient";
            }
        }
        User patient = userService.getUserByEmailOrUsername(nameOrEmail, nameOrEmail);
        if (patient == null) {
            model.addAttribute("error", "không tìm thấy bệnh nhân " + nameOrEmail);
            model.addAttribute("listPatient", List.of());
        } else {
            model.addAttribute("listPatient", List.of(patient));
        }
        model.addAttribute("email", nameOrEmail);
        return "receptionist/receptionist-viewPatient";
    }

}
