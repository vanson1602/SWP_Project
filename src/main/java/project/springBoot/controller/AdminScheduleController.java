package project.springBoot.controller;

import project.springBoot.model.Doctor;
import project.springBoot.model.DoctorSchedule;
import project.springBoot.repository.DoctorRepository;
import project.springBoot.service.DoctorScheduleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/admin/schedules")
public class AdminScheduleController {

    @Autowired
    private DoctorScheduleService doctorScheduleService;

    @Autowired
    private DoctorRepository doctorRepository;

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
        Doctor doctor = doctorRepository.findById(doctorId).orElse(null);
        model.addAttribute("schedules", schedules);
        model.addAttribute("doctor", doctor);
        return "admin/schedules/doctor_schedules";
    }

}