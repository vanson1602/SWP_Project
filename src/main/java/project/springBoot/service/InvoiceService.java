package project.springBoot.service;

import project.springBoot.model.Invoice;
import project.springBoot.model.Appointment;

public interface InvoiceService {

    Invoice createAppointmentInvoice(Appointment appointment, String paymentMethod);

    Invoice getInvoiceById(Long invoiceId);

    Invoice getInvoiceByAppointment(Long appointmentId);
}