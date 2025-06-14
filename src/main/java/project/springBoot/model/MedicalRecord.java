package project.springBoot.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@Table(name = "tblMedicalRecords")
@NoArgsConstructor
@AllArgsConstructor
public class MedicalRecord {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long medicalRecordID;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patientID", nullable = false)
    private Patient patient;

    @Column(precision = 5, scale = 2)
    private BigDecimal height;

    @Column(precision = 5, scale = 2)
    private BigDecimal weight;

    @Column(name = "blood_type", length = 5)
    private String bloodType;

    @Column(name = "smoking_status", length = 20)
    private String smokingStatus;

    @Column(name = "alcohol_use", length = 20)
    private String alcoholUse;

    @JsonIgnore
    @ManyToMany(cascade = { CascadeType.PERSIST, CascadeType.MERGE }, fetch = FetchType.LAZY)
    @JoinTable(name = "tblMedicalRecordAllergies", joinColumns = @JoinColumn(name = "recordID"), inverseJoinColumns = @JoinColumn(name = "allergyID"))
    private List<PatientAllergy> allergies = new ArrayList<>();

    @JsonIgnore
    @ManyToMany(cascade = { CascadeType.PERSIST, CascadeType.MERGE }, fetch = FetchType.LAZY)
    @JoinTable(name = "tblMedicalRecordComorbidities", joinColumns = @JoinColumn(name = "recordID"), inverseJoinColumns = @JoinColumn(name = "comorbidityID"))
    private List<PatientComorbidity> comorbidities = new ArrayList<>();

    @Column(nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false)
    private LocalDateTime modifiedAt = LocalDateTime.now();

    @PrePersist
    @PreUpdate
    private void validateEnumLikeFields() {
        if (smokingStatus != null && !smokingStatus.matches("Non-smoker|Smoker|Former smoker")) {
            throw new IllegalArgumentException("Invalid smoking status: " + smokingStatus);
        }
        if (alcoholUse != null && !alcoholUse.matches("None|Occasional|Regular")) {
            throw new IllegalArgumentException("Invalid alcohol use: " + alcoholUse);
        }
        if (height != null && height.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Height must be greater than 0");
        }
        if (weight != null && weight.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Weight must be greater than 0");
        }
    }

    @Override
    public String toString() {
        return "MedicalRecord [medicalRecordID=" + medicalRecordID +
                ", patientID=" + (patient != null ? patient.getPatientID() : null) +
                ", height=" + height + ", weight=" + weight + ", bloodType=" + bloodType +
                ", smokingStatus=" + smokingStatus + ", alcoholUse=" + alcoholUse +
                ", createdAt=" + createdAt + ", modifiedAt=" + modifiedAt + "]";
    }
}