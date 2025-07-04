
package project.springBoot.repository;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import project.springBoot.model.Medication;

@Repository
public interface MedicationRepository extends JpaRepository<Medication, Long> {
    List<Medication> findByMedicationNameContainingIgnoreCase(String name);
    List<Medication> findByStockQuantityLessThanEqual(int threshold);
    List<Medication> findByExpiryDateBefore(LocalDate date);
}