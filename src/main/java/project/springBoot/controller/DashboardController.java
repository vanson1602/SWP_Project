package project.springBoot.controller;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import project.springBoot.service.AppointmentService;

@RestController
@RequestMapping("/api/dashboard")
public class DashboardController {

    @Autowired
    private AppointmentService appointmentService;

    @GetMapping("/daily-stats")
    public ResponseEntity<?> getDailyStats(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss") LocalDateTime startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss") LocalDateTime endDate) {
        try {
            List<Map<String, Object>> stats = appointmentService.getDailyAppointmentReport(startDate, endDate);
            return ResponseEntity.ok(stats);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Có lỗi xảy ra khi tải dữ liệu thống kê: " + e.getMessage());
        }
    }

    @GetMapping("/monthly-stats")
    public ResponseEntity<?> getMonthlyStats(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss") LocalDateTime startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss") LocalDateTime endDate) {
        try {
            List<Map<String, Object>> stats = appointmentService.getMonthlyAppointmentReport(startDate, endDate);
            return ResponseEntity.ok(stats);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Có lỗi xảy ra khi tải dữ liệu thống kê: " + e.getMessage());
        }
    }

    @GetMapping("/overview")
    public ResponseEntity<?> getDashboardOverview() {
        try {
            Map<String, Object> stats = appointmentService.getDashboardStatistics();
            return ResponseEntity.ok(stats);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Có lỗi xảy ra khi tải dữ liệu tổng quan: " + e.getMessage());
        }
    }
} 