package superadmin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import util.DBConnection;

@WebServlet(urlPatterns = {"/superadmin/approve-admin", "/superadmin/reject-admin"})
public class SuperAdminActionController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        String userIdStr = request.getParameter("userId");

        if (userIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/superadmin/dashboard");
            return;
        }

        int userId = Integer.parseInt(userIdStr);
        boolean isApprove = "/superadmin/approve-admin".equals(path);

        try (Connection conn = DBConnection.getConnection()) {
            // 1. Update User Status
            String userSql = "UPDATE users SET is_active = ? WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(userSql)) {
                ps.setBoolean(1, isApprove);
                ps.setInt(2, userId);
                ps.executeUpdate();
            }

            // 2. Update College Status
            String colSql = "UPDATE colleges SET is_active = ? WHERE id = (SELECT college_id FROM users WHERE id = ?)";
            try (PreparedStatement ps = conn.prepareStatement(colSql)) {
                ps.setBoolean(1, isApprove);
                ps.setInt(2, userId);
                ps.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Reload Dashboard
        response.sendRedirect(request.getContextPath() + "/superadmin/dashboard");
    }
}