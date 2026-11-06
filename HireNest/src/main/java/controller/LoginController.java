package controller;

import dao.UserDAO;
import dao.CollegeDAO;
import entity.User;
import entity.College;
import util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try {
            User user = userDAO.findByEmail(email.trim());

            if (user == null) {
                System.out.println("❌ LOGIN FAILED: User not found in database for email: " + email);
                request.setAttribute("error", "Invalid email or password.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // 🔥 DEBUG LOGS
            System.out.println("==================================================");
            System.out.println("🔍 LOGIN ATTEMPT: " + email);
            System.out.println("   -> DB Password Field: " + user.getPasswordHash());
            System.out.println("   -> Password Typed: " + password);

            // Verify Password
            boolean isPasswordCorrect = PasswordUtil.matches(password, user.getPasswordHash());

            // Fallback for plain text
            if (!isPasswordCorrect && password.equals(user.getPassword())) {
                isPasswordCorrect = true;
            }

            if (!isPasswordCorrect) {
                System.out.println("❌ LOGIN FAILED: Password mismatch!");
                request.setAttribute("error", "Invalid email or password.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            System.out.println("✅ PASSWORD MATCHED!");

            String actualRole = user.getRole();

            // Check if account is active
            if (!"SUPER_ADMIN".equals(actualRole) && !user.isActive()) {
                System.out.println("❌ LOGIN FAILED: Account is not active.");
                request.setAttribute("error", "Your account is waiting for approval.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // Create Session
            HttpSession session = request.getSession(true);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("role", actualRole);
            session.setAttribute("userName", user.getName());
            session.setAttribute("collegeId", user.getCollegeId());

            if ("COLLEGE_ADMIN".equals(actualRole) && user.getCollegeId() != null) {
                College college = new CollegeDAO().getCollegeById(user.getCollegeId());
                if (college != null) session.setAttribute("collegeName", college.getCollegeName());
            }

            System.out.println("🚀 LOGIN SUCCESS! Redirecting to " + actualRole + " dashboard.");
            System.out.println("==================================================");

            // Auto-redirect based on the DB Role
            switch (actualRole) {
                case "SUPER_ADMIN":   response.sendRedirect(request.getContextPath() + "/superadmin/dashboard"); break;
                case "COLLEGE_ADMIN": response.sendRedirect(request.getContextPath() + "/collegeadmin/dashboard"); break;
                case "RECRUITER":     response.sendRedirect(request.getContextPath() + "/recruiter/dashboard"); break;
                case "STUDENT":       response.sendRedirect(request.getContextPath() + "/student/dashboard"); break;
                default:              response.sendRedirect(request.getContextPath() + "/index.jsp"); break;
            }

        } catch (Exception e) {
            System.out.println("❌ SYSTEM ERROR during login: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "System error: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}