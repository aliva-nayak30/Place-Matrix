package controller;

import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
@WebServlet("/dashboard")
public class DashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");

        String view;
        switch (user.getRole()) {
            case "STUDENT":       view = "student-dashboard"; break;
            case "RECRUITER":     view = "recruiter-dashboard"; break;
            case "COLLEGE_ADMIN": view = "admin-dashboard"; break;
            default:
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
        }
        req.getRequestDispatcher("/WEB-INF/views/" + view + ".jsp").forward(req, resp);
    }
}