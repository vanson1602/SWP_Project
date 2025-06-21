package project.springBoot.repository;

import project.springBoot.model.Doctor;
import project.springBoot.model.DoctorSchedule;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface DoctorScheduleRepository extends JpaRepository<DoctorSchedule, Long> {
    List<DoctorSchedule> findByDoctorDoctorID(Long doctorID);

    List<DoctorSchedule> findByDoctorAndWorkDateBetweenOrderByWorkDateAsc(
            Doctor doctor,
            LocalDate startDate,
            LocalDate endDate);

    @Query("SELECT DISTINCT ds.doctor FROM DoctorSchedule ds " +
            "WHERE ds.workDate = :date AND ds.status = 'Available'")
    List<Doctor> findAvailableDoctorsForDate(@Param("date") LocalDate date);

}
