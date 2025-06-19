package project.springBoot.service;

import java.time.LocalDate;
import java.util.List;

import project.springBoot.model.Medication;

public interface MedicationService {

    List<Medication> getAllMedications();

    Medication findById(Long id);

    Medication save(Medication medication);

    void deleteById(Long id);

    List<Medication> findByNameContaining(String name);

    void updateStock(Long id, int quantity);

    List<Medication> findLowStockMedications(int threshold);

    List<Medication> findExpiringMedications(LocalDate date);
}