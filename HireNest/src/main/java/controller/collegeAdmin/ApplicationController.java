package controller.collegeAdmin;

import util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/collegeadmin/applications")
public class ApplicationController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"COLLEGE_ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer collegeId = (Integer) session.getAttribute("collegeId");
        List<Map<String, Object>> drives = new ArrayList<>();

        // 🔥 GROUP BY COMPANY: Shows one row per company, with total applications
        String sql = "SELECT r.company_name, r.id as recruiter_id, COUNT(a.id) as total_apps " +
                "FROM recruiters r " +
                "LEFT JOIN jobs j ON r.user_id = j.recruiter_id " +
                "LEFT JOIN applications a ON j.id = a.job_id " +
                "WHERE r.college_id = ? " +
                "GROUP BY r.id, r.company_name";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, collegeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("companyName", rs.getString("company_name"));
                map.put("recruiterId", rs.getInt("recruiter_id"));
                map.put("totalApps", rs.getInt("total_apps"));
                drives.add(map);
            }
        } catch (SQLException e) { e.printStackTrace(); }

        request.setAttribute("drives", drives);
        request.getRequestDispatcher("/collegeadmin/applications.jsp").forward(request, response);
    }
}