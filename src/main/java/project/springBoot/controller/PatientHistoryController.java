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
import project.springBoot.model.Medication;
import project.springBoot.model.Patient;
import project.springBoot.model.Prescription;
import project.springBoot.model.User;
import project.springBoot.service.AppointmentService;
import project.springBoot.service.ExaminationService;
import project.springBoot.service.MedicationService;
import project.springBoot.service.PatientService;
import project.springBoot.service.PrescriptionService;
import project.springBoot.service.UserService;

@Controller
public class PatientHistoryController {
    @Autowired
    private PatientService patientService;
    @Autowired
    private UserService userService;
    @Autowired
    private AppointmentService appointmentService;
    @Autowired
    private ExaminationService examinationService;
    @Autowired
    private PrescriptionService prescriptionService;
    @Autowired
    private MedicationService medicationService;

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

    @GetMapping("/medical-history/medical-record/{appointmentID}")
    public String viewPatientHistoryMedicalRecord(HttpSession session, Model model, @PathVariable Long appointmentID) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"patient".equalsIgnoreCase(currentUser.getRole())) {
            return "redirect:/login";
        }
        Examination examination = examinationService.getExaminationByAppointmentId(appointmentID);
        DateTimeFormatter date = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        DateTimeFormatter time = DateTimeFormatter.ofPattern("HH:mm");
        model.addAttribute("examination", examination);
        model.addAttribute("time", time);
        model.addAttribute("date", date);
        return "patient/patient-medicalRecord";
    }

    @GetMapping("/medical-history/prescription/{appointmentID}")
    public String viewPrescriptionDetail(HttpSession session, Model model, @PathVariable Long appointmentID) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"patient".equalsIgnoreCase(currentUser.getRole())) {
            return "redirect:/login";
        }

        Examination examination = examinationService.getExaminationByAppointmentId(appointmentID);
        if (examination == null) {
            model.addAttribute("errorMessage", "Không tìm thấy đơn thuốc nào cho cuộc hẹn này.");
            return "patient/patient-viewPrescription";
        }
        List<Prescription> prescriptions = prescriptionService
                .getAllPrescriptionsByExaminationId(examination.getExaminationID());
        if (prescriptions == null || prescriptions.isEmpty()) {
            model.addAttribute("errorMessage", "Không tìm thấy đơn thuốc nào cho cuộc hẹn này.");
        } else {
            model.addAttribute("prescriptions", prescriptions);
        }
        return "patient/patient-viewPrescription";
    }
}
