package project.springBoot.controller.AppointmentController;

import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import project.springBoot.model.*;
import project.springBoot.service.AppointmentService;
import project.springBoot.service.DoctorService;
import project.springBoot.service.SpecializationService;
import project.springBoot.service.impl.AppointmentServiceImpl;

import java.security.Principal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/appointments")
public class AppointmentController {
    private final AppointmentService appointmentService;
    private final DoctorService doctorService;
    private final SpecializationService specializationService;

    @GetMapping("")
    public String showAppointmentForm(Model model, Principal principal) {
        // Hiển thị trang chính đặt lịch
        return "appointment/appointment-page";
    }

    @GetMapping("/booking")
    public String showAppointmentBooking(Model model) {
        // Hiển thị form đặt lịch
        return "appointment/appointment-booking";
    }

    @GetMapping("/specialty")
    public String showSpecialtySelection(Model model) {
        List<Specialization> specializations = specializationService.getAllActiveSpecializations();
        model.addAttribute("specializations", specializations);
        return "appointment/specialty-selection";
    }

    @GetMapping("/doctor")
    public String showDoctorSelection(@RequestParam Long specializationId, Model model, HttpSession session) {
        List<Doctor> doctors = doctorService.getDoctorsBySpecialization(specializationId);
        Specialization specialization = specializationService.getSpecializationById(specializationId);
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
            // Kiểm tra xem appointment có tồn tại và thuộc về người dùng hiện tại không
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

            boolean paymentSuccess = false;
            String paymentNote = "";

            switch (paymentMethod) {
                case "momo":
                    paymentSuccess = true;
                    paymentNote = "Thanh toán qua MoMo thành công";
                    break;
                case "vnpay":
                    paymentSuccess = true;
                    paymentNote = "Thanh toán qua VNPay thành công";
                    break;
                case "banking":
                    paymentSuccess = true;
                    paymentNote = "Thanh toán qua Banking thành công";
                    break;
                default:
                    throw new RuntimeException("Invalid payment method");
            }

            if (paymentSuccess) {
                // Cập nhật trạng thái appointment thành CONFIRMED sau khi thanh toán thành công
                appointmentService.updateAppointmentStatus(appointmentId, "Confirmed", paymentNote);
                session.removeAttribute("pendingAppointment");
                return "redirect:/appointments/payment-success";
            } else {
                model.addAttribute("error", "Payment failed. Please try again.");
                return "appointment/payment";
            }
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("appointment", appointmentService.getAppointmentByIdWithDetails(appointmentId));
            return "appointment/payment";
        }
    }

    @GetMapping("/payment-success")
    public String showPaymentSuccess() {
        return "appointment/payment-success";
    }

    @GetMapping("/my-appointments")
    public String showMyAppointments(HttpSession session, Model model) {
        User user = (User) session.getAttribute("currentUser");
        Patient patient = doctorService.getPatientByUsername(user.getUsername());
        List<Appointment> appointments = appointmentService.getPatientAppointments(patient.getPatientID());
        model.addAttribute("appointments", appointments);
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
}
