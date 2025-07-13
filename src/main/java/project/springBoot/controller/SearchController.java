package project.springBoot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.ui.Model;
import project.springBoot.model.Doctor;
import project.springBoot.model.Specialization;

import project.springBoot.service.DoctorService;
import project.springBoot.service.SpecializationService;

import java.math.BigDecimal;
import java.util.List;
import java.util.Arrays;

@Controller
@RequestMapping("/search")
public class SearchController {

        @Autowired
        private DoctorService doctorService;

        @Autowired
        private SpecializationService specializationService;

        @GetMapping("/specialties")
        public String searchDoctorsBySpec(
                        @RequestParam(required = false) String keyword,
                        @RequestParam(required = false) String[] specializationName,
                        @RequestParam(required = false) Integer experienceYears,
                        @RequestParam(required = false) BigDecimal consultationFee,
                        Model model) {

                List<Doctor> doctorsBySpecialty = doctorService.findDoctorBySpecility(keyword, specializationName,
                                experienceYears, consultationFee);

                // Get all active specializations from database
                List<Specialization> specializations = specializationService.getAllActiveSpecializations();

                model.addAttribute("doctors", doctorsBySpecialty);
                model.addAttribute("specializations", specializations);
                model.addAttribute("searchKeyword", keyword);
                model.addAttribute("currentPath", "/search/specialties");
                model.addAttribute("searchType", "specialty");
                model.addAttribute("selectedSpecializations",
                                specializationName != null ? Arrays.asList(specializationName) : null);

                return "doctor/searchDoctors";
        }

        @GetMapping("/doctors")
        public String searchDoctorByName(
                        @RequestParam(required = false) String keyword,
                        @RequestParam(required = false) String[] specializationName,
                        @RequestParam(required = false) Integer experienceYears,
                        @RequestParam(required = false) BigDecimal consultationFee,
                        Model model) {

                List<Doctor> doctorsByName = doctorService.findDoctorByName(keyword, specializationName,
                                experienceYears,
                                consultationFee);

                // Get all active specializations from database
                List<Specialization> specializations = specializationService.getAllActiveSpecializations();

                model.addAttribute("doctors", doctorsByName);
                model.addAttribute("specializations", specializations);
                model.addAttribute("searchKeyword", keyword);
                model.addAttribute("currentPath", "/search/doctors");
                model.addAttribute("searchType", "doctor");
                model.addAttribute("selectedSpecializations",
                                specializationName != null ? Arrays.asList(specializationName) : null);

                return "doctor/searchDoctors";
        }

        @GetMapping("/doctors/details/{id}")
        public String getDoctorDetails(@PathVariable Long id, Model model) {
                Doctor doctor = doctorService.getDoctorById(id);
                model.addAttribute("doctor", doctor);
                return "doctor/detailsDoctors";
        }

}
