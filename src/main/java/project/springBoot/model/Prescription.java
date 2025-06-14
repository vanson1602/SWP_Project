package project.springBoot.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@Table(name = "tblPrescriptions")
@NoArgsConstructor
@AllArgsConstructor
public class Prescription {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long prescriptionID;

    @ManyToOne
    @JoinColumn(name = "examinationID", nullable = false)
    private Examination examination;

    @ManyToOne
    @JoinColumn(name = "medicationID", nullable = false)
    private Medication medication;

    @ManyToOne
    @JoinColumn(name = "prescribed_by", nullable = false)
    private Doctor prescribedBy;

    @Column(nullable = false)
    private Integer quantity;

    @Column(nullable = false, length = 100)
    private String dosage;

    @Column(nullable = false, length = 100)
    private String frequency;

    @Column(length = 100)
    private String duration;

    @Column(length = 500)
    private String instructions;

    @Column(name = "is_refillable")
    private boolean isRefillable = false;

    @Column(nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false)
    private LocalDateTime modifiedAt = LocalDateTime.now();

    @Override
    public String toString() {
        return "Prescription [prescriptionID=" + prescriptionID +
                ", examinationID=" + (examination != null ? examination.getExaminationID() : null) +
                ", medicationID=" + (medication != null ? medication.getMedicationID() : null) +
                ", prescribedBy=" + (prescribedBy != null ? prescribedBy.getDoctorID() : null) +
                ", quantity=" + quantity + ", dosage=" + dosage + ", frequency=" + frequency +
                ", duration=" + duration + ", isRefillable=" + isRefillable +
                ", createdAt=" + createdAt + ", modifiedAt=" + modifiedAt + "]";
    }
}