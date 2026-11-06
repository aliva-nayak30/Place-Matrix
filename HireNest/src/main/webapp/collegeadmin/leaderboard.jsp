<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Leaderboard - HireNest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ca-dashboard.css">
</head>
<body>
<header class="ca-topbar">
    <!-- COPY NAVBAR FROM dashboard.jsp HERE -->
    <div class="ca-brand">
        <div class="ca-brand-icon"><i class="fas fa-university"></i></div>
        <div><div class="ca-brand-name">HireNest</div><div class="ca-brand-sub">${sessionScope.collegeName}</div></div>
    </div>
    <nav class="ca-tabs">
        <a href="${pageContext.request.contextPath}/collegeadmin/dashboard" class="ca-tab"><i class="fas fa-chart-line"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/collegeadmin/leaderboard" class="ca-tab active"><i class="fas fa-trophy"></i> Leaderboard</a>
    </nav>
    <div class="ca-user">
        <div class="ca-avatar">${fn:substring(sessionScope.userName, 0, 1)}</div>
        <div class="ca-user-info"><div class="ca-user-name">${sessionScope.userName}</div><div class="ca-user-role">College Admin</div></div>
    </div>
</header>

<main class="ca-main">
    <h2 style="font-weight: 700; color: #1e293b; margin-bottom: 20px;"><i class="fas fa-crown text-warning"></i> Top 10 Placed Students</h2>

    <div class="ca-card">
        <div class="table-responsive">
            <table class="ca-table">
                <thead>
                <tr>
                    <th>Rank</th>
                    <th>Student Name</th>
                    <th>Branch</th>
                    <th>CGPA</th>
                    <th>Company</th>
                    <th>Package</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${leaderboard}" var="l" varStatus="status">
                    <tr>
                        <td><strong>#${status.count}</strong></td>
                        <td>${l.name}</td>
                        <td>${l.branch}</td>
                        <td>${l.cgpa}</td>
                        <td><span class="badge bg-primary">${l.company}</span></td>
                        <td><span class="badge bg-success" style="font-size: 14px;">${l.packageLpa} LPA</span></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty leaderboard}">
                    <tr><td colspan="6" class="text-center text-muted py-4">No placements recorded yet.</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</main>
</body>
</html>