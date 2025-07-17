package project.springBoot.service.impl;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Objects;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import project.springBoot.model.Medication;
import project.springBoot.repository.MedicationRepository;
import project.springBoot.service.MedicationService;

@Service
@Transactional
public class MedicationServiceImpl implements MedicationService {

    @Autowired
    private MedicationRepository medicationRepository;

    @Override
    public Medication findByMedicationID(Long medicationID) {
        return medicationRepository.findByMedicationID(medicationID);
    }
}