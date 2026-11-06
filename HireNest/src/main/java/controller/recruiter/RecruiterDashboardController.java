package controller.recruiter;

import dao.RecruiterDashboardDAO;
import util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/recruiter/dashboard")
public class RecruiterDashboardController extends HttpServlet {
    private RecruiterDashboardDAO dao = new RecruiterDashboardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"RECRUITER".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int recruiterId = (int) session.getAttribute("userId");
        String page = request.getParameter("page");
        if (page == null) page = "dashboard";

        try {
            request.setAttribute("notifications", dao.getNotifications(recruiterId));
            request.setAttribute("unreadCount", dao.getUnreadCount(recruiterId));

            if ("dashboard".equals(page)) {
                dao.markNotificationsAsRead(recruiterId);
            }

            switch (page) {
                case "post-job":
                    request.getRequestDispatcher("/recruiter/post-job.jsp").forward(request, response);
                    break;
                case "my-jobs":
                    request.setAttribute("jobs", dao.getJobsByRecruiter(recruiterId));
                    request.getRequestDispatcher("/recruiter/my-jobs.jsp").forward(request, response);
                    break;
                case "applications":
                    String search = request.getParameter("search");
                    String branch = request.getParameter("branch");
                    String minCgpa = request.getParameter("minCgpa");
                    String jobId = request.getParameter("jobId");
                    String status = request.getParameter("status");

                    request.setAttribute("applications", dao.getFilteredApplications(recruiterId, search, branch, minCgpa, jobId, status));
                    request.setAttribute("myJobs", dao.getJobsByRecruiter(recruiterId));
                    request.setAttribute("search", search);
                    request.setAttribute("branch", branch);
                    request.setAttribute("minCgpa", minCgpa);
                    request.setAttribute("jobId", jobId);
                    request.setAttribute("status", status);

                    request.getRequestDispatcher("/recruiter/applications.jsp").forward(request, response);
                    break;
                case "profile":
                    request.setAttribute("profile", dao.getRecruiterProfile(recruiterId));
                    request.getRequestDispatcher("/recruiter/company-profile.jsp").forward(request, response);
                    break;
                default:
                    request.setAttribute("stats", dao.getStats(recruiterId));
                    request.setAttribute("recentApps", dao.getRecentApplications(recruiterId));
                    request.setAttribute("upcomingInterviews", dao.getUpcomingInterviews(recruiterId));
                    request.getRequestDispatcher("/recruiter/dashboard.jsp").forward(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"RECRUITER".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int recruiterId = (int) session.getAttribute("userId");
        Integer collegeIdObj = (Integer) session.getAttribute("collegeId");
        int collegeId = (collegeIdObj == null ? 0 : collegeIdObj);
        String action = request.getParameter("action");

        try {
            if ("postJob".equals(action)) {
                try (Connection conn = DBConnection.getConnection()) {
                    String sql = "INSERT INTO jobs (recruiter_id, college_id, title, job_type, location, salary, skills, eligible_branches, last_date, description) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setInt(1, recruiterId); ps.setInt(2, collegeId);
                        ps.setString(3, request.getParameter("title"));
                        ps.setString(4, request.getParameter("jobType"));
                        ps.setString(5, request.getParameter("location"));
                        ps.setDouble(6, Double.parseDouble(request.getParameter("salary")));
                        ps.setString(7, request.getParameter("skills"));
                        ps.setString(8, request.getParameter("eligibleBranches"));
                        ps.setDate(9, java.sql.Date.valueOf(request.getParameter("lastDate")));
                        ps.setString(10, request.getParameter("description"));
                        ps.executeUpdate();
                    }
                }
                response.sendRedirect(request.getContextPath() + "/recruiter/dashboard?page=my-jobs");
            }
            else if ("updateStatus".equals(action)) {
                int appId = Integer.parseInt(request.getParameter("appId"));
                dao.updateApplicationStatus(appId, request.getParameter("status"));
                response.sendRedirect(request.getContextPath() + "/recruiter/dashboard?page=applications");
            }
            else if ("bulkUpdate".equals(action)) {
                String[] appIds = request.getParameterValues("appIds");
                String bulkStatus = request.getParameter("bulkStatus");

                if (appIds != null && bulkStatus != null && !bulkStatus.isEmpty()) {
                    for (String appIdStr : appIds) {
                        dao.updateApplicationStatus(Integer.parseInt(appIdStr), bulkStatus);
                    }
                    session.setAttribute("successMsg", appIds.length + " application(s) updated to " + bulkStatus);
                } else {
                    session.setAttribute("errorMsg", "No students selected.");
                }
                response.sendRedirect(request.getContextPath() + "/recruiter/dashboard?page=applications");
            }
            else if ("updateProfile".equals(action)) {
                String companyName = request.getParameter("companyName");
                String website = request.getParameter("website");
                String about = request.getParameter("about");
                String logoUrl = request.getParameter("logoUrl");
                dao.updateRecruiterProfile(recruiterId, companyName, website, about, logoUrl);
                session.setAttribute("successMsg", "Profile updated successfully!");
                response.sendRedirect(request.getContextPath() + "/recruiter/dashboard?page=profile");
            }
            else if ("scheduleInterview".equals(action)) {
                int appId = Integer.parseInt(request.getParameter("appId"));
                String date = request.getParameter("date");
                String time = request.getParameter("time");
                String mode = request.getParameter("mode");
                String link = request.getParameter("link");
                dao.scheduleInterview(appId, date, time, mode, link);
                dao.updateApplicationStatus(appId, "SHORTLISTED");
                session.setAttribute("successMsg", "Interview scheduled successfully!");
                response.sendRedirect(request.getContextPath() + "/recruiter/dashboard?page=applications");
            }
            else if ("markRead".equals(action)) {
                dao.markNotificationsAsRead(recruiterId);
                response.sendRedirect(request.getContextPath() + "/recruiter/dashboard");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/recruiter/dashboard");
        }
    }
}