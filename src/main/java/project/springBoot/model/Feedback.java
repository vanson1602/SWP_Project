package project.springBoot.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@Table(name = "tblFeedback")
@NoArgsConstructor
@AllArgsConstructor
public class Feedback {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long feedbackID;

    @ManyToOne
    @JoinColumn(name = "patientID", nullable = false)
    private Patient patient;

    @ManyToOne
    @JoinColumn(name = "doctorID", nullable = false)
    private Doctor doctor;

    @ManyToOne
    @JoinColumn(name = "examinationID", nullable = false)
    private Examination examination;

    @Column(nullable = false)
    private Integer rating;

    @Column(name = "service_rating")
    private Integer serviceRating;

    @Column(name = "cleanliness_rating")
    private Integer cleanlinessRating;

    @Column(length = 2000)
    private String comment;

    @Column(length = 2000)
    private String response;

    @Column(name = "is_anonymous")
    private boolean isAnonymous = false;

    @Column(name = "is_approved")
    private boolean isApproved = true;

    @Column(nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false)
    private LocalDateTime modifiedAt = LocalDateTime.now();

    @PrePersist
    @PreUpdate
    private void validateRatings() {
        if (rating != null && (rating < 1 || rating > 5)) {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }
        if (serviceRating != null && (serviceRating < 1 || serviceRating > 5)) {
            throw new IllegalArgumentException("Service rating must be between 1 and 5");
        }
        if (cleanlinessRating != null && (cleanlinessRating < 1 || cleanlinessRating > 5)) {
            throw new IllegalArgumentException("Cleanliness rating must be between 1 and 5");
        }
    }

    @Override
    public String toString() {
        return "Feedback [feedbackID=" + feedbackID +
                ", patientID=" + (patient != null ? patient.getPatientID() : null) +
                ", doctorID=" + (doctor != null ? doctor.getDoctorID() : null) +
                ", examinationID=" + (examination != null ? examination.getExaminationID() : null) +
                ", rating=" + rating + ", serviceRating=" + serviceRating +
                ", cleanlinessRating=" + cleanlinessRating + ", isAnonymous=" + isAnonymous +
                ", isApproved=" + isApproved + ", createdAt=" + createdAt + ", modifiedAt=" + modifiedAt + "]";
    }
}