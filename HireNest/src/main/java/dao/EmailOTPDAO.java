package dao;

import entity.EmailOTP;
import util.DBConnection;

import java.sql.*;

public class EmailOTPDAO {

    public boolean insert(int userId, String otpHash, Timestamp expiresAt) {
        String sql = "INSERT INTO email_otp (user_id, otp_hash, expires_at) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, otpHash);
            ps.setTimestamp(3, expiresAt);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error inserting OTP: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public EmailOTP findLatestActive(int userId) {
        String sql = "SELECT * FROM email_otp " +
                "WHERE user_id = ? AND consumed = 0 AND expires_at > NOW() " +
                "ORDER BY id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return extract(rs);
        } catch (SQLException e) {
            System.err.println("Error finding active OTP: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean incrementAttempts(int otpId) {
        String sql = "UPDATE email_otp SET attempts = attempts + 1 WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, otpId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean markConsumed(int otpId) {
        String sql = "UPDATE email_otp SET consumed = 1 WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, otpId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int invalidateAllForUser(int userId) {
        String sql = "UPDATE email_otp SET consumed = 1 WHERE user_id = ? AND consumed = 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int countRecentForUser(int userId, int minutes) {
        String sql = "SELECT COUNT(*) FROM email_otp " +
                "WHERE user_id = ? AND created_at > (NOW() - INTERVAL ? MINUTE)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, minutes);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private EmailOTP extract(ResultSet rs) throws SQLException {
        EmailOTP o = new EmailOTP();
        o.setId(rs.getInt("id"));
        o.setUserId(rs.getInt("user_id"));
        o.setOtpHash(rs.getString("otp_hash"));
        o.setExpiresAt(rs.getTimestamp("expires_at"));
        o.setAttempts(rs.getInt("attempts"));
        o.setResendCount(rs.getInt("resend_count"));
        o.setConsumed(rs.getBoolean("consumed"));
        o.setCreatedAt(rs.getTimestamp("created_at"));
        return o;
    }
}