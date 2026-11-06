package controller.collegeAdmin;

import dao.CollegeAdminDashboardDAO;
import util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/collegeadmin/dashboard")
public class CollegeDashboardController extends HttpServlet {
    private CollegeAdminDashboardDAO dao;

    @Override
    public void init() {
        dao = new CollegeAdminDashboardDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"COLLEGE_ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer collegeId = (Integer) session.getAttribute("collegeId");
        if (collegeId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 1. Fetch Dashboard Stats
        request.setAttribute("stats", dao.getStats(collegeId));
        request.setAttribute("branchStats", dao.getBranchStats(collegeId));
        request.setAttribute("placementStats", dao.getPlacementStatus(collegeId));
        request.setAttribute("analytics", dao.getPlacementAnalytics(collegeId));

        // 2. Fetch Latest Announcements (ONLY for College Admin + ONLY for this college)
        List<Map<String, String>> announcements = new ArrayList<>();
        String sql = "SELECT title, message, created_at FROM announcements " +
                "WHERE target_audience IN ('COLLEGE_ADMIN', 'ALL') " +
                "AND (target_college_id IS NULL OR target_college_id = ?) " +
                "ORDER BY created_at DESC LIMIT 3";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, collegeId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> ann = new HashMap<>();
                    ann.put("title", rs.getString("title"));
                    ann.put("message", rs.getString("message"));
                    ann.put("date", rs.getString("created_at"));
                    announcements.add(ann);
                }
            }
        } catch (Exception e) {
            System.out.println("Error fetching announcements: " + e.getMessage());
        }

        request.setAttribute("announcements", announcements);

        // 3. Forward to JSP
        request.getRequestDispatcher("/collegeadmin/dashboard.jsp").forward(request, response);
    }
}