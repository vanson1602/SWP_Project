-- Create wallets table
CREATE TABLE IF NOT EXISTS wallets (
    wallet_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    balance DECIMAL(19,2) NOT NULL DEFAULT 0,
    is_locked BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Create wallet_transactions table
CREATE TABLE IF NOT EXISTS wallet_transactions (
    transaction_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    wallet_id BIGINT NOT NULL,
    amount DECIMAL(19,2) NOT NULL,
    balance_after DECIMAL(19,2) NOT NULL,
    type VARCHAR(20) NOT NULL,
    description VARCHAR(500),
    appointment_id BIGINT,
    created_at TIMESTAMP NOT NULL,
    FOREIGN KEY (wallet_id) REFERENCES wallets(wallet_id),
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

-- Insert sample wallets
INSERT INTO wallets (user_id, balance, is_locked, created_at, updated_at)
SELECT user_id, 0, false, NOW(), NOW()
FROM users
WHERE NOT EXISTS (
    SELECT 1 FROM wallets w WHERE w.user_id = users.user_id
);

-- Insert sample wallet transactions
INSERT INTO wallet_transactions (wallet_id, amount, balance_after, type, description, created_at)
SELECT w.wallet_id, 1000000, 1000000, 'DEPOSIT', 'Nạp tiền ban đầu', NOW()
FROM wallets w
WHERE NOT EXISTS (
    SELECT 1 FROM wallet_transactions t WHERE t.wallet_id = w.wallet_id
);
