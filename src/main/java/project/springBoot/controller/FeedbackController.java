package project.springBoot.controller;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import project.springBoot.model.Examination;
import project.springBoot.model.Feedback;
import project.springBoot.model.User;
import project.springBoot.repository.ExaminationRepository;
import project.springBoot.service.DoctorService;
import project.springBoot.service.FeedbackService;

@Controller
@RequestMapping("/feedback")
@RequiredArgsConstructor
public class FeedbackController {
    private final FeedbackService feedbackService;
    private final ExaminationRepository examinationRepo;
    private final DoctorService doctorService;

    @GetMapping("/new")
    public String showFeedbackForm(@RequestParam("examinationId") long examinationId, Model model) {
        Feedback feedback = new Feedback();
        Examination exam = examinationRepo.findById(examinationId).orElseThrow();
        feedback.setExamination(exam);
        feedback.setDoctor(exam.getDoctor());
        feedback.setPatient(exam.getAppointment().getPatient());
        model.addAttribute("feedback", feedback);
        return "feedback/feedback_form";
    }

    @PostMapping("/submit")
    public String submitFeedback(@ModelAttribute Feedback feedback, RedirectAttributes redirectAttributes) {
        feedback.setApproved(false);
        feedback.setCreatedAt(LocalDateTime.now());
        feedback.setModifiedAt(LocalDateTime.now());
        feedbackService.saveFeedback(feedback);
        redirectAttributes.addFlashAttribute("success", "Feedback đã gửi thành công!");
        return "redirect:/appointments/my-appointments";
    }

    @GetMapping("/edit")
    public String editFeedback(@RequestParam("feedbackId") long feedbackId, Model model) {
        Feedback feedback = feedbackService.getFeedbackById(feedbackId);
        if (feedback == null) {
            throw new RuntimeException("Feedback không tồn tại");
        }
        model.addAttribute("feedback", feedback);
        return "feedback/feedback_edit_form"; // JSP mới
    }

    @PostMapping("/update")
    public String updateFeedback(@ModelAttribute Feedback feedback, RedirectAttributes redirectAttributes) {
        Feedback existing = feedbackService.getFeedbackById(feedback.getFeedbackID());
        if (existing == null) {
            throw new RuntimeException("Feedback không tồn tại");
        }

        existing.setRating(feedback.getRating());
        existing.setServiceRating(feedback.getServiceRating());
        existing.setCleanlinessRating(feedback.getCleanlinessRating());
        existing.setComment(feedback.getComment());
        existing.setAnonymous(feedback.isAnonymous());
        existing.setModifiedAt(LocalDateTime.now());
        existing.setApproved(false);

        feedbackService.saveFeedback(existing);
        redirectAttributes.addFlashAttribute("success", "Cập nhật Feedback thành công!");
        return "redirect:/appointments/my-appointments";
    }

    @PostMapping("/delete")
    public String deleteFeedback(@RequestParam("feedbackId") long feedbackId, RedirectAttributes redirectAttributes) {
        feedbackService.deleteFeedback(feedbackId);
        redirectAttributes.addFlashAttribute("success", "Đã xóa Feedback thành công!");
        return "redirect:/appointments/my-appointments";
    }

    @GetMapping("/list")
    public String listFeedbacks(
            @RequestParam(value = "doctorName", required = false) String doctorName,
            @RequestParam(value = "rating", required = false) Integer rating,
            @RequestParam(value = "page", defaultValue = "1") int page,
            Model model,
            HttpSession session) {

        User user = (User) session.getAttribute("currentUser");
        model.addAttribute("role", user.getRole());
        int pageSize = 10;

        Page<Feedback> feedbackPage;

        if (user.getRole().equals("admin")) {
            feedbackPage = feedbackService.searchFeedbacksForAdmin(doctorName, rating, page, pageSize);
        } else if (user.getRole().equals("doctor")) {
            Long doctorId = doctorService.getDoctorByUserId(user.getUserID()).getDoctorID();
            feedbackPage = feedbackService.searchFeedbacksForDoctor(doctorId, rating, page, pageSize);
        } else {
            feedbackPage = Page.empty(); // Không có quyền
        }

        model.addAttribute("feedbacks", feedbackPage.getContent());
        model.addAttribute("totalPages", feedbackPage.getTotalPages());
        model.addAttribute("currentPage", page);
        model.addAttribute("doctorName", doctorName);
        model.addAttribute("rating", rating);

        return "feedback/feedback-list";
    }

    @GetMapping("/{id}/reply")
    public String showReplyForm(@PathVariable("id") Long feedbackId, Model model, HttpSession session) {
        Feedback feedback = feedbackService.getFeedbackById(feedbackId);
        User user = (User) session.getAttribute("currentUser");

        if (user.getRole().equals("admin") ||
                (user.getRole().equals("doctor") && feedback.getDoctor().getUser().getUserID() == user.getUserID())) {
            model.addAttribute("feedback", feedback);
            return "feedback/feedback-reply-form";
        }
        return "redirect:/feedback?error=Unauthorized";
    }

    @PostMapping("/{id}/reply")
    public String submitReply(@PathVariable("id") Long feedbackId,
            @RequestParam("response") String response,
            HttpSession session) {
        Feedback feedback = feedbackService.getFeedbackById(feedbackId);
        User user = (User) session.getAttribute("currentUser");

        if (user.getRole().equals("admin") ||
                (user.getRole().equals("doctor") && feedback.getDoctor().getUser().getUserID() == user.getUserID())) {
            feedback.setResponse(response);
            feedbackService.saveFeedback(feedback);
            return "redirect:/feedback/list";
        }
        return "redirect:/feedback/{id}/reply";
    }

    @PostMapping("/{id}/approve")
    public String approve(@PathVariable("id") Long feedbackId,
            RedirectAttributes redirectAttributes) {
        feedbackService.approveFeedback(feedbackId);
        redirectAttributes.addFlashAttribute("success", "Feedback đã được duyệt!");
        return "redirect:/feedback/list";
    }

}
