package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(urlPatterns = {"/superadmin/*", "/collegeadmin/*", "/student/*", "/recruiter/*"})
public class AuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String path = req.getRequestURI();

        // 🔥 DESTROY OLD LOGIN PAGES: If they try to go to any old login, force them to the main one
        if (path.endsWith("recruiter/login.jsp") ||
                path.endsWith("collegeadmin/login.jsp") ||
                path.endsWith("student/login.jsp")) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // Allow access to main pages
        if (path.endsWith("login.jsp") || path.endsWith("login") || path.endsWith("register") || path.contains("/join")) {
            chain.doFilter(request, response);
            return;
        }

        boolean loggedIn = (session != null && session.getAttribute("role") != null);

        if (loggedIn) {
            chain.doFilter(request, response);
        } else {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
        }
    }
}