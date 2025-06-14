package project.springBoot.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@Table(name = "tblAppointmentTypes")
@NoArgsConstructor
@AllArgsConstructor
public class AppointmentType {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long appointmentTypeID;

    @Column(name = "type_name", nullable = false, length = 50)
    private String typeName;

    @Column(length = 200)
    private String description;

    @Column(name = "is_active")
    private boolean isActive = true;

    @OneToMany(mappedBy = "appointmentType", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Appointment> appointments = new ArrayList<>();

    @Column(nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false)
    private LocalDateTime modifiedAt = LocalDateTime.now();

    @Override
    public String toString() {
        return "AppointmentType [appointmentTypeID=" + appointmentTypeID + ", typeName=" + typeName + 
               ", description=" + description + ", isActive=" + isActive + 
               ", createdAt=" + createdAt + ", modifiedAt=" + modifiedAt + "]";
    }
} 