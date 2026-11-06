package dao;

import util.DBConnection;
import java.sql.*;
import java.util.*;

public class StudentDashboardDAO {

    // 1. Get Eligible Companies / Jobs - GROUPED BY COMPANY
    public List<Map<String, Object>> getEligibleCompanies(int collegeId, double cgpa, int backlogs, String branch) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = "SELECT r.id as recruiter_id, r.company_name, COUNT(j.id) as total_jobs " +
                "FROM jobs j " +
                "JOIN recruiters r ON j.recruiter_id = r.user_id " +
                "WHERE j.college_id = ? " +
                "AND (j.last_date >= CURDATE() OR j.last_date IS NULL) " +
                "AND (r.is_archived = 0 OR r.is_archived IS NULL) " +
                "AND (j.min_cgpa <= ? OR j.min_cgpa IS NULL) " +
                "AND (j.max_backlogs >= ? OR j.max_backlogs IS NULL) " +
                "AND (j.eligible_branches LIKE ? OR j.eligible_branches IS NULL OR j.eligible_branches = '') " +
                "GROUP BY r.id, r.company_name";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, collegeId);
            ps.setDouble(2, cgpa);
            ps.setInt(3, backlogs);
            ps.setString(4, "%" + branch + "%");

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("recruiterId", rs.getInt("recruiter_id"));
                map.put("companyName", rs.getString("company_name"));
                map.put("totalJobs", rs.getInt("total_jobs"));
                list.add(map);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // 2. Get Jobs by Recruiter
    public List<Map<String, Object>> getJobsByRecruiter(int recruiterId, int collegeId) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = "SELECT id, title, salary as package_lpa, last_date as drive_date, status " +
                "FROM jobs " +
                "WHERE recruiter_id = (SELECT user_id FROM recruiters WHERE id = ?) " +
                "AND college_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, recruiterId);
            ps.setInt(2, collegeId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("id"));
                map.put("title", rs.getString("title"));
                map.put("packageLpa", rs.getDouble("package_lpa"));
                map.put("driveDate", rs.getDate("drive_date"));
                map.put("status", rs.getString("status"));
                list.add(map);
            }
            System.out.println("✅ DB DEBUG: Found " + list.size() + " jobs for RecruiterID: " + recruiterId);
        } catch (SQLException e) {
            System.out.println("❌ DB ERROR: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // 3. Apply to a company
    public int applyToCompany(int studentId, int jobId) {
        // Check if already applied
        String checkSql = "SELECT COUNT(*) FROM applications WHERE student_id = ? AND job_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, jobId);
            ResultSet rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return -1; // Already applied
            }
        } catch (SQLException e) { e.printStackTrace(); }

        // Insert application
        String sql = "INSERT INTO applications (student_id, job_id, status) VALUES (?, ?, 'APPLIED')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, studentId);
            ps.setInt(2, jobId);
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("❌ DB Error on Apply: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    // 4. Get applied jobs
    public Set<Integer> getAppliedCompanyIds(int studentId) {
        Set<Integer> applied = new HashSet<>();
        String sql = "SELECT job_id FROM applications WHERE student_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) applied.add(rs.getInt("job_id"));
        } catch (SQLException e) { e.printStackTrace(); }
        return applied;
    }

    // 5. Get Dashboard Stats
    public Map<String, Integer> getDashboardStats(int studentId) {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("appliedCount", 0);
        stats.put("shortlistedCount", 0);

        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM applications WHERE student_id = ?")) {
                ps.setInt(1, studentId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) stats.put("appliedCount", rs.getInt(1));
            }
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM applications WHERE student_id = ? AND status IN ('SHORTLISTED', 'SELECTED')")) {
                ps.setInt(1, studentId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) stats.put("shortlistedCount", rs.getInt(1));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return stats;
    }

    // 6. Get Recent Applications for the Timeline
    public List<Map<String, Object>> getRecentApplications(int studentId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT r.company_name, j.title as role, a.status, a.applied_at " +
                "FROM applications a " +
                "JOIN jobs j ON a.job_id = j.id " +
                "JOIN recruiters r ON j.recruiter_id = r.user_id " +
                "WHERE a.student_id = ? ORDER BY a.applied_at DESC LIMIT 3";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> app = new HashMap<>();
                app.put("companyName", rs.getString("company_name"));
                app.put("role", rs.getString("role"));
                app.put("status", rs.getString("status"));
                app.put("appliedAt", rs.getTimestamp("applied_at"));
                list.add(app);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}