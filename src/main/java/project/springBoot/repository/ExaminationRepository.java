package project.springBoot.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import project.springBoot.model.Examination;

public interface ExaminationRepository extends JpaRepository<Examination, Long> {
}