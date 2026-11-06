
package controller;

import dao.CollegeDAO;
import entity.College;
import entity.InviteToken;
import entity.Student;
import entity.User;

import service.InviteTokenService;
import service.OTPService;
import service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/join")
public class JoinController extends HttpServlet {

    private InviteTokenService inviteService;
    private UserService userService;
    private OTPService otpService;
    private CollegeDAO collegeDAO;

    @Override
    public void init() {
        inviteService = new InviteTokenService();
        userService = new UserService();
        otpService = new OTPService();
        collegeDAO = new CollegeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");

        InviteToken invite = inviteService.validateToken(token);

        if (invite == null) {
            request.setAttribute(
                    "error",
                    "Invalid, expired or exhausted invitation link."
            );
            request.getRequestDispatcher("/join.jsp")
                    .forward(request, response);
            return;
        }

        showJoinPage(request, response, invite);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");

        InviteToken invite = inviteService.validateToken(token);

        if (invite == null) {
            request.setAttribute(
                    "error",
                    "Invitation link is invalid or expired."
            );
            request.getRequestDispatcher("/join.jsp")
                    .forward(request, response);
            return;
        }

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");

        String regNo = request.getParameter("regNo");
        String branch = request.getParameter("branch");

        try {

            if (name == null || name.trim().isEmpty()
                    || email == null || email.trim().isEmpty()
                    || password == null || password.length() < 8
                    || phone == null || !phone.matches("[0-9]{10}")) {

                request.setAttribute(
                        "error", "Please enter valid registration details."
                );
                showJoinPage(request, response, invite);
                return;
            }

            email = email.trim().toLowerCase();

            if (userService.isEmailExists(email)) {
                request.setAttribute(
                        "error", "This email is already registered."
                );
                showJoinPage(request, response, invite);
                return;
            }

            User user = new User();

            user.setName(name.trim());
            user.setEmail(email);
            user.setPassword(password);
            user.setPhone(phone);
            user.setCollegeId(invite.getCollegeId());
            user.setActive(false);

            boolean registered = false;

            if ("STUDENT".equals(invite.getRole())) {

                if (regNo == null || regNo.trim().isEmpty()
                        || branch == null || branch.trim().isEmpty()) {

                    request.setAttribute(
                            "error",
                            "Registration number and branch are required."
                    );
                    showJoinPage(request, response, invite);
                    return;
                }

                if (userService.isRegNoExists(regNo.trim())) {
                    request.setAttribute(
                            "error", "Registration number already exists."
                    );
                    showJoinPage(request, response, invite);
                    return;
                }

                user.setRole("STUDENT");

                Student student = new Student();

                student.setName(name.trim());
                student.setEmail(email);
                student.setPhone(phone);
                student.setCollegeId(invite.getCollegeId());
                student.setRegistrationNo(regNo.trim());
                student.setBranch(branch.trim());
                student.setStatus("PENDING");

                registered = userService.registerStudent(user, student);

            } else if ("RECRUITER".equals(invite.getRole())) {

                user.setRole("RECRUITER");

                registered = userService.registerRecruiterFromInvite(
                        user,
                        name.trim(),
                        name.trim(),
                        email,
                        null,
                        phone,
                        invite.getCollegeId()
                );

            } else {

                request.setAttribute(
                        "error", "Invalid invitation role."
                );
                showJoinPage(request, response, invite);
                return;
            }

            if (!registered) {
                request.setAttribute(
                        "error",
                        "Registration failed. Please check your details and try again."
                );
                showJoinPage(request, response, invite);
                return;
            }

            User savedUser = userService.getUserByEmail(email);

            if (savedUser == null) {
                throw new Exception("Could not retrieve registered user.");
            }

            HttpSession session = request.getSession(true);

            session.setAttribute("pendingUserId", savedUser.getId());
            session.setAttribute("pendingEmail", savedUser.getEmail());

            // Used by VerifyOTPController after successful OTP
            session.setAttribute("joinTokenId", invite.getId());

            otpService.createAndSend(
                    savedUser.getId(),
                    savedUser.getEmail()
            );

            response.sendRedirect(
                    request.getContextPath() + "/verify-otp"
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Registration error: " + e.getMessage()
            );

            showJoinPage(request, response, invite);
        }
    }

    private void showJoinPage(
            HttpServletRequest request,
            HttpServletResponse response,
            InviteToken invite)
            throws ServletException, IOException {

        College college =
                collegeDAO.getCollegeById(invite.getCollegeId());

        request.setAttribute("invite", invite);
        request.setAttribute("college", college);

        request.getRequestDispatcher("/join.jsp")
                .forward(request, response);
    }
}
