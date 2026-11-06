package dao;

import entity.Student;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class StudentDAO {

    // ==================================================
    // SAVE STUDENT
    // ==================================================
    public boolean saveStudent(Student student) {
        String sql = "INSERT INTO students (" +
                "user_id, college_id, name, email, registration_no, branch, " +
                "passout_year, gender, dob, cgpa, backlogs, " +
                "tenth_percentage, twelfth_percentage, skills, phone, address, " +
                "linkedin_url, github_url, status" +
                ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, student.getUserId());
            ps.setInt(2, student.getCollegeId());
            ps.setString(3, student.getName());
            ps.setString(4, student.getEmail());
            ps.setString(5, student.getRegistrationNo());
            ps.setString(6, student.getBranch());
            ps.setInt(7, student.getPassoutYear());
            ps.setString(8, student.getGender());
            ps.setDate(9, student.getDob());
            ps.setDouble(10, student.getCgpa());
            ps.setInt(11, student.getBacklogs());
            ps.setDouble(12, student.getTenthPercentage());
            ps.setDouble(13, student.getTwelfthPercentage());
            ps.setString(14, student.getSkills());
            ps.setString(15, student.getPhone());
            ps.setString(16, student.getAddress());
            ps.setString(17, student.getLinkedinUrl());
            ps.setString(18, student.getGithubUrl());
            ps.setString(19, student.getStatus() != null ? student.getStatus() : "PENDING");

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    student.setId(rs.getInt(1));
                    return true;
                }
            }
        } catch (SQLException e) {
            System.out.println("❌ ERROR SAVING STUDENT TO DB: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public Student getStudentByUserId(int userId) {
        String sql = "SELECT * FROM students WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return extractStudent(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public Student getStudentById(int id) {
        String sql = "SELECT * FROM students WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return extractStudent(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Student> getStudentsByCollegeId(int collegeId) {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM students WHERE college_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, collegeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) students.add(extractStudent(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return students;
    }

    // ==================================================
    // NEW: GET ELIGIBLE COMPANIES - Jobs + Companies (UNION)
    // ==================================================
    public List<Map<String, Object>> getEligibleCompanies(int collegeId, double cgpa, int backlogs, String branch) {
        List<Map<String, Object>> list = new ArrayList<>();

        // 🔥 FIX: UNION to fetch from BOTH jobs (Recruiters) and companies (College Admin)
        String sql = "SELECT j.id, r.company_name, j.title as job_title, j.salary as package_lpa, j.last_date as drive_date, j.status " +
                "FROM jobs j JOIN recruiters r ON j.recruiter_id = r.user_id " +
                "WHERE j.college_id = ? AND j.last_date >= CURDATE() " +
                "AND (j.min_cgpa <= ? OR j.min_cgpa IS NULL) " +
                "AND (j.max_backlogs >= ? OR j.max_backlogs IS NULL) " +
                "AND (j.eligible_branches LIKE ? OR j.eligible_branches IS NULL OR j.eligible_branches = '') " +
                "UNION " +
                "SELECT c.id, c.company_name, 'Campus Drive' as job_title, c.package_lpa, c.drive_date, c.status " +
                "FROM companies c " +
                "WHERE c.college_id = ? AND c.drive_date >= CURDATE() " +
                "ORDER BY drive_date ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, collegeId); ps.setDouble(2, cgpa); ps.setInt(3, backlogs); ps.setString(4, "%" + branch + "%");
            ps.setInt(5, collegeId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("id"));
                map.put("companyName", rs.getString("company_name"));
                map.put("jobTitle", rs.getString("job_title"));
                map.put("packageLpa", rs.getDouble("package_lpa"));
                map.put("driveDate", rs.getDate("drive_date"));
                map.put("status", rs.getString("status"));
                list.add(map);
            }
        } catch (SQLException e) {
            System.out.println("❌ Error loading eligible companies: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateStudentStatus(int studentId, String status) {
        String sql = "UPDATE students SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, studentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateStudent(Student student) {
        String sql = "UPDATE students SET " +
                "name = ?, branch = ?, passout_year = ?, gender = ?, dob = ?, " +
                "cgpa = ?, backlogs = ?, tenth_percentage = ?, twelfth_percentage = ?, " +
                "skills = ?, phone = ?, address = ?, " +
                "linkedin_url = ?, github_url = ?, profile_photo = ? " +
                "WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, student.getName());
            ps.setString(2, student.getBranch());
            ps.setInt(3, student.getPassoutYear());
            ps.setString(4, student.getGender());
            ps.setDate(5, student.getDob());
            ps.setDouble(6, student.getCgpa());
            ps.setInt(7, student.getBacklogs());
            ps.setDouble(8, student.getTenthPercentage());
            ps.setDouble(9, student.getTwelfthPercentage());
            ps.setString(10, student.getSkills());
            ps.setString(11, student.getPhone());
            ps.setString(12, student.getAddress());
            ps.setString(13, student.getLinkedinUrl());
            ps.setString(14, student.getGithubUrl());
            ps.setString(15, student.getProfilePhoto());
            ps.setInt(16, student.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean isRegistrationNoExists(String regNo) {
        String sql = "SELECT COUNT(*) FROM students WHERE registration_no = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, regNo);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateResumePath(int studentId, String resumePath) {
        String sql = "UPDATE students SET resume_path = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, resumePath);
            ps.setInt(2, studentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateProfilePhoto(int studentId, String photoPath) {
        String sql = "UPDATE students SET profile_photo = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, photoPath);
            ps.setInt(2, studentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateAtsScore(int studentId, int score) {
        String sql = "UPDATE students SET ats_score = ?, ats_last_updated = NOW() WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, score);
            ps.setInt(2, studentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public int getAtsScore(int studentId) {
        String sql = "SELECT ats_score FROM students WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("ats_score");
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<Student> searchStudents(String search, String branch, String minCgpa) {
        List<Student> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM students WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR email LIKE ? OR registration_no LIKE ?)");
            String like = "%" + search.trim() + "%";
            params.add(like); params.add(like); params.add(like);
        }
        if (branch != null && !branch.trim().isEmpty()) {
            sql.append(" AND branch = ?");
            params.add(branch);
        }
        if (minCgpa != null && !minCgpa.trim().isEmpty()) {
            try {
                double c = Double.parseDouble(minCgpa);
                sql.append(" AND cgpa >= ?");
                params.add(c);
            } catch (NumberFormatException ignored) {}
        }
        sql.append(" ORDER BY id DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(extractStudent(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<String> getAllBranches() {
        List<String> branches = new ArrayList<>();
        String sql = "SELECT DISTINCT branch FROM students WHERE branch IS NOT NULL AND branch <> ''";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) branches.add(rs.getString("branch"));
        } catch (SQLException e) { e.printStackTrace(); }
        return branches;
    }

    public boolean toggleUserStatus(int userId, boolean active) {
        String sql = "UPDATE users SET is_active = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, active);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    // 🔥 FIX: Manual deletion of applications before deleting student
    public boolean deleteStudentAndUser(int studentId, int userId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Delete applications first to prevent Foreign Key error
            try (PreparedStatement psApp = conn.prepareStatement("DELETE FROM applications WHERE student_id = ?")) {
                psApp.setInt(1, studentId);
                psApp.executeUpdate();
            }

            // 2. Delete Student Profile
            try (PreparedStatement ps1 = conn.prepareStatement("DELETE FROM students WHERE id = ?")) {
                ps1.setInt(1, studentId);
                ps1.executeUpdate();
            }

            // 3. Delete User Account
            try (PreparedStatement ps2 = conn.prepareStatement("DELETE FROM users WHERE id = ?")) {
                ps2.setInt(1, userId);
                int rows = ps2.executeUpdate();
                conn.commit();
                return rows > 0;
            }
        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    public boolean markAsPlaced(int studentId) {
        String sql = "UPDATE students SET is_placed = 1 WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public int calculateProfileCompletion(Student s) {
        if (s == null) return 0;
        int score = 0;
        if (s.getName() != null && !s.getName().trim().isEmpty()) score++;
        if (s.getEmail() != null && !s.getEmail().trim().isEmpty()) score++;
        if (s.getCgpa() > 0) score++;
        if (s.getSkills() != null && !s.getSkills().trim().isEmpty()) score++;
        if (s.getResumePath() != null && !s.getResumePath().trim().isEmpty()) score++;
        if (s.getPhone() != null && !s.getPhone().trim().isEmpty()) score++;
        if (s.getTenthPercentage() > 0 && s.getTwelfthPercentage() > 0) score++;
        if (s.getLinkedinUrl() != null && !s.getLinkedinUrl().trim().isEmpty()) score++;
        if (s.getGithubUrl() != null && !s.getGithubUrl().trim().isEmpty()) score++;
        if (s.getProfilePhoto() != null && !s.getProfilePhoto().trim().isEmpty()) score++;
        return (score * 100) / 10;
    }

    public List<Student> getPendingStudentsByCollege(int collegeId) {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM students WHERE status='PENDING' AND college_id=? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, collegeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(extractStudent(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private Student extractStudent(ResultSet rs) throws SQLException {
        Student student = new Student();
        student.setId(rs.getInt("id"));
        student.setUserId(rs.getInt("user_id"));
        student.setCollegeId(rs.getInt("college_id"));
        student.setName(rs.getString("name"));
        student.setEmail(rs.getString("email"));
        student.setRegistrationNo(rs.getString("registration_no"));
        student.setBranch(rs.getString("branch"));
        student.setPassoutYear(rs.getInt("passout_year"));
        student.setGender(rs.getString("gender"));
        student.setDob(rs.getDate("dob"));
        student.setCgpa(rs.getDouble("cgpa"));
        student.setBacklogs(rs.getInt("backlogs"));
        student.setTenthPercentage(rs.getDouble("tenth_percentage"));
        student.setTwelfthPercentage(rs.getDouble("twelfth_percentage"));
        student.setSkills(rs.getString("skills"));
        student.setResumePath(rs.getString("resume_path"));
        student.setPhone(rs.getString("phone"));
        student.setAddress(rs.getString("address"));
        student.setProfilePhoto(rs.getString("profile_photo"));
        student.setLinkedinUrl(rs.getString("linkedin_url"));
        student.setGithubUrl(rs.getString("github_url"));
        student.setStatus(rs.getString("status"));
        student.setCreatedAt(rs.getString("created_at"));
        try { student.setPlaced(rs.getBoolean("is_placed")); } catch (SQLException ignored) {}
        try { student.setActive(rs.getBoolean("is_active")); } catch (SQLException ignored) {}
        try { student.setPlacedCompany(rs.getString("placed_company")); } catch (SQLException ignored) {}
        try { student.setPlacedPackage(rs.getDouble("placed_package")); } catch (SQLException ignored) {}
        return student;
    }
}