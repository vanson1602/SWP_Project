package project.springBoot.service.impl;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.UUID;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import project.springBoot.service.UploadFileService;

@Service
@RequiredArgsConstructor
@Slf4j
public class UploadFileImpl implements UploadFileService {
    private final Cloudinary cloudinary;

    @Override
    public String uploadImage(MultipartFile file) {
        assert file.getOriginalFilename() != null;
        String publicValue = generatePublicValue(file.getOriginalFilename());
        log.info("publicValue is : {}", publicValue);
        String extension = getFileName(file.getOriginalFilename())[1];
        log.info("extension is : {}", extension);
        File fileUpload = convert(file);
        log.info("File upload is : {}", fileUpload);
        try {
            cloudinary.uploader().upload(fileUpload,
                    ObjectUtils.asMap("public_id", publicValue));
            cleanDisk(fileUpload);

        } catch (IOException e) {

            e.printStackTrace();
        }

        return cloudinary.url().generate(StringUtils.join(publicValue, ".", extension));
    }

    private File convert(MultipartFile file) {
        assert file.getOriginalFilename() != null;
        File convFile = new File(StringUtils.join(generatePublicValue(file.getOriginalFilename()),
                getFileName(file.getOriginalFilename())[1]));
        try (InputStream is = file.getInputStream()) {
            Files.copy(is, convFile.toPath());
        } catch (IOException e) {

            e.printStackTrace();
        }
        return convFile;
    }

    public String generatePublicValue(String originalName) {
        String fileName = getFileName(originalName)[0];
        return StringUtils.join(UUID.randomUUID().toString(), "_", fileName);
    }
    public void cleanDisk(File file) {
        log.info("File.toppath", file.toPath());
        try {
            Path filePath = file.toPath();
            Files.delete(filePath);
        } catch (Exception e) {
            log.info("Error");
        }
    }

    public String[] getFileName(String originalName) {
        return originalName.split("\\.");
    }

}
