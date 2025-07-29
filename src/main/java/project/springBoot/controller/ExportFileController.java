package project.springBoot.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpServletResponse;
import project.springBoot.model.Prescription;
import project.springBoot.service.ExportFileService;
import project.springBoot.service.PrescriptionService;

@Controller
public class ExportFileController {
    @Autowired
    private PrescriptionService prescriptionService;
    @Autowired
    private ExportFileService exportFileService;

    @GetMapping("/doctor/prescription/export/pdf")
    public void exportPdf(@RequestParam("examinationId") Long examinationId, HttpServletResponse response) {
        List<Prescription> prescriptions = prescriptionService.findByExaminationId(examinationId);
        exportFileService.exportToPdf(response, prescriptions);
    }

    @GetMapping("/doctor/prescription/export/csv")
    public void exportCsv(@RequestParam("examinationId") Long examinationId, HttpServletResponse response) {
        List<Prescription> prescriptions = prescriptionService.findByExaminationId(examinationId);
        exportFileService.exportToCsv(response, prescriptions);
    }
}
