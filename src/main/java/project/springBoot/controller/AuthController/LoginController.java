package project.springBoot.controller.AuthController;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import jakarta.servlet.http.HttpSession;
import project.springBoot.model.Patient;
import project.springBoot.model.User;
import project.springBoot.repository.PatientRepository;
import project.springBoot.service.UserService;

@Controller
public class LoginController {
    @Value("${google.client.id}")
    private String clientId;

    @Value("${google.redirect.uri}")
    private String redirectUri;
    @Value("${google.client.secret}")
    private String clientSecret;
    private final UserService userService;
    private final PatientRepository patientRepository;

    public LoginController(UserService userService, PatientRepository patientRepository) {
        this.userService = userService;
        this.patientRepository = patientRepository;
    }

    @GetMapping("/login")
    public String loginPage(Model model, @RequestParam(required = false) String error) {
        if (error != null) {
            model.addAttribute("error", "Email/tên đăng nhập hoặc mật khẩu không chính xác!");
        }
        String googleLoginUrl = "https://accounts.google.com/o/oauth2/v2/auth?" +
                "client_id=" + clientId +
                "&redirect_uri=" + redirectUri +
                "&response_type=code" +
                "&scope=openid%20email%20profile" +
                "&access_type=online";
        model.addAttribute("googleLoginUrl", googleLoginUrl);
        return "authentication/form-login";
    }

    @PostMapping("/login")
    public String handleLogin(@RequestParam String emailorusername,
            @RequestParam String password,
            HttpSession session,
            Model model) {
        System.out.println("Login controller received request for: " + emailorusername);

        try {
            // Kiểm tra user có tồn tại không
            User user = userService.getUserByEmailOrUsername(emailorusername, emailorusername);
            if (user == null) {
                model.addAttribute("error", "Tài khoản không tồn tại!");
                model.addAttribute("emailorusername", emailorusername);
                return "authentication/form-login";
            }

            // Kiểm tra đã xác thực email chưa
            if (!user.isVerified()) {
                model.addAttribute("error", "Tài khoản chưa được xác thực! Vui lòng kiểm tra email để xác thực.");
                model.addAttribute("emailorusername", emailorusername);
                return "authentication/form-login";
            }

            // Thử đăng nhập
            user = userService.login(emailorusername, password);
            if (user != null) {
                session.setAttribute("currentUser", user);
                String role = user.getRole();
                System.out.println("Login successful. User role: " + role);

                if ("admin".equalsIgnoreCase(role)) {
                    return "redirect:/admin";
                } else if ("doctor".equalsIgnoreCase(role)) {
                    // Get doctor ID and set it in session
                    Long doctorId = userService.getDoctorIdByUserId(user.getUserID());
                    if (doctorId != null) {
                        session.setAttribute("doctorId", doctorId);
                        System.out.println("Set doctorId in session: " + doctorId);
                    } else {
                        System.out.println("Could not find doctorId for user: " + user.getUserID());
                    }
                    return "redirect:/doctor/home";
                } else {
                    // Create patient record for existing user if needed
                    if ("patient".equalsIgnoreCase(user.getRole())) {
                        Patient patient = patientRepository.findByUser(user);
                        if (patient == null) {
                            patient = new Patient();
                            patient.setUser(user);
                            patient.setPatientCode("P" + String.format("%06d", user.getUserID()));
                            patientRepository.save(patient);
                        }
                    }
                    return "redirect:/";
                }
            } else {
                model.addAttribute("error", "Tên đăng nhập hoăc mật khẩu không chính xác!");
                model.addAttribute("emailorusername", emailorusername);
                return "authentication/form-login";
            }
        } catch (Exception e) {
            System.out.println("Login error: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "Có lỗi xảy ra trong quá trình đăng nhập!");
            model.addAttribute("emailorusername", emailorusername);
            return "authentication/form-login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    @GetMapping("/oauth2/callback")
    public String oauth2Callback(@RequestParam("code") String code, HttpSession session, Model model) {
        try {
            RestTemplate restTemplate = new RestTemplate();

            String tokenRequestUrl = "https://oauth2.googleapis.com/token";

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

            MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
            params.add("code", code);
            params.add("client_id", clientId);
            params.add("client_secret", clientSecret);
            params.add("redirect_uri", redirectUri);
            params.add("grant_type", "authorization_code");

            HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);

            ResponseEntity<String> response = restTemplate.postForEntity(tokenRequestUrl, request, String.class);

            if (response.getStatusCode() == HttpStatus.OK) {
                JSONObject jsonObject = new JSONObject(response.getBody());
                String accessToken = jsonObject.getString("access_token");

                HttpHeaders userInfoHeaders = new HttpHeaders();
                userInfoHeaders.setBearerAuth(accessToken);

                HttpEntity<String> userInfoRequest = new HttpEntity<>(userInfoHeaders);

                ResponseEntity<String> userInfoResponse = restTemplate.exchange(
                        "https://openidconnect.googleapis.com/v1/userinfo",
                        HttpMethod.GET,
                        userInfoRequest,
                        String.class);

                if (userInfoResponse.getStatusCode() == HttpStatus.OK) {
                    JSONObject userInfo = new JSONObject(userInfoResponse.getBody());
                    String email = userInfo.getString("email");
                    String name = userInfo.getString("name");

                    User user = userService.getUserByEmail(email);
                    if (user == null) {
                        user = new User();
                        user.setEmail(email);
                        user.setFirstName(name);
                        user.setRole("patient");
                        userService.handleSaveUser(user);
                        
                        // Create patient record if it doesn't exist
                        Patient patient = patientRepository.findByUser(user);
                        if (patient == null) {
                            patient = new Patient();
                            patient.setUser(user);
                            patient.setPatientCode("P" + String.format("%06d", user.getUserID()));
                            patientRepository.save(patient);
                        }
                    } else {
                        // Create patient record for existing user if needed
                        if ("patient".equalsIgnoreCase(user.getRole())) {
                            Patient patient = patientRepository.findByUser(user);
                            if (patient == null) {
                                patient = new Patient();
                                patient.setUser(user);
                                patient.setPatientCode("P" + String.format("%06d", user.getUserID()));
                                patientRepository.save(patient);
                            }
                        }
                    }

                    session.setAttribute("currentUser", user);

                    String role = user.getRole();
                    if ("admin".equalsIgnoreCase(role)) {
                        return "redirect:/admin";
                    } else if ("patient".equalsIgnoreCase(role)
                            || "receptionist".equalsIgnoreCase(role)) {
                        return "redirect:/";
                    } else if ("doctor".equalsIgnoreCase(role)) {
                        return "redirect:/doctor/home";
                    }else {
                        return "redirect:/";
                    }
                }
            }
            model.addAttribute("error", "Đăng nhập Google thất bại");
            return "authentication/form-login";

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Có lỗi xảy ra trong quá trình đăng nhập Google");
            return "authentication/form-login";
        }
    }
}
