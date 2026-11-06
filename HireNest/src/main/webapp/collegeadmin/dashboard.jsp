<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>College Dashboard - HireNest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; overflow-x: hidden; }

        /* Teal Sidebar */
        .sidebar { width: 260px; background-color: #0F172A; color: #94a3b8; position: fixed; height: 100vh; top: 0; left: 0; z-index: 1000; padding-top: 1rem; border-right: 1px solid #1e293b; }
        .sidebar-brand { color: white; font-size: 1.5rem; font-weight: 700; padding: 1rem 1.5rem; display: flex; align-items: center; gap: 10px; margin-bottom: 1rem; }
        .sidebar-brand i { color: #0d9488; }
        .nav-item { margin: 0.25rem 1rem; }
        .nav-link { color: #94a3b8; border-radius: 8px; padding: 0.75rem 1rem; font-weight: 500; display: flex; align-items: center; gap: 12px; transition: all 0.2s; text-decoration: none; }
        .nav-link:hover, .nav-link.active { background-color: rgba(255, 255, 255, 0.1); color: white; }
        .nav-link.active { background-color: #0d9488; color: white; }

        .main-content { margin-left: 260px; padding: 2rem; min-height: 100vh; }
        .top-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; background: rgba(255, 255, 255, 0.7); backdrop-filter: blur(10px); padding: 1rem 1.5rem; border-radius: 16px; border: 1px solid rgba(255, 255, 255, 0.5); box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05); }

        .glass-card { background: rgba(255, 255, 255, 0.7); backdrop-filter: blur(10px); border: 1px solid rgba(255, 255, 255, 0.5); border-radius: 16px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05); padding: 1.5rem; height: 100%; }

        .stat-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; }

        /* NEW: Top Tabs - your ca-tab style */
        .ca-tab { display: inline-flex; align-items: center; gap: 8px; padding: 0.5rem 1rem; border-radius: 999px; background: white; border: 1px solid #e2e8f0; color: #334155; font-weight: 600; font-size: 0.9rem; text-decoration: none; }
        .ca-tab:hover { background: #f0fdfa; color: #0f766e; border-color: #0d9488; }
    </style>
</head>
<body>

<aside class="sidebar">
    <div class="sidebar-brand"><i class="bi bi-bank"></i> HireNest</div>
    <ul class="nav flex-column mt-3">
        <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/collegeadmin/dashboard"><i class="bi bi-grid-1x2-fill"></i> Dashboard</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/collegeadmin/pending-approvals"><i class="bi bi-person-check-fill"></i> Approvals</a></li>
        <!-- NEW: Added in sidebar -->
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/collegeadmin/users"><i class="bi bi-people-fill"></i> All Users</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/collegeadmin/students"><i class="bi bi-mortarboard-fill"></i> Students</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/collegeadmin/companies"><i class="bi bi-building"></i> Companies</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/collegeadmin/applications"><i class="bi bi-file-earmark-text-fill"></i> Applications</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/collegeadmin/leaderboard"><i class="bi bi-trophy-fill"></i> Leaderboard</a></li>
        <li class="nav-item mt-5"><a class="nav-link text-danger" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
    </ul>
</aside>

<main class="main-content">

    <!-- NEW: Added on TOP of dashboard, your All Users link -->
    <div class="d-flex gap-2 mb-3">
        <a href="${pageContext.request.contextPath}/collegeadmin/users" class="ca-tab">
            <i class="bi bi-people-fill"></i> All Users
        </a>
        <a href="${pageContext.request.contextPath}/collegeadmin/students" class="ca-tab">
            <i class="bi bi-mortarboard-fill"></i> Students
        </a>
        <a href="${pageContext.request.contextPath}/collegeadmin/companies" class="ca-tab">
            <i class="bi bi-building"></i> Companies
        </a>
    </div>

    <!-- ANNOUNCEMENTS BANNER (Only visible to College Admin, Only for this college) -->
    <c:if test="${not empty announcements}">
        <div class="mb-4">
            <c:forEach items="${announcements}" var="ann">
                <div class="alert shadow-sm border-0 d-flex align-items-start mb-2"
                     style="background-color: #eff6ff; border-left: 5px solid #3b82f6;">
                    <i class="bi bi-megaphone-fill text-primary mt-1 me-3" style="font-size: 1.2rem;"></i>
                    <div>
                        <h6 class="fw-bold mb-1 text-dark">${ann.title}</h6>
                        <p class="mb-0 text-muted small">${ann.message}</p>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>

    <header class="top-header">
        <div>
            <h2 class="h4 fw-bold mb-1" style="color:#0f766e;">Welcome back, ${sessionScope.userName}</h2>
            <p class="text-muted small mb-0">Manage placements for <strong>${sessionScope.collegeName}</strong></p>
        </div>
        <div class="d-flex align-items-center gap-3">
            <a href="${pageContext.request.contextPath}/collegeadmin/invites" class="btn btn-sm btn-outline-dark fw-bold"><i class="bi bi-link-45deg"></i> Invites</a>
            <div class="bg-teal-100 rounded-circle d-flex align-items-center justify-content-center fw-bold" style="width: 42px; height: 42px; background:#ccfbf1; color:#0f766e;">
                ${fn:substring(sessionScope.userName, 0, 1)}
            </div>
        </div>
    </header>

    <div class="row g-4 mb-4">
        <div class="col-md-3">
            <div class="glass-card d-flex align-items-center gap-3">
                <div class="stat-icon bg-primary bg-opacity-10 text-primary"><i class="bi bi-people-fill"></i></div>
                <div>
                    <h6 class="text-muted mb-1">Total Students</h6>
                    <h4 class="mb-0 fw-bold">${empty stats.totalStudents ? 0 : stats.totalStudents}</h4>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="glass-card d-flex align-items-center gap-3">
                <div class="stat-icon bg-warning bg-opacity-10 text-warning"><i class="bi bi-hourglass-split"></i></div>
                <div>
                    <h6 class="text-muted mb-1">Pending Approvals</h6>
                    <h4 class="mb-0 fw-bold">${empty stats.pendingStudents ? 0 : stats.pendingStudents}</h4>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="glass-card d-flex align-items-center gap-3">
                <div class="stat-icon bg-success bg-opacity-10 text-success"><i class="bi bi-trophy-fill"></i></div>
                <div>
                    <h6 class="text-muted mb-1">Placed Students</h6>
                    <h4 class="mb-0 fw-bold">${empty stats.placedStudents ? 0 : stats.placedStudents}</h4>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="glass-card d-flex align-items-center gap-3">
                <div class="stat-icon bg-info bg-opacity-10 text-info"><i class="bi bi-building"></i></div>
                <div>
                    <h6 class="text-muted mb-1">Companies</h6>
                    <h4 class="mb-0 fw-bold">${empty stats.totalCompanies ? 0 : stats.totalCompanies}</h4>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-md-8">
            <div class="glass-card">
                <h5 class="fw-bold mb-4">Branch-wise Placement %</h5>
                <div style="height: 300px;"><canvas id="branchChart"></canvas></div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="glass-card">
                <h5 class="fw-bold mb-4">Student Status</h5>
                <div style="height: 300px;"><canvas id="studentStatusChart"></canvas></div>
            </div>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // Branch Chart
    const branchLabels = [<c:forEach items="${branchStats}" var="e" varStatus="s">"${e.key}"<c:if test="${!s.last}">,</c:if></c:forEach>];
    const branchValues = [<c:forEach items="${branchStats}" var="e" varStatus="s">${e.value}<c:if test="${!s.last}">,</c:if></c:forEach>];
    if (branchLabels.length > 0) {
        new Chart(document.getElementById('branchChart'), {
            type: 'bar',
            data: { labels: branchLabels, datasets: [{ label: 'Placement %', data: branchValues, backgroundColor: '#0d9488', borderRadius: 6 }] },
            options: { responsive: true, maintainAspectRatio: false, scales: { y: { beginAtZero: true, max: 100 } } }
        });
    }

    // Status Chart
    const placed = ${empty stats.placedStudents ? 0 : stats.placedStudents};
    const unplaced = ${empty stats.totalStudents ? 0 : stats.totalStudents} - placed;
    new Chart(document.getElementById('studentStatusChart'), {
        type: 'doughnut',
        data: { labels: ['Placed', 'Unplaced'], datasets: [{ data: [placed, unplaced], backgroundColor: ['#10b981', '#e2e8f0'], cutout: '70%' }] },
        options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'bottom' } } }
    });
</script>
</body>
</html>