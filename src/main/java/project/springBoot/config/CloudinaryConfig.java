package project.springBoot.config;

import java.util.HashMap;
import java.util.Map;

import org.springframework.context.annotation.Bean;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

import com.cloudinary.Cloudinary;

@Configuration
public class CloudinaryConfig {
    Map config = new HashMap<>();

    // private String CLOUD_NAME = "davsm8nyf";

    // private String API_KEY = "788326782389462";

    // private String API_SECRET = "FCLCI7G_zz_Wu-XxIojvIu5He4s";

    @Bean
    public Cloudinary getCloudinary() {
        config.put("cloud_name", "davsm8nyf");
        config.put("api_key", "788326782389462");
        config.put("api_secret", "FCLCI7G_zz_Wu-XxIojvIu5He4s");
        return new Cloudinary(config);

    }

}
