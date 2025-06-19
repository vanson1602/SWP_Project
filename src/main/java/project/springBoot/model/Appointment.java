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
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
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
@Table(name = "tblAppointments", uniqueConstraints = {
        @UniqueConstraint(columnNames = "appointment_number")
})
@NoArgsConstructor
@AllArgsConstructor
public class Appointment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long appointmentID;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patientID", nullable = false)
    private Patient patient;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "doctorID")
    private Doctor doctor;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "appointmentTypeID", nullable = false)
    private AppointmentType appointmentType;

    @Column(name = "appointment_date", nullable = false)
    private LocalDateTime appointmentDate;

    @Column(name = "appointment_number", nullable = false, length = 20, unique = true)
    private String appointmentNumber;

    @Column(length = 20)
    private String status = "Pending";

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "adminID")
    private User admin;

    @Column(name = "admin_notes", length = 500)
    private String adminNotes;

    @Column(name = "patient_notes", length = 500)
    private String patientNotes;

    @JsonIgnore
    @OneToMany(mappedBy = "appointment", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<Examination> examinations = new ArrayList<>();

    @JsonIgnore
    @OneToMany(mappedBy = "appointment", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<DoctorBookingSlot> bookingSlots = new ArrayList<>();

    @Column(nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false)
    private LocalDateTime modifiedAt = LocalDateTime.now();

    @PrePersist
    @PreUpdate
    private void validateEnumLikeFields() {
        if (status != null && !status.matches("Pending|Confirmed|Rejected|Completed|Cancelled|NoShow")) {
            throw new IllegalArgumentException("Invalid status: " + status);
        }
        if (appointmentDate != null && appointmentDate.isBefore(LocalDateTime.now())) {
            throw new IllegalArgumentException("Appointment date must be in the future");
        }
    }

    @Override
    public String toString() {
        return "Appointment [appointmentID=" + appointmentID +
                ", patientID=" + (patient != null ? patient.getPatientID() : null) +
                ", doctorID=" + (doctor != null ? doctor.getDoctorID() : null) +
                ", appointmentTypeID=" + (appointmentType != null ? appointmentType.getAppointmentTypeID() : null) +
                ", appointmentDate=" + appointmentDate + ", appointmentNumber=" + appointmentNumber +
                ", status=" + status + ", adminID=" + (admin != null ? admin.getUserID() : null) +
                ", createdAt=" + createdAt + ", modifiedAt=" + modifiedAt + "]";
    }
}