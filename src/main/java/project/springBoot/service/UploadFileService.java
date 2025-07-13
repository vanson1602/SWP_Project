package project.springBoot.service;

import org.springframework.web.multipart.MultipartFile;

public interface  UploadFileService {
    String uploadImage(MultipartFile file);
}
