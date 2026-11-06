package dao;

import entity.Recruiter;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RecruiterDAO {

    // ==================================================
    // CREATE
    // ==================================================
    public boolean saveRecruiter(Recruiter recruiter) {
        String sql = "INSERT INTO recruiters (user_id, college_id, company_name, hr_name, hr_email, " +
                "company_website, phone, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, recruiter.getUserId());
            ps.setInt(2, recruiter.getCollegeId());
            ps.setString(3, recruiter.getCompanyName());
            ps.setString(4, recruiter.getHrName());
            ps.setString(5, recruiter.getHrEmail());
            ps.setString(6, recruiter.getCompanyWebsite());
            ps.setString(7, recruiter.getPhone());
            ps.setString(8, recruiter.getStatus() != null ? recruiter.getStatus() : "PENDING");

            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    recruiter.setId(rs.getInt(1));
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ==================================================
    // READ
    // ==================================================
    public Recruiter getRecruiterByUserId(int userId) {
        String sql = "SELECT * FROM recruiters WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return extractRecruiter(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Recruiter getRecruiterById(int id) {
        String sql = "SELECT * FROM recruiters WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return extractRecruiter(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Recruiter> getRecruitersByCollegeId(int collegeId) {
        List<Recruiter> list = new ArrayList<>();
        String sql = "SELECT * FROM recruiters WHERE college_id = ? ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, collegeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(extractRecruiter(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Recruiter> getAllRecruiters() {
        List<Recruiter> list = new ArrayList<>();
        String sql = "SELECT * FROM recruiters ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(extractRecruiter(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Recruiter> getPendingRecruiters(int collegeId) {
        List<Recruiter> list = new ArrayList<>();
        String sql = "SELECT * FROM recruiters WHERE college_id = ? AND status = 'PENDING' ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, collegeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(extractRecruiter(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==================================================
    // UPDATE
    // ==================================================
    public boolean updateRecruiter(Recruiter r) {
        String sql = "UPDATE recruiters SET company_name = ?, hr_name = ?, hr_email = ?, " +
                "company_website = ?, phone = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, r.getCompanyName());
            ps.setString(2, r.getHrName());
            ps.setString(3, r.getHrEmail());
            ps.setString(4, r.getCompanyWebsite());
            ps.setString(5, r.getPhone());
            ps.setInt(6, r.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateRecruiterStatus(int recruiterId, String status) {
        String sql = "UPDATE recruiters SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, recruiterId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ==================================================
    // DELETE
    // ==================================================
    public boolean deleteRecruiter(int recruiterId) {
        String sql = "DELETE FROM recruiters WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, recruiterId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteRecruiterAndUser(int recruiterId, int userId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement p1 = conn.prepareStatement(
                    "DELETE FROM recruiters WHERE id = ?")) {
                p1.setInt(1, recruiterId);
                p1.executeUpdate();
            }
            try (PreparedStatement p2 = conn.prepareStatement(
                    "DELETE FROM users WHERE id = ?")) {
                p2.setInt(1, userId);
                int rows = p2.executeUpdate();
                conn.commit();
                return rows > 0;
            }
        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) try {
                conn.setAutoCommit(true);
                conn.close();
            } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    // ==================================================
    // VALIDATION HELPERS
    // ==================================================
    public boolean isCompanyNameExists(String companyName) {
        String sql = "SELECT COUNT(*) FROM recruiters WHERE company_name = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, companyName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ==================================================
    // RESULTSET MAPPER
    // ==================================================
    private Recruiter extractRecruiter(ResultSet rs) throws SQLException {
        Recruiter r = new Recruiter();
        r.setId(rs.getInt("id"));
        r.setUserId(rs.getInt("user_id"));
        r.setCollegeId(rs.getInt("college_id"));
        r.setCompanyName(rs.getString("company_name"));
        r.setHrName(rs.getString("hr_name"));
        r.setHrEmail(rs.getString("hr_email"));
        r.setCompanyWebsite(rs.getString("company_website"));
        r.setPhone(rs.getString("phone"));
        r.setStatus(rs.getString("status"));
        try { r.setCreatedAt(rs.getString("created_at")); } catch (SQLException ignored) {}
        return r;
    }
}