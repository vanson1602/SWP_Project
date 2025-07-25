package project.springBoot.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import project.springBoot.model.WalletTransaction;
import project.springBoot.model.Wallet;
import project.springBoot.model.Appointment;
import project.springBoot.model.WalletTransaction.TransactionType;

import java.util.List;
import java.util.Optional;

public interface WalletTransactionRepository extends JpaRepository<WalletTransaction, Long> {
        Page<WalletTransaction> findByWalletOrderByCreatedAtDesc(Wallet wallet, Pageable pageable);

        List<WalletTransaction> findByAppointmentAndType(Appointment appointment, TransactionType type);

        @Query("SELECT COUNT(t) > 0 FROM WalletTransaction t WHERE t.appointment = :appointment AND t.type = :type")
        boolean existsByAppointmentAndType(@Param("appointment") Appointment appointment,
                        @Param("type") TransactionType type);

        Optional<WalletTransaction> findFirstByWalletOrderByCreatedAtDesc(Wallet wallet);
}