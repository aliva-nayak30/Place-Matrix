package controller.student;

import dao.StudentDAO;
import entity.Student;
import util.ResumeAnalyzer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;

@WebServlet("/student/resume")
public class ResumeController extends HttpServlet {
    private static final long serialVersionUID = 1L;

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

        Integer studentId = (Integer) session.getAttribute("studentId");
        if (studentId == null) studentId = (Integer) session.getAttribute("userId");

        Student student = studentDAO.getStudentById(studentId);
        request.setAttribute("student", student);

        // Get ATS score from DB
        int atsScore = studentDAO.getAtsScore(studentId);
        request.setAttribute("atsScore", atsScore);

        // If resume exists, re-analyze to show suggestions
        if (student != null && student.getResumePath() != null
                && !student.getResumePath().isEmpty()) {
            try {
                String realPath = getServletContext().getRealPath("")
                        + File.separator + student.getResumePath();
                File pdf = new File(realPath);
                if (pdf.exists()) {
                    ResumeAnalyzer.Result analysis = ResumeAnalyzer.analyze(pdf);
                    request.setAttribute("atsDetails", analysis);
                    request.setAttribute("suggestions", analysis.suggestions);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        request.getRequestDispatcher("/student/resume.jsp").forward(request, response);
    }
}