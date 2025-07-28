package project.springBoot.service.impl;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Map;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import project.springBoot.model.Appointment;
import project.springBoot.model.AppointmentType;
import project.springBoot.model.Doctor;
import project.springBoot.model.DoctorBookingSlot;
import project.springBoot.model.Invoice;
import project.springBoot.model.Invoice;
import project.springBoot.model.Notification;
import project.springBoot.model.Patient;
import project.springBoot.repository.AppointmentRepository;
import project.springBoot.repository.AppointmentTypeRepository;
import project.springBoot.repository.DoctorBookingSlotRepository;
import project.springBoot.repository.InvoiceRepository;
import project.springBoot.repository.InvoiceRepository;
import project.springBoot.repository.NotificationRepository;
import project.springBoot.repository.PatientRepository;
import project.springBoot.service.AppointmentService;
import project.springBoot.service.EmailService;
import project.springBoot.utils.AppointmentUtils;
import project.springBoot.utils.AppointmentUtils;
import project.springBoot.utils.AppointmentUtils;

@Service
@Transactional
@RequiredArgsConstructor
public class AppointmentServiceImpl implements AppointmentService {
    private final AppointmentRepository appointmentRepository;
    private final DoctorBookingSlotRepository bookingSlotRepository;
    private final PatientRepository patientRepository;
    private final AppointmentTypeRepository appointmentTypeRepository;
    private final NotificationRepository notificationRepository;
    private final EmailService emailService;

    private final InvoiceRepository invoiceRepository;

    @Override
    @Transactional
    public Appointment createAppointment(Long patientId, Long slotId, Long specializationId,
            Long appointmentTypeId, String notes) {

        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new RuntimeException("Patient not found"));

        DoctorBookingSlot slot = bookingSlotRepository.findById(slotId)
                .orElseThrow(() -> new RuntimeException("Booking slot not found"));

        AppointmentType appointmentType = appointmentTypeRepository.findById(appointmentTypeId)
                .orElseThrow(() -> new RuntimeException("Appointment type not found"));

        if (!slot.getStatus().equalsIgnoreCase("Available")) {
            throw new RuntimeException("This slot is no longer available. Current status: " + slot.getStatus());
        }
        if (!slot.getStatus().equalsIgnoreCase("Available")) {
            throw new RuntimeException("This slot is no longer available. Current status: " + slot.getStatus());
        }

        Appointment appointment = new Appointment();
        appointment.setPatient(patient);
        appointment.setDoctor(slot.getSchedule().getDoctor());
        appointment.setAppointmentDate(slot.getStartTime());
        appointment.setAppointmentNumber(AppointmentUtils.generateAppointmentNumber());
        appointment.setStatus("Pending");
        appointment.setPatientNotes(notes);
        appointment.setAppointmentType(appointmentType);

        // Save appointment before linking slot
        appointment = appointmentRepository.save(appointment);

        // Link appointment <-> slot
        slot.setStatus("Booked");
        slot.setAppointment(appointment);
        slot.setModifiedAt(LocalDateTime.now());
        bookingSlotRepository.save(slot);

        // 👇 Gán lại slot cho appointment để tránh null khi gọi getBookingSlot()
        appointment.setBookingSlot(slot);

        // Tạo thông báo cho bác sĩ
        Notification doctorNotification = new Notification();
        doctorNotification.setUser(slot.getSchedule().getDoctor().getUser());
        doctorNotification.setTitle("Lịch hẹn mới");
        doctorNotification.setMessage("Bạn có lịch hẹn mới với bệnh nhân " + patient.getUser().getFullName() +
                " vào lúc " + appointment.getAppointmentDate());
        doctorNotification.setNotificationType("NewAppointment");
        doctorNotification.setRead(false);
        notificationRepository.save(doctorNotification);

        try {
            String patientEmail = patient.getUser().getEmail();
            emailService.sendAppointmentBookingConfirmationEmail(patientEmail, appointment);
        } catch (Exception e) {
            System.err.println("Failed to send booking confirmation email: " + e.getMessage());
        }

        try {
            String doctorEmail = slot.getSchedule().getDoctor().getUser().getEmail();
            emailService.sendDoctorAppointmentNotificationEmail(doctorEmail, appointment);
        } catch (Exception e) {
            System.err.println("Failed to send doctor notification email: " + e.getMessage());
        }

        return appointment;
    }

    @Override
    @Transactional
    public Appointment updateAppointmentStatus(Long appointmentId, String status, String notes) {
        // Load appointment with all relationships
        Appointment appointment = appointmentRepository.findByIdWithDetails(appointmentId)
                .orElseThrow(() -> new RuntimeException("Appointment not found"));

        DoctorBookingSlot slot = appointment.getBookingSlot();
        if (slot == null) {
            throw new RuntimeException("Booking slot not found for appointment");
        }

        // Cập nhật trạng thái của slot trước
        if ("Cancelled".equals(status) || "Rejected".equals(status)) {
            slot.setStatus("Available");
            slot.setAppointment(null);
        } else if ("Confirmed".equals(status)) {
            slot.setStatus("Booked");
        }
        slot.setModifiedAt(LocalDateTime.now());

        // Cập nhật trạng thái của appointment
        appointment.setStatus(status);
        if (notes != null) {
            appointment.setAdminNotes(notes);
        }
        appointment.setModifiedAt(LocalDateTime.now());

        // Cập nhật mối quan hệ hai chiều
        if ("Cancelled".equals(status) || "Rejected".equals(status)) {
            appointment.setBookingSlot(null);
        } else {
            appointment.setBookingSlot(slot);
            slot.setAppointment(appointment);
        }

        // Lưu slot trước
        bookingSlotRepository.save(slot);

        // Gửi thông báo nếu xác nhận
        if ("Confirmed".equals(status)) {
            Notification patientNotification = new Notification();
            patientNotification.setUser(appointment.getPatient().getUser());
            patientNotification.setTitle("Xác nhận lịch hẹn");
            patientNotification.setMessage("Lịch hẹn của bạn đã được xác nhận thành công.");
            patientNotification.setNotificationType("Confirmation");
            patientNotification.setRead(false);
            notificationRepository.save(patientNotification);

            String patientEmail = appointment.getPatient().getUser().getEmail();
            emailService.sendAppointmentConfirmationEmail(patientEmail, appointment);

            String doctorEmail = slot.getSchedule().getDoctor().getUser().getEmail();
            emailService.sendDoctorAppointmentNotificationEmail(doctorEmail, appointment);
        }

        // Lưu appointment sau
        return appointmentRepository.save(appointment);

    }

    @Override
    public void cancelAppointment(Long appointmentId, String reason) {
        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new RuntimeException("Appointment not found"));

        if ("Cancelled".equals(appointment.getStatus())) {
            throw new RuntimeException("Appointment is already cancelled");
        }
        if ("Cancelled".equals(appointment.getStatus())) {
            throw new RuntimeException("Appointment is already cancelled");
        }
        if ("Cancelled".equals(appointment.getStatus())) {
            throw new RuntimeException("Appointment is already cancelled");
        }

        Doctor doctor = appointment.getBookingSlot().getSchedule().getDoctor();
        if (appointment.getDoctor() == null) {
            appointment.setDoctor(doctor);
        }

        appointment.setStatus("Cancelled");
        appointment.setAdminNotes(reason);
        appointment.setModifiedAt(LocalDateTime.now());

        DoctorBookingSlot slot = appointment.getBookingSlot();
        if (slot != null) {
            slot.setStatus("Available");
            slot.setAppointment(null);
            bookingSlotRepository.save(slot);
        }

        Notification doctorNotification = new Notification();
        doctorNotification.setUser(doctor.getUser());
        doctorNotification.setTitle("Lịch hẹn bị hủy");
        doctorNotification.setMessage("Lịch hẹn với bệnh nhân " + appointment.getPatient().getUser().getFullName() +
                " vào lúc " + appointment.getAppointmentDate() + " đã bị hủy. Lý do: " + reason);
        doctorNotification.setNotificationType("General");
        doctorNotification.setRead(false);
        notificationRepository.save(doctorNotification);

        Notification patientNotification = new Notification();
        patientNotification.setUser(appointment.getPatient().getUser());
        patientNotification.setTitle("Lịch hẹn đã bị hủy");
        patientNotification.setMessage("Lịch hẹn của bạn với bác sĩ " + doctor.getUser().getFullName() +
                " vào lúc " + appointment.getAppointmentDate() +
                " đã bị hủy. Lý do: " + reason);
        patientNotification.setNotificationType("General");
        patientNotification.setRead(false);
        notificationRepository.save(patientNotification);

        appointmentRepository.save(appointment);
    }

    @Override
    public Appointment getAppointmentById(Long appointmentId) {
        return appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new RuntimeException("Appointment not found"));
    }

    @Override
    public Appointment getAppointmentByIdWithDetails(Long appointmentId) {
        return appointmentRepository.findByIdWithDetails(appointmentId)
                .orElseThrow(() -> new RuntimeException("Appointment not found"));
    }

    @Override
    public Appointment getAppointmentByNumber(String appointmentNumber) {
        return appointmentRepository.findByAppointmentNumber(appointmentNumber)
                .orElseThrow(() -> new RuntimeException("Appointment not found"));
    }

    @Override
    public List<Appointment> getPatientAppointments(Long patientId) {
        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new RuntimeException("Patient not found"));
        return appointmentRepository.findByPatientOrderByAppointmentDateDesc(patient);
    }

    @Override
    public List<Appointment> findByPatientPatientIDOrderByAppointmentDateDesc(Long patientId) {
        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new RuntimeException("Patient not found"));
        return appointmentRepository.findByPatientOrderByAppointmentDateDesc(patient);
    }

    @Override
    public boolean canBookAppointment(Long patientId, Long doctorId, LocalDateTime appointmentDate) {
        long pendingCount = appointmentRepository.countByPatientAndStatusAndAppointmentDateAfter(
                patientId, "Pending", LocalDateTime.now());
        return pendingCount < 2;
    }

    @Override
    public AppointmentType getAppointmentTypeById(Long appointmentTypeId) {
        return appointmentTypeRepository.findById(appointmentTypeId)
                .orElseThrow(() -> new RuntimeException("Appointment type not found"));
    }

    @Override
    public List<AppointmentType> getAllAppointmentTypes() {
        return appointmentTypeRepository.findAll();
    }

    @Override
    public void updatePaymentStatus(Long appointmentId, String status) {
        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new RuntimeException("Appointment not found"));
        appointment.setStatus(status);
        appointment.setModifiedAt(LocalDateTime.now());
        appointmentRepository.save(appointment);
    }

    @Override
    public List<Appointment> findByPatientAndStatus(Long patientId, String status) {
        return appointmentRepository.findByPatientAndStatus(patientId, status);
    }

    @Override
    public Page<Appointment> getAppointmentsByPatientId(long patientId, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("appointmentDate").descending());
        return appointmentRepository.findByPatientId(patientId, pageable);
    }

    @Override
    public Page<Appointment> getAppointmentsByPatientAndStatus(long patientId, String status, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("appointmentDate").descending());
        return appointmentRepository.findByPatientAndStatus(patientId, status, pageable);
    }

    private void createStatusNotification(Appointment appointment, String status) {
        String title = "";
        String message = "";

        switch (status) {
            case "Confirmed":
                title = "Lịch hẹn đã được xác nhận";
                message = "Lịch hẹn của bạn đã được xác nhận";
                break;
            case "Rejected":
                title = "Lịch hẹn đã bị từ chối";
                message = "Lịch hẹn của bạn đã bị từ chối" +
                        (appointment.getAdminNotes() != null ? ". Lý do: " + appointment.getAdminNotes() : "");
                break;
            case "Cancelled":
                title = "Lịch hẹn đã bị hủy";
                message = "Lịch hẹn của bạn đã bị hủy";
                break;
        }

        Notification notification = new Notification();
        notification.setUser(appointment.getPatient().getUser());
        notification.setAppointment(appointment);
        notification.setTitle(title);
        notification.setMessage(message);
        notification.setNotificationType("General");
        notificationRepository.save(notification);
    }

    @Scheduled(fixedRate = 300000)
    public void cancelUnpaidAppointments() {
        LocalDateTime cutoffTime = LocalDateTime.now().minusHours(3);

        List<Appointment> unpaidAppointments = appointmentRepository.findUnpaidAppointments(cutoffTime);

        for (Appointment appointment : unpaidAppointments) {
            appointment.setStatus("Cancelled");
            appointment.setModifiedAt(LocalDateTime.now());
            appointmentRepository.save(appointment);

            Notification notification = new Notification();
            notification.setUser(appointment.getPatient().getUser());
            notification.setAppointment(appointment);
            notification.setTitle("Lịch Hẹn Bị Hủy");
            notification.setMessage("Lịch hẹn của bạn đã bị hủy do chưa thanh toán sau 12 giờ.");
            notification.setNotificationType("Rejection");
            notification.setPriority("High");
            notificationRepository.save(notification);
        }
    }

    @Override
    public List<Appointment> findAppointmentByPatientID(Long patientId) {
        return appointmentRepository.findAppointmentByPatient_PatientID(patientId);
    }

    public List<Appointment> getAppointmentsByDoctorAndDateRange(Long doctorId, LocalDateTime startDate,
            LocalDateTime endDate) {
        return appointmentRepository.findByDoctorAndDateRangeAndNotCompleted(doctorId, startDate, endDate);
    }

    @Override
    public List<Appointment> getAppointmentsByDoctorAndDateRangeIncludingCompleted(Long doctorId,
            LocalDateTime startDate,
            LocalDateTime endDate) {
        return appointmentRepository.findByDoctorAndDateRange(doctorId, startDate, endDate);
    }

    @Override
    public Appointment findByIdAppointment(Long appointmentId) {
        return appointmentRepository.findById(appointmentId).orElse(null);
    }

    @Override
    public long countTotalPatients() {
        return patientRepository.count();
    }

    @Override
    public long countTodaysAppointments() {
        LocalDateTime startOfDay = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0).withNano(0);
        LocalDateTime endOfDay = startOfDay.plusDays(1);
        return appointmentRepository.countByAppointmentDateBetween(startOfDay, endOfDay);
    }

    @Override
    public double getTotalRevenue() {
        Double revenue = appointmentRepository.sumConsultationFeeForCompletedAppointments();
        return revenue != null ? revenue : 0.0;
    }

    @Override
    public List<Map<String, Object>> getMonthlyAppointments(int months) {
        LocalDateTime startDate = LocalDateTime.now().minusMonths(months);
        LocalDateTime endDate = LocalDateTime.now();
        return appointmentRepository.getMonthlyAppointmentCounts(startDate, endDate);
    }

    @Override
    public Map<String, Long> getAppointmentStatusDistribution() {
        Map<String, Long> distribution = new java.util.HashMap<>();
        distribution.put("Pending", appointmentRepository.countByStatus("Pending"));
        distribution.put("Confirmed", appointmentRepository.countByStatus("Confirmed"));
        distribution.put("Completed", appointmentRepository.countByStatus("Completed"));
        distribution.put("Cancelled", appointmentRepository.countByStatus("Cancelled"));
        distribution.put("Rejected", appointmentRepository.countByStatus("Rejected"));
        return distribution;
    }

    @Override
    public List<Appointment> findTop5ByStatusOrderByCreatedAtDesc(String status) {
        Pageable pageable = PageRequest.of(0, 5);
        return appointmentRepository.findTop5ByStatusOrderByCreatedAtDesc(status, pageable);
    }

    @Override
    public List<Map<String, Object>> getRevenueReport(LocalDateTime startDate, LocalDateTime endDate) {
        return appointmentRepository.getRevenueByDoctor(startDate, endDate);
    }

    @Override
    public Map<String, Object> getDashboardStatistics() {
        Map<String, Object> stats = new java.util.HashMap<>();
        stats.put("totalPatients", countTotalPatients());
        stats.put("todaysAppointments", countTodaysAppointments());
        stats.put("totalRevenue", getTotalRevenue());
        stats.put("appointmentStatusDistribution", getAppointmentStatusDistribution());
        return stats;
    }

    @Override
    public long getDistinctAppointmentsCompletedBetween(LocalDateTime start, LocalDateTime end) {
        return appointmentRepository.countDistinctAppointmentsCompletedBetween(start, end);
    }

    @Override
    public long getDistinctPatientsCompletedBetween(LocalDateTime start, LocalDateTime end) {
        return appointmentRepository.countDistinctPatientsCompletedBetween(start, end);
    }

    @Override
    public double getRevenueBetween(LocalDateTime start, LocalDateTime end) {
        Double revenue = appointmentRepository.sumRevenueBetween(start, end);
        return revenue != null ? revenue : 0.0;
    }

    @Override
    public List<Map<String, Object>> getMonthlyAppointmentReport(LocalDateTime startDate, LocalDateTime endDate) {
        return appointmentRepository.getMonthlyAppointmentCounts(startDate, endDate);
    }

    @Override
    public List<Map<String, Object>> getDailyAppointmentReport(LocalDateTime startDate, LocalDateTime endDate) {
        return appointmentRepository.getDailyAppointmentCounts(startDate, endDate);
    }

    @Override
    public Map<String, Long> getAppointmentStatusDistributionBetween(LocalDateTime startDate, LocalDateTime endDate) {
        List<Map<String, Object>> results = appointmentRepository.getAppointmentStatusDistributionBetween(startDate,
                endDate);
        Map<String, Long> distribution = new java.util.HashMap<>();

        // Initialize with 0 for all possible statuses
        distribution.put("Pending", 0L);
        distribution.put("Confirmed", 0L);
        distribution.put("Completed", 0L);
        distribution.put("Cancelled", 0L);
        distribution.put("Rejected", 0L);

        // Fill with actual data
        for (Map<String, Object> result : results) {
            String status = (String) result.get("status");
            Long count = (Long) result.get("count");
            if (status != null && count != null) {
                distribution.put(status, count);
            }
        }

        return distribution;
    }

    @Override
    public List<Invoice> getInvoicesInDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        return invoiceRepository.findByInvoiceDateBetween(startDate, endDate);
    }

    @Override
    public List<Map<String, Object>> getDoctorRevenueReport(LocalDateTime startDate, LocalDateTime endDate) {
        return appointmentRepository.getRevenueByDoctor(startDate, endDate);
    }

    // Thêm các phương thức mới cho thống kê bệnh nhân
    @Override
    public List<Map<String, Object>> getPatientAppointmentsByMonthYear(Long patientId) {
        return appointmentRepository.getPatientAppointmentsByMonthYear(patientId);
    }

    @Override
    public List<Map<String, Object>> getPatientAppointmentsBySpecialization(Long patientId) {
        return appointmentRepository.getPatientAppointmentsBySpecialization(patientId);
    }

    @Override
    public long countPatientAppointmentsByMonthYear(Long patientId, int year, int month) {
        return appointmentRepository.countPatientAppointmentsByMonthYear(patientId, year, month);
    }

    @Override
    public long countPatientAppointmentsBySpecialization(Long patientId, Long specializationId) {
        return appointmentRepository.countPatientAppointmentsBySpecialization(patientId, specializationId);
    }

    // Thêm các phương thức mới cho filter và chart
    @Override
    public List<Map<String, Object>> getPatientAppointmentsByYear(Long patientId, int year) {
        return appointmentRepository.getPatientAppointmentsByYear(patientId, year);
    }

    @Override
    public List<Map<String, Object>> getPatientAppointmentsByYearMonth(Long patientId, int year, int month) {
        return appointmentRepository.getPatientAppointmentsByYearMonth(patientId, year, month);
    }

    @Override
    public List<Map<String, Object>> getPatientAppointmentsBySpecializationAndYear(Long patientId, int year) {
        return appointmentRepository.getPatientAppointmentsBySpecializationAndYear(patientId, year);
    }

    @Override
    public List<Map<String, Object>> getPatientAppointmentsBySpecializationAndYearMonth(Long patientId, int year,
            int month) {
        return appointmentRepository.getPatientAppointmentsBySpecializationAndYearMonth(patientId, year, month);
    }

    @Override
    public List<Integer> getAvailableYearsForPatient(Long patientId) {
        return appointmentRepository.getAvailableYearsForPatient(patientId);
    }

    @Override
    public List<Map<String, Object>> getPatientMonthlyStatusStats(Long patientId, int year) {
        return appointmentRepository.getPatientMonthlyStatusStats(patientId, year);
    }

    @Override
    public List<Map<String, Object>> getPatientDailyStatusStats(Long patientId, int year, int month) {
        return appointmentRepository.getPatientDailyStatusStats(patientId, year, month);
    }

    @Override
    public List<Map<String, Object>> getPatientAppointmentsByWeekInMonth(Long patientId, int year, int month) {
        return appointmentRepository.getPatientAppointmentsByWeekInMonth(patientId, year, month);
    }

    @Override
    public List<Map<String, Object>> getDoctorPatientCountByDay(Long doctorId, int year, int month) {
        return appointmentRepository.getDoctorPatientCountByDay(doctorId, year, month);
    }

    @Override
    public List<Map<String, Object>> getDoctorPatientCountByWeek(Long doctorId, int year, int month) {
        return appointmentRepository.getDoctorPatientCountByWeek(doctorId, year, month);
    }

    @Override
    public List<Map<String, Object>> getDoctorPatientCountByMonth(Long doctorId, int year) {
        return appointmentRepository.getDoctorPatientCountByMonth(doctorId, year);
    }

}