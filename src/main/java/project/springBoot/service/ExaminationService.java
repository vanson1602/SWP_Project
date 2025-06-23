package project.springBoot.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import project.springBoot.model.Examination;
import project.springBoot.repository.ExaminationRepository;

@Service
public class ExaminationService {
    private static final Logger logger = LoggerFactory.getLogger(ExaminationService.class);

    @Autowired
    private ExaminationRepository examinationRepository;

    public Examination saveExamination(Examination examination) {
        return examinationRepository.save(examination);
    }

    public Examination getExaminationById(Long id) {
        return examinationRepository.findById(id).orElse(null);
    }

    public Examination getLatestExaminationByPatientId(Long patientId) {
        logger.debug("Fetching latest examination for patient ID: {}", patientId);
        
        // First try to get a valid (completed) examination
        Examination examination = examinationRepository.findLatestValidExamination(patientId);
        if (examination != null) {
            logger.debug("Found valid examination ID: {} with status: {} and appointment status: {}", 
                examination.getExaminationID(), 
                examination.getStatus(),
                examination.getAppointment().getStatus());
            return examination;
        } else {
            logger.debug("No valid (completed) examination found for patient ID: {}", patientId);
        }
        
        // If no valid examination found, try to get any examination
        examination = examinationRepository.findLatestExamination(patientId);
        if (examination != null) {
            logger.info("Found examination ID: {} but it's not valid. Status details:", examination.getExaminationID());
            logger.info("- Examination status: {}", examination.getStatus());
            logger.info("- Appointment status: {}", examination.getAppointment().getStatus());
            logger.info("- Examination date: {}", examination.getExaminationDate());
            logger.info("- Doctor: {}", examination.getDoctor().getUser().getFullName());
            logger.info("This examination will not be shown to the patient until both statuses are 'Completed'");
            return examination;
        } else {
            logger.warn("No examination found at all for patient ID: {}", patientId);
            // Try to find all examinations without status filter
            var allExams = examinationRepository.findAllExaminations(patientId);
            logger.info("Total examinations found (including non-completed): {}", allExams.size());
            if (!allExams.isEmpty()) {
                for (var exam : allExams) {
                    logger.info("Examination ID: {}, Status: {}, Appointment Status: {}, Date: {}", 
                        exam.getExaminationID(),
                        exam.getStatus(),
                        exam.getAppointment().getStatus(),
                        exam.getExaminationDate());
                }
            }
        }
        return null;
    }
}