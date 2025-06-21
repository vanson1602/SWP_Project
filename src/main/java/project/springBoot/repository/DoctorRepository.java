package project.springBoot.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import project.springBoot.model.Doctor;

import java.util.List;
import java.util.Optional;

@Repository
public interface DoctorRepository extends JpaRepository<Doctor, Long> {
    @Query("SELECT DISTINCT d FROM Doctor d LEFT JOIN d.specializations s WHERE s.specializationID = :specializationId")
    List<Doctor> findBySpecializationsSpecializationID(Long specializationId);

    @Query("SELECT d FROM Doctor d LEFT JOIN FETCH d.feedbacks WHERE d.doctorID = :id")
    Optional<Doctor> findByIdWithFeedback(Long id);

    @Query("SELECT d FROM Doctor d LEFT JOIN FETCH d.specializations WHERE d.doctorID = :id")
    Optional<Doctor> findByIdWithSpecializations(Long id);
}
