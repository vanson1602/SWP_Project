package project.springBoot.service.impl;

import lombok.RequiredArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

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
import project.springBoot.model.Notification;
import project.springBoot.model.Patient;
import project.springBoot.repository.AppointmentRepository;
import project.springBoot.repository.AppointmentTypeRepository;
import project.springBoot.repository.DoctorBookingSlotRepository;
import project.springBoot.repository.NotificationRepository;
import project.springBoot.repository.PatientRepository;
import project.springBoot.service.AppointmentService;
import project.springBoot.service.EmailService;
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

        Appointment appointment = new Appointment();
        appointment.setPatient(patient);
        appointment.setDoctor(slot.getSchedule().getDoctor());
        appointment.setAppointmentDate(slot.getStartTime());
        appointment.setAppointmentNumber(AppointmentUtils.generateAppointmentNumber());
        appointment.setStatus("Pending");
        appointment.setPatientNotes(notes);
        appointment.setAppointmentType(appointmentType);
        appointment = appointmentRepository.save(appointment);

        slot.setStatus("Booked");
        slot.setAppointment(appointment);
        slot.setModifiedAt(LocalDateTime.now());
        bookingSlotRepository.save(slot);

        Notification doctorNotification = new Notification();
        doctorNotification.setUser(slot.getSchedule().getDoctor().getUser());
        doctorNotification.setTitle("Lịch hẹn mới");
        doctorNotification.setMessage("Bạn có lịch hẹn mới với bệnh nhân " + patient.getUser().getFullName() +
                " vào lúc " + appointment.getAppointmentDate());
        doctorNotification.setNotificationType("NewAppointment");
        doctorNotification.setRead(false);
        notificationRepository.save(doctorNotification);

        return appointment;
    }

    @Override
    public Appointment updateAppointmentStatus(Long appointmentId, String status, String notes) {
        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new RuntimeException("Appointment not found"));

        appointment.setStatus(status);
        if (notes != null) {
            appointment.setAdminNotes(notes);
        }
        appointment.setModifiedAt(LocalDateTime.now());

        if ("Cancelled".equals(status) || "Rejected".equals(status)) {
            DoctorBookingSlot slot = appointment.getBookingSlot();
            slot.setStatus("Available");
            slot.setAppointment(null);
            bookingSlotRepository.save(slot);
        } else if ("Confirmed".equals(status)) {
            Notification patientNotification = new Notification();
            patientNotification.setUser(appointment.getPatient().getUser());
            patientNotification.setTitle("Xác nhận lịch hẹn");
            patientNotification.setMessage("Lịch hẹn của bạn đã được xác nhận thành công.");
            patientNotification.setNotificationType("Confirmation");
            patientNotification.setRead(false);
            notificationRepository.save(patientNotification);

            String patientEmail = appointment.getPatient().getUser().getEmail();
            emailService.sendAppointmentConfirmationEmail(patientEmail, appointment);

            String doctorEmail = appointment.getBookingSlot().getSchedule().getDoctor().getUser().getEmail();
            emailService.sendDoctorAppointmentNotificationEmail(doctorEmail, appointment);
        }

        return appointmentRepository.save(appointment);
    }

    @Override
    public void cancelAppointment(Long appointmentId, String reason) {
        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new RuntimeException("Appointment not found"));

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

    public List<Appointment> getAppointmentsByDoctorAndDateRange(Long doctorId, LocalDateTime startDate,
            LocalDateTime endDate) {
        return appointmentRepository.findByDoctorAndDateRangeAndNotCompleted(doctorId, startDate, endDate);
    }

    @Override
    public Appointment findByIdAppointment(Long appointmentId) {
        return appointmentRepository.findById(appointmentId).orElse(null);
    }
}