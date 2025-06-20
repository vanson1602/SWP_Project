package project.springBoot.service;

import project.springBoot.model.Doctor;
import project.springBoot.model.DoctorBookingSlot;
import project.springBoot.model.Patient;
import java.time.LocalDate;
import java.util.List;

public interface DoctorService {
    List<Doctor> getDoctorsBySpecialization(Long specializationId);

    List<DoctorBookingSlot> getAvailableSlots(Long doctorId, LocalDate date);

    DoctorBookingSlot getSlotById(Long slotId);

    Patient getPatientByUsername(String username);

    Doctor getDoctorById(Long doctorId);
}