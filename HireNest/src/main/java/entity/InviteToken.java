package entity;

import java.time.LocalDateTime;

public class InviteToken {

    private long id;
    private int collegeId;
    private String role;            // STUDENT or RECRUITER
    private String token;
    private int maxUses;
    private int usedCount;
    private LocalDateTime expiresAt;
    private boolean active;
    private Integer createdBy;
    private LocalDateTime createdAt;

    public InviteToken() {}

    // ---------- id ----------
    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    // ---------- collegeId ----------
    public int getCollegeId() { return collegeId; }
    public void setCollegeId(int collegeId) { this.collegeId = collegeId; }

    // ---------- role ----------
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    // ---------- token ----------
    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }

    // ---------- maxUses ----------
    public int getMaxUses() { return maxUses; }
    public void setMaxUses(int maxUses) { this.maxUses = maxUses; }

    // ---------- usedCount ----------
    public int getUsedCount() { return usedCount; }
    public void setUsedCount(int usedCount) { this.usedCount = usedCount; }

    // ---------- expiresAt ----------
    public LocalDateTime getExpiresAt() { return expiresAt; }
    public void setExpiresAt(LocalDateTime expiresAt) { this.expiresAt = expiresAt; }

    // ---------- active ----------
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    // ---------- createdBy ----------
    public Integer getCreatedBy() { return createdBy; }
    public void setCreatedBy(Integer createdBy) { this.createdBy = createdBy; }

    // ---------- createdAt ----------
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    // =========================================================
    // HELPERS — used by JSP
    // =========================================================
    public boolean isValid() {
        return active
                && expiresAt != null
                && expiresAt.isAfter(LocalDateTime.now())
                && usedCount < maxUses;
    }

    public String getStatusLabel() {
        if (!active) return "INACTIVE";
        if (expiresAt != null && expiresAt.isBefore(LocalDateTime.now())) return "EXPIRED";
        if (usedCount >= maxUses) return "MAXED OUT";
        return "ACTIVE";
    }

    public String getStatusBadgeClass() {
        switch (getStatusLabel()) {
            case "ACTIVE":    return "bg-success";
            case "EXPIRED":   return "bg-warning text-dark";
            case "MAXED OUT": return "bg-secondary";
            default:          return "bg-danger";
        }
    }

    public String getExpiresAtDisplay() {
        if (expiresAt == null) return "—";
        String s = expiresAt.toString();
        return s.length() >= 16 ? s.substring(0, 16).replace("T", " ") : s;
    }

    public String getCreatedAtDisplay() {
        if (createdAt == null) return "—";
        String s = createdAt.toString();
        return s.length() >= 16 ? s.substring(0, 16).replace("T", " ") : s;
    }

    public int getRemainingUses() {
        return Math.max(0, maxUses - usedCount);
    }
}