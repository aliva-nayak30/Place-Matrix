package controller.collegeAdmin;

import util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/collegeadmin/leaderboard")
public class LeaderboardController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"COLLEGE_ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer collegeId = (Integer) session.getAttribute("collegeId");
        List<Map<String, Object>> leaderboard = new ArrayList<>();

        // 🔥 FIXED SQL: Pulls directly from students table if is_placed = 1
        // If placed_company is null, it checks the most recent SELECTED application.
        String sql = "SELECT s.name, s.branch, s.cgpa, " +
                "COALESCE(s.placed_company, (SELECT r.company_name FROM applications a JOIN jobs j ON a.job_id = j.id JOIN recruiters r ON j.recruiter_id = r.user_id WHERE a.student_id = s.id AND a.status = 'SELECTED' LIMIT 1)) as company_name, " +
                "COALESCE(s.placed_package, (SELECT j.salary FROM applications a JOIN jobs j ON a.job_id = j.id WHERE a.student_id = s.id AND a.status = 'SELECTED' LIMIT 1)) as package_lpa " +
                "FROM students s " +
                "WHERE s.is_placed = 1 AND s.college_id = ? " +
                "ORDER BY package_lpa DESC LIMIT 10";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, collegeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("name", rs.getString("name"));
                map.put("branch", rs.getString("branch"));
                map.put("cgpa", rs.getDouble("cgpa"));
                map.put("company", rs.getString("company_name") != null ? rs.getString("company_name") : "Unknown");
                map.put("packageLpa", rs.getDouble("package_lpa"));
                leaderboard.add(map);
            }
            System.out.println(">>> Leaderboard found " + leaderboard.size() + " placed students.");
        } catch (SQLException e) { e.printStackTrace(); }

        request.setAttribute("leaderboard", leaderboard);
        request.getRequestDispatcher("/collegeadmin/leaderboard.jsp").forward(request, response);
    }
}