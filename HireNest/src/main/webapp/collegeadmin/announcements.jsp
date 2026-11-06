<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Announcements - HireNest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ca-dashboard.css">
</head>
<body>
<header class="ca-topbar">
    <!-- Add your standard navbar here -->
    <div class="ca-brand"><div class="ca-brand-icon"><i class="fas fa-university"></i></div><div><div class="ca-brand-name">HireNest</div></div></div>
    <nav class="ca-tabs">
        <a href="${pageContext.request.contextPath}/collegeadmin/dashboard" class="ca-tab"><i class="fas fa-chart-line"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/collegeadmin/announcements" class="ca-tab active"><i class="fas fa-bullhorn"></i> Announcements</a>
    </nav>
</header>

<main class="ca-main">
    <h2 style="font-weight: 700; color: #1e293b; margin-bottom: 20px;">Platform Announcements</h2>

    <div class="ca-card">
        <div class="space-y-4">
            <c:forEach items="${announcements}" var="a">
                <div class="p-5 border-l-4 border-blue-500 bg-white shadow-sm rounded-r-lg mb-3">
                    <div class="d-flex justify-content-between align-items-start mb-2">
                        <h4 class="fw-bold text-gray-800 m-0">${a.title}</h4>
                        <span class="text-xs text-muted">${a.date}</span>
                    </div>
                    <p class="text-gray-600 m-0 mt-2">${a.message}</p>
                </div>
            </c:forEach>
            <c:if test="${empty announcements}">
                <div class="text-center text-muted py-4">No announcements yet.</div>
            </c:if>
        </div>
    </div>
</main>
</body>
</html>