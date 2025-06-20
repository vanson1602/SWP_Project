package project.springBoot.model;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@Table(name = "tblServices", uniqueConstraints = {
        @UniqueConstraint(columnNames = "service_code")
})
@NoArgsConstructor
@AllArgsConstructor
public class Service {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long serviceID;

    @Column(name = "service_name", nullable = false, length = 200)
    private String serviceName;

    @Column(name = "service_code", length = 20, unique = true)
    private String serviceCode;

    @Column(length = 500)
    private String description;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal price;

    @Column(length = 100)
    private String category;

    @Column(name = "is_active")
    private boolean isActive = true;

    @Column(nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false)
    private LocalDateTime modifiedAt = LocalDateTime.now();

    @Override
    public String toString() {
        return "Service [serviceID=" + serviceID + ", serviceName=" + serviceName +
                ", serviceCode=" + serviceCode + ", description=" + description +
                ", price=" + price + ", category=" + category + ", isActive=" + isActive +
                ", createdAt=" + createdAt + ", modifiedAt=" + modifiedAt + "]";
    }
}
