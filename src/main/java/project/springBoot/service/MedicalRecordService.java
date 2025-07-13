package project.springBoot.service;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import project.springBoot.model.MedicalRecord;
import project.springBoot.model.Patient;
import project.springBoot.repository.MedicalRecordRepository;

@Service
public class MedicalRecordService {
    
    @Autowired
    private MedicalRecordRepository medicalRecordRepository;

    public MedicalRecord findById(Long id) {
        return medicalRecordRepository.findById(id).orElse(null);
    }

    public MedicalRecord getOrCreateMedicalRecord(Patient patient) {
        MedicalRecord record = medicalRecordRepository.findByPatient(patient);
        if (record == null) {
            record = new MedicalRecord();
            record.setPatient(patient);
            record.setCreatedAt(LocalDateTime.now());
            record.setModifiedAt(LocalDateTime.now());
            record = medicalRecordRepository.save(record);
        }
        return record;
    }

    public MedicalRecord save(MedicalRecord medicalRecord) {
        return medicalRecordRepository.save(medicalRecord);
    }
}