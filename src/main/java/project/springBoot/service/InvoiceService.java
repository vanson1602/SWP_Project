package project.springBoot.service;

import project.springBoot.model.Invoice;

import java.time.LocalDateTime;
import java.util.List;

import project.springBoot.model.Appointment;

public interface InvoiceService {

    Invoice createAppointmentInvoice(Appointment appointment, String paymentMethod);



    Invoice getInvoiceByAppointment(Long appointmentId);


    List<Invoice> getInvoicesInDateRange(LocalDateTime startDate, LocalDateTime endDate);
    Invoice getInvoiceById(Long id);
}