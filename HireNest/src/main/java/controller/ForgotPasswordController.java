package controller;

import dao.UserDAO;
import entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.OTPService;
import java.io.IOException;
import java.sql.SQLException;
import java.util.regex.Pattern;

/**
 * Handles the "Forgot Password" entry point.
 *
 *   GET  /forgot-password  → shows forgot-password.jsp
 *   POST /forgot-password  → validates email, sends OTP, redirects to /verify-reset-otp
 *
 * Uses OTPService.sendResetOtp(...) which internally:
 *   - generates a 6-digit OTP
 *   - BCrypt-hashes it
 *   - stores it in the email_otp table (purpose='RESET_PASSWORD')
 *   - sends the email via service.EmailService
 */
@WebServlet("/forgot-password")
public class ForgotPasswordController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final Pattern EMAIL_RE =
            Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private UserDAO userDAO;
    private OTPService otpService;

    @Override
    public void init() {
        userDAO = new UserDAO();
        otpService = new OTPService();
    }

    // =========================================================
    // GET — show form
    // =========================================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }

    // =========================================================
    // POST — validate + send OTP + redirect
    // =========================================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        email = (email == null) ? "" : email.trim().toLowerCase();

        // ---- Validate email format ----
        if (!EMAIL_RE.matcher(email).matches()) {
            request.setAttribute("error", "Please enter a valid email address.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }

        try {
            User user = userDAO.findByEmail(email);

            // Only send OTP if the account exists.
            // We ALWAYS redirect to the same page afterwards — this prevents
            // attackers from discovering which emails are registered.
            if (user != null) {
                otpService.sendResetOtp(email);
            }

            // Store in session so /verify-reset-otp knows which email to check
            HttpSession session = request.getSession(true);
            session.setAttribute("resetEmail", email);

            response.sendRedirect(request.getContextPath() + "/verify-reset-otp");

        } catch (IllegalStateException e) {
            // Thrown by OTPService when rate limit exceeded
            request.setAttribute("error", e.getMessage());
            request.setAttribute("email", email);
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong. Please try again.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);

        } catch (RuntimeException e) {
            // Thrown by EmailService when SMTP fails
            e.printStackTrace();
            request.setAttribute("error",
                    "Could not send the email right now. Please try again in a moment.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
        }
    }
}