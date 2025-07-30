package project.springBoot.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import project.springBoot.model.MedicalRecord;
import project.springBoot.model.Patient;

@Repository
public interface MedicalRecordRepository extends JpaRepository<MedicalRecord, Long> {
    Optional<MedicalRecord> findFirstByPatientPatientIDOrderByCreatedAtDesc(Long patientId);

    MedicalRecord findByPatient(Patient patient);
}