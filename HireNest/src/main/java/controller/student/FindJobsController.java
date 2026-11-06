package controller.student;

import dao.ApplicationDAO;
import dao.JobDAO;
import entity.Job;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Set;

@WebServlet("/student/find-jobs")
public class FindJobsController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private JobDAO jobDAO;
    private ApplicationDAO applicationDAO;

    @Override
    public void init() {
        jobDAO = new JobDAO();
        applicationDAO = new ApplicationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer studentId = (Integer) session.getAttribute("studentId");
        if (studentId == null) studentId = (Integer) session.getAttribute("userId");

        List<Job> jobs = jobDAO.getActiveJobs();
        Set<Integer> appliedJobIds = applicationDAO.getAppliedJobIds(studentId);

        request.setAttribute("jobs", jobs);
        request.setAttribute("appliedJobIds", appliedJobIds);

        request.getRequestDispatcher("/student/find-jobs.jsp").forward(request, response);
    }
}