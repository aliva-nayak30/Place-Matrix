package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter("/superadmin/*")
public class SuperAdminFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        // Allow login page & login servlet to pass through
        String uri = req.getRequestURI();
        if (uri.endsWith("/superadmin/login.jsp") || uri.endsWith("/superadmin/login")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        boolean isSuperAdmin = false;

        if (session != null) {
            Object role = session.getAttribute("role");
            if ("SUPER_ADMIN".equals(role)) {
                isSuperAdmin = true;
            }
        }

        if (isSuperAdmin) {
            chain.doFilter(request, response);
        } else {
            res.sendRedirect(req.getContextPath() + "/superadmin/login.jsp?error=Please+login+as+Super+Admin");
        }
    }

    @Override
    public void destroy() {}
}