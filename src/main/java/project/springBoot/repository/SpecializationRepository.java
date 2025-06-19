package project.springBoot.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import project.springBoot.model.Specialization;

@Repository
public interface SpecializationRepository extends JpaRepository<Specialization, Long> {
    List<Specialization> findByIsActive(boolean isActive);

    List<Specialization> findBySpecializationNameAndIsActive(String specializationName, boolean isActive);
}
