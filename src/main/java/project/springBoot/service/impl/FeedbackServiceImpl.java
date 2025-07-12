package project.springBoot.service.impl;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import project.springBoot.model.Feedback;
import project.springBoot.repository.FeedbackRepository;
import project.springBoot.service.FeedbackService;

@Service
@RequiredArgsConstructor
public class FeedbackServiceImpl implements FeedbackService {
    private final FeedbackRepository feedbackRepo;

    @Override
    public void saveFeedback(Feedback feedback) {
        feedbackRepo.save(feedback);
    }

    @Override
    public boolean hasFeedback(long examinationID) {
        return feedbackRepo.existsByExamination_ExaminationID(examinationID);
    }

    @Override
    public Feedback getFeedbackById(long feedbackId) {
        return feedbackRepo.findById(feedbackId).orElse(null);
    }

    @Override
    public void deleteFeedback(long feedbackId) {
        feedbackRepo.deleteById(feedbackId);
    }

    @Override
    public List<Feedback> getAllFeedbacks() {
        return feedbackRepo.findAll();
    }

    @Override
    public List<Feedback> getFeedbacksByDoctorId(Long doctorId) {
        return feedbackRepo.findByDoctorId(doctorId);
    }

    @Override
    @Transactional
    public void approveFeedback(Long id) {
        Feedback feedback = feedbackRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Feedback không tồn tại"));

        feedback.setIsApproved(true);
        feedback.setModifiedAt(LocalDateTime.now());

        feedbackRepo.save(feedback);
    }

    @Override
    public Page<Feedback> searchFeedbacksForAdmin(String doctorName, Integer rating, int page, int size) {
        Pageable pageable = PageRequest.of(page - 1, size);
        return feedbackRepo.findByAdminFilters(doctorName, rating, pageable);
    }

    @Override
    public Page<Feedback> searchFeedbacksForDoctor(Long doctorId, Integer rating, int page, int size) {
        Pageable pageable = PageRequest.of(page - 1, size);
        return feedbackRepo.findByDoctorFilters(doctorId, rating, pageable);
    }

}
