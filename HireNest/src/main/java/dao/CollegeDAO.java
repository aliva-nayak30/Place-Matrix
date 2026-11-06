package dao;

import entity.College;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CollegeDAO {

    // ==================================================
    // READ
    // ==================================================
    public List<College> getAllColleges() {
        List<College> list = new ArrayList<>();
        String sql = "SELECT * FROM colleges ORDER BY college_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<College> getActiveColleges() {
        List<College> list = new ArrayList<>();
        String sql = "SELECT * FROM colleges WHERE is_active = 1 ORDER BY college_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<College> getApprovedColleges() {
        List<College> list = new ArrayList<>();
        // Ensure is_active = 1 is checked and use GROUP BY to prevent duplicates
        String sql = "SELECT * FROM colleges WHERE is_active = 1 GROUP BY college_name ORDER BY college_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public College getCollegeById(int id) {
        String sql = "SELECT * FROM colleges WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public College getCollegeByCode(String code) {
        String sql = "SELECT * FROM colleges WHERE college_code = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // ==================================================
    // CREATE
    // ==================================================
    public boolean saveCollege(College c) {
        String sql = "INSERT INTO colleges (college_name, college_code, location, email, phone) " +
                "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, c.getCollegeName());
            ps.setString(2, c.getCollegeCode());
            ps.setString(3, c.getLocation());
            ps.setString(4, c.getEmail());
            ps.setString(5, c.getPhone());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) c.setId(keys.getInt(1));
                return true;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean addCollege(String name, String code, String location) {
        String sql = "INSERT INTO colleges (college_name, college_code, location) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, name);
            ps.setString(2, code);
            ps.setString(3, location != null ? location : "");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==================================================
    // UPDATE
    // ==================================================
    public boolean updateStatus(int collegeId, String status) {
        boolean active = status != null && ("ACTIVE".equalsIgnoreCase(status) || "1".equals(status) || "true".equalsIgnoreCase(status));
        String sql = "UPDATE colleges SET is_active = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, active);
            ps.setInt(2, collegeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean setActive(int collegeId, boolean active) {
        String sql = "UPDATE colleges SET is_active = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, active);
            ps.setInt(2, collegeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    // ==================================================
    // VALIDATION & COUNT
    // ==================================================
    public boolean isCollegeCodeExists(String code) {
        String sql = "SELECT COUNT(*) FROM colleges WHERE college_code = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean isCollegeNameExists(String name) {
        String sql = "SELECT COUNT(*) FROM colleges WHERE college_name = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public int getCollegeCount() {
        String sql = "SELECT COUNT(*) FROM colleges";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    // ==================================================
    // DELETE COLLEGE
    // ==================================================
    public boolean deleteCollege(int id) {
        String sql = "DELETE FROM colleges WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }



    private College map(ResultSet rs) throws SQLException {
        College c = new College();
        c.setId(rs.getInt("id"));
        c.setCollegeName(rs.getString("college_name"));
        c.setCollegeCode(rs.getString("college_code"));
        c.setLocation(rs.getString("location"));
        try { c.setEmail(rs.getString("email")); } catch (SQLException ignored) {}
        try { c.setPhone(rs.getString("phone")); } catch (SQLException ignored) {}
        try { c.setActive(rs.getBoolean("is_active")); } catch (SQLException ignored) {}
        try { c.setCreatedAt(rs.getString("created_at")); } catch (SQLException ignored) {}
        return c;
    }
}