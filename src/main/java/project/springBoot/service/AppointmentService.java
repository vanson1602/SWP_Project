package project.springBoot.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import org.springframework.data.domain.Page;

import project.springBoot.model.Appointment;
import project.springBoot.model.AppointmentType;
import project.springBoot.model.Invoice;

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

        List<Appointment> findByPatientAndStatus(Long patientId, String status);

        Page<Appointment> getAppointmentsByPatientId(long patientId, int page, int size);

        Page<Appointment> getAppointmentsByPatientAndStatus(long patientId, String status, int page, int size);

        List<Appointment> getAppointmentsByDoctorAndDateRange(Long doctorId, LocalDateTime startDate,
                        LocalDateTime endDate);


    Appointment findByIdAppointment(Long appointmentId);

    long countTotalPatients();
    long countTodaysAppointments();
    double getTotalRevenue(); // Updated to use consultation_fee
    List<Map<String, Object>> getMonthlyAppointments(int months);
    Map<String, Long> getAppointmentStatusDistribution();
    List<Appointment> findTop5ByStatusOrderByCreatedAtDesc(String status);

    List<Map<String, Object>> getRevenueReport(LocalDateTime startDate, LocalDateTime endDate);
    List<Map<String, Object>> getMonthlyAppointmentReport(LocalDateTime startDate, LocalDateTime endDate);
    Map<String, Object> getDashboardStatistics();

    // Dashboard filter methods
    long getDistinctAppointmentsCompletedBetween(LocalDateTime start, LocalDateTime end);
    long getDistinctPatientsCompletedBetween(LocalDateTime start, LocalDateTime end);
    double getRevenueBetween(LocalDateTime start, LocalDateTime end);

    List<Map<String, Object>> getDailyAppointmentReport(LocalDateTime startDate, LocalDateTime endDate);
    
    Map<String, Long> getAppointmentStatusDistributionBetween(LocalDateTime startDate, LocalDateTime endDate);



    List<Invoice> getInvoicesInDateRange(LocalDateTime startDate, LocalDateTime endDate);

    List<Map<String, Object>> getDoctorRevenueReport(LocalDateTime startDate, LocalDateTime endDate);

        List<Appointment> getAppointmentsByDoctorAndDateRangeIncludingCompleted(Long doctorId, LocalDateTime startDate,
                        LocalDateTime endDate);

        List<Appointment> findAppointmentByPatientID(Long patientId);
}