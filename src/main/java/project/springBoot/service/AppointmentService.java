package project.springBoot.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Service;

import project.springBoot.model.Appointment;

@Service
public interface AppointmentService {
    // Appointment createAppointment(Long patientId, Long slotId, Long specializationId,
    //         Long appointmentTypeId, String notes);

    // Appointment updateAppointmentStatus(Long appointmentId, String status, String notes);

    // void cancelAppointment(Long appointmentId, String reason);

    Appointment getAppointmentById(Long appointmentId);

    Appointment getAppointmentByIdWithDetails(Long appointmentId);

    Appointment getAppointmentByNumber(String appointmentNumber);

    List<Appointment> getPatientAppointments(Long patientId);

    boolean canBookAppointment(Long patientId, Long doctorId, LocalDateTime appointmentDate);

    // List<AppointmentType> getAllAppointmentTypes();

    // AppointmentType getAppointmentTypeById(Long appointmentTypeId);

    List<Appointment> findByPatientPatientIDOrderByAppointmentDateDesc(Long patientId);

    void updatePaymentStatus(Long appointmentId, String status);

    List<Appointment> getAppointmentsByDoctorAndDateRange(Long doctorId, LocalDateTime startDate, LocalDateTime endDate);

    Appointment findById(Long id);

    Appointment saveAppointment(Appointment appointment);

    List<Appointment> findByDoctorId(long doctorId);
}