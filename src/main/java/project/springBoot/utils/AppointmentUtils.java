package project.springBoot.utils;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;
import project.springBoot.model.Appointment;

public class AppointmentUtils {
    public static final int MAX_DAILY_APPOINTMENTS = 20;

    public static String generateAppointmentNumber() {
        return "APT" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"))
                + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }

    public static boolean isValidStatus(String status) {
        return status != null && status.matches("Pending|Confirmed|Rejected|Completed|Cancelled|NoShow");
    }

    public static boolean canCancel(Appointment appointment) {
        if (appointment == null)
            return false;

        String status = appointment.getStatus();
        if ("Completed".equals(status) || "Cancelled".equals(status)) {
            return false;
        }

        LocalDateTime appointmentDate = appointment.getAppointmentDate();
        return appointmentDate.isAfter(LocalDateTime.now());
    }
}