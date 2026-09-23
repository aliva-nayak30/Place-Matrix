package Dao;

import Entity.Student;
import Util.DBConnection;

import java.sql.*;

public class StudentDao {
    public boolean saveStudent(Student s) {
        String sql = "INSERT INTO students (user_id, college_id, registration_no, name, phone, "
                + "department, cgpa, passing_year, backlogs) VALUES (?,?,?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, s.getUserId());
            ps.setInt(2, s.getCollegeId());
            ps.setString(3, s.getRegistrationNo());
            ps.setString(4, s.getName());
            ps.setString(5, s.getPhone());
            ps.setString(6, s.getDepartment());
            ps.setDouble(7, s.getCgpa());
            ps.setInt(8, s.getPassingYear());
            ps.setInt(9, s.getBacklogs());

            if (ps.executeUpdate() == 0) return false;
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) s.setId(keys.getInt(1));
            }
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isRegistrationNoExists(String regNo) {
        String sql = "SELECT 1 FROM students WHERE registration_no = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, regNo);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Student getStudentByUserId(int userId) {
        String sql = "SELECT * FROM students WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Student s = new Student();
                    s.setId(rs.getInt("id"));
                    s.setUserId(rs.getInt("user_id"));
                    s.setCollegeId(rs.getInt("college_id"));
                    s.setRegistrationNo(rs.getString("registration_no"));
                    s.setName(rs.getString("name"));
                    s.setPhone(rs.getString("phone"));
                    s.setDepartment(rs.getString("department"));
                    s.setCgpa(rs.getDouble("cgpa"));
                    s.setPassingYear(rs.getInt("passing_year"));
                    s.setBacklogs(rs.getInt("backlogs"));
                    return s;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
