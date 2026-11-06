
package controller;

import dao.UserDAO;
import entity.User;
import service.OTPService;
import service.InviteTokenService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/verify-otp")
public class VerifyOTPController extends HttpServlet {

    private OTPService otpService;
    private UserDAO userDAO;
    private InviteTokenService inviteService;

    @Override
    public void init() {
        otpService = new OTPService();
        userDAO = new UserDAO();
        inviteService = new InviteTokenService();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
                session.getAttribute("pendingUserId") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        request.getRequestDispatcher("/verify-otp.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
                session.getAttribute("pendingUserId") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        Integer userId =
                (Integer) session.getAttribute("pendingUserId");

        String email =
                (String) session.getAttribute("pendingEmail");

        String otp = request.getParameter("otp");

        String flow =
                (String) session.getAttribute("otpFlowType");

        boolean loginFlow = "LOGIN".equals(flow);

        String purpose = loginFlow
                ? OTPService.PURPOSE_LOGIN
                : OTPService.PURPOSE_REGISTER;

        try {

            OTPService.VerifyResult result =
                    otpService.verify(email, otp, purpose);

            if (result == OTPService.VerifyResult.SUCCESS) {

                User user = userDAO.getUserById(userId);

                if (user == null) {
                    request.setAttribute(
                            "error", "User account not found."
                    );

                    request.getRequestDispatcher("/verify-otp.jsp")
                            .forward(request, response);
                    return;
                }

                // LOGIN OTP FLOW
                if (loginFlow) {

                    if (!user.isActive()) {
                        request.setAttribute(
                                "error",
                                "Your account is waiting for admin approval."
                        );

                        session.removeAttribute("pendingUserId");
                        session.removeAttribute("pendingEmail");

                        request.getRequestDispatcher("/login.jsp")
                                .forward(request, response);
                        return;
                    }

                    session.removeAttribute("pendingUserId");
                    session.removeAttribute("pendingEmail");
                    session.removeAttribute("otpFlowType");

                    session.setAttribute("userId", user.getId());
                    session.setAttribute("userEmail", user.getEmail());
                    session.setAttribute("userRole", user.getRole());
                    session.setAttribute("role", user.getRole());
                    session.setAttribute("userName", user.getName());
                    session.setAttribute("collegeId", user.getCollegeId());

                    redirectByRole(user, request, response);
                    return;
                }

                // REGISTRATION OTP FLOW
                userDAO.markEmailVerified(userId);

                // Consume invitation only after OTP verification
                Object tokenObject =
                        session.getAttribute("joinTokenId");

                if (tokenObject instanceof Number) {
                    long tokenId =
                            ((Number) tokenObject).longValue();

                    inviteService.incrementUsed(tokenId);
                }

                session.removeAttribute("pendingUserId");
                session.removeAttribute("pendingEmail");
                session.removeAttribute("otpFlowType");
                session.removeAttribute("joinTokenId");

                // IMPORTANT:
                // Do not activate user here.
                // College Admin must approve first.

                String message;

                if ("STUDENT".equals(user.getRole())) {

                    message =
                            "Email verified successfully! " +
                                    "Your registration is waiting for College Admin approval.";

                } else if ("RECRUITER".equals(user.getRole())) {

                    message =
                            "Email verified successfully! " +
                                    "Your recruiter account is waiting for College Admin approval.";

                } else {

                    message =
                            "Email verified successfully! " +
                                    "Your account is waiting for Super Admin approval.";
                }

                request.setAttribute("success", message);

                request.getRequestDispatcher("/login.jsp")
                        .forward(request, response);

                return;
            }

            if (result == OTPService.VerifyResult.WRONG_OTP) {
                request.setAttribute(
                        "error", "Incorrect OTP. Please try again."
                );
            }

            else if (result == OTPService.VerifyResult.EXPIRED) {
                request.setAttribute(
                        "error", "OTP expired. Please request a new one."
                );
            }

            else if (result == OTPService.VerifyResult.TOO_MANY_ATTEMPTS) {
                request.setAttribute(
                        "error", "Too many wrong attempts. Please resend OTP."
                );
            }

            else {
                request.setAttribute(
                        "error", "No active OTP found. Please resend."
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error", "Verification failed: " + e.getMessage()
            );
        }

        request.getRequestDispatcher("/verify-otp.jsp")
                .forward(request, response);
    }

    private void redirectByRole(
            User user,
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String path;

        switch (user.getRole()) {
            case "SUPER_ADMIN":
                path = "/superadmin/dashboard";
                break;

            case "COLLEGE_ADMIN":
                path = "/collegeadmin/dashboard";
                break;

            case "RECRUITER":
                path = "/recruiter/dashboard";
                break;

            default:
                path = "/student/dashboard";
                break;
        }

        response.sendRedirect(request.getContextPath() + path);
    }
}
