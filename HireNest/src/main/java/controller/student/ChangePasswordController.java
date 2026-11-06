package controller.student;

import dao.UserDAO;
import entity.User;
import util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/student/change-password")
public class ChangePasswordController extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check session
        if (request.getSession().getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        request.getRequestDispatcher("/student/change-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String currentPwd = request.getParameter("currentPassword");
        String newPwd = request.getParameter("newPassword");
        String confirmPwd = request.getParameter("confirmPassword");

        // 1. Basic Validation
        if (!newPwd.equals(confirmPwd)) {
            request.setAttribute("error", "New passwords do not match.");
            request.getRequestDispatcher("/student/change-password.jsp").forward(request, response);
            return;
        }

        // 2. Password Strength Check (Min 8 chars, 1 letter, 1 number)
        if (newPwd.length() < 8 || !newPwd.matches(".*[A-Za-z].*") || !newPwd.matches(".*\\d.*")) {
            request.setAttribute("error", "Password must be at least 8 characters and contain both letters and numbers.");
            request.getRequestDispatcher("/student/change-password.jsp").forward(request, response);
            return;
        }

        try {
            User user = userDAO.getUserById(userId);

            // 3. Verify Current Password
            if (!PasswordUtil.matches(currentPwd, user.getPasswordHash()) && !currentPwd.equals(user.getPassword())) {
                request.setAttribute("error", "Current password is incorrect.");
                request.getRequestDispatcher("/student/change-password.jsp").forward(request, response);
                return;
            }

            // 4. Hash and Save New Password
            String newHashed = PasswordUtil.hashPassword(newPwd);
            boolean updated = userDAO.updateUserPassword(userId, newHashed);

            if (updated) {
                request.setAttribute("success", "Password changed successfully! Please login again.");
                session.invalidate(); // Force re-login for security
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Failed to update password. Please try again.");
                request.getRequestDispatcher("/student/change-password.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error: " + e.getMessage());
            request.getRequestDispatcher("/student/change-password.jsp").forward(request, response);
        }
    }
}