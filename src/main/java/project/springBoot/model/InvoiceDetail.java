package project.springBoot.model;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@Table(name = "tblInvoiceDetails")
@NoArgsConstructor
@AllArgsConstructor
public class InvoiceDetail {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long invoiceDetailID;

    @ManyToOne
    @JoinColumn(name = "invoiceID", nullable = false)
    private Invoice invoice;

    @ManyToOne
    @JoinColumn(name = "serviceID")
    private Service service;

    @ManyToOne
    @JoinColumn(name = "medicationID")
    private Medication medication;

    @Column(nullable = false, length = 255)
    private String description;

    @Column()
    private Integer quantity = 1;

    @Column(name = "unit_price", nullable = false, precision = 10, scale = 2)
    private BigDecimal unitPrice;

    @Column(name = "total_price", nullable = false, precision = 10, scale = 2)
    private BigDecimal totalPrice;

    @Column(nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false)
    private LocalDateTime modifiedAt = LocalDateTime.now();

    @PrePersist
    @PreUpdate
    private void validateRelationships() {
        // For consultation fee, we allow both service and medication to be null
        if (description != null && description.startsWith("Phí tư vấn")) {
            if (service != null || medication != null) {
                throw new IllegalArgumentException("Consultation fee should not have service or medication");
            }
        } else {
            // For other items, ensure only one of service or medication is set
            if ((service != null && medication != null) || (service == null && medication == null)) {
                throw new IllegalArgumentException(
                        "Exactly one of service or medication must be set for non-consultation items");
            }
        }

        // Calculate total price
        if (quantity != null && unitPrice != null) {
            totalPrice = unitPrice.multiply(new BigDecimal(quantity));
        }
    }

    @Override
    public String toString() {
        String itemInfo = service != null ? "Service: " + service.getServiceID()
                : medication != null ? "Medication: " + medication.getMedicationID()
                        : "Consultation Fee";

        return "InvoiceDetail [invoiceDetailID=" + invoiceDetailID +
                ", invoiceID=" + (invoice != null ? invoice.getInvoiceID() : null) +
                ", " + itemInfo + ", description=" + description +
                ", quantity=" + quantity + ", unitPrice=" + unitPrice + ", totalPrice=" + totalPrice +
                ", createdAt=" + createdAt + ", modifiedAt=" + modifiedAt + "]";
    }
}