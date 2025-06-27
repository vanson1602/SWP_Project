package project.springBoot.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@Table(name = "tblDoctorBookingSlots")
@NoArgsConstructor
@AllArgsConstructor
public class DoctorBookingSlot {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long slotID;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "scheduleID", nullable = false)
    private DoctorSchedule schedule;

    @Column(name = "start_time", nullable = false)
    private LocalDateTime startTime;

    @Column(name = "end_time", nullable = false)
    private LocalDateTime endTime;

    @Column(length = 20)
    private String status = "Available";

    @OneToOne(cascade = { CascadeType.PERSIST, CascadeType.MERGE })
    @JoinColumn(name = "appointmentID", unique = true)
    private Appointment appointment;

    @Column(nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false)
    private LocalDateTime modifiedAt = LocalDateTime.now();

    @PrePersist
    @PreUpdate
    private void validateEnumLikeFields() {
        if (status != null && !status.matches("Available|Booked|Blocked")) {
            throw new IllegalArgumentException("Invalid status: " + status);
        }
    }

    @Override
    public String toString() {
        return "DoctorBookingSlot [slotID=" + slotID +
                ", scheduleID=" + (schedule != null ? schedule.getScheduleID() : null) +
                ", startTime=" + startTime + ", endTime=" + endTime + ", status=" + status +
                ", appointmentID=" + (appointment != null ? appointment.getAppointmentID() : null) +
                ", createdAt=" + createdAt + ", modifiedAt=" + modifiedAt + "]";
    }

    public boolean isAvailable() {
        return this.status != null && this.status.equals("Available");
    }
}