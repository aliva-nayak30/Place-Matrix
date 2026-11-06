package controller.collegeAdmin;

import util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/collegeadmin/calendar-events")
public class CalendarApiController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer collegeId = (Integer) request.getSession().getAttribute("collegeId");
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        if (collegeId == null) { out.print("[]"); return; }

        StringBuilder json = new StringBuilder("[");
        String sql = "SELECT company_name, drive_date FROM companies WHERE college_id = ? AND drive_date IS NOT NULL";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, collegeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                if (json.length() > 1) json.append(",");
                json.append("{")
                        .append("\"title\":\"").append(rs.getString("company_name")).append("\",")
                        .append("\"start\":\"").append(rs.getDate("drive_date")).append("\",")
                        .append("\"color\":\"#0d9488\"")
                        .append("}");
            }
        } catch (SQLException e) { e.printStackTrace(); }
        json.append("]");
        out.print(json.toString());
    }
}