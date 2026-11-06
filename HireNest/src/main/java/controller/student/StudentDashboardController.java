package controller.student;

import dao.StudentDAO;
import dao.StudentDashboardDAO;
import entity.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet("/student/dashboard")
public class StudentDashboardController extends HttpServlet {
    private StudentDashboardDAO dashDAO = new StudentDashboardDAO();
    private StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || !"STUDENT".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        Integer collegeId = (Integer) session.getAttribute("collegeId");

        Student student = studentDAO.getStudentByUserId(userId);
        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Profile+not+found");
            return;
        }

        // 1. Profile Completion
        int profileCompletion = studentDAO.calculateProfileCompletion(student);
        request.setAttribute("profileCompletion", profileCompletion);

        // 2. Readiness Score Calculation
        int readinessScore = 0;
        readinessScore += (int) ((student.getCgpa() / 10.0) * 30);

        if (student.getSkills() != null && !student.getSkills().trim().isEmpty()) {
            int skillCount = student.getSkills().split(",").length;
            readinessScore += Math.min(30, skillCount * 10);
        }

        if (student.getTenthPercentage() > 60) readinessScore += 10;
        if (student.getTwelfthPercentage() > 60) readinessScore += 10;

        readinessScore += (profileCompletion * 20 / 100);

        if (readinessScore > 100) readinessScore = 100;
        request.setAttribute("readinessScore", readinessScore);

        // 3. Stats & Applications
        Map<String, Integer> stats = dashDAO.getDashboardStats(student.getId());
        request.setAttribute("appliedCount", stats.get("appliedCount"));
        request.setAttribute("shortlistedCount", stats.get("shortlistedCount"));
        request.setAttribute("recentApps", dashDAO.getRecentApplications(student.getId()));

        // 4. Eligible Companies
        request.setAttribute("eligibleCompanies",
                dashDAO.getEligibleCompanies(collegeId, student.getCgpa(), student.getBacklogs(), student.getBranch()));
        request.setAttribute("appliedIds", dashDAO.getAppliedCompanyIds(student.getId()));

        request.getRequestDispatcher("/student/dashboard.jsp").forward(request, response);
    }
}