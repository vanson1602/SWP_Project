package project.springBoot.service.impl;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Objects;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import project.springBoot.model.Medication;
import project.springBoot.repository.MedicationRepository;
import project.springBoot.service.MedicationService;

@Service
@Transactional
public class MedicationServiceImpl implements MedicationService {

    @Autowired
    private MedicationRepository medicationRepository;

    @Override
    @Transactional(readOnly = true)
    public List<Medication> getAllMedications() {
        return medicationRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Medication findById(Long id) {
        if (Objects.isNull(id)) {
            throw new IllegalArgumentException("ID không được để trống");
        }
        return medicationRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy thuốc với ID: " + id));
    }

    @Override
    public Medication save(Medication medication) {
        validateMedication(medication);
        return medicationRepository.save(medication);
    }

    @Override
    public void deleteById(Long id) {
        if (Objects.isNull(id)) {
            throw new IllegalArgumentException("ID không được để trống");
        }
        
        // Check if medication exists before deleting
        if (!medicationRepository.existsById(id)) {
            throw new IllegalArgumentException("Không tìm thấy thuốc với ID: " + id);
        }
        
        medicationRepository.deleteById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Medication> findByNameContaining(String name) {
        if (Objects.isNull(name) || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Tên thuốc tìm kiếm không được để trống");
        }
        return medicationRepository.findByMedicationNameContainingIgnoreCase(name.trim());
    }

    private void validateMedication(Medication medication) {
        if (Objects.isNull(medication)) {
            throw new IllegalArgumentException("Thông tin thuốc không được để trống");
        }
        
        // Validate required fields
        if (Objects.isNull(medication.getMedicationName()) || medication.getMedicationName().trim().isEmpty()) {
            throw new IllegalArgumentException("Tên thuốc không được để trống");
        }
        
        if (Objects.isNull(medication.getStockQuantity())) {
            throw new IllegalArgumentException("Số lượng tồn kho không được để trống");
        }
        
        if (medication.getStockQuantity() < 0) {
            throw new IllegalArgumentException("Số lượng tồn kho không được âm");
        }
        
        if (Objects.isNull(medication.getPrice())) {
            throw new IllegalArgumentException("Giá thuốc không được để trống");
        }
        
        if (medication.getPrice().compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Giá thuốc không được âm");
        }

        // Validate expiry date
        if (medication.getExpiryDate() != null && medication.getExpiryDate().isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("Ngày hết hạn không hợp lệ");
        }

        // Validate dosage form
        if (Objects.nonNull(medication.getDosageForm()) && medication.getDosageForm().trim().isEmpty()) {
            throw new IllegalArgumentException("Dạng bào chế không hợp lệ");
        }

        // Validate strength
        if (Objects.nonNull(medication.getStrength()) && medication.getStrength().trim().isEmpty()) {
            throw new IllegalArgumentException("Hàm lượng không hợp lệ");
        }

        // Validate manufacturer
        if (Objects.nonNull(medication.getManufacturer()) && medication.getManufacturer().trim().isEmpty()) {
            throw new IllegalArgumentException("Nhà sản xuất không hợp lệ");
        }
    }

    @Override
    @Transactional
    public void updateStock(Long id, int quantity) {
        Medication medication = findById(id);
        int newQuantity = medication.getStockQuantity() + quantity;
        
        if (newQuantity < 0) {
            throw new IllegalArgumentException("Số lượng tồn kho không đủ");
        }
        
        medication.setStockQuantity(newQuantity);
        medicationRepository.save(medication);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Medication> findLowStockMedications(int threshold) {
        return medicationRepository.findByStockQuantityLessThanEqual(threshold);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Medication> findExpiringMedications(LocalDate date) {
        return medicationRepository.findByExpiryDateBefore(date);
    }
} 