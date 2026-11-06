package controller.student;

import dao.StudentDAO;
import util.ResumeAnalyzer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;

@WebServlet("/UploadResumeServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 15
)
public class UploadResumeController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String UPLOAD_DIR = "uploads" + File.separator + "resumes";

    private StudentDAO studentDAO;

    @Override
    public void init() {
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer studentId = (Integer) session.getAttribute("studentId");
        if (studentId == null) studentId = (Integer) session.getAttribute("userId");

        try {
            Part filePart = request.getPart("resumeFile");

            if (filePart == null || filePart.getSize() == 0) {
                session.setAttribute("errorMsg", "Please select a PDF file.");
                response.sendRedirect(request.getContextPath() + "/student/resume");
                return;
            }

            // Validate PDF
            String contentType = filePart.getContentType();
            if (contentType == null || !contentType.equals("application/pdf")) {
                session.setAttribute("errorMsg", "Only PDF files are allowed.");
                response.sendRedirect(request.getContextPath() + "/student/resume");
                return;
            }

            // Save file
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            String fileName = studentId + ".pdf";
            String filePath = uploadPath + File.separator + fileName;
            filePart.write(filePath);

            // Update DB with resume path
            String relativePath = UPLOAD_DIR + File.separator + fileName;
            studentDAO.updateResumePath(studentId, relativePath);

            // ---------- ANALYZE RESUME ----------
            ResumeAnalyzer.Result analysis = ResumeAnalyzer.analyze(new File(filePath));

            // Save ATS score
            studentDAO.updateAtsScore(studentId, analysis.totalScore);

            // Set attributes for the resume page
            request.setAttribute("atsScore", analysis.totalScore);
            request.setAttribute("atsDetails", analysis);
            request.setAttribute("suggestions", analysis.suggestions);

            session.setAttribute("successMsg",
                    "Resume uploaded! ATS Score: " + analysis.totalScore + "/100");

            response.sendRedirect(request.getContextPath() + "/student/resume");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Error uploading: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/student/resume");
        }
    }
}