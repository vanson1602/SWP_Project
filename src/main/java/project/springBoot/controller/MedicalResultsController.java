package project.springBoot.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpSession;
import project.springBoot.model.Examination;
import project.springBoot.model.Patient;
import project.springBoot.model.User;
import project.springBoot.repository.PatientRepository;
import project.springBoot.repository.UserRepository;
import project.springBoot.service.AppointmentService;
import project.springBoot.service.ExaminationService;
import project.springBoot.service.PrescriptionService;

@Controller
public class MedicalResultsController {
    private static final Logger logger = LoggerFactory.getLogger(MedicalResultsController.class);

    @Autowired
    private ExaminationService examinationService;

    @Autowired
    private PrescriptionService prescriptionService;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private PatientRepository patientRepository;
    
    @Autowired
    private AppointmentService appointmentService;

    @GetMapping("/appointments/medical-result")
    public String showMedicalResults(Model model, HttpSession session) {
        // Get the logged-in user from session
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            logger.warn("User not authenticated");
            return "redirect:/login";
        }
        
        logger.debug("Looking up patient ID for user: {}", currentUser.getUsername());
        
        // Get patient ID
        Patient patient = patientRepository.findByUser(currentUser);
        if (patient == null) {
            logger.error("Could not find patient record for user: {}", currentUser.getUsername());
            model.addAttribute("message", "Không thể xác định thông tin bệnh nhân.");
            return "error";
        }
        
        Long patientId = patient.getPatientID();
        logger.debug("Found patient ID: {}", patientId);

        // Check if patient has any appointments
        if (appointmentService.findByPatientPatientIDOrderByAppointmentDateDesc(patientId).isEmpty()) {
            logger.warn("No appointments found for patient ID: {}", patientId);
            model.addAttribute("message", "Bạn chưa có lịch hẹn khám bệnh nào.");
            return "error";
        }

        // Fetch the latest examination for the patient
        Examination examination = examinationService.getLatestExaminationByPatientId(patientId);
        if (examination != null) {
            logger.debug("Found examination ID: {} for patient ID: {}", examination.getExaminationID(), patientId);
            examination.setPrescriptions(prescriptionService.findByExaminationId(examination.getExaminationID()));
            model.addAttribute("examination", examination);
            return "appointment/medical-results";
        } else {
            logger.warn("No examination found for patient ID: {}", patientId);
            model.addAttribute("message", "Không tìm thấy kết quả khám bệnh. Có thể bạn chưa đi khám hoặc buổi khám chưa hoàn thành.");
            return "error";
        }
    }
}