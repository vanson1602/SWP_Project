package project.springBoot.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import project.springBoot.model.*;

import java.math.BigDecimal;

public interface WalletService {
    Wallet createWallet(User user);

    Wallet getOrCreateWallet(User user);

    Wallet getWalletByUser(User user);

    boolean hasWallet(User user);

    WalletTransaction deposit(User user, BigDecimal amount, String description);

    void deposit(User user, java.math.BigDecimal amount);

    WalletTransaction withdraw(User user, BigDecimal amount, String description);

    WalletTransaction payment(User user, Appointment appointment, BigDecimal amount);

    WalletTransaction refund(Appointment appointment);

    boolean isRefundable(Appointment appointment);

    boolean hasBeenRefunded(Appointment appointment);

    Page<WalletTransaction> getTransactionHistory(User user, Pageable pageable);

    BigDecimal getBalance(User user);

    void lockWallet(User user);

    void unlockWallet(User user);

    void saveWallet(Wallet wallet);

    void saveRefundTransaction(Wallet wallet, BigDecimal amount, Appointment appointment);
}