package project.springBoot.service.impl;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import project.springBoot.model.Invoice;
import project.springBoot.repository.InvoiceRepository;
import project.springBoot.service.InvoiceService;

@Slf4j
@Service
@Transactional
public class InvoiceServiceImpl implements InvoiceService {

    @Autowired
    private InvoiceRepository invoiceRepository;

    @Override
    public List<Invoice> getInvoicesInDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        try {
            log.info("Fetching invoices between {} and {}", startDate, endDate);
            
            // Validate input dates
            if (startDate == null || endDate == null) {
                log.error("Start date or end date is null");
                return List.of();
            }
            
            if (startDate.isAfter(endDate)) {
                log.error("Start date {} is after end date {}", startDate, endDate);
                return List.of();
            }

            // Fetch invoices
            List<Invoice> invoices = invoiceRepository.findByInvoiceDateBetween(startDate, endDate);
            
            // Log results
            if (invoices.isEmpty()) {
                log.info("No invoices found for the date range");
            } else {
                log.info("Found {} invoices", invoices.size());
                invoices.forEach(invoice -> {
                    log.debug("Invoice: ID={}, Number={}, Date={}, Amount={}, Status={}, Patient={}",
                        invoice.getInvoiceID(),
                        invoice.getInvoiceNumber(),
                        invoice.getInvoiceDate(),
                        invoice.getFinalAmount(),
                        invoice.getPaymentStatus(),
                        invoice.getPatient() != null && invoice.getPatient().getUser() != null 
                            ? invoice.getPatient().getUser().getFullName() 
                            : "N/A"
                    );
                });
            }
            
            return invoices;
        } catch (Exception e) {
            log.error("Error fetching invoices: ", e);
            return List.of();
        }
    }

    @Override
    public Invoice getInvoiceById(Long id) {
        try {
            log.info("Fetching invoice with ID: {}", id);
            if (id == null) {
                log.error("Invoice ID is null");
                return null;
            }

            Optional<Invoice> invoice = invoiceRepository.findById(id);
            if (invoice.isEmpty()) {
                log.warn("No invoice found with ID: {}", id);
                return null;
            }

            log.info("Found invoice: {}", invoice.get().getInvoiceNumber());
            return invoice.get();
        } catch (Exception e) {
            log.error("Error fetching invoice by ID: ", e);
            return null;
        }
    }
} 