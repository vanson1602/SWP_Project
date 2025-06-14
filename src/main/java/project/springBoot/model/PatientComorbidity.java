package project.springBoot.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@Table(name = "tblPatientComorbidities")
@NoArgsConstructor
@AllArgsConstructor
public class PatientComorbidity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long comorbidityID;

    @ManyToOne
    @JoinColumn(name = "medicalRecordID", nullable = false)
    private MedicalRecord medicalRecord;

    @ManyToOne
    @JoinColumn(name = "icdCode", nullable = false)
    private ICDCode icdCode;

    @Column(name = "diagnosis_date")
    private LocalDate diagnosisDate;

    @Column(length = 500)
    private String notes;

    @ManyToMany(mappedBy = "comorbidities")
    private List<MedicalRecord> medicalRecords = new ArrayList<>();

    @Column(nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false)
    private LocalDateTime modifiedAt = LocalDateTime.now();

    @Override
    public String toString() {
        return "PatientComorbidity [comorbidityID=" + comorbidityID +
                ", medicalRecordID=" + (medicalRecord != null ? medicalRecord.getMedicalRecordID() : null) +
                ", icdCode=" + (icdCode != null ? icdCode.getIcdCode() : null) +
                ", diagnosisDate=" + diagnosisDate + ", notes=" + notes +
                ", createdAt=" + createdAt + ", modifiedAt=" + modifiedAt + "]";
    }
}