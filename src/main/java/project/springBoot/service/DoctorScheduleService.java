package project.springBoot.service;

import project.springBoot.model.DoctorSchedule;
import project.springBoot.repository.DoctorScheduleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class DoctorScheduleService {

    @Autowired
    private DoctorScheduleRepository doctorScheduleRepository;

    public DoctorSchedule createSchedule(DoctorSchedule schedule) {
        schedule.setCreatedAt(LocalDateTime.now());
        schedule.setModifiedAt(LocalDateTime.now());
        return doctorScheduleRepository.save(schedule);
    }

    public DoctorSchedule updateSchedule(long scheduleID, DoctorSchedule updatedSchedule) {
        Optional<DoctorSchedule> existingSchedule = doctorScheduleRepository.findById((int) scheduleID);
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
            return doctorScheduleRepository.save(schedule);
        }
        return null;
    }

    public List<DoctorSchedule> getAllSchedules() {
        return doctorScheduleRepository.findAll();
    }

    public DoctorSchedule getScheduleById(int scheduleID) {
        return doctorScheduleRepository.findById(scheduleID).orElse(null);
    }

    public void deleteSchedule(int id) {
        doctorScheduleRepository.deleteById(id);
    }

    public List<DoctorSchedule> getSchedulesByDoctorId(long doctorId) {
        return doctorScheduleRepository.findByDoctorDoctorID(doctorId);
    }
}