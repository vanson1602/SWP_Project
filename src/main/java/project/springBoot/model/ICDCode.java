package project.springBoot.model;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

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

    public String getCodeAndDescription() {
        return icdCode + " - " + description;
    }

    @Override
    public String toString() {
        return "ICDCode [icdCode=" + icdCode + ", description=" + description +
                ", category=" + category + ", isActive=" + isActive +
                ", createdAt=" + createdAt + ", modifiedAt=" + modifiedAt + "]";
    }

    public String getIcdCode() {
        return icdCode;
    }
}