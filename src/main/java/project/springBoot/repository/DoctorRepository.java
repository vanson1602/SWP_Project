package project.springBoot.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import project.springBoot.model.Doctor;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Repository
public interface DoctorRepository extends JpaRepository<Doctor, Long> {
        @Query("SELECT DISTINCT d FROM Doctor d LEFT JOIN d.specializations s WHERE s.specializationID = :specializationId")
        List<Doctor> findBySpecializationsSpecializationID(Long specializationId);

        @Query("SELECT d FROM Doctor d LEFT JOIN FETCH d.feedbacks WHERE d.doctorID = :id")
        Optional<Doctor> findByIdWithFeedback(Long id);

        @Query("SELECT d FROM Doctor d LEFT JOIN FETCH d.specializations WHERE d.doctorID = :id")
        Optional<Doctor> findByIdWithSpecializations(Long id);

        @Query("SELECT d FROM Doctor d " +
                        "JOIN d.specializations s " +
                        "JOIN d.user u " +
                        "WHERE LOWER(s.specializationName) LIKE LOWER(CONCAT('%', :specializationName, '%')) " +
                        "AND s.isActive = true " +
                        "AND u.state = true")
        List<Doctor> findBySpecializationName(@Param("specializationName") String specializationName);

        @Query("SELECT DISTINCT d FROM Doctor d " +
                        "JOIN FETCH d.user u " +
                        "JOIN FETCH d.specializations s " +
                        "WHERE s.isActive = true " +
                        "AND u.state = true")
        Page<Doctor> findAllActiveDoctors(Pageable pageable);

        @Query("SELECT d FROM Doctor d " +
                        "JOIN d.specializations s " +
                        "JOIN d.user u " +
                        "WHERE LOWER(u.firstName) LIKE LOWER(CONCAT('%', :name, '%')) " +
                        "OR LOWER(u.lastName) LIKE LOWER(CONCAT('%', :name, '%')) " +
                        "AND s.isActive = true " +
                        "AND u.state = true")
        List<Doctor> findByName(@Param("name") String name);

        Doctor save(Doctor doctor);

        List<Doctor> findAll();

        @Query("""
                            SELECT DISTINCT d FROM Doctor d
                            JOIN d.user u
                            JOIN d.specializations s
                            WHERE
                                (:keyword IS NULL OR
                                    (LOWER(CONCAT(u.firstName, ' ', u.lastName)) LIKE LOWER(CONCAT('%', :keyword, '%'))
                                    OR LOWER(s.specializationName) LIKE LOWER(CONCAT('%', :keyword, '%')))
                                )
                            AND (:specializationNames IS NULL OR s.specializationName IN :specializationNames)
                            AND (:experienceYears IS NULL OR d.experienceYears >= :experienceYears)
                            AND (:consultationFee IS NULL OR d.consultationFee <= :consultationFee)
                            AND s.isActive = true
                            AND u.state = true
                        """)
        List<Doctor> findDoctorsAdvanced(
                        @Param("keyword") String keyword,
                        @Param("specializationNames") Set<String> specializationNames,
                        @Param("experienceYears") Integer experienceYears,
                        @Param("consultationFee") BigDecimal consultationFee);

        @Query("SELECT d FROM Doctor d WHERE d.user.userID = :userId")
        Optional<Doctor> findByUserId(@Param("userId") long userId);

        @Query("SELECT d FROM Doctor d WHERE d.doctorID = :doctorId")
        Doctor findByIdDoctor(@Param("doctorId") long doctorId);

}
