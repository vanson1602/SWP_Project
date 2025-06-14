package project.springBoot.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@Table(name = "tblICDCodes")
@NoArgsConstructor
@AllArgsConstructor
public class ICDCode {
    @Id
    @Column(name = "icdCode", length = 10)
    private String icdCode;

    @Column(nullable = false, length = 500)
    private String description;

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
        return "ICDCode [icdCode=" + icdCode + ", description=" + description +
                ", category=" + category + ", isActive=" + isActive +
                ", createdAt=" + createdAt + ", modifiedAt=" + modifiedAt + "]";
    }
}