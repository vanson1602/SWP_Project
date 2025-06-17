package project.springBoot.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import project.springBoot.model.Doctor;
import java.util.List;
import java.time.LocalDate;

@Repository
public interface DoctorRepository extends JpaRepository<Doctor, Long> {
        @Query("SELECT d FROM Doctor d " +
                        "JOIN d.specializations s " +
                        "JOIN d.user u " +
                        "WHERE LOWER(s.specializationName) LIKE LOWER(CONCAT('%', :specializationName, '%')) " +
                        "AND s.isActive = true " +
                        "AND u.state = true")
        List<Doctor> findBySpecializationName(@Param("specializationName") String specializationName);

        @Query("SELECT DISTINCT d FROM Doctor d " +
                        "JOIN d.schedules s " +
                        "JOIN d.user u " +
                        "WHERE s.workDate = :workDate " +
                        "AND s.status = 'Available' " +
                        "AND u.state = true")
        List<Doctor> findByWorkDate(@Param("workDate") LocalDate workDate);

        @Query("SELECT  d FROM Doctor d " +
                        "JOIN d.specializations s " +
                        "JOIN d.user u " +
                        "WHERE d.experienceYears >= 5 " +
                        "AND s.isActive = true " +
                        "AND u.state = true " +
                        "ORDER BY d.experienceYears DESC")
        List<Doctor> findFeaturedDoctors();

        @Query("SELECT d FROM Doctor d " +
                        "JOIN d.specializations s " +
                        "JOIN d.user u " +
                        "WHERE LOWER(u.firstName) LIKE LOWER(CONCAT('%', :name, '%')) " +
                        "OR LOWER(u.lastName) LIKE LOWER(CONCAT('%', :name, '%')) " +
                        "AND s.isActive = true " +
                        "AND u.state = true")
        List<Doctor> findByName(@Param("name") String name);

}
