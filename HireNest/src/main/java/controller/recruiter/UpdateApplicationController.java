package controller.recruiter;

import util.DBConnection;
import service.EmailService;
import util.AuditLogger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/recruiter/update-status")
public class UpdateApplicationController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"RECRUITER".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int applicationId = Integer.parseInt(request.getParameter("applicationId"));
        String newStatus = request.getParameter("status");
        Integer recruiterId = (Integer) session.getAttribute("userId");

        String companyNameForLog = "";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            // 1. Update application status
            String updateAppSql = "UPDATE applications SET status = ? WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateAppSql)) {
                ps.setString(1, newStatus);
                ps.setInt(2, applicationId);
                ps.executeUpdate();
            }

            // 2. Insert notification when status changes to SHORTLISTED
            if ("SHORTLISTED".equals(newStatus)) {
                // 🔥 FIXED: Join with jobs instead of companies
                String notifSql = "INSERT INTO notifications (user_id, message, is_read) " +
                        "SELECT s.user_id, CONCAT('Your application for ', j.title, ' has been shortlisted!'), 0 " +
                        "FROM applications a JOIN students s ON a.student_id = s.id " +
                        "JOIN jobs j ON a.job_id = j.id WHERE a.id = ?";

                try (PreparedStatement ps = conn.prepareStatement(notifSql)) {
                    ps.setInt(1, applicationId);
                    int rows = ps.executeUpdate();
                    System.out.println("Notification inserted: " + rows);
                }
            }

            // 3. If SELECTED, update student, save rating/feedback, and send email
            if ("SELECTED".equals(newStatus)) {

                String ratingStr = request.getParameter("rating");
                String feedback = request.getParameter("feedback");
                int rating = (ratingStr != null && !ratingStr.isEmpty()) ? Integer.parseInt(ratingStr) : 5;

                // Update rating and feedback
                String updateFeedbackSql = "UPDATE applications SET rating = ?, feedback = ? WHERE id = ?";
                try (PreparedStatement ps = conn.prepareStatement(updateFeedbackSql)) {
                    ps.setInt(1, rating);
                    ps.setString(2, feedback);
                    ps.setInt(3, applicationId);
                    ps.executeUpdate();
                }

                // Mark student as placed
                String updateStudentSql = "UPDATE students s JOIN applications a ON s.id = a.student_id SET s.is_placed = 1 WHERE a.id = ?";
                try (PreparedStatement ps = conn.prepareStatement(updateStudentSql)) {
                    ps.setInt(1, applicationId);
                    ps.executeUpdate();
                }

                // 🔥 FIXED: Fetch student email and company details by joining recruiters table
                String fetchSql = "SELECT s.email, s.name, r.company_name FROM applications a " +
                        "JOIN students s ON a.student_id = s.id " +
                        "JOIN jobs j ON a.job_id = j.id " +
                        "JOIN recruiters r ON j.recruiter_id = r.user_id WHERE a.id = ?";

                try (PreparedStatement ps = conn.prepareStatement(fetchSql)) {
                    ps.setInt(1, applicationId);
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        String studentEmail = rs.getString("email");
                        String studentName = rs.getString("name");
                        String companyName = rs.getString("company_name");
                        companyNameForLog = companyName;

                        try {
                            EmailService mailer = new EmailService();
                            mailer.send(studentEmail, "Congratulations! You are selected",
                                    "Dear " + studentName + ",\n\nCongratulations! You have been selected by " + companyName + ".\n\nBest Regards,\nHireNest Team",
                                    "<h3>Congratulations " + studentName + "!</h3><p>You have been selected by <b>" + companyName + "</b>.</p>");
                            System.out.println("Selection email sent to " + studentEmail);
                        } catch (Exception mailEx) {
                            System.out.println("Email failed but status updated: " + mailEx.getMessage());
                        }

                        AuditLogger.log(recruiterId, "STUDENT_SELECTED",
                                "Selected application ID: " + applicationId + " for Company: " + companyName + " Rating: " + rating);
                        System.out.println("Audit logged for selection");
                    }
                }
            } else {
                AuditLogger.log(recruiterId, "STATUS_UPDATE",
                        "Updated application ID: " + applicationId + " to status: " + newStatus + " Company: " + companyNameForLog);
            }

            conn.commit();
            System.out.println("Application " + applicationId + " updated to " + newStatus);

        } catch (Exception e) {
            System.out.println("Error in UpdateApplicationController: " + e.getMessage());
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/recruiter/dashboard?page=applications");
    }
}