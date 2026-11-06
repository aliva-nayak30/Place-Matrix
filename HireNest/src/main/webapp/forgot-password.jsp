<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - HireNest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
</head>
<body>

<div class="login-container">
    <div class="login-card">

        <div class="login-header">
            <div class="logo-icon"><i class="fas fa-graduation-cap"></i></div>
            <h1>Hire<span>Nest</span></h1>
            <p>Enter your registered email and we'll send a 6-digit reset code.</p>
        </div>

        <% String error = (String) request.getAttribute("error");
            if (error != null) { %>
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-circle"></i> <%= error %>
        </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/forgot-password" method="post">
            <div class="form-group">
                <label for="email"><i class="fas fa-envelope"></i> Email Address</label>
                <input type="email" id="email" name="email"
                       placeholder="your.email@university.edu"
                       required autofocus>
            </div>
            <button type="submit" class="btn-login">
                <i class="fas fa-paper-plane"></i> Send Reset Code
            </button>
        </form>

        <div class="login-footer" style="margin-top:20px;">
            <p>
                <a href="${pageContext.request.contextPath}/login.jsp">
                    <i class="fas fa-arrow-left"></i> Back to Login
                </a>
            </p>
        </div>

    </div>
</div>
</body>
</html>