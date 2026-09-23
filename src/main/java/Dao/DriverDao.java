package Dao;

import Entity.Drive;
import Util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DriverDao {
    public List<Drive> getOpenDrives() {
        String sql = "SELECT d.*, r.company_name FROM drives d "
                + "JOIN recruiters r ON r.id = d.recruiter_id "
                + "WHERE d.status = 'OPEN' AND r.status = 'APPROVED' "
                + "ORDER BY d.last_date ASC";
        List<Drive> drives = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Drive d = new Drive();
                d.setId(rs.getInt("id"));
                d.setRecruiterId(rs.getInt("recruiter_id"));
                d.setCollegeId(rs.getInt("college_id"));
                d.setTitle(rs.getString("title"));
                d.setDescription(rs.getString("description"));
                d.setJobLocation(rs.getString("job_location"));
                d.setPackageLpa(rs.getDouble("package_lpa"));
                d.setDriveDate(rs.getDate("drive_date"));
                d.setLastDate(rs.getDate("last_date"));
                d.setStatus(rs.getString("status"));
                d.setCompanyName(rs.getString("company_name"));
                drives.add(d);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return drives;
    }
}
