package project.springBoot.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import project.springBoot.model.*;
import project.springBoot.repository.WalletRepository;
import project.springBoot.repository.WalletTransactionRepository;
import project.springBoot.repository.InvoiceRepository;
import project.springBoot.service.WalletService;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class WalletServiceImpl implements WalletService {
    private final WalletRepository walletRepository;
    private final WalletTransactionRepository transactionRepository;
    private final InvoiceRepository invoiceRepository;

    private static final BigDecimal MINIMUM_AMOUNT = new BigDecimal("10000"); // 10,000 VND
    private static final int REFUND_TIME_LIMIT_HOURS = 24;

    @Override
    @Transactional
    public Wallet createWallet(User user) {
        log.info("Creating wallet for user: {}", user.getUserID());

        if (walletRepository.existsByUser(user)) {
            log.warn("User {} already has a wallet", user.getUserID());
            throw new IllegalStateException("User already has a wallet");
        }

        try {
            Wallet wallet = new Wallet();
            wallet.setUser(user);
            wallet.setBalance(BigDecimal.ZERO);
            wallet.setLocked(false);
            Wallet savedWallet = walletRepository.save(wallet);
            log.info("Successfully created wallet for user: {}", user.getUserID());
            return savedWallet;
        } catch (Exception e) {
            log.error("Error creating wallet for user {}: {}", user.getUserID(), e.getMessage(), e);
            throw e;
        }
    }

    @Override
    public boolean hasBeenRefunded(Appointment appointment) {
        return transactionRepository.existsByAppointmentAndType(appointment, WalletTransaction.TransactionType.REFUND);
    }

    @Override
    public Wallet getOrCreateWallet(User user) {
        return walletRepository.findWithLockByUser(user).orElseGet(() -> createWallet(user));
    }

    @Override
    public void saveWallet(Wallet wallet) {
        walletRepository.save(wallet);
    }

    @Override
    public void saveRefundTransaction(Wallet wallet, BigDecimal amount, Appointment appointment) {
        WalletTransaction transaction = new WalletTransaction();
        transaction.setWallet(wallet);
        transaction.setAmount(amount);
        transaction.setBalanceAfter(wallet.getBalance());
        transaction.setType(WalletTransaction.TransactionType.REFUND);
        transaction.setAppointment(appointment);
        transaction.setDescription("Hoàn tiền lịch hẹn #" + appointment.getAppointmentID());
        transactionRepository.save(transaction);
    }

    @Override
    @Transactional(readOnly = true)
    public Wallet getWalletByUser(User user) {
        return walletRepository.findByUser(user)
                .orElseThrow(() -> new IllegalStateException("Wallet not found"));
    }

    @Override
    @Transactional(readOnly = true)
    public boolean hasWallet(User user) {
        return walletRepository.existsByUser(user);
    }

    @Override
    @Transactional
    public WalletTransaction deposit(User user, BigDecimal amount, String description) {
        log.info("Processing deposit for user {}: {} VND", user.getUserID(), amount);

        if (amount.compareTo(MINIMUM_AMOUNT) < 0) {
            log.warn("Deposit amount {} is below minimum {}", amount, MINIMUM_AMOUNT);
            throw new IllegalArgumentException("Minimum deposit amount is " + MINIMUM_AMOUNT + " VND");
        }

        try {
            Wallet wallet = walletRepository.findWithLockByUser(user)
                    .orElseGet(() -> createWallet(user));

            if (wallet.isLocked()) {
                log.warn("Cannot deposit to locked wallet for user {}", user.getUserID());
                throw new IllegalStateException("Wallet is locked");
            }

            wallet.setBalance(wallet.getBalance().add(amount));
            walletRepository.save(wallet);

            WalletTransaction transaction = new WalletTransaction();
            transaction.setWallet(wallet);
            transaction.setAmount(amount);
            transaction.setBalanceAfter(wallet.getBalance());
            transaction.setType(WalletTransaction.TransactionType.DEPOSIT);
            transaction.setDescription(description);

            WalletTransaction savedTransaction = transactionRepository.save(transaction);
            log.info("Successfully processed deposit for user {}: {} VND", user.getUserID(), amount);
            return savedTransaction;
        } catch (Exception e) {
            log.error("Error processing deposit for user {}: {}", user.getUserID(), e.getMessage(), e);
            throw e;
        }
    }

    @Override
    @Transactional
    public WalletTransaction withdraw(User user, BigDecimal amount, String description) {
        if (amount.compareTo(MINIMUM_AMOUNT) < 0) {
            throw new IllegalArgumentException("Minimum withdrawal amount is " + MINIMUM_AMOUNT + " VND");
        }

        Wallet wallet = walletRepository.findWithLockByUser(user)
                .orElseThrow(() -> new IllegalStateException("Wallet not found"));

        if (wallet.isLocked()) {
            throw new IllegalStateException("Wallet is locked");
        }

        if (wallet.getBalance().compareTo(amount) < 0) {
            throw new IllegalStateException("Insufficient balance");
        }

        wallet.setBalance(wallet.getBalance().subtract(amount));
        walletRepository.save(wallet);

        WalletTransaction transaction = new WalletTransaction();
        transaction.setWallet(wallet);
        transaction.setAmount(amount);
        transaction.setBalanceAfter(wallet.getBalance());
        transaction.setType(WalletTransaction.TransactionType.WITHDRAW);
        transaction.setDescription(description);

        return transactionRepository.save(transaction);
    }

    @Override
    @Transactional
    public WalletTransaction payment(User user, Appointment appointment, BigDecimal amount) {
        Wallet wallet = walletRepository.findWithLockByUser(user)
                .orElseThrow(() -> new IllegalStateException("Wallet not found"));

        if (wallet.isLocked()) {
            throw new IllegalStateException("Wallet is locked");
        }

        if (wallet.getBalance().compareTo(amount) < 0) {
            throw new IllegalStateException("Insufficient balance");
        }

        wallet.setBalance(wallet.getBalance().subtract(amount));
        walletRepository.save(wallet);

        WalletTransaction transaction = new WalletTransaction();
        transaction.setWallet(wallet);
        transaction.setAmount(amount);
        transaction.setBalanceAfter(wallet.getBalance());
        transaction.setType(WalletTransaction.TransactionType.PAYMENT);
        transaction.setAppointment(appointment);
        transaction.setDescription("Thanh toán lịch hẹn #" + appointment.getAppointmentID());
        WalletTransaction savedTx = transactionRepository.save(transaction);

        // Tạo hóa đơn nếu chưa có
        if (invoiceRepository != null && appointment != null) {
            if (invoiceRepository.findByAppointment(appointment).isEmpty()) {
                Invoice invoice = new Invoice();
                invoice.setAppointment(appointment);
                invoice.setPatient(appointment.getPatient());
                invoice.setInvoiceNumber(project.springBoot.utils.InvoiceUtils.generateInvoiceNumber());
                invoice.setTotalAmount(amount);
                invoice.setFinalAmount(amount);
                invoice.setPaymentStatus("Paid");
                invoice.setPaymentMethod("WALLET");
                invoice.setInvoiceDate(java.time.LocalDateTime.now());
                invoice.setCreatedAt(java.time.LocalDateTime.now());
                invoice.setModifiedAt(java.time.LocalDateTime.now());
                invoiceRepository.save(invoice);
            }
        }
        return savedTx;
    }

    @Override
    @Transactional
    public WalletTransaction refund(Appointment appointment) {
        if (!isRefundable(appointment)) {
            throw new IllegalStateException("Appointment is not eligible for refund");
        }

        if (hasBeenRefunded(appointment)) {
            throw new IllegalStateException("Appointment has already been refunded");
        }

        // Chỉ cần kiểm tra invoice đã thanh toán
        Optional<Invoice> invoiceOpt = invoiceRepository.findByAppointment(appointment);
        if (invoiceOpt.isEmpty() || !"Paid".equalsIgnoreCase(invoiceOpt.get().getPaymentStatus())) {
            throw new IllegalStateException("Lịch hẹn chưa thanh toán, không thể hoàn tiền");
        }
        Invoice invoice = invoiceOpt.get();
        BigDecimal originalAmount = invoice.getFinalAmount();

        LocalDateTime now = LocalDateTime.now();
        LocalDateTime appointmentTime = appointment.getAppointmentDate();
        long hoursUntilAppointment = ChronoUnit.HOURS.between(now, appointmentTime);
        BigDecimal refundAmount;
        if (hoursUntilAppointment >= 12) {
            refundAmount = originalAmount.multiply(BigDecimal.valueOf(0.9)); // hoàn 90%
        } else {
            throw new IllegalStateException("Không đủ điều kiện hoàn tiền (chỉ hủy lịch)");
        }
        refundAmount = refundAmount.setScale(0, RoundingMode.DOWN); // Làm tròn xuống số nguyên

        Wallet wallet = walletRepository.findWithLockByUser(appointment.getPatient().getUser())
                .orElseGet(() -> createWallet(appointment.getPatient().getUser()));
        wallet.setBalance(wallet.getBalance().add(refundAmount));
        walletRepository.save(wallet);

        WalletTransaction transaction = new WalletTransaction();
        transaction.setWallet(wallet);
        transaction.setAmount(refundAmount);
        transaction.setBalanceAfter(wallet.getBalance());
        transaction.setType(WalletTransaction.TransactionType.REFUND);
        transaction.setAppointment(appointment);
        transaction.setDescription("Hoàn 90% tiền lịch hẹn #" + appointment.getAppointmentID());

        return transactionRepository.save(transaction);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isRefundable(Appointment appointment) {
        if (appointment == null || appointment.getStatus() == null) {
            return false;
        }
        if (!appointment.getStatus().equalsIgnoreCase("Cancelled")) {
            return false;
        }
        LocalDateTime appointmentTime = appointment.getAppointmentDate();
        LocalDateTime now = LocalDateTime.now();
        long hoursUntilAppointment = ChronoUnit.HOURS.between(now, appointmentTime);
        return hoursUntilAppointment >= 12;
    }

    @Override
    @Transactional(readOnly = true)
    public Page<WalletTransaction> getTransactionHistory(User user, Pageable pageable) {
        Wallet wallet = walletRepository.findByUser(user)
                .orElseThrow(() -> new IllegalStateException("Wallet not found"));
        return transactionRepository.findByWalletOrderByCreatedAtDesc(wallet, pageable);
    }

    @Override
    @Transactional(readOnly = true)
    public BigDecimal getBalance(User user) {
        return walletRepository.findByUser(user)
                .map(Wallet::getBalance)
                .orElseThrow(() -> new IllegalStateException("User does not have a wallet"));
    }

    @Override
    @Transactional
    public void lockWallet(User user) {
        Wallet wallet = walletRepository.findWithLockByUser(user)
                .orElseThrow(() -> new IllegalStateException("Wallet not found"));
        wallet.setLocked(true);
        walletRepository.save(wallet);
    }

    @Override
    @Transactional
    public void unlockWallet(User user) {
        Wallet wallet = walletRepository.findWithLockByUser(user)
                .orElseThrow(() -> new IllegalStateException("Wallet not found"));
        wallet.setLocked(false);
        walletRepository.save(wallet);
    }

    @Override
    @Transactional
    public void deposit(User user, BigDecimal amount) {
        Wallet wallet = walletRepository.findWithLockByUser(user)
                .orElseThrow(() -> new IllegalStateException("Wallet not found"));
        wallet.setBalance(wallet.getBalance().add(amount));
        walletRepository.save(wallet);

        WalletTransaction transaction = new WalletTransaction();
        transaction.setWallet(wallet);
        transaction.setAmount(amount);
        transaction.setBalanceAfter(wallet.getBalance());
        transaction.setType(WalletTransaction.TransactionType.DEPOSIT);
        transaction.setDescription("Nạp tiền vào ví");
        transactionRepository.save(transaction);
    }
}