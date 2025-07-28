package project.springBoot.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import lombok.RequiredArgsConstructor;

import project.springBoot.model.*;
import project.springBoot.service.WalletService;
import project.springBoot.service.AppointmentService;
import project.springBoot.service.NotificationService;

import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.Map;
import java.util.Date;
import java.util.HashMap;

import vn.payos.PayOS;
import vn.payos.type.CheckoutResponseData;
import vn.payos.type.ItemData;
import vn.payos.type.PaymentData;

@Controller
@RequestMapping("/wallet")
@RequiredArgsConstructor
public class WalletController {
    private final WalletService walletService;
    private final AppointmentService appointmentService;
    private final PayOS payOS;
    private final NotificationService notificationService;

    @GetMapping
    public String getWalletPage(Model model, HttpSession session,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        // Add notification count
        int notificationCount = notificationService.getUnreadNotificationsCount(currentUser.getUserID());
        model.addAttribute("notificationCount", notificationCount);

        // Kiểm tra xem người dùng đã có ví chưa
        boolean hasWallet = walletService.hasWallet(currentUser);
        if (!hasWallet) {
            model.addAttribute("hasWallet", false);
            return "wallet/wallet-register";
        }

        // Lấy thông tin ví và lịch sử giao dịch
        Wallet wallet = walletService.getWalletByUser(currentUser);
        Page<WalletTransaction> transactions = walletService.getTransactionHistory(
                currentUser, PageRequest.of(page, size));

        model.addAttribute("hasWallet", true);
        model.addAttribute("wallet", wallet);
        model.addAttribute("transactions", transactions);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", transactions.getTotalPages());

        return "wallet/wallet-dashboard";
    }

    @GetMapping("/register")
    public String showRegisterWalletPage(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null)
            return "redirect:/login";
        if (walletService.hasWallet(currentUser))
            return "redirect:/wallet";

        // Add notification count
        int notificationCount = notificationService.getUnreadNotificationsCount(currentUser.getUserID());
        model.addAttribute("notificationCount", notificationCount);

        return "wallet/wallet-register";
    }

    @PostMapping("/register")
    public String registerWallet(Model model, HttpSession session,
            org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null)
            return "redirect:/login";
        if (walletService.hasWallet(currentUser)) {
            redirectAttributes.addFlashAttribute("error", "Bạn đã có ví điện tử!");
            return "redirect:/wallet";
        }
        try {
            walletService.createWallet(currentUser);
            redirectAttributes.addFlashAttribute("message",
                    "Đăng ký ví thành công! Bạn có thể nạp tiền vào ví để sử dụng.");
            return "redirect:/wallet";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            return "redirect:/wallet/register";
        }
    }

    @GetMapping("/deposit")
    public String showDepositForm() {
        return "wallet/wallet-deposit";
    }

    @PostMapping("/deposit")
    public String deposit(@RequestParam BigDecimal amount, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null)
            return "redirect:/login";
        String currentTimeString = String.valueOf(new Date().getTime());
        long orderCode = Long.parseLong(currentTimeString.substring(currentTimeString.length() - 6));
        ItemData item = ItemData.builder()
                .name("Nạp tiền vào ví")
                .price(amount.intValue())
                .quantity(1)
                .build();
        PaymentData paymentData = PaymentData.builder()
                .orderCode(orderCode)
                .amount(amount.intValue())
                .description("Nạp tiền vào ví")
                .returnUrl("http://localhost:8080/wallet/deposit-success")
                .cancelUrl("http://localhost:8080/wallet/deposit-cancel")
                .item(item)
                .build();
        try {
            CheckoutResponseData checkoutResponseData = payOS.createPaymentLink(paymentData);
            session.setAttribute("pendingDepositAmount", amount);
            return "redirect:" + checkoutResponseData.getCheckoutUrl();
        } catch (Exception e) {
            return "redirect:/wallet?error=payment";
        }
    }

    @GetMapping("/deposit-success")
    public String depositSuccess(HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        BigDecimal amount = (BigDecimal) session.getAttribute("pendingDepositAmount");
        if (user != null && amount != null) {
            walletService.deposit(user, amount);
            session.removeAttribute("pendingDepositAmount");
        }
        return "wallet/wallet-deposit-success";
    }

    @GetMapping("/deposit-cancel")
    public String depositCancel() {
        return "wallet/wallet-deposit-cancel";
    }

    @PostMapping("/withdraw")
    @ResponseBody
    public ResponseEntity<?> withdraw(HttpSession session,
            @RequestParam BigDecimal amount,
            @RequestParam(required = false) String description) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return ResponseEntity.badRequest().body(Map.of("error", "User not authenticated"));
            }

            WalletTransaction transaction = walletService.withdraw(currentUser, amount, description);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("newBalance", transaction.getBalanceAfter());
            response.put("message", "Rút tiền thành công: " + amount + " VNĐ");

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/refund/{appointmentId}")
    @ResponseBody
    public ResponseEntity<?> refund(HttpSession session, @PathVariable Long appointmentId) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return ResponseEntity.badRequest().body(Map.of("error", "User not authenticated"));
            }

            Appointment appointment = appointmentService.getAppointmentById(appointmentId);
            if (appointment == null) {
                return ResponseEntity.badRequest().body(Map.of("error", "Appointment not found"));
            }

            // Kiểm tra quyền hoàn tiền (chỉ admin hoặc chính bệnh nhân)
            if (!currentUser.getRole().equals("admin") &&
                    (currentUser.getUserID() != appointment.getPatient().getUser().getUserID())) {
                return ResponseEntity.badRequest().body(Map.of("error", "Unauthorized"));
            }

            if (!walletService.isRefundable(appointment)) {
                return ResponseEntity.badRequest().body(Map.of(
                        "error", "Lịch hẹn không đủ điều kiện hoàn tiền. " +
                                "Vui lòng kiểm tra trạng thái và thời gian hủy."));
            }

            WalletTransaction transaction = walletService.refund(appointment);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("newBalance", transaction.getBalanceAfter());
            response.put("message", "Hoàn tiền thành công: " + transaction.getAmount() + " VNĐ");

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/check-refund/{appointmentId}")
    @ResponseBody
    public ResponseEntity<?> checkRefundEligibility(@PathVariable Long appointmentId) {
        try {
            Appointment appointment = appointmentService.getAppointmentById(appointmentId);
            if (appointment == null) {
                return ResponseEntity.badRequest().body(Map.of("error", "Appointment not found"));
            }

            boolean isRefundable = walletService.isRefundable(appointment);
            boolean hasBeenRefunded = walletService.hasBeenRefunded(appointment);

            Map<String, Object> response = new HashMap<>();
            response.put("isRefundable", isRefundable);
            response.put("hasBeenRefunded", hasBeenRefunded);

            if (!isRefundable) {
                response.put("reason", "Lịch hẹn không đủ điều kiện hoàn tiền. " +
                        "Vui lòng kiểm tra trạng thái và thời gian hủy.");
            }
            if (hasBeenRefunded) {
                response.put("reason", "Lịch hẹn đã được hoàn tiền trước đó.");
            }

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/balance")
    @ResponseBody
    public ResponseEntity<?> getBalance(HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return ResponseEntity.badRequest().body(Map.of("error", "User not authenticated"));
            }

            BigDecimal balance = walletService.getBalance(currentUser);
            return ResponseEntity.ok(Map.of("balance", balance));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
}