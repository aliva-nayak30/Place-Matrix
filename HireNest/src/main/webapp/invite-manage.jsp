<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, entity.InviteToken" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    Object role = session.getAttribute("role");
    if (!"COLLEGE_ADMIN".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    List<InviteToken> studentTokens   = (List<InviteToken>) request.getAttribute("studentTokens");
    List<InviteToken> recruiterTokens = (List<InviteToken>) request.getAttribute("recruiterTokens");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Invite Links — HireNest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', sans-serif; background: #f3f4f6; padding: 24px; }
        .container-wide { max-width: 1100px; margin: auto; }
        .card-box { background: #fff; border-radius: 12px; padding: 24px; box-shadow: 0 4px 12px rgba(0,0,0,0.06); margin-bottom: 24px; }
        h1 { color: #1e3a8a; font-size: 24px; margin: 0 0 8px; }
        .subtitle { color: #6b7280; margin: 0 0 20px; }
        .token-cell { font-family: 'Courier New', monospace; font-size: 12px; background: #f3f4f6; padding: 4px 8px; border-radius: 4px; word-break: break-all; }
        .url-cell { font-family: 'Courier New', monospace; font-size: 11px; color: #1e40af; word-break: break-all; }
        .btn-copy { font-size: 12px; padding: 4px 10px; }
    </style>
</head>
<body>

<div class="container-wide">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1><i class="fas fa-link"></i> Invite Link Management</h1>
            <p class="subtitle">Generate secure links to invite students and recruiters to your college</p>
        </div>
        <a href="${pageContext.request.contextPath}/collegeadmin/dashboard" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>

    <c:if test="${not empty sessionScope.successMsg}">
        <div class="alert alert-success alert-dismissible fade show">
            <i class="fas fa-check-circle"></i> ${sessionScope.successMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="successMsg" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMsg}">
        <div class="alert alert-danger alert-dismissible fade show">
            <i class="fas fa-exclamation-circle"></i> ${sessionScope.errorMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="errorMsg" scope="session"/>
    </c:if>

    <div class="card-box">
        <h2 style="font-size: 18px; color: #1e3a8a; margin-bottom: 16px;">
            <i class="fas fa-plus-circle"></i> Generate New Invite Link
        </h2>

        <form method="post" action="${pageContext.request.contextPath}/collegeadmin/invites" class="row g-3">
            <input type="hidden" name="action" value="create">

            <div class="col-md-4">
                <label class="form-label">Role</label>
                <select name="role" class="form-select" required>
                    <option value="STUDENT">Student</option>
                    <option value="RECRUITER">Recruiter</option>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label">Max Uses</label>
                <input type="number" name="maxUses" class="form-control" value="100" min="1" max="1000" required>
            </div>
            <div class="col-md-3">
                <label class="form-label">Valid For (Days)</label>
                <input type="number" name="daysValid" class="form-control" value="7" min="1" max="90" required>
            </div>
            <div class="col-md-2 d-flex align-items-end">
                <button type="submit" class="btn btn-primary w-100">
                    <i class="fas fa-magic"></i> Generate
                </button>
            </div>
        </form>
    </div>

    <!-- Student Invites -->
    <div class="card-box">
        <h2 style="font-size: 18px; color: #1e3a8a; margin-bottom: 16px;">
            <i class="fas fa-user-graduate"></i> Student Invites
        </h2>
        <% if (studentTokens == null || studentTokens.isEmpty()) { %>
        <p class="text-muted">No student invite links yet. Create one above.</p>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-sm align-middle">
                <thead><tr><th>Token</th><th>Status</th><th>Uses</th><th>Expires</th><th>URL</th><th></th></tr></thead>
                <tbody>
                <% for (InviteToken t : studentTokens) { %>
                <tr>
                    <td><span class="token-cell"><%= t.getToken() %></span></td>
                    <td><span class="badge <%= t.getStatusBadgeClass() %>"><%= t.getStatusLabel() %></span></td>
                    <td><%= t.getUsedCount() %> / <%= t.getMaxUses() %></td>
                    <td><%= t.getExpiresAtDisplay() %></td>

                    <!-- 🔥 FIXED: Removed broken scheme code -->
                    <td><span class="url-cell"><a href="${pageContext.request.contextPath}/join?token=<%= t.getToken() %>" target="_blank">/join?token=<%= t.getToken() %></a></span></td>

                    <td class="text-nowrap">
                        <button type="button" class="btn btn-sm btn-outline-primary btn-copy" onclick="copyUrl('<%= t.getToken() %>')">
                            <i class="fas fa-copy"></i> Copy
                        </button>
                        <% if (t.isActive()) { %>
                        <form method="post" action="${pageContext.request.contextPath}/collegeadmin/invites" style="display:inline" onsubmit="return confirm('Deactivate this link?')">
                            <input type="hidden" name="action" value="deactivate">
                            <input type="hidden" name="id" value="<%= t.getId() %>">
                            <button type="submit" class="btn btn-sm btn-outline-danger btn-copy"><i class="fas fa-ban"></i> Disable</button>
                        </form>
                        <% } %>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>

    <!-- Recruiter Invites -->
    <div class="card-box">
        <h2 style="font-size: 18px; color: #1e3a8a; margin-bottom: 16px;">
            <i class="fas fa-building"></i> Recruiter Invites
        </h2>
        <% if (recruiterTokens == null || recruiterTokens.isEmpty()) { %>
        <p class="text-muted">No recruiter invite links yet. Create one above.</p>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-sm align-middle">
                <thead><tr><th>Token</th><th>Status</th><th>Uses</th><th>Expires</th><th>URL</th><th></th></tr></thead>
                <tbody>
                <% for (InviteToken t : recruiterTokens) { %>
                <tr>
                    <td><span class="token-cell"><%= t.getToken() %></span></td>
                    <td><span class="badge <%= t.getStatusBadgeClass() %>"><%= t.getStatusLabel() %></span></td>
                    <td><%= t.getUsedCount() %> / <%= t.getMaxUses() %></td>
                    <td><%= t.getExpiresAtDisplay() %></td>

                    <!-- 🔥 FIXED: Removed broken scheme code -->
                    <td><span class="url-cell"><a href="${pageContext.request.contextPath}/join?token=<%= t.getToken() %>" target="_blank">/join?token=<%= t.getToken() %></a></span></td>

                    <td class="text-nowrap">
                        <button type="button" class="btn btn-sm btn-outline-primary btn-copy" onclick="copyUrl('<%= t.getToken() %>')">
                            <i class="fas fa-copy"></i> Copy
                        </button>
                        <% if (t.isActive()) { %>
                        <form method="post" action="${pageContext.request.contextPath}/collegeadmin/invites" style="display:inline" onsubmit="return confirm('Deactivate this link?')">
                            <input type="hidden" name="action" value="deactivate">
                            <input type="hidden" name="id" value="<%= t.getId() %>">
                            <button type="submit" class="btn btn-sm btn-outline-danger btn-copy"><i class="fas fa-ban"></i> Disable</button>
                        </form>
                        <% } %>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>
</div>

<script>
    function copyUrl(token) {
        const contextPath = "${pageContext.request.contextPath}";
        const url = window.location.origin + contextPath + '/join?token=' + token;
        navigator.clipboard.writeText(url).then(() => {
            alert('URL copied to clipboard:\n\n' + url);
        }).catch(() => {
            prompt('Copy this URL manually:', url);
        });
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>