package project.springBoot.controller.receptionistController;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.RequiredArgsConstructor;
import project.springBoot.model.Appointment;
import project.springBoot.model.AppointmentType;
import project.springBoot.model.Doctor;
import project.springBoot.model.DoctorBookingSlot;
import project.springBoot.model.Patient;
import project.springBoot.model.User;
import project.springBoot.service.AppointmentService;
import project.springBoot.service.DoctorService;
import project.springBoot.service.EmailService;
import project.springBoot.service.PatientService;
import project.springBoot.service.SpecializationService;
import project.springBoot.service.UserService;
import vn.payos.PayOS;
import vn.payos.type.CheckoutResponseData;
import vn.payos.type.ItemData;
import vn.payos.type.PaymentData;

import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;

@Controller
@RequiredArgsConstructor
public class ReceptionistBookingController {

    private final DoctorService doctorService;
    private final AppointmentService appointmentService;
    private final UserService userService;
    private final SpecializationService specializationService;
    private final PatientService patientService;
    private final EmailService emailService;
    private final PayOS payOS;

    @GetMapping("/receptionist")
    public String getReceptionistPage() {
        return "receptionist/receptionist-page";
    }

    @GetMapping("/booking-receptionist/step-1")
    public String getSpecializationSelection(Model model, @RequestParam(required = false) String email,
            @RequestParam(required = false) Long specializationId) {
        model.addAttribute("specializations", specializationService.getAllActiveSpecializations());
        model.addAttribute("email", email);
        model.addAttribute("selectedSpecializationId", specializationId);
        return "receptionist/booking-specializations";
    }

    @PostMapping("/booking-receptionist/step-1")
    public String getSpecializationSelection(@RequestParam String email,
            @RequestParam Long specializationId,
            RedirectAttributes redirectAttributes, Model model) {
        User user = userService.getUserByEmail(email);
        if (user == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy bệnh nhân với email: " + email);
            redirectAttributes.addFlashAttribute("email", email);
            return "redirect:/booking-receptionist/step-1";
        }
        redirectAttributes.addAttribute("email", email);
        redirectAttributes.addAttribute("specializationId", specializationId);
        return "redirect:/booking-receptionist/step-2";
    }

    @GetMapping("/booking-receptionist/step-2")
    public String getDoctorSelection(Model model,
            @RequestParam String email,
            @RequestParam Long specializationId) {
        List<Doctor> doctors = doctorService.getDoctorsBySpecialization(specializationId);
        model.addAttribute("doctors", doctors);
        model.addAttribute("email", email);
        model.addAttribute("selectedSpecializationId", specializationId);
        return "receptionist/booking-doctor";
    }

    @PostMapping("/booking-receptionist/step-2")
    public String getDoctorSelection(@RequestParam String email,
            @RequestParam Long specializationId,
            @RequestParam Long doctorId,
            RedirectAttributes redirectAttributes) {
        redirectAttributes.addAttribute("email", email);
        redirectAttributes.addAttribute("specializationId", specializationId);
        redirectAttributes.addAttribute("doctorId", doctorId);
        return "redirect:/booking-receptionist/step-3";
    }

    @GetMapping("/booking-receptionist/step-3")
    public String getTimeSelection(Model model,
            @RequestParam String email,
            @RequestParam Long specializationId,
            @RequestParam Long doctorId,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate date) {

        if (date == null) {
            date = LocalDate.now();
        }

        Doctor doctor = doctorService.getDoctorById(doctorId);

        // Danh sách slot có sẵn
        List<DoctorBookingSlot> availableSlots = doctorService.getAvailableSlots(doctorId, date);
        System.out.println(availableSlots);

        // Tạo các khung giờ cố định trong ngày (8h -> 16h, trừ 12h)
        List<LocalDateTime> allTimeSlots = new ArrayList<>();
        LocalDateTime startTime = date.atTime(8, 0);
        LocalDateTime endTime = date.atTime(16, 0);

        while (!startTime.isAfter(endTime)) {
            if (startTime.getHour() != 12) {
                allTimeSlots.add(startTime);
            }
            startTime = startTime.plusHours(1);
        }

        // Tạo danh sách 7 ngày tới để chọn
        List<Map<String, String>> next7Days = new ArrayList<>();
        DateTimeFormatter dayFormat = DateTimeFormatter.ofPattern("EEEE - dd/MM");

        for (int i = 0; i < 7; i++) {
            LocalDate d = LocalDate.now().plusDays(i);
            Map<String, String> map = new LinkedHashMap<>();
            map.put("value", d.toString());
            map.put("label", d.format(dayFormat));
            next7Days.add(map);
        }
        List<AppointmentType> appointmentTypes = appointmentService.getAllAppointmentTypes();
        model.addAttribute("email", email);
        model.addAttribute("specializationId", specializationId);
        model.addAttribute("doctorId", doctorId);
        model.addAttribute("selectedDate", date);
        model.addAttribute("formattedDate", date.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        model.addAttribute("consultationFee", doctor.getConsultationFee());
        model.addAttribute("appointmentTypes", appointmentTypes);
        model.addAttribute("availableSlots", availableSlots);
        model.addAttribute("allTimeSlots", allTimeSlots);
        model.addAttribute("dateOptions", next7Days);

        return "receptionist/booking-time";
    }

    @PostMapping("/booking-receptionist/step-3")
    public String confirmAppointmentStep4(
            @RequestParam String email,
            @RequestParam Long doctorId,
            @RequestParam Long specializationId,
            @RequestParam Long slotId,
            @RequestParam Long appointmentTypeId,
            @RequestParam(required = false) String note,
            RedirectAttributes redirectAttributes) {

        redirectAttributes.addAttribute("email", email);
        redirectAttributes.addAttribute("doctorId", doctorId);
        redirectAttributes.addAttribute("specializationId", specializationId);
        redirectAttributes.addAttribute("slotId", slotId);
        redirectAttributes.addAttribute("appointmentTypeId", appointmentTypeId);
        redirectAttributes.addAttribute("note", note);
        return "redirect:/booking-receptionist/step-4";
    }

    @GetMapping("/booking-receptionist/step-4")
    public String showConfirmationPage(Model model,
            @RequestParam String email,
            @RequestParam Long doctorId,
            @RequestParam Long specializationId,
            @RequestParam Long slotId,
            @RequestParam Long appointmentTypeId,
            @RequestParam(required = false) String note) {

        Doctor doctor = doctorService.getDoctorById(doctorId);
        AppointmentType type = appointmentService.getAppointmentTypeById(appointmentTypeId);
        DoctorBookingSlot slot = doctorService.getSlotById(slotId);
        Patient patient = patientService.getPatientByEmail(email);

        model.addAttribute("doctor", doctor);
        model.addAttribute("appointmentType", type);
        model.addAttribute("slot", slot);
        model.addAttribute("patient", patient);
        model.addAttribute("note", note);
        model.addAttribute("specializationId", specializationId);
        return "receptionist/booking-confirm";
    }

    @PostMapping("/booking-receptionist/step-4")
    public String confirmAndSaveAppointment(
            @RequestParam String email,
            @RequestParam Long doctorId,
            @RequestParam Long specializationId,
            @RequestParam Long slotId,
            @RequestParam Long appointmentTypeId,
            @RequestParam(required = false) String note,
            @RequestParam String paymentMethod,
            RedirectAttributes redirectAttributes,
            HttpSession session) {

        try {
            Patient patient = patientService.getPatientByEmail(email);

            // Tạo cuộc hẹn với trạng thái "Pending"
            Appointment appointment = appointmentService.createAppointment(
                    patient.getPatientID(),
                    slotId,
                    specializationId,
                    appointmentTypeId,
                    note);

            // Nếu thanh toán qua PAYOS
            if ("PAYOS".equalsIgnoreCase(paymentMethod)) {
                String currentTimeString = String.valueOf(new Date().getTime());
                long orderCode = Long.parseLong(currentTimeString.substring(currentTimeString.length() - 6));

                int price = appointment.getBookingSlot().getSchedule().getDoctor().getConsultationFee().intValue();

                ItemData item = ItemData.builder()
                        .name("Thanh Toán Lịch Hẹn")
                        .price(price)
                        .quantity(1)
                        .build();

                PaymentData paymentData = PaymentData.builder()
                        .orderCode(orderCode)
                        .amount(price)
                        .description("Thanh toán lịch hẹn")
                        .returnUrl("http://localhost:8080/booking-receptionist/booking-success?appointmentId="
                                + appointment.getAppointmentID())
                        .cancelUrl("http://localhost:8080/booking-receptionist/payment-cancel")
                        .item(item)
                        .build();

                CheckoutResponseData checkoutResponseData = payOS.createPaymentLink(paymentData);
                session.setAttribute("pendingAppointment", appointment);
                return "redirect:" + checkoutResponseData.getCheckoutUrl();
            }

            // Nếu thanh toán tiền mặt: cập nhật trạng thái và gửi email
            appointmentService.updatePaymentStatus(appointment.getAppointmentID(), "Confirmed");

            emailService.sendAppointmentConfirmationEmail(email, appointment);
            emailService.sendDoctorAppointmentNotificationEmail(
                    appointment.getBookingSlot().getSchedule().getDoctor().getUser().getEmail(),
                    appointment);
            redirectAttributes.addFlashAttribute("success", "Đặt lịch thành công!");
            return "redirect:/booking-success";

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Đặt lịch thất bại: " + e.getMessage());
            return "redirect:/booking-receptionist/step-3?email=" + email +
                    "&specializationId=" + specializationId +
                    "&doctorId=" + doctorId;
        }
    }

    @GetMapping("/booking-receptionist/booking-success")
    public String handlePayOSSuccess(@RequestParam Long appointmentId, RedirectAttributes redirectAttributes) {
        Appointment appointment = appointmentService.getAppointmentById(appointmentId);
        if (appointment == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy lịch hẹn đang chờ.");
            return "redirect:/receptionist";
        }

        if ("Pending".equalsIgnoreCase(appointment.getStatus())) {
            appointmentService.updatePaymentStatus(appointmentId, "Confirmed");

            emailService.sendAppointmentConfirmationEmail(
                    appointment.getPatient().getUser().getEmail(), appointment);

            emailService.sendDoctorAppointmentNotificationEmail(
                    appointment.getBookingSlot().getSchedule().getDoctor().getUser().getEmail(), appointment);
        }

        redirectAttributes.addFlashAttribute("success", "Thanh toán và đặt lịch thành công!");
        return "redirect:/booking-success";
    }

    @GetMapping("/booking-receptionist/payment-cancel")
    public String handlePayOSCancel(HttpSession session, RedirectAttributes redirectAttributes) {
        Appointment appointment = (Appointment) session.getAttribute("pendingAppointment");

        if (appointment != null) {
            appointmentService.cancelAppointment(appointment.getAppointmentID(), "Bệnh nhân hủy thanh toán");
            session.removeAttribute("pendingAppointment");
        }

        redirectAttributes.addFlashAttribute("error", "Thanh toán bị hủy. Lịch hẹn đã được hủy.");
        return "redirect:/receptionist";
    }

    @GetMapping("/booking-success")
    public String showBookingSuccessPage() {
        return "receptionist/booking-success"; // cần có file JSP tương ứng
    }
}
