package controller.superAdmin;

import util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*;

@WebServlet(urlPatterns = {"/superadmin/reports", "/superadmin/export-report"})
public class SuperAdminReportController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/superadmin/export-report".equals(path)) {
            exportCsv(response);
        } else {
            loadReports(request, response);
        }
    }

    private void loadReports(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Map<String, Object>> collegeStats = new ArrayList<>();
        String topCollege = "N/A";
        double topPackage = 0.0;

        try (Connection conn = DBConnection.getConnection()) {
            // Query to get stats for EVERY college
            String sql = "SELECT c.college_name, " +
                    "COUNT(DISTINCT s.id) as total_students, " +
                    "SUM(CASE WHEN s.is_placed = 1 THEN 1 ELSE 0 END) as placed_students, " +
                    "COALESCE(MAX(s.placed_package), 0) as highest_package " +
                    "FROM colleges c " +
                    "LEFT JOIN students s ON c.id = s.college_id " +
                    "GROUP BY c.id " +
                    "ORDER BY highest_package DESC, placed_students DESC";

            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                boolean isFirst = true;
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    String name = rs.getString("college_name");
                    int total = rs.getInt("total_students");
                    int placed = rs.getInt("placed_students");
                    double highestPkg = rs.getDouble("highest_package");

                    // Calculate percentage
                    int rate = total > 0 ? (placed * 100) / total : 0;

                    map.put("collegeName", name);
                    map.put("totalStudents", total);
                    map.put("placedStudents", placed);
                    map.put("placementRate", rate);
                    map.put("highestPackage", highestPkg);
                    collegeStats.add(map);

                    // Capture the #1 college for the highlight card
                    if (isFirst && highestPkg > 0) {
                        topCollege = name;
                        topPackage = highestPkg;
                        isFirst = false;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("collegeStats", collegeStats);
        request.setAttribute("topCollege", topCollege);
        request.setAttribute("topPackage", topPackage);

        request.getRequestDispatcher("/superadmin/reports.jsp").forward(request, response);
    }

    private void exportCsv(HttpServletResponse response) throws IOException {
        // ... (Keep your existing export CSV logic here) ...
    }
}