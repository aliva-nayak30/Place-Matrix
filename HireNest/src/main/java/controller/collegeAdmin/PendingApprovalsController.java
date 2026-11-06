package controller.collegeAdmin;

import dao.StudentDAO;
import entity.Student;
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

@WebServlet("/collegeadmin/pending-approvals")
public class PendingApprovalsController extends HttpServlet {
    private StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"COLLEGE_ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer collegeId = (Integer) session.getAttribute("collegeId");

        // 1. Fetch Pending Students
        List<Student> pendingStudents = studentDAO.getPendingStudentsByCollege(collegeId);
        request.setAttribute("pendingStudents", pendingStudents);

        // 2. Fetch Pending Recruiters
        List<Map<String, String>> pendingRecruiters = new ArrayList<>();
        String recruiterSql = "SELECT u.id as user_id, u.name, u.email, r.company_name, r.hr_name " +
                "FROM users u " +
                "LEFT JOIN recruiters r ON u.id = r.user_id " +
                "WHERE u.role = 'RECRUITER' AND u.is_active = 0 AND u.college_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(recruiterSql)) {
            ps.setInt(1, collegeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> rec = new HashMap<>();
                rec.put("userId", String.valueOf(rs.getInt("user_id")));
                rec.put("name", rs.getString("name"));
                rec.put("email", rs.getString("email"));
                rec.put("companyName", rs.getString("company_name") != null ? rs.getString("company_name") : "N/A");
                rec.put("hrName", rs.getString("hr_name") != null ? rs.getString("hr_name") : "N/A");
                pendingRecruiters.add(rec);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.setAttribute("pendingRecruiters", pendingRecruiters);

        request.getRequestDispatcher("/collegeadmin/pending-approvals.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type = request.getParameter("type"); // "STUDENT" or "RECRUITER"
        String action = request.getParameter("action"); // "APPROVED" or "REJECTED"

        try (Connection conn = DBConnection.getConnection()) {
            if ("STUDENT".equals(type)) {
                int studentId = Integer.parseInt(request.getParameter("studentId"));
                studentDAO.updateStudentStatus(studentId, action);

            } else if ("RECRUITER".equals(type)) {
                int userId = Integer.parseInt(request.getParameter("userId"));

                if ("APPROVED".equals(action)) {
                    // Activate User
                    try (PreparedStatement ps = conn.prepareStatement("UPDATE users SET is_active = 1 WHERE id = ?")) {
                        ps.setInt(1, userId);
                        ps.executeUpdate();
                    }
                    // Update Recruiter Status
                    try (PreparedStatement ps = conn.prepareStatement("UPDATE recruiters SET status = 'APPROVED' WHERE user_id = ?")) {
                        ps.setInt(1, userId);
                        ps.executeUpdate();
                    }
                } else {
                    // Reject Recruiter
                    try (PreparedStatement ps = conn.prepareStatement("UPDATE recruiters SET status = 'REJECTED' WHERE user_id = ?")) {
                        ps.setInt(1, userId);
                        ps.executeUpdate();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/collegeadmin/pending-approvals");
    }
}