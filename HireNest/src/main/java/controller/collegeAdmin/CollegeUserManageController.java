package controller.collegeAdmin;

import util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/collegeadmin/users")
public class CollegeUserManageController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"COLLEGE_ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer collegeId = (Integer) session.getAttribute("collegeId");
        List<Map<String, Object>> users = new ArrayList<>();

        // Fetch Students and Recruiters for this college
        String sql = "SELECT u.id, u.name, u.email, u.phone, u.role, u.is_active, " +
                "COALESCE(s.roll_no, 'N/A') as roll_no, " +
                "COALESCE(s.branch, 'N/A') as branch, " +
                "COALESCE(r.company_name, 'N/A') as company_name " +
                "FROM users u " +
                "LEFT JOIN students s ON u.id = s.user_id " +
                "LEFT JOIN recruiters r ON u.id = r.user_id " +
                "WHERE u.college_id = ? AND u.role IN ('STUDENT', 'RECRUITER') " +
                "ORDER BY u.role, u.name";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, collegeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("id"));
                map.put("name", rs.getString("name"));
                map.put("email", rs.getString("email"));
                map.put("phone", rs.getString("phone"));
                map.put("role", rs.getString("role"));
                map.put("isActive", rs.getBoolean("is_active"));
                map.put("rollNo", rs.getString("roll_no"));
                map.put("branch", rs.getString("branch"));
                map.put("companyName", rs.getString("company_name"));
                users.add(map);
            }
        } catch (SQLException e) { e.printStackTrace(); }

        request.setAttribute("users", users);
        request.getRequestDispatcher("/collegeadmin/manage-users.jsp").forward(request, response);
    }
}