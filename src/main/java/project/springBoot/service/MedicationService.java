package project.springBoot.service;

import java.time.LocalDate;
import java.util.List;

import project.springBoot.model.Medication;

public interface MedicationService {

    Medication findByMedicationID(Long medicationID);
}