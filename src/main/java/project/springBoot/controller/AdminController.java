package project.springBoot.controller;

import java.time.DayOfWeek;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

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

    @GetMapping("/dashboard")
    public String getDashboard(@RequestParam(defaultValue = "day") String filter, Model model) {
        try {
            LocalDateTime now = LocalDateTime.now();
            LocalDateTime startDate;
            LocalDateTime endDate;
            List<Map<String, Object>> chartData;

            log.info("Processing dashboard request with filter: {}", filter);

            switch (filter.toLowerCase()) {
                case "week":
                    startDate = now.with(DayOfWeek.MONDAY).toLocalDate().atStartOfDay();
                    endDate = startDate.plusDays(6).with(LocalTime.MAX);
                    chartData = appointmentService.getDailyAppointmentReport(startDate, endDate);
                    break;
                case "month":
                    startDate = now.withDayOfMonth(1).toLocalDate().atStartOfDay();
                    endDate = startDate.plusMonths(1).minusNanos(1);
                    chartData = appointmentService.getMonthlyAppointmentReport(now.minusMonths(5).withDayOfMonth(1).toLocalDate().atStartOfDay(), endDate);
                    break;
                case "day":
                default:
                    startDate = now.toLocalDate().atStartOfDay();
                    endDate = LocalDateTime.of(now.toLocalDate(), LocalTime.MAX);
                    chartData = appointmentService.getDailyAppointmentReport(now.minusDays(6).toLocalDate().atStartOfDay(), endDate);
                    break;
            }

            log.info("Fetching data from {} to {} for filter {}", startDate, endDate, filter);

            long totalAppointments = appointmentService.getDistinctAppointmentsCompletedBetween(startDate, endDate);
            long totalPatients = appointmentService.getDistinctPatientsCompletedBetween(startDate, endDate);
            double totalRevenue = appointmentService.getRevenueBetween(startDate, endDate);
            
            Map<String, Long> rawStatusDistribution = appointmentService.getAppointmentStatusDistributionBetween(startDate, endDate);
            Map<String, Long> orderedStatusDistribution = new LinkedHashMap<>();
            String[] statusOrder = {"PENDING", "CONFIRMED", "COMPLETED", "CANCELLED", "REJECTED"};
            
            log.info("Raw status distribution: {}", rawStatusDistribution);
            
            for (String status : statusOrder) {
                Long count = rawStatusDistribution.get(status);
                if (count == null) {
                    count = rawStatusDistribution.get(status.toLowerCase());
                }
                if (count == null) {
                    count = rawStatusDistribution.get(status.substring(0, 1).toUpperCase() + status.substring(1).toLowerCase());
                }
                
                if (count != null && count > 0) {
                    orderedStatusDistribution.put(status, count);
                }
            }
            
            log.info("Ordered status distribution: {}", orderedStatusDistribution);
            
            List<Map<String, Object>> doctorRevenue = appointmentService.getDoctorRevenueReport(startDate, endDate);
            log.info("Found doctor revenue data: {}", doctorRevenue);

            try {
                String dailyStatsJson = objectMapper.writeValueAsString(chartData != null ? chartData : Collections.emptyList());
                String statusDistributionJson = objectMapper.writeValueAsString(orderedStatusDistribution != null ? orderedStatusDistribution : Collections.emptyMap());
                model.addAttribute("dailyStatsJson", dailyStatsJson);
                model.addAttribute("statusDistributionJson", statusDistributionJson);
            } catch (Exception e) {
                log.warn("Error serializing JSON data: {}", e.getMessage());
                model.addAttribute("dailyStatsJson", "[]");
                model.addAttribute("statusDistributionJson", "{}");
            }

            model.addAttribute("totalPatients", totalPatients);
            model.addAttribute("totalAppointments", totalAppointments);
            model.addAttribute("totalRevenue", totalRevenue);
            model.addAttribute("filter", filter);
            model.addAttribute("doctorRevenue", doctorRevenue != null ? doctorRevenue : Collections.emptyList());

            return "admin/dashboard";
        } catch (Exception e) {
            log.error("Error in getDashboard for filter {}: {}", filter, e.getMessage(), e);
            model.addAttribute("error", "Có lỗi xảy ra khi tải dữ liệu thống kê: " + e.getMessage());
            setDefaultModelAttributes(model);
            return "admin/dashboard";
        }
    }

    private void setDefaultModelAttributes(Model model) {
        model.addAttribute("totalPatients", 0L);
        model.addAttribute("totalAppointments", 0L);
        model.addAttribute("totalRevenue", 0.0);
        model.addAttribute("dailyStatsJson", "[]");
        model.addAttribute("statusDistributionJson", "{}");
        model.addAttribute("doctorRevenue", Collections.emptyList());
        model.addAttribute("filter", "day");
    }
}