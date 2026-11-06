package dao;

import entity.Application;
import entity.ApplicationDTO;
import util.DBConnection;

import java.sql.*;
import java.util.*;

public class ApplicationDAO {

    // ==================================================
    // APPLY TO A JOB
    // ==================================================
    public boolean applyToJob(int studentId, int jobId) {
        String sql = "INSERT INTO applications (student_id, job_id, status) VALUES (?, ?, 'Applied')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2, jobId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==================================================
    // CHECK IF ALREADY APPLIED
    // ==================================================
    public boolean hasApplied(int studentId, int jobId) {
        String sql = "SELECT COUNT(*) FROM applications WHERE student_id = ? AND job_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2, jobId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ==================================================
    // GET APPLIED JOB IDs (for Find Jobs page)
    // ==================================================
    public Set<Integer> getAppliedJobIds(int studentId) {
        Set<Integer> ids = new HashSet<>();
        String sql = "SELECT job_id FROM applications WHERE student_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ids.add(rs.getInt("job_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ids;
    }

    // ==================================================
    // GET RECENT N APPLICATIONS (JOIN with jobs table)
    // ==================================================
    public List<Application> getRecentApplications(int studentId, int limit) {
        List<Application> apps = new ArrayList<>();
        String sql = "SELECT a.id, a.student_id, a.job_id, a.applied_date, a.status, " +
                "j.company_name, j.role, j.logo_path, j.location, j.ctc " +
                "FROM applications a " +
                "JOIN jobs j ON a.job_id = j.id " +
                "WHERE a.student_id = ? " +
                "ORDER BY a.applied_date DESC LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                apps.add(mapAppRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return apps;
    }

    // ==================================================
    // GET ALL APPLICATIONS FOR A STUDENT
    // ==================================================
    public List<Application> getApplicationsByStudent(int studentId) {
        List<Application> apps = new ArrayList<>();
        String sql = "SELECT a.id, a.student_id, a.job_id, a.applied_date, a.status, " +
                "j.company_name, j.role, j.logo_path, j.location, j.ctc " +
                "FROM applications a " +
                "JOIN jobs j ON a.job_id = j.id " +
                "WHERE a.student_id = ? " +
                "ORDER BY a.applied_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                apps.add(mapAppRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return apps;
    }

    // ==================================================
    // GET STATUS COUNTS (for stat cards + chart)
    // ==================================================
    public Map<String, Integer> getStatusCounts(int studentId) {
        Map<String, Integer> counts = new HashMap<>();

        counts.put("Applied", 0);
        counts.put("Shortlisted", 0);
        counts.put("Interview", 0);
        counts.put("Rejected", 0);
        counts.put("Hired", 0);
        counts.put("Withdrawn", 0);
        counts.put("Total", 0);

        String sql = "SELECT status, COUNT(*) AS cnt " +
                "FROM applications " +
                "WHERE student_id = ? " +
                "GROUP BY status";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();

            int total = 0;
            while (rs.next()) {
                String status = rs.getString("status");
                int cnt = rs.getInt("cnt");
                counts.put(status, cnt);
                total += cnt;
            }
            counts.put("Total", total);

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return counts;
    }

    // ==================================================
    // GET APPLICATIONS BY STATUS (for filter tabs)
    // ==================================================
    public List<ApplicationDTO> getApplicationsByStatus(int studentId, String status) {
        List<ApplicationDTO> list = new ArrayList<>();

        String sql = "SELECT a.id, a.student_id, a.job_id, a.applied_date, a.status, " +
                "a.recruiter_remarks, a.interview_date, a.interview_location, " +
                "j.company_name, j.logo_path, j.role, j.location, j.ctc " +
                "FROM applications a " +
                "JOIN jobs j ON a.job_id = j.id " +
                "WHERE a.student_id = ? AND a.status = ? " +
                "ORDER BY a.applied_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapDTO(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==================================================
    // GET ALL APPLICATIONS AS DTO (for My Applications page)
    // ==================================================
    public List<ApplicationDTO> getApplicationsByStudentId(int studentId) {
        List<ApplicationDTO> list = new ArrayList<>();

        String sql = "SELECT a.id, a.student_id, a.job_id, a.applied_date, a.status, " +
                "a.recruiter_remarks, a.interview_date, a.interview_location, " +
                "j.company_name, j.logo_path, j.role, j.location, j.ctc " +
                "FROM applications a " +
                "JOIN jobs j ON a.job_id = j.id " +
                "WHERE a.student_id = ? " +
                "ORDER BY a.applied_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapDTO(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==================================================
    // WITHDRAW APPLICATION (Only if status = 'Applied')
    // ==================================================
    public boolean withdrawApplication(int applicationId, int studentId) {
        String sql = "UPDATE applications SET status = 'Withdrawn' " +
                "WHERE id = ? AND student_id = ? AND status = 'Applied'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, applicationId);
            ps.setInt(2, studentId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==================================================
    // MAP RESULTSET ROW → Application OBJECT
    // ==================================================
    private Application mapAppRow(ResultSet rs) throws SQLException {
        Application app = new Application();
        app.setId(rs.getInt("id"));
        app.setStudentId(rs.getInt("student_id"));
        app.setJobId(rs.getInt("job_id"));
        app.setAppliedDate(rs.getTimestamp("applied_date"));
        app.setStatus(rs.getString("status"));
        app.setCompanyName(rs.getString("company_name"));
        app.setRole(rs.getString("role"));
        app.setLogoPath(rs.getString("logo_path"));
        app.setLocation(rs.getString("location"));
        app.setCtc(rs.getDouble("ctc"));
        return app;
    }

    // ==================================================
    // GET ALL APPLICATIONS FOR A COLLEGE (For College Admin)
    // ==================================================
    public List<ApplicationDTO> getApplicationsByCollege(int collegeId) {
        List<ApplicationDTO> list = new ArrayList<>();
        // Assuming 'jobs' table has a 'college_id' column to link it to the college
        String sql = "SELECT a.id, a.student_id, a.job_id, a.applied_date, a.status, " +
                "a.recruiter_remarks, a.interview_date, a.interview_location, " +
                "j.company_name, j.logo_path, j.role, j.location, j.ctc " +
                "FROM applications a " +
                "JOIN jobs j ON a.job_id = j.id " +
                "WHERE j.college_id = ? " +
                "ORDER BY a.applied_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, collegeId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapDTO(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==================================================
    // MAP RESULTSET ROW → ApplicationDTO (for My Applications)
    // ==================================================
    private ApplicationDTO mapDTO(ResultSet rs) throws SQLException {
        ApplicationDTO dto = new ApplicationDTO();
        dto.setId(rs.getInt("id"));
        dto.setStudentId(rs.getInt("student_id"));
        dto.setJobId(rs.getInt("job_id"));
        dto.setStatus(rs.getString("status"));
        dto.setAppliedDate(rs.getTimestamp("applied_date"));
        dto.setRecruiterRemarks(rs.getString("recruiter_remarks"));
        dto.setInterviewDate(rs.getDate("interview_date"));
        dto.setInterviewLocation(rs.getString("interview_location"));

        // From JOIN with jobs table
        dto.setCompanyName(rs.getString("company_name"));
        dto.setCompanyLogo(rs.getString("logo_path"));
        dto.setRole(rs.getString("role"));
        dto.setLocation(rs.getString("location"));
        dto.setPackageLpa(rs.getDouble("ctc"));
        return dto;
    }
}