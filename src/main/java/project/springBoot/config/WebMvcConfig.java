package project.springBoot.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;

@Configuration
@EnableWebMvc
public class WebMvcConfig implements WebMvcConfigurer {

    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/WEB-INF/view/");
        resolver.setSuffix(".jsp");
        resolver.setViewClass(JstlView.class);
        registry.viewResolver(resolver);
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Static resources
        registry.addResourceHandler("/resources/**")
                .addResourceLocations("/resources/", "classpath:/static/")
                .setCachePeriod(3600)
                .resourceChain(true);
                
        // CSS files
        registry.addResourceHandler("/css/**")
                .addResourceLocations("/resources/css/")
                .setCachePeriod(3600)
                .resourceChain(true);
                
        // Uploaded files
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:uploads/")
                .setCachePeriod(3600)
                .resourceChain(true);
                
        // Add webjars if needed
        registry.addResourceHandler("/webjars/**")
                .addResourceLocations("classpath:/META-INF/resources/webjars/")
                .resourceChain(true);
    }
}
