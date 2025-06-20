package project.springBoot.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import project.springBoot.model.AppointmentType;

import java.util.List;

@Repository
public interface AppointmentTypeRepository extends JpaRepository<AppointmentType, Long> {
    List<AppointmentType> findByIsActiveOrderByTypeNameAsc(boolean isActive);

    List<AppointmentType> findByTypeNameContainingAndIsActive(String typeName, boolean isActive);

    boolean existsByTypeNameAndIsActive(String typeName, boolean isActive);
}