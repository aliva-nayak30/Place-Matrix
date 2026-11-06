package controller.superAdmin; // ⚠️ Change to 'package superadmin;' if your folder is lowercase

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import util.DBConnection;

@WebServlet("/superadmin/dashboard")
public class SuperAdminDashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 1. Fetch pending requests
            UserDAO userDAO = new UserDAO();
            request.setAttribute("pendingAdmins", userDAO.getPendingCollegeAdmins());

            // 2. Fetch Stats
            try (Connection conn = DBConnection.getConnection()) {

                ResultSet rs = conn.prepareStatement("SELECT COUNT(*) FROM colleges").executeQuery();
                if (rs.next()) request.setAttribute("totalColleges", rs.getInt(1));

                rs = conn.prepareStatement("SELECT COUNT(*) FROM colleges WHERE is_active = 1").executeQuery();
                if (rs.next()) request.setAttribute("activeColleges", rs.getInt(1));

                rs = conn.prepareStatement("SELECT COUNT(*) FROM colleges WHERE is_active = 0").executeQuery();
                if (rs.next()) request.setAttribute("pendingColleges", rs.getInt(1));

                rs = conn.prepareStatement("SELECT COUNT(*) FROM students").executeQuery();
                if (rs.next()) request.setAttribute("totalStudents", rs.getInt(1));

                rs = conn.prepareStatement("SELECT COUNT(*) FROM students WHERE is_placed = 1").executeQuery();
                if (rs.next()) request.setAttribute("placedStudents", rs.getInt(1));

                rs = conn.prepareStatement("SELECT COUNT(*) FROM students WHERE is_placed = 0 OR is_placed IS NULL").executeQuery();
                if (rs.next()) request.setAttribute("unplacedStudents", rs.getInt(1));

                rs = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE role = 'RECRUITER'").executeQuery();
                if (rs.next()) request.setAttribute("totalRecruiters", rs.getInt(1));

                rs = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE role = 'COLLEGE_ADMIN'").executeQuery();
                if (rs.next()) request.setAttribute("totalCollegeAdmins", rs.getInt(1));

                // Chart Data
                List<String> collegeNames = new ArrayList<>();
                List<Integer> collegeCounts = new ArrayList<>();
                String chartSql = "SELECT c.college_name, COUNT(s.id) as cnt FROM colleges c " +
                        "LEFT JOIN students s ON c.id = s.college_id " +
                        "GROUP BY c.id ORDER BY cnt DESC LIMIT 5";
                rs = conn.prepareStatement(chartSql).executeQuery();
                while (rs.next()) {
                    collegeNames.add("'" + rs.getString("college_name").replace("'", "") + "'");
                    collegeCounts.add(rs.getInt("cnt"));
                }
                request.setAttribute("collegeNames", collegeNames.toString());
                request.setAttribute("collegeStudentCounts", collegeCounts.toString());
            }

        } catch (Exception e) {
            // If DB fails, print error to console instead of crashing the page
            System.out.println("❌ Error loading SuperAdmin Dashboard: " + e.getMessage());
            e.printStackTrace();
        }

        // 3. Forward to JSP
        request.getRequestDispatcher("/superadmin/dashboard.jsp").forward(request, response);
    }
}