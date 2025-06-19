package project.springBoot.repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

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
                        "LEFT JOIN FETCH a.bookingSlots bs " +
                        "LEFT JOIN FETCH bs.schedule s " +
                        "LEFT JOIN FETCH a.doctor d " +
                        "LEFT JOIN FETCH d.user du " +
                        "LEFT JOIN FETCH d.specializations " +
                        "WHERE a.appointmentID = :id")
        Optional<Appointment> findByIdWithDetails(@Param("id") Long id);
        List<Appointment> findByDoctorDoctorID(long doctorId);
}