package project.springBoot.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import io.micrometer.common.lang.NonNull;
import vn.payos.PayOS;

@Configuration
public class PayOSConfig implements WebMvcConfigurer {
    @Value("${PAYOS_CLIENT_ID}")
    private String PAYOS_CLIENT_ID;
    @Value("${PAYOS_API_KEY}")
    private String PAYOS_API_KEY;
    @Value("${PAYOS_CHECKSUM_KEY}")
    private String PAYOS_CHECKSUM_KEY;

    @Override
    public void addCorsMappings(@NonNull CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("*")
                .allowedMethods("*")
                .allowedHeaders("*")
                .exposedHeaders("*")
                .allowCredentials(false)
                .maxAge(3600);
    }

    @Bean
    public PayOS payOS() {
        return new PayOS(PAYOS_CLIENT_ID, PAYOS_API_KEY, PAYOS_CHECKSUM_KEY);
    }
}
