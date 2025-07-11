package project.springBoot.repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import project.springBoot.model.Appointment;
import project.springBoot.model.Patient;

@Repository
public interface AppointmentRepository extends JpaRepository<Appointment, Long> {
        Optional<Appointment> findByAppointmentNumber(String appointmentNumber);

        List<Appointment> findByPatientOrderByAppointmentDateDesc(Patient patient);

        List<Appointment> findByPatientAndStatusOrderByAppointmentDateDesc(Patient patient, String status);

        @Query("SELECT COUNT(a) FROM Appointment a " +
                        "WHERE a.patient.patientID = :patientId " +
                        "AND a.status = :status " +
                        "AND a.appointmentDate > :date")
        long countByPatientAndStatusAndAppointmentDateAfter(
                        @Param("patientId") Long patientId,
                        @Param("status") String status,
                        @Param("date") LocalDateTime date);

        @Query("SELECT DISTINCT a FROM Appointment a " +
                        "LEFT JOIN FETCH a.patient p " +
                        "LEFT JOIN FETCH p.user pu " +
                        "LEFT JOIN FETCH a.bookingSlot bs " +
                        "LEFT JOIN FETCH bs.schedule s " +
                        "LEFT JOIN FETCH a.doctor d " +
                        "LEFT JOIN FETCH d.user du " +
                        "LEFT JOIN FETCH d.specializations " +
                        "WHERE a.appointmentID = :id")
        Optional<Appointment> findByIdWithDetails(@Param("id") Long id);

        @Query("SELECT a FROM Appointment a " +
                        "LEFT JOIN FETCH a.patient p " +
                        "LEFT JOIN FETCH p.user pu " +
                        "LEFT JOIN FETCH a.bookingSlot bs " +
                        "LEFT JOIN FETCH bs.schedule s " +
                        "LEFT JOIN FETCH s.doctor d " +
                        "LEFT JOIN FETCH d.user du " +
                        "LEFT JOIN FETCH d.specializations " +
                        "WHERE p.patientID = :patientId " +
                        "AND a.status = :status " +
                        "ORDER BY a.appointmentDate DESC")
        List<Appointment> findByPatientAndStatus(@Param("patientId") Long patientId, @Param("status") String status);

        @Query("SELECT DISTINCT a FROM Appointment a LEFT JOIN FETCH a.doctor LEFT JOIN FETCH a.bookingSlot bs LEFT JOIN FETCH bs.schedule s LEFT JOIN FETCH s.doctor d WHERE a.patient.patientID = :patientId")
        Page<Appointment> findByPatientId(@Param("patientId") Long patientId, Pageable pageable);

        @Query("SELECT DISTINCT a FROM Appointment a LEFT JOIN FETCH a.doctor LEFT JOIN FETCH a.bookingSlot bs LEFT JOIN FETCH bs.schedule s LEFT JOIN FETCH s.doctor d WHERE a.patient.patientID = :patientId AND a.status = :status")
        Page<Appointment> findByPatientAndStatus(@Param("patientId") Long patientId, @Param("status") String status,
                        Pageable pageable);

        @Query("SELECT a FROM Appointment a WHERE a.status = 'Pending' AND a.createdAt <= :cutoffTime")
        List<Appointment> findUnpaidAppointments(@Param("cutoffTime") LocalDateTime cutoffTime);

        @Query("SELECT DISTINCT a FROM Appointment a " +
                        "LEFT JOIN FETCH a.patient p " +
                        "LEFT JOIN FETCH p.user pu " +
                        "LEFT JOIN FETCH a.bookingSlot bs " +
                        "LEFT JOIN FETCH bs.schedule s " +
                        "LEFT JOIN FETCH a.doctor d " +
                        "LEFT JOIN FETCH d.user du " +
                        "LEFT JOIN FETCH a.appointmentType at " +
                        "WHERE a.doctor.doctorID = :doctorId " +
                        "AND a.appointmentDate BETWEEN :startDate AND :endDate " +
                        "AND a.status NOT IN ('Completed', 'Cancelled', 'NoShow') " +
                        "ORDER BY a.appointmentDate")
        List<Appointment> findByDoctorAndDateRangeAndNotCompleted(
                        @Param("doctorId") Long doctorId,
                        @Param("startDate") LocalDateTime startDate,
                        @Param("endDate") LocalDateTime endDate);

        @Query("SELECT DISTINCT a FROM Appointment a " +
                        "LEFT JOIN FETCH a.patient p " +
                        "LEFT JOIN FETCH p.user pu " +
                        "LEFT JOIN FETCH a.bookingSlot bs " +
                        "LEFT JOIN FETCH bs.schedule s " +
                        "LEFT JOIN FETCH a.doctor d " +
                        "LEFT JOIN FETCH d.user du " +
                        "LEFT JOIN FETCH a.appointmentType at " +
                        "WHERE a.doctor.doctorID = :doctorId " +
                        "AND a.appointmentDate BETWEEN :startDate AND :endDate " +
                        "AND a.status NOT IN ('Cancelled', 'NoShow') " +
                        "ORDER BY a.appointmentDate")
        List<Appointment> findByDoctorAndDateRange(
                        @Param("doctorId") Long doctorId,
                        @Param("startDate") LocalDateTime startDate,
                        @Param("endDate") LocalDateTime endDate);
    
    @Query("SELECT COUNT(a) FROM Appointment a WHERE a.appointmentDate BETWEEN :start AND :end")
    long countByAppointmentDateBetween(LocalDateTime start, LocalDateTime end);

    @Query("SELECT COUNT(a) FROM Appointment a WHERE a.status = :status")
    long countByStatus(String status);

    @Query("SELECT COALESCE(SUM(d.consultationFee), 0) " +
           "FROM Appointment a " +
           "JOIN a.doctor d " +
           "WHERE a.status = 'Completed'")
    Double sumConsultationFeeForCompletedAppointments();  
    
    @Query("SELECT a FROM Appointment a " +
           "WHERE a.status = :status " +
           "ORDER BY a.createdAt DESC")
    List<Appointment> findTop5ByStatusOrderByCreatedAtDesc(@Param("status") String status, Pageable pageable);

    @Query("SELECT NEW map(" +
           "d.doctorID as doctorId, " +
           "d.user.firstName as firstName, " +
           "d.user.lastName as lastName, " +
           "d.consultationFee as fee, " +
           "COUNT(a) as totalExaminations, " +
           "d.consultationFee * COUNT(a) as totalRevenue) " +
           "FROM Appointment a " +
           "JOIN a.doctor d " +
           "WHERE a.status = 'Completed' " +
           "AND a.appointmentDate BETWEEN :startDate AND :endDate " +
           "GROUP BY d.doctorID, d.user.firstName, d.user.lastName, d.consultationFee " +
           "ORDER BY totalRevenue DESC")
    List<Map<String, Object>> getRevenueByDoctor(@Param("startDate") LocalDateTime startDate, 
                                                @Param("endDate") LocalDateTime endDate);

    @Query("SELECT COUNT(DISTINCT a.appointmentID) FROM Appointment a WHERE a.status = 'Completed' AND a.appointmentDate BETWEEN :start AND :end")
    long countDistinctAppointmentsCompletedBetween(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);

    @Query("SELECT COUNT(DISTINCT a.patient.patientID) FROM Appointment a WHERE a.status = 'Completed' AND a.appointmentDate BETWEEN :start AND :end")
    long countDistinctPatientsCompletedBetween(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);

    @Query("SELECT COUNT(a) FROM Appointment a WHERE a.status = :status AND a.appointmentDate BETWEEN :start AND :end")
    long countByStatusAndAppointmentDateBetween(@Param("status") String status, @Param("start") LocalDateTime start, @Param("end") LocalDateTime end);

    @Query("SELECT COALESCE(SUM(a.doctor.consultationFee), 0) FROM Appointment a WHERE a.status = 'Completed' AND a.appointmentDate BETWEEN :start AND :end")
    Double sumRevenueBetween(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);

@Query("SELECT NEW map(" +
           "FUNCTION('DATE_FORMAT', a.appointmentDate, '%Y-%m') as yearMonth, " +
           "EXTRACT(MONTH FROM a.appointmentDate) as monthNumber, " +
           "EXTRACT(YEAR FROM a.appointmentDate) as year, " +
           "COUNT(a) as appointmentCount, " +
           "COALESCE(SUM(d.consultationFee), 0) as totalRevenue) " +
           "FROM Appointment a " +
           "JOIN a.doctor d " +
           "WHERE a.status = 'Completed' AND a.appointmentDate BETWEEN :startDate AND :endDate " +
           "GROUP BY FUNCTION('DATE_FORMAT', a.appointmentDate, '%Y-%m'), " +
           "EXTRACT(MONTH FROM a.appointmentDate), " +
           "EXTRACT(YEAR FROM a.appointmentDate) " +
           "ORDER BY yearMonth")
    List<Map<String, Object>> getMonthlyAppointmentCounts(@Param("startDate") LocalDateTime startDate, 
                                                         @Param("endDate") LocalDateTime endDate);

    @Query("SELECT NEW map(" +
           "FUNCTION('DATE_FORMAT', a.appointmentDate, '%Y-%m-%d') as date, " +
           "COUNT(a) as appointmentCount, " +
           "COALESCE(SUM(d.consultationFee), 0) as totalRevenue) " +
           "FROM Appointment a " +
           "JOIN a.doctor d " +
           "WHERE a.status = 'Completed' AND a.appointmentDate BETWEEN :startDate AND :endDate " +
           "GROUP BY FUNCTION('DATE_FORMAT', a.appointmentDate, '%Y-%m-%d') " +
           "ORDER BY date")
    List<Map<String, Object>> getDailyAppointmentCounts(@Param("startDate") LocalDateTime startDate, 
                                                       @Param("endDate") LocalDateTime endDate);

    @Query("SELECT NEW map(" +
           "a.status as status, " +
           "COUNT(a) as count) " +
           "FROM Appointment a " +
           "WHERE a.appointmentDate BETWEEN :startDate AND :endDate " +
           "GROUP BY a.status")
    List<Map<String, Object>> getAppointmentStatusDistributionBetween(@Param("startDate") LocalDateTime startDate, 
                                                                     @Param("endDate") LocalDateTime endDate);

        @Query("SELECT a FROM Appointment a " +
                        "LEFT JOIN FETCH a.patient p " +
                        "LEFT JOIN FETCH p.user pu " +
                        "LEFT JOIN FETCH a.bookingSlot bs " +
                        "LEFT JOIN FETCH bs.schedule s " +
                        "LEFT JOIN FETCH s.doctor d " +
                        "LEFT JOIN FETCH d.user du " +
                        "LEFT JOIN FETCH d.specializations " +
                        "WHERE p.patientID = :patientId " +
                        "ORDER BY a.appointmentDate DESC")
        List<Appointment> findAppointmentByPatient_PatientID(Long patientId);
}