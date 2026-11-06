package controller.student;

import util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/student/notifications")
public class StudentNotificationController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        List<Map<String, String>> notifications = new ArrayList<>();

        String sql = "SELECT c.company_name, a.status, a.updated_at " +
                "FROM applications a " +
                "JOIN students s ON a.student_id = s.id " +
                "JOIN companies c ON a.company_id = c.id " +
                "WHERE s.user_id = ? AND a.status != 'APPLIED' " +
                "ORDER BY a.updated_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> map = new HashMap<>();
                map.put("company", rs.getString("company_name"));
                map.put("status", rs.getString("status"));
                map.put("date", rs.getString("updated_at"));
                notifications.add(map);
            }
        } catch (SQLException e) { e.printStackTrace(); }

        request.setAttribute("notifications", notifications);
        request.getRequestDispatcher("/student/notifications.jsp").forward(request, response);
    }
}