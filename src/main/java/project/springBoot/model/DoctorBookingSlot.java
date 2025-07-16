package project.springBoot.model;

import java.time.LocalDateTime;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToOne;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setAppointment(Appointment appointment) {
        this.appointment = appointment;
    }

    public DoctorSchedule getSchedule() {
        return schedule;
    }

    public LocalDateTime getStartTime() {
        return startTime;
    }

    public void setModifiedAt(LocalDateTime modifiedAt) {
        this.modifiedAt = modifiedAt;
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