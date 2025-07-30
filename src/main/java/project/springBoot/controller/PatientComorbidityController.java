package project.springBoot.controller;

import java.util.List;
import java.time.format.DateTimeFormatter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.http.MediaType;

import project.springBoot.model.Patient;
import project.springBoot.model.PatientComorbidity;
import project.springBoot.service.PatientComorbidityService;
import project.springBoot.service.PatientService;

@Controller
public class PatientComorbidityController {

    @Autowired
    private PatientComorbidityService patientComorbidityService;

    @Autowired
    private PatientService patientService;

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    @GetMapping(value = "/patients/{patientId}/comorbidities", produces = MediaType.TEXT_HTML_VALUE + ";charset=UTF-8")
    @ResponseBody
    public String getPatientComorbidities(@PathVariable Long patientId, Model model) {
        try {
            // Tìm bệnh nhân
            Patient patient = patientService.findById(patientId).orElse(null);
            if (patient == null) {
                return "<div class=\"alert alert-danger\">" +
                        "<i class=\"bi bi-exclamation-triangle me-2\"></i>" +
                        "Không tìm thấy bệnh nhân</div>";
            }

            // Lấy danh sách bệnh nền
            List<PatientComorbidity> comorbidities = patientComorbidityService.getComorbidities(patient);

            if (comorbidities.isEmpty()) {
                return "<div class=\"empty-state text-center py-4\">" +
                        "<i class=\"bi bi-clipboard-x fs-1 text-muted mb-3\"></i>" +
                        "<p class=\"text-muted\">Bệnh nhân không có bệnh nền nào được ghi nhận.</p></div>";
            }

            StringBuilder html = new StringBuilder();
            html.append("<div class=\"comorbidity-items\">");

            for (PatientComorbidity comorbidity : comorbidities) {
                html.append("<div class=\"comorbidity-item mb-3 p-3 border rounded bg-light\">");
                html.append("<div class=\"d-flex justify-content-between align-items-start\">");
                html.append("<h5 class=\"mb-2\">").append(comorbidity.getIcdCode().getDescription()).append("</h5>");
                html.append("<span class=\"badge bg-info\">").append(comorbidity.getIcdCode().getIcdCode())
                        .append("</span>");
                html.append("</div>");

                if (comorbidity.getDiagnosisDate() != null) {
                    html.append("<p class=\"mb-2 text-muted\"><i class=\"bi bi-calendar-event me-2\"></i>")
                            .append("Ngày phát hiện: ")
                            .append(comorbidity.getDiagnosisDate().format(DATE_FORMATTER))
                            .append("</p>");
                }

                if (comorbidity.getNotes() != null && !comorbidity.getNotes().isEmpty()) {
                    html.append("<div class=\"mt-2 pt-2 border-top\">");
                    html.append("<p class=\"mb-0\"><i class=\"bi bi-journal-text me-2\"></i>")
                            .append("<strong>Ghi chú:</strong><br/>")
                            .append("<span class=\"text-muted\">").append(comorbidity.getNotes()).append("</span></p>");
                    html.append("</div>");
                }

                html.append("</div>");
            }

            html.append("</div>");
            return html.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return "<div class=\"alert alert-danger\">" +
                    "<i class=\"bi bi-exclamation-triangle me-2\"></i>" +
                    "Có lỗi xảy ra khi tải thông tin bệnh nền: " + e.getMessage() + "</div>";
        }
    }
}