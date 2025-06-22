package project.springBoot.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@Table(name = "tblUsers", uniqueConstraints = {
        @UniqueConstraint(columnNames = "username"),
        @UniqueConstraint(columnNames = "email"),
        @UniqueConstraint(columnNames = "phone")
})
@NoArgsConstructor
@AllArgsConstructor
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long userID;
    @Column(nullable = false, length = 50)
    private String username;
    @JsonIgnore
    @Column(nullable = false, length = 512)
    private String password;
    @Column(name = "first_name", length = 50)
    private String firstName;
    @Column(name = "last_name", length = 50)
    private String lastName;
    @Column(nullable = false)
    private String role = "patient";
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate dob;
    @Column(length = 10)
    private String gender;
    @Column(length = 256)
    private String address;
    @Column(length = 15)
    private String phone;
    @Column(nullable = false, length = 100)
    private String email;
    @Column(name = "verificationToken", length = 256)
    private String verificationToken;

    @Column(name = "isVerified")
    private boolean isVerified = false;

    @Column(name = "reset_token", length = 256)
    private String resetToken;

    @Column(name = "resetTokenExpiry")
    private LocalDateTime resetTokenExpiry;

    @Column(name = "last_login")
    private LocalDateTime lastLogin;

    @Column(nullable = false)
    private Boolean state = true;

    @Column(nullable = false)
    private String avatarUrl = "/resources/images/defaultImg.jpg";

    @Column(nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false)
    private LocalDateTime modifiedAt = LocalDateTime.now();
    @JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "modified_by", referencedColumnName = "userID")
    private User modifiedBy;

    @PrePersist
    protected void onCreate() {
        if (role == null) {
            role = "patient";
        }
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
        if (modifiedAt == null) {
            modifiedAt = LocalDateTime.now();
        }
        if (state == null) {
            state = true;
        }

        if (!role.matches("admin|patient|doctor")) {
            throw new IllegalArgumentException("Invalid role: " + role);
        }
        if (gender != null && !gender.matches("Male|Female|Other")) {
            throw new IllegalArgumentException("Invalid gender: " + gender);
        }
    }

    @PreUpdate
    protected void onUpdate() {
        if (!role.matches("admin|patient|doctor")) {
            throw new IllegalArgumentException("Invalid role: " + role);
        }
        if (gender != null && !gender.matches("Male|Female|Other")) {
            throw new IllegalArgumentException("Invalid gender: " + gender);
        }
    }

    @Override
    public String toString() {
        return "User [UserID=" + userID + ", username=" + username + ", firstName="
                + firstName + ", lastName=" + lastName + ", role=" + role + ", dob=" + dob + ", gender=" + gender
                + ", address=" + address + ", phone=" + phone + ", email=" + email + ", isVerified=" + isVerified
                + ", state=" + state + ", createdAt=" + createdAt + ", modifiedAt=" + modifiedAt + "]";
    }

    public void setRole(String role) {
        if (role != null && (role.equals("admin") || role.equals("patient") || role.equals("doctor"))) {
            this.role = role;
        } else {
            throw new IllegalArgumentException("Invalid role. Must be admin, patient, or doctor");
        }
    }

    public String getFullName() {
        return firstName + " " + lastName;
    }
}
