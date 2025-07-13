-- =============================================
-- CLINIC MANAGEMENT SYSTEM DATABASE SCHEMA (IMPROVED)
-- =============================================

-- 1. USERS TABLE
CREATE TABLE tblUsers (
  userID INT IDENTITY(1,1) PRIMARY KEY,
  username NVARCHAR(50) UNIQUE NOT NULL,
  password NVARCHAR(512) NOT NULL,
  first_name NVARCHAR(50),
  last_name NVARCHAR(50),
  role NVARCHAR(20) NOT NULL CHECK (role IN ('Admin', 'Patient', 'Doctor')),
  dob DATE,
  gender NVARCHAR(10) CHECK (gender IN ('Male', 'Female', 'Other')),
  address NVARCHAR(256),
  phone VARCHAR(15) UNIQUE,
  email NVARCHAR(256) UNIQUE NOT NULL,
  verificationToken NVARCHAR(256) NULL,
  isVerified BIT DEFAULT 0,
  resetToken NVARCHAR(256) NULL,
  resetTokenExpiry DATETIME NULL,
  last_login DATETIME NULL,
  [state] BIT DEFAULT 1,
  created_at DATETIME DEFAULT GETDATE(),
  modified_at DATETIME DEFAULT GETDATE(),
  modified_by INT NULL,
  FOREIGN KEY (modified_by) REFERENCES tblUsers(userID)
);

-- 2. USER AVATARS TABLE (New)
CREATE TABLE tblUserAvatars (
  avatarID INT IDENTITY(1,1) PRIMARY KEY,
  userID INT NOT NULL,
  avatar_url NVARCHAR(256) NOT NULL,
  created_at DATETIME DEFAULT GETDATE(),
  modified_at DATETIME DEFAULT GETDATE(),
  FOREIGN KEY (userID) REFERENCES tblUsers(userID)
);

-- 3. PATIENTS TABLE
CREATE TABLE tblPatients (
  patientID INT IDENTITY(1,1) PRIMARY KEY,
  userID INT NOT NULL UNIQUE,
  patient_code NVARCHAR(20) UNIQUE,
  emergency_contact_name NVARCHAR(100),
  emergency_contact_phone VARCHAR(15),
  insurance_number NVARCHAR(50),
  occupation NVARCHAR(100),
  marital_status NVARCHAR(20) CHECK (marital_status IN ('Single', 'Married', 'Divorced', 'Widowed')),
  created_at DATETIME DEFAULT GETDATE(),
  modified_at DATETIME DEFAULT GETDATE(),
  FOREIGN KEY (userID) REFERENCES tblUsers(userID)
);

-- 4. DOCTORS TABLE
CREATE TABLE tblDoctors (
  doctorID INT IDENTITY(1,1) PRIMARY KEY,
  userID INT NOT NULL UNIQUE,
  doctor_code NVARCHAR(20) UNIQUE,
  license_number NVARCHAR(50) UNIQUE,
  experience_years INT DEFAULT 0,
  consultation_fee DECIMAL(10,2) DEFAULT 0,
  qualification NVARCHAR(200),
  created_at DATETIME DEFAULT GETDATE(),
  modified_at DATETIME DEFAULT GETDATE(),
  FOREIGN KEY (userID) REFERENCES tblUsers(userID)
);

-- 5. SPECIALIZATIONS TABLE (New)
CREATE TABLE tblSpecializations (
  specializationID INT IDENTITY(1,1) PRIMARY KEY,
  specialization_name NVARCHAR(100) NOT NULL,
  description NVARCHAR(500),
  is_active BIT DEFAULT 1,
  created_at DATETIME DEFAULT GETDATE(),
  modified_at DATETIME DEFAULT GETDATE()
);
-- 6. DOCTOR SPECIALIZATIONS TABLE
CREATE TABLE tblDoctorSpecializations (
  doctorID INT NOT NULL,
  specializationID INT NOT NULL,
  created_at DATETIME DEFAULT GETDATE(),
  PRIMARY KEY (doctorID, specializationID),
  FOREIGN KEY (doctorID) REFERENCES tblDoctors(doctorID),
  FOREIGN KEY (specializationID) REFERENCES tblSpecializations(specializationID)
);

-- 7. ICD CODES TABLE
CREATE TABLE tblICDCodes (
  icdCode NVARCHAR(10) PRIMARY KEY,
  description NVARCHAR(500) NOT NULL,
  category NVARCHAR(100),
  is_active BIT DEFAULT 1,
  created_at DATETIME DEFAULT GETDATE(),
  modified_at DATETIME DEFAULT GETDATE()
);
-- 8. MEDICAL RECORDS TABLE
CREATE TABLE tblMedicalRecords (
  medicalRecordID INT IDENTITY(1,1) PRIMARY KEY,
  patientID INT NOT NULL,
  height DECIMAL(5,2) CHECK (height > 0),
  weight DECIMAL(5,2) CHECK (weight > 0),
  blood_type NVARCHAR(5),
  smoking_status NVARCHAR(20) CHECK (smoking_status IN ('Non-smoker', 'Smoker', 'Former smoker')),
  alcohol_use NVARCHAR(20) CHECK (alcohol_use IN ('None', 'Occasional', 'Regular')),
  created_at DATETIME DEFAULT GETDATE(),
  modified_at DATETIME DEFAULT GETDATE(),
  FOREIGN KEY (patientID) REFERENCES tblPatients(patientID)
);



-- 9. PATIENT ALLERGIES TABLE 
CREATE TABLE tblPatientAllergies (
  allergyID INT IDENTITY(1,1) PRIMARY KEY,
  allergen NVARCHAR(100) NOT NULL,
  reaction NVARCHAR(500),
  severity NVARCHAR(20) CHECK (severity IN ('Mild', 'Moderate', 'Severe')),
  created_at DATETIME DEFAULT GETDATE(),
  modified_at DATETIME DEFAULT GETDATE(),
);
CREATE TABLE tblMedicalRecordAllergies (
  recordID INT NOT NULL,
  allergyID INT NOT NULL,
  PRIMARY KEY (recordID, allergyID),
  FOREIGN KEY (recordID) REFERENCES tblMedicalRecords(medicalRecordID),
  FOREIGN KEY (allergyID) REFERENCES tblPatientAllergies(allergyID)
);
-- 10. PATIENT COMORBIDITIES TABLE 
CREATE TABLE tblPatientComorbidities (
  comorbidityID INT IDENTITY(1,1) PRIMARY KEY,
  medicalRecordID INT NOT NULL,
  icdCode NVARCHAR(10) NOT NULL,
  diagnosis_date DATE,
  notes NVARCHAR(500),
  created_at DATETIME DEFAULT GETDATE(),
  modified_at DATETIME DEFAULT GETDATE(),
  FOREIGN KEY (icdCode) REFERENCES tblICDCodes(icdCode)
);
CREATE TABLE tblMedicalRecordComorbidities (
  recordID INT NOT NULL,
  comorbidityID INT NOT NULL,
  PRIMARY KEY (recordID, comorbidityID),
  FOREIGN KEY (recordID) REFERENCES tblMedicalRecords(medicalRecordID),
  FOREIGN KEY (comorbidityID) REFERENCES tblPatientComorbidities(comorbidityID)
);
-- 11. APPOINTMENT TYPES TABLE
CREATE TABLE tblAppointmentTypes (
  appointmentTypeID INT IDENTITY(1,1) PRIMARY KEY,
  type_name NVARCHAR(50) NOT NULL,
  description NVARCHAR(200),
  is_active BIT DEFAULT 1,
  created_at DATETIME DEFAULT GETDATE(),
  modified_at DATETIME DEFAULT GETDATE()
);
-- 12. APPOINTMENTS TABLE
CREATE TABLE tblAppointments (
  appointmentID INT IDENTITY(1,1) PRIMARY KEY,
  patientID INT NOT NULL,
  appointmentTypeID INT NOT NULL,
  appointment_date DATETIME NOT NULL CHECK (appointment_date >= GETDATE()),
  appointment_number NVARCHAR(20) UNIQUE NOT NULL,
  status NVARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Confirmed', 'Rejected', 'Completed', 'Cancelled', 'NoShow')),
  adminID INT,
  admin_notes NVARCHAR(500),
  patient_notes NVARCHAR(500),
  created_at DATETIME DEFAULT GETDATE(),
  modified_at DATETIME DEFAULT GETDATE(),
  FOREIGN KEY (patientID) REFERENCES tblPatients(patientID),
  FOREIGN KEY (appointmentTypeID) REFERENCES tblAppointmentTypes(appointmentTypeID),
  FOREIGN KEY (adminID) REFERENCES tblUsers(userID)
);

-- 13. EXAMINATIONS TABLE
CREATE TABLE tblExaminations (
  examinationID INT IDENTITY(1,1) PRIMARY KEY,
  appointmentID INT NOT NULL,
  medicalRecordID INT NOT NULL,
  doctorID INT NOT NULL,
  examination_date DATETIME NOT NULL,
  heart_rate INT,
  temperature DECIMAL(4,1),
  blood_pressure_systolic INT,
  blood_pressure_diastolic INT,
  respiratory_rate INT,
  oxygen_saturation DECIMAL(5,2),
  chief_complaint NVARCHAR(500),
  symptoms NVARCHAR(1000),
  physical_examination NVARCHAR(1000),
  icd_diagnosis NVARCHAR(10),
  disease_diagnosis NVARCHAR(500),
  conclusion_treatment_plan NVARCHAR(2000),
  follow_up_date DATETIME,
  status NVARCHAR(20) DEFAULT 'Completed' CHECK (status IN ('In Progress', 'Completed', 'Cancelled')),
  created_at DATETIME DEFAULT GETDATE(),
  modified_at DATETIME DEFAULT GETDATE(),
  FOREIGN KEY (appointmentID) REFERENCES tblAppointments(appointmentID),
  FOREIGN KEY (medicalRecordID) REFERENCES tblMedicalRecords(medicalRecordID),
  FOREIGN KEY (doctorID) REFERENCES tblDoctors(doctorID),
  FOREIGN KEY (icd_diagnosis) REFERENCES tblICDCodes(icdCode)
);

-- 14. MEDICATIONS TABLE
CREATE TABLE tblMedications (
  medicationID INT IDENTITY(1,1) PRIMARY KEY,
  medication_name NVARCHAR(200) NOT NULL,
  generic_name NVARCHAR(200),
  manufacturer NVARCHAR(100),
  dosage_form NVARCHAR(50),
  strength NVARCHAR(50),
  unit NVARCHAR(20),
  price DECIMAL(10,2) DEFAULT 0,
  stock_quantity INT DEFAULT 0,
  expiry_date DATE,
  storage_condition NVARCHAR(200),
  contraindications NVARCHAR(1000),
  side_effects NVARCHAR(1000),
  is_controlled BIT DEFAULT 0,
  created_at DATETIME DEFAULT GETDATE(),
  modified_at DATETIME DEFAULT GETDATE()
);

-- 15. PRESCRIPTIONS TABLE
CREATE TABLE tblPrescriptions (
  prescriptionID INT IDENTITY(1,1) PRIMARY KEY,
  examinationID INT NOT NULL,
  medicationID INT NOT NULL,
  prescribed_by INT NOT NULL,
  quantity INT NOT NULL,
  dosage NVARCHAR(100) NOT NULL,
  frequency NVARCHAR(100) NOT NULL,
  duration NVARCHAR(100),
  instructions NVARCHAR(500),
  is_refillable BIT DEFAULT 0,
  created_at DATETIME DEFAULT GETDATE(),
  modified_at DATETIME DEFAULT GETDATE(),
  FOREIGN KEY (examinationID) REFERENCES tblExaminations(examinationID),
  FOREIGN KEY (medicationID) REFERENCES tblMedications(medicationID),
  FOREIGN KEY (prescribed_by) REFERENCES tblDoctors(doctorID)
);

-- 16. SERVICES TABLE
CREATE TABLE tblServices (
  serviceID INT IDENTITY(1,1) PRIMARY KEY,
  service_name NVARCHAR(200) NOT NULL,
  service_code NVARCHAR(20) UNIQUE,
  description NVARCHAR(500),
  price DECIMAL(10,2) NOT NULL,
  category NVARCHAR(100),
  is_active BIT DEFAULT 1,
  created_at DATETIME DEFAULT GETDATE(),
  modified_at DATETIME DEFAULT GETDATE()
);

-- 17. INVOICES TABLE
CREATE TABLE tblInvoices (
  invoiceID INT IDENTITY(1,1) PRIMARY KEY,
  examinationID INT NULL,
  appointmentID INT NOT NULL,
  patientID INT NOT NULL,
  invoice_number NVARCHAR(20) UNIQUE NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL,
  tax_amount DECIMAL(10,2) DEFAULT 0,
  final_amount DECIMAL(10,2) NOT NULL,
  payment_status NVARCHAR(20) DEFAULT 'Pending' CHECK (payment_status IN ('Pending', 'Partial', 'Paid', 'Cancelled')),
  payment_method NVARCHAR(50),
  invoice_date DATETIME DEFAULT GETDATE(),
  due_date DATETIME,
  paid_date DATETIME,
  notes NVARCHAR(500),
  created_at DATETIME DEFAULT GETDATE(),
  modified_at DATETIME DEFAULT GETDATE(),
  FOREIGN KEY (examinationID) REFERENCES tblExaminations(examinationID),
  FOREIGN KEY (appointmentID) REFERENCES tblAppointments(appointmentID),
  FOREIGN KEY (patientID) REFERENCES tblPatients(patientID)
);

-- Add ALTER statement to ensure examinationID allows NULL
ALTER TABLE tblInvoices ALTER COLUMN examinationID INT NULL;

-- 18. INVOICE DETAILS TABLE
CREATE TABLE tblInvoiceDetails (
  invoiceDetailID INT IDENTITY(1,1) PRIMARY KEY,
  invoiceID INT NOT NULL,
  serviceID INT,
  medicationID INT,
  description NVARCHAR(255) NOT NULL,
  quantity INT DEFAULT 1,
  unit_price DECIMAL(10,2) NOT NULL,
  total_price DECIMAL(10,2) NOT NULL,
  created_at DATETIME DEFAULT GETDATE(),
  modified_at DATETIME DEFAULT GETDATE(),
  FOREIGN KEY (invoiceID) REFERENCES tblInvoices(invoiceID),
  FOREIGN KEY (serviceID) REFERENCES tblServices(serviceID),
  FOREIGN KEY (medicationID) REFERENCES tblMedications(medicationID),
  CONSTRAINT CHK_OnlyOneItem CHECK (
    (serviceID IS NULL AND medicationID IS NOT NULL) OR
    (serviceID IS NOT NULL AND medicationID IS NULL) OR
    (serviceID IS NULL AND medicationID IS NULL AND description LIKE 'Phí tư vấn%')
  )
);
-- 19. DOCTOR SCHEDULES TABLE
CREATE TABLE tblDoctorSchedules (
  scheduleID INT IDENTITY(1,1) PRIMARY KEY,
  doctorID INT NOT NULL,
  work_date DATE NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  status NVARCHAR(20) DEFAULT 'Available' CHECK (status IN ('Available', 'Busy', 'Off', 'Holiday')),
  max_patients INT DEFAULT 20,
  clinic_room NVARCHAR(50),
  notes NVARCHAR(255),
  created_at DATETIME DEFAULT GETDATE(),
  modified_at DATETIME DEFAULT GETDATE(),
  FOREIGN KEY (doctorID) REFERENCES tblDoctors(doctorID),
  UNIQUE(doctorID, work_date)
);

-- 20. DOCTOR BOOKING SLOTS TABLE
CREATE TABLE tblDoctorBookingSlots (
  slotID INT IDENTITY(1,1) PRIMARY KEY,
  scheduleID INT NOT NULL,
  start_time DATETIME NOT NULL,
  end_time DATETIME NOT NULL,
  status NVARCHAR(20) DEFAULT 'Available' CHECK (status IN ('Available', 'Booked', 'Blocked')),
  appointmentID INT NULL,
  created_at DATETIME DEFAULT GETDATE(),
  modified_at DATETIME DEFAULT GETDATE(),
  FOREIGN KEY (scheduleID) REFERENCES tblDoctorSchedules(scheduleID),
  FOREIGN KEY (appointmentID) REFERENCES tblAppointments(appointmentID)
);

-- 21. NOTIFICATIONS TABLE (Updated)
CREATE TABLE tblNotifications (
  notificationID INT IDENTITY(1,1) PRIMARY KEY,
  userID INT NOT NULL,
  appointmentID INT NULL,
  title NVARCHAR(200) NOT NULL,
  message NVARCHAR(1000) NOT NULL,
  notification_type NVARCHAR(20) NOT NULL CHECK (notification_type IN ('Reminder', 'Confirmation', 'Rejection', 'NewAppointment', 'Payment', 'General')),
  priority NVARCHAR(10) DEFAULT 'Normal' CHECK (priority IN ('Low', 'Normal', 'High', 'Urgent')),
  is_read BIT DEFAULT 0,
  sent_at DATETIME DEFAULT GETDATE(),
  read_at DATETIME NULL,
  created_at DATETIME DEFAULT GETDATE(),
  FOREIGN KEY (userID) REFERENCES tblUsers(userID),
  FOREIGN KEY (appointmentID) REFERENCES tblAppointments(appointmentID)
);

-- 22. FEEDBACK TABLE
CREATE TABLE tblFeedback (
  feedbackID INT IDENTITY(1,1) PRIMARY KEY,
  patientID INT NOT NULL,
  doctorID INT NOT NULL,
  examinationID INT NOT NULL,
  rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  service_rating INT CHECK (service_rating BETWEEN 1 AND 5),
  cleanliness_rating INT CHECK (cleanliness_rating BETWEEN 1 AND 5),
  comment NVARCHAR(2000),
  response NVARCHAR(2000),
  is_anonymous BIT DEFAULT 0,
  is_approved BIT DEFAULT 1,
  created_at DATETIME DEFAULT GETDATE(),
  modified_at DATETIME DEFAULT GETDATE(),
  FOREIGN KEY (patientID) REFERENCES tblPatients(patientID),
  FOREIGN KEY (doctorID) REFERENCES tblDoctors(doctorID),
  FOREIGN KEY (examinationID) REFERENCES tblExaminations(examinationID)
);

-- =============================================
-- INDEXES FOR PERFORMANCE
-- =============================================

-- Users indexes
CREATE INDEX IX_Users_Email ON tblUsers(email);
CREATE INDEX IX_Users_Phone ON tblUsers(phone);
CREATE INDEX IX_Users_Role ON tblUsers(role);
CREATE INDEX IX_Users_State ON tblUsers(state);

-- Patients indexes
CREATE INDEX IX_Patients_UserID ON tblPatients(userID);
CREATE INDEX IX_Patients_PatientCode ON tblPatients(patient_code);

-- Appointments indexes
CREATE INDEX IX_Appointments_Date_Patient ON tblAppointments(appointment_date, patientID);
CREATE INDEX IX_Appointments_Status ON tblAppointments(status);

-- Examinations indexes
CREATE INDEX IX_Examinations_Date ON tblExaminations(examination_date);
CREATE INDEX IX_Examinations_Patient ON tblExaminations(medicalRecordID);
CREATE INDEX IX_Examinations_Doctor ON tblExaminations(doctorID);

-- Schedules indexes
CREATE INDEX IX_Schedules_Doctor_Date_Status ON tblDoctorSchedules(doctorID, work_date, status);

-- Slots indexes
CREATE INDEX IX_Slots_Schedule_Time ON tblDoctorBookingSlots(scheduleID, start_time, end_time);
CREATE INDEX IX_Slots_Status ON tblDoctorBookingSlots(status);

-- Notifications indexes
CREATE INDEX IX_Notifications_User_Read ON tblNotifications(userID, is_read);
CREATE INDEX IX_Notifications_Sent ON tblNotifications(sent_at);

-- Invoices indexes
CREATE INDEX IX_Invoices_Date_Status ON tblInvoices(invoice_date, payment_status);
CREATE INDEX IX_Invoices_Patient ON tblInvoices(patientID);

-- USER AVATARS TABLE
CREATE TABLE tbl_user_avatars (
  avatarid INT IDENTITY(1,1) PRIMARY KEY,
  userid INT NOT NULL,
  avatar_url NVARCHAR(255) NOT NULL,
  created_at DATETIME DEFAULT GETDATE(),
  modified_at DATETIME DEFAULT GETDATE(),
  FOREIGN KEY (userid) REFERENCES tbl_users(userid)
);

