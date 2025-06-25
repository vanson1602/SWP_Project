package project.springBoot.service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import project.springBoot.model.Doctor;
import project.springBoot.model.DoctorBookingSlot;
import project.springBoot.model.Patient;

@Service
public interface DoctorService {
        List<Doctor> getDoctorsBySpecialization(Long specializationId);

        List<DoctorBookingSlot> getAvailableSlots(Long doctorId, LocalDate date);

        DoctorBookingSlot getSlotById(Long slotId);

        Patient getPatientByUsername(String username);

        Doctor getDoctorById(Long doctorId);

        Optional<Doctor> findByUserId(long userId);

        Doctor getDoctorByUserId(long userId);

        Doctor save(Doctor doctor);

        List<Doctor> findDoctorByName(String keyword, String[] specializationNames, Integer experienceYears,
                        BigDecimal consultationFee);

        List<Doctor> findDoctorBySpecility(String keyword, String[] specializationNames, Integer experienceYears,
                        BigDecimal consultationFee);

        Doctor findById(Long id);

}