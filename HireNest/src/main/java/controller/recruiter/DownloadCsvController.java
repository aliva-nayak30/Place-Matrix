package controller.recruiter;

import util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/recruiter/download-csv")
public class DownloadCsvController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int jobId = Integer.parseInt(request.getParameter("jobId"));
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"applicants.csv\"");

        try (PrintWriter out = response.getWriter(); Connection conn = DBConnection.getConnection()) {
            out.println("Name,Branch,CGPA,Skills,Status");
            String sql = "SELECT s.name, s.branch, s.cgpa, s.skills, a.status FROM applications a JOIN students s ON a.student_id = s.id WHERE a.job_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, jobId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    out.println(rs.getString("name") + "," + rs.getString("branch") + "," + rs.getDouble("cgpa") + "," + rs.getString("skills").replace(",", ";") + "," + rs.getString("status"));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
    }
}