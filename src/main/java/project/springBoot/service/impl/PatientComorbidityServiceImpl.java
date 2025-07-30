package project.springBoot.service.impl;

import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import project.springBoot.model.MedicalRecord;
import project.springBoot.model.Patient;
import project.springBoot.model.PatientComorbidity;
import project.springBoot.repository.PatientComorbidityRepository;
import project.springBoot.service.MedicalRecordService;
import project.springBoot.service.PatientComorbidityService;

@Service
public class PatientComorbidityServiceImpl implements PatientComorbidityService {

    @Autowired
    private PatientComorbidityRepository patientComorbidityRepository;

    @Autowired
    private MedicalRecordService medicalRecordService;

    @Override
    public List<PatientComorbidity> getComorbidities(Patient patient) {
        MedicalRecord medicalRecord = medicalRecordService.getOrCreateMedicalRecord(patient);
        if (medicalRecord != null && medicalRecord.getComorbidities() != null) {
            return medicalRecord.getComorbidities();
        }
        return Collections.emptyList();
    }

    @Override
    public PatientComorbidity save(PatientComorbidity comorbidity) {
        return patientComorbidityRepository.save(comorbidity);
    }

    @Override
    public void delete(Long id) {
        patientComorbidityRepository.deleteById(id);
    }
}