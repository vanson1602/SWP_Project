package project.springBoot.service.impl;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import project.springBoot.model.Appointment;
import project.springBoot.model.Invoice;
import project.springBoot.model.InvoiceDetail;
import project.springBoot.repository.InvoiceRepository;
import project.springBoot.service.InvoiceService;
import project.springBoot.utils.InvoiceUtils;

@Service
@Transactional
@RequiredArgsConstructor
public class InvoiceServiceImpl implements InvoiceService {
    private final InvoiceRepository invoiceRepository;

    @Override
    public Invoice createAppointmentInvoice(Appointment appointment, String paymentMethod) {
        if (appointment == null) {
            throw new IllegalArgumentException("Appointment cannot be null");
        }

        Invoice invoice = new Invoice();

        invoice.setAppointment(appointment);
        invoice.setPatient(appointment.getPatient());
        invoice.setInvoiceNumber(InvoiceUtils.generateInvoiceNumber());
        invoice.setPaymentMethod(paymentMethod);
        invoice.setPaymentStatus("Paid");
        invoice.setInvoiceDate(LocalDateTime.now());
        invoice.setPaidDate(LocalDateTime.now());

        BigDecimal consultationFee = appointment.getBookingSlot().getSchedule().getDoctor().getConsultationFee();
        invoice.setTotalAmount(consultationFee);
        invoice.setTaxAmount(BigDecimal.ZERO);
        invoice.setFinalAmount(consultationFee);
        InvoiceDetail detail = new InvoiceDetail();
        detail.setInvoice(invoice);
        detail.setDescription("Phí tư vấn - " + appointment.getAppointmentType().getTypeName());
        detail.setQuantity(1);
        detail.setUnitPrice(consultationFee);
        detail.setTotalPrice(consultationFee);
        detail.setService(null);
        detail.setMedication(null);

        invoice.setInvoiceDetails(new ArrayList<>());
        invoice.getInvoiceDetails().add(detail);

        invoice.setExamination(null);

        return invoiceRepository.save(invoice);
    }

    @Override
    public Invoice getInvoiceById(Long invoiceId) {
        return invoiceRepository.findById(invoiceId).orElse(null);
    }

    @Override
    public Invoice getInvoiceByAppointment(Long appointmentId) {
        return invoiceRepository.findByAppointmentId(appointmentId);
    }
}