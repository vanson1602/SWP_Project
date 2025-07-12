package project.springBoot.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import project.springBoot.model.Appointment;
import project.springBoot.model.Patient;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

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

        @Query("SELECT a FROM Appointment a " +
                        "LEFT JOIN FETCH a.patient p " +
                        "LEFT JOIN FETCH p.user pu " +
                        "LEFT JOIN FETCH a.bookingSlot bs " +
                        "LEFT JOIN FETCH bs.schedule s " +
                        "LEFT JOIN FETCH s.doctor d " +
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