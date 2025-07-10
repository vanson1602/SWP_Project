package project.springBoot.model;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@Table(name = "tblInvoices", uniqueConstraints = {
        @UniqueConstraint(columnNames = "invoice_number")
})
@NoArgsConstructor
@AllArgsConstructor
public class Invoice {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long invoiceID;

    @ManyToOne(optional = true)
    @JoinColumn(name = "examinationID")
    private Examination examination;

    @ManyToOne
    @JoinColumn(name = "appointmentID", nullable = false)
    private Appointment appointment;

    @ManyToOne
    @JoinColumn(name = "patientID", nullable = false)
    private Patient patient;

    @Column(name = "invoice_number", nullable = false, length = 20, unique = true)
    private String invoiceNumber;

    @Column(name = "total_amount", nullable = false, precision = 10, scale = 2)
    private BigDecimal totalAmount;

    @Column(name = "tax_amount", precision = 10, scale = 2)
    private BigDecimal taxAmount = BigDecimal.ZERO;

    @Column(name = "final_amount", nullable = false, precision = 10, scale = 2)
    private BigDecimal finalAmount;

    @Column(name = "payment_status", length = 20)
    private String paymentStatus = "Pending";

    @Column(name = "payment_method", length = 50)
    private String paymentMethod;

    @Column(name = "invoice_date")
    private LocalDateTime invoiceDate = LocalDateTime.now();

    @Column(name = "due_date")
    private LocalDateTime dueDate;

    @Column(name = "paid_date")
    private LocalDateTime paidDate;

    @Column(length = 500)
    private String notes;

    @OneToMany(mappedBy = "invoice", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<InvoiceDetail> invoiceDetails = new ArrayList<>();

    @Column(nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false)
    private LocalDateTime modifiedAt = LocalDateTime.now();

    @PrePersist
    @PreUpdate
    private void validateEnumLikeFields() {
        if (paymentStatus != null && !paymentStatus.matches("Pending|Partial|Paid|Cancelled")) {
            throw new IllegalArgumentException("Invalid payment status: " + paymentStatus);
        }

        // Calculate final amount based on total and tax only
        if (totalAmount != null) {
            BigDecimal taxValue = (taxAmount != null) ? taxAmount : BigDecimal.ZERO;
            finalAmount = totalAmount.add(taxValue);
        }
    }

    @Override
    public String toString() {
        return "Invoice [invoiceID=" + invoiceID +
                ", examinationID=" + (examination != null ? examination.getExaminationID() : null) +
                ", appointmentID=" + (appointment != null ? appointment.getAppointmentID() : null) +
                ", patientID=" + (patient != null ? patient.getPatientID() : null) +
                ", invoiceNumber=" + invoiceNumber + ", totalAmount=" + totalAmount +
                ", finalAmount=" + finalAmount + ", paymentStatus=" + paymentStatus +
                ", invoiceDate=" + invoiceDate + ", createdAt=" + createdAt + ", modifiedAt=" + modifiedAt + "]";
    }
}