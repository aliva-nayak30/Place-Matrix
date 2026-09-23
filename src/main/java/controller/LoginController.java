package controller;

import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import service.UserService;

import java.io.IOException;

@WebServlet("/login")
public class LoginController
        extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        User user = userService.loginUser(email, password);
        if (user == null) {
            req.setAttribute("error", "Email or password is incorrect.");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        HttpSession old = req.getSession(false);
        if (old != null) old.invalidate();
        user.setPassword(null);
        req.getSession(true).setAttribute("user", user);

        resp.sendRedirect(req.getContextPath() + "/dashboard");
    }
}