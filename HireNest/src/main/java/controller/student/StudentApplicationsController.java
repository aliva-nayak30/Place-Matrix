package controller.student;

import util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/student/my-applications")
public class StudentApplicationsController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"STUDENT".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        List<Map<String, Object>> apps = new ArrayList<>();

        String sql = "SELECT a.id, r.company_name, j.title as role, a.status, a.applied_at " +
                "FROM applications a " +
                "JOIN students s ON a.student_id = s.id " +
                "JOIN jobs j ON a.job_id = j.id " +
                "JOIN recruiters r ON j.recruiter_id = r.user_id " +
                "WHERE s.user_id = ? ORDER BY a.applied_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("id"));
                map.put("companyName", rs.getString("company_name"));
                map.put("role", rs.getString("role"));
                map.put("status", rs.getString("status"));
                map.put("appliedAt", rs.getTimestamp("applied_at"));
                apps.add(map);
            }
        } catch (SQLException e) { e.printStackTrace(); }

        request.setAttribute("applications", apps);
        request.getRequestDispatcher("/student/my-applications.jsp").forward(request, response);
    }
}