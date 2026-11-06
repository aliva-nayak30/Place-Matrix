package service;

import dao.OtpDAO;
import dao.UserDAO;
import entity.OtpRecord;
import entity.User;
import util.PasswordUtil;
import service.UserService;
import java.security.SecureRandom;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.Optional;

public class OTPService {

    public enum VerifyResult {
        SUCCESS, WRONG_OTP, EXPIRED, TOO_MANY_ATTEMPTS, NO_ACTIVE_OTP
    }

    public static final String PURPOSE_REGISTER = "REGISTER";
    public static final String PURPOSE_RESET    = "RESET_PASSWORD";
    public static final String PURPOSE_LOGIN    = "LOGIN";

    public static final int OTP_TTL_MINUTES      = 10;
    public static final int MAX_ATTEMPTS         = 5;
    public static final int MAX_RESENDS_PER_HOUR = 3;

    private final OtpDAO otpDAO;
    private final UserDAO userDAO;
    private final EmailService emailService;
    private final SecureRandom random;

    public OTPService() {
        this.otpDAO      = new OtpDAO();
        this.userDAO     = new UserDAO();
        this.emailService = new EmailService();
        this.random      = new SecureRandom();
    }

    public void generateAndSend(String email, String purpose) throws SQLException {
        int recentCount = otpDAO.countRecentOtps(email, purpose, 60);
        if (recentCount >= MAX_RESENDS_PER_HOUR) {
            throw new IllegalStateException("Too many OTP requests. Please try again in 1 hour.");
        }
        String otp = generateCode();
        String otpHash = PasswordUtil.hashOtp(otp);
        otpDAO.invalidatePrevious(email, purpose);
        otpDAO.saveOtp(email, otpHash, purpose, OTP_TTL_MINUTES);
        emailService.sendOtp(email, otp, purpose);
    }

    public void sendOtp(String email, String purpose) throws SQLException {
        generateAndSend(email, purpose);
    }
    public void sendRegistrationOtp(String email) throws SQLException {
        generateAndSend(email, PURPOSE_REGISTER);
    }
    public void sendResetOtp(String email) throws SQLException {
        generateAndSend(email, PURPOSE_RESET);
    }
    public void sendLoginOtp(String email) throws SQLException {
        generateAndSend(email, PURPOSE_LOGIN);
    }
    public void createAndSend(int userId, String email) throws SQLException {
        generateAndSend(email, PURPOSE_REGISTER);
    }
    public void createAndSend(int userId, String email, String purpose) throws SQLException {
        generateAndSend(email, purpose);
    }

    public boolean canResend(Integer resendCount) {
        if (resendCount == null) return true;
        return resendCount < MAX_RESENDS_PER_HOUR;
    }
    public boolean canResend(int resendCount) {
        return canResend(Integer.valueOf(resendCount));
    }

    public VerifyResult verify(Integer userId, String otp) throws SQLException {
        if (userId == null || otp == null) return VerifyResult.NO_ACTIVE_OTP;
        User user = userDAO.getUserById(userId);
        if (user == null || user.getEmail() == null) return VerifyResult.NO_ACTIVE_OTP;
        return verify(user.getEmail(), otp, PURPOSE_REGISTER);
    }

    public VerifyResult verify(String email, String otp, String purpose) throws SQLException {
        if (email == null || otp == null || purpose == null) return VerifyResult.NO_ACTIVE_OTP;
        Optional<OtpRecord> opt = otpDAO.findLatestAny(email, purpose);
        if (opt.isEmpty()) return VerifyResult.NO_ACTIVE_OTP;
        OtpRecord rec = opt.get();
        if (rec.getConsumedAt() != null) return VerifyResult.NO_ACTIVE_OTP;
        if (rec.getExpiresAt() != null && rec.getExpiresAt().isBefore(LocalDateTime.now())) return VerifyResult.EXPIRED;
        if (rec.getAttempts() >= MAX_ATTEMPTS) return VerifyResult.TOO_MANY_ATTEMPTS;
        if (!PasswordUtil.checkOtp(otp, rec.getOtpHash())) {
            otpDAO.incrementAttempts(rec.getId());
            return VerifyResult.WRONG_OTP;
        }
        otpDAO.consume(rec.getId());
        return VerifyResult.SUCCESS;
    }

    public VerifyResult verify(String email, String otp) throws SQLException {
        return verify(email, otp, PURPOSE_REGISTER);
    }

    public boolean verifyOtp(String email, String otp, String purpose) throws SQLException {
        return verify(email, otp, purpose) == VerifyResult.SUCCESS;
    }
    public boolean verifyRegistrationOtp(String email, String otp) throws SQLException {
        return verify(email, otp, PURPOSE_REGISTER) == VerifyResult.SUCCESS;
    }
    public boolean verifyResetOtp(String email, String otp) throws SQLException {
        return verify(email, otp, PURPOSE_RESET) == VerifyResult.SUCCESS;
    }
    public boolean verifyLoginOtp(String email, String otp) throws SQLException {
        return verify(email, otp, PURPOSE_LOGIN) == VerifyResult.SUCCESS;
    }

    private String generateCode() {
        return String.format("%06d", random.nextInt(1_000_000));
    }
}