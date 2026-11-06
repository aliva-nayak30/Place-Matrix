package dao;

import util.DBConnection;
import java.sql.*;
import java.util.*;

public class CollegeApplicationDAO {

    public List<Map<String, Object>> getApplications(int collegeId, String status) {
        List<Map<String, Object>> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT a.id, a.status, a.applied_date, a.recruiter_remarks, " +
                        "s.name AS student_name, s.branch, s.cgpa, " +
                        "cp.job_title, cp.package, " +
                        "r.company_name " +
                        "FROM applications a " +
                        "JOIN students s ON a.student_id = s.id " +
                        "JOIN company_postings cp ON a.company_posting_id = cp.id " +
                        "JOIN recruiters r ON cp.recruiter_id = r.id " +
                        "WHERE a.college_id = ?");

        if (status != null && !status.isEmpty()) sql.append(" AND a.status = ?");
        sql.append(" ORDER BY a.applied_date DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, collegeId);
            if (status != null && !status.isEmpty()) ps.setString(2, status);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("id", rs.getInt("id"));
                row.put("studentName", rs.getString("student_name"));
                row.put("branch", rs.getString("branch"));
                row.put("cgpa", rs.getDouble("cgpa"));
                row.put("companyName", rs.getString("company_name"));
                row.put("jobTitle", rs.getString("job_title"));
                row.put("package", rs.getDouble("package"));
                row.put("appliedDate", rs.getTimestamp("applied_date"));
                row.put("status", rs.getString("status"));
                row.put("remarks", rs.getString("recruiter_remarks"));
                list.add(row);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Map<String, Integer> getStatusCounts(int collegeId) {
        Map<String, Integer> counts = new HashMap<>();
        counts.put("Applied", 0);
        counts.put("Shortlisted", 0);
        counts.put("Interview", 0);
        counts.put("Rejected", 0);
        counts.put("Hired", 0);
        counts.put("Total", 0);

        String sql = "SELECT status, COUNT(*) AS cnt FROM applications WHERE college_id = ? GROUP BY status";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, collegeId);
            ResultSet rs = ps.executeQuery();
            int total = 0;
            while (rs.next()) {
                String st = rs.getString("status");
                int c = rs.getInt("cnt");
                counts.put(st, c);
                total += c;
            }
            counts.put("Total", total);
        } catch (SQLException e) { e.printStackTrace(); }
        return counts;
    }
}