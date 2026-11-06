<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    if (!"STUDENT".equals(session.getAttribute("role"))) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Eligible Companies - HireNest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>body { font-family: 'Inter', sans-serif; background: #f8fafc; }</style>
</head>
<body class="d-flex">
<aside class="bg-dark text-white p-3" style="width: 250px; min-height: 100vh;">
    <h4 class="fw-bold mb-4 text-white"><i class="bi bi-mortarboard-fill text-primary"></i> HireNest</h4>
    <a href="${pageContext.request.contextPath}/student/dashboard" class="d-block text-white text-decoration-none py-2 px-3 mb-2 rounded">Dashboard</a>
    <a href="${pageContext.request.contextPath}/student/eligible-companies" class="d-block bg-primary text-white text-decoration-none py-2 px-3 mb-2 rounded">Eligible Companies</a>
    <a href="${pageContext.request.contextPath}/student/my-applications" class="d-block text-white text-decoration-none py-2 px-3 mb-2 rounded">My Applications</a>
</aside>

<main class="flex-grow-1 p-4">
    <h2 class="fw-bold mb-4">Eligible Company Drives</h2>
    <div class="row g-4">
        <c:forEach items="${companies}" var="c">
            <div class="col-md-4">
                <div class="card shadow-sm border-0 h-100 rounded-4 p-3">
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <!-- 🔥 Logo or fallback letter -->
                        <c:choose>
                            <c:when test="${not empty c.logoUrl}">
                                <img src="${c.logoUrl}" class="rounded-circle object-cover border" style="width: 48px; height: 48px;">
                            </c:when>
                            <c:otherwise>
                                <div class="bg-primary bg-opacity-10 text-primary rounded-circle d-flex align-items-center justify-content-center fw-bold" style="width: 48px; height: 48px; font-size: 1.2rem;">
                                        ${fn:substring(c.companyName, 0, 1)}
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div>
                            <h5 class="fw-bold mb-0">${c.companyName}</h5>
                            <p class="text-muted small mb-0">${c.totalJobs} Active Job Roles</p>
                        </div>
                    </div>
                    <p class="text-muted small mb-3"><i class="bi bi-briefcase-fill me-1"></i> Click below to see all job roles, package and last date for this company.</p>
                    <a href="${pageContext.request.contextPath}/student/company-jobs?recruiterId=${c.recruiterId}&companyName=${c.companyName}" class="btn btn-primary w-100 mt-auto">View Jobs & Apply</a>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty companies}">
            <div class="col-12 text-center text-muted py-5">
                <i class="bi bi-search fs-1"></i>
                <p class="mt-2">No eligible companies found based on your CGPA/Branch.</p>
            </div>
        </c:if>
    </div>
</main>
</body>
</html>