package controller.collegeAdmin;

import util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/collegeadmin/upload-whitelist")
@MultipartConfig
public class WhitelistController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer collegeId = (Integer) request.getSession().getAttribute("collegeId");
        if (collegeId == null) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }

        try {
            Part filePart = request.getPart("file");
            BufferedReader reader = new BufferedReader(new InputStreamReader(filePart.getInputStream()));
            String line;
            boolean firstLine = true;
            int count = 0;

            try (Connection conn = DBConnection.getConnection()) {
                // Insert ONLY the roll number
                String sql = "INSERT IGNORE INTO college_whitelist (college_id, roll_number) VALUES (?, ?)";
                PreparedStatement ps = conn.prepareStatement(sql);

                while ((line = reader.readLine()) != null) {
                    if (firstLine) { firstLine = false; continue; } // Skip header row
                    String rollNo = line.trim();
                    if (!rollNo.isEmpty()) {
                        ps.setInt(1, collegeId);
                        ps.setString(2, rollNo);
                        ps.addBatch();
                        count++;
                    }
                }
                ps.executeBatch();
            }
            request.getSession().setAttribute("successMsg", count + " roll numbers added to Whitelist!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMsg", "Error uploading whitelist.");
        }
        response.sendRedirect(request.getContextPath() + "/collegeadmin/students");
    }
}