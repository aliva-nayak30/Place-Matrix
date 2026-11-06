package controller.superAdmin;

import dao.SuperAdminLoginDAO;
import entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/superadmin/login")
public class SuperAdminLoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private SuperAdminLoginDAO loginDAO;

    @Override
    public void init() {
        loginDAO = new SuperAdminLoginDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Redirect to login JSP
        response.sendRedirect(request.getContextPath() + "/superadmin/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validate
        if (email == null || email.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required.");
            request.getRequestDispatcher("/superadmin/login.jsp").forward(request, response);
            return;
        }

        User user = loginDAO.loginSuperAdmin(email.trim(), password.trim());

        if (user != null) {
            // Create session
            HttpSession session = request.getSession();
            session.setAttribute("userId", user.getId());
            session.setAttribute("userName", user.getName());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("role", user.getRole());
            session.setMaxInactiveInterval(30 * 60); // 30 min

            loginDAO.updateLastLogin(user.getId());

            response.sendRedirect(request.getContextPath() + "/superadmin/dashboard");
        } else {
            request.setAttribute("error", "Invalid email or password.");
            request.getRequestDispatcher("/superadmin/login.jsp").forward(request, response);
        }
    }
}