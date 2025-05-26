package project.springBoot;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Helloworld {
     @GetMapping("/")
    public String index() {
        return "Hello World";
    }
}
