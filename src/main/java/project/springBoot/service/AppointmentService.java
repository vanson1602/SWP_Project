package project.springBoot.service;

import project.springBoot.model.*;
import java.time.LocalDateTime;
import java.util.List;

public interface AppointmentService {
    Appointment createAppointment(Long patientId, Long slotId, Long specializationId,
            Long appointmentTypeId, String notes);

    Appointment updateAppointmentStatus(Long appointmentId, String status, String notes);

    void cancelAppointment(Long appointmentId, String reason);

    Appointment getAppointmentById(Long appointmentId);

    Appointment getAppointmentByIdWithDetails(Long appointmentId);

    Appointment getAppointmentByNumber(String appointmentNumber);

    List<Appointment> getPatientAppointments(Long patientId);

    boolean canBookAppointment(Long patientId, Long doctorId, LocalDateTime appointmentDate);

    List<AppointmentType> getAllAppointmentTypes();

    AppointmentType getAppointmentTypeById(Long appointmentTypeId);

    List<Appointment> findByPatientPatientIDOrderByAppointmentDateDesc(Long patientId);

    void updatePaymentStatus(Long appointmentId, String status);
}