package project.springBoot.service;

import java.util.List;

import jakarta.servlet.http.HttpServletResponse;
import project.springBoot.model.Prescription;

public interface ExportFileService {
    public void setRespondHeader(HttpServletResponse response, String contentType, String extension, String prefix);
    public void exportToCsv(HttpServletResponse response, List<Prescription> prescriptions );
    public void exportToPdf(HttpServletResponse response, List<Prescription> prescriptions );
}
