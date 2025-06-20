package project.springBoot.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@Table(name = "tblNotifications")
@NoArgsConstructor
@AllArgsConstructor
public class Notification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long notificationID;

    @ManyToOne
    @JoinColumn(name = "userID", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "appointmentID")
    private Appointment appointment;

    @Column(nullable = false, length = 200)
    private String title;

    @Column(nullable = false, length = 1000)
    private String message;

    @Column(name = "notification_type", nullable = false, length = 20)
    private String notificationType;

    @Column(length = 10)
    private String priority = "Normal";

    @Column(name = "is_read")
    private boolean isRead = false;

    @Column(name = "sent_at")
    private LocalDateTime sentAt = LocalDateTime.now();

    @Column(name = "read_at")
    private LocalDateTime readAt;

    @Column(nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @PrePersist
    @PreUpdate
    private void validateEnumLikeFields() {
        if (notificationType != null
                && !notificationType.matches("Reminder|Confirmation|Rejection|NewAppointment|Payment|General")) {
            throw new IllegalArgumentException("Invalid notification type: " + notificationType);
        }
        if (priority != null && !priority.matches("Low|Normal|High|Urgent")) {
            throw new IllegalArgumentException("Invalid priority: " + priority);
        }
    }

    @Override
    public String toString() {
        return "Notification [notificationID=" + notificationID +
                ", userID=" + (user != null ? user.getUserID() : null) +
                ", appointmentID=" + (appointment != null ? appointment.getAppointmentID() : null) +
                ", title=" + title + ", notificationType=" + notificationType +
                ", priority=" + priority + ", isRead=" + isRead + ", sentAt=" + sentAt +
                ", createdAt=" + createdAt + "]";
    }
}