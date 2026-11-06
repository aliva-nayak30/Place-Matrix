package controller.collegeAdmin;

import util.DBConnection;
import util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/collegeadmin/import-students")
@MultipartConfig // 🔥 REQUIRED for file upload
public class BulkImportController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer collegeId = (Integer) request.getSession().getAttribute("collegeId");
        if (collegeId == null) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }

        int successCount = 0;
        int errorCount = 0;

        try {
            Part filePart = request.getPart("file");
            if (filePart == null || filePart.getSize() == 0) {
                request.getSession().setAttribute("errorMsg", "Please select a CSV file.");
                response.sendRedirect(request.getContextPath() + "/collegeadmin/students");
                return;
            }

            BufferedReader reader = new BufferedReader(new InputStreamReader(filePart.getInputStream()));
            String line;
            boolean firstLine = true;

            try (Connection conn = DBConnection.getConnection()) {
                conn.setAutoCommit(false); // Transaction

                // SQL for Users table
                String userSql = "INSERT INTO users (name, email, password, role, college_id, is_active, email_verified) VALUES (?, ?, ?, 'STUDENT', ?, 1, 1)";
                PreparedStatement psUser = conn.prepareStatement(userSql, PreparedStatement.RETURN_GENERATED_KEYS);

                // SQL for Students table
                String studentSql = "INSERT INTO students (user_id, college_id, name, email, roll_no, branch, phone, cgpa, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'APPROVED')";
                PreparedStatement psStudent = conn.prepareStatement(studentSql);

                while ((line = reader.readLine()) != null) {
                    if (firstLine) { firstLine = false; continue; } // Skip header

                    String[] data = line.split(",");
                    if (data.length >= 6) {
                        try {
                            String name = data[0].trim();
                            String email = data[1].trim();
                            String rollNo = data[2].trim();
                            String branch = data[3].trim();
                            String phone = data[4].trim();
                            double cgpa = Double.parseDouble(data[5].trim());

                            // Default password is 'Student@123'
                            String hashedPwd = PasswordUtil.hashPassword("Student@123");

                            // 1. Insert into Users
                            psUser.setString(1, name);
                            psUser.setString(2, email);
                            psUser.setString(3, hashedPwd);
                            psUser.setInt(4, collegeId);
                            psUser.executeUpdate();

                            java.sql.ResultSet rs = psUser.getGeneratedKeys();
                            int userId = 0;
                            if (rs.next()) userId = rs.getInt(1);

                            // 2. Insert into Students
                            psStudent.setInt(1, userId);
                            psStudent.setInt(2, collegeId);
                            psStudent.setString(3, name);
                            psStudent.setString(4, email);
                            psStudent.setString(5, rollNo);
                            psStudent.setString(6, branch);
                            psStudent.setString(7, phone);
                            psStudent.setDouble(8, cgpa);
                            psStudent.executeUpdate();

                            successCount++;
                        } catch (Exception e) {
                            errorCount++; // Skip bad rows (e.g., duplicate email)
                        }
                    }
                }
                conn.commit();
            }
            request.getSession().setAttribute("successMsg", successCount + " students imported successfully! Default Password: Student@123. Errors: " + errorCount);
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMsg", "Import failed: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/collegeadmin/students");
    }
}