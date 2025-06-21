package project.springBoot.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import project.springBoot.model.Doctor;

@Repository
public interface DoctorRepository extends JpaRepository<Doctor, Long> {
    @Query("SELECT DISTINCT d FROM Doctor d LEFT JOIN d.specializations s WHERE s.specializationID = :specializationId")
    List<Doctor> findBySpecializationsSpecializationID(Long specializationId);

    @Query("SELECT d FROM Doctor d LEFT JOIN FETCH d.feedbacks WHERE d.doctorID = :id")
    Optional<Doctor> findByIdWithFeedback(Long id);

    @Query("SELECT d FROM Doctor d LEFT JOIN FETCH d.specializations WHERE d.doctorID = :id")
    Optional<Doctor> findByIdWithSpecializations(Long id);

    Doctor findByDoctorID(long doctorID);

    Optional<Doctor> findByUserUserID(long userId);

}
