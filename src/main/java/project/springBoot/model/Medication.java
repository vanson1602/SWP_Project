package project.springBoot.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@Table(name = "tblMedications")
@NoArgsConstructor
@AllArgsConstructor
public class Medication {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long medicationID;

    @Column(name = "medication_name", nullable = false, length = 200)
    private String medicationName;

    @Column(name = "generic_name", length = 200)
    private String genericName;

    @Column(length = 100)
    private String manufacturer;

    @Column(name = "dosage_form", length = 50)
    private String dosageForm;

    @Column(length = 50)
    private String strength;

    @Column(length = 20)
    private String unit;

    @Column(precision = 10, scale = 2)
    private BigDecimal price = BigDecimal.ZERO;

    @Column(name = "stock_quantity")
    private Integer stockQuantity = 0;

    @Column(name = "expiry_date")
    private LocalDate expiryDate;

    @Column(name = "storage_condition", length = 200)
    private String storageCondition;

    @Column(length = 1000)
    private String contraindications;

    @Column(name = "side_effects", length = 1000)
    private String sideEffects;

    @Column(name = "is_controlled")
    private boolean isControlled = false;

    @Column(nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false)
    private LocalDateTime modifiedAt = LocalDateTime.now();

    @Override
    public String toString() {
        return "Medication [medicationID=" + medicationID + ", medicationName=" + medicationName +
                ", genericName=" + genericName + ", manufacturer=" + manufacturer +
                ", dosageForm=" + dosageForm + ", strength=" + strength + ", unit=" + unit +
                ", price=" + price + ", stockQuantity=" + stockQuantity + ", expiryDate=" + expiryDate +
                ", isControlled=" + isControlled + ", createdAt=" + createdAt + ", modifiedAt=" + modifiedAt + "]";
    }

    
}