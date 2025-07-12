package project.springBoot.controller;

import java.security.Principal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;

import lombok.RequiredArgsConstructor;
import project.springBoot.model.Appointment;
import project.springBoot.model.Examination;
import project.springBoot.model.Patient;
import project.springBoot.model.User;
import project.springBoot.service.AppointmentService;
import project.springBoot.service.PatientService;
import project.springBoot.service.UserService;

@Controller
public class PatientHistoryController {
    @Autowired
    private PatientService patientService;
    @Autowired
    private UserService userService;
    @Autowired
    private AppointmentService appointmentService;

    @GetMapping("/medical-history")
    public String viewPatientHistory(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"patient".equalsIgnoreCase(currentUser.getRole())) {
            return "redirect:/access-denied";
        }
        Patient patient = patientService.getPatientByUsername(currentUser.getUsername());
        List<Appointment> appointments = appointmentService.findAppointmentByPatientID(patient.getPatientID());
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        DateTimeFormatter startTime = DateTimeFormatter.ofPattern("HH:mm");
        List<String> endTimes = new ArrayList<>();
        for (Appointment a : appointments) {
            if (a.getBookingSlot() != null && a.getBookingSlot().getStartTime() != null) {
                LocalDateTime start = a.getBookingSlot().getStartTime();
                LocalDateTime end = start.plusHours(1); // cộng thêm 1 tiếng
                endTimes.add(end.format(startTime));
            } else {
                endTimes.add("N/A");
            }
        }
        model.addAttribute("startTime", startTime);
        model.addAttribute("endTimes", endTimes);
        model.addAttribute("formatter", formatter);
        model.addAttribute("appointment", appointments);
        return "patient/patient-history";
    }
}
