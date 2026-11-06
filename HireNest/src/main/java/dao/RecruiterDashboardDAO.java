package dao;

import util.DBConnection;
import java.sql.*;
import java.util.*;

public class RecruiterDashboardDAO {

    // 1. Get Stats for the 4 Cards
    public Map<String, Integer> getStats(int recruiterId) {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("totalJobs", 0); stats.put("totalApps", 0); stats.put("shortlisted", 0); stats.put("hired", 0);

        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM jobs WHERE recruiter_id = ?")) {
                ps.setInt(1, recruiterId); ResultSet rs = ps.executeQuery();
                if (rs.next()) stats.put("totalJobs", rs.getInt(1));
            }
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM applications a JOIN jobs j ON a.job_id = j.id WHERE j.recruiter_id = ?")) {
                ps.setInt(1, recruiterId); ResultSet rs = ps.executeQuery();
                if (rs.next()) stats.put("totalApps", rs.getInt(1));
            }
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM applications a JOIN jobs j ON a.job_id = j.id WHERE j.recruiter_id = ? AND a.status = 'SHORTLISTED'")) {
                ps.setInt(1, recruiterId); ResultSet rs = ps.executeQuery();
                if (rs.next()) stats.put("shortlisted", rs.getInt(1));
            }
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM applications a JOIN jobs j ON a.job_id = j.id WHERE j.recruiter_id = ? AND a.status = 'SELECTED'")) {
                ps.setInt(1, recruiterId); ResultSet rs = ps.executeQuery();
                if (rs.next()) stats.put("hired", rs.getInt(1));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return stats;
    }

    // 2. Get All Jobs Posted by this Recruiter (With Auto-Expire Logic)
    public List<Map<String, Object>> getJobsByRecruiter(int recruiterId) {
        List<Map<String, Object>> jobs = new ArrayList<>();
        String sql = "SELECT *, CASE WHEN last_date < CURDATE() THEN 'EXPIRED' ELSE status END as real_status " +
                "FROM jobs WHERE recruiter_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, recruiterId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("id"));
                map.put("title", rs.getString("title"));
                map.put("jobType", rs.getString("job_type"));
                map.put("location", rs.getString("location"));
                map.put("salary", rs.getDouble("salary"));
                map.put("lastDate", rs.getDate("last_date"));
                map.put("status", rs.getString("real_status"));
                jobs.add(map);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return jobs;
    }

    // 3. Get Applications for this Recruiter's Jobs
    public List<Map<String, Object>> getApplications(int recruiterId) {
        List<Map<String, Object>> apps = new ArrayList<>();
        String sql = "SELECT a.id, s.name, s.branch, s.cgpa, s.skills, s.resume_path, j.title, a.status " +
                "FROM applications a " +
                "JOIN jobs j ON a.job_id = j.id " +
                "JOIN students s ON a.student_id = s.id " +
                "WHERE j.recruiter_id = ? ORDER BY a.applied_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, recruiterId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("id"));
                map.put("name", rs.getString("name"));
                map.put("branch", rs.getString("branch"));
                map.put("cgpa", rs.getDouble("cgpa"));
                map.put("skills", rs.getString("skills"));
                map.put("resumePath", rs.getString("resume_path"));
                map.put("jobTitle", rs.getString("title"));
                map.put("status", rs.getString("status"));
                apps.add(map);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return apps;
    }

    // 4. Update Application Status (WITH NOTIFICATION TRIGGER)
    public boolean updateApplicationStatus(int appId, String status) {
        String updateSql = "UPDATE applications SET status = ? WHERE id = ?";
        String notifSql = "INSERT INTO notifications (user_id, message) " +
                "SELECT s.user_id, CONCAT('Your application for ', j.title, ' was updated to: ', ?) " +
                "FROM applications a " +
                "JOIN students s ON a.student_id = s.id " +
                "JOIN jobs j ON a.job_id = j.id WHERE a.id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setString(1, status);
                ps.setInt(2, appId);
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(notifSql)) {
                ps.setString(1, status);
                ps.setInt(2, appId);
                ps.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 5. Get Company Profile (WITH LOGO)
    public Map<String, String> getRecruiterProfile(int userId) {
        Map<String, String> profile = new HashMap<>();
        String sql = "SELECT company_name, website, about, logo_url FROM recruiters WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                profile.put("companyName", rs.getString("company_name"));
                profile.put("website", rs.getString("website") != null ? rs.getString("website") : "");
                profile.put("about", rs.getString("about") != null ? rs.getString("about") : "");
                profile.put("logoUrl", rs.getString("logo_url") != null ? rs.getString("logo_url") : "");
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return profile;
    }

    // 6. Update Company Profile (WITH LOGO)
    public boolean updateRecruiterProfile(int userId, String companyName, String website, String about, String logoUrl) {
        String sql = "UPDATE recruiters SET company_name = ?, website = ?, about = ?, logo_url = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, companyName);
            ps.setString(2, website);
            ps.setString(3, about);
            ps.setString(4, logoUrl);
            ps.setInt(5, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }

    // 7. Schedule Interview
    public boolean scheduleInterview(int appId, String date, String time, String mode, String link) {
        String sql = "INSERT INTO interviews (application_id, interview_date, interview_time, mode, meeting_link) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appId);
            ps.setDate(2, java.sql.Date.valueOf(date));
            ps.setTime(3, java.sql.Time.valueOf(time + ":00"));
            ps.setString(4, mode);
            ps.setString(5, link);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error scheduling interview: " + e.getMessage());
            return false;
        }
    }

    // 8. NOTIFICATIONS
    public List<Map<String, String>> getNotifications(int userId) {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT message, created_at FROM notifications WHERE user_id = ? ORDER BY created_at DESC LIMIT 5";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> map = new HashMap<>();
                map.put("message", rs.getString("message"));
                map.put("date", rs.getString("created_at"));
                list.add(map);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int getUnreadCount(int userId) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public void markNotificationsAsRead(int userId) {
        String sql = "UPDATE notifications SET is_read = 1 WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // 10. Recent Applications
    public List<Map<String, Object>> getRecentApplications(int recruiterId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT s.name, s.branch, j.title, a.status, a.applied_at " +
                "FROM applications a JOIN students s ON a.student_id = s.id " +
                "JOIN jobs j ON a.job_id = j.id " +
                "WHERE j.recruiter_id = ? ORDER BY a.applied_at DESC LIMIT 5";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, recruiterId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("studentName", rs.getString("name"));
                map.put("branch", rs.getString("branch"));
                map.put("jobTitle", rs.getString("title"));
                map.put("status", rs.getString("status"));
                map.put("appliedAt", rs.getTimestamp("applied_at"));
                list.add(map);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // 11. Upcoming Interviews
    public List<Map<String, Object>> getUpcomingInterviews(int recruiterId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT s.name, j.title, i.interview_date, i.interview_time, i.mode, i.meeting_link " +
                "FROM interviews i JOIN applications a ON i.application_id = a.id " +
                "JOIN students s ON a.student_id = s.id " +
                "JOIN jobs j ON a.job_id = j.id " +
                "WHERE j.recruiter_id = ? AND i.interview_date >= CURDATE() " +
                "ORDER BY i.interview_date ASC, i.interview_time ASC LIMIT 5";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, recruiterId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("studentName", rs.getString("name"));
                map.put("jobTitle", rs.getString("title"));
                map.put("date", rs.getDate("interview_date"));
                map.put("time", rs.getTime("interview_time"));
                map.put("mode", rs.getString("mode"));
                map.put("link", rs.getString("meeting_link"));
                list.add(map);
            }
        } catch (SQLException e) {
            System.out.println("⚠️ Warning: Could not load interviews. " + e.getMessage());
        }
        return list;
    }

    public List<Map<String, Object>> getFilteredApplications(int recruiterId, String search, String branch, String minCgpa, String jobId, String status) {
        List<Map<String, Object>> apps = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT a.id, s.name, s.branch, s.cgpa, s.skills, s.resume_path, j.title, a.status " +
                        "FROM applications a JOIN jobs j ON a.job_id = j.id " +
                        "JOIN students s ON a.student_id = s.id WHERE j.recruiter_id = ?"
        );
        List<Object> params = new ArrayList<>();
        params.add(recruiterId);

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND s.name LIKE ?"); params.add("%" + search.trim() + "%");
        }
        if (branch != null && !branch.trim().isEmpty()) {
            sql.append(" AND s.branch = ?"); params.add(branch);
        }
        if (minCgpa != null && !minCgpa.trim().isEmpty()) {
            sql.append(" AND s.cgpa >= ?"); params.add(Double.parseDouble(minCgpa));
        }
        if (jobId != null && !jobId.trim().isEmpty()) {
            sql.append(" AND j.id = ?"); params.add(Integer.parseInt(jobId));
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND a.status = ?"); params.add(status);
        }
        sql.append(" ORDER BY a.applied_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("id"));
                map.put("name", rs.getString("name"));
                map.put("branch", rs.getString("branch"));
                map.put("cgpa", rs.getDouble("cgpa"));
                map.put("skills", rs.getString("skills"));
                map.put("resumePath", rs.getString("resume_path"));
                map.put("jobTitle", rs.getString("title"));
                map.put("status", rs.getString("status"));
                apps.add(map);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return apps;
    }
}