package controller.student;

import dao.StudentDashboardDAO;
import dao.StudentDAO;
import entity.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/student/eligible-companies")
public class StudentCompanyController extends HttpServlet {
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

        if (student != null) {
            // Fetch eligible companies based on the student's actual profile
            request.setAttribute("companies", dashDAO.getEligibleCompanies(collegeId, student.getCgpa(), student.getBacklogs(), student.getBranch()));
            request.setAttribute("appliedIds", dashDAO.getAppliedCompanyIds(student.getId()));
        }

        request.getRequestDispatcher("/student/eligible-companies.jsp").forward(request, response);
    }
}