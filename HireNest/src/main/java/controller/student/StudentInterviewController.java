package controller.student;

import util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/student/interviews")
public class StudentInterviewController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"STUDENT".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        List<Map<String, Object>> interviews = new ArrayList<>();

        String sql = "SELECT i.interview_date, i.interview_time, i.mode, i.meeting_link, j.title, j.company_name " +
                "FROM interviews i " +
                "JOIN applications a ON i.application_id = a.id " +
                "JOIN students s ON a.student_id = s.id " +
                "JOIN jobs j ON a.job_id = j.id " +
                "WHERE s.user_id = ? AND a.status = 'SHORTLISTED' ORDER BY i.interview_date ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("date", rs.getDate("interview_date"));
                map.put("time", rs.getTime("interview_time"));
                map.put("mode", rs.getString("mode"));
                map.put("link", rs.getString("meeting_link"));
                map.put("title", rs.getString("title"));
                map.put("company", rs.getString("company_name"));
                interviews.add(map);
            }
        } catch (SQLException e) { e.printStackTrace(); }

        request.setAttribute("interviews", interviews);
        request.getRequestDispatcher("/student/interviews.jsp").forward(request, response);
    }
}