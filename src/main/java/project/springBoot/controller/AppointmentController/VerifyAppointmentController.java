package project.springBoot.controller.AppointmentController;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/appointments")
public class VerifyAppointmentController {
    @GetMapping("/verify")
    public String showVerifyForm() {
        return "appointment/verify-appointment";
    }

    @PostMapping("/verify")
    public String handleVerify(@RequestParam("verifyCode") String verifyCode, Model model) {
        // TODO: Thay thế logic xác thực thực tế ở đây
        if (verifyCode != null && verifyCode.trim().equalsIgnoreCase("123456")) {
            // Nếu mã đúng, chuyển hướng về trang thành công hoặc trang chi tiết lịch hẹn
            return "redirect:/appointments/verify-success";
        } else {
            model.addAttribute("error", "Mã xác thực không đúng hoặc đã hết hạn!");
            return "appointment/verify-appointment";
        }
    }

    @GetMapping("/verify-success")
    public String showVerifySuccess() {
        return "appointment/verify-success";
    }
}