package project.springBoot.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@Table(name = "tblDoctorSchedules", uniqueConstraints = {
        @UniqueConstraint(columnNames = { "doctorID", "work_date" })
})
@NoArgsConstructor
@AllArgsConstructor
public class DoctorSchedule {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long scheduleID;

    @ManyToOne
    @JoinColumn(name = "doctorID", nullable = false)
    private Doctor doctor;

    @Column(name = "work_date", nullable = false)
    @NotNull(message = "Work date is required")
    private LocalDate workDate;

    @Column(name = "start_time", nullable = false)
    @NotNull(message = "Start time is required")
    private LocalTime startTime;

    @Column(name = "end_time", nullable = false)
    @NotNull(message = "End time is required")
    private LocalTime endTime;

    @Column(length = 20)
    private String status = "Available";

    @Column(name = "max_patients")
    private Integer maxPatients = 20;

    @Column(name = "clinic_room", length = 50)
    private String clinicRoom;

    @Column(length = 255)
    private String notes;

    @OneToMany(mappedBy = "schedule", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<DoctorBookingSlot> bookingSlots = new ArrayList<>();

    @Column(nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false)
    private LocalDateTime modifiedAt = LocalDateTime.now();

    @PrePersist
    @PreUpdate
    private void validateEnumLikeFields() {
        if (status != null && !status.matches("Available|Busy|Off|Holiday")) {
            throw new IllegalArgumentException("Invalid status: " + status);
        }
    }

    @Override
    public String toString() {
        return "DoctorSchedule [scheduleID=" + scheduleID +
                ", doctorID=" + (doctor != null ? doctor.getDoctorID() : null) +
                ", workDate=" + workDate + ", startTime=" + startTime + ", endTime=" + endTime +
                ", status=" + status + ", maxPatients=" + maxPatients + ", clinicRoom=" + clinicRoom +
                ", createdAt=" + createdAt + ", modifiedAt=" + modifiedAt + "]";
    }
}