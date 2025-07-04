package project.springBoot.repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import project.springBoot.model.Doctor;
import project.springBoot.model.DoctorSchedule;

@Repository
public interface DoctorScheduleRepository extends JpaRepository<DoctorSchedule, Long> {
        List<DoctorSchedule> findByDoctorAndWorkDateBetweenOrderByWorkDateAsc(
                        Doctor doctor,
                        LocalDate startDate,
                        LocalDate endDate);

        @Query("SELECT DISTINCT ds.doctor FROM DoctorSchedule ds " +
                        "WHERE ds.workDate = :date AND ds.status = 'Available'")
        List<Doctor> findAvailableDoctorsForDate(@Param("date") LocalDate date);

        List<DoctorSchedule> findByDoctorDoctorID(long doctorId);

        List<DoctorSchedule> findByDoctorDoctorIDOrderByWorkDateAscStartTimeAsc(Long doctorId);

        List<DoctorSchedule> findByStatus(String status);

        @Query("SELECT ds FROM DoctorSchedule ds WHERE ds.doctor.doctorID = :doctorId AND ds.status = :status")
        List<DoctorSchedule> findByDoctorIdAndStatus(@Param("doctorId") Long doctorId, @Param("status") String status);

        @Query("SELECT ds FROM DoctorSchedule ds LEFT JOIN FETCH ds.bookingSlots WHERE ds.scheduleID = :scheduleId")
        Optional<DoctorSchedule> findByIdWithSlots(@Param("scheduleId") Long scheduleId);
}