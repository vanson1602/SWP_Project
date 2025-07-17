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

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import project.springBoot.model.User;
import project.springBoot.service.UserService;
import project.springBoot.utils.JwtTokenUtil;

@Controller
public class LoginController {
    @Value("${google.client.id}")
    private String clientId;

    @Value("${google.redirect.uri}")
    private String redirectUri;
    @Value("${google.client.secret}")
    private String clientSecret;
    private final UserService userService;
    private final JwtTokenUtil jwtTokenUtil;

    public LoginController(UserService userService, JwtTokenUtil jwtTokenUtil) {
        this.userService = userService;
        this.jwtTokenUtil = jwtTokenUtil;
    }

    @GetMapping("/login")
    public String loginPage(Model model, @RequestParam(required = false) String error, HttpServletRequest request) {
        if (error != null) {
            model.addAttribute("error", "Email/tên đăng nhập hoặc mật khẩu không chính xác!");
        }

        // Check remember-me cookie
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("remember-me")) {
                    try {
                        String email = jwtTokenUtil.extractEmail(cookie.getValue());
                        User user = userService.getUserByEmail(email);
                        if (user != null) {
                            request.getSession().setAttribute("currentUser", user);
                            String role = user.getRole();
                            if ("admin".equalsIgnoreCase(role)) {
                                return "redirect:/admin";
                            } else if ("doctor".equalsIgnoreCase(role)) {
                                Long doctorId = userService.getDoctorIdByUserId(user.getUserID());
                                if (doctorId != null) {
                                    request.getSession().setAttribute("doctorId", doctorId);
                                }
                                return "redirect:/doctor/home";
                            } else if ("receptionist".equalsIgnoreCase(role)) {
                                return "redirect:/receptionist";
                            } else {
                                return "redirect:/";
                            }
                        }
                    } catch (Exception e) {
                        // Token invalid or expired, delete cookie
                        cookie.setMaxAge(0);
                        cookie.setPath("/");
                    }
                }
            }
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
    public String handleLogin(@RequestParam String emailOrUsername,
            @RequestParam String password,
            @RequestParam(required = false) boolean remember,
            HttpSession session,
            HttpServletResponse response,
            Model model) {
        System.out.println("Login controller received request for: " + emailOrUsername);
        try {
            // Kiểm tra user có tồn tại không
            User user = userService.getUserByEmailOrUsername(emailOrUsername, emailOrUsername);
            if (user == null) {
                model.addAttribute("error", "Tài khoản không tồn tại!");
                model.addAttribute("emailorusername", emailOrUsername);
                return "authentication/form-login";
            }

            // Kiểm tra đã xác thực email chưa
            if (!user.getIsVerified()) {
                model.addAttribute("error", "Tài khoản chưa được xác thực! Vui lòng kiểm tra email để xác thực.");
                model.addAttribute("emailorusername", emailOrUsername);
                return "authentication/form-login";
            }

            // Thử đăng nhập
            user = userService.login(emailOrUsername, password);
            if (user != null) {
                session.setAttribute("currentUser", user);
                String role = user.getRole();
                System.out.println("Login successful. User role: " + role);

                // Handle remember me
                if (remember) {
                    String token = JwtTokenUtil.generateToken(user.getEmail());
                    Cookie cookie = new Cookie("remember-me", token);
                    cookie.setMaxAge(7 * 24 * 60 * 60); // 7 days
                    cookie.setPath("/");
                    response.addCookie(cookie);
                }

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
                } else if ("receptionist".equalsIgnoreCase(role)) {
                    return "redirect:/receptionist";
                } else {
                    return "redirect:/";
                }
            } else {
                model.addAttribute("error", "Tên đăng nhập hoăc mật khẩu không chính xác!");
                model.addAttribute("emailorusername", emailOrUsername);
                return "authentication/form-login";
            }
        } catch (Exception e) {
            System.out.println("Login error: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "Có lỗi xảy ra trong quá trình đăng nhập!");
            model.addAttribute("emailorusername", emailOrUsername);
            return "authentication/form-login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session, HttpServletResponse response) {
        session.invalidate();

        // Delete remember-me cookie
        Cookie cookie = new Cookie("remember-me", "");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);

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
                    }

                    session.setAttribute("currentUser", user);

                    String role = user.getRole();
                    if ("admin".equalsIgnoreCase(role)) {
                        return "redirect:/admin";
                    } else if ("receptionist".equalsIgnoreCase(role)) {
                        return "redirect:/receptionist";
                    } else if ("patient".equalsIgnoreCase(role)) {
                        return "redirect:/";
                    } else if ("doctor".equalsIgnoreCase(role)) {
                        return "redirect:/doctor/home";
                    } else {
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
