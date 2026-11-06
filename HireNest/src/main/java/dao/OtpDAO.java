package dao;

import entity.OtpRecord;
import util.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.Optional;

public class OtpDAO {

    // ==================================================
    // CREATE
    // ==================================================
    public void saveOtp(String email, String otpHash, String purpose, int ttlMinutes) throws SQLException {
        String sql = "INSERT INTO email_otp (email, otp_hash, purpose, expires_at) VALUES (?, ?, ?, ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, otpHash);
            ps.setString(3, purpose);
            ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now().plusMinutes(ttlMinutes)));
            ps.executeUpdate();
        }
    }

    public void invalidatePrevious(String email, String purpose) throws SQLException {
        String sql = "UPDATE email_otp SET consumed_at = NOW() " +
                "WHERE email = ? AND purpose = ? AND consumed_at IS NULL";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, purpose);
            ps.executeUpdate();
        }
    }

    // ==================================================
    // READ
    // ==================================================

    /** Returns latest UNEXPIRED, UNCONSUMED OTP — or empty. */
    public Optional<OtpRecord> findLatestValid(String email, String purpose) throws SQLException {
        String sql = "SELECT * FROM email_otp " +
                "WHERE email = ? AND purpose = ? " +
                "  AND consumed_at IS NULL AND expires_at > NOW() " +
                "ORDER BY id DESC LIMIT 1";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, purpose);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(map(rs));
            }
        }
        return Optional.empty();
    }

    /**
     * Returns the most recent OTP row for (email, purpose) — regardless of
     * whether it is expired or already consumed. Used by verify() to
     * distinguish EXPIRED vs NO_ACTIVE_OTP.
     */
    public Optional<OtpRecord> findLatestAny(String email, String purpose) throws SQLException {
        String sql = "SELECT * FROM email_otp " +
                "WHERE email = ? AND purpose = ? " +
                "ORDER BY id DESC LIMIT 1";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, purpose);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(map(rs));
            }
        }
        return Optional.empty();
    }

    public int countRecentOtps(String email, String purpose, int minutes) throws SQLException {
        String sql = "SELECT COUNT(*) FROM email_otp " +
                "WHERE email = ? AND purpose = ? " +
                "  AND created_at > (NOW() - INTERVAL ? MINUTE)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, purpose);
            ps.setInt(3, minutes);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    // ==================================================
    // UPDATE
    // ==================================================
    public void incrementAttempts(long id) throws SQLException {
        String sql = "UPDATE email_otp SET attempts = attempts + 1 WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        }
    }

    public void consume(long id) throws SQLException {
        String sql = "UPDATE email_otp SET consumed_at = NOW() WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        }
    }

    // ==================================================
    // MAPPER
    // ==================================================
    private OtpRecord map(ResultSet rs) throws SQLException {
        OtpRecord r = new OtpRecord();
        r.setId(rs.getLong("id"));
        r.setEmail(rs.getString("email"));
        r.setOtpHash(rs.getString("otp_hash"));
        r.setPurpose(rs.getString("purpose"));
        r.setAttempts(rs.getInt("attempts"));
        r.setResendCount(rs.getInt("resend_count"));
        Timestamp exp = rs.getTimestamp("expires_at");
        if (exp != null) r.setExpiresAt(exp.toLocalDateTime());
        Timestamp con = rs.getTimestamp("consumed_at");
        if (con != null) r.setConsumedAt(con.toLocalDateTime());
        Timestamp cre = rs.getTimestamp("created_at");
        if (cre != null) r.setCreatedAt(cre.toLocalDateTime());
        return r;
    }
}