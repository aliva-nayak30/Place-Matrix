package dao;

import util.DBConnection;
import java.sql.*;
import java.util.*;

public class InviteLinkDAO {

    public boolean createInvite(int collegeId, String code, java.sql.Date expiry) {
        String sql = "INSERT INTO college_invite_links (college_id, invite_code, expiry_date) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, collegeId);
            ps.setString(2, code);
            ps.setDate(3, expiry);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Map<String, Object>> getInvitesByCollege(int collegeId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT * FROM college_invite_links WHERE college_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, collegeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("id"));
                map.put("code", rs.getString("invite_code"));
                map.put("expiry", rs.getDate("expiry_date"));
                map.put("active", rs.getBoolean("is_active"));
                list.add(map);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}