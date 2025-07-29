package project.springBoot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import lombok.RequiredArgsConstructor;
import project.springBoot.service.UploadFileService;

@RequestMapping("/api/upload")
@RestController
@RequiredArgsConstructor
public class UploadFileController {
    private final UploadFileService uploadFileService;

    @PostMapping("/images")
    public ResponseEntity<String> uploadImage(@RequestParam("file") MultipartFile file) {
        try {
            String imageUrl = uploadFileService.uploadImage(file);
            return ResponseEntity.ok(imageUrl); // HTTP 200
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Upload failed: " + e.getMessage());
        }
    }

}
