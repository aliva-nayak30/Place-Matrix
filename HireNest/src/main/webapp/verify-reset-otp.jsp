<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String resetEmail = (String) session.getAttribute("resetEmail");
    if (resetEmail == null) {
        response.sendRedirect(request.getContextPath() + "/forgot-password");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify Reset Code - HireNest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
</head>
<body>

<div class="login-container">
    <div class="login-card">

        <div class="login-header">
            <div class="logo-icon"><i class="fas fa-key"></i></div>
            <h1>Hire<span>Nest</span></h1>
            <p>We sent a 6-digit code to <b><%= resetEmail %></b>.<br>It expires in 10 minutes.</p>
        </div>

        <% String error = (String) request.getAttribute("error");
            if (error != null) { %>
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-circle"></i> <%= error %>
        </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/verify-reset-otp" method="post">
            <div class="form-group">
                <label for="otp"><i class="fas fa-shield-alt"></i> Reset Code</label>
                <input type="text" id="otp" name="otp"
                       maxlength="6" pattern="[0-9]{6}"
                       inputmode="numeric" autocomplete="one-time-code"
                       required autofocus
                       style="letter-spacing:8px; text-align:center; font-size:22px;">
            </div>
            <button type="submit" class="btn-login">
                <i class="fas fa-check-circle"></i> Verify Code
            </button>
        </form>

        <div style="display:flex; justify-content:space-between; margin-top:18px; font-size:14px;">
            <form method="post" action="${pageContext.request.contextPath}/forgot-password" style="margin:0;">
                <input type="hidden" name="email" value="<%= resetEmail %>">
                <button type="submit" class="btn btn-link"
                        style="padding:0; color:#1e3a8a; text-decoration:underline;">
                    Resend Code
                </button>
            </form>
            <a href="${pageContext.request.contextPath}/forgot-password">Change email</a>
        </div>

    </div>
</div>
</body>
</html>