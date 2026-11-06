package controller;

import dao.CollegeDAO;
import dao.UserDAO;
import entity.College;
import entity.User;
import entity.Student;
import service.UserService; // 🔥 REQUIRED IMPORT
import service.OTPService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/register")
public class RegisterController extends HttpServlet {
    private UserService userService;
    private CollegeDAO collegeDAO;
    private OTPService otpService;
    private UserDAO userDAO;

    @Override
    public void init() {
        userService = new UserService();
        collegeDAO = new CollegeDAO();
        otpService = new OTPService();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<College> colleges = collegeDAO.getApprovedColleges();
        request.setAttribute("colleges", colleges);
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String role = request.getParameter("role");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String collegeIdStr = request.getParameter("collegeId");
        String phone = request.getParameter("phone");

        String regNo = request.getParameter("regNo");
        String branch = request.getParameter("branch");
        String passoutYearStr = request.getParameter("passoutYear");
        String gender = request.getParameter("gender");
        String dobStr = request.getParameter("dob");
        String linkedinUrl = request.getParameter("linkedinUrl");
        String githubUrl = request.getParameter("githubUrl");

        String collegeName = request.getParameter("collegeName");
        String collegeCode = request.getParameter("collegeCode");
        String collegeLocation = request.getParameter("collegeLocation");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty() || name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "All required fields must be filled!");
            loadCollegesAndForward(request, response, role);
            return;
        }

        int collegeId = 0;
        if (collegeIdStr != null && !collegeIdStr.trim().isEmpty()) {
            try { collegeId = Integer.parseInt(collegeIdStr); }
            catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid college selection!");
                loadCollegesAndForward(request, response, role);
                return;
            }
        }

        try {
            if (userService.isEmailExists(email)) {
                request.setAttribute("error", "Email already registered! Try logging in.");
                loadCollegesAndForward(request, response, role);
                return;
            }

            if ("STUDENT".equals(role)) {
                if (regNo == null || regNo.trim().isEmpty() || branch == null || branch.trim().isEmpty()) {
                    request.setAttribute("error", "Registration No and Branch are required!");
                    loadCollegesAndForward(request, response, role);
                    return;
                }
                if (userService.isRegNoExists(regNo)) {
                    request.setAttribute("error", "Registration number already exists!");
                    loadCollegesAndForward(request, response, role);
                    return;
                }

                User user = new User();
                user.setName(name); user.setEmail(email); user.setPassword(password);
                user.setPhone(phone); user.setRole("STUDENT");
                user.setCollegeId(collegeId); user.setActive(false);

                Student student = new Student();
                student.setName(name); student.setEmail(email);
                student.setRegistrationNo(regNo); student.setBranch(branch);
                student.setPhone(phone); student.setCollegeId(collegeId);
                student.setStatus("PENDING");

                if (passoutYearStr != null && !passoutYearStr.trim().isEmpty()) {
                    try { student.setPassoutYear(Integer.parseInt(passoutYearStr)); } catch (NumberFormatException ignored) {}
                }
                if (gender != null && !gender.trim().isEmpty()) student.setGender(gender);
                if (dobStr != null && !dobStr.trim().isEmpty()) {
                    try { student.setDob(Date.valueOf(dobStr)); } catch (IllegalArgumentException ignored) {}
                }
                if (linkedinUrl != null && !linkedinUrl.trim().isEmpty()) student.setLinkedinUrl(linkedinUrl);
                if (githubUrl != null && !githubUrl.trim().isEmpty()) student.setGithubUrl(githubUrl);

                boolean registered = userService.registerStudent(user, student);

                if (registered) {
                    redirectToOTP(request, response, email);
                } else {
                    try { User ghost = userDAO.findByEmail(email); if (ghost != null) userDAO.deleteUser(ghost.getId()); } catch (Exception ignored) {}
                    request.setAttribute("error", "Registration failed! Please try again.");
                    loadCollegesAndForward(request, response, role);
                }
            }
            else if ("RECRUITER".equals(role)) {
                User user = new User();
                user.setName(name); user.setEmail(email); user.setPassword(password);
                user.setPhone(phone); user.setRole("RECRUITER");
                user.setCollegeId(collegeId); user.setActive(false);

                boolean registered = userService.registerRecruiter(user, name, phone, collegeId);

                if (registered) {
                    redirectToOTP(request, response, email);
                } else {
                    request.setAttribute("error", "Registration failed! Please try again.");
                    loadCollegesAndForward(request, response, role);
                }
            }
            else if ("COLLEGE_ADMIN".equals(role)) {
                if (collegeName == null || collegeName.trim().isEmpty() || collegeCode == null || collegeCode.trim().isEmpty()) {
                    request.setAttribute("error", "College Name and Code are required!");
                    loadCollegesAndForward(request, response, role);
                    return;
                }

                User user = new User();
                user.setName(name); user.setEmail(email); user.setPassword(password); user.setPhone(phone);

                boolean registered = userService.registerCollegeAdminWithCollege(
                        user, collegeName.trim(), collegeCode.trim().toUpperCase(),
                        collegeLocation != null ? collegeLocation.trim() : ""
                );

                if (registered) {
                    redirectToOTP(request, response, email);
                } else {
                    request.setAttribute("error", "Registration failed! Please check if the email or college code already exists.");
                    loadCollegesAndForward(request, response, role);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            loadCollegesAndForward(request, response, role);
        }
    }

    private void loadCollegesAndForward(HttpServletRequest request, HttpServletResponse response, String role)
            throws ServletException, IOException {
        List<College> colleges = collegeDAO.getApprovedColleges();
        request.setAttribute("colleges", colleges);
        if (role != null) request.setAttribute("selectedRole", role);
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    private void redirectToOTP(HttpServletRequest request, HttpServletResponse response, String email)
            throws IOException, SQLException {
        User user = userService.getUserByEmail(email);
        if (user == null) {
            request.setAttribute("error", "Registration succeeded but user lookup failed.");
            try { loadCollegesAndForward(request, response, null); } catch (ServletException e) { throw new RuntimeException(e); }
            return;
        }
        HttpSession session = request.getSession();
        session.setAttribute("pendingUserId", user.getId());
        session.setAttribute("pendingEmail", user.getEmail());
        otpService.createAndSend(user.getId(), user.getEmail());
        response.sendRedirect("verify-otp");
    }
}