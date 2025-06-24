package project.springBoot.controller;

import project.springBoot.model.Doctor;
import project.springBoot.model.DoctorSchedule;
import project.springBoot.model.User;
import project.springBoot.repository.DoctorRepository;
import project.springBoot.service.DoctorScheduleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
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
        try {
            List<DoctorSchedule> schedules = doctorScheduleService.getAllSchedules();
            for (DoctorSchedule schedule : schedules) {
                schedule.setBookingSlots(
                        doctorScheduleService.getScheduleWithSlots(schedule.getScheduleID()).getBookingSlots());
            }
            model.addAttribute("schedules", schedules);
        } catch (Exception e) {
            System.out.println("Error loading schedules: " + e.getMessage());
            model.addAttribute("error", "Failed to load schedules: " + e.getMessage());
            return "error";
        }
        return "admin/schedules/list";
    }

    @GetMapping("/add")
    public String showAddForm(Model model) {
        List<Doctor> doctors = doctorRepository.findAll();
        model.addAttribute("schedule", new DoctorSchedule());
        model.addAttribute("doctors", doctors);
        return "admin/schedules/add";
    }

    @PostMapping("/save")
    public String saveSchedule(@ModelAttribute DoctorSchedule schedule, Model model) {
        List<Doctor> doctors = doctorRepository.findAll();
        model.addAttribute("doctors", doctors);
        try {
            List<DoctorSchedule> existingSchedules = doctorScheduleService
                    .getSchedulesByDoctorId(schedule.getDoctor().getDoctorID());
            for (DoctorSchedule existing : existingSchedules) {
                if (existing.getWorkDate().equals(schedule.getWorkDate())) {
                    model.addAttribute("error",
                            "Schedule creation failed: A schedule for this doctor on the selected date already exists. Please choose a different date.");
                    model.addAttribute("schedule", schedule);
                    return "admin/schedules/add";
                }
            }
            doctorScheduleService.createSchedule(schedule);
        } catch (DataIntegrityViolationException e) {
            model.addAttribute("error",
                    "Schedule creation failed: A schedule for this doctor on the selected date already exists. Please choose a different date.");
            model.addAttribute("schedule", schedule);
            return "admin/schedules/add";
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", "Schedule creation failed: " + e.getMessage());
            model.addAttribute("schedule", schedule);
            return "admin/schedules/add";
        } catch (Exception e) {
            model.addAttribute("error", "Schedule creation failed due to an unexpected error: " + e.getMessage());
            model.addAttribute("schedule", schedule);
            return "admin/schedules/add";
        }
        return "redirect:/admin/schedules/list";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable long id, Model model) {
        DoctorSchedule schedule = doctorScheduleService.getScheduleById(id);
        schedule.setBookingSlots(doctorScheduleService.getScheduleWithSlots(id).getBookingSlots());
        model.addAttribute("schedule", schedule);
        return "admin/schedules/edit";
    }

    @GetMapping("/delete/{id}")
    public String deleteSchedule(@PathVariable long id) {
        doctorScheduleService.deleteSchedule(id);
        return "redirect:/admin/schedules/list";
    }

    @PostMapping("/update")
    public String updateSchedule(@ModelAttribute DoctorSchedule schedule, Model model) {
        try {
            doctorScheduleService.updateSchedule(schedule.getScheduleID(), schedule);
        } catch (DataIntegrityViolationException e) {
            model.addAttribute("error",
                    "Schedule update failed: A schedule for this doctor on the selected date already exists. Please choose a different date.");
            model.addAttribute("schedule", schedule);
            return "admin/schedules/edit";
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", "Schedule update failed: " + e.getMessage());

            model.addAttribute("schedule", schedule);
            return "admin/schedules/edit";
        } catch (Exception e) {
            model.addAttribute("error", "Schedule update failed due to an unexpected error: " + e.getMessage());
            model.addAttribute("schedule", schedule);
            return "admin/schedules/edit";
        }
        return "redirect:/admin/schedules/list";
    }

    @GetMapping("/doctors")
    public String getAllDoctors(Model model) {
        List<Doctor> doctors = doctorRepository.findAll();
        model.addAttribute("doctors", doctors);
        return "admin/schedules/doctors_list";
    }

    @GetMapping("/doctor/{doctorId}")
    public String getSchedulesByDoctor(@PathVariable long doctorId, Model model) {
        List<DoctorSchedule> schedules = doctorScheduleService.getSchedulesByDoctorId(doctorId);
        for (DoctorSchedule schedule : schedules) {
            schedule.setBookingSlots(
                    doctorScheduleService.getScheduleWithSlots(schedule.getScheduleID()).getBookingSlots());
        }
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
        for (DoctorSchedule schedule : pendingSchedules) {
            schedule.setBookingSlots(
                    doctorScheduleService.getScheduleWithSlots(schedule.getScheduleID()).getBookingSlots());
        }
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