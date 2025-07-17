package project.springBoot.model;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class NotificationDTO {
    private long notificationID;
    private String title;
    private String message;
    private String notificationType;
    private String priority;
    private boolean isRead;
    private LocalDateTime sentAt;
    private LocalDateTime readAt;
    private Long appointmentId;
    private String appointmentType;
    private LocalDateTime appointmentDateTime;
    private String doctorName;

    public static NotificationDTO fromEntity(Notification notification) {
        NotificationDTO dto = new NotificationDTO();
        dto.setNotificationID(notification.getNotificationID());
        dto.setTitle(notification.getTitle());
        dto.setMessage(notification.getMessage());
        dto.setNotificationType(notification.getNotificationType());
        dto.setPriority(notification.getPriority());
        dto.setRead(notification.isRead());
        dto.setSentAt(notification.getSentAt());
        dto.setReadAt(notification.getReadAt());

        if (notification.getAppointment() != null) {
            dto.setAppointmentId(notification.getAppointment().getAppointmentID());
            dto.setAppointmentDateTime(notification.getAppointment().getBookingSlot().getStartTime());
            dto.setAppointmentType(notification.getAppointment().getAppointmentType().getTypeName());
            dto.setDoctorName(
                    notification.getAppointment().getBookingSlot().getSchedule().getDoctor().getUser()
                            .getFullName());
        }

        return dto;
    }
}