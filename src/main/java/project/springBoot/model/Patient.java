package project.springBoot.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@Table(name = "tblPatients", uniqueConstraints = {
        @UniqueConstraint(columnNames = "userID"),
        @UniqueConstraint(columnNames = "patient_code")
})
@NoArgsConstructor
@AllArgsConstructor
public class Patient {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long patientID;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "userID", nullable = false, unique = true)
    private User user;

    @Column(name = "patient_code", length = 20, unique = true)
    private String patientCode;

    @Column(name = "emergency_contact_name", length = 100)
    private String emergencyContactName;

    @Column(name = "emergency_contact_phone", length = 15)
    private String emergencyContactPhone;

    @Column(name = "insurance_number", length = 50)
    private String insuranceNumber;

    @Column(length = 100)
    private String occupation;

    @Column(name = "marital_status", length = 20)
    private String maritalStatus;

    @JsonIgnore
    @OneToMany(mappedBy = "patient", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<MedicalRecord> medicalRecords = new ArrayList<>();

    @JsonIgnore
    @OneToMany(mappedBy = "patient", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<Appointment> appointments = new ArrayList<>();

    @Column(nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false)
    private LocalDateTime modifiedAt = LocalDateTime.now();

    @PrePersist
    @PreUpdate
    private void validateEnumLikeFields() {
        if (maritalStatus != null && !maritalStatus.matches("Single|Married|Divorced|Widowed")) {
            throw new IllegalArgumentException("Invalid marital status: " + maritalStatus);
        }
    }

    @Override
    public String toString() {
        return "Patient [patientID=" + patientID + ", userID=" + (user != null ? user.getUserID() : null) +
                ", patientCode=" + patientCode + ", emergencyContactName=" + emergencyContactName +
                ", emergencyContactPhone=" + emergencyContactPhone + ", insuranceNumber=" + insuranceNumber +
                ", occupation=" + occupation + ", maritalStatus=" + maritalStatus +
                ", createdAt=" + createdAt + ", modifiedAt=" + modifiedAt + "]";
    }
}