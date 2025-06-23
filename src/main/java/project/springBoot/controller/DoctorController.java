package project.springBoot.controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;
import project.springBoot.model.Appointment;
import project.springBoot.model.Doctor;
import project.springBoot.model.DoctorBookingSlot;
import project.springBoot.model.Examination;
import project.springBoot.model.MedicalRecord;
import project.springBoot.model.Medication;
import project.springBoot.model.Prescription;
import project.springBoot.model.User;
import project.springBoot.service.AppointmentService;
import project.springBoot.service.DoctorBookingSlotService;
import project.springBoot.service.DoctorService;
import project.springBoot.service.ExaminationService;
import project.springBoot.service.ICDCodeService;
import project.springBoot.service.MedicalRecordService;
import project.springBoot.service.MedicationService;
import project.springBoot.service.PrescriptionService;
import project.springBoot.service.UserService;

@Controller
public class DoctorController {

    @Autowired
    private AppointmentService appointmentService;
    @Autowired
    private DoctorBookingSlotService bookingSlotService;
    @Autowired
    private ExaminationService examinationService;
    @Autowired
    private MedicalRecordService medicalRecordService;
    @Autowired
    private UserService userService;
    @Autowired
    private ICDCodeService icdCodeService;
    @Autowired
    private MedicationService medicationService;
    @Autowired
    private PrescriptionService prescriptionService;
    @Autowired
    private DoctorService doctorService;

    @GetMapping("/doctor/home")
    public String getDoctorHomePage(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"doctor".equalsIgnoreCase(currentUser.getRole())) {
            return "redirect:/login";
        }
        
        Long doctorId = (Long) session.getAttribute("doctorId");
        if (doctorId == null) {
            // Try to get doctorId from user if it's missing in session
            doctorId = userService.getDoctorIdByUserId(currentUser.getUserID());
            if (doctorId != null) {
                session.setAttribute("doctorId", doctorId);
            } else {
                System.out.println("Could not find doctor record for user: " + currentUser.getUserID());
                return "redirect:/access-denied";
            }
        }
        
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("doctorId", doctorId);
        return "doctors/doctor-home";
    }

    @GetMapping("/doctor/appointments")
    public String getDoctorAppointments(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"doctor".equalsIgnoreCase(currentUser.getRole())) {
            return "redirect:/access-denied";
        }
        Long doctorId = (Long) session.getAttribute("doctorId");
        if (doctorId == null) {
            System.out.println("doctorId is null for user: " + currentUser.getUsername());
            return "redirect:/login";
        }
        System.out.println("Fetching appointments and slots for doctorId: " + doctorId);
        
        // Get today's booking slots
        LocalDateTime startOfToday = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0).withNano(0);
        LocalDateTime endOfToday = startOfToday.plusDays(1);
        List<DoctorBookingSlot> todayBookingSlots = bookingSlotService.getBookingSlotsByDoctorAndDateRange(doctorId, startOfToday, endOfToday);
        
        // Get tomorrow's booking slots
        LocalDateTime startOfTomorrow = startOfToday.plusDays(1);
        LocalDateTime endOfTomorrow = startOfTomorrow.plusDays(1);
        List<DoctorBookingSlot> tomorrowBookingSlots = bookingSlotService.getBookingSlotsByDoctorAndDateRange(doctorId, startOfTomorrow, endOfTomorrow);
        
        model.addAttribute("todayBookingSlots", todayBookingSlots);
        model.addAttribute("tomorrowBookingSlots", tomorrowBookingSlots);
        model.addAttribute("currentUser", currentUser);
        return "doctors/doctor-appointments";
    }

    @GetMapping("/doctor/appointments/{appointmentId}")
    public String getAppointmentDetails(@PathVariable Long appointmentId, Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"doctor".equalsIgnoreCase(currentUser.getRole())) {
            return "redirect:/access-denied";
        }
        Appointment appointment = appointmentService.findById(appointmentId);
        if (appointment != null) {
            // Get the latest examination for this appointment
            Examination latestExamination = null;
            if (!appointment.getExaminations().isEmpty()) {
                latestExamination = appointment.getExaminations().stream()
                        .max((e1, e2) -> e1.getExaminationDate().compareTo(e2.getExaminationDate()))
                        .orElse(null);
            }

            // Format the follow-up date if exists
            String followUpDateStr = "";
            if (latestExamination != null && latestExamination.getFollowUpDate() != null) {
                followUpDateStr = latestExamination.getFollowUpDate()
                        .format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
            }

            model.addAttribute("appointment", appointment);
            model.addAttribute("examination", latestExamination);
            model.addAttribute("followUpDateStr", followUpDateStr);
            model.addAttribute("currentUser", currentUser);
            return "doctors/doctor-appointment-details";
        }
        return "redirect:/doctor/appointments";
    }

    @GetMapping("/doctor/appointments/{appointmentId}/examination/create")
    public String getCreateExamForm(@PathVariable Long appointmentId, Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"doctor".equalsIgnoreCase(currentUser.getRole())) {
            return "redirect:/access-denied";
        }
        model.addAttribute("appointmentId", appointmentId);
        model.addAttribute("examination", new Examination());
        model.addAttribute("icdCodes", icdCodeService.getAllActiveCodes());
        System.out.println("Rendering create-exam form for appointmentId: " + appointmentId);
        return "doctors/doctor-create-exam";
    }

    @GetMapping("/doctor/appointments/{appointmentId}/examination/edit")
    public String getEditExamForm(@PathVariable Long appointmentId, Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"doctor".equalsIgnoreCase(currentUser.getRole())) {
            return "redirect:/access-denied";
        }
        
        Appointment appointment = appointmentService.findById(appointmentId);
        if (appointment == null) {
            return "redirect:/doctor/appointments";
        }

        // Get the latest examination for this appointment
        Examination examination = appointment.getExaminations().stream()
                .max((e1, e2) -> e1.getExaminationDate().compareTo(e2.getExaminationDate()))
                .orElse(null);

        if (examination == null) {
            return "redirect:/doctor/appointments/" + appointmentId;
        }

        model.addAttribute("appointmentId", appointmentId);
        model.addAttribute("examination", examination);
        model.addAttribute("icdCodes", icdCodeService.getAllActiveCodes());
        model.addAttribute("currentUser", currentUser);
        return "doctors/doctor-create-exam";
    }

    @PostMapping("/doctor/appointments/{appointmentId}/examination/save")
    public String saveExamination(@PathVariable Long appointmentId, Examination examination, Model model,
            HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"doctor".equalsIgnoreCase(currentUser.getRole())) {
            return "redirect:/access-denied";
        }
        
        try {
            Appointment appointment = appointmentService.findById(appointmentId);
            if (appointment != null) {
                examination.setAppointment(appointment);
                
                // If this is an update (examination has ID)
                if (examination.getExaminationID() > 0) {
                    Examination existingExam = examinationService.getExaminationById(examination.getExaminationID());
                    if (existingExam != null) {
                        // Keep the original examination date, relationships and prescriptions
                        examination.setExaminationDate(existingExam.getExaminationDate());
                        examination.setMedicalRecord(existingExam.getMedicalRecord());
                        examination.setDoctor(existingExam.getDoctor());
                        examination.setPrescriptions(existingExam.getPrescriptions());
                        examination.setModifiedAt(LocalDateTime.now());
                    }
                } else {
                    // This is a new examination
                    examination.setExaminationDate(LocalDateTime.now());
                    examination.setDoctor(doctorService.findById((Long) session.getAttribute("doctorId")));
                    
                    // Create or get medical record
                    MedicalRecord medicalRecord = medicalRecordService.findById(appointment.getPatient().getPatientID());
                    if (medicalRecord == null) {
                        medicalRecord = new MedicalRecord();
                        medicalRecord.setPatient(appointment.getPatient());
                        medicalRecord = medicalRecordService.save(medicalRecord);
                    }
                    examination.setMedicalRecord(medicalRecord);
                }
                
                // Save the examination
                examinationService.saveExamination(examination);
                
                // Update appointment status if examination is completed
                if ("Completed".equals(examination.getStatus())) {
                    appointment.setStatus("Completed");
                    appointment.setModifiedAt(LocalDateTime.now());
                    appointmentService.saveAppointment(appointment);
                }
                
                // Redirect back to appointment details
                return "redirect:/doctor/appointments/" + appointmentId;
            }
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Có lỗi xảy ra khi lưu hồ sơ khám bệnh");
            return "doctors/doctor-create-exam";
        }
        
        return "redirect:/doctor/appointments/" + appointmentId;
    }

    @GetMapping("/doctor/appointments/{appointmentId}/prescriptions")
    public String getPrescriptionPage(@PathVariable Long appointmentId, @RequestParam(required = false) Long edit, Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"doctor".equalsIgnoreCase(currentUser.getRole())) {
            return "redirect:/login";
        }
        Long doctorId = (Long) session.getAttribute("doctorId");
        if (doctorId == null) {
            System.out.println("doctorId is null for user: " + currentUser.getUsername());
            return "redirect:/login";
        }
        Appointment appointment = appointmentService.findById(appointmentId);
        if (appointment != null) {
            Examination examination = null;
            if (!appointment.getExaminations().isEmpty()) {
                examination = appointment.getExaminations().stream()
                        .max((e1, e2) -> e1.getExaminationDate().compareTo(e2.getExaminationDate()))
                        .orElse(null);
            }

            if (examination == null) {
                return "redirect:/doctor/appointments/" + appointmentId + "/examination/create";
            }

            Prescription prescription = new Prescription();
            if (edit != null) {
                prescription = prescriptionService.findById(edit);
                if (prescription == null || prescription.getExamination().getExaminationID() != examination.getExaminationID()) {
                    model.addAttribute("error", "Đơn thuốc không tồn tại hoặc không thuộc buổi khám này.");
                }
            }

            List<Prescription> prescriptions = prescriptionService.findByExaminationId(examination.getExaminationID());
            model.addAttribute("appointment", appointment);
            model.addAttribute("examination", examination);
            model.addAttribute("prescriptions", prescriptions);
            model.addAttribute("medications", medicationService.getAllMedications());
            model.addAttribute("currentUser", currentUser);
            model.addAttribute("prescription", prescription);
            return "doctors/doctor-prescription";
        }
        return "redirect:/doctor/appointments";
    }

    @PostMapping("/doctor/appointments/{appointmentId}/prescriptions/save")
    @ResponseBody
    public Map<String, Object> savePrescription(@PathVariable("appointmentId") Long appointmentId,
                                              @RequestBody Map<String, Object> requestData) {
        Map<String, Object> response = new HashMap<>();
        try {
            System.out.println("Received request data: " + requestData);
            
            Appointment appointment = appointmentService.findById(appointmentId);
            if (appointment == null) {
                throw new IllegalArgumentException("Không tìm thấy lịch khám");
            }

            // Get the latest examination
            Examination examination = appointment.getExaminations().stream()
                    .max((e1, e2) -> e1.getExaminationDate().compareTo(e2.getExaminationDate()))
                    .orElse(null);

            if (examination == null) {
                throw new IllegalArgumentException("Vui lòng tạo bệnh án trước khi kê đơn thuốc");
            }

            // Create new prescription
            Prescription prescription = new Prescription();
            
            // Set basic fields
            if (requestData.get("prescription_id") != null) {
                prescription.setPrescriptionID(Long.parseLong(requestData.get("prescription_id").toString()));
            }
            
            // Get medication
            Long medicationId = Long.parseLong(requestData.get("medication_id").toString());
            Medication medication = medicationService.findById(medicationId);
            if (medication == null) {
                throw new IllegalArgumentException("Không tìm thấy thuốc");
            }
            
            // Set quantity and validate stock
            int quantity = Integer.parseInt(requestData.get("quantity").toString());
            if (quantity > medication.getStockQuantity()) {
                throw new IllegalArgumentException("Số lượng yêu cầu vượt quá số lượng tồn kho");
            }
            prescription.setQuantity(quantity);
            
            // Update medication stock
            medication.setStockQuantity(medication.getStockQuantity() - quantity);
            medicationService.save(medication);

            // Set other fields
            prescription.setMedication(medication);
            prescription.setExamination(examination);
            
            // Set doctor directly from prescribed_by
            Long doctorId = Long.parseLong(requestData.get("prescribed_by").toString());
            Doctor doctor = doctorService.findById(doctorId);
            if (doctor == null) {
                throw new IllegalArgumentException("Không tìm thấy bác sĩ");
            }
            prescription.setPrescribedBy(doctor);
            
            prescription.setDosage(requestData.get("dosage").toString());
            prescription.setFrequency(requestData.get("frequency").toString());
            prescription.setDuration(requestData.get("duration") != null ? requestData.get("duration").toString() : null);
            prescription.setInstructions(requestData.get("instructions") != null ? requestData.get("instructions").toString() : null);
            prescription.setIsRefillable(Boolean.parseBoolean(requestData.get("is_refillable").toString()));
            prescription.setStatus("PENDING");
            
            if (prescription.getPrescriptionID() == null) {
                prescription.setCreatedAt(LocalDateTime.now());
            }
            prescription.setModifiedAt(LocalDateTime.now());

            System.out.println("Saving prescription with data:");
            System.out.println("- Medication: " + prescription.getMedication().getMedicationID());
            System.out.println("- Examination: " + prescription.getExamination().getExaminationID());
            System.out.println("- Doctor: " + prescription.getPrescribedBy().getDoctorID());
            System.out.println("- Quantity: " + prescription.getQuantity());

            Prescription savedPrescription = prescriptionService.savePrescription(prescription);
            response.put("success", true);
            response.put("prescription", savedPrescription);
        } catch (Exception e) {
            System.err.println("Error saving prescription: " + e.getMessage());
            e.printStackTrace();
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        return response;
    }

    @PostMapping("/doctor/appointments/{appointmentId}/prescriptions/complete")
    @ResponseBody
    public Map<String, Object> completePrescriptions(@PathVariable("appointmentId") Long appointmentId,
                                                   @RequestBody Map<String, List<Long>> request) {
        Map<String, Object> response = new HashMap<>();
        try {
            List<Long> prescriptionIds = request.get("prescriptionIds");
            if (prescriptionIds == null || prescriptionIds.isEmpty()) {
                throw new IllegalArgumentException("Không có đơn thuốc nào được chọn");
            }

            // Update status of prescriptions
            prescriptionService.completePrescriptions(prescriptionIds);
            
            response.put("success", true);
            response.put("message", "Đơn thuốc đã được hoàn thành");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        return response;
    }

    @PostMapping("/doctor/appointments/{appointmentId}/prescriptions/{prescriptionId}/delete")
    public ResponseEntity<Map<String, Object>> deletePrescription(@PathVariable Long appointmentId, 
                                                                @PathVariable Long prescriptionId, 
                                                                HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"doctor".equalsIgnoreCase(currentUser.getRole())) {
            response.put("success", false);
            response.put("message", "Unauthorized access");
            return ResponseEntity.badRequest().body(response);
        }

        try {
            Prescription prescription = prescriptionService.findById(prescriptionId);
            if (prescription == null) {
                response.put("success", false);
                response.put("message", "Prescription not found");
                return ResponseEntity.badRequest().body(response);
            }

            // Restore stock quantity
            Medication medication = prescription.getMedication();
            medication.setStockQuantity(medication.getStockQuantity() + prescription.getQuantity());
            medicationService.save(medication);

            prescriptionService.deletePrescription(prescriptionId);
            response.put("success", true);
            response.put("message", "Prescription deleted successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error occurred while deleting prescription: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @GetMapping("/doctor/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }
}