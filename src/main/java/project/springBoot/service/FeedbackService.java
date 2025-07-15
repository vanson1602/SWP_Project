package project.springBoot.service;

import java.util.List;

import org.springframework.data.domain.Page;

import project.springBoot.model.Feedback;

public interface FeedbackService {
    void saveFeedback(Feedback feedback);

    boolean hasFeedback(long examinationID);

    Feedback getFeedbackById(long feedbackId);

    void deleteFeedback(long feedbackId);

    List<Feedback> getAllFeedbacks();

    List<Feedback> getFeedbacksByDoctorId(Long doctorId);

    void approveFeedback(Long id);

    Page<Feedback> searchFeedbacksForAdmin(String doctorName, Integer rating, int page, int size);

    Page<Feedback> searchFeedbacksForDoctor(Long doctorId, Integer rating, int page, int size);
}
