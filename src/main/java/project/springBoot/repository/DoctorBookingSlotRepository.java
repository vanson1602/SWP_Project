package project.springBoot.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import project.springBoot.model.DoctorBookingSlot;
import project.springBoot.model.DoctorSchedule;

import java.time.LocalDateTime;
import java.util.List;

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
}