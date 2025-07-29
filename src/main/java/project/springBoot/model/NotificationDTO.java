package project.springBoot.model;

import java.time.LocalDateTime;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class NotificationDTO {
    private Long id;
    private String title;
    private String message;
    private String type;
    private boolean isRead;
    private LocalDateTime createdAt;
    private LocalDateTime readAt;
    private Long appointmentId;
    private String appointmentStatus;
    private String doctorName;
    private String patientName;
    private String appointmentTime;

    public static NotificationDTO fromEntity(Notification notification) {
        NotificationDTO dto = new NotificationDTO();
        dto.setId(notification.getNotificationID());
        dto.setTitle(notification.getTitle());
        dto.setMessage(notification.getMessage());
        dto.setType(notification.getNotificationType());
        dto.setRead(notification.isRead());
        dto.setCreatedAt(notification.getSentAt());
        dto.setReadAt(notification.getReadAt());

        if (notification.getAppointment() != null) {
            dto.setAppointmentId(notification.getAppointment().getAppointmentID());
            dto.setAppointmentStatus(notification.getAppointment().getStatus());

            if (notification.getAppointment().getBookingSlot() != null &&
                    notification.getAppointment().getBookingSlot().getSchedule() != null &&
                    notification.getAppointment().getBookingSlot().getSchedule().getDoctor() != null &&
                    notification.getAppointment().getBookingSlot().getSchedule().getDoctor().getUser() != null) {

                User doctorUser = notification.getAppointment().getBookingSlot().getSchedule().getDoctor().getUser();
                dto.setDoctorName("Dr. " + doctorUser.getFirstName() + " " + doctorUser.getLastName());
            }

            if (notification.getAppointment().getPatient() != null &&
                    notification.getAppointment().getPatient().getUser() != null) {

                User patientUser = notification.getAppointment().getPatient().getUser();
                dto.setPatientName(patientUser.getFirstName() + " " + patientUser.getLastName());
            }

            if (notification.getAppointment().getBookingSlot() != null) {
                dto.setAppointmentTime(notification.getAppointment().getBookingSlot().getStartTime().toString());
            }
        }

        return dto;
    }
}