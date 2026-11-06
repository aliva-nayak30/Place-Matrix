<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Applications - HireNest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>

<nav class="top-navbar">
    <button class="mobile-toggle" onclick="toggleSidebar()"><i class="fas fa-bars"></i></button>
    <a href="#" class="navbar-logo"><i class="fas fa-graduation-cap"></i><span>HireNest</span></a>
    <div class="navbar-search">
        <i class="fas fa-search search-icon"></i>
        <input type="text" placeholder="Search applications...">
    </div>
    <div class="navbar-right">
        <button class="navbar-icon-btn"><i class="fas fa-bell"></i><span class="notification-badge">3</span></button>
        <div class="navbar-profile">
            <div class="profile-avatar">S</div>
            <div class="profile-info">
                <span class="profile-name">Student</span>
                <span class="profile-role">Student</span>
            </div>
        </div>
    </div>
</nav>

<aside class="sidebar" id="sidebar">
    <ul class="sidebar-menu">
        <li><a href="${pageContext.request.contextPath}/student/dashboard"><i class="fas fa-th-large"></i><span>Dashboard</span></a></li>
        <li><a href="${pageContext.request.contextPath}/student/find-jobs"><i class="fas fa-briefcase"></i><span>Find Jobs</span></a></li>
        <li><a href="${pageContext.request.contextPath}/student/applications" class="active"><i class="fas fa-file-alt"></i><span>My Applications</span></a></li>
        <li><a href="${pageContext.request.contextPath}/student/resume"><i class="fas fa-file-pdf"></i><span>Resume</span></a></li>
        <!-- ✅ FIXED: Profile link now points to servlet -->
        <li><a href="${pageContext.request.contextPath}/student/profile"><i class="fas fa-user"></i><span>Profile</span></a></li>
        <div class="sidebar-divider"></div>
        <li><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a></li>
    </ul>
</aside>

<main class="main-content">

    <div class="mb-4">
        <h2 style="font-size: 22px; font-weight: 700; margin: 0;">My Applications</h2>
        <p style="color: #64748b; margin: 4px 0 0;">Track the status of all your job applications</p>
    </div>

    <!-- Stats Row -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon blue"><i class="fas fa-briefcase"></i></div>
                <div class="stat-body">
                    <h3 class="stat-value">${statusCounts.Total}</h3>
                    <p class="stat-label">Total</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon green"><i class="fas fa-check-circle"></i></div>
                <div class="stat-body">
                    <h3 class="stat-value">${statusCounts.Shortlisted}</h3>
                    <p class="stat-label">Shortlisted</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon orange"><i class="fas fa-calendar-check"></i></div>
                <div class="stat-body">
                    <h3 class="stat-value">${statusCounts.Interview}</h3>
                    <p class="stat-label">Interview</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon purple"><i class="fas fa-clock"></i></div>
                <div class="stat-body">
                    <h3 class="stat-value">${statusCounts.Pending}</h3>
                    <p class="stat-label">Pending</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Applications Table -->
    <div class="dashboard-card">
        <c:choose>
            <c:when test="${empty applications}">
                <div class="text-center py-5">
                    <i class="fas fa-inbox" style="font-size: 48px; color: #cbd5e1;"></i>
                    <h4 class="mt-3">No applications yet</h4>
                    <p style="color: #64748b;">Start applying for jobs to see them here.</p>
                    <a href="${pageContext.request.contextPath}/student/find-jobs" class="btn-primary-custom" style="display: inline-flex; width: auto; padding: 12px 24px; text-decoration: none; margin-top: 12px;">
                        <i class="fas fa-search"></i> Browse Jobs
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="applications-table">
                        <thead>
                        <tr>
                            <th>Company</th>
                            <th>Role</th>
                            <th>Location</th>
                            <th>CTC</th>
                            <th>Applied On</th>
                            <th>Status</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${applications}" var="app">
                            <tr>
                                <td>
                                    <div class="company-cell">
                                        <div class="company-logo" style="background: linear-gradient(135deg, #4f46e5, #7c3aed);">
                                                ${fn:substring(app.companyName, 0, 1)}
                                        </div>
                                        <span class="company-name">${app.companyName}</span>
                                    </div>
                                </td>
                                <td>${app.role}</td>
                                <td>${app.location}</td>
                                <td>${app.ctc} LPA</td>
                                <td><fmt:formatDate value="${app.appliedDate}" pattern="dd MMM yyyy"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${app.status == 'Shortlisted'}">
                                            <span class="status-badge status-shortlisted">Shortlisted</span>
                                        </c:when>
                                        <c:when test="${app.status == 'Rejected'}">
                                            <span class="status-badge status-rejected">Rejected</span>
                                        </c:when>
                                        <c:when test="${app.status == 'Interview'}">
                                            <span class="status-badge status-interview">Interview</span>
                                        </c:when>
                                        <c:when test="${app.status == 'Selected'}">
                                            <span class="status-badge status-shortlisted">Selected</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-pending">Pending</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/dashboard.js"></script>
</body>
</html>