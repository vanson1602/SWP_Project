package project.springBoot.service;

import java.util.List;

import project.springBoot.model.Prescription;

public interface PrescriptionService {
    List<Prescription> findByExaminationId(Long examinationId);
    Prescription findById(Long id);
    Prescription savePrescription(Prescription prescription);
    void deletePrescription(Long prescriptionId);
    void completePrescriptions(List<Long> prescriptionIds);
    
    // Thêm các method mới
    List<Prescription> findByPatientId(Long patientId);
    List<Prescription> findByDoctorId(Long doctorId);
    List<Prescription> findByStatus(String status);
    List<Prescription> findPendingPrescriptions();
    List<Prescription> findCompletedPrescriptions();
    boolean existsById(Long id);
    long countByExaminationId(Long examinationId);
}