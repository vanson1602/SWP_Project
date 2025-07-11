package project.springBoot.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import project.springBoot.model.Invoice;

@Repository
public interface InvoiceRepository extends JpaRepository<Invoice, Long> {
    @Query("SELECT DISTINCT i FROM Invoice i " +
           "LEFT JOIN FETCH i.patient p " +
           "LEFT JOIN FETCH p.user " +
           "LEFT JOIN FETCH i.examination e " +
           "LEFT JOIN FETCH i.invoiceDetails d " +
           "WHERE i.invoiceDate >= :startDate " +
           "AND i.invoiceDate < :endDate " +
           "ORDER BY i.invoiceDate DESC")
    List<Invoice> findByInvoiceDateBetween(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
}