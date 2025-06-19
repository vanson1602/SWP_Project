package project.springBoot.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import project.springBoot.model.Medication;
import project.springBoot.service.MedicationService;

@RestController
@RequestMapping("/api/medications")
public class MedicationController {

    @Autowired
    private MedicationService medicationService;

    @GetMapping
    public ResponseEntity<List<Medication>> getAllMedications() {
        List<Medication> medications = medicationService.getAllMedications();
        System.out.println("Found " + medications.size() + " medications");
        medications.forEach(med -> System.out.println("Medication: " + med.getMedicationName()));
        return ResponseEntity.ok(medications);
    }

    @GetMapping("/search")
    public ResponseEntity<List<Medication>> searchMedications(@RequestParam String name) {
        if (name == null || name.trim().isEmpty()) {
            List<Medication> allMeds = medicationService.getAllMedications();
            System.out.println("Returning all " + allMeds.size() + " medications for empty search");
            return ResponseEntity.ok(allMeds);
        }
        
        List<Medication> medications = medicationService.findByNameContaining(name.trim());
        System.out.println("Found " + medications.size() + " medications matching: " + name);
        return ResponseEntity.ok(medications);
    }
} 