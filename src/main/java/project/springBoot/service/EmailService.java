package project.springBoot.service;

import java.time.format.DateTimeFormatter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import project.springBoot.model.Appointment;
import project.springBoot.model.DoctorSchedule;

@Service
public class EmailService {
    @Autowired
    private JavaMailSender mailSender;
    @Value("${spring.mail.username}")
    private String from;

    public void sendVerificationEmail(String email, String verificationToken) {
        String subject = "Xác thực tài khoản";
        String path = "/register/verify";
        String message = "Nhấn vào nút phía bên dưới để xác thực tài khoản email của bạn:";
        sendEmail(email, verificationToken, subject, path, message);
    }

    public void sendForgotPasswordEmail(String email, String resetToken) {
        String subject = "Khôi phục mật khẩu";
        String path = "/reset-password";
        String message = "Nhấn vào nút phía bên dưới để khôi phục mật khẩu của bạn:";
        sendEmail(email, resetToken, subject, path, message);
    }

    private void sendEmail(String email, String token, String subject, String path, String message) {
        try {
            String actionUrl = ServletUriComponentsBuilder.fromCurrentContextPath()
                    .path(path)
                    .queryParam("token", token)
                    .toUriString();

            String content = """
                    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border-radius: 8px; background-color: #f9f9f9; text-align: center;">
                    <h2 style="color: #333;">%s</h2>
                    <p style="font-size: 16px; color: #555;">%s</p>
                    <a href="%s" style="display: inline-block; margin: 20px 0; padding: 10px 20px; font-size: 16px; color: #fff; background-color: #007bff; text-decoration: none; border-radius: 5px;">Proceed</a>
                    <p style="font-size: 14px; color: #777;">Hoặc copy và paste link vào trình duyệt:</p>
                    <p style="font-size: 14px; color: #007bff;">%s</p>
                    <p style="font-size: 12px; color: #aaa;">This is an automated message. Please do not reply.</p>
                    </div>
                    """
                    .formatted(subject, message, actionUrl, actionUrl);

            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
            helper.setTo(email);
            helper.setSubject(subject);
            helper.setFrom(from);
            helper.setText(content, true);
            mailSender.send(mimeMessage);
        } catch (MessagingException e) {
            throw new RuntimeException("Failed to send email: " + e.getMessage(), e);
        }
    }

    public void sendAppointmentConfirmationEmail(String email, Appointment appointment) {
        String subject = "Xác nhận đặt lịch khám thành công";
        String message = String.format(
                """
                        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border-radius: 8px; background-color: #f9f9f9;">
                            <h2 style="color: #333; text-align: center;">Xác nhận đặt lịch khám</h2>
                            <p style="font-size: 16px; color: #555;">Xin chào %s,</p>
                            <p style="font-size: 16px; color: #555;">Lịch hẹn khám của bạn đã được xác nhận thành công với thông tin như sau:</p>
                            <div style="background-color: #fff; padding: 15px; border-radius: 5px; margin: 20px 0;">
                                <table style="width: 100%%; border-collapse: collapse;">
                                    <tr>
                                        <td style="padding: 8px; border-bottom: 1px solid #eee; width: 35%%;"><strong>Mã lịch hẹn:</strong></td>
                                        <td style="padding: 8px; border-bottom: 1px solid #eee;">%s</td>
                                    </tr>
                                    <tr>
                                        <td style="padding: 8px; border-bottom: 1px solid #eee;"><strong>Bác sĩ:</strong></td>
                                        <td style="padding: 8px; border-bottom: 1px solid #eee;">%s</td>
                                    </tr>
                                    <tr>
                                        <td style="padding: 8px; border-bottom: 1px solid #eee;"><strong>Ngày giờ khám:</strong></td>
                                        <td style="padding: 8px; border-bottom: 1px solid #eee;">%s</td>
                                    </tr>
                                    <tr>
                                        <td style="padding: 8px;"><strong>Loại khám:</strong></td>
                                        <td style="padding: 8px;">%s</td>
                                    </tr>
                                </table>
                            </div>
                            <p style="font-size: 14px; color: #555;">Vui lòng đến đúng giờ để được phục vụ tốt nhất.</p>
                            <p style="font-size: 14px; color: #555;">Nếu bạn cần hủy hoặc thay đổi lịch hẹn, vui lòng thông báo trước ít nhất 24 giờ.</p>
                            <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee;">
                                <p style="font-size: 14px; color: #777; margin: 5px 0;">Trân trọng,</p>
                                <p style="font-size: 14px; color: #777; margin: 5px 0;">Heathcare++</p>
                            </div>
                        </div>
                        """,
                appointment.getPatient().getUser().getFullName(),
                appointment.getAppointmentNumber(),
                // appointment.getBookingSlot().getSchedule().getDoctor().getUser().getFullName(),
                appointment.getAppointmentDate().format(DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy")),
                appointment.getAppointmentType().getTypeName());

        try {
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
            helper.setTo(email);
            helper.setSubject(subject);
            helper.setFrom(from);
            helper.setText(message, true);
            mailSender.send(mimeMessage);
        } catch (MessagingException e) {
            throw new RuntimeException("Failed to send confirmation email: " + e.getMessage(), e);
        }
    }

    public void sendDoctorAppointmentNotificationEmail(String email, Appointment appointment) {
        String subject = "Thông báo lịch hẹn khám mới";
        String message = String.format(
                """
                        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border-radius: 8px; background-color: #f9f9f9;">
                            <h2 style="color: #333; text-align: center;">Thông báo lịch hẹn khám mới</h2>
                            <p style="font-size: 16px; color: #555;">Xin chào Bác sĩ %s,</p>
                            <p style="font-size: 16px; color: #555;">Bạn có một lịch hẹn khám mới với thông tin như sau:</p>
                            <div style="background-color: #fff; padding: 15px; border-radius: 5px; margin: 20px 0;">
                                <table style="width: 100%%; border-collapse: collapse;">
                                    <tr>
                                        <td style="padding: 8px; border-bottom: 1px solid #eee; width: 35%%;"><strong>Mã lịch hẹn:</strong></td>
                                        <td style="padding: 8px; border-bottom: 1px solid #eee;">%s</td>
                                    </tr>
                                    <tr>
                                        <td style="padding: 8px; border-bottom: 1px solid #eee;"><strong>Bệnh nhân:</strong></td>
                                        <td style="padding: 8px; border-bottom: 1px solid #eee;">%s</td>
                                    </tr>
                                    <tr>
                                        <td style="padding: 8px; border-bottom: 1px solid #eee;"><strong>Ngày giờ khám:</strong></td>
                                        <td style="padding: 8px; border-bottom: 1px solid #eee;">%s</td>
                                    </tr>
                                    <tr>
                                        <td style="padding: 8px;"><strong>Loại khám:</strong></td>
                                        <td style="padding: 8px;">%s</td>
                                    </tr>
                                </table>
                            </div>
                            <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee;">
                                <p style="font-size: 14px; color: #777; margin: 5px 0;">Trân trọng,</p>
                                <p style="font-size: 14px; color: #777; margin: 5px 0;">Heathcare++</p>
                            </div>
                        </div>
                        """,
                // appointment.getBookingSlot().getSchedule().getDoctor().getUser().getFullName(),
                appointment.getAppointmentNumber(),
                appointment.getPatient().getUser().getFullName(),
                appointment.getAppointmentDate().format(DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy")),
                appointment.getAppointmentType().getTypeName());

        try {
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
            helper.setTo(email);
            helper.setSubject(subject);
            helper.setFrom(from);
            helper.setText(message, true);
            mailSender.send(mimeMessage);
        } catch (MessagingException e) {
            throw new RuntimeException("Failed to send notification email: " + e.getMessage(), e);
        }
    }

    public void sendScheduleApprovalEmail(String doctorEmail, DoctorSchedule schedule, boolean approved) {
        String subject = approved ? "Phê duyệt lịch bận thành công" : "Từ chối lịch bận";
        String status = approved ? "Busy" : "Available";
        String action = approved ? "phê duyệt" : "từ chối";

        String message = String.format(
                """
                        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border-radius: 8px; background-color: #f9f9f9;">
                            <h2 style="color: #333; text-align: center;">%s</h2>
                            <p style="font-size: 16px; color: #555;">Xin chào Bác sĩ %s,</p>
                            <p style="font-size: 16px; color: #555;">Lịch bận của bạn đã được %s với thông tin như sau:</p>
                            <div style="background-color: #fff; padding: 15px; border-radius: 5px; margin: 20px 0;">
                                <table style="width: 100%%; border-collapse: collapse;">
                                    <tr>
                                        <td style="padding: 8px; border-bottom: 1px solid #eee; width: 35%%;"><strong>Ngày làm việc:</strong></td>
                                        <td style="padding: 8px; border-bottom: 1px solid #eee;">%s</td>
                                    </tr>
                                    <tr>
                                        <td style="padding: 8px; border-bottom: 1px solid #eee;"><strong>Thời gian bắt đầu:</strong></td>
                                        <td style="padding: 8px; border-bottom: 1px solid #eee;">%s</td>
                                    </tr>
                                    <tr>
                                        <td style="padding: 8px; border-bottom: 1px solid #eee;"><strong>Thời gian kết thúc:</strong></td>
                                        <td style="padding: 8px; border-bottom: 1px solid #eee;">%s</td>
                                    </tr>
                                    <tr>
                                        <td style="padding: 8px;"><strong>Trạng thái:</strong></td>
                                        <td style="padding: 8px;">%s</td>
                                    </tr>
                                </table>
                            </div>
                            <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee;">
                                <p style="font-size: 14px; color: #777; margin: 5px 0;">Trân trọng,</p>
                                <p style="font-size: 14px; color: #777; margin: 5px 0;">Heathcare++</p>
                            </div>
                        </div>
                        """,
                subject,
                schedule.getDoctor().getUser().getFullName(),
                action,
                schedule.getWorkDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")),
                schedule.getStartTime().format(DateTimeFormatter.ofPattern("HH:mm")),
                schedule.getEndTime().format(DateTimeFormatter.ofPattern("HH:mm")),
                status);

        try {
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
            helper.setTo(doctorEmail);
            helper.setSubject(subject);
            helper.setFrom(from);
            helper.setText(message, true);
            mailSender.send(mimeMessage);
        } catch (MessagingException e) {
            throw new RuntimeException("Failed to send schedule approval email: " + e.getMessage(), e);
        }
    }

}
