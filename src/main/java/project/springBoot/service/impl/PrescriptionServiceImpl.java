package project.springBoot.service.impl;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import project.springBoot.model.Prescription;
import project.springBoot.repository.PrescriptionRepository;
import project.springBoot.service.AppointmentService;
import project.springBoot.service.PrescriptionService;

@Service
@Transactional
public class PrescriptionServiceImpl implements PrescriptionService {

    @Autowired
    private PrescriptionRepository prescriptionRepository;
    
    @Autowired
    private AppointmentService appointmentService;

    @Override
    @Transactional(readOnly = true)
    public List<Prescription> findByExaminationId(Long examinationId) {
        if (Objects.isNull(examinationId)) {
            throw new IllegalArgumentException("ID khám bệnh không được để trống");
        }
        return prescriptionRepository.findByExaminationExaminationID(examinationId);
    }

    @Override
    @Transactional(readOnly = true)
    public Prescription findById(Long id) {
        if (Objects.isNull(id)) {
            throw new IllegalArgumentException("ID đơn thuốc không được để trống");
        }
        return prescriptionRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy đơn thuốc với ID: " + id));
    }

    @Override
    public Prescription savePrescription(Prescription prescription) {
        if (prescription == null) {
            throw new IllegalArgumentException("Đơn thuốc không được để trống");
        }
        return prescriptionRepository.save(prescription);
    }

    @Override
    public void deletePrescription(Long prescriptionId) {
        if (prescriptionId == null) {
            throw new IllegalArgumentException("ID đơn thuốc không được để trống");
        }
        
        if (!prescriptionRepository.existsById(prescriptionId)) {
            throw new IllegalArgumentException("Không tìm thấy đơn thuốc với ID: " + prescriptionId);
        }
        
        prescriptionRepository.deleteById(prescriptionId);
    }

    @Override
    public void completePrescriptions(List<Long> prescriptionIds) {
        if (prescriptionIds == null || prescriptionIds.isEmpty()) {
            throw new IllegalArgumentException("Danh sách đơn thuốc không được để trống");
        }

        List<Prescription> prescriptions = prescriptionRepository.findAllById(prescriptionIds);
        
        if (prescriptions.size() != prescriptionIds.size()) {
            throw new IllegalArgumentException("Một số đơn thuốc không tồn tại");
        }

        for (Prescription prescription : prescriptions) {
            prescription.setStatus("COMPLETED");
            prescription.setModifiedAt(LocalDateTime.now());
            prescription.setCompletedAt(LocalDateTime.now());
        }

        prescriptionRepository.saveAll(prescriptions);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Prescription> findByPatientId(Long patientId) {
        if (Objects.isNull(patientId)) {
            throw new IllegalArgumentException("ID bệnh nhân không được để trống");
        }
        return prescriptionRepository.findByExaminationMedicalRecordPatientPatientID(patientId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Prescription> findByDoctorId(Long doctorId) {
        if (Objects.isNull(doctorId)) {
            throw new IllegalArgumentException("ID bác sĩ không được để trống");
        }
        return prescriptionRepository.findByPrescribedByDoctorID(doctorId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Prescription> findByStatus(String status) {
        if (Objects.isNull(status) || status.trim().isEmpty()) {
            throw new IllegalArgumentException("Trạng thái không được để trống");
        }
        return prescriptionRepository.findByStatus(status.trim().toUpperCase());
    }

    @Override
    @Transactional(readOnly = true)
    public List<Prescription> findPendingPrescriptions() {
        return prescriptionRepository.findByStatus("PENDING");
    }

    @Override
    @Transactional(readOnly = true)
    public List<Prescription> findCompletedPrescriptions() {
        return prescriptionRepository.findByStatus("COMPLETED");
    }

    @Override
    @Transactional(readOnly = true)
    public boolean existsById(Long id) {
        if (Objects.isNull(id)) {
            throw new IllegalArgumentException("ID đơn thuốc không được để trống");
        }
        return prescriptionRepository.existsById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public long countByExaminationId(Long examinationId) {
        if (Objects.isNull(examinationId)) {
            throw new IllegalArgumentException("ID khám bệnh không được để trống");
        }
        return prescriptionRepository.countByExaminationExaminationID(examinationId);
    }
} 