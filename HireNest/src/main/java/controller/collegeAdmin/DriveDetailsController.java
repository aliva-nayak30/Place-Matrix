package controller.collegeAdmin;

import util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/collegeadmin/drive-details")
public class DriveDetailsController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"COLLEGE_ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String recruiterIdStr = request.getParameter("recruiterId");
        String companyName = request.getParameter("companyName");
        String branchFilter = request.getParameter("branch"); // Get the branch filter
        if (branchFilter == null) branchFilter = "";

        List<Map<String, Object>> apps = new ArrayList<>();

        // 🔥 FIXED SQL: Added dynamic branch filtering
        StringBuilder sql = new StringBuilder(
                "SELECT s.name, s.branch, s.cgpa, j.title, a.status, a.applied_at " +
                        "FROM applications a " +
                        "JOIN students s ON a.student_id = s.id " +
                        "JOIN jobs j ON a.job_id = j.id " +
                        "WHERE j.recruiter_id = (SELECT user_id FROM recruiters WHERE id = ?)"
        );

        if (!branchFilter.isEmpty()) {
            sql.append(" AND s.branch = ?");
        }
        sql.append(" ORDER BY s.name ASC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            ps.setInt(1, Integer.parseInt(recruiterIdStr));
            if (!branchFilter.isEmpty()) {
                ps.setString(2, branchFilter);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("studentName", rs.getString("name"));
                map.put("branch", rs.getString("branch"));
                map.put("cgpa", rs.getDouble("cgpa"));
                map.put("jobTitle", rs.getString("title"));
                map.put("status", rs.getString("status"));
                map.put("appliedAt", rs.getTimestamp("applied_at"));
                apps.add(map);
            }
        } catch (SQLException e) { e.printStackTrace(); }

        request.setAttribute("companyName", companyName);
        request.setAttribute("recruiterId", recruiterIdStr);
        request.setAttribute("branchFilter", branchFilter);
        request.setAttribute("applications", apps);
        request.getRequestDispatcher("/collegeadmin/drive-details.jsp").forward(request, response);
    }
}