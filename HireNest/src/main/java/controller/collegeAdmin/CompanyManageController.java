package controller.collegeAdmin;

import util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/collegeadmin/companies")
public class CompanyManageController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"COLLEGE_ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer collegeId = (Integer) session.getAttribute("collegeId");
        List<Map<String, Object>> companies = new ArrayList<>();

        // Fetch all recruiters, their HR details, and count their jobs and applications
        String sql = "SELECT r.id as recruiter_id, r.company_name, r.hr_name, r.hr_email, r.is_archived, " +
                "(SELECT COUNT(*) FROM jobs j WHERE j.recruiter_id = r.user_id) as total_jobs, " +
                "(SELECT COUNT(*) FROM applications a JOIN jobs j ON a.job_id = j.id WHERE j.recruiter_id = r.user_id) as total_apps " +
                "FROM recruiters r WHERE r.college_id = ? ORDER BY r.is_archived ASC, r.company_name ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, collegeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("recruiterId", rs.getInt("recruiter_id"));
                map.put("companyName", rs.getString("company_name"));
                map.put("hrName", rs.getString("hr_name"));
                map.put("hrEmail", rs.getString("hr_email"));
                map.put("isArchived", rs.getBoolean("is_archived"));
                map.put("totalJobs", rs.getInt("total_jobs"));
                map.put("totalApps", rs.getInt("total_apps"));
                companies.add(map);
            }
        } catch (SQLException e) { e.printStackTrace(); }

        request.setAttribute("companies", companies);
        request.getRequestDispatcher("/collegeadmin/companies.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        // Handle Archiving
        if ("archive".equals(action)) {
            try {
                int recruiterId = Integer.parseInt(request.getParameter("recruiterId"));
                String sql = "UPDATE recruiters SET is_archived = 1 WHERE id = ?";
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, recruiterId);
                    ps.executeUpdate();
                    request.getSession().setAttribute("successMsg", "Company drive archived successfully. Students can no longer see their jobs.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("errorMsg", "Failed to archive company.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/collegeadmin/companies");
    }
}