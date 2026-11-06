package controller.superAdmin;

import dao.UserDAO;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/superadmin/recruiters")
public class RecruiterManageController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserDAO dao = new UserDAO();
        // Fetch all Recruiters
        List<User> recruiters = dao.getAllUsers().stream()
                .filter(u -> "RECRUITER".equals(u.getRole()))
                .toList();

        request.setAttribute("recruiters", recruiters);
        request.getRequestDispatcher("/superadmin/recruiters.jsp").forward(request, response);
    }
}