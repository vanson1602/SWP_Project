
package project.springBoot.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import project.springBoot.model.Medication;

@Repository
public interface MedicationRepository extends JpaRepository<Medication, Long> {

    Medication findByMedicationID(Long medicationID);
}