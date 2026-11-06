package controller;

import dao.OtpDAO;
import entity.OtpRecord;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;

@WebServlet("/verify-reset-otp")
public class VerifyResetOtpServlet extends HttpServlet {

    private static final int MAX_ATTEMPTS = 5;
    private final OtpDAO otpDAO = new OtpDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (req.getSession().getAttribute("resetEmail") == null) {
            resp.sendRedirect(req.getContextPath() + "/forgot-password");
            return;
        }
        req.getRequestDispatcher("/verify-reset-otp.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        String email = (session == null) ? null : (String) session.getAttribute("resetEmail");
        if (email == null) {
            resp.sendRedirect(req.getContextPath() + "/forgot-password");
            return;
        }

        String otp = req.getParameter("otp");
        if (otp == null || otp.trim().length() != 6) {
            req.setAttribute("error", "Please enter the 6-digit code.");
            req.getRequestDispatcher("/verify-reset-otp.jsp").forward(req, resp);
            return;
        }
        otp = otp.trim();

        try {
            Optional<OtpRecord> recOpt = otpDAO.findLatestValid(email, "RESET_PASSWORD");
            if (recOpt.isEmpty()) {
                req.setAttribute("error", "Code expired or not found. Please resend.");
                req.getRequestDispatcher("/verify-reset-otp.jsp").forward(req, resp);
                return;
            }
            OtpRecord rec = recOpt.get();

            if (rec.getAttempts() >= MAX_ATTEMPTS) {
                req.setAttribute("error", "Too many attempts. Please resend the code.");
                req.getRequestDispatcher("/verify-reset-otp.jsp").forward(req, resp);
                return;
            }

            if (!BCrypt.checkpw(otp, rec.getOtpHash())) {
                otpDAO.incrementAttempts(rec.getId());
                int remaining = MAX_ATTEMPTS - (rec.getAttempts() + 1);
                req.setAttribute("error",
                        "Incorrect code. " + Math.max(remaining, 0) + " attempts left.");
                req.getRequestDispatcher("/verify-reset-otp.jsp").forward(req, resp);
                return;
            }

            otpDAO.consume(rec.getId());
            session.setAttribute("resetVerified", Boolean.TRUE);
            resp.sendRedirect(req.getContextPath() + "/reset-password");

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}