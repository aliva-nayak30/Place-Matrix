package controller;

import entity.Student;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import service.UserService;

import java.io.IOException;

@WebServlet("/register/student")
public class RegisterStudentController extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/register-student.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email = trim(req.getParameter("email"));
        String password = req.getParameter("password");
        String name = trim(req.getParameter("name"));
        String regNo = trim(req.getParameter("registrationNo"));

        if (email.isEmpty() || name.isEmpty() || regNo.isEmpty()
                || password == null || password.length() < 8) {
            fail(req, resp, "Fill in all required fields. Password needs at least 8 characters.");
            return;
        }

        Student student = new Student();
        try {
            student.setCollegeId(Integer.parseInt(req.getParameter("collegeId")));
            student.setCgpa(Double.parseDouble(req.getParameter("cgpa")));
            student.setPassingYear(Integer.parseInt(req.getParameter("passingYear")));
            student.setBacklogs(Integer.parseInt(req.getParameter("backlogs")));
        } catch (NumberFormatException | NullPointerException e) {
            fail(req, resp, "College, CGPA, passing year and backlogs must be valid numbers.");
            return;
        }
        student.setName(name);
        student.setRegistrationNo(regNo);
        student.setPhone(trim(req.getParameter("phone")));
        student.setDepartment(trim(req.getParameter("department")));

        User user = new User(email, password, "STUDENT");
        if (userService.registerStudent(user, student)) {
            resp.sendRedirect(req.getContextPath() + "/login?registered=1");
        } else {
            fail(req, resp, "That email or registration number is already registered.");
        }
    }

    private void fail(HttpServletRequest req, HttpServletResponse resp, String msg)
            throws ServletException, IOException {
        req.setAttribute("error", msg);
        req.getRequestDispatcher("/register-student.jsp").forward(req, resp);
    }

    private String trim(String s) { return s == null ? "" : s.trim(); }
}