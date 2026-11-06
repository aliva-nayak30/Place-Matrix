package controller;

import dao.UserDAO;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/reset-password")
public class ResetPasswordController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        if (s == null
                || s.getAttribute("resetEmail") == null
                || s.getAttribute("resetVerified") == null) {
            resp.sendRedirect(req.getContextPath() + "/forgot-password");
            return;
        }
        req.getRequestDispatcher("/reset-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null
                || session.getAttribute("resetEmail") == null
                || session.getAttribute("resetVerified") == null) {
            resp.sendRedirect(req.getContextPath() + "/forgot-password");
            return;
        }
        String email = (String) session.getAttribute("resetEmail");
        String pwd1 = req.getParameter("newPassword");
        String pwd2 = req.getParameter("confirmPassword");

        if (pwd1 == null || pwd1.length() < 8) {
            req.setAttribute("error", "Password must be at least 8 characters.");
            req.getRequestDispatcher("/reset-password.jsp").forward(req, resp);
            return;
        }
        if (!pwd1.matches(".*[A-Za-z].*") || !pwd1.matches(".*\\d.*")) {
            req.setAttribute("error", "Password must contain at least one letter and one number.");
            req.getRequestDispatcher("/reset-password.jsp").forward(req, resp);
            return;
        }
        if (!pwd1.equals(pwd2)) {
            req.setAttribute("error", "Passwords do not match.");
            req.getRequestDispatcher("/reset-password.jsp").forward(req, resp);
            return;
        }

        try {
            String hash = BCrypt.hashpw(pwd1, BCrypt.gensalt(12));
            userDAO.updatePassword(email, hash);

            session.removeAttribute("resetEmail");
            session.removeAttribute("resetVerified");

            resp.sendRedirect(req.getContextPath()
                    + "/login.jsp?success=Password+updated+successfully.+Please+log+in.");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}