package project.springBoot.service;

import java.util.List;

import project.springBoot.model.Patient;
import project.springBoot.model.PatientComorbidity;

public interface PatientComorbidityService {
    List<PatientComorbidity> getComorbidities(Patient patient);

    PatientComorbidity save(PatientComorbidity comorbidity);

    void delete(Long id);
}