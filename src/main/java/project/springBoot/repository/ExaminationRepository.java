package project.springBoot.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import project.springBoot.model.Examination;

public interface ExaminationRepository extends JpaRepository<Examination, Long> {
    Examination findTopByMedicalRecordPatientPatientIDOrderByExaminationDateDesc(Long patientId);

    @Query("SELECT e FROM Examination e " +
            "LEFT JOIN FETCH e.medicalRecord mr " +
            "LEFT JOIN FETCH mr.patient p " +
            "LEFT JOIN FETCH e.appointment a " +
            "WHERE p.patientID = :patientId " +
            "AND e.chiefComplaint IS NOT NULL " + // Ensure basic examination info exists
            "ORDER BY e.examinationDate DESC")
    List<Examination> findAllValidExaminations(@Param("patientId") Long patientId);

    @Query("SELECT e FROM Examination e " +
            "LEFT JOIN FETCH e.medicalRecord mr " +
            "LEFT JOIN FETCH mr.patient p " +
            "LEFT JOIN FETCH e.appointment a " +
            "WHERE p.patientID = :patientId " +
            "ORDER BY e.examinationDate DESC")
    List<Examination> findAllExaminations(@Param("patientId") Long patientId);

    default Examination findLatestValidExamination(Long patientId) {
        List<Examination> examinations = findAllValidExaminations(patientId);
        return examinations.isEmpty() ? null : examinations.get(0);
    }

    default Examination findLatestExamination(Long patientId) {
        List<Examination> examinations = findAllExaminations(patientId);
        return examinations.isEmpty() ? null : examinations.get(0);
    }

    Examination findByAppointmentAppointmentID(Long appointmentId);
}
