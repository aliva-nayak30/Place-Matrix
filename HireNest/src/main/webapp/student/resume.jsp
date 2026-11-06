<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Resume - HireNest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/resume.css">
</head>
<body>

<nav class="top-navbar">
    <button class="mobile-toggle" onclick="toggleSidebar()"><i class="fas fa-bars"></i></button>
    <a href="#" class="navbar-logo"><i class="fas fa-graduation-cap"></i><span>HireNest</span></a>
    <div class="navbar-search">
        <i class="fas fa-search search-icon"></i>
        <input type="text" placeholder="Search...">
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
        <li><a href="${pageContext.request.contextPath}/student/my-applications"><i class="fas fa-file-alt"></i><span>My Applications</span></a></li>
        <li><a href="${pageContext.request.contextPath}/student/resume" class="active"><i class="fas fa-file-pdf"></i><span>Resume</span></a></li>
        <li><a href="${pageContext.request.contextPath}/student/profile"><i class="fas fa-user"></i><span>Profile</span></a></li>
        <div class="sidebar-divider"></div>
        <li><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a></li>
    </ul>
</aside>

<main class="main-content">

    <div class="mb-4">
        <h2 style="font-size:22px; font-weight:700; margin:0;">My Resume</h2>
        <p style="color:#64748b; margin:4px 0 0;">Upload your resume and get an AI-powered ATS score</p>
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

    <div class="row g-3">
        <div class="col-lg-6">
            <div class="dashboard-card h-100">
                <div class="card-title"><span><i class="fas fa-file-pdf"></i> Current Resume</span></div>
                <c:choose>
                    <c:when test="${not empty student.resumePath}">
                        <div class="text-center py-4">
                            <i class="fas fa-file-pdf" style="font-size:64px; color:#ef4444;"></i>
                            <h5 class="mt-3">Resume.pdf</h5>
                            <p style="color:#64748b; font-size:13px;">Uploaded successfully</p>
                            <div class="d-flex gap-2 justify-content-center mt-3">
                                <a href="${pageContext.request.contextPath}/${student.resumePath}" target="_blank"
                                   class="btn-primary-custom" style="text-decoration:none; display:inline-flex; width:auto; padding:10px 20px;">
                                    <i class="fas fa-eye"></i> View
                                </a>
                                <a href="${pageContext.request.contextPath}/${student.resumePath}" download
                                   class="btn-outline-custom" style="text-decoration:none; display:inline-flex; width:auto; padding:10px 20px;">
                                    <i class="fas fa-download"></i> Download
                                </a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5">
                            <i class="fas fa-file-excel" style="font-size:64px; color:#cbd5e1;"></i>
                            <h5 class="mt-3" style="color:#64748b;">No Resume Uploaded</h5>
                            <p style="color:#94a3b8; font-size:13px;">Upload your resume to get started</p>
                        </div>
                    </c:otherwise>
                </c:choose>
                <hr style="margin:20px 0;">
                <div class="card-title" style="margin-bottom:12px;">
                    <span><i class="fas fa-cloud-upload-alt"></i> Upload / Re-upload</span>
                </div>
                <form action="${pageContext.request.contextPath}/UploadResumeServlet" method="post" enctype="multipart/form-data">
                    <input type="file" class="form-control mb-3" name="resumeFile" accept=".pdf" required
                           style="padding:12px; border-radius:10px; border:2px solid #e2e8f0;">
                    <small style="color:#94a3b8; display:block; margin-bottom:12px;">
                        <i class="fas fa-info-circle"></i> Max 10 MB. PDF only. Will be analyzed for ATS score.
                    </small>
                    <button type="submit" class="btn-primary-custom">
                        <i class="fas fa-upload"></i> Upload & Analyze
                    </button>
                </form>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="dashboard-card h-100">
                <div class="card-title">
                    <span><i class="fas fa-chart-line"></i> ATS Score</span>
                    <c:if test="${atsScore > 0}">
                        <span class="badge-score ${atsScore >= 75 ? 'good' : (atsScore >= 50 ? 'average' : 'poor')}">
                                ${atsScore >= 75 ? 'Good' : (atsScore >= 50 ? 'Average' : 'Needs Work')}
                        </span>
                    </c:if>
                </div>
                <c:choose>
                    <c:when test="${atsScore == 0}">
                        <div class="text-center py-5">
                            <i class="fas fa-robot" style="font-size:64px; color:#cbd5e1;"></i>
                            <h5 class="mt-3" style="color:#64748b;">No Score Yet</h5>
                            <p style="color:#94a3b8; font-size:13px;">Upload a resume to see your ATS score</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="score-circle-wrapper">
                            <div class="score-circle" style="--score: ${atsScore};">
                                <svg viewBox="0 0 120 120">
                                    <circle cx="60" cy="60" r="52" class="bg-circle"></circle>
                                    <circle cx="60" cy="60" r="52" class="fg-circle"
                                            style="stroke-dashoffset: calc(327 - (327 * ${atsScore} / 100));"></circle>
                                </svg>
                                <div class="score-value">
                                    <span class="score-number">${atsScore}</span>
                                    <span class="score-label">/ 100</span>
                                </div>
                            </div>
                        </div>
                        <c:if test="${not empty atsDetails}">
                            <div class="section-scores mt-4">
                                <div class="score-row">
                                    <span>Contact Info</span>
                                    <div class="score-bar"><div class="score-fill" style="width: ${atsDetails.contactScore * 100 / 15}%;"></div></div>
                                    <span class="score-num">${atsDetails.contactScore}/15</span>
                                </div>
                                <div class="score-row">
                                    <span>Skills</span>
                                    <div class="score-bar"><div class="score-fill" style="width: ${atsDetails.skillsScore * 100 / 20}%;"></div></div>
                                    <span class="score-num">${atsDetails.skillsScore}/20</span>
                                </div>
                                <div class="score-row">
                                    <span>Education</span>
                                    <div class="score-bar"><div class="score-fill" style="width: ${atsDetails.educationScore * 100 / 15}%;"></div></div>
                                    <span class="score-num">${atsDetails.educationScore}/15</span>
                                </div>
                                <div class="score-row">
                                    <span>Experience</span>
                                    <div class="score-bar"><div class="score-fill" style="width: ${atsDetails.experienceScore * 100 / 20}%;"></div></div>
                                    <span class="score-num">${atsDetails.experienceScore}/20</span>
                                </div>
                                <div class="score-row">
                                    <span>Keywords</span>
                                    <div class="score-bar"><div class="score-fill" style="width: ${atsDetails.keywordsScore * 100 / 20}%;"></div></div>
                                    <span class="score-num">${atsDetails.keywordsScore}/20</span>
                                </div>
                                <div class="score-row">
                                    <span>Format</span>
                                    <div class="score-bar"><div class="score-fill" style="width: ${atsDetails.formatScore * 100 / 10}%;"></div></div>
                                    <span class="score-num">${atsDetails.formatScore}/10</span>
                                </div>
                            </div>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <c:if test="${not empty suggestions}">
            <div class="col-12">
                <div class="dashboard-card">
                    <div class="card-title"><span><i class="fas fa-lightbulb"></i> Improvement Suggestions</span></div>
                    <ul class="suggestions-list">
                        <c:forEach items="${suggestions}" var="s">
                            <li><i class="fas fa-arrow-right"></i> ${s}</li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </c:if>
    </div>

</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/dashboard.js"></script>
</body>
</html>