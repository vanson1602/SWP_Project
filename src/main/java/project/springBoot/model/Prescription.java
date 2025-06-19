package project.springBoot.model;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
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
@Table(name = "prescriptions")
@NoArgsConstructor
@AllArgsConstructor
public class Prescription {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "prescription_id")
    private Long prescriptionID;

    @Column(name = "examination_id", nullable = false, insertable = false, updatable = false)
    private Long examinationId;

    @Column(name = "medication_id", nullable = false, insertable = false, updatable = false)
    private Long medicationId;

    @Column(name = "prescribed_by", nullable = false, insertable = false, updatable = false)
    private Long prescribedById;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "examination_id", nullable = false)
    private Examination examination;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "medication_id", nullable = false)
    private Medication medication;

    @ManyToOne(fetch = FetchType.EAGER)
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
    private Boolean isRefillable = false;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "modified_at", nullable = false)
    private LocalDateTime modifiedAt;

    @Column(name = "status", length = 20)
    private String status = "PENDING";

    @Column(name = "completed_at")
    private LocalDateTime completedAt;

    // Getters and setters
    public Long getPrescriptionID() {
        return prescriptionID;
    }

    public void setPrescriptionID(Long prescriptionID) {
        this.prescriptionID = prescriptionID;
    }

    public Long getExaminationId() {
        return examinationId;
    }

    public void setExaminationId(Long examinationId) {
        this.examinationId = examinationId;
    }

    public Long getMedicationId() {
        return medicationId;
    }

    public void setMedicationId(Long medicationId) {
        this.medicationId = medicationId;
    }

    public Long getPrescribedById() {
        return prescribedById;
    }

    public void setPrescribedById(Long prescribedById) {
        this.prescribedById = prescribedById;
    }

    public Examination getExamination() {
        return examination;
    }

    public void setExamination(Examination examination) {
        this.examination = examination;
    }

    public Medication getMedication() {
        return medication;
    }

    public void setMedication(Medication medication) {
        this.medication = medication;
    }

    public Doctor getPrescribedBy() {
        return prescribedBy;
    }

    public void setPrescribedBy(Doctor prescribedBy) {
        this.prescribedBy = prescribedBy;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public String getDosage() {
        return dosage;
    }

    public void setDosage(String dosage) {
        this.dosage = dosage;
    }

    public String getFrequency() {
        return frequency;
    }

    public void setFrequency(String frequency) {
        this.frequency = frequency;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public String getInstructions() {
        return instructions;
    }

    public void setInstructions(String instructions) {
        this.instructions = instructions;
    }

    public Boolean getIsRefillable() {
        return isRefillable;
    }

    public void setIsRefillable(Boolean isRefillable) {
        this.isRefillable = isRefillable;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getModifiedAt() {
        return modifiedAt;
    }

    public void setModifiedAt(LocalDateTime modifiedAt) {
        this.modifiedAt = modifiedAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(LocalDateTime completedAt) {
        this.completedAt = completedAt;
    }

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        modifiedAt = LocalDateTime.now();
        if (status == null) {
            status = "PENDING";
        }
        // Set the ID fields from the relationships
        if (examination != null) {
            examinationId = examination.getExaminationID();
        }
        if (medication != null) {
            medicationId = medication.getMedicationID();
        }
        if (prescribedBy != null) {
            prescribedById = prescribedBy.getDoctorID();
        }
    }

    @PreUpdate
    protected void onUpdate() {
        modifiedAt = LocalDateTime.now();
        // Update the ID fields from the relationships
        if (examination != null) {
            examinationId = examination.getExaminationID();
        }
        if (medication != null) {
            medicationId = medication.getMedicationID();
        }
        if (prescribedBy != null) {
            prescribedById = prescribedBy.getDoctorID();
        }
    }

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