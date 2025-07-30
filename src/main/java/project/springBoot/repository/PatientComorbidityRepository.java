package project.springBoot.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import project.springBoot.model.MedicalRecord;
import project.springBoot.model.PatientComorbidity;

@Repository
public interface PatientComorbidityRepository extends JpaRepository<PatientComorbidity, Long> {
    List<PatientComorbidity> findByMedicalRecord(MedicalRecord medicalRecord);
}