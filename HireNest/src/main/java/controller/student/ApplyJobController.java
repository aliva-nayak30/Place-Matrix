package controller.student;

import dao.StudentDashboardDAO;
import dao.StudentDAO;
import entity.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/student/apply")
public class ApplyJobController extends HttpServlet {
    private StudentDashboardDAO dashDAO = new StudentDashboardDAO();
    private StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String companyIdStr = request.getParameter("companyId");
        if (companyIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/student/eligible-companies");
            return;
        }

        int jobId = Integer.parseInt(companyIdStr);
        Student student = studentDAO.getStudentByUserId(userId);

        if (student != null) {
            int appId = dashDAO.applyToCompany(student.getId(), jobId);

            if (appId > 0) {
                System.out.println("✅ Application successful! App ID: " + appId);
                session.setAttribute("successMsg", "Successfully applied for the job!");
            } else {
                System.out.println("❌ Application failed. Check DB errors.");
                session.setAttribute("errorMsg", "You have already applied for this job or an error occurred.");
            }
        }

        // Redirect to 'My Applications' so they can see it worked
        response.sendRedirect(request.getContextPath() + "/student/my-applications");
    }
}