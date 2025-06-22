package project.springBoot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;  
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.ui.Model;
import project.springBoot.model.Doctor;
import project.springBoot.repository.DoctorRepository;
import java.util.List;

@Controller
@RequestMapping("/search")
public class SearchController {

    @Autowired
    private DoctorRepository doctorRepository;

    @GetMapping("/specialties")
    public String searchDoctorsBySpec(
            @RequestParam(required = false) String keyword,
            Model model) {

        if (keyword != null && !keyword.trim().isEmpty()) {
            String searchTerm = keyword.trim();

            List<Doctor> doctorsBySpecialty = doctorRepository.findBySpecializationName(searchTerm);

            model.addAttribute("doctors", doctorsBySpecialty);
            model.addAttribute("searchKeyword", keyword);
        }
        return "doctor/searchDoctors";
    }

    @GetMapping("/doctors")
    public String searchDoctorByName(
            @RequestParam(required = false) String keyword,
            Model model) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            String searchTerm = keyword.trim();
            List<Doctor> doctorsByName = doctorRepository.findByName(searchTerm);
            model.addAttribute("doctors", doctorsByName);
            model.addAttribute("searchKeyword", keyword);
        }
        return "doctor/searchDoctors";
    }

    @GetMapping("/doctors/details/{id}")
    public String getDoctorDetails(@PathVariable Long id, Model model) {
        Doctor doctor = doctorRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Doctor not found"));
        model.addAttribute("doctor", doctor);
        return "doctor/detailsDoctors";
    }

}
