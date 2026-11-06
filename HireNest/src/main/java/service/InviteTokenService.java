package service;

import dao.InviteTokenDAO;
import entity.InviteToken;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.List;

public class InviteTokenService {

    private static final SecureRandom RANDOM = new SecureRandom();
    private final InviteTokenDAO dao = new InviteTokenDAO();

    public InviteToken createInvite(int collegeId, String role, int maxUses, int daysValid, Integer createdBy) {
        if (!"STUDENT".equals(role) && !"RECRUITER".equals(role)) throw new IllegalArgumentException("Invalid role");

        InviteToken t = new InviteToken();
        t.setCollegeId(collegeId);
        t.setRole(role);
        t.setToken(generateToken());
        t.setMaxUses(maxUses);
        t.setUsedCount(0);
        t.setExpiresAt(LocalDateTime.now().plusDays(daysValid));
        t.setActive(true);
        t.setCreatedBy(createdBy);

        if (!dao.insert(t)) throw new RuntimeException("Failed to save invite token");
        return t;
    }

    public InviteToken validateToken(String token) {
        if (token == null || token.isBlank()) return null;
        InviteToken t = dao.findByToken(token);
        if (t == null || !t.isValid()) return null;
        return t;
    }

    public List<InviteToken> listByCollege(int collegeId) { return dao.findByCollege(collegeId); }
    public boolean incrementUsed(long id) { return dao.incrementUsedCount(id); }
    public boolean deactivate(long id) { return dao.deactivate(id); }
    public boolean delete(long id) { return dao.delete(id); }

    private String generateToken() {
        byte[] bytes = new byte[32];
        RANDOM.nextBytes(bytes);
        StringBuilder sb = new StringBuilder(64);
        for (byte b : bytes) sb.append(String.format("%02x", b));
        return sb.toString();
    }
}