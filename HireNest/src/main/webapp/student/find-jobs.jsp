<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Find Jobs - HireNest</title>
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
        <input type="text" placeholder="Search jobs...">
    </div>
    <div class="navbar-right">
        <button class="navbar-icon-btn"><i class="fas fa-bell"></i><span class="notification-badge">3</span></button>
        <div class="navbar-profile">
            <div class="profile-avatar">${fn:substring(student.name, 0, 1)}</div>
            <div class="profile-info">
                <span class="profile-name">${student.name}</span>
                <span class="profile-role">Student</span>
            </div>
        </div>
    </div>
</nav>

<aside class="sidebar" id="sidebar">
    <ul class="sidebar-menu">
        <li><a href="${pageContext.request.contextPath}/student/dashboard"><i class="fas fa-th-large"></i><span>Dashboard</span></a></li>
        <li><a href="${pageContext.request.contextPath}/student/find-jobs" class="active"><i class="fas fa-briefcase"></i><span>Find Jobs</span></a></li>
        <li><a href="${pageContext.request.contextPath}/student/my-applications"><i class="fas fa-file-alt"></i><span>My Applications</span></a></li>
        <li><a href="${pageContext.request.contextPath}/student/resume"><i class="fas fa-file-pdf"></i><span>Resume</span></a></li>
        <li><a href="${pageContext.request.contextPath}/student/profile"><i class="fas fa-user"></i><span>Profile</span></a></li>
        <div class="sidebar-divider"></div>
        <li><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a></li>
    </ul>
</aside>

<main class="main-content">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 style="font-size: 22px; font-weight: 700; margin: 0;">Find Jobs</h2>
            <p style="color: #64748b; margin: 4px 0 0;">Discover ${jobs.size()} active placement drives</p>
        </div>
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

    <c:choose>
        <c:when test="${empty jobs}">
            <div class="dashboard-card text-center py-5">
                <i class="fas fa-briefcase" style="font-size: 48px; color: #cbd5e1;"></i>
                <h4 class="mt-3">No jobs available</h4>
                <p style="color: #64748b;">New placement drives will appear here soon.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row g-3">
                <c:forEach items="${jobs}" var="job">
                    <div class="col-lg-6">
                        <div class="dashboard-card h-100">
                            <div class="d-flex align-items-start gap-3 mb-3">
                                <div class="company-logo" style="width: 56px; height: 56px; border-radius: 12px; background: linear-gradient(135deg, #4f46e5, #7c3aed); display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; font-size: 20px;">
                                        ${fn:substring(job.companyName, 0, 1)}
                                </div>
                                <div style="flex: 1;">
                                    <h5 style="margin: 0; font-weight: 700; font-size: 17px;">${job.role}</h5>
                                    <p style="margin: 2px 0 0; color: #64748b; font-size: 14px;">${job.companyName}</p>
                                </div>
                            </div>

                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; font-size: 13px; color: #64748b; margin-bottom: 16px;">
                                <div><i class="fas fa-map-marker-alt" style="color: #4f46e5; width: 16px;"></i> ${job.location}</div>
                                <div><i class="fas fa-rupee-sign" style="color: #4f46e5; width: 16px;"></i> ${job.ctc} LPA</div>
                                <div><i class="fas fa-graduation-cap" style="color: #4f46e5; width: 16px;"></i> Min CGPA: ${job.minCgpa}</div>
                                <div><i class="fas fa-calendar" style="color: #4f46e5; width: 16px;"></i> <fmt:formatDate value="${job.deadline}" pattern="dd MMM"/></div>
                            </div>

                            <c:if test="${not empty job.skills}">
                                <p style="font-size: 12px; color: #94a3b8; margin-bottom: 16px;">
                                    <i class="fas fa-code"></i> ${job.skills}
                                </p>
                            </c:if>

                            <c:choose>
                                <c:when test="${appliedJobIds.contains(job.id)}">
                                    <button class="btn-outline-custom w-100" disabled style="opacity: 0.6; cursor: not-allowed;">
                                        <i class="fas fa-check"></i> Already Applied
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/student/apply?jobId=${job.id}"
                                       class="btn-primary-custom w-100"
                                       style="text-decoration: none; display: flex;"
                                       onclick="return confirm('Apply for ${job.role} at ${job.companyName}?');">
                                        <i class="fas fa-paper-plane"></i> Apply Now
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/dashboard.js"></script>
</body>
</html>