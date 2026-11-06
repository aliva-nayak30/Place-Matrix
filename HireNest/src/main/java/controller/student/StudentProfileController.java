package controller.student;

import dao.StudentDAO;
import entity.Student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/student/profile")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,   // 2 MB
        maxFileSize = 1024 * 1024 * 5,          // 5 MB
        maxRequestSize = 1024 * 1024 * 10       // 10 MB
)
public class StudentProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String PHOTO_DIR = "uploads" + File.separator + "photos";

    private StudentDAO studentDAO;

    @Override
    public void init() {
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        Student student = studentDAO.getStudentByUserId(userId);

        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        request.setAttribute("student", student);
        request.setAttribute("profilePercent", studentDAO.calculateProfileCompletion(student));

        request.getRequestDispatcher("/student/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        Student existing = studentDAO.getStudentByUserId(userId);

        if (existing == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String gender = request.getParameter("gender");
            String dobStr = request.getParameter("dob");
            String passoutYearStr = request.getParameter("passoutYear");
            String cgpaStr = request.getParameter("cgpa");
            String backlogsStr = request.getParameter("backlogs");
            String tenthStr = request.getParameter("tenthPercentage");
            String twelfthStr = request.getParameter("twelfthPercentage");
            String skills = request.getParameter("skills");
            String address = request.getParameter("address");
            String linkedinUrl = request.getParameter("linkedinUrl");
            String githubUrl = request.getParameter("githubUrl");

            Student s = new Student();
            s.setId(existing.getId());

            s.setName(name != null ? name.trim() : existing.getName());
            s.setPhone(phone != null ? phone.trim() : existing.getPhone());
            s.setGender(gender != null && !gender.isEmpty() ? gender : existing.getGender());
            s.setSkills(skills != null ? skills.trim() : existing.getSkills());
            s.setAddress(address != null ? address.trim() : existing.getAddress());
            s.setLinkedinUrl(linkedinUrl != null ? linkedinUrl.trim() : existing.getLinkedinUrl());
            s.setGithubUrl(githubUrl != null ? githubUrl.trim() : existing.getGithubUrl());
            s.setBranch(existing.getBranch());

            s.setPassoutYear(parseInt(passoutYearStr, existing.getPassoutYear()));
            s.setCgpa(parseDouble(cgpaStr, existing.getCgpa()));
            s.setBacklogs(parseInt(backlogsStr, existing.getBacklogs()));
            s.setTenthPercentage(parseDouble(tenthStr, existing.getTenthPercentage()));
            s.setTwelfthPercentage(parseDouble(twelfthStr, existing.getTwelfthPercentage()));

            Date dob = existing.getDob();
            if (dobStr != null && !dobStr.trim().isEmpty()) {
                try {
                    dob = Date.valueOf(dobStr);
                } catch (IllegalArgumentException ex) {
                    System.out.println("Invalid DOB format: " + dobStr);
                }
            }
            s.setDob(dob);
            s.setProfilePhoto(existing.getProfilePhoto());

            // ---------- Handle photo upload (UPDATED LINE HERE) ----------
            Part photoPart = request.getPart("profilePhoto");
            if (photoPart != null && photoPart.getSize() > 0) {
                String contentType = photoPart.getContentType();
                if (contentType != null && contentType.startsWith("image/")) {

                    String uploadPath = getServletContext().getRealPath("") + File.separator + PHOTO_DIR;
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();

                    String original = photoPart.getSubmittedFileName();
                    String ext = ".jpg";
                    if (original != null && original.contains(".")) {
                        ext = original.substring(original.lastIndexOf("."));
                    }

                    // ===== CHANGED AS YOU ASKED - Added System.currentTimeMillis() =====
                    String fileName = "student_" + existing.getId() + "_" + System.currentTimeMillis() + ext;

                    String filePath = uploadPath + File.separator + fileName;
                    photoPart.write(filePath);

                    String relativePath = PHOTO_DIR + File.separator + fileName;
                    s.setProfilePhoto(relativePath);

                    System.out.println("✅ Photo saved: " + relativePath);
                }
            }

            boolean updated = studentDAO.updateStudent(s);

            if (updated) {
                session.setAttribute("successMsg", "Profile updated successfully!");
            } else {
                session.setAttribute("errorMsg", "Failed to update profile. Please try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/student/profile");
    }

    private int parseInt(String s, int fallback) {
        if (s == null || s.trim().isEmpty()) return fallback;
        try { return Integer.parseInt(s.trim()); } catch (NumberFormatException e) { return fallback; }
    }

    private double parseDouble(String s, double fallback) {
        if (s == null || s.trim().isEmpty()) return fallback;
        try { return Double.parseDouble(s.trim()); } catch (NumberFormatException e) { return fallback; }
    }
}