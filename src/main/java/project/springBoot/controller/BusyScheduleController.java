package project.springBoot.controller;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;
import project.springBoot.model.Doctor;
import project.springBoot.model.DoctorSchedule;
import project.springBoot.model.User;
import project.springBoot.service.DoctorScheduleService;
import project.springBoot.service.DoctorService;
import project.springBoot.service.UserService;

@Controller
@RequestMapping("/doctor/busy")
public class BusyScheduleController {

    @Autowired
    private DoctorScheduleService doctorScheduleService;

    @Autowired
    private UserService userService;

    @Autowired
    private DoctorService doctorService;

    @GetMapping("/schedule")
    public String viewBusyScheduleForm(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"DOCTOR".equalsIgnoreCase(currentUser.getRole())) {
            return "redirect:/login";
        }
        Long doctorId = (Long) session.getAttribute("doctorId");
        if (doctorId == null) {
            doctorId = userService.getDoctorIdByUserId(currentUser.getUserID());
            if (doctorId != null) {
                session.setAttribute("doctorId", doctorId);
            } else {
                return "redirect:/access-denied";
            }
        }
        model.addAttribute("currentUser", currentUser);
        return "doctors/doctor-busy-schedule";
    }

    @PostMapping("/submit-busy-schedule")
    @ResponseBody
    public Map<String, Object> submitBusySchedule(@RequestBody DoctorScheduleRequest request, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null || !"DOCTOR".equalsIgnoreCase(currentUser.getRole())) {
                response.put("success", false);
                response.put("message", "Unauthorized access");
                return response;
            }

            Long doctorId = (Long) session.getAttribute("doctorId");
            if (doctorId == null) {
                doctorId = userService.getDoctorIdByUserId(currentUser.getUserID());
                if (doctorId != null) {
                    session.setAttribute("doctorId", doctorId);
                } else {
                    throw new IllegalStateException("Doctor ID not found");
                }
            }

            Doctor doctor = doctorService.findById(doctorId);
            if (doctor == null) {
                throw new IllegalStateException("Doctor not found");
            }

            DoctorSchedule schedule = new DoctorSchedule();
            schedule.setDoctor(doctor);
            schedule.setWorkDate(request.workDate());
            schedule.setStartTime(request.startTime());
            schedule.setEndTime(request.endTime());
            schedule.setStatus("Processing");

            DoctorSchedule savedSchedule = doctorScheduleService.saveSchedule(schedule);
            response.put("success", true);
            response.put("message", "Lịch bận đã được gửi thành công");
            response.put("scheduleId", savedSchedule.getScheduleID());
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi khi gửi lịch bận: " + e.getMessage());
            e.printStackTrace();
        }
        return response;
    }
}

record DoctorScheduleRequest(
        LocalDate workDate,
        LocalTime startTime,
        LocalTime endTime) {
}