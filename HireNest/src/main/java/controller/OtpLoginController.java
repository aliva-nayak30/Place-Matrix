package controller;

import dao.UserDAO;
import entity.User;
import service.OTPService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login-otp")
public class OtpLoginController extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private OTPService otpService = new OTPService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");

        try {
            User user = userDAO.findByEmail(email);
            if (user == null) {
                request.setAttribute("error", "No account found with this email.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("pendingUserId", user.getId());
            session.setAttribute("pendingEmail", user.getEmail());
            session.setAttribute("otpFlowType", "LOGIN");

            otpService.sendLoginOtp(user.getEmail());

            response.sendRedirect(request.getContextPath() + "/verify-otp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error sending OTP. Please try again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}