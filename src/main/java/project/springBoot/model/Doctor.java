package project.springBoot.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@Table(name = "tblDoctors", uniqueConstraints = {
        @UniqueConstraint(columnNames = "userID"),
        @UniqueConstraint(columnNames = "doctor_code"),
        @UniqueConstraint(columnNames = "license_number")
})
@NoArgsConstructor
@AllArgsConstructor
public class Doctor {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long doctorID;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "userID", nullable = false, unique = true)
    private User user;

    @Column(name = "doctor_code", length = 20, unique = true)
    private String doctorCode;

    @Column(name = "license_number", length = 50, unique = true)
    private String licenseNumber;

    @Column(name = "experience_years")
    private Integer experienceYears = 0;

    @Column(name = "consultation_fee", precision = 10, scale = 2)
    private BigDecimal consultationFee = BigDecimal.ZERO;

    @Column(length = 200)
    private String qualification;

    @JsonIgnore
    @ManyToMany(cascade = { CascadeType.PERSIST, CascadeType.MERGE }, fetch = FetchType.LAZY)
    @JoinTable(name = "tblDoctorSpecializations", joinColumns = @JoinColumn(name = "doctorID"), inverseJoinColumns = @JoinColumn(name = "specializationID"))
    private List<Specialization> specializations = new ArrayList<>();

    @JsonIgnore
    @OneToMany(mappedBy = "doctor", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<DoctorSchedule> schedules = new ArrayList<>();

    @Column(nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false)
    private LocalDateTime modifiedAt = LocalDateTime.now();

    @Override
    public String toString() {
        return "Doctor [doctorID=" + doctorID + ", userID=" + (user != null ? user.getUserID() : null) +
                ", doctorCode=" + doctorCode + ", licenseNumber=" + licenseNumber +
                ", experienceYears=" + experienceYears + ", consultationFee=" + consultationFee +
                ", qualification=" + qualification + ", createdAt=" + createdAt + ", modifiedAt=" + modifiedAt + "]";
    }
}