
package controller.collegeAdmin;

import dao.CollegeRecruiterDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Map;

@WebServlet("/collegeadmin/recruiters")
public class CollegeManageRecruiterController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private CollegeRecruiterDAO dao;

    @Override
    public void init() {
        dao = new CollegeRecruiterDAO();
    }


    // Display recruiter list
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check login and role
        if (session == null ||
                !"COLLEGE_ADMIN".equals(session.getAttribute("role"))) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        Integer collegeId =
                (Integer) session.getAttribute("collegeId");

        if (collegeId == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        // Optional status filter
        String filter = request.getParameter("status");

        if (filter != null && !filter.trim().isEmpty()) {

            filter = filter.trim().toUpperCase();

            if (!filter.equals("PENDING")
                    && !filter.equals("APPROVED")
                    && !filter.equals("REJECTED")) {

                filter = "";
            }
        }

        // Get recruiters
        request.setAttribute(
                "recruiters",
                dao.getRecruiters(collegeId, filter)
        );

        // Get status counts
        Map<String, Integer> counts =
                dao.getStatusCounts(collegeId);

        request.setAttribute("statusCounts", counts);
        request.setAttribute("filter", filter != null ? filter : "");

        // Success and error messages are read by JSP
        request.getRequestDispatcher(
                "/collegeadmin/recruiters.jsp"
        ).forward(request, response);
    }


    // Handle Approve / Reject
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
                !"COLLEGE_ADMIN".equals(session.getAttribute("role"))) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        Integer collegeId =
                (Integer) session.getAttribute("collegeId");

        if (collegeId == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        String action = request.getParameter("action");

        try {

            int recruiterId = Integer.parseInt(
                    request.getParameter("id")
            );

            String status;

            if ("approve".equals(action)) {
                status = "APPROVED";
            }
            else if ("reject".equals(action)) {
                status = "REJECTED";
            }
            else {
                session.setAttribute(
                        "errorMsg",
                        "Invalid recruiter action."
                );

                response.sendRedirect(
                        request.getContextPath() +
                                "/collegeadmin/recruiters"
                );
                return;
            }

            boolean success = dao.updateRecruiterStatus(
                    recruiterId,
                    collegeId,
                    status
            );

            if (success) {

                session.setAttribute(
                        "successMsg",
                        "Recruiter successfully " +
                                status.toLowerCase() + "."
                );

            } else {

                session.setAttribute(
                        "errorMsg",
                        "Unable to update recruiter. " +
                                "Check email verification and recruiter status."
                );
            }

        } catch (NumberFormatException e) {

            session.setAttribute(
                    "errorMsg",
                    "Invalid recruiter ID."
            );

        } catch (Exception e) {

            e.printStackTrace();

            session.setAttribute(
                    "errorMsg",
                    "Something went wrong: " + e.getMessage()
            );
        }

        response.sendRedirect(
                request.getContextPath() +
                        "/collegeadmin/recruiters"
        );
    }
}
