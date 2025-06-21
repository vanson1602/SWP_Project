package project.springBoot.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import project.springBoot.model.Patient;
import project.springBoot.repository.PatientRepository;
import project.springBoot.service.PatientService;

import java.util.Optional;

@Service
@Transactional
@RequiredArgsConstructor
public class PatientServiceImpl implements PatientService {
    private final PatientRepository patientRepository;

    @Override
    public Patient getPatientByUsername(String username) {
        return patientRepository.findByUserUsername(username)
                .orElseThrow(() -> new RuntimeException("Patient not found"));
    }

    @Override
    public Optional<Patient> findById(Long id) {
        return patientRepository.findById(id);
    }

    @Override
    public Patient save(Patient patient) {
        return patientRepository.save(patient);
    }

    @Override
    public void delete(Long id) {
        patientRepository.deleteById(id);
    }
}