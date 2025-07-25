package project.springBoot.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.*;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

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

    @NotBlank(message = "Username is required")
    @Pattern(regexp = "^[a-zA-Z0-9_]+$", message = "Username can only contain letters, numbers and underscore")
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

    @Pattern(regexp = "^0\\d{9}$", message = "Phone number must start with 0 and have 10 digits")
    @Column(length = 15)
    private String phone;

    @NotBlank(message = "Email is required")
    @Pattern(regexp = "^[a-zA-Z0-9._%+-]+@(gmail\\.com|fpt\\.edu\\.vn)$", message = "Email must be a valid Gmail or FPT email address")
    @Column(nullable = false, length = 100)
    private String email;

    @Column(name = "verificationToken", length = 256)
    private String verificationToken;

    @Column(name = "isVerified")
    private Boolean isVerified = false;

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

    @JsonIgnore
    @OneToMany(mappedBy = "sender", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Conversation> sentConversations;

    @JsonIgnore
    @OneToMany(mappedBy = "receiver", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Conversation> receivedConversations;

    @PrePersist
    protected void onCreate() {
        validateFields();
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

        if (!role.matches("admin|patient|doctor|receptionist")) {
            if (!role.matches("admin|patient|doctor|receptionist")) {
                throw new IllegalArgumentException("Invalid role: " + role);
            }
            if (gender != null && !gender.matches("Male|Female|Other")) {
                throw new IllegalArgumentException("Invalid gender: " + gender);
            }
        }
    }

    @PreUpdate
    protected void onUpdate() {
        validateFields();
        if (!role.matches("admin|patient|doctor|receptionist")) {
            throw new IllegalArgumentException("Invalid role: " + role);
        }
        if (gender != null && !gender.matches("Male|Female|Other")) {
            throw new IllegalArgumentException("Invalid gender: " + gender);
        }
    }

    private void validateFields() {

        if (username != null && !username.matches("^[a-zA-Z0-9_]+$")) {
            throw new IllegalArgumentException("Username can only contain letters, numbers and underscore");
        }

        if (email != null && !email.matches("^[a-zA-Z0-9._%+-]+@(gmail\\.com|fpt\\.edu\\.vn)$")) {
            throw new IllegalArgumentException("Email must be a valid Gmail or FPT email address");
        }

        if (phone != null && !phone.matches("^0\\d{9}$")) {
            throw new IllegalArgumentException("Phone number must start with 0 and have 10 digits");
        }

        if (dob != null && dob.isAfter(LocalDate.now())) {
            throw new IllegalArgumentException("Date of birth cannot be in the future");
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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public long getUserID() {
        return userID;
    }

}
