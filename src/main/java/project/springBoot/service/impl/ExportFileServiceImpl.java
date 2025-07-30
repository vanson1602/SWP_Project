package project.springBoot.service.impl;

import java.io.IOException;

import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import project.springBoot.model.Prescription;
import project.springBoot.service.ExportFileService;

@Service
@Transactional
@RequiredArgsConstructor

public class ExportFileServiceImpl implements ExportFileService {
    @Override
    public void setRespondHeader(HttpServletResponse response, String contentType, String extension, String prefix) {
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd_HHmmss");
        String timestamp = dateFormat.format(new Date());
        String fileName = prefix + timestamp + extension;
        response.setCharacterEncoding("UTF-8");
        response.setContentType(contentType);
        String headerKey = "Content-Disposition";
        String headerValue = "attachment; filename=" + fileName;
        response.setHeader(headerKey, headerValue);
    }

    @Override
    public void exportToCsv(HttpServletResponse response, List<Prescription> prescriptions) {
        setRespondHeader(response, "text/csv; charset=UTF-8", ".csv", "prescription_");

        try {
            // Thêm BOM để Excel hiểu UTF-8 (EF BB BF)
            response.getOutputStream().write(0xEF);
            response.getOutputStream().write(0xBB);
            response.getOutputStream().write(0xBF);

            PrintWriter writer = new PrintWriter(response.getOutputStream(), true,
                    java.nio.charset.StandardCharsets.UTF_8);

            writer.println("STT,Tên thuốc,Số lượng,Liều lượng,Tần suất,Thời gian dùng,Hướng dẫn");

            int stt = 1;
            for (Prescription pres : prescriptions) {
                writer.printf("%d,%s,%d,%s,%s,%s,%s%n",
                        stt++,
                        pres.getMedication().getMedicationName(),
                        pres.getQuantity(),
                        pres.getDosage(),
                        pres.getFrequency(),
                        pres.getDuration(),
                        pres.getInstructions().replace(",", ";")); // tránh xung đột dấu phẩy
            }

            writer.flush();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void exportToPdf(HttpServletResponse response, List<Prescription> prescriptions) {
        setRespondHeader(response, "application/pdf", ".pdf", "prescription_");
        try {
            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            String fontPath = new ClassPathResource("fonts/NotoSans-Regular.ttf").getPath();
            BaseFont baseFont = BaseFont.createFont(fontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
            Font font = new Font(baseFont, 12);
            Font titleFont = new Font(baseFont, 16, Font.BOLD);

            Paragraph title = new Paragraph("ĐƠN THUỐC", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);
            document.add(new Paragraph(" ")); // dòng trắng

            PdfPTable table = new PdfPTable(7); // 7 cột
            table.setWidthPercentage(100f);
            table.setSpacingBefore(10f);

            // Header
            table.addCell(new Phrase("STT", font));
            table.addCell(new Phrase("Tên thuốc", font));
            table.addCell(new Phrase("Số lượng", font));
            table.addCell(new Phrase("Liều lượng", font));
            table.addCell(new Phrase("Tần suất", font));
            table.addCell(new Phrase("Thời gian dùng", font));
            table.addCell(new Phrase("Hướng dẫn", font));

            int stt = 1;
            for (Prescription pres : prescriptions) {
                table.addCell(new Phrase(String.valueOf(stt++), font));
                table.addCell(new Phrase(pres.getMedication().getMedicationName(), font));
                table.addCell(new Phrase(String.valueOf(pres.getQuantity()), font));
                table.addCell(new Phrase(pres.getDosage(), font));
                table.addCell(new Phrase(pres.getFrequency(), font));
                table.addCell(new Phrase(pres.getDuration(), font));
                table.addCell(new Phrase(pres.getInstructions(), font));
            }

            document.add(table);
            document.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    

}