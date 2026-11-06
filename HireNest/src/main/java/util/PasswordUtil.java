package util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    // =========================================================
    //  PASSWORD HASHING
    // =========================================================

    /** Hash a plain password with BCrypt (cost = 12). */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null) {
            throw new IllegalArgumentException("Password cannot be null");
        }
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }

    /** Alias — some code calls hash() instead. */
    public static String hash(String plainPassword) {
        return hashPassword(plainPassword);
    }

    // =========================================================
    //  PASSWORD VERIFICATION
    // =========================================================

    /** Verify plain password against a BCrypt hash. */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) return false;
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    /** Alias — some code calls matches() instead. */
    public static boolean matches(String plainPassword, String hashedPassword) {
        return checkPassword(plainPassword, hashedPassword);
    }

    /**
     * Verify password — the method your existing code is looking for.
     * Handles both BCrypt and (legacy) plain-text passwords:
     *   • If the stored value looks like a BCrypt hash → BCrypt compare
     *   • Otherwise                                → plain equals compare
     * This lets your OLD plain-text users still log in until you
     * migrate them (see note at the bottom).
     */
    public static boolean verifyPassword(String plainPassword, String storedPassword) {
        if (plainPassword == null || storedPassword == null) return false;
        if (isBcryptHash(storedPassword)) {
            return checkPassword(plainPassword, storedPassword);
        }
        // Legacy: plain-text comparison
        return plainPassword.equals(storedPassword);
    }

    // =========================================================
    //  BCYPT DETECTION
    // =========================================================

    /**
     * Returns true if the string looks like a BCrypt hash
     * (starts with $2a$, $2b$, or $2y$ and is 60 chars long).
     * Some older parts of your app may call this to decide whether
     * a password needs to be re-hashed on next login.
     */
    public static boolean isBcryptHash(String value) {
        if (value == null || value.length() != 60) return false;
        return value.startsWith("$2a$")
                || value.startsWith("$2b$")
                || value.startsWith("$2y$");
    }

    // =========================================================
    //  OTP HASHING (used by Forgot Password)
    // =========================================================

    public static String hashOtp(String otp) {
        if (otp == null) {
            throw new IllegalArgumentException("OTP cannot be null");
        }
        return BCrypt.hashpw(otp, BCrypt.gensalt(10));
    }

    public static boolean checkOtp(String plainOtp, String hashedOtp) {
        if (plainOtp == null || hashedOtp == null) return false;
        try {
            return BCrypt.checkpw(plainOtp, hashedOtp);
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    public static void main(String[] args) {
        System.out.println("HASH_FOR_ADMIN90: " + hashPassword("Admin90"));
    }
}