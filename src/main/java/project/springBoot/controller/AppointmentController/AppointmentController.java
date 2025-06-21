package project.springBoot.controller.AppointmentController;

import java.security.Principal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import project.springBoot.model.Doctor;
import project.springBoot.model.DoctorBookingSlot;
import project.springBoot.model.Specialization;
import project.springBoot.service.AppointmentService;
import project.springBoot.service.DoctorService;
import project.springBoot.service.SpecializationService;

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

    // @GetMapping("/info")
    // public String showPatientInfo(
    //         @RequestParam Long slotId,
    //         HttpSession session,
    //         Model model) {
    //     DoctorBookingSlot slot = doctorService.getSlotById(slotId);
    //     User user = (User) session.getAttribute("currentUser");
    //     Patient patient = doctorService.getPatientByUsername(user.getUsername());
    //     Specialization specialization = (Specialization) session.getAttribute("selectedSpecialization");
    //     List<AppointmentType> appointmentTypes = appointmentService.getAllAppointmentTypes();

    //     model.addAttribute("slot", slot);
    //     model.addAttribute("patient", patient);
    //     model.addAttribute("specialization", specialization);
    //     model.addAttribute("appointmentTypes", appointmentTypes);

    //     return "appointment/patient-info";
    // }

    // @PostMapping("/payment")
    // public String confirmAppointment(
    //         @RequestParam Long slotId,
    //         @RequestParam(required = false) String notes,
    //         @RequestParam Long appointmentTypeId,
    //         HttpSession session,
    //         Model model) {
    //     try {
    //         User user = (User) session.getAttribute("currentUser");
    //         Patient patient = doctorService.getPatientByUsername(user.getUsername());
    //         Specialization specialization = (Specialization) session.getAttribute("selectedSpecialization");

    //         DoctorBookingSlot slot = doctorService.getSlotById(slotId);
    //         System.out.println("Slot:" + slot);
    //         System.out.println("Slot id:" + slotId);
    //         System.out.println("Specialization ID: " + specialization.getSpecializationID());
    //         System.out.println("Patient ID: " + patient.getPatientID());
    //         System.out.println("Appointment Type ID: " + appointmentTypeId);
    //         System.out.println("Notes: " + notes);

    //         Appointment appointment = appointmentService.createAppointment(
    //                 patient.getPatientID(), slotId, specialization.getSpecializationID(),
    //                 appointmentTypeId, notes);

    //         model.addAttribute("appointment", appointment);
    //         session.setAttribute("pendingAppointment", appointment);
    //         return "redirect:/appointments/payment";
    //     } catch (RuntimeException e) {
    //         model.addAttribute("error", e.getMessage());
    //         System.out.println("Error: " + e.getMessage());
    //         return "appointment/error";
    //     }
    // }

    // @GetMapping("/payment")
    // public String showPaymentPage(HttpSession session, Model model) {
    //     Appointment appointment = (Appointment) session.getAttribute("pendingAppointment");
    //     if (appointment == null) {
    //         return "redirect:/appointments/booking";
    //     }
    //     appointment = appointmentService.getAppointmentByIdWithDetails(appointment.getAppointmentID());
    //     model.addAttribute("appointment", appointment);
    //     return "appointment/payment";
    // }

    // @PostMapping("/process-payment")
    // public String processPayment(
    //         @RequestParam String paymentMethod,
    //         @RequestParam Long appointmentId,
    //         HttpSession session,
    //         Model model) {
    //     try {
    //         Appointment appointment = appointmentService.getAppointmentById(appointmentId);

    //         // Xử lý thanh toán theo phương thức được chọn
    //         boolean paymentSuccess = false;
    //         switch (paymentMethod) {
    //             case "momo":
    //                 paymentSuccess = true; // Giả lập thanh toán thành công
    //                 break;
    //             case "vnpay":
    //                 paymentSuccess = true; // Giả lập thanh toán thành công
    //                 break;
    //             case "banking":
    //                 paymentSuccess = true; // Giả lập thanh toán thành công
    //                 break;
    //         }

    //         if (paymentSuccess) {
    //             // Cập nhật trạng thái appointment thành CONFIRMED sau khi thanh toán thành công
    //             appointmentService.updateAppointmentStatus(appointmentId, "Confirmed", "Payment completed");
    //             session.removeAttribute("pendingAppointment");
    //             return "redirect:/appointments/payment-success";
    //         } else {
    //             model.addAttribute("error", "Payment failed. Please try again.");
    //             return "appointment/payment";
    //         }
    //     } catch (Exception e) {
    //         model.addAttribute("error", e.getMessage());
    //         return "appointment/payment";
    //     }
    // }

    // @GetMapping("/payment-success")
    // public String showPaymentSuccess() {
    //     return "appointment/payment-success";
    // }

    // @GetMapping("/my-appointments")
    // public String showMyAppointments(HttpSession session, Model model) {
    //     User user = (User) session.getAttribute("currentUser");
    //     Patient patient = doctorService.getPatientByUsername(user.getUsername());
    //     List<Appointment> appointments = appointmentService.getPatientAppointments(patient.getPatientID());
    //     model.addAttribute("appointments", appointments);
    //     return "appointment/my-appointments";
    // }

    // @PostMapping("/{id}/cancel")
    // public String cancelAppointment(
    //         @PathVariable("id") Long appointmentId,
    //         @RequestParam String reason,
    //         Principal principal,
    //         Model model) {
    //     try {
    //         appointmentService.cancelAppointment(appointmentId, reason);
    //         return "redirect:/appointments/my-appointments?success=true";
    //     } catch (RuntimeException e) {
    //         model.addAttribute("error", e.getMessage());
    //         return "redirect:/appointments/my-appointments?error=" + e.getMessage();
    //     }
    // }
}
