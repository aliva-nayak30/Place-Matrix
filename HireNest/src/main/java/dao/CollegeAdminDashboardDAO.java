package dao;

import util.DBConnection;
import java.sql.*;
import java.util.*;

public class CollegeAdminDashboardDAO {

    public Map<String, Integer> getStats(int collegeId) {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("totalStudents", 0);
        stats.put("pendingStudents", 0);
        stats.put("placedStudents", 0);
        stats.put("totalCompanies", 0);
        stats.put("activeDrives", 0);
        stats.put("totalApplications", 0);

        try (Connection conn = DBConnection.getConnection()) {
            // Total Students
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM students WHERE college_id = ?")) {
                ps.setInt(1, collegeId); ResultSet rs = ps.executeQuery(); if (rs.next()) stats.put("totalStudents", rs.getInt(1));
            }
            // Pending Students
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM students WHERE status='PENDING' AND college_id = ?")) {
                ps.setInt(1, collegeId); ResultSet rs = ps.executeQuery(); if (rs.next()) stats.put("pendingStudents", rs.getInt(1));
            }
            // Placed Students
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM students WHERE is_placed = 1 AND college_id = ?")) {
                ps.setInt(1, collegeId); ResultSet rs = ps.executeQuery(); if (rs.next()) stats.put("placedStudents", rs.getInt(1));
            }
            // FIX: Total Companies (Join jobs with recruiters)
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT COUNT(DISTINCT r.company_name) FROM jobs j JOIN recruiters r ON j.recruiter_id = r.user_id WHERE j.college_id = ?")) {
                ps.setInt(1, collegeId); ResultSet rs = ps.executeQuery(); if (rs.next()) stats.put("totalCompanies", rs.getInt(1));
            }
            // Active Drives
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM jobs WHERE last_date >= CURDATE() AND college_id = ?")) {
                ps.setInt(1, collegeId); ResultSet rs = ps.executeQuery(); if (rs.next()) stats.put("activeDrives", rs.getInt(1));
            }
            // Total Applications (Join with jobs)
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT COUNT(*) FROM applications a JOIN jobs j ON a.job_id = j.id WHERE j.college_id = ?")) {
                ps.setInt(1, collegeId); ResultSet rs = ps.executeQuery(); if (rs.next()) stats.put("totalApplications", rs.getInt(1));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return stats;
    }

    public Map<String, Double> getPlacementAnalytics(int collegeId) {
        Map<String, Double> analytics = new HashMap<>();
        analytics.put("highestPackage", 0.0);
        analytics.put("averagePackage", 0.0);

        // Use jobs and applications
        String sql = "SELECT MAX(j.salary) as highest, AVG(j.salary) as avg_pkg " +
                "FROM applications a JOIN jobs j ON a.job_id = j.id " +
                "WHERE a.status = 'SELECTED' AND j.college_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, collegeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                analytics.put("highestPackage", rs.getDouble("highest"));
                analytics.put("averagePackage", rs.getDouble("avg_pkg"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return analytics;
    }

    public Map<String, Double> getBranchStats(int collegeId) {
        Map<String, Double> branchStats = new LinkedHashMap<>();
        String sql = "SELECT branch, ROUND(SUM(CASE WHEN is_placed=1 THEN 1 ELSE 0 END)*100.0/COUNT(*),1) as percent " +
                "FROM students WHERE status='APPROVED' AND college_id=? GROUP BY branch";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, collegeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                branchStats.put(rs.getString("branch"), rs.getDouble("percent"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return branchStats;
    }

    public Map<String, Integer> getPlacementStatus(int collegeId) {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("placed", 0);
        stats.put("unplaced", 0);
        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM students WHERE is_placed=1 AND status='APPROVED' AND college_id=?")) {
                ps.setInt(1, collegeId); ResultSet rs = ps.executeQuery(); if (rs.next()) stats.put("placed", rs.getInt(1));
            }
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM students WHERE is_placed=0 AND status='APPROVED' AND college_id=?")) {
                ps.setInt(1, collegeId); ResultSet rs = ps.executeQuery(); if (rs.next()) stats.put("unplaced", rs.getInt(1));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return stats;
    }
}