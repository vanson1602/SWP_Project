package project.springBoot.model;

import java.math.BigDecimal;
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
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@Table(name = "tblExaminations")
@NoArgsConstructor
@AllArgsConstructor
public class Examination {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long examinationID;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "appointmentID", nullable = false)
    private Appointment appointment;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "medicalRecordID", nullable = false)
    private MedicalRecord medicalRecord;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "doctorID", nullable = false)
    private Doctor doctor;

    @Column(name = "examination_date", nullable = false)
    private LocalDateTime examinationDate;

    @Column(name = "heart_rate")
    private Integer heartRate;

    @Column(precision = 4, scale = 1)
    private BigDecimal temperature;

    @Column(name = "blood_pressure_systolic")
    private Integer bloodPressureSystolic;

    @Column(name = "blood_pressure_diastolic")
    private Integer bloodPressureDiastolic;

    @Column(name = "respiratory_rate")
    private Integer respiratoryRate;

    @Column(name = "oxygen_saturation", precision = 5, scale = 2)
    private BigDecimal oxygenSaturation;

    @Column(name = "chief_complaint", length = 500)
    private String chiefComplaint;

    @Column(length = 1000)
    private String symptoms;

    @Column(name = "physical_examination", length = 1000)
    private String physicalExamination;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "icd_diagnosis")
    private ICDCode icdDiagnosis;

    @Column(name = "disease_diagnosis", length = 500)
    private String diseaseDiagnosis;

    @Column(name = "conclusion_treatment_plan", length = 2000)
    private String conclusionTreatmentPlan;

    @Column(name = "follow_up_date")
    private LocalDateTime followUpDate;

    @Column(length = 20)
    private String status = "Completed";

    @JsonIgnore
    @OneToMany(mappedBy = "examination", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<Prescription> prescriptions = new ArrayList<>();

    @JsonIgnore
    @OneToMany(mappedBy = "examination", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<Invoice> invoices = new ArrayList<>();

    @JsonIgnore
    @OneToMany(mappedBy = "examination", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<Feedback> feedbacks = new ArrayList<>();

    @Column(nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false)
    private LocalDateTime modifiedAt = LocalDateTime.now();

    @PrePersist
    @PreUpdate
    private void validateEnumLikeFields() {
        if (status != null && !status.matches("In Progress|Completed|Cancelled")) {
            throw new IllegalArgumentException("Invalid status: " + status);
        }
    }

    @Override
    public String toString() {
        return "Examination [examinationID=" + examinationID +
                ", appointmentID=" + (appointment != null ? appointment.getAppointmentID() : null) +
                ", medicalRecordID=" + (medicalRecord != null ? medicalRecord.getMedicalRecordID() : null) +
                ", doctorID=" + (doctor != null ? doctor.getDoctorID() : null) +
                ", examinationDate=" + examinationDate + ", status=" + status +
                ", createdAt=" + createdAt + ", modifiedAt=" + modifiedAt + "]";
    }
}