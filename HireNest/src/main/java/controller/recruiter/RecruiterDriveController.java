package controller.recruiter;

import util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/recruiter/post-drive")
public class RecruiterDriveController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"RECRUITER".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        request.getRequestDispatcher("/recruiter/post-drive.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"RECRUITER".equals(session.getAttribute("role"))) return;

        Integer userId = (Integer) session.getAttribute("userId");
        Integer collegeId = (Integer) session.getAttribute("collegeId");

        try (Connection conn = DBConnection.getConnection()) {
            // Get the Recruiter's Company Name from DB
            String companyName = "";
            try (PreparedStatement ps = conn.prepareStatement("SELECT company_name FROM recruiters WHERE user_id = ?")) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) companyName = rs.getString("company_name");
            }

            // Insert the new Drive into the companies table
            String sql = "INSERT INTO companies (college_id, recruiter_id, company_name, job_title, package_lpa, eligible_branches, min_cgpa, max_backlogs, drive_date, status) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'OPEN')";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, collegeId);
                ps.setInt(2, userId); // Track which recruiter created this
                ps.setString(3, companyName); // Auto-filled
                ps.setString(4, request.getParameter("jobTitle"));
                ps.setDouble(5, Double.parseDouble(request.getParameter("packageLpa")));
                ps.setString(6, request.getParameter("eligibleBranches"));
                ps.setDouble(7, Double.parseDouble(request.getParameter("minCgpa")));
                ps.setInt(8, Integer.parseInt(request.getParameter("maxBacklogs")));
                ps.setDate(9, java.sql.Date.valueOf(request.getParameter("driveDate")));
                ps.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/recruiter/dashboard");
    }
}