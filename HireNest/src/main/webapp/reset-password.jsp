<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("resetEmail") == null
            || session.getAttribute("resetVerified") == null) {
        response.sendRedirect(request.getContextPath() + "/forgot-password");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - HireNest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
</head>
<body>

<div class="login-container">
    <div class="login-card">

        <div class="login-header">
            <div class="logo-icon"><i class="fas fa-lock"></i></div>
            <h1>Hire<span>Nest</span></h1>
            <p>Set a new password for your account.</p>
        </div>

        <% String error = (String) request.getAttribute("error");
            if (error != null) { %>
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-circle"></i> <%= error %>
        </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/reset-password" method="post">
            <div class="form-group">
                <label for="newPassword"><i class="fas fa-lock"></i> New Password</label>
                <input type="password" id="newPassword" name="newPassword"
                       minlength="8"
                       placeholder="Min 8 chars, 1 letter, 1 number"
                       autocomplete="new-password" required>
            </div>
            <div class="form-group">
                <label for="confirmPassword"><i class="fas fa-lock"></i> Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword"
                       minlength="8"
                       placeholder="Re-enter new password"
                       autocomplete="new-password" required>
            </div>
            <button type="submit" class="btn-login">
                <i class="fas fa-save"></i> Update Password
            </button>
        </form>

    </div>
</div>
</body>
</html>