package dao;

import entity.Student;
import util.DBConnection;
import java.sql.*;
import java.util.*;

public class CollegeStudentDAO {

    // Get all students of a college
    public List<Student> getStudentsByCollege(int collegeId, String status) {
        List<Student> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM students WHERE college_id = ?");
        if (status != null && !status.isEmpty()) sql.append(" AND status = ?");
        sql.append(" ORDER BY id DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, collegeId);
            if (status != null && !status.isEmpty()) ps.setString(2, status);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(extract(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Approve / Reject
    public boolean updateStatus(int studentId, String status) {
        String sql = "UPDATE students SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, studentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    // Mark placed
    public boolean markPlaced(int studentId) {
        String sql = "UPDATE students SET is_placed = 1 WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private Student extract(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setId(rs.getInt("id"));
        s.setUserId(rs.getInt("user_id"));
        s.setCollegeId(rs.getInt("college_id"));
        s.setName(rs.getString("name"));
        s.setEmail(rs.getString("email"));
        s.setRegistrationNo(rs.getString("registration_no"));
        s.setBranch(rs.getString("branch"));
        s.setCgpa(rs.getDouble("cgpa"));
        s.setPhone(rs.getString("phone"));
        s.setStatus(rs.getString("status"));
        try { s.setPlaced(rs.getBoolean("is_placed")); } catch (Exception ignored) {}
        return s;
    }
}