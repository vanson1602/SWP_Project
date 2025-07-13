package project.springBoot.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import project.springBoot.model.ICDCode;

@Repository
public interface ICDCodeRepository extends JpaRepository<ICDCode, String> {
    // The primary key type is String because icdCode is the ID field in ICDCode entity
} 