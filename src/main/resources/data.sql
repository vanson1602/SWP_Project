-- Thêm các chuyên khoa
INSERT INTO tblSpecializations (specializationID, created_at, description, is_active, modified_at, specialization_name) 
VALUES
(2, NOW(), 'Chuyên khoa về các bệnh lý tim mạch và mạch máu', 1, NOW(), 'Tim mạch'),
(3, NOW(), 'Chuyên khoa về chăm sóc và điều trị cho trẻ em', 1, NOW(), 'Nhi khoa'),
(4, NOW(), 'Chuyên khoa về các bệnh lý da và thẩm mỹ da', 1, NOW(), 'Da liễu'),
(5, NOW(), 'Chuyên khoa về các bệnh lý hệ thần kinh', 1, NOW(), 'Thần kinh');

-- Thêm người dùng là bác sĩ
INSERT INTO tblUsers (username, password, first_name, last_name, role, dob, gender, address, phone, email, isVerified, state) VALUES
('drnguyen', '$2a$10$rTm8zZxwGtYZY0mj7ZgqOeGy3YBPUCqkPWnUzfZYqzBGBzHLTeKK.', 'Minh', 'Nguyễn', 'Doctor', '1980-05-15', 'Male', 'Quận 1, TP.HCM', '0901234567', 'dr.nguyen@healthcare.com', 1, 1),
('drpham', '$2a$10$rTm8zZxwGtYZY0mj7ZgqOeGy3YBPUCqkPWnUzfZYqzBGBzHLTeKK.', 'Thu', 'Phạm', 'Doctor', '1985-08-20', 'Female', 'Quận 3, TP.HCM', '0901234568', 'dr.pham@healthcare.com', 1, 1),
('drle', '$2a$10$rTm8zZxwGtYZY0mj7ZgqOeGy3YBPUCqkPWnUzfZYqzBGBzHLTeKK.', 'Hùng', 'Lê', 'Doctor', '1975-12-10', 'Male', 'Quận 5, TP.HCM', '0901234569', 'dr.le@healthcare.com', 1, 1),
('drtran', '$2a$10$rTm8zZxwGtYZY0mj7ZgqOeGy3YBPUCqkPWnUzfZYqzBGBzHLTeKK.', 'Hương', 'Trần', 'Doctor', '1982-03-25', 'Female', 'Quận 7, TP.HCM', '0901234570', 'dr.tran@healthcare.com', 1, 1);

-- Thêm avatar cho bác sĩ
INSERT INTO tbl_user_avatars (userid, avatar_url) VALUES
(6, '/images/doctors/dr-tran.html'),   -- Dr. Trần
(7, '/images/doctors/dr-vo.html'),     -- Dr. Võ
(8, '/images/doctors/dr-phan.html'),   -- Dr. Phan
(9, '/images/doctors/dr-hoang.html'),  -- Dr. Hoàng
(10, '/images/doctors/dr-ly.html');    -- Dr. Lý

-- Thêm thông tin bác sĩ
INSERT INTO tblDoctors (userID, doctor_code, license_number, experience_years, consultation_fee, qualification) VALUES
((SELECT userID FROM tblUsers WHERE username = 'drnguyen'), 'DOC001', 'LIC001', 15, 500000, 'Tiến sĩ Y khoa, Đại học Y Dược TP.HCM'),
((SELECT userID FROM tblUsers WHERE username = 'drpham'), 'DOC002', 'LIC002', 10, 400000, 'Thạc sĩ Y khoa, Chuyên khoa 1 Tim mạch'),
((SELECT userID FROM tblUsers WHERE username = 'drle'), 'DOC003', 'LIC003', 20, 600000, 'Phó Giáo sư, Tiến sĩ Y khoa'),
((SELECT userID FROM tblUsers WHERE username = 'drtran'), 'DOC004', 'LIC004', 12, 450000, 'Thạc sĩ Y khoa, Chuyên khoa 2 Nhi');

-- Thêm chuyên khoa cho bác sĩ
INSERT INTO tblDoctorSpecializations (doctorID, specializationID) VALUES
((SELECT doctorID FROM tblDoctors WHERE doctor_code = 'DOC001'), 2), -- Tim mạch
((SELECT doctorID FROM tblDoctors WHERE doctor_code = 'DOC002'), 2), -- Tim mạch
((SELECT doctorID FROM tblDoctors WHERE doctor_code = 'DOC003'), 5), -- Thần kinh
((SELECT doctorID FROM tblDoctors WHERE doctor_code = 'DOC004'), 3); -- Nhi khoa 

-- Thêm user bác sĩ
INSERT INTO tbl_users (username, password, first_name, last_name, role, dob, gender, address, phone, email, is_verified, state, created_at, modified_at)
VALUES 
('doctor1', '$2a$10$HwtpZcsQpcFSxu6fDMZAO.QVb0kiR5gBk8I9.1yVg1Y.2ElaPJCF6', 'Nguyen', 'Van A', 'doctor', '1980-01-01', 'Male', 'Ha Noi', '0123456779', 'doctor1@gmail.com', 1, 1, NOW(), NOW());

-- Thêm user bệnh nhân
INSERT INTO tbl_users (username, password, first_name, last_name, role, dob, gender, address, phone, email, is_verified, state, created_at, modified_at)
VALUES 
('patient1', '$2a$10$HwtpZcsQpcFSxu6fDMZAO.QVb0kiR5gBk8I9.1yVg1Y.2ElaPJCF6', 'Tran', 'Thi B', 'patient', '1990-05-15', 'Female', 'Ho Chi Minh', '0987654321', 'patient1@gmail.com', 1, 1, NOW(), NOW());


-- Thêm chuyên khoa
INSERT INTO tbl_specializations (doctorid,specialization_name, description, is_active, created_at, modified_at)
VALUES 
('Nội khoa', 'Chuyên khoa nội tổng quát', 1, NOW(), NOW());

-- Thêm bác sĩ
INSERT INTO tbl_doctors (userid, doctor_code, license_number, experience_years, consultation_fee, qualification, created_at, modified_at)
VALUES 
((SELECT userid FROM tbl_users WHERE username = 'doctor1'), 'DOC001', 'LICENSE001', 10, 500000.00, 'Bác sĩ chuyên khoa I', NOW(), NOW());

-- Thêm liên kết bác sĩ - chuyên khoa
INSERT INTO tbl_doctor_specializations (doctorid, specializationid)
VALUES 
((SELECT doctorid FROM tbl_doctors WHERE doctor_code = 'DOC001'),
(SELECT specializationid FROM tbl_specializations WHERE specialization_name = 'Nội khoa'));

-- Thêm bệnh nhân
INSERT INTO tbl_patients (userid, patient_code, emergency_contact_name, emergency_contact_phone, insurance_number, occupation, marital_status, created_at, modified_at)
VALUES 
((SELECT userid FROM tbl_users WHERE username = 'patient1'), 'PAT001', 'Nguyen Van C', '0123456788', 'INS001', 'Giáo viên', 'Married', NOW(), NOW());

-- Thêm hồ sơ y tế
INSERT INTO tbl_medical_records (patientid, height, weight, blood_type, smoking_status, alcohol_use, created_at, modified_at)
VALUES 
((SELECT patientid FROM tbl_patients WHERE patient_code = 'PAT001'), 165.5, 55.0, 'A+', 'Non-smoker', 'None', NOW(), NOW());


-- Thêm lịch làm việc bác sĩ
INSERT INTO tbl_doctor_schedules (doctorid, work_date, start_time, end_time, max_patients, clinic_room, status, created_at, modified_at)
VALUES 
((SELECT doctorid FROM tbl_doctors WHERE doctor_code = 'DOC001'), 
CURDATE(), '08:00:00', '17:00:00', 20, 'Room 101', 'Available', NOW(), NOW());

-- Thêm các slot khám
INSERT INTO tbl_doctor_booking_slots (scheduleid, start_time, end_time, status, created_at, modified_at)
VALUES 
((SELECT scheduleid FROM tbl_doctor_schedules WHERE doctorid = (SELECT doctorid FROM tbl_doctors WHERE doctor_code = 'DOC001') LIMIT 1),
CONCAT(CURDATE(), ' 08:00:00'), CONCAT(CURDATE(), ' 08:30:00'), 'Available', NOW(), NOW());


-- Thêm loại cuộc hẹn
INSERT INTO tbl_appointment_types (type_name, description, is_active, created_at, modified_at)
VALUES 
('Khám tổng quát', 'Khám sức khỏe tổng quát định kỳ', 1, NOW(), NOW());

-- Thêm cuộc hẹn
INSERT INTO tbl_appointments (patientid, appointment_typeid, appointment_number, appointment_date, status, created_at, modified_at)
VALUES 
((SELECT patientid FROM tbl_patients WHERE patient_code = 'PAT001'),
(SELECT appointment_typeid FROM tbl_appointment_types WHERE type_name = 'Khám tổng quát'),
'APT001', NOW(), 'Scheduled', NOW(), NOW());


INSERT INTO tbl_medications (medication_name, generic_name, manufacturer, dosage_form, strength, unit, price, stock_quantity, 
expiry_date, storage_condition, is_controlled, created_at, modified_at)
VALUES 
('Paracetamol', 'Acetaminophen', 'Công ty Dược Hậu Giang', 'Viên nén', '500', 'mg', 2000.00, 1000, 
'2025-12-31', 'Bảo quản ở nhiệt độ phòng dưới 30°C', 0, NOW(), NOW());


INSERT INTO tbl_services (service_name, service_code, description, category, price, is_active, created_at, modified_at)
VALUES 
('Khám tổng quát', 'SER001', 'Dịch vụ khám sức khỏe tổng quát', 'Khám bệnh', 500000.00, 1, NOW(), NOW());

-- Thêm ca khám
INSERT INTO tbl_examinations (appointmentid, medical_recordid, doctorid, examination_date, 
heart_rate, temperature, blood_pressure_systolic, blood_pressure_diastolic, 
chief_complaint, symptoms, physical_examination, disease_diagnosis, status, created_at, modified_at)
VALUES 
((SELECT appointmentid FROM tbl_appointments WHERE appointment_number = 'APT001'),
(SELECT medical_recordid FROM tbl_medical_records WHERE patientid = (SELECT patientid FROM tbl_patients WHERE patient_code = 'PAT001')),
(SELECT doctorid FROM tbl_doctors WHERE doctor_code = 'DOC001'),
NOW(), 75, 36.5, 120, 80, 'Đau đầu', 'Đau đầu, chóng mặt', 'Bình thường', 'Đau đầu căng thẳng', 'Completed', NOW(), NOW());

-- Thêm đơn thuốc
INSERT INTO tbl_prescriptions (examinationid, medicationid, prescribed_by, quantity, dosage, frequency, duration, instructions, is_refillable, created_at, modified_at)
VALUES 
((SELECT examinationid FROM tbl_examinations ORDER BY examinationid DESC LIMIT 1),
(SELECT medicationid FROM tbl_medications WHERE medication_name = 'Paracetamol'),
(SELECT doctorid FROM tbl_doctors WHERE doctor_code = 'DOC001'),
20, '1 viên', '3 lần/ngày', '7 ngày', 'Uống sau ăn', 0, NOW(), NOW());

-- Thêm hóa đơn
INSERT INTO tbl_invoices (examinationid, patientid, invoice_number, total_amount, discount_amount, 
tax_amount, final_amount, payment_status, payment_method, invoice_date, created_at, modified_at)
VALUES 
((SELECT examinationid FROM tbl_examinations ORDER BY examinationid DESC LIMIT 1),
(SELECT patientid FROM tbl_patients WHERE patient_code = 'PAT001'),
'INV001', 1000000.00, 0.00, 100000.00, 1100000.00, 'Pending', 'Cash', NOW(), NOW(), NOW());

-- Thêm chi tiết hóa đơn
INSERT INTO tbl_invoice_details (invoiceid, item_type, item_id, description, quantity, unit_price, total_price, created_at, modified_at)
VALUES 
((SELECT invoiceid FROM tbl_invoices WHERE invoice_number = 'INV001'),
'Service', 1, 'Khám tổng quát', 1, 500000.00, 500000.00, NOW(), NOW());