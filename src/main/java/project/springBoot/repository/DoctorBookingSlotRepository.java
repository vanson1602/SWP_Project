package project.springBoot.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import project.springBoot.model.DoctorBookingSlot;
import project.springBoot.model.DoctorSchedule;

@Repository
public interface DoctorBookingSlotRepository extends JpaRepository<DoctorBookingSlot, Long> {
        List<DoctorBookingSlot> findByScheduleAndStatusAndStartTimeGreaterThanOrderByStartTimeAsc(
                        DoctorSchedule schedule,
                        String status,
                        LocalDateTime startTime);

        @Query("SELECT bs FROM DoctorBookingSlot bs " +
                        "WHERE bs.schedule.doctor.doctorID = :doctorId " +
                        "AND bs.startTime BETWEEN :startTime AND :endTime " +
                        "AND bs.status = 'Available' " +
                        "ORDER BY bs.startTime")
        List<DoctorBookingSlot> findAvailableSlotsByDoctorAndTimeRange(
                        @Param("doctorId") Long doctorId,
                        @Param("startTime") LocalDateTime startTime,
                        @Param("endTime") LocalDateTime endTime);

        @Query("SELECT bs FROM DoctorBookingSlot bs " +
               "WHERE bs.schedule.doctor.doctorID = :doctorId " +
               "AND bs.status = 'Available' " +
               "ORDER BY bs.startTime")
        List<DoctorBookingSlot> findByScheduleDoctorDoctorIDAndNotCompleted(
               @Param("doctorId") Long doctorId);

        @Query("SELECT DISTINCT bs FROM DoctorBookingSlot bs " +
               "LEFT JOIN FETCH bs.schedule s " +
               "LEFT JOIN FETCH s.doctor d " +
               "LEFT JOIN FETCH bs.appointment a " +
               "LEFT JOIN FETCH a.patient p " +
               "LEFT JOIN FETCH p.user pu " +
               "LEFT JOIN FETCH a.appointmentType at " +
               "WHERE bs.schedule.doctor.doctorID = :doctorId " +
               "AND bs.startTime BETWEEN :startTime AND :endTime " +
               "ORDER BY bs.startTime")
        List<DoctorBookingSlot> findByScheduleDoctorDoctorIDAndDateRange(
               @Param("doctorId") Long doctorId,
               @Param("startTime") LocalDateTime startTime,
               @Param("endTime") LocalDateTime endTime);
}