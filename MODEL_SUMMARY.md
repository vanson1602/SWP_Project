# CLINIC MANAGEMENT SYSTEM - JPA MODELS SUMMARY

## Danh sách các Model đã tạo

Dựa trên file SQL schema, tôi đã tạo các Spring JPA Model sau:

### 1. **User.java** (tblUsers)
- **Primary Key**: userID
- **Unique Constraints**: username, email, phone
- **Relationships**: 
  - OneToMany với Avatar
  - ManyToOne với User (modifiedBy)
- **Validations**: role (Admin|Patient|Doctor), gender (Male|Female|Other)

### 2. **Avatar.java** (tblUserAvatars)
- **Primary Key**: avatarID
- **Relationships**: ManyToOne với User

### 3. **Patient.java** (tblPatients)
- **Primary Key**: patientID
- **Unique Constraints**: userID, patient_code
- **Relationships**: 
  - OneToOne với User
  - OneToMany với MedicalRecord, Appointment
- **Validations**: maritalStatus (Single|Married|Divorced|Widowed)

### 4. **Doctor.java** (tblDoctors)
- **Primary Key**: doctorID
- **Unique Constraints**: userID, doctor_code, license_number
- **Relationships**: 
  - OneToOne với User
  - ManyToMany với Specialization
  - OneToMany với DoctorSchedule

### 5. **Specialization.java** (tblSpecializations)
- **Primary Key**: specializationID
- **Relationships**: ManyToMany với Doctor

### 6. **ICDCode.java** (tblICDCodes)
- **Primary Key**: icdCode (String)
- Chứa mã ICD-10 và mô tả bệnh

### 7. **MedicalRecord.java** (tblMedicalRecords)
- **Primary Key**: medicalRecordID
- **Relationships**: 
  - ManyToOne với Patient
  - ManyToMany với PatientAllergy, PatientComorbidity
- **Validations**: height > 0, weight > 0, smokingStatus, alcoholUse

### 8. **PatientAllergy.java** (tblPatientAllergies)
- **Primary Key**: allergyID
- **Relationships**: ManyToMany với MedicalRecord
- **Validations**: severity (Mild|Moderate|Severe)

### 9. **PatientComorbidity.java** (tblPatientComorbidities)
- **Primary Key**: comorbidityID
- **Relationships**: 
  - ManyToOne với MedicalRecord
  - ManyToOne với ICDCode
  - ManyToMany với MedicalRecord

### 10. **AppointmentType.java** (tblAppointmentTypes)
- **Primary Key**: appointmentTypeID
- **Relationships**: OneToMany với Appointment

### 11. **Appointment.java** (tblAppointments)
- **Primary Key**: appointmentID
- **Unique Constraints**: appointment_number
- **Relationships**: 
  - ManyToOne với Patient, AppointmentType, User (admin)
  - OneToMany với Examination, DoctorBookingSlot
- **Validations**: status, appointment_date (phải trong tương lai)

### 12. **Examination.java** (tblExaminations)
- **Primary Key**: examinationID
- **Relationships**: 
  - ManyToOne với Appointment, MedicalRecord, Doctor, ICDCode
  - OneToMany với Prescription, Invoice, Feedback
- **Validations**: status (In Progress|Completed|Cancelled)

### 13. **Medication.java** (tblMedications)
- **Primary Key**: medicationID
- Chứa thông tin thuốc, giá, tồn kho

### 14. **Prescription.java** (tblPrescriptions)
- **Primary Key**: prescriptionID
- **Relationships**: ManyToOne với Examination, Medication, Doctor

### 15. **Service.java** (tblServices)
- **Primary Key**: serviceID
- **Unique Constraints**: service_code
- Chứa thông tin dịch vụ y tế và giá

### 16. **Invoice.java** (tblInvoices)
- **Primary Key**: invoiceID
- **Unique Constraints**: invoice_number
- **Relationships**: 
  - ManyToOne với Examination, Patient
  - OneToMany với InvoiceDetail
- **Validations**: paymentStatus (Pending|Partial|Paid|Cancelled)

### 17. **InvoiceDetail.java** (tblInvoiceDetails)
- **Primary Key**: invoiceDetailID
- **Relationships**: ManyToOne với Invoice
- **Validations**: itemType (Service|Medication|Other)

### 18. **DoctorSchedule.java** (tblDoctorSchedules)
- **Primary Key**: scheduleID
- **Unique Constraints**: doctorID + work_date
- **Relationships**: 
  - ManyToOne với Doctor
  - OneToMany với DoctorBookingSlot
- **Validations**: status (Available|Busy|Off|Holiday)

### 19. **DoctorBookingSlot.java** (tblDoctorBookingSlots)
- **Primary Key**: slotID
- **Relationships**: ManyToOne với DoctorSchedule, Appointment
- **Validations**: status (Available|Booked|Blocked)

### 20. **Notification.java** (tblNotifications)
- **Primary Key**: notificationID
- **Relationships**: ManyToOne với User, Appointment
- **Validations**: notificationType, priority

### 21. **Feedback.java** (tblFeedback)
- **Primary Key**: feedbackID
- **Relationships**: ManyToOne với Patient, Doctor, Examination
- **Validations**: rating (1-5), serviceRating (1-5), cleanlinessRating (1-5)

## Các tính năng chính được implement:

### ✅ JPA Annotations
- `@Entity`, `@Table`, `@Id`, `@GeneratedValue`
- `@Column` với constraints (length, nullable, unique)
- `@OneToOne`, `@OneToMany`, `@ManyToOne`, `@ManyToMany`
- `@JoinColumn`, `@JoinTable`
- `@UniqueConstraint`

### ✅ Lombok Integration
- `@Getter`, `@Setter`
- `@NoArgsConstructor`, `@AllArgsConstructor`

### ✅ Validation
- `@PrePersist`, `@PreUpdate` với custom validation logic
- Check constraints cho enums
- Range validation cho ratings
- Positive number validation

### ✅ Relationships
- Đầy đủ foreign key constraints
- Many-to-many relationships với join tables
- Cascade operations
- Orphan removal

### ✅ Business Logic
- Automatic timestamp (createdAt, modifiedAt)
- Default values
- Custom toString() methods

## Lưu ý quan trọng:

1. **Circular Dependencies**: Một số model có thể có lỗi compile vì circular references. Cần sử dụng `@JsonIgnore` hoặc lazy loading khi cần thiết.

2. **Database Schema**: Các model này tương thích với SQL schema đã cung cấp.

3. **Performance**: Đã thêm indexes thông qua JPA annotations cho các trường quan trọng.

4. **Security**: Passwords sẽ cần hash trước khi lưu (BCrypt recommended).

5. **Validation**: Có thể thêm Bean Validation annotations (`@NotNull`, `@Size`, etc.) nếu cần.

Tất cả các model đã được tạo theo chuẩn Spring Boot JPA với đầy đủ relationships và validations theo yêu cầu của database schema. 