package project.springBoot.interceptor;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import project.springBoot.model.User;

@Component
public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        String requestURI = request.getRequestURI();
        if (isPublicResource(requestURI)) {
            return true;
        }

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");

        // Nếu chưa đăng nhập
        if (user == null) {
            response.sendRedirect("/login");
            return false;
        }

        // Kiểm tra quyền truy cập
        if (requestURI.startsWith("/admin") && !"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect("/access-denied");
            return false;
        }

        if (requestURI.startsWith("/doctor") && !"doctor".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect("/access-denied");
            return false;
        }

        if (requestURI.startsWith("/patient") && !"patient".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect("/access-denied");
            return false;
        }

        if (requestURI.startsWith("/receptionist") && !"receptionist".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect("/access-denied");
            return false;
        }

        return true;
    }

    private boolean isPublicResource(String uri) {
        return uri.startsWith("/css") ||
                uri.startsWith("/js") ||
                uri.startsWith("/images") ||
                uri.startsWith("/resources") ||
                uri.equals("/") ||
                uri.equals("/login") ||
                uri.equals("/register") ||
                uri.equals("/forgot-password") ||
                uri.equals("/reset-password") ||
                uri.startsWith("/register/verify") ||
                uri.equals("/access-denied");
    }
}