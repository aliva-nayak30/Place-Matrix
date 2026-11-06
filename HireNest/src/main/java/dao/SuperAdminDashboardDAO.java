package dao;

import util.DBConnection;

import java.sql.*;
import java.util.*;

public class SuperAdminDashboardDAO {

    // Get all dashboard stats in one call
    public Map<String, Integer> getDashboardStats() {
        Map<String, Integer> stats = new HashMap<>();

        try (Connection conn = DBConnection.getConnection()) {

            stats.put("totalStudents",   getCount(conn, "SELECT COUNT(*) FROM students"));
            stats.put("totalColleges",   getCount(conn, "SELECT COUNT(*) FROM colleges"));
            stats.put("totalRecruiters", getCount(conn, "SELECT COUNT(*) FROM recruiters"));
            stats.put("totalDrives",     getCount(conn, "SELECT COUNT(*) FROM company_postings WHERE status='OPEN'"));
            stats.put("totalApps",       getCount(conn, "SELECT COUNT(*) FROM applications"));
            stats.put("totalPlaced",     getCount(conn, "SELECT COUNT(*) FROM applications WHERE status='Hired'"));
            stats.put("pendingColleges", getCount(conn, "SELECT COUNT(*) FROM colleges WHERE status='PENDING'"));
            stats.put("pendingRecruiters", getCount(conn, "SELECT COUNT(*) FROM recruiters WHERE status='PENDING'"));

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    private int getCount(Connection conn, String sql) {
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    // Recent 5 drives (JOIN with recruiters)
    public List<Map<String, Object>> getRecentDrives(int limit) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT cp.id, cp.job_title, cp.package, cp.location, cp.last_date, cp.status, " +
                "r.company_name, r.company_logo " +
                "FROM company_postings cp " +
                "JOIN recruiters r ON cp.recruiter_id = r.id " +
                "ORDER BY cp.created_at DESC LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("id", rs.getInt("id"));
                row.put("jobTitle", rs.getString("job_title"));
                row.put("package_", rs.getDouble("package"));
                row.put("location", rs.getString("location"));
                row.put("lastDate", rs.getDate("last_date"));
                row.put("status", rs.getString("status"));
                row.put("companyName", rs.getString("company_name"));
                row.put("companyLogo", rs.getString("company_logo"));
                list.add(row);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Pending recruiter/company approvals
    public List<Map<String, Object>> getPendingRecruiters(int limit) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT r.id, r.company_name, r.hr_email, r.phone, r.status, " +
                "c.college_name " +
                "FROM recruiters r " +
                "LEFT JOIN colleges c ON r.college_id = c.id " +
                "WHERE r.status = 'PENDING' " +
                "ORDER BY r.created_at DESC LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("id", rs.getInt("id"));
                row.put("companyName", rs.getString("company_name"));
                row.put("hrEmail", rs.getString("hr_email"));
                row.put("phone", rs.getString("phone"));
                row.put("status", rs.getString("status"));
                row.put("collegeName", rs.getString("college_name"));
                list.add(row);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Chart data: placed vs unplaced
    public Map<String, Integer> getPlacedVsUnplaced() {
        Map<String, Integer> data = new HashMap<>();
        try (Connection conn = DBConnection.getConnection()) {
            data.put("placed", getCount(conn,
                    "SELECT COUNT(DISTINCT student_id) FROM applications WHERE status='Hired'"));
            data.put("unplaced", getCount(conn,
                    "SELECT COUNT(*) FROM students WHERE id NOT IN " +
                            "(SELECT DISTINCT student_id FROM applications WHERE status='Hired')"));
        } catch (SQLException e) { e.printStackTrace(); }
        return data;
    }

    // Chart data: package distribution
    public Map<String, Integer> getPackageDistribution() {
        Map<String, Integer> data = new LinkedHashMap<>();
        data.put("0-3 LPA", 0);
        data.put("3-6 LPA", 0);
        data.put("6-10 LPA", 0);
        data.put("10+ LPA", 0);

        String sql = "SELECT " +
                "SUM(CASE WHEN package < 3 THEN 1 ELSE 0 END) AS range1, " +
                "SUM(CASE WHEN package >= 3 AND package < 6 THEN 1 ELSE 0 END) AS range2, " +
                "SUM(CASE WHEN package >= 6 AND package < 10 THEN 1 ELSE 0 END) AS range3, " +
                "SUM(CASE WHEN package >= 10 THEN 1 ELSE 0 END) AS range4 " +
                "FROM company_postings";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                data.put("0-3 LPA", rs.getInt("range1"));
                data.put("3-6 LPA", rs.getInt("range2"));
                data.put("6-10 LPA", rs.getInt("range3"));
                data.put("10+ LPA", rs.getInt("range4"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return data;
    }
}