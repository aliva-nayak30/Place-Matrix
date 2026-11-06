package controller.collegeAdmin;

import util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/collegeadmin/announcements")
public class ViewAnnouncementsController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT * FROM announcements ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, String> map = new HashMap<>();
                map.put("title", rs.getString("title"));
                map.put("message", rs.getString("message"));
                map.put("date", rs.getString("created_at"));
                list.add(map);
            }
        } catch (SQLException e) { e.printStackTrace(); }

        request.setAttribute("announcements", list);
        request.getRequestDispatcher("/collegeadmin/announcements.jsp").forward(request, response);
    }
}