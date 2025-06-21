package project.springBoot.service;

import project.springBoot.model.Specialization;
import java.util.List;

public interface SpecializationService {
    List<Specialization> getAllActiveSpecializations();

    Specialization getSpecializationById(Long id);
}