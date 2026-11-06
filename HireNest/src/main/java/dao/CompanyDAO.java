package dao;

import entity.Company;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CompanyDAO {

    public boolean addCompany(Company c) {
        String sql = "INSERT INTO companies (college_id, company_name, package_lpa, eligible_branches, min_cgpa, max_backlogs, drive_date, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, c.getCollegeId());
            ps.setString(2, c.getCompanyName());
            ps.setDouble(3, c.getPackageLpa());
            ps.setString(4, c.getEligibleBranches());
            ps.setDouble(5, c.getMinCgpa());
            ps.setInt(6, c.getMaxBacklogs());
            ps.setDate(7, c.getDriveDate());
            ps.setString(8, c.getStatus() != null ? c.getStatus() : "UPCOMING");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Company> getCompaniesByCollege(int collegeId) {
        List<Company> list = new ArrayList<>();
        String sql = "SELECT * FROM companies WHERE college_id = ? ORDER BY drive_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, collegeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Company c = new Company();
                c.setId(rs.getInt("id"));
                c.setCompanyName(rs.getString("company_name"));
                c.setPackageLpa(rs.getDouble("package_lpa"));
                c.setEligibleBranches(rs.getString("eligible_branches"));
                c.setMinCgpa(rs.getDouble("min_cgpa"));
                c.setMaxBacklogs(rs.getInt("max_backlogs"));
                c.setDriveDate(rs.getDate("drive_date"));
                c.setStatus(rs.getString("status"));
                list.add(c);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Company getCompanyById(int id) {
        String sql = "SELECT * FROM companies WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Company c = new Company();
                c.setId(rs.getInt("id"));
                c.setCompanyName(rs.getString("company_name"));
                c.setPackageLpa(rs.getDouble("package_lpa"));
                c.setEligibleBranches(rs.getString("eligible_branches"));
                c.setMinCgpa(rs.getDouble("min_cgpa"));
                c.setMaxBacklogs(rs.getInt("max_backlogs"));
                return c;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }
}