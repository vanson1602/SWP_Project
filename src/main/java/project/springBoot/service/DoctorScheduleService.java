package project.springBoot.service;

import project.springBoot.model.DoctorBookingSlot;
import project.springBoot.model.DoctorSchedule;
import project.springBoot.repository.DoctorScheduleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Optional;

@Service
public class DoctorScheduleService {

    @Autowired
    private DoctorScheduleRepository doctorScheduleRepository;
    @Autowired
    private DoctorBookingSlotService bookingSlotService;

    public DoctorSchedule createSchedule(DoctorSchedule schedule) {
        validateScheduleTimes(schedule);
        checkForOverlaps(schedule);
        schedule.setCreatedAt(LocalDateTime.now());
        schedule.setModifiedAt(LocalDateTime.now());
        DoctorSchedule savedSchedule = doctorScheduleRepository.save(schedule);
        generateAndSaveSlots(savedSchedule);
        if ("Available".equals(schedule.getStatus())) {
            generateAndSaveSlots(savedSchedule);
        }
        return savedSchedule;
    }

    public DoctorSchedule updateSchedule(long scheduleID, DoctorSchedule updatedSchedule) {
        Optional<DoctorSchedule> existingSchedule = doctorScheduleRepository.findById(scheduleID);
        if (existingSchedule.isPresent()) {
            DoctorSchedule schedule = existingSchedule.get();
            schedule.setWorkDate(updatedSchedule.getWorkDate());
            schedule.setStartTime(updatedSchedule.getStartTime());
            schedule.setEndTime(updatedSchedule.getEndTime());
            schedule.setStatus(updatedSchedule.getStatus());
            schedule.setMaxPatients(updatedSchedule.getMaxPatients());
            schedule.setClinicRoom(updatedSchedule.getClinicRoom());
            schedule.setNotes(updatedSchedule.getNotes());
            schedule.setModifiedAt(LocalDateTime.now());

            validateScheduleTimes(schedule);
            checkForOverlaps(schedule);
            if ("Available".equals(updatedSchedule.getStatus())) {
                bookingSlotService.deleteByScheduleId(scheduleID);
                generateAndSaveSlots(schedule);
            } else {
                bookingSlotService.deleteByScheduleId(scheduleID);
            }
            return doctorScheduleRepository.save(schedule);
        }
        return null;
    }

    public List<DoctorSchedule> getAllSchedules() {
        return doctorScheduleRepository.findAll();
    }

    public DoctorSchedule getScheduleById(long scheduleID) {
        return doctorScheduleRepository.findById(scheduleID).orElse(null);
    }

    public void deleteSchedule(long id) {
        doctorScheduleRepository.deleteById(id);
    }

    public List<DoctorSchedule> getSchedulesByDoctorId(long doctorId) {
        return doctorScheduleRepository.findByDoctorDoctorID(doctorId);
    }

    public List<DoctorSchedule> getSchedulesByDoctorSorted(long doctorId) {
        return doctorScheduleRepository.findByDoctorDoctorIDOrderByWorkDateAscStartTimeAsc(doctorId);
    }

    public DoctorSchedule saveSchedule(DoctorSchedule schedule) {
        if (schedule.getStatus() == null || schedule.getStatus().trim().isEmpty()) {
            schedule.setStatus("Processing");
        }
        return doctorScheduleRepository.save(schedule);
    }

    public DoctorSchedule updateScheduleStatus(Long scheduleId, String status) {
        DoctorSchedule schedule = doctorScheduleRepository.findById(scheduleId)
                .orElseThrow(() -> new RuntimeException("Schedule not found with ID: " + scheduleId));
        schedule.setStatus(status);
        schedule.setModifiedAt(LocalDateTime.now());

        if ("Busy".equals(status)) { // Generate slots only when approved
            bookingSlotService.deleteByScheduleId(scheduleId);
        } else if ("Available".equals(status)) { // Clear slots when rejected
            generateAndSaveSlots(schedule);
        }

        return doctorScheduleRepository.save(schedule);
    }

    public List<DoctorSchedule> getPendingSchedules() {
        return doctorScheduleRepository.findByStatus("Processing");
    }

    public List<DoctorSchedule> getSchedulesByDoctorSorted2(Long doctorId) {
        return doctorScheduleRepository.findByDoctorIdAndStatus(doctorId, null);
    }

    private void validateScheduleTimes(DoctorSchedule schedule) {
        if (schedule.getStartTime().isAfter(schedule.getEndTime())) {
            throw new IllegalArgumentException("Start time must be before end time");
        }
        long hours = ChronoUnit.HOURS.between(
                schedule.getWorkDate().atTime(schedule.getStartTime()),
                schedule.getWorkDate().atTime(schedule.getEndTime()));
        if (hours <= 0) {
            throw new IllegalArgumentException("Schedule must span at least 1 hour");
        }
    }

    private void generateAndSaveSlots(DoctorSchedule schedule) {
        LocalDateTime start = schedule.getWorkDate().atTime(schedule.getStartTime());
        LocalDateTime end = schedule.getWorkDate().atTime(schedule.getEndTime());
        System.out.println(
                "Generating slots for schedule ID: " + schedule.getScheduleID() + " from " + start + " to " + end);
        while (!start.isAfter(end.minusHours(1))) {
            DoctorBookingSlot slot = new DoctorBookingSlot();
            slot.setSchedule(schedule);
            slot.setStartTime(start);
            slot.setEndTime(start.plusHours(1));
            slot.setStatus("Available");
            slot.setCreatedAt(LocalDateTime.now());
            slot.setModifiedAt(LocalDateTime.now());
            bookingSlotService.save(slot);
            System.out.println("Saved slot: " + slot.getStartTime() + " to " + slot.getEndTime());
            start = start.plusHours(1);
        }
    }

    public DoctorSchedule getScheduleWithSlots(long scheduleID) {
        Optional<DoctorSchedule> scheduleOpt = doctorScheduleRepository.findByIdWithSlots(scheduleID);
        if (scheduleOpt.isEmpty()) {
            System.out.println("Schedule not found for ID: " + scheduleID); // Add logging
            throw new RuntimeException("Schedule not found: " + scheduleID);
        }
        return scheduleOpt.get();
    }

    private void checkForOverlaps(DoctorSchedule schedule) {
        if (schedule.getDoctor() == null || schedule.getDoctor().getDoctorID() <= 0) {
            throw new IllegalArgumentException("Doctor information is invalid");
        }
        List<DoctorSchedule> existingSchedules = doctorScheduleRepository
                .findByDoctorDoctorID(schedule.getDoctor().getDoctorID());
        LocalDateTime newStart = schedule.getWorkDate().atTime(schedule.getStartTime());
        LocalDateTime newEnd = schedule.getWorkDate().atTime(schedule.getEndTime());
        for (DoctorSchedule existing : existingSchedules) {
            if (existing.getScheduleID() != schedule.getScheduleID()) {
                LocalDateTime existingStart = existing.getWorkDate().atTime(existing.getStartTime());
                LocalDateTime existingEnd = existing.getWorkDate().atTime(existing.getEndTime());
                if (newStart.isBefore(existingEnd) && newEnd.isAfter(existingStart)) {
                    throw new IllegalArgumentException(
                            "Schedule overlaps with existing schedule on " + existing.getWorkDate());
                }
            }
        }
    }

}