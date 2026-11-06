package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter("/collegeadmin/*")
public class CollegeAdminFilter implements Filter {

    @Override
    public void init(FilterConfig fc) {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();

        // Allow access to the main login page (just in case)
        if (uri.endsWith("/login.jsp") || uri.endsWith("/login")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        boolean ok = false;

        if (session != null) {
            Object role = session.getAttribute("role");
            Object collegeId = session.getAttribute("collegeId");
            if ("COLLEGE_ADMIN".equals(role) && collegeId != null) ok = true;
        }

        if (ok) {
            chain.doFilter(request, response);
        } else {
            // 🔥 FIXED: Redirect to the MAIN unified login page, not the deleted collegeadmin one
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Please+login");
        }
    }

    @Override
    public void destroy() {}
}