package project.springBoot.service;

import project.springBoot.model.Patient;
import java.util.Optional;

public interface PatientService {
    Patient getPatientByUsername(String username);

    Optional<Patient> findById(Long id);

    Patient save(Patient patient);

    void delete(Long id);
}