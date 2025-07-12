package project.springBoot.service.impl;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import org.hibernate.Hibernate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import project.springBoot.model.Doctor;
import project.springBoot.model.DoctorBookingSlot;
import project.springBoot.model.Patient;
import project.springBoot.repository.DoctorBookingSlotRepository;
import project.springBoot.repository.DoctorRepository;
import project.springBoot.repository.PatientRepository;
import project.springBoot.repository.UserRepository;
import project.springBoot.service.DoctorService;

@Service
@Transactional
@RequiredArgsConstructor
public class DoctorServiceImpl implements DoctorService {
    private final DoctorRepository doctorRepository;
    private final DoctorBookingSlotRepository bookingSlotRepository;
    private final PatientRepository patientRepository;
    private final UserRepository userRepository;
    private static final Logger logger = LoggerFactory.getLogger(DoctorServiceImpl.class);

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
        LocalDateTime currentTime = LocalDateTime.now();

        // Block any past slots that are still marked as available
        List<DoctorBookingSlot> pastSlots = bookingSlotRepository.findPastAvailableSlots(currentTime);
        for (DoctorBookingSlot slot : pastSlots) {
            slot.setStatus("Blocked");
            slot.setModifiedAt(LocalDateTime.now());
            bookingSlotRepository.save(slot);
        }

        // Only return slots that are in the future
        return bookingSlotRepository.findAvailableSlotsByDoctorAndTimeRange(doctorId,
                currentTime.isAfter(startTime) ? currentTime : startTime,
                endTime);
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
    public Optional<Doctor> findByUserId(long userId) {
        return doctorRepository.findByUserId(userId);
    }

    @Override
    public Doctor getDoctorByUserId(long userId) {
        return doctorRepository.findByUserId(userId).orElse(null);
    }


    @Override
    public Doctor findById(Long id) {
        return doctorRepository.findById(id).orElse(null);
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

    private Set<String> parseSpecializations(String[] specializationNames) {
        if (specializationNames == null || specializationNames.length == 0) {
            return null;
        }
        return new HashSet<>(Arrays.asList(specializationNames));
    }

    @Override
    public List<Doctor> findDoctorByName(String keyword, String[] specializationNames, Integer experienceYears,
            BigDecimal consultationFee) {
        logger.info("Searching doctors by name with parameters:");
        logger.info("Keyword: {}", keyword);
        logger.info("Specializations: {}", Arrays.toString(specializationNames));
        logger.info("Experience Years: {}", experienceYears);
        logger.info("Consultation Fee: {}", consultationFee);

        Set<String> specializations = parseSpecializations(specializationNames);
        List<Doctor> doctors = doctorRepository.findDoctorsAdvanced(keyword, specializations, experienceYears,
                consultationFee);
        logger.info("Found {} doctors", doctors.size());
        return doctors;
    }

    @Override
    public List<Doctor> findDoctorBySpecility(String keyword, String[] specializationNames, Integer experienceYears,
            BigDecimal consultationFee) {
        logger.info("Searching doctors by specialty with parameters:");
        logger.info("Keyword: {}", keyword);
        logger.info("Specializations: {}", Arrays.toString(specializationNames));
        logger.info("Experience Years: {}", experienceYears);
        logger.info("Consultation Fee: {}", consultationFee);

        Set<String> specializations = parseSpecializations(specializationNames);
        List<Doctor> doctors = doctorRepository.findDoctorsAdvanced(keyword, specializations, experienceYears,
                consultationFee);
        logger.info("Found {} doctors", doctors.size());
        return doctors;
    }
}
