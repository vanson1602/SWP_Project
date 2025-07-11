package project.springBoot.service;

import java.time.LocalDateTime;
import java.util.List;

import project.springBoot.model.Invoice;

public interface InvoiceService {
    List<Invoice> getInvoicesInDateRange(LocalDateTime startDate, LocalDateTime endDate);
    Invoice getInvoiceById(Long id);
} 