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

    @Column(name = "item_type", length = 20)
    private String itemType;

    @Column(name = "item_id", nullable = false)
    private Integer itemId;

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
    private void validateEnumLikeFields() {
        if (itemType != null && !itemType.matches("Service|Medication|Other")) {
            throw new IllegalArgumentException("Invalid item type: " + itemType);
        }
    }

    @Override
    public String toString() {
        return "InvoiceDetail [invoiceDetailID=" + invoiceDetailID +
                ", invoiceID=" + (invoice != null ? invoice.getInvoiceID() : null) +
                ", itemType=" + itemType + ", itemId=" + itemId + ", description=" + description +
                ", quantity=" + quantity + ", unitPrice=" + unitPrice + ", totalPrice=" + totalPrice +
                ", createdAt=" + createdAt + ", modifiedAt=" + modifiedAt + "]";
    }
}