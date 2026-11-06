package dao;

import entity.User;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // ==================================================
    // CREATE
    // ==================================================
    public boolean saveUser(User user) {
        String sql = "INSERT INTO users (name, email, password, phone, role, college_id, is_active, email_verified) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getRole());
            ps.setObject(6, user.getCollegeId());
            ps.setBoolean(7, user.isActive());
            ps.setBoolean(8, user.isEmailVerified());
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    user.setId(rs.getInt(1));
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
    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return extractUser(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return extractUser(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /** Alias used by OTPService. */
    public User findById(int id) {
        return getUserById(id);
    }

    /** Used by LoginController. Reads password column explicitly. */
    public User findByEmail(String email) throws SQLException {
        String sql = "SELECT id, name, email, password, role, phone, college_id, is_active, email_verified FROM users WHERE email = ? LIMIT 1";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setName(rs.getString("name"));
                    u.setEmail(rs.getString("email"));
                    // Ensure both setters are called to cover any controller logic
                    String pwd = rs.getString("password");
                    u.setPasswordHash(pwd);
                    u.setPassword(pwd);
                    u.setRole(rs.getString("role"));
                    u.setPhone(rs.getString("phone"));
                    u.setCollegeId((Integer) rs.getObject("college_id"));
                    u.setActive(rs.getBoolean("is_active"));
                    u.setEmailVerified(rs.getBoolean("email_verified"));
                    return u;
                }
            }
        }
        return null;
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) users.add(extractUser(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    // ==================================================
    // UPDATE
    // ==================================================
    public boolean updateUser(User user) {
        String sql = "UPDATE users SET name = ?, email = ?, password = ?, phone = ?, " +
                "role = ?, college_id = ?, is_active = ?, email_verified = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getRole());
            ps.setObject(6, user.getCollegeId());
            ps.setBoolean(7, user.isActive());
            ps.setBoolean(8, user.isEmailVerified());
            ps.setInt(9, user.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePasswordHash(int userId, String hashedPassword) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /** Alias used by ForgotPassword flow. Column `password`. */
    public void updatePassword(String email, String hashedPassword) throws SQLException {
        String sql = "UPDATE users SET password = ? WHERE email = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setString(2, email);
            ps.executeUpdate();
        }
    }

    public boolean markEmailVerified(int userId) {
        String sql = "UPDATE users SET email_verified = 1 WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean activateCollegeAdmin(int collegeId) {
        String sql = "UPDATE users SET is_active = 1 WHERE role = 'COLLEGE_ADMIN' AND college_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, collegeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==================================================
    // DELETE + COUNT
    // ==================================================
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getUserCount() {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ==================================================
    // VALIDATION
    // ==================================================
    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ==================================================
    // SET ACTIVE
    // ==================================================
    public boolean setActive(int userId, boolean active) {
        String sql = "UPDATE users SET is_active = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, active);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==================================================
    // Fetch Pending College Admin Requests
    // ==================================================
    public List<entity.CollegeAdminRequest> getPendingCollegeAdmins() {
        List<entity.CollegeAdminRequest> list = new ArrayList<>();
        String sql = "SELECT u.id as user_id, u.name, u.email, c.college_name, u.created_at " +
                "FROM users u JOIN colleges c ON u.college_id = c.id " +
                "WHERE u.role = 'COLLEGE_ADMIN' AND u.is_active = 0 " +
                "ORDER BY u.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                entity.CollegeAdminRequest req = new entity.CollegeAdminRequest();
                req.setUserId(rs.getInt("user_id"));
                req.setName(rs.getString("name"));
                req.setEmail(rs.getString("email"));
                req.setCollegeName(rs.getString("college_name"));
                req.setRequestedDate(rs.getString("created_at"));
                list.add(req);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }


    public boolean updateUserPassword(int userId, String newHashedPassword) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newHashedPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    // ==================================================
    // MAPPER
    // ==================================================
    private User extractUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));

        // Ensure both setters are set for compatibility
        String pwd = rs.getString("password");
        user.setPassword(pwd);
        user.setPasswordHash(pwd);

        user.setPhone(rs.getString("phone"));
        try { user.setProfilePic(rs.getString("profile_pic")); } catch (SQLException ignored) {}
        user.setRole(rs.getString("role"));
        user.setCollegeId((Integer) rs.getObject("college_id"));
        user.setActive(rs.getBoolean("is_active"));
        try { user.setEmailVerified(rs.getBoolean("email_verified")); } catch (SQLException ignored) {}
        try { user.setLastLogin(rs.getString("last_login")); } catch (SQLException ignored) {}
        try { user.setCreatedAt(rs.getString("created_at")); } catch (SQLException ignored) {}
        try { user.setUpdatedAt(rs.getString("updated_at")); } catch (SQLException ignored) {}
        return user;
    }
}