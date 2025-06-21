package project.springBoot.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import project.springBoot.model.Specialization;
import project.springBoot.repository.SpecializationRepository;
import project.springBoot.service.SpecializationService;

import java.util.List;

@Service
@RequiredArgsConstructor
public class SpecializationServiceImpl implements SpecializationService {
    private final SpecializationRepository specializationRepository;

    @Override
    public List<Specialization> getAllActiveSpecializations() {
        return specializationRepository.findByIsActive(true);
    }

    @Override
    public Specialization getSpecializationById(Long id) {
        return specializationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Specialization not found"));
    }
}