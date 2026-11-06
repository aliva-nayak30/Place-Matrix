<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Super Admin Login - HireNest</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- External CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/superadmin-login.css">
</head>
<body>

<div class="login-card">

    <div class="login-header">
        <div class="icon-circle">
            <i class="fas fa-user-shield"></i>
        </div>
        <h1>Super Admin</h1>
        <p>HireNest Placement Platform</p>
    </div>

    <!-- Error Message -->
    <%
        String error = (String) request.getAttribute("error");
        String errorParam = request.getParameter("error");
        if (error == null) error = errorParam;

        if (error != null && !error.isEmpty()) {
    %>
    <div class="alert alert-danger">
        <i class="fas fa-exclamation-circle"></i> <%= error %>
    </div>
    <%
        }
    %>

    <form method="post" action="${pageContext.request.contextPath}/superadmin/login">

        <div class="mb-3">
            <label class="form-label">Email Address</label>
            <div class="input-group">
                <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                <input type="email" class="form-control with-icon" name="email"
                       placeholder="admin@hirenest.com" required autofocus>
            </div>
        </div>

        <div class="mb-4">
            <label class="form-label">Password</label>
            <div class="input-group">
                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                <input type="password" class="form-control with-icon" name="password"
                       placeholder="Enter password" required>
            </div>
        </div>

        <button type="submit" class="btn-login">
            <i class="fas fa-sign-in-alt"></i> Login
        </button>

    </form>

    <div class="demo-credentials">
        <i class="fas fa-info-circle"></i> <strong>Demo:</strong>
        <code>admin@hirenest.com</code> / <code>admin123</code>
    </div>

</div>

</body>
</html>