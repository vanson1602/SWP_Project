package project.springBoot.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import project.springBoot.model.DoctorBookingSlot;
import project.springBoot.repository.DoctorBookingSlotRepository;

@Service
public class DoctorBookingSlotService {

    @Autowired
    private DoctorBookingSlotRepository bookingSlotRepository;

    public List<DoctorBookingSlot> getBookingSlotsByScheduleId(Long scheduleId) {
        return bookingSlotRepository.findAll(); // Placeholder
    }

    public List<DoctorBookingSlot> getBookingSlotsByDoctorId(Long doctorId) {
        return bookingSlotRepository.findByScheduleDoctorDoctorID(doctorId);
    }

    public DoctorBookingSlot save(DoctorBookingSlot slot) {
        return bookingSlotRepository.save(slot);
    }

    public DoctorBookingSlot findById(Long id) {
        return bookingSlotRepository.findById(id).orElse(null);
    }

    public void deleteById(Long id) {
        bookingSlotRepository.deleteById(id);
    }

    
}