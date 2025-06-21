package project.springBoot.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import project.springBoot.model.Examination;
import project.springBoot.repository.ExaminationRepository;

@Service
public class ExaminationService {

    @Autowired
    private ExaminationRepository examinationRepository;

    public Examination saveExamination(Examination examination) {
        return examinationRepository.save(examination);
    }

    public Examination getExaminationById(Long id) {
        return examinationRepository.findById(id).orElse(null);
    }
}