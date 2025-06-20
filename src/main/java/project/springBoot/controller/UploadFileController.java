package project.springBoot.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import lombok.RequiredArgsConstructor;
import project.springBoot.service.UploadFileService;

@RequestMapping("/api/upload")
@RestController
@RequiredArgsConstructor 
public class UploadFileController {
    private final UploadFileService uploadFileService;
    @PostMapping("/images")
    public String uploadImage(@RequestParam("file") MultipartFile file){
       
        return uploadFileService.uploadImage(file);
    }
}
