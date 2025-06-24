package project.springBoot.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import project.springBoot.model.Doctor;
import project.springBoot.model.DoctorBookingSlot;
import project.springBoot.model.Patient;
import project.springBoot.repository.*;
import project.springBoot.service.DoctorService;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import org.hibernate.Hibernate;

@Service
@Transactional
@RequiredArgsConstructor
public class DoctorServiceImpl implements DoctorService {
    private final DoctorRepository doctorRepository;
    private final DoctorBookingSlotRepository bookingSlotRepository;
    private final PatientRepository patientRepository;
    private final UserRepository userRepository;

    @Override
    public List<Doctor> getDoctorsBySpecialization(Long specializationId) {
        List<Doctor> doctors = doctorRepository.findBySpecializationsSpecializationID(specializationId);
        for (Doctor doctor : doctors) {
            Hibernate.initialize(doctor.getFeedbacks());
            Hibernate.initialize(doctor.getUser());
        }
        return doctors;
    }

    @Override
    public List<DoctorBookingSlot> getAvailableSlots(Long doctorId, LocalDate date) {
        LocalDateTime startTime = date.atStartOfDay();
        LocalDateTime endTime = date.plusDays(1).atStartOfDay();

        return bookingSlotRepository.findAvailableSlotsByDoctorAndTimeRange(doctorId, startTime, endTime);
    }

    @Override
    public DoctorBookingSlot getSlotById(Long slotId) {
        return bookingSlotRepository.findById(slotId)
                .orElseThrow(() -> new RuntimeException("Slot not found"));
    }

    @Override
    public Patient getPatientByUsername(String username) {
        return patientRepository.findByUserUsername(username)
                .orElseThrow(() -> new RuntimeException("Patient not found"));
    }

    @Override
    public Doctor getDoctorById(Long doctorId) {
        Doctor doctor = doctorRepository.findByIdWithFeedback(doctorId)
                .orElseThrow(() -> new RuntimeException("Doctor not found"));
        // Initialize the specializations if needed
        Hibernate.initialize(doctor.getSpecializations());
        return doctor;
    }

    @Override
    public Doctor save(Doctor doctor) {
        if (doctor.getUser() == null) {
            throw new IllegalArgumentException("Doctor must have an associated user");
        }

        // Set creation/modification timestamps
        LocalDateTime now = LocalDateTime.now();
        doctor.setCreatedAt(now);
        doctor.setModifiedAt(now);

        // Initialize collections if they're null
        if (doctor.getSpecializations() == null) {
            doctor.setSpecializations(new java.util.HashSet<>());
        }
        if (doctor.getSchedules() == null) {
            doctor.setSchedules(new java.util.HashSet<>());
        }
        if (doctor.getFeedbacks() == null) {
            doctor.setFeedbacks(new java.util.HashSet<>());
        }

        // Save the doctor
        return doctorRepository.save(doctor);
    }
}
