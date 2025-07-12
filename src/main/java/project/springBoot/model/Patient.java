package project.springBoot.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

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

    public long getPatientID() {
        return patientID;
    }
    
    public void setPatientID(long patientID) {
        this.patientID = patientID;
    }
}