package dao;

import entity.CollegeAdmin;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CollegeAdminDAO {

    public List<CollegeAdmin> getAllCollegeAdmins() {
        List<CollegeAdmin> list = new ArrayList<>();
        // Fetching directly from users to ensure we don't miss records
        String sql = "SELECT u.id as user_id, u.name, u.email, u.phone, u.is_active, c.college_name, u.created_at " +
                "FROM users u " +
                "LEFT JOIN colleges c ON u.college_id = c.id " +
                "WHERE u.role = 'COLLEGE_ADMIN' " +
                "ORDER BY u.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                CollegeAdmin ca = new CollegeAdmin();
                ca.setUserId(rs.getInt("user_id"));
                ca.setId(rs.getInt("user_id")); // Using userId as ID for UI actions
                ca.setName(rs.getString("name"));
                ca.setEmail(rs.getString("email"));
                ca.setPhone(rs.getString("phone"));
                ca.setCollegeName(rs.getString("college_name"));
                ca.setCreatedAt(rs.getString("created_at"));
                // If your CollegeAdmin entity has isActive, uncomment below:
                // ca.setActive(rs.getBoolean("is_active"));
                list.add(ca);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean deleteCollegeAdmin(int adminId, int userId) {
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement("DELETE FROM college_admin WHERE user_id = ?")) {
                ps1.setInt(1, userId); ps1.executeUpdate();
            } catch (SQLException ignored) {} // Ignore if table doesn't exist

            try (PreparedStatement ps2 = conn.prepareStatement("DELETE FROM users WHERE id = ?")) {
                ps2.setInt(1, userId); ps2.executeUpdate();
            }
            conn.commit();
            return true;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean toggleUserStatus(int userId, boolean active) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE users SET is_active = ? WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setBoolean(1, active);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // ==================================================
    // DELETE USER (Called by CollegeAdminManageController)
    // ==================================================
    public boolean deleteUser(int userId) {
        try (java.sql.Connection conn = util.DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            // 1. Delete from college_admin table (ignore if missing)
            try (java.sql.PreparedStatement ps1 = conn.prepareStatement("DELETE FROM college_admin WHERE user_id = ?")) {
                ps1.setInt(1, userId);
                ps1.executeUpdate();
            } catch (Exception ignored) {}

            // 2. Delete from users table
            try (java.sql.PreparedStatement ps2 = conn.prepareStatement("DELETE FROM users WHERE id = ?")) {
                ps2.setInt(1, userId);
                ps2.executeUpdate();
            }
            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}