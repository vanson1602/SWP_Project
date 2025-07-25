package project.springBoot.controller.AppointmentController;

import java.security.Principal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import org.springframework.data.domain.Page;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.web.bind.annotation.ModelAttribute;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import project.springBoot.model.Appointment;
import project.springBoot.model.AppointmentType;
import project.springBoot.model.Doctor;
import project.springBoot.model.DoctorBookingSlot;
import project.springBoot.model.Patient;
import project.springBoot.model.Specialization;
import project.springBoot.model.User;
import project.springBoot.service.AppointmentService;
import project.springBoot.service.DoctorService;
import project.springBoot.service.EmailService;
import project.springBoot.service.InvoiceService;
import project.springBoot.service.PatientService;
import project.springBoot.service.SpecializationService;
import vn.payos.PayOS;
import vn.payos.type.CheckoutResponseData;
import vn.payos.type.ItemData;
import vn.payos.type.PaymentData;
import project.springBoot.service.WalletService;

@Controller
@RequiredArgsConstructor
@RequestMapping("/appointments")
public class AppointmentController {
    private final AppointmentService appointmentService;
    private final DoctorService doctorService;
    private final SpecializationService specializationService;
    private final PayOS payOS;
    private final EmailService emailService;
    private final PatientService patientService;
    private final InvoiceService invoiceService;
    private final WalletService walletService;

    private void clearBookingSession(HttpSession session) {
        session.removeAttribute("selectedDoctor");
        session.removeAttribute("selectedSpecialization");
        session.removeAttribute("pendingAppointment");
    }

    @ModelAttribute
    public void addCsrfToken(Model model, CsrfToken token) {
        if (token != null) {
            model.addAttribute("_csrf", token);
        }
    }

    @GetMapping("")
    public String showAppointmentForm(Model model, Principal principal, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }

        Patient patient = patientService.getPatientByUsername(user.getUsername());
        if (patient == null) {
            return "redirect:/login";
        }

        session.setAttribute("currentUser", user);
        session.setAttribute("currentPatient", patient);
        clearBookingSession(session);
        return "appointment/appointment-page";
    }

    @GetMapping("/booking")
    public String showAppointmentBooking(@RequestParam(required = false) Long doctorId, Model model,
            HttpSession session) {
        clearBookingSession(session);
        if (doctorId != null) {
            Doctor doctor = doctorService.getDoctorById(doctorId);
            session.setAttribute("selectedDoctor", doctor);
        }
        return "appointment/appointment-booking";
    }

    @GetMapping("/specialty")
    public String showSpecialtySelection(Model model, HttpSession session) {
        Doctor doctor = (Doctor) session.getAttribute("selectedDoctor");
        List<Specialization> specializations;
        if (doctor == null) {
            specializations = specializationService.getAllActiveSpecializations();
        } else {
            specializations = new ArrayList<>(doctor.getSpecializations());
        }
        model.addAttribute("specializations", specializations);
        return "appointment/specialty-selection";
    }

    @GetMapping("/doctor")
    public String showDoctorSelection(@RequestParam Long specializationId, Model model, HttpSession session) {
        Doctor doctor = (Doctor) session.getAttribute("selectedDoctor");
        Specialization specialization = specializationService.getSpecializationById(specializationId);
        if (doctor != null) {
            session.setAttribute("selectedDoctor", doctor);
            session.setAttribute("selectedSpecialization", specialization);
            return "redirect:/appointments/time?doctorId=" + doctor.getDoctorID();
        }
        List<Doctor> doctors = doctorService.getDoctorsBySpecialization(specializationId);
        session.setAttribute("selectedSpecialization", specialization);
        model.addAttribute("doctors", doctors);
        return "appointment/doctor-selection";
    }

    @GetMapping("/time")
    public String showTimeSelectionPage(
            @RequestParam Long doctorId,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate date,
            Model model,
            HttpSession session) {
        if (date == null) {
            date = LocalDate.now();
        }

        List<DoctorBookingSlot> availableSlots = doctorService.getAvailableSlots(doctorId, date);
        System.out.println(availableSlots);
        List<LocalDateTime> allTimeSlots = new ArrayList<>();
        LocalDateTime startTime = date.atTime(8, 0);
        LocalDateTime endTime = date.atTime(16, 0);

        while (!startTime.isAfter(endTime)) {
            if (startTime.getHour() != 12) {
                allTimeSlots.add(startTime);
            }
            startTime = startTime.plusHours(1);
        }

        model.addAttribute("today", LocalDate.now());
        model.addAttribute("selectedDate", date);
        model.addAttribute("availableSlots", availableSlots);
        model.addAttribute("allTimeSlots", allTimeSlots);

        return "appointment/time-selection";
    }

    @GetMapping("/info")
    public String showPatientInfo(
            @RequestParam Long slotId,
            HttpSession session,
            Model model) {
        DoctorBookingSlot slot = doctorService.getSlotById(slotId);
        System.out.println("Slot: " + slot);
        System.out.println("Slot: " + slot);
        User user = (User) session.getAttribute("currentUser");
        Patient patient = doctorService.getPatientByUsername(user.getUsername());
        Specialization specialization = (Specialization) session.getAttribute("selectedSpecialization");
        List<AppointmentType> appointmentTypes = appointmentService.getAllAppointmentTypes();

        model.addAttribute("slot", slot);
        model.addAttribute("patient", patient);
        model.addAttribute("specialization", specialization);
        model.addAttribute("appointmentTypes", appointmentTypes);

        return "appointment/patient-info";
    }

    @PostMapping("/payment")
    public String confirmAppointment(
            @RequestParam Long slotId,
            @RequestParam(required = false) String notes,
            @RequestParam Long appointmentTypeId,
            HttpSession session,
            Model model) {

        try {
            User user = (User) session.getAttribute("currentUser");
            Patient patient = doctorService.getPatientByUsername(user.getUsername());
            Specialization specialization = (Specialization) session.getAttribute("selectedSpecialization");
            System.out.println("Specialization: " + specialization);
            System.out.println("User: " + user);
            System.out.println("Patient: " + patient);
            DoctorBookingSlot slot = doctorService.getSlotById(slotId);

            System.out.println("Slot:" + slot);
            System.out.println("Slot id:" + slotId);
            System.out.println("Specialization ID: " + specialization.getSpecializationID());
            System.out.println("Patient ID: " + patient.getPatientID());
            System.out.println("Appointment Type ID: " + appointmentTypeId);
            System.out.println("Notes: " + notes);

            Appointment appointment = appointmentService.createAppointment(
                    patient.getPatientID(), slotId, specialization.getSpecializationID(),
                    appointmentTypeId, notes);

            model.addAttribute("appointment", appointment);
            session.setAttribute("pendingAppointment", appointment);
            return "redirect:/appointments/payment";
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            System.out.println("Error: " + e.getMessage());
            return "redirect:/appointments/info?error=" + e.getMessage();
        }
    }

    @GetMapping("/payment")
    public String showPaymentPage(@RequestParam(required = false) Long appointmentId, HttpSession session,
            Model model) {
        Appointment appointment;

        if (appointmentId != null) {
            try {
                appointment = appointmentService.getAppointmentByIdWithDetails(appointmentId);
                if (appointment == null) {
                    return "redirect:/appointments/my-appointments?error=Appointment not found";
                }
                if (!appointment.getStatus().equals("Pending")) {
                    return "redirect:/appointments/my-appointments?error=This appointment cannot be paid";
                }

                // Kiểm tra xem người dùng hiện tại có phải là chủ của appointment không
                User currentUser = (User) session.getAttribute("currentUser");
                if (currentUser.getUserID() != appointment.getPatient().getUser().getUserID()) {
                    return "redirect:/appointments/my-appointments?error=Unauthorized access";
                }

                session.setAttribute("pendingAppointment", appointment);
            } catch (Exception e) {
                return "redirect:/appointments/my-appointments?error=" + e.getMessage();
            }
        } else {
            // Nếu không có appointmentId, lấy từ session như cũ
            appointment = (Appointment) session.getAttribute("pendingAppointment");
            if (appointment == null) {
                return "redirect:/appointments/booking";
            }
            try {
                appointment = appointmentService.getAppointmentByIdWithDetails(appointment.getAppointmentID());
            } catch (Exception e) {
                return "redirect:/appointments/booking?error=" + e.getMessage();
            }
        }

        // Lấy số dư ví và kiểm tra đủ tiền không
        User currentUser = (User) session.getAttribute("currentUser");
        java.math.BigDecimal walletBalance = walletService.getBalance(currentUser);
        java.math.BigDecimal fee = appointment.getBookingSlot().getSchedule().getDoctor().getConsultationFee();
        boolean walletEnough = walletBalance.compareTo(fee) >= 0;
        model.addAttribute("walletBalance", walletBalance);
        model.addAttribute("walletEnough", walletEnough);
        model.addAttribute("appointment", appointment);
        return "appointment/payment";
    }

    @PostMapping("/process-payment")
    public String processPayment(
            @RequestParam String paymentMethod,
            @RequestParam Long appointmentId,
            HttpSession session,
            Model model) {
        try {
            Appointment appointment = appointmentService.getAppointmentById(appointmentId);
            if (appointment == null) {
                throw new RuntimeException("Appointment not found");
            }

            User currentUser = (User) session.getAttribute("currentUser");
            if (appointment.getPatient().getUser().getUserID() != currentUser.getUserID()) {
                throw new RuntimeException("Unauthorized access");
            }

            if (!appointment.getStatus().equals("Pending")) {
                throw new RuntimeException("This appointment cannot be paid");
            }

            if ("WALLET".equalsIgnoreCase(paymentMethod)) {
                // Thanh toán bằng ví nội bộ
                java.math.BigDecimal amount = appointment.getBookingSlot().getSchedule().getDoctor()
                        .getConsultationFee();
                walletService.payment(currentUser, appointment, amount);
                appointmentService.updatePaymentStatus(appointmentId, "Confirmed");
                invoiceService.createAppointmentInvoice(appointment, "WALLET");
                // Gửi email, notification như PayOS
                appointment = appointmentService.getAppointmentByIdWithDetails(appointmentId);
                emailService.sendAppointmentConfirmationEmail(
                        appointment.getPatient().getUser().getEmail(),
                        appointment);
                emailService.sendDoctorAppointmentNotificationEmail(
                        appointment.getBookingSlot().getSchedule().getDoctor().getUser().getEmail(),
                        appointment);
                return "redirect:/appointments/payment-success";
            }

            String currentTimeString = String.valueOf(new java.util.Date().getTime());
            long orderCode = Long.parseLong(currentTimeString.substring(currentTimeString.length() - 6));
            vn.payos.type.ItemData item = vn.payos.type.ItemData.builder()
                    .name("Thanh Toán Lịch Hẹn")
                    .price(appointment.getBookingSlot().getSchedule().getDoctor().getConsultationFee().intValue())
                    .quantity(1)
                    .build();
            vn.payos.type.PaymentData paymentData = vn.payos.type.PaymentData.builder()
                    .orderCode(orderCode)
                    .amount(appointment.getBookingSlot().getSchedule().getDoctor().getConsultationFee().intValue())
                    .description("thanh toan lich hen")
                    .returnUrl("http://localhost:8080/appointments/payment-success")
                    .cancelUrl("http://localhost:8080/appointments/payment-cancel")
                    .item(item).build();

            vn.payos.type.CheckoutResponseData checkoutResponseData = payOS.createPaymentLink(paymentData);
            String paymentLink = checkoutResponseData.getCheckoutUrl();
            return "redirect:" + paymentLink;
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("appointment", appointmentService.getAppointmentByIdWithDetails(appointmentId));
            return "appointment/payment";
        }
    }

    @GetMapping("/payment-success")
    public String showPaymentSuccess(HttpSession session) {
        try {
            Appointment appointment = (Appointment) session.getAttribute("pendingAppointment");
            if (appointment != null) {
                appointmentService.updatePaymentStatus(appointment.getAppointmentID(), "Confirmed");
                // Tạo hóa đơn nếu chưa có
                invoiceService.createAppointmentInvoice(appointment, "PAYOS");
                appointment = appointmentService.getAppointmentByIdWithDetails(appointment.getAppointmentID());
                emailService.sendAppointmentConfirmationEmail(
                        appointment.getPatient().getUser().getEmail(),
                        appointment);
                emailService.sendDoctorAppointmentNotificationEmail(
                        appointment.getBookingSlot().getSchedule().getDoctor().getUser().getEmail(),
                        appointment);
                session.removeAttribute("pendingAppointment");
            }
            return "appointment/payment-success";
        } catch (Exception e) {
            return "redirect:/appointments/my-appointments?error=" + e.getMessage();
        }
    }

    @GetMapping("/payment-cancel")
    public String showPaymentCancel(HttpSession session, Model model) {
        try {
            Appointment appointment = (Appointment) session.getAttribute("pendingAppointment");
            if (appointment != null) {
                appointment = appointmentService.getAppointmentByIdWithDetails(appointment.getAppointmentID());
                model.addAttribute("appointment", appointment);
            }
            return "appointment/payment-cancel";
        } catch (Exception e) {
            return "redirect:/appointments/my-appointments?error=" + e.getMessage();
        }
    }

    @GetMapping("/my-appointments")
    public String viewMyAppointments(Model model, HttpSession session,
            @RequestParam(defaultValue = "all") String status,
            @RequestParam(defaultValue = "0") int page) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }

        Patient patient = doctorService.getPatientByUsername(user.getUsername());
        if (patient == null) {
            return "redirect:/login";
        }

        final int PAGE_SIZE = 5;
        Page<Appointment> appointmentPage;

        if ("all".equals(status)) {
            appointmentPage = appointmentService.getAppointmentsByPatientId(patient.getPatientID(), page, PAGE_SIZE);
        } else {
            appointmentPage = appointmentService.getAppointmentsByPatientAndStatus(patient.getPatientID(), status, page,
                    PAGE_SIZE);
        }

        model.addAttribute("appointments", appointmentPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", appointmentPage.getTotalPages());
        model.addAttribute("totalItems", appointmentPage.getTotalElements());
        model.addAttribute("currentStatus", status);

        return "appointment/my-appointments";
    }

    @PostMapping("/{id}/cancel")
    public String cancelAppointment(
            @PathVariable("id") Long appointmentId,
            @RequestParam String reason,
            Principal principal,
            Model model) {
        try {
            appointmentService.cancelAppointment(appointmentId, reason);
            return "redirect:/appointments/my-appointments?success=true";
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/appointments/my-appointments?error=" + e.getMessage();
        }
    }

    @PostMapping("/{id}/cancel-api")
    @ResponseBody
    public ResponseEntity<?> cancelAppointmentApi(@PathVariable("id") Long appointmentId, HttpSession session,
            @RequestParam(required = false) String reason) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return ResponseEntity.badRequest().body(Map.of("error", "User not authenticated"));
            }
            Appointment appointment = appointmentService.getAppointmentById(appointmentId);
            if (appointment == null) {
                return ResponseEntity.badRequest().body(Map.of("error", "Appointment not found"));
            }
            // Chỉ cho phép bệnh nhân hoặc admin huỷ
            if (!currentUser.getRole().equals("admin")
                    && (currentUser.getUserID() != appointment.getPatient().getUser().getUserID())) {
                return ResponseEntity.badRequest().body(Map.of("error", "Unauthorized"));
            }
            // Chỉ gọi service huỷ lịch, không xử lý hoàn tiền ở controller
            String resultMsg = appointmentService.cancelAppointmentAndHandleRefund(appointmentId,
                    reason != null ? reason : "");
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", resultMsg);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/{id}/cancel")
    public String showCancelAppointmentForm(@PathVariable("id") Long appointmentId, Model model) {
        Appointment appointment = appointmentService.getAppointmentByIdWithDetails(appointmentId);
        if (appointment == null) {
            model.addAttribute("error", "Không tìm thấy lịch hẹn");
            return "redirect:/appointments/my-appointments?error=notfound";
        }
        model.addAttribute("appointment", appointment);
        return "appointment/cancel-appointment";
    }

    @GetMapping("/cancel-booking")
    public String cancelBooking(HttpSession session) {
        clearBookingSession(session);
        return "redirect:/appointments";
    }
}
