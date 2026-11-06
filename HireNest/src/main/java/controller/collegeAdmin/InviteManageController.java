package controller.collegeAdmin;

import entity.InviteToken;
import service.InviteTokenService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/collegeadmin/invites")
public class InviteManageController extends HttpServlet {
    private InviteTokenService service = new InviteTokenService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"COLLEGE_ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer collegeId = (Integer) session.getAttribute("collegeId");

        try {
            List<InviteToken> allInvites = service.listByCollege(collegeId);

            List<InviteToken> studentTokens = allInvites.stream()
                    .filter(t -> "STUDENT".equals(t.getRole()))
                    .collect(Collectors.toList());

            List<InviteToken> recruiterTokens = allInvites.stream()
                    .filter(t -> "RECRUITER".equals(t.getRole()))
                    .collect(Collectors.toList());

            request.setAttribute("studentTokens", studentTokens);
            request.setAttribute("recruiterTokens", recruiterTokens);

        } catch (Exception e) {
            System.out.println("❌ Error fetching invites: " + e.getMessage());
            e.printStackTrace();
        }

        request.getRequestDispatcher("/invite-manage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"COLLEGE_ADMIN".equals(session.getAttribute("role"))) return;

        Integer collegeId = (Integer) session.getAttribute("collegeId");
        Integer userId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");

        try {
            if ("create".equals(action)) {
                String role = request.getParameter("role");
                int maxUses = Integer.parseInt(request.getParameter("maxUses"));
                int daysValid = Integer.parseInt(request.getParameter("daysValid"));

                service.createInvite(collegeId, role, maxUses, daysValid, userId);
                session.setAttribute("successMsg", "Invite link generated successfully!");

            } else if ("deactivate".equals(action)) {
                long id = Long.parseLong(request.getParameter("id"));
                service.deactivate(id);
                session.setAttribute("successMsg", "Invite link deactivated.");
            }
        } catch (Exception e) {
            System.out.println("❌ ERROR GENERATING TOKEN: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMsg", "Error generating token: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/collegeadmin/invites");
    }
}