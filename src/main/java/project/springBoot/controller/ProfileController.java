package project.springBoot.controller;

import java.time.LocalDateTime;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import project.springBoot.model.Patient;
import project.springBoot.model.User;
import project.springBoot.service.AppointmentService;
import project.springBoot.service.PatientService;
import project.springBoot.service.UploadFileService;
import project.springBoot.service.UserService;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@Slf4j
@Controller
public class ProfileController {

    private final UserService userService;
    private final UploadFileService uploadFileService;
    private final PatientService patientService;
    private final AppointmentService appointmentService;

    private static final String UPLOAD_DIR = "uploads/avatars/";
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024;
    private static final String[] ALLOWED_EXTENSIONS = { ".jpg", ".jpeg", ".png", ".gif" };

    @Autowired
    public ProfileController(UserService userService, UploadFileService uploadFileService,
            PatientService patientService, AppointmentService appointmentService) {
        this.userService = userService;
        this.uploadFileService = uploadFileService;
        this.patientService = patientService;
        this.appointmentService = appointmentService;
    }

    @RequestMapping("/profile")
    public String getProfileUserPage(Model model, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }

        if ("patient".equalsIgnoreCase(user.getRole())) {
            try {
                Patient patient = patientService.getPatientByUsername(user.getUsername());
                if (patient != null) {
                    // Lấy năm hiện tại
                    int currentYear = LocalDateTime.now().getYear();
                    int currentMonth = LocalDateTime.now().getMonthValue();

                    List<Map<String, Object>> monthlyStats = appointmentService
                            .getPatientAppointmentsByYear(patient.getPatientID(), currentYear);
                    model.addAttribute("monthlyStats", monthlyStats);

                    List<Map<String, Object>> specializationStats = appointmentService
                            .getPatientAppointmentsBySpecializationAndYear(patient.getPatientID(), currentYear);
                    model.addAttribute("specializationStats", specializationStats);

                    List<Integer> availableYears = appointmentService
                            .getAvailableYearsForPatient(patient.getPatientID());
                    model.addAttribute("availableYears", availableYears);
                    model.addAttribute("currentYear", currentYear);
                    model.addAttribute("currentMonth", currentMonth);

                  
                    List<Map<String, Object>> weekStats = appointmentService
                            .getPatientAppointmentsByWeekInMonth(patient.getPatientID(), currentYear, currentMonth);
                    if (weekStats != null && !weekStats.isEmpty()) {
                        Map<String, Object> topWeekMap = weekStats.get(0);
                        model.addAttribute("topWeek", topWeekMap.get("weekInMonth"));
                        model.addAttribute("topWeekCount", topWeekMap.get("appointmentCount"));
                        model.addAttribute("topWeekMonth", currentMonth);
                        model.addAttribute("topWeekYear", currentYear);
                    }

                    model.addAttribute("patient", patient);
                }
            } catch (Exception e) {
                log.error("Error loading patient statistics", e);
            }
        }

        model.addAttribute("user", user);
        return "user/profile";
    }

    @RequestMapping("/profile/edit")
    public String editProfile(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        model.addAttribute("user", currentUser);
        return "user/edit-profile";
    }

    @RequestMapping(value = "/profile/update", method = RequestMethod.POST)
    public String updateProfile(@ModelAttribute("user") User user,
            @RequestParam(value = "avatarFile", required = false) MultipartFile file,
            HttpSession session,
            RedirectAttributes ra) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        // Keep unchanged values from the current user
        user.setUserID(currentUser.getUserID());
        user.setUsername(currentUser.getUsername());
        user.setEmail(currentUser.getEmail());
        user.setRole(currentUser.getRole());
        user.setPassword(currentUser.getPassword());
        user.setAvatarUrl(currentUser.getAvatarUrl());
        user.setVerificationToken(currentUser.getVerificationToken());
        user.setIsVerified(currentUser.getIsVerified());
        user.setResetToken(currentUser.getResetToken());
        user.setResetTokenExpiry(currentUser.getResetTokenExpiry());
        user.setLastLogin(currentUser.getLastLogin());
        user.setState(currentUser.getState());
        user.setCreatedAt(currentUser.getCreatedAt());
        user.setModifiedAt(LocalDateTime.now());
        user.setModifiedBy(currentUser.getModifiedBy());

        // Handle avatar upload if provided
        if (file != null && !file.isEmpty()) {
            try {
                String avatarUrl = uploadFileService.uploadImage(file);
                if (avatarUrl != null) {
                    user.setAvatarUrl(avatarUrl);
                }
            } catch (IllegalArgumentException e) {
                ra.addFlashAttribute("error", e.getMessage());
                return "redirect:/profile/edit";
            } catch (RuntimeException e) {
                ra.addFlashAttribute("error", "Có lỗi xảy ra khi tải lên ảnh. Vui lòng thử lại sau!");
                return "redirect:/profile/edit";
            } catch (Exception e) {
                ra.addFlashAttribute("error", "Có lỗi xảy ra khi tải lên ảnh. Vui lòng thử lại sau!");
                return "redirect:/profile/edit";
            }
        }

        try {
            userService.handleSaveUser(user);
            session.setAttribute("currentUser", user);
            ra.addFlashAttribute("success", "Cập nhật thông tin thành công!");
            return "redirect:/profile";
        } catch (Exception e) {
            log.error("Error updating user profile", e);
            ra.addFlashAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại sau!");
            return "redirect:/profile/edit";
        }
    }

    @PostMapping("/profile/change-password")
    public String changePassword(@RequestParam("currentPassword") String currentPassword,
            @RequestParam("newPassword") String newPassword,
            @RequestParam("confirmPassword") String confirmPassword,
            HttpSession session,
            RedirectAttributes ra) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return "redirect:/login";
            }

            // Validate current password
            if (!BCrypt.checkpw(currentPassword, currentUser.getPassword())) {
                ra.addFlashAttribute("error", "Mật khẩu hiện tại không đúng");
                return "redirect:/profile";
            }

            // Validate new password
            if (!newPassword.equals(confirmPassword)) {
                ra.addFlashAttribute("error", "Mật khẩu xác nhận không khớp");
                return "redirect:/profile";
            }

            // Update password
            String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
            currentUser.setPassword(hashedPassword);
            userService.handleUpdateUser(currentUser);
            session.setAttribute("currentUser", currentUser);

            ra.addFlashAttribute("success", "Đổi mật khẩu thành công!");
            return "redirect:/profile";
        } catch (Exception e) {
            e.printStackTrace();
            ra.addFlashAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại sau!");
            return "redirect:/profile";
        }
    }

    @RequestMapping("/api/patient/stats/monthly")
    public @ResponseBody List<Map<String, Object>> getPatientMonthlyStats(HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null || !"patient".equalsIgnoreCase(user.getRole())) {
            return new ArrayList<>();
        }

        try {
            Patient patient = patientService.getPatientByUsername(user.getUsername());
            if (patient != null) {
                return appointmentService.getPatientAppointmentsByMonthYear(patient.getPatientID());
            }
        } catch (Exception e) {
            log.error("Error getting patient monthly stats", e);
        }

        return new ArrayList<>();
    }

    @RequestMapping("/api/patient/stats/specialization")
    public @ResponseBody List<Map<String, Object>> getPatientSpecializationStats(HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null || !"patient".equalsIgnoreCase(user.getRole())) {
            return new ArrayList<>();
        }

        try {
            Patient patient = patientService.getPatientByUsername(user.getUsername());
            if (patient != null) {
                return appointmentService.getPatientAppointmentsBySpecialization(patient.getPatientID());
            }
        } catch (Exception e) {
            log.error("Error getting patient specialization stats", e);
        }

        return new ArrayList<>();
    }

    @RequestMapping("/api/patient/stats/filter")
    public @ResponseBody Map<String, Object> getPatientStatsByFilter(
            @RequestParam(defaultValue = "0") int year,
            @RequestParam(defaultValue = "0") int month,
            HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null || !"patient".equalsIgnoreCase(user.getRole())) {
            return new HashMap<>();
        }

        try {
            Patient patient = patientService.getPatientByUsername(user.getUsername());
            if (patient != null) {
                Map<String, Object> result = new HashMap<>();

                List<Map<String, Object>> monthlyStats;
                List<Map<String, Object>> specializationStats;

                if (month > 0) {

                    monthlyStats = appointmentService.getPatientAppointmentsByYearMonth(patient.getPatientID(), year,
                            month);
                    specializationStats = appointmentService
                            .getPatientAppointmentsBySpecializationAndYearMonth(patient.getPatientID(), year, month);
                } else {

                    monthlyStats = appointmentService.getPatientAppointmentsByYear(patient.getPatientID(), year);
                    specializationStats = appointmentService
                            .getPatientAppointmentsBySpecializationAndYear(patient.getPatientID(), year);
                }

                result.put("monthlyStats", monthlyStats);
                result.put("specializationStats", specializationStats);
                result.put("year", year);
                result.put("month", month);

                // Bổ sung trả về tuần khám nhiều nhất trong tháng nếu có lọc theo tháng
                if (month > 0) {
                    List<Map<String, Object>> weekStats = appointmentService
                            .getPatientAppointmentsByWeekInMonth(patient.getPatientID(), year, month);
                    if (weekStats != null && !weekStats.isEmpty()) {
                        Map<String, Object> topWeekMap = weekStats.get(0);
                        result.put("topWeek", topWeekMap.get("weekInMonth"));
                        result.put("topWeekCount", topWeekMap.get("appointmentCount"));
                        result.put("topWeekMonth", month);
                        result.put("topWeekYear", year);
                    }
                }

                return result;
            }
        } catch (Exception e) {
            log.error("Error getting patient stats by filter", e);
        }

        return new HashMap<>();
    }

    @RequestMapping("/api/patient/stats/available-years")
    public @ResponseBody List<Integer> getAvailableYears(HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null || !"patient".equalsIgnoreCase(user.getRole())) {
            return new ArrayList<>();
        }

        try {
            Patient patient = patientService.getPatientByUsername(user.getUsername());
            if (patient != null) {
                return appointmentService.getAvailableYearsForPatient(patient.getPatientID());
            }
        } catch (Exception e) {
            log.error("Error getting available years", e);
        }

        return new ArrayList<>();
    }

    @RequestMapping("/api/patient/stats/chart-3col")
    public @ResponseBody Map<String, Object> getPatientMonthly3ColChart(
            @RequestParam(defaultValue = "0") int year,
            HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null || !"patient".equalsIgnoreCase(user.getRole())) {
            return new HashMap<>();
        }
        try {
            Patient patient = patientService.getPatientByUsername(user.getUsername());
            if (patient != null) {

                if (year == 0) {
                    year = java.time.LocalDate.now().getYear();
                }
                List<Map<String, Object>> stats = appointmentService
                        .getPatientMonthlyStatusStats(patient.getPatientID(), year);
                // Chuẩn bị dữ liệu cho chart
                List<String> labels = new ArrayList<>();
                List<Long> total = new ArrayList<>();
                List<Long> completed = new ArrayList<>();
                List<Long> cancelled = new ArrayList<>();
                String[] monthNames = { "T1", "T2", "T3", "T4", "T5", "T6", "T7", "T8", "T9", "T10", "T11", "T12" };
                Map<Integer, Map<String, Object>> monthMap = new HashMap<>();
                for (Map<String, Object> stat : stats) {
                    monthMap.put(((Number) stat.get("month")).intValue(), stat);
                }
                for (int i = 1; i <= 12; i++) {
                    labels.add(monthNames[i - 1]);
                    Map<String, Object> stat = monthMap.get(i);
                    if (stat != null) {
                        total.add(((Number) stat.get("total")).longValue());
                        completed.add(((Number) stat.get("completed")).longValue());
                        cancelled.add(((Number) stat.get("cancelled")).longValue());
                    } else {
                        total.add(0L);
                        completed.add(0L);
                        cancelled.add(0L);
                    }
                }
                Map<String, Object> result = new HashMap<>();
                result.put("labels", labels);
                result.put("total", total);
                result.put("completed", completed);
                result.put("cancelled", cancelled);
                result.put("year", year);
                return result;
            }
        } catch (Exception e) {
            log.error("Error getting patient 3col chart data", e);
        }
        return new HashMap<>();
    }

    @RequestMapping("/api/patient/stats/chart-3col-daily")
    public @ResponseBody Map<String, Object> getPatientDaily3ColChart(
            @RequestParam(defaultValue = "0") int year,
            @RequestParam(defaultValue = "0") int month,
            HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null || !"patient".equalsIgnoreCase(user.getRole())) {
            return new HashMap<>();
        }
        try {
            Patient patient = patientService.getPatientByUsername(user.getUsername());
            if (patient != null) {
                // Nếu year = 0 thì lấy năm hiện tại
                if (year == 0) {
                    year = java.time.LocalDate.now().getYear();
                }
                List<Map<String, Object>> stats = appointmentService.getPatientDailyStatusStats(patient.getPatientID(),
                        year, month);
                // Chuẩn bị dữ liệu cho chart
                List<String> labels = new ArrayList<>();
                List<Long> total = new ArrayList<>();
                List<Long> completed = new ArrayList<>();
                List<Long> cancelled = new ArrayList<>();
                int daysInMonth = (month > 0) ? java.time.YearMonth.of(year, month).lengthOfMonth() : 31;
                Map<Integer, Map<String, Object>> dayMap = new HashMap<>();
                for (Map<String, Object> stat : stats) {
                    dayMap.put(((Number) stat.get("day")).intValue(), stat);
                }
                for (int i = 1; i <= daysInMonth; i++) {
                    labels.add(String.valueOf(i));
                    Map<String, Object> stat = dayMap.get(i);
                    if (stat != null) {
                        total.add(((Number) stat.get("total")).longValue());
                        completed.add(((Number) stat.get("completed")).longValue());
                        cancelled.add(((Number) stat.get("cancelled")).longValue());
                    } else {
                        total.add(0L);
                        completed.add(0L);
                        cancelled.add(0L);
                    }
                }
                Map<String, Object> result = new HashMap<>();
                result.put("labels", labels);
                result.put("total", total);
                result.put("completed", completed);
                result.put("cancelled", cancelled);
                result.put("year", year);
                result.put("month", month);
                return result;
            }
        } catch (Exception e) {
            log.error("Error getting patient daily 3col chart data", e);
        }
        return new HashMap<>();
    }

}