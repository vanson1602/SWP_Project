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
                        "d as doctor, " +
                        "d.consultationFee as fee, " +
                        "COUNT(a) as totalExaminations, " +
                        "d.consultationFee * COUNT(a) as totalRevenue) " +
                        "FROM Appointment a " +
                        "JOIN a.doctor d " +
                        "JOIN FETCH d.user u " +
                        "WHERE a.status = 'Completed' " +
                        "AND a.appointmentDate BETWEEN :startDate AND :endDate " +
                        "GROUP BY d.doctorID, d, d.consultationFee " +
                        "ORDER BY totalRevenue DESC")
        List<Map<String, Object>> getRevenueByDoctor(@Param("startDate") LocalDateTime startDate,
                        @Param("endDate") LocalDateTime endDate);

        @Query("SELECT COUNT(DISTINCT a.appointmentID) FROM Appointment a WHERE a.status = 'Completed' AND a.appointmentDate BETWEEN :start AND :end")
        long countDistinctAppointmentsCompletedBetween(@Param("start") LocalDateTime start,
                        @Param("end") LocalDateTime end);

        @Query("SELECT COUNT(DISTINCT a.patient.patientID) FROM Appointment a WHERE a.status = 'Completed' AND a.appointmentDate BETWEEN :start AND :end")
        long countDistinctPatientsCompletedBetween(@Param("start") LocalDateTime start,
                        @Param("end") LocalDateTime end);

        @Query("SELECT COUNT(a) FROM Appointment a WHERE a.status = :status AND a.appointmentDate BETWEEN :start AND :end")
        long countByStatusAndAppointmentDateBetween(@Param("status") String status, @Param("start") LocalDateTime start,
                        @Param("end") LocalDateTime end);

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
                        "AND a.status IN ('Pending', 'Confirmed', 'Completed', 'Cancelled', 'Rejected') " +
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
                        "AND a.status = :status " +
                        "ORDER BY a.appointmentDate DESC")
        List<Appointment> findAppointmentByPatient_PatientIDAndStatus(@Param("patientId") Long patientId,
                        @Param("status") String status);

        @Query("SELECT a FROM Appointment a WHERE a.doctor.doctorID = :doctorId AND a.appointmentDate BETWEEN :startDate AND :endDate")
        List<Appointment> findByDoctorAndDateRangeIncludingCompleted(@Param("doctorId") Long doctorId,
                        @Param("startDate") LocalDateTime startDate,
                        @Param("endDate") LocalDateTime endDate);

        @Query("""
                        SELECT NEW map(
                            COUNT(a) as totalAppointments,
                            COUNT(CASE WHEN a.status = 'Completed' THEN 1 END) as completedAppointments,
                            COUNT(CASE WHEN a.status = 'Pending' THEN 1 END) as pendingAppointments,
                            COUNT(CASE WHEN a.status = 'Cancelled' THEN 1 END) as cancelledAppointments,
                            SUM(CASE WHEN a.status = 'Completed' THEN a.appointmentType.fee ELSE 0 END) as totalRevenue
                        )
                        FROM Appointment a
                        """)
        Map<String, Object> getDashboardStatistics();

        @Query("""
                        SELECT NEW map(
                            EXTRACT(YEAR FROM a.appointmentDate) as year,
                            EXTRACT(MONTH FROM a.appointmentDate) as month,
                            COUNT(a) as totalAppointments,
                            COUNT(CASE WHEN a.status = 'Completed' THEN 1 END) as completedAppointments,
                            SUM(CASE WHEN a.status = 'Completed' THEN a.appointmentType.fee ELSE 0 END) as revenue
                        )
                        FROM Appointment a
                        WHERE a.appointmentDate BETWEEN :startDate AND :endDate
                        GROUP BY EXTRACT(YEAR FROM a.appointmentDate), EXTRACT(MONTH FROM a.appointmentDate)
                        ORDER BY year, month
                        """)
        List<Map<String, Object>> getMonthlyAppointmentReport(@Param("startDate") LocalDateTime startDate,
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

        // Thêm các phương thức mới cho thống kê bệnh nhân
        @Query("SELECT NEW map(" +
                        "EXTRACT(YEAR FROM a.appointmentDate) as year, " +
                        "EXTRACT(MONTH FROM a.appointmentDate) as month, " +
                        "COUNT(a) as appointmentCount) " +
                        "FROM Appointment a " +
                        "WHERE a.patient.patientID = :patientId " +
                        "AND a.status = 'Completed' " +
                        "GROUP BY EXTRACT(YEAR FROM a.appointmentDate), EXTRACT(MONTH FROM a.appointmentDate) " +
                        "ORDER BY year DESC, month DESC")
        List<Map<String, Object>> getPatientAppointmentsByMonthYear(@Param("patientId") Long patientId);

        @Query("SELECT NEW map(" +
                        "s.specializationName as specializationName, " +
                        "COUNT(a) as appointmentCount) " +
                        "FROM Appointment a " +
                        "JOIN a.doctor d " +
                        "JOIN d.specializations s " +
                        "WHERE a.patient.patientID = :patientId " +
                        "AND a.status = 'Completed' " +
                        "GROUP BY s.specializationID, s.specializationName " +
                        "ORDER BY appointmentCount DESC")
        List<Map<String, Object>> getPatientAppointmentsBySpecialization(@Param("patientId") Long patientId);

        @Query("SELECT COUNT(a) FROM Appointment a " +
                        "WHERE a.patient.patientID = :patientId " +
                        "AND a.status = 'Completed' " +
                        "AND EXTRACT(YEAR FROM a.appointmentDate) = :year " +
                        "AND EXTRACT(MONTH FROM a.appointmentDate) = :month")
        long countPatientAppointmentsByMonthYear(@Param("patientId") Long patientId,
                        @Param("year") int year,
                        @Param("month") int month);

        @Query("SELECT COUNT(a) FROM Appointment a " +
                        "JOIN a.doctor d " +
                        "JOIN d.specializations s " +
                        "WHERE a.patient.patientID = :patientId " +
                        "AND a.status = 'Completed' " +
                        "AND s.specializationID = :specializationId")
        long countPatientAppointmentsBySpecialization(@Param("patientId") Long patientId,
                        @Param("specializationId") Long specializationId);

        // Thêm các phương thức mới cho filter và chart
        @Query("SELECT NEW map(" +
                        "EXTRACT(YEAR FROM a.appointmentDate) as year, " +
                        "EXTRACT(MONTH FROM a.appointmentDate) as month, " +
                        "COUNT(a) as appointmentCount) " +
                        "FROM Appointment a " +
                        "WHERE a.patient.patientID = :patientId " +
                        "AND a.status = 'Completed' " +
                        "AND EXTRACT(YEAR FROM a.appointmentDate) = :year " +
                        "GROUP BY EXTRACT(YEAR FROM a.appointmentDate), EXTRACT(MONTH FROM a.appointmentDate) " +
                        "ORDER BY month")
        List<Map<String, Object>> getPatientAppointmentsByYear(@Param("patientId") Long patientId,
                        @Param("year") int year);

        @Query("SELECT NEW map(" +
                        "EXTRACT(YEAR FROM a.appointmentDate) as year, " +
                        "EXTRACT(MONTH FROM a.appointmentDate) as month, " +
                        "COUNT(a) as appointmentCount) " +
                        "FROM Appointment a " +
                        "WHERE a.patient.patientID = :patientId " +
                        "AND a.status = 'Completed' " +
                        "AND EXTRACT(YEAR FROM a.appointmentDate) = :year " +
                        "AND EXTRACT(MONTH FROM a.appointmentDate) = :month " +
                        "GROUP BY EXTRACT(YEAR FROM a.appointmentDate), EXTRACT(MONTH FROM a.appointmentDate)")
        List<Map<String, Object>> getPatientAppointmentsByYearMonth(@Param("patientId") Long patientId,
                        @Param("year") int year,
                        @Param("month") int month);

        @Query("SELECT NEW map(" +
                        "s.specializationName as specializationName, " +
                        "COUNT(a) as appointmentCount) " +
                        "FROM Appointment a " +
                        "JOIN a.doctor d " +
                        "JOIN d.specializations s " +
                        "WHERE a.patient.patientID = :patientId " +
                        "AND a.status = 'Completed' " +
                        "AND EXTRACT(YEAR FROM a.appointmentDate) = :year " +
                        "GROUP BY s.specializationID, s.specializationName " +
                        "ORDER BY appointmentCount DESC")
        List<Map<String, Object>> getPatientAppointmentsBySpecializationAndYear(@Param("patientId") Long patientId,
                        @Param("year") int year);

        @Query("SELECT NEW map(" +
                        "s.specializationName as specializationName, " +
                        "COUNT(a) as appointmentCount) " +
                        "FROM Appointment a " +
                        "JOIN a.doctor d " +
                        "JOIN d.specializations s " +
                        "WHERE a.patient.patientID = :patientId " +
                        "AND a.status = 'Completed' " +
                        "AND EXTRACT(YEAR FROM a.appointmentDate) = :year " +
                        "AND EXTRACT(MONTH FROM a.appointmentDate) = :month " +
                        "GROUP BY s.specializationID, s.specializationName " +
                        "ORDER BY appointmentCount DESC")
        List<Map<String, Object>> getPatientAppointmentsBySpecializationAndYearMonth(@Param("patientId") Long patientId,
                        @Param("year") int year,
                        @Param("month") int month);

        @Query("SELECT DISTINCT EXTRACT(YEAR FROM a.appointmentDate) as year " +
                        "FROM Appointment a " +
                        "WHERE a.patient.patientID = :patientId " +
                        "AND a.status = 'Completed' " +
                        "ORDER BY year DESC")
        List<Integer> getAvailableYearsForPatient(@Param("patientId") Long patientId);

        @Query("SELECT NEW map(" +
                        "EXTRACT(MONTH FROM a.appointmentDate) as month, " +
                        "COUNT(a) as total, " +
                        "COUNT(CASE WHEN a.status = 'Completed' THEN 1 END) as completed, " +
                        "COUNT(CASE WHEN a.status = 'Rejected' OR a.status = 'Cancelled' THEN 1 END) as cancelled " +
                        ") FROM Appointment a " +
                        "WHERE a.patient.patientID = :patientId " +
                        "AND EXTRACT(YEAR FROM a.appointmentDate) = :year " +
                        "GROUP BY EXTRACT(MONTH FROM a.appointmentDate) " +
                        "ORDER BY month")
        List<Map<String, Object>> getPatientMonthlyStatusStats(@Param("patientId") Long patientId,
                        @Param("year") int year);

        @Query("SELECT NEW map(" +
                        "EXTRACT(DAY FROM a.appointmentDate) as day, " +
                        "COUNT(a) as total, " +
                        "COUNT(CASE WHEN a.status = 'Completed' THEN 1 END) as completed, " +
                        "COUNT(CASE WHEN a.status = 'Rejected' OR a.status = 'Cancelled' THEN 1 END) as cancelled " +
                        ") FROM Appointment a " +
                        "WHERE a.patient.patientID = :patientId " +
                        "AND EXTRACT(YEAR FROM a.appointmentDate) = :year " +
                        "AND EXTRACT(MONTH FROM a.appointmentDate) = :month " +
                        "GROUP BY EXTRACT(DAY FROM a.appointmentDate) " +
                        "ORDER BY day")
        List<Map<String, Object>> getPatientDailyStatusStats(@Param("patientId") Long patientId,
                        @Param("year") int year, @Param("month") int month);

        @Query("SELECT NEW map(" +
                        "FLOOR((EXTRACT(DAY FROM a.appointmentDate) - 1) / 7) + 1 as weekInMonth, " +
                        "COUNT(a) as appointmentCount) " +
                        "FROM Appointment a " +
                        "WHERE a.patient.patientID = :patientId " +
                        "AND a.status = 'Completed' " +
                        "AND EXTRACT(YEAR FROM a.appointmentDate) = :year " +
                        "AND EXTRACT(MONTH FROM a.appointmentDate) = :month " +
                        "GROUP BY FLOOR((EXTRACT(DAY FROM a.appointmentDate) - 1) / 7) + 1 " +
                        "ORDER BY appointmentCount DESC")
        List<Map<String, Object>> getPatientAppointmentsByWeekInMonth(@Param("patientId") Long patientId,
                        @Param("year") int year,
                        @Param("month") int month);

        @Query("SELECT NEW map(EXTRACT(DAY FROM a.appointmentDate) as day, COUNT(DISTINCT a.patient.patientID) as patientCount) "
                        +
                        "FROM Appointment a WHERE a.doctor.doctorID = :doctorId AND a.status = 'Completed' " +
                        "AND EXTRACT(YEAR FROM a.appointmentDate) = :year AND EXTRACT(MONTH FROM a.appointmentDate) = :month "
                        +
                        "GROUP BY EXTRACT(DAY FROM a.appointmentDate) ORDER BY day")
        List<Map<String, Object>> getDoctorPatientCountByDay(@Param("doctorId") Long doctorId, @Param("year") int year,
                        @Param("month") int month);

        @Query("SELECT NEW map(FLOOR((EXTRACT(DAY FROM a.appointmentDate) - 1) / 7) + 1 as weekInMonth, COUNT(DISTINCT a.patient.patientID) as patientCount) "
                        +
                        "FROM Appointment a WHERE a.doctor.doctorID = :doctorId AND a.status = 'Completed' " +
                        "AND EXTRACT(YEAR FROM a.appointmentDate) = :year AND EXTRACT(MONTH FROM a.appointmentDate) = :month "
                        +
                        "GROUP BY FLOOR((EXTRACT(DAY FROM a.appointmentDate) - 1) / 7) + 1 ORDER BY weekInMonth")
        List<Map<String, Object>> getDoctorPatientCountByWeek(@Param("doctorId") Long doctorId, @Param("year") int year,
                        @Param("month") int month);

        @Query("SELECT NEW map(EXTRACT(MONTH FROM a.appointmentDate) as month, COUNT(DISTINCT a.patient.patientID) as patientCount) "
                        +
                        "FROM Appointment a WHERE a.doctor.doctorID = :doctorId AND a.status = 'Completed' " +
                        "AND EXTRACT(YEAR FROM a.appointmentDate) = :year " +
                        "GROUP BY EXTRACT(MONTH FROM a.appointmentDate) ORDER BY month")
        List<Map<String, Object>> getDoctorPatientCountByMonth(@Param("doctorId") Long doctorId,
                        @Param("year") int year);

        @Query("SELECT a FROM Appointment a WHERE a.status = 'Confirmed' AND a.appointmentDate < :date")
        List<Appointment> findByStatusAndAppointmentDateBefore(@Param("date") LocalDateTime date);
}