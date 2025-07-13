package project.springBoot.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import project.springBoot.model.Invoice;

public interface InvoiceRepository extends JpaRepository<Invoice, Long> {
    @Query("SELECT i FROM Invoice i WHERE i.appointment.appointmentID = :appointmentId")
    Invoice findByAppointmentId(@Param("appointmentId") Long appointmentId);
}