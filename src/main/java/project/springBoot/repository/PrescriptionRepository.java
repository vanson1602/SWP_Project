package project.springBoot.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import project.springBoot.model.Prescription;

@Repository
public interface PrescriptionRepository extends JpaRepository<Prescription, Long> {
    List<Prescription> findByExaminationExaminationID(Long examinationId);
    List<Prescription> findByExaminationMedicalRecordPatientPatientID(Long patientId);
    List<Prescription> findByPrescribedByDoctorID(Long doctorId);
    List<Prescription> findByStatus(String status);
    long countByExaminationExaminationID(Long examinationId);
    Optional<Prescription> findFirstByExaminationExaminationID(Long examinationId);

}