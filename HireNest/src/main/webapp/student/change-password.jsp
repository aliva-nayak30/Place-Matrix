<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%
    if (!"STUDENT".equals(session.getAttribute("role"))) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Change Password - HireNest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>body { font-family: 'Inter', sans-serif; background: #f8fafc; }</style>
</head>
<body class="flex h-screen overflow-hidden d-flex">

<!-- Include your Student Sidebar here -->
<aside class="sidebar w-25 bg-dark text-white p-3" style="min-height: 100vh; background-color: #0F172A !important;">
    <h4 class="fw-bold mb-4 text-white"><i class="bi bi-mortarboard-fill text-primary"></i> HireNest</h4>
    <a href="${pageContext.request.contextPath}/student/dashboard" class="d-block text-white text-decoration-none py-2 px-3 mb-2 rounded hover-bg-light">Dashboard</a>
    <a href="${pageContext.request.contextPath}/student/profile" class="d-block text-white text-decoration-none py-2 px-3 mb-2 rounded hover-bg-light">My Profile</a>
    <a href="${pageContext.request.contextPath}/student/change-password" class="d-block bg-primary text-white text-decoration-none py-2 px-3 mb-2 rounded fw-bold">Change Password</a>
</aside>

<!-- Main Content -->
<main class="flex-grow-1 p-5 overflow-auto">
    <div class="container" style="max-width: 600px;">
        <h2 class="fw-bold text-dark mb-4">Change Password</h2>

        <div class="bg-white p-5 rounded-4 shadow-sm border">
            <c:if test="${not empty error}">
                <div class="alert alert-danger"><i class="bi bi-exclamation-circle"></i> ${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/student/change-password" method="POST">

                <div class="mb-3">
                    <label class="form-label fw-bold small text-muted">Current Password (e.g., Student@123)</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light"><i class="bi bi-lock"></i></span>
                        <input type="password" name="currentPassword" class="form-control" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold small text-muted">New Password</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light"><i class="bi bi-key"></i></span>
                        <input type="password" name="newPassword" class="form-control" placeholder="Min 8 chars, letters & numbers" required>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-bold small text-muted">Confirm New Password</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light"><i class="bi bi-key-fill"></i></span>
                        <input type="password" name="confirmPassword" class="form-control" required>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary w-100 fw-bold py-2">
                    <i class="bi bi-shield-check"></i> Update Password
                </button>
            </form>
        </div>
    </div>
</main>
</body>
</html>