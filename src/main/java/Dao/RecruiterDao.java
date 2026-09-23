package Dao;

import Entity.Recruiter;
import Util.DBConnection;

import java.sql.*;

public class RecruiterDao {
    public boolean saveRecruiter(Recruiter r) {
        String sql = "INSERT INTO recruiters (user_id, college_id, company_name, hr_name, hr_email, phone, status) "
                + "VALUES (?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, r.getUserId());
            ps.setInt(2, r.getCollegeId());
            ps.setString(3, r.getCompanyName());
            ps.setString(4, r.getHrName());
            ps.setString(5, r.getHrEmail());
            ps.setString(6, r.getPhone());
            ps.setString(7, r.getStatus());

            if (ps.executeUpdate() == 0) return false;
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) r.setId(keys.getInt(1));
            }
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
