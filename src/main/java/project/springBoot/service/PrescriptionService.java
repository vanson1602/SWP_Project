package project.springBoot.service;

import java.util.List;
import java.util.Optional;

import project.springBoot.model.Prescription;

public interface PrescriptionService {

    Prescription findById(Long id);

    Prescription savePrescription(Prescription prescription);

    void deletePrescription(Long prescriptionId);

    void completePrescriptions(List<Long> prescriptionIds);

    List<Prescription> findByPatientId(Long patientId);

    List<Prescription> findByDoctorId(Long doctorId);

    List<Prescription> findByStatus(String status);

    List<Prescription> findPendingPrescriptions();

    List<Prescription> findCompletedPrescriptions();

    boolean existsById(Long id);

    long countByExaminationId(Long examinationId);

    Prescription getPrescriptionByExaminationId(Long examinationId);

    List<Prescription> getAllPrescriptionsByExaminationId(Long examinationId);

    List<Prescription> findByExaminationId(Long examinationId);
}