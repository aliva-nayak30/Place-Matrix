<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if user is logged in
    HttpSession sessionCheck = request.getSession(false);
    if (sessionCheck == null || sessionCheck.getAttribute("userId") == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    // Get user details from session
    String userName = (String) sessionCheck.getAttribute("userName");
    String userEmail = (String) sessionCheck.getAttribute("userEmail");
    String userRegNo = (String) sessionCheck.getAttribute("userRegNo");
    String userBranch = (String) sessionCheck.getAttribute("userBranch");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - HireNest</title>
    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="dashboard-container">
    <div class="dashboard-header">
        <div class="logo">
            <i class="fas fa-graduation-cap"></i>
            <h1>HireNest</h1>
        </div>
        <div class="user-info">
            <span>Welcome, <%= userName %></span>
            <a href="../logout" class="btn-logout">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>

    <div class="dashboard-content">
        <div class="welcome-card">
            <h2>Welcome to HireNest!</h2>
            <p>Your placement journey starts here.</p>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <i class="fas fa-building"></i>
                <h3>Companies</h3>
                <p>25+</p>
            </div>
            <div class="stat-card">
                <i class="fas fa-briefcase"></i>
                <h3>Jobs</h3>
                <p>50+</p>
            </div>
            <div class="stat-card">
                <i class="fas fa-users"></i>
                <h3>Students</h3>
                <p>200+</p>
            </div>
            <div class="stat-card">
                <i class="fas fa-check-circle"></i>
                <h3>Placed</h3>
                <p>150+</p>
            </div>
        </div>

        <div class="info-card">
            <h3>Your Profile</h3>
            <table class="profile-table">
                <tr>
                    <td><strong>Name:</strong></td>
                    <td><%= userName %></td>
                </tr>
                <tr>
                    <td><strong>Registration No:</strong></td>
                    <td><%= userRegNo %></td>
                </tr>
                <tr>
                    <td><strong>Branch:</strong></td>
                    <td><%= userBranch %></td>
                </tr>
                <tr>
                    <td><strong>Email:</strong></td>
                    <td><%= userEmail %></td>
                </tr>
            </table>
        </div>
    </div>

    <div class="dashboard-footer">
        <p>&copy; 2026 HireNest. All rights reserved.</p>
    </div>
</div>
</body>
</html>