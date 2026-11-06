
package dao;

import util.DBConnection;

import java.sql.*;
import java.util.*;

public class CollegeRecruiterDAO {

    // Get all recruiters belonging to a college
    // Optional filter: PENDING, APPROVED, REJECTED
    public List<Map<String, Object>> getRecruiters(
            int collegeId, String status) {

        List<Map<String, Object>> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT r.id, r.user_id, r.company_name, r.hr_name, " +
                        "r.hr_email, r.phone, r.company_website, r.company_logo, " +
                        "r.status, r.created_at, u.is_active, u.email_verified " +
                        "FROM recruiters r " +
                        "JOIN users u ON r.user_id = u.id " +
                        "WHERE r.college_id = ?"
        );

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND r.status = ?");
        }

        sql.append(" ORDER BY r.created_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            ps.setInt(1, collegeId);

            if (status != null && !status.trim().isEmpty()) {
                ps.setString(2, status.trim().toUpperCase());
            }

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Map<String, Object> row = new HashMap<>();

                    row.put("id", rs.getInt("id"));
                    row.put("userId", rs.getInt("user_id"));
                    row.put("companyName", rs.getString("company_name"));
                    row.put("hrName", rs.getString("hr_name"));
                    row.put("hrEmail", rs.getString("hr_email"));
                    row.put("phone", rs.getString("phone"));
                    row.put("website", rs.getString("company_website"));
                    row.put("logo", rs.getString("company_logo"));
                    row.put("status", rs.getString("status"));
                    row.put("createdAt", rs.getTimestamp("created_at"));
                    row.put("isActive", rs.getBoolean("is_active"));
                    row.put("emailVerified", rs.getBoolean("email_verified"));

                    list.add(row);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }


    // Count recruiters by status
    public Map<String, Integer> getStatusCounts(int collegeId) {

        Map<String, Integer> counts = new HashMap<>();

        counts.put("PENDING", 0);
        counts.put("APPROVED", 0);
        counts.put("REJECTED", 0);
        counts.put("Total", 0);

        String sql =
                "SELECT status, COUNT(*) AS cnt " +
                        "FROM recruiters " +
                        "WHERE college_id = ? " +
                        "GROUP BY status";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, collegeId);

            try (ResultSet rs = ps.executeQuery()) {

                int total = 0;

                while (rs.next()) {

                    String status = rs.getString("status");
                    int count = rs.getInt("cnt");

                    counts.put(status, count);
                    total += count;
                }

                counts.put("Total", total);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return counts;
    }


    // Approve or reject recruiter
    // Both recruiters and users tables are updated together
    public boolean updateRecruiterStatus(
            int recruiterId,
            int collegeId,
            String status) {

        if (!"APPROVED".equals(status)
                && !"REJECTED".equals(status)) {
            return false;
        }

        String selectSQL =
                "SELECT r.user_id, u.email_verified " +
                        "FROM recruiters r " +
                        "JOIN users u ON r.user_id = u.id " +
                        "WHERE r.id = ? AND r.college_id = ?";

        String updateRecruiterSQL =
                "UPDATE recruiters SET status = ? " +
                        "WHERE id = ? AND college_id = ?";

        String updateUserSQL =
                "UPDATE users SET is_active = ? " +
                        "WHERE id = ?";

        Connection conn = null;

        try {

            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int userId;
            boolean emailVerified;

            // 1. Find recruiter and verify college ownership
            try (PreparedStatement ps =
                         conn.prepareStatement(selectSQL)) {

                ps.setInt(1, recruiterId);
                ps.setInt(2, collegeId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (!rs.next()) {
                        conn.rollback();
                        return false;
                    }

                    userId = rs.getInt("user_id");
                    emailVerified = rs.getBoolean("email_verified");
                }
            }

            // 2. Do not approve an unverified email
            if ("APPROVED".equals(status) && !emailVerified) {
                conn.rollback();
                return false;
            }

            // 3. Update recruiter profile
            try (PreparedStatement ps =
                         conn.prepareStatement(updateRecruiterSQL)) {

                ps.setString(1, status);
                ps.setInt(2, recruiterId);
                ps.setInt(3, collegeId);

                if (ps.executeUpdate() == 0) {
                    conn.rollback();
                    return false;
                }
            }

            // 4. Activate only when approved
            try (PreparedStatement ps =
                         conn.prepareStatement(updateUserSQL)) {

                ps.setBoolean(1, "APPROVED".equals(status));
                ps.setInt(2, userId);

                if (ps.executeUpdate() == 0) {
                    conn.rollback();
                    return false;
                }
            }

            // 5. Save both changes
            conn.commit();

            return true;

        } catch (SQLException e) {

            e.printStackTrace();

            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackError) {
                    rollbackError.printStackTrace();
                }
            }

            return false;

        } finally {

            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
