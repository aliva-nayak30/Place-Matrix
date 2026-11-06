package controller.student;

import dao.StudentDashboardDAO;
import dao.StudentDAO;
import entity.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/student/company-jobs")
public class CompanyJobsController extends HttpServlet {
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
        String recruiterIdStr = request.getParameter("recruiterId");
        String companyName = request.getParameter("companyName");

        if (recruiterIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/student/eligible-companies");
            return;
        }

        int recruiterId = Integer.parseInt(recruiterIdStr);
        Student student = studentDAO.getStudentByUserId(userId);

        if (student != null) {
            List<Map<String, Object>> jobs = dashDAO.getJobsByRecruiter(recruiterId, collegeId);
            java.util.Set<Integer> appliedJobs = dashDAO.getAppliedCompanyIds(student.getId());

            request.setAttribute("jobs", jobs);
            request.setAttribute("appliedJobs", appliedJobs);
            request.setAttribute("companyName", companyName != null ? companyName : "Company");
        }

        request.getRequestDispatcher("/student/company-jobs.jsp").forward(request, response);
    }
}