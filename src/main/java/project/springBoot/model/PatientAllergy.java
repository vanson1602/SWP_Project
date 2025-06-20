package project.springBoot.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@Table(name = "tblPatientAllergies")
@NoArgsConstructor
@AllArgsConstructor
public class PatientAllergy {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long allergyID;

    @Column(nullable = false, length = 100)
    private String allergen;

    @Column(length = 500)
    private String reaction;

    @Column(length = 20)
    private String severity;

    @ManyToMany(mappedBy = "allergies")
    private List<MedicalRecord> medicalRecords = new ArrayList<>();

    @Column(nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false)
    private LocalDateTime modifiedAt = LocalDateTime.now();

    @PrePersist
    @PreUpdate
    private void validateEnumLikeFields() {
        if (severity != null && !severity.matches("Mild|Moderate|Severe")) {
            throw new IllegalArgumentException("Invalid severity: " + severity);
        }
    }

    @Override
    public String toString() {
        return "PatientAllergy [allergyID=" + allergyID + ", allergen=" + allergen +
                ", reaction=" + reaction + ", severity=" + severity +
                ", createdAt=" + createdAt + ", modifiedAt=" + modifiedAt + "]";
    }
}