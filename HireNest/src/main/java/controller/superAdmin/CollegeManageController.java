package controller.superAdmin;

import dao.CollegeDAO;
import entity.College;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(urlPatterns = {"/superadmin/colleges", "/superadmin/toggle-college"})
public class CollegeManageController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(CollegeManageController.class.getName());
    private CollegeDAO dao;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            dao = new CollegeDAO();
            LOGGER.info("CollegeManageController initialized successfully.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "ERROR IN INIT: " + e.getMessage(), e);
            throw new ServletException("Failed to init CollegeManageController", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<College> colleges = dao.getAllColleges(); // REAL DATA
            request.setAttribute("colleges", colleges);
            request.getRequestDispatcher("/superadmin/colleges.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Database error in doGet", e);
            response.sendError(500, "Database error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            if ("/superadmin/toggle-college".equals(request.getServletPath())) {
                int collegeId = Integer.parseInt(request.getParameter("collegeId"));
                boolean active = Boolean.parseBoolean(request.getParameter("active"));
                dao.setActive(collegeId, active);
                LOGGER.info("Toggled college ID: " + collegeId + " to active: " + active);
            }
            response.sendRedirect(request.getContextPath() + "/superadmin/colleges");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in toggle", e);
            response.sendError(500, "Error: " + e.getMessage());
        }
    }
}