package controller.superAdmin;

import dao.UserDAO;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/superadmin/college-admins")
public class CollegeAdminManageController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserDAO dao = new UserDAO();
        // Fetch all College Admins
        List<User> admins = dao.getAllUsers().stream()
                .filter(u -> "COLLEGE_ADMIN".equals(u.getRole()))
                .toList();

        request.setAttribute("admins", admins);
        request.getRequestDispatcher("/superadmin/college-admins.jsp").forward(request, response);
    }
}