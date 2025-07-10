package project.springBoot.utils;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.atomic.AtomicInteger;

public class InvoiceUtils {
    private static final AtomicInteger sequence = new AtomicInteger(1);
    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyMMdd");

    public static String generateInvoiceNumber() {
        LocalDateTime now = LocalDateTime.now();
        String dateStr = now.format(formatter);
        int seq = sequence.getAndIncrement();
        if (seq > 9999) {
            sequence.set(1);
            seq = 1;
        }
        return String.format("INV%s%04d", dateStr, seq);
    }
}