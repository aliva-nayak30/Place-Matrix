package controller;

import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import service.UserService;

import java.io.IOException;

@WebServlet("/register/recruiter")
public class RegisterRecruiterController extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/register-recruiter.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email = req.getParameter("email") == null ? "" : req.getParameter("email").trim();
        String password = req.getParameter("password");
        String name = req.getParameter("name") == null ? "" : req.getParameter("name").trim();
        String phone = req.getParameter("phone") == null ? "" : req.getParameter("phone").trim();

        int collegeId;
        try {
            collegeId = Integer.parseInt(req.getParameter("collegeId"));
        } catch (NumberFormatException | NullPointerException e) {
            collegeId = -1;
        }

        if (email.isEmpty() || name.isEmpty() || collegeId < 1
                || password == null || password.length() < 8) {
            req.setAttribute("error", "Fill in all required fields. Password needs at least 8 characters.");
            req.getRequestDispatcher("/register-recruiter.jsp").forward(req, resp);
            return;
        }

        User user = new User(email, password, "RECRUITER");
        if (userService.registerRecruiter(user, name, phone, collegeId)) {
            resp.sendRedirect(req.getContextPath() + "/login?pending=1");
        } else {
            req.setAttribute("error", "That email is already registered.");
            req.getRequestDispatcher("/register-recruiter.jsp").forward(req, resp);
        }
    }
}