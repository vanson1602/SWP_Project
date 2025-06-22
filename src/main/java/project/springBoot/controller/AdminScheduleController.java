package project.springBoot.controller;

import project.springBoot.model.Doctor;
import project.springBoot.model.DoctorSchedule;
import project.springBoot.model.User;
import project.springBoot.repository.DoctorRepository;
import project.springBoot.service.DoctorScheduleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import project.springBoot.service.EmailService;

import jakarta.servlet.http.HttpSession;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin/schedules")
public class AdminScheduleController {

    @Autowired
    private DoctorScheduleService doctorScheduleService;

    @Autowired
    private DoctorRepository doctorRepository;

    @Autowired
    private EmailService emailService;

    @GetMapping("/list")
    public String getAllSchedules(Model model) {
        List<DoctorSchedule> schedules = doctorScheduleService.getAllSchedules();
        model.addAttribute("schedules", schedules);
        return "admin/schedules/list";
    }

    @GetMapping("/add")
    public String showAddForm(Model model) {
        List<Doctor> doctors = doctorRepository.findAll();
        model.addAttribute("schedule", new DoctorSchedule());
        model.addAttribute("doctors", doctorRepository.findAll()); // truyền danh sách bác sĩ
        return "admin/schedules/add";
    }

    @PostMapping("/save")
    public String saveSchedule(@ModelAttribute DoctorSchedule schedule) {
        doctorScheduleService.createSchedule(schedule);
        return "redirect:/admin/schedules/doctors";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable int id, Model model) {
        DoctorSchedule schedule = doctorScheduleService.getScheduleById(id);
        model.addAttribute("schedule", schedule);
        return "admin/schedules/edit";
    }

    @GetMapping("/delete/{id}")
    public String deleteSchedule(@PathVariable int id) {
        doctorScheduleService.deleteSchedule(id);
        return "redirect:/admin/schedules/list";
    }

    @PostMapping("/update")
    public String updateSchedule(@ModelAttribute DoctorSchedule schedule) {
        doctorScheduleService.updateSchedule(schedule.getScheduleID(), schedule);
        return "redirect:/admin/schedules/list";
    }

    @GetMapping("/doctors")
    public String getAllDoctors(Model model) {
        List<Doctor> doctors = doctorRepository.findAll();
        model.addAttribute("doctors", doctors);
        return "admin/schedules/doctors_list";
    }

    @GetMapping("/doctor/{doctorId}")
    public String getSchedulesByDoctor(@PathVariable int doctorId, Model model) {
        List<DoctorSchedule> schedules = doctorScheduleService.getSchedulesByDoctorId(doctorId);
        Doctor doctor = doctorRepository.findByDoctorID(doctorId);
        model.addAttribute("schedules", schedules);
        model.addAttribute("doctor", doctor);
        return "admin/schedules/doctor_schedules";
    }

    @GetMapping("/processing")
    public String viewPendingSchedules(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"ADMIN".equalsIgnoreCase(currentUser.getRole())) {
            return "redirect:/login";
        }
        List<DoctorSchedule> pendingSchedules = doctorScheduleService.getPendingSchedules();
        System.out.println("Pending Schedules count: " + pendingSchedules.size());
        model.addAttribute("pendingSchedules", pendingSchedules);
        model.addAttribute("currentUser", currentUser);
        return "admin/admin-schedules";
    }

    @PostMapping("/approve-schedule")
    @ResponseBody
    public Map<String, Object> approveSchedule(@RequestBody Map<String, Long> request, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            Long scheduleId = request.get("scheduleId");
            if (scheduleId == null) {
                throw new IllegalArgumentException("Schedule ID is required");
            }
            DoctorSchedule schedule = doctorScheduleService.updateScheduleStatus(scheduleId, "Busy");
            if (schedule == null) {
                throw new RuntimeException("Schedule not found or update failed");
            }
            emailService.sendScheduleApprovalEmail(schedule.getDoctor().getUser().getEmail(), schedule, true);
            response.put("success", true);
            response.put("message", "Lịch bận đã được phê duyệt");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi khi phê duyệt: " + e.getMessage());
        }
        return response;
    }

    @PostMapping("/reject-schedule")
    @ResponseBody
    public Map<String, Object> rejectSchedule(@RequestBody Map<String, Long> request, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            Long scheduleId = request.get("scheduleId");
            if (scheduleId == null) {
                throw new IllegalArgumentException("Schedule ID is required");
            }
            DoctorSchedule schedule = doctorScheduleService.updateScheduleStatus(scheduleId, "Available");
            if (schedule == null) {
                throw new RuntimeException("Schedule not found or update failed");
            }
            emailService.sendScheduleApprovalEmail(schedule.getDoctor().getUser().getEmail(), schedule, false);
            response.put("success", true);
            response.put("message", "Lịch bận đã bị từ chối");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi khi từ chối: " + e.getMessage());
        }
        return response;
    }

}