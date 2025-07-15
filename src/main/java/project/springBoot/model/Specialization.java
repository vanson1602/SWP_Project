package project.springBoot.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@Table(name = "tblSpecializations")
@NoArgsConstructor
@AllArgsConstructor
public class Specialization {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long specializationID;

    @Column(name = "specialization_name", nullable = false, length = 100)
    private String specializationName;

    @Column(length = 500)
    private String description;

    @Column(name = "is_active")
    private boolean isActive = true;

    @ManyToMany(mappedBy = "specializations")
    private List<Doctor> doctors = new ArrayList<>();

    @Column(nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false)
    private LocalDateTime modifiedAt = LocalDateTime.now();

    @Override
    public String toString() {
        return "Specialization [specializationID=" + specializationID + ", specializationName=" + specializationName +
                ", description=" + description + ", isActive=" + isActive +
                ", createdAt=" + createdAt + ", modifiedAt=" + modifiedAt + "]";
    }

    public long getSpecializationID() {
        return specializationID;
    }
}