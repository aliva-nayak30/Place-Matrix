package dao;

import entity.InviteToken;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InviteTokenDAO {

    public boolean insert(InviteToken t) {
        String sql = "INSERT INTO invite_tokens (college_id, role, token, max_uses, used_count, expires_at, is_active, created_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, t.getCollegeId());
            ps.setString(2, t.getRole());
            ps.setString(3, t.getToken());
            ps.setInt(4, t.getMaxUses());
            ps.setInt(5, t.getUsedCount());
            ps.setTimestamp(6, Timestamp.valueOf(t.getExpiresAt()));
            ps.setBoolean(7, t.isActive());
            if (t.getCreatedBy() != null) ps.setInt(8, t.getCreatedBy());
            else ps.setNull(8, Types.INTEGER);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) t.setId(keys.getLong(1));
                return true;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public InviteToken findByToken(String token) {
        String sql = "SELECT * FROM invite_tokens WHERE token = ? LIMIT 1";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public InviteToken findById(long id) {
        String sql = "SELECT * FROM invite_tokens WHERE id = ? LIMIT 1";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<InviteToken> findByCollege(int collegeId) {
        List<InviteToken> list = new ArrayList<>();
        String sql = "SELECT * FROM invite_tokens WHERE college_id = ? ORDER BY created_at DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, collegeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean incrementUsedCount(long id) {
        String sql = "UPDATE invite_tokens SET used_count = used_count + 1 WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean deactivate(long id) {
        String sql = "UPDATE invite_tokens SET is_active = 0 WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean delete(long id) {
        String sql = "DELETE FROM invite_tokens WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    private InviteToken map(ResultSet rs) throws SQLException {
        InviteToken t = new InviteToken();
        t.setId(rs.getLong("id"));
        t.setCollegeId(rs.getInt("college_id"));
        t.setRole(rs.getString("role"));
        t.setToken(rs.getString("token"));
        t.setMaxUses(rs.getInt("max_uses"));
        t.setUsedCount(rs.getInt("used_count"));
        Timestamp exp = rs.getTimestamp("expires_at");
        if (exp != null) t.setExpiresAt(exp.toLocalDateTime());
        t.setActive(rs.getBoolean("is_active"));
        int cb = rs.getInt("created_by");
        if (!rs.wasNull()) t.setCreatedBy(cb);
        Timestamp cre = rs.getTimestamp("created_at");
        if (cre != null) t.setCreatedAt(cre.toLocalDateTime());
        return t;
    }
}