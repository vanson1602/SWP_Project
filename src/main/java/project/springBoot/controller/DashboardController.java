package project.springBoot.controller;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.extern.slf4j.Slf4j;
import project.springBoot.service.AppointmentService;

@Slf4j
@Controller
@RequestMapping("/admin")
public class DashboardController {

    @Autowired
    private AppointmentService appointmentService;

    @GetMapping({"", "/"})
    public String showDashboard(Model model) {
        try {
            LocalDateTime now = LocalDateTime.now();
            LocalDateTime startOfDay = now.withHour(0).withMinute(0).withSecond(0).withNano(0);
            LocalDateTime endOfDay = now.withHour(23).withMinute(59).withSecond(59).withNano(999999999);

            // Initialize with today's data
            model.addAttribute("totalAppointments", appointmentService.getDistinctAppointmentsCompletedBetween(startOfDay, endOfDay));
            model.addAttribute("totalPatients", appointmentService.getDistinctPatientsCompletedBetween(startOfDay, endOfDay));
            model.addAttribute("totalRevenue", appointmentService.getRevenueBetween(startOfDay, endOfDay));
            
            // Get doctor revenue data
            List<Map<String, Object>> doctorRevenue = appointmentService.getDoctorRevenueReport(startOfDay, endOfDay);
            log.info("Found doctor revenue data: {}", doctorRevenue);
            model.addAttribute("doctorRevenue", doctorRevenue);
            
            // Get status distribution
            Map<String, Long> statusDistribution = appointmentService.getAppointmentStatusDistributionBetween(startOfDay, endOfDay);
            model.addAttribute("statusDistribution", statusDistribution);
            
            model.addAttribute("filter", "day");

            return "admin/dashboard";
        } catch (Exception e) {
            log.error("Error in showDashboard: ", e);
            model.addAttribute("error", "Có lỗi xảy ra khi tải dữ liệu: " + e.getMessage());
            return "admin/dashboard";
        }
    }

    @GetMapping("/dashboard/daily-stats")
    @ResponseBody
    public ResponseEntity<?> getDailyStats(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate) {
        try {
            List<Map<String, Object>> stats = appointmentService.getDailyAppointmentReport(startDate, endDate);
            return ResponseEntity.ok(stats != null ? stats : Collections.emptyList());
        } catch (Exception e) {
            log.error("Error getting daily stats: ", e);
            return ResponseEntity.badRequest().body(Collections.singletonMap("error", "Có lỗi xảy ra khi tải dữ liệu thống kê: " + e.getMessage()));
        }
    }

    @GetMapping("/dashboard/monthly-stats")
    @ResponseBody
    public ResponseEntity<?> getMonthlyStats(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate) {
        try {
            List<Map<String, Object>> stats = appointmentService.getMonthlyAppointmentReport(startDate, endDate);
            return ResponseEntity.ok(stats != null ? stats : Collections.emptyList());
        } catch (Exception e) {
            log.error("Error getting monthly stats: ", e);
            return ResponseEntity.badRequest().body(Collections.singletonMap("error", "Có lỗi xảy ra khi tải dữ liệu thống kê: " + e.getMessage()));
        }
    }

    @GetMapping("/dashboard/overview")
    @ResponseBody
    public ResponseEntity<?> getDashboardOverview(
            @RequestParam(defaultValue = "day") String filter,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate) {
        try {
            Map<String, Object> stats = new HashMap<>();
            stats.put("totalAppointments", appointmentService.getDistinctAppointmentsCompletedBetween(startDate, endDate));
            stats.put("totalPatients", appointmentService.getDistinctPatientsCompletedBetween(startDate, endDate));
            stats.put("totalRevenue", appointmentService.getRevenueBetween(startDate, endDate));
            
            // Get and process status distribution
            Map<String, Long> rawStatusDistribution = appointmentService.getAppointmentStatusDistributionBetween(startDate, endDate);
            Map<String, Long> orderedStatusDistribution = new LinkedHashMap<>();
            String[] statusOrder = {"Pending", "Confirmed", "Completed", "Cancelled", "Rejected"};
            
            for (String status : statusOrder) {
                if (rawStatusDistribution.containsKey(status)) {
                    orderedStatusDistribution.put(status, rawStatusDistribution.get(status));
                }
            }
            
            stats.put("statusDistribution", orderedStatusDistribution);
            
            // Get doctor revenue with full information
            List<Map<String, Object>> doctorRevenue = appointmentService.getDoctorRevenueReport(startDate, endDate);
            log.info("Found doctor revenue data for overview: {}", doctorRevenue);
            stats.put("doctorRevenue", doctorRevenue);
            
            return ResponseEntity.ok(stats);
        } catch (Exception e) {
            log.error("Error getting dashboard overview: ", e);
            return ResponseEntity.badRequest().body(Collections.singletonMap("error", "Có lỗi xảy ra khi tải dữ liệu tổng quan: " + e.getMessage()));
        }
    }
}