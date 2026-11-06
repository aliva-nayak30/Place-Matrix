<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    if (!"STUDENT".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    // Fallback data for UI presentation if backend hasn't populated the attributes yet
    int profileCompletion = request.getAttribute("profileCompletion") != null ? (Integer) request.getAttribute("profileCompletion") : 80;
    int readinessScore = request.getAttribute("readinessScore") != null ? (Integer) request.getAttribute("readinessScore") : 72;
    int appliedCount = request.getAttribute("appliedCount") != null ? (Integer) request.getAttribute("appliedCount") : 12;
    int shortlistedCount = request.getAttribute("shortlistedCount") != null ? (Integer) request.getAttribute("shortlistedCount") : 3;

    // Determine Readiness Color
    String scoreColor = "text-danger";
    String scoreBg = "bg-danger";
    if (readinessScore >= 80) { scoreColor = "text-success"; scoreBg = "bg-success"; }
    else if (readinessScore >= 60) { scoreColor = "text-warning"; scoreBg = "bg-warning"; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - HireNest</title>

    <!-- Bootstrap 5 & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8fafc;
            overflow-x: hidden;
        }

        /* Sidebar */
        .sidebar {
            width: 260px;
            background-color: #0F172A;
            color: #94a3b8;
            position: fixed;
            height: 100vh;
            top: 0; left: 0;
            z-index: 1000;
            padding-top: 1rem;
            transition: all 0.3s ease;
        }

        .sidebar-brand {
            color: white;
            font-size: 1.5rem;
            font-weight: 700;
            padding: 1rem 1.5rem;
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 1rem;
        }

        .sidebar-brand i { color: #3b82f6; }

        .nav-item { margin: 0.25rem 1rem; }

        .nav-link {
            color: #94a3b8;
            border-radius: 8px;
            padding: 0.75rem 1rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
            transition: all 0.2s;
            text-decoration: none;
        }

        .nav-link:hover, .nav-link.active {
            background-color: rgba(255, 255, 255, 0.1);
            color: white;
        }

        .nav-link.active { background-color: #3b82f6; color: white; }

        /* Main Content */
        .main-content {
            margin-left: 260px;
            padding: 2rem;
            min-height: 100vh;
        }

        /* Header */
        .top-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(10px);
            padding: 1rem 1.5rem;
            border-radius: 16px;
            border: 1px solid rgba(255, 255, 255, 0.5);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }

        /* Glassmorphism Cards */
        .glass-card {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.5);
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
            padding: 1.5rem;
            height: 100%;
            transition: transform 0.2s;
        }

        .glass-card:hover { transform: translateY(-3px); }

        /* Circular Progress */
        .circular-progress {
            position: relative;
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: conic-gradient(#3b82f6 <%= profileCompletion %>%, #e2e8f0 0);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .circular-progress::before {
            content: "";
            position: absolute;
            width: 65px;
            height: 65px;
            background: white;
            border-radius: 50%;
        }
        .circular-progress span {
            position: relative;
            font-weight: 700;
            font-size: 1.2rem;
            color: #0F172A;
        }

        /* Hero Readiness Meter */
        .hero-meter-card {
            background: linear-gradient(135deg, #0F172A, #1e293b);
            color: white;
            border-radius: 16px;
            padding: 2rem;
            position: relative;
            overflow: hidden;
            height: 100%;
        }

        .hero-meter-card::after {
            content: "";
            position: absolute;
            top: -50%; right: -50%;
            width: 300px; height: 300px;
            background: radial-gradient(circle, rgba(59, 130, 246, 0.2) 0%, transparent 70%);
            border-radius: 50%;
        }

        /* Timeline */
        .timeline {
            position: relative;
            padding-left: 2rem;
            margin-top: 1.5rem;
        }
        .timeline::before {
            content: '';
            position: absolute;
            top: 0; bottom: 0; left: 9px;
            width: 2px;
            background: #e2e8f0;
        }
        .timeline-item {
            position: relative;
            margin-bottom: 1.5rem;
        }
        .timeline-item:last-child { margin-bottom: 0; }

        .timeline-icon {
            position: absolute;
            left: -2rem;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background: #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 10px;
            color: white;
            z-index: 2;
        }
        .timeline-icon.done { background: #10b981; }
        .timeline-icon.active { background: #3b82f6; box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.2); animation: pulse 2s infinite; }
        .timeline-icon.rejected { background: #ef4444; }

        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(59, 130, 246, 0.4); }
            70% { box-shadow: 0 0 0 8px rgba(59, 130, 246, 0); }
            100% { box-shadow: 0 0 0 0 rgba(59, 130, 246, 0); }
        }

        .hover-bg-light:hover { background-color: #f1f5f9; }
    </style>
</head>
<body>

<!-- Sidebar -->
<aside class="sidebar">
    <div class="sidebar-brand">
        <i class="bi bi-mortarboard-fill"></i> HireNest
    </div>
    <ul class="nav flex-column mt-3">
        <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/student/dashboard"><i class="bi bi-grid-1x2-fill"></i> Dashboard</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/student/eligible-companies"><i class="bi bi-briefcase-fill"></i> Eligible Companies</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/student/my-applications"><i class="bi bi-file-earmark-text-fill"></i> My Applications</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/student/resume"><i class="bi bi-file-pdf-fill"></i> Resume & ATS</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/student/profile"><i class="bi bi-person-fill"></i> My Profile</a></li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/student/change-password">
                <i class="bi bi-shield-lock-fill"></i> Change Password
            </a>
        </li>
        <li class="nav-item mt-5"><a class="nav-link text-danger" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
    </ul>
</aside>

<!-- Main Content -->
<main class="main-content">

    <!-- Top Header - CHANGED: added position:relative; z-index:1050 -->
    <header class="top-header" style="position: relative; z-index: 1050;">
        <div>
            <h2 class="h4 fw-bold mb-1">Welcome, ${sessionScope.userName}</h2>
            <p class="text-muted small mb-0">
                <i class="bi bi-diagram-3-fill me-1 text-primary"></i> Branch: ${empty sessionScope.studentBranch ? 'MCA' : sessionScope.studentBranch}
                <span class="mx-2">|</span>
                <i class="bi bi-calendar-event-fill me-1 text-success"></i> Passout: ${empty sessionScope.passoutYear ? '2026' : sessionScope.passoutYear}
            </p>
        </div>
        <div class="d-flex align-items-center gap-3">
            <!-- Bell Dropdown - CHANGED: added data-bs-auto-close="true", menu z-index:1055 -->
            <div class="dropdown">
                <button class="btn btn-light position-relative rounded-circle p-2 border" data-bs-toggle="dropdown" data-bs-auto-close="true" aria-expanded="false">
                    <i class="bi bi-bell-fill text-dark"></i>
                    <c:if test="${unreadCount > 0}">
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 0.6rem;">
                                ${unreadCount}
                        </span>
                    </c:if>
                </button>
                <ul class="dropdown-menu dropdown-menu-end shadow" style="width: 320px; z-index: 1055;">
                    <li><h6 class="dropdown-header">Recent Notifications</h6></li>
                    <c:forEach items="${notifications}" var="n">
                        <li>
                            <a class="dropdown-item text-wrap" href="${pageContext.request.contextPath}/student/my-applications">
                                <div class="small ${n.isRead == 0 ? 'fw-bold text-dark' : 'text-muted'}">${n.message}</div>
                                <div class="text-muted" style="font-size: 0.75rem;"><fmt:formatDate value="${n.createdAt}" pattern="dd MMM yyyy, hh:mm a"/></div>
                            </a>
                        </li>
                    </c:forEach>
                    <c:if test="${empty notifications}">
                        <li><a class="dropdown-item text-muted text-center" href="#">No new notifications</a></li>
                    </c:if>
                </ul>
            </div>
            <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center fw-bold shadow-sm" style="width: 42px; height: 42px; font-size: 1.1rem;">
                ${fn:substring(sessionScope.userName, 0, 1)}
            </div>
        </div>
    </header>

    <!-- Section 1: Stat Cards -->
    <div class="row g-4 mb-4">
        <div class="col-md-3">
            <div class="glass-card d-flex align-items-center gap-3">
                <div class="circular-progress"><span><%= profileCompletion %>%</span></div>
                <div>
                    <h6 class="text-muted mb-1 fw-medium" style="font-size: 0.85rem;">Profile Strength</h6>
                    <h5 class="mb-0 fw-bold">Complete</h5>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="glass-card" title="Calculated based on: CGPA 30%, Skills 30%, Academics 20%, Profile 20%">
                <h6 class="text-muted mb-1 fw-medium" style="font-size: 0.85rem;">Readiness Score</h6>
                <div class="d-flex align-items-end gap-2">
                    <h2 class="mb-0 fw-bold <%= scoreColor %>"><%= readinessScore %><span style="font-size: 1rem;">%</span></h2>
                </div>
                <div class="progress mt-2" style="height: 6px;">
                    <div class="progress-bar <%= scoreBg %>" style="width: <%= readinessScore %>%;"></div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="glass-card">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <h6 class="text-muted mb-1 fw-medium" style="font-size: 0.85rem;">Applications</h6>
                        <h2 class="mb-0 fw-bold"><%= appliedCount %></h2>
                    </div>
                    <div class="bg-primary bg-opacity-10 text-primary rounded-circle p-2 d-flex align-items-center justify-content-center" style="width: 42px; height: 42px;">
                        <i class="bi bi-send-fill fs-5"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="glass-card">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <h6 class="text-muted mb-1 fw-medium" style="font-size: 0.85rem;">Shortlisted</h6>
                        <h2 class="mb-0 fw-bold"><%= shortlistedCount %></h2>
                    </div>
                    <div class="bg-success bg-opacity-10 text-success rounded-circle p-2 d-flex align-items-center justify-content-center" style="width: 42px; height: 42px;">
                        <i class="bi bi-person-check-fill fs-5"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <!-- Section 2: Placement Readiness Meter (Hero) -->
        <div class="col-md-7">
            <div class="hero-meter-card">
                <div class="d-flex justify-content-between align-items-center mb-4 position-relative z-1">
                    <h4 class="mb-0 fw-bold">Placement Readiness</h4>
                    <span class="badge <%= scoreBg %> text-white px-3 py-2 rounded-pill shadow-sm"><%= readinessScore %>% Ready</span>
                </div>
                <div class="d-flex justify-content-between small mb-2 text-light opacity-75 position-relative z-1">
                    <span>0%</span><span>50%</span><span>100%</span>
                </div>
                <div class="progress mb-4 position-relative z-1" style="height: 12px; background: rgba(255,255,255,0.1); border-radius: 10px;">
                    <div class="progress-bar <%= scoreBg %>" role="progressbar" style="width: <%= readinessScore %>%; border-radius: 10px;" aria-valuenow="<%= readinessScore %>" aria-valuemin="0" aria-valuemax="100"></div>
                </div>
                <div class="bg-white bg-opacity-10 p-3 rounded-3 mb-4 position-relative z-1 border border-light border-opacity-10">
                    <h6 class="text-warning mb-2 fw-bold"><i class="bi bi-stars me-2"></i> AI Suggestions</h6>
                    <ul class="mb-0 small text-light opacity-75 ps-3">
                        <li class="mb-1">Add 2 more skills to be eligible for TCS Digital.</li>
                        <li>Upload LinkedIn URL to increase score by 10%.</li>
                    </ul>
                </div>
                <a href="${pageContext.request.contextPath}/student/profile" class="btn btn-light text-dark fw-bold px-4 rounded-3 position-relative z-1">
                    Improve Score <i class="bi bi-arrow-right ms-1"></i>
                </a>
            </div>
        </div>

        <!-- Section 4: Quick Actions -->
        <div class="col-md-5">
            <div class="glass-card">
                <h5 class="fw-bold mb-4">Quick Actions</h5>
                <div class="row g-3">
                    <div class="col-6">
                        <a href="${pageContext.request.contextPath}/student/resume" class="text-decoration-none">
                            <div class="p-3 border rounded-3 text-center h-100 hover-bg-light transition">
                                <i class="bi bi-file-earmark-arrow-down fs-3 text-primary mb-2 d-block"></i>
                                <span class="small fw-medium text-dark d-block">Resume & ATS</span>
                            </div>
                        </a>
                    </div>
                    <div class="col-6">
                        <a href="${pageContext.request.contextPath}/student/eligible-companies" class="text-decoration-none">
                            <div class="p-3 border rounded-3 text-center h-100 hover-bg-light transition">
                                <i class="bi bi-buildings fs-3 text-success mb-2 d-block"></i>
                                <span class="small fw-medium text-dark d-block">Eligible Drives</span>
                            </div>
                        </a>
                    </div>
                    <div class="col-6">
                        <a href="${pageContext.request.contextPath}/student/profile" class="text-decoration-none">
                            <div class="p-3 border rounded-3 text-center h-100 hover-bg-light transition">
                                <i class="bi bi-lightning-charge fs-3 text-warning mb-2 d-block"></i>
                                <span class="small fw-medium text-dark d-block">Update Skills</span>
                            </div>
                        </a>
                    </div>
                    <div class="col-6">
                        <a href="${pageContext.request.contextPath}/student/profile" class="text-decoration-none">
                            <div class="p-3 border rounded-3 text-center h-100 hover-bg-light transition">
                                <i class="bi bi-person-gear fs-3 text-info mb-2 d-block"></i>
                                <span class="small fw-medium text-dark d-block">My Profile</span>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Section 3: Application Timeline -->
    <div class="row g-4">
        <div class="col-12">
            <div class="glass-card">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5 class="fw-bold mb-0">Recent Applications</h5>
                    <a href="${pageContext.request.contextPath}/student/my-applications" class="text-decoration-none small fw-bold text-primary">View All</a>
                </div>
                <div class="row g-4">
                    <c:choose>
                        <c:when test="${empty recentApps}">
                            <div class="col-12 text-center text-muted py-4 border rounded-3 bg-light">
                                <i class="bi bi-inbox fs-1 text-secondary mb-2 d-block"></i>
                                <h6 class="fw-bold">No Applications Yet</h6>
                                <p class="small mb-0">Apply to eligible companies to see your progress timeline here.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${recentApps}" var="app">
                                <div class="col-md-4">
                                    <div class="border rounded-3 p-3 h-100 position-relative bg-white">
                                        <div class="d-flex align-items-center gap-3 mb-3">
                                            <div class="bg-light p-2 rounded-circle border"><i class="bi bi-building text-muted fs-5"></i></div>
                                            <div>
                                                <h6 class="mb-0 fw-bold text-dark">${app.companyName}</h6>
                                                <span class="text-muted small">${app.role}</span>
                                            </div>
                                        </div>
                                        <div class="timeline mt-4">
                                            <div class="timeline-item">
                                                <div class="timeline-icon done"><i class="bi bi-check"></i></div>
                                                <h6 class="mb-0 small fw-bold text-dark">Applied</h6>
                                                <span class="text-muted" style="font-size: 0.75rem;"><fmt:formatDate value="${app.appliedAt}" pattern="MMM dd, yyyy"/></span>
                                            </div>
                                            <div class="timeline-item">
                                                <div class="timeline-icon ${app.status == 'APPLIED' ? 'active' : (app.status == 'REJECTED' ? 'rejected' : 'done')}">
                                                    <c:if test="${app.status != 'APPLIED' && app.status != 'REJECTED'}"><i class="bi bi-check"></i></c:if>
                                                    <c:if test="${app.status == 'REJECTED'}"><i class="bi bi-x"></i></c:if>
                                                </div>
                                                <h6 class="mb-0 small fw-bold ${app.status == 'APPLIED' ? 'text-primary' : (app.status == 'REJECTED' ? 'text-danger' : 'text-dark')}">
                                                        ${app.status == 'REJECTED' ? 'Rejected' : 'Under Review'}
                                                </h6>
                                            </div>
                                            <div class="timeline-item">
                                                <div class="timeline-icon ${app.status == 'SHORTLISTED' || app.status == 'SELECTED' ? 'done' : ''}">
                                                    <c:if test="${app.status == 'SHORTLISTED' || app.status == 'SELECTED'}"><i class="bi bi-check"></i></c:if>
                                                </div>
                                                <h6 class="mb-0 small fw-bold ${app.status == 'SHORTLISTED' ? 'text-success' : (app.status == 'SELECTED' ? 'text-success' : 'text-muted')}">
                                                    Shortlisted
                                                </h6>
                                            </div>
                                            <div class="timeline-item">
                                                <div class="timeline-icon ${app.status == 'SELECTED' ? 'done' : ''}">
                                                    <c:if test="${app.status == 'SELECTED'}"><i class="bi bi-check"></i></c:if>
                                                </div>
                                                <h6 class="mb-0 small fw-bold ${app.status == 'SELECTED' ? 'text-success' : 'text-muted'}">
                                                    Selected 🎉
                                                </h6>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

</main>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>