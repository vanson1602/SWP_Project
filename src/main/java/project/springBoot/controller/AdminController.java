package project.springBoot.controller;

import java.time.DayOfWeek;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;
import project.springBoot.service.AppointmentService;

@Slf4j
@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private AppointmentService appointmentService;
    
    @Autowired
    private ObjectMapper objectMapper;

    @GetMapping("/dashboard-day")
    public String getDashboardDay(Model model) {
        try {
            LocalDateTime now = LocalDateTime.now();
            LocalDateTime startOfDay = now.toLocalDate().atStartOfDay();
            LocalDateTime endOfDay = LocalDateTime.of(now.toLocalDate(), LocalTime.MAX);

            log.info("Fetching daily data from {} to {}", startOfDay, endOfDay);

            long totalAppointments = appointmentService.getDistinctAppointmentsCompletedBetween(startOfDay, endOfDay);
            long totalPatients = appointmentService.getDistinctPatientsCompletedBetween(startOfDay, endOfDay);
            double totalRevenue = appointmentService.getRevenueBetween(startOfDay, endOfDay);
            LocalDateTime chartStart = now.minusDays(6).toLocalDate().atStartOfDay();
            List<Map<String, Object>> chartData = appointmentService.getDailyAppointmentReport(chartStart, endOfDay);
            Map<String, Long> statusDistribution = appointmentService.getAppointmentStatusDistributionBetween(startOfDay, endOfDay);
            
            List<Map<String, Object>> doctorRevenue = appointmentService.getDoctorRevenueReport(startOfDay, endOfDay);
            log.info("Found daily doctor revenue data: {}", doctorRevenue);

            try {
                String dailyStatsJson = objectMapper.writeValueAsString(chartData);
                String statusDistributionJson = objectMapper.writeValueAsString(statusDistribution);
                model.addAttribute("dailyStatsJson", dailyStatsJson);
                model.addAttribute("statusDistributionJson", statusDistributionJson);
            } catch (Exception e) {
                log.warn("Error serializing JSON data: " + e.getMessage());
                model.addAttribute("dailyStatsJson", "[]");
                model.addAttribute("statusDistributionJson", "{}");
            }

            model.addAttribute("totalPatients", totalPatients);
            model.addAttribute("totalAppointments", totalAppointments);
            model.addAttribute("totalRevenue", totalRevenue);
            model.addAttribute("filter", "day");
            model.addAttribute("doctorRevenue", doctorRevenue);

            return "admin/dashboard-day";
        } catch (Exception e) {
            log.error("Error in getDashboardDay: ", e);
            model.addAttribute("error", "Có lỗi xảy ra khi tải dữ liệu thống kê: " + e.getMessage());
            setDefaultModelAttributes(model);
            return "admin/dashboard-day";
        }
    }

    @GetMapping("/dashboard-week")
    public String getDashboardWeek(Model model) {
        try {
            LocalDateTime now = LocalDateTime.now();
            // Tính toán đầu tuần (thứ 2) và cuối tuần (chủ nhật)
            LocalDateTime startOfWeek = now.with(DayOfWeek.MONDAY).toLocalDate().atStartOfDay();
            LocalDateTime endOfWeek = startOfWeek.plusDays(6).with(LocalTime.MAX);

            log.info("Fetching weekly data from {} to {}", startOfWeek, endOfWeek);

            long totalAppointments = appointmentService.getDistinctAppointmentsCompletedBetween(startOfWeek, endOfWeek);
            long totalPatients = appointmentService.getDistinctPatientsCompletedBetween(startOfWeek, endOfWeek);
            double totalRevenue = appointmentService.getRevenueBetween(startOfWeek, endOfWeek);
            List<Map<String, Object>> chartData = appointmentService.getDailyAppointmentReport(startOfWeek, endOfWeek);
            Map<String, Long> statusDistribution = appointmentService.getAppointmentStatusDistributionBetween(startOfWeek, endOfWeek);
            
            List<Map<String, Object>> doctorRevenue = appointmentService.getDoctorRevenueReport(startOfWeek, endOfWeek);
            log.info("Found weekly doctor revenue data: {}", doctorRevenue);

            try {
                String dailyStatsJson = objectMapper.writeValueAsString(chartData);
                String statusDistributionJson = objectMapper.writeValueAsString(statusDistribution);
                model.addAttribute("dailyStatsJson", dailyStatsJson);
                model.addAttribute("statusDistributionJson", statusDistributionJson);
            } catch (Exception e) {
                log.warn("Error serializing JSON data: " + e.getMessage());
                model.addAttribute("dailyStatsJson", "[]");
                model.addAttribute("statusDistributionJson", "{}");
            }

            model.addAttribute("totalPatients", totalPatients);
            model.addAttribute("totalAppointments", totalAppointments);
            model.addAttribute("totalRevenue", totalRevenue);
            model.addAttribute("filter", "week");
            model.addAttribute("doctorRevenue", doctorRevenue);

            return "admin/dashboard-week";
        } catch (Exception e) {
            log.error("Error in getDashboardWeek: ", e);
            model.addAttribute("error", "Có lỗi xảy ra khi tải dữ liệu thống kê: " + e.getMessage());
            setDefaultModelAttributes(model);
            return "admin/dashboard-week";
        }
    }

    @GetMapping("/dashboard-month")
    public String getDashboardMonth(Model model) {
        try {
            LocalDateTime now = LocalDateTime.now();
            // Tính toán đầu tháng và cuối tháng
            LocalDateTime startOfMonth = now.withDayOfMonth(1).toLocalDate().atStartOfDay();
            LocalDateTime endOfMonth = startOfMonth.plusMonths(1).minusNanos(1);

            log.info("Fetching monthly data from {} to {}", startOfMonth, endOfMonth);

            long totalAppointments = appointmentService.getDistinctAppointmentsCompletedBetween(startOfMonth, endOfMonth);
            long totalPatients = appointmentService.getDistinctPatientsCompletedBetween(startOfMonth, endOfMonth);
            double totalRevenue = appointmentService.getRevenueBetween(startOfMonth, endOfMonth);
            
            // Lấy dữ liệu cho biểu đồ 6 tháng gần nhất
            LocalDateTime chartStart = now.minusMonths(5).withDayOfMonth(1).toLocalDate().atStartOfDay();
            List<Map<String, Object>> chartData = appointmentService.getMonthlyAppointmentReport(chartStart, endOfMonth);
            Map<String, Long> statusDistribution = appointmentService.getAppointmentStatusDistributionBetween(startOfMonth, endOfMonth);
            
            List<Map<String, Object>> doctorRevenue = appointmentService.getDoctorRevenueReport(startOfMonth, endOfMonth);
            log.info("Found monthly doctor revenue data: {}", doctorRevenue);

            try {
                String dailyStatsJson = objectMapper.writeValueAsString(chartData);
                String statusDistributionJson = objectMapper.writeValueAsString(statusDistribution);
                model.addAttribute("dailyStatsJson", dailyStatsJson);
                model.addAttribute("statusDistributionJson", statusDistributionJson);
            } catch (Exception e) {
                log.warn("Error serializing JSON data: " + e.getMessage());
                model.addAttribute("dailyStatsJson", "[]");
                model.addAttribute("statusDistributionJson", "{}");
            }

            model.addAttribute("totalPatients", totalPatients);
            model.addAttribute("totalAppointments", totalAppointments);
            model.addAttribute("totalRevenue", totalRevenue);
            model.addAttribute("filter", "month");
            model.addAttribute("doctorRevenue", doctorRevenue);

            return "admin/dashboard-month";
        } catch (Exception e) {
            log.error("Error in getDashboardMonth: ", e);
            model.addAttribute("error", "Có lỗi xảy ra khi tải dữ liệu thống kê: " + e.getMessage());
            setDefaultModelAttributes(model);
            return "admin/dashboard-month";
        }
    }

    private void setDefaultModelAttributes(Model model) {
        model.addAttribute("totalPatients", 0);
        model.addAttribute("totalAppointments", 0);
        model.addAttribute("totalRevenue", 0.0);
        model.addAttribute("dailyStatsJson", "[]");
        model.addAttribute("statusDistributionJson", "{}");
        model.addAttribute("doctorRevenue", Collections.emptyList());
    }
} 