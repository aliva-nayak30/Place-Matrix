<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    if (!"COLLEGE_ADMIN".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Companies - HireNest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ca-dashboard.css">
</head>
<body>

<header class="ca-topbar">
    <div class="ca-brand">
        <div class="ca-brand-icon"><i class="fas fa-university"></i></div>
        <div><div class="ca-brand-name">HireNest</div><div class="ca-brand-sub">${sessionScope.collegeName}</div></div>
    </div>
    <nav class="ca-tabs">
        <a href="${pageContext.request.contextPath}/collegeadmin/dashboard" class="ca-tab"><i class="fas fa-chart-line"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/collegeadmin/pending-approvals" class="ca-tab"><i class="fas fa-user-clock"></i> Approvals</a>
        <a href="${pageContext.request.contextPath}/collegeadmin/companies" class="ca-tab active"><i class="fas fa-building"></i> Companies</a>
        <a href="${pageContext.request.contextPath}/collegeadmin/applications" class="ca-tab"><i class="fas fa-file-alt"></i> Applications</a>
    </nav>
    <div class="ca-user">
        <div class="ca-avatar">${fn:substring(sessionScope.userName, 0, 1)}</div>
        <div class="ca-user-info"><div class="ca-user-name">${sessionScope.userName}</div><div class="ca-user-role">College Admin</div></div>
        <a href="${pageContext.request.contextPath}/logout" class="ca-logout"><i class="fas fa-sign-out-alt"></i></a>
    </div>
</header>

<main class="ca-main">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 style="font-weight: 700; color: #1e293b; margin: 0;">Campus Companies & Drives</h2>
            <p class="text-muted small mb-0">Track companies that have visited your campus and manage their active status.</p>
        </div>
    </div>

    <!-- Flash Messages -->
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

    <div class="ca-card">
        <div class="table-responsive">
            <table class="ca-table">
                <thead>
                <tr>
                    <th>Company Name</th>
                    <th>HR Name / Contact</th>
                    <th>Active Jobs Posted</th>
                    <th>Applications Received</th>
                    <th>Status</th>
                    <th class="text-end">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${companies}" var="c">
                    <tr>
                        <td>
                            <div class="d-flex align-items-center">
                                <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 40px; height: 40px; font-weight: bold;">
                                        ${fn:substring(c.companyName, 0, 1)}
                                </div>
                                <strong>${c.companyName}</strong>
                            </div>
                        </td>
                        <td>
                            <div class="small text-dark">${c.hrName}</div>
                            <div class="small text-muted">${c.hrEmail}</div>
                        </td>
                        <td>
                            <span class="badge bg-info text-dark" style="font-size: 14px;">${c.totalJobs} Jobs</span>
                        </td>
                        <td>
                            <span class="badge bg-success" style="font-size: 14px;">${c.totalApps} Apps</span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${c.isArchived}">
                                    <span class="badge bg-secondary">ARCHIVED</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-primary">ACTIVE</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-end">
                            <c:if test="${!c.isArchived}">
                                <form action="${pageContext.request.contextPath}/collegeadmin/companies" method="POST" style="display:inline;" onsubmit="return confirm('Are you sure you want to archive this company? Their jobs will no longer be visible to students.');">
                                    <!-- 🔥 CRITICAL: This tells the Controller what to do -->
                                    <input type="hidden" name="action" value="archive">
                                    <input type="hidden" name="recruiterId" value="${c.recruiterId}">
                                    <button type="submit" class="btn btn-sm btn-outline-danger fw-bold">
                                        <i class="fas fa-archive"></i> Archive Drive
                                    </button>
                                </form>
                            </c:if>
                            <c:if test="${c.isArchived}">
                                <span class="text-muted small">Drive completed</span>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty companies}">
                    <tr><td colspan="6" class="text-center text-muted py-5">
                        <i class="fas fa-building text-secondary mb-3" style="font-size: 3rem;"></i>
                        <h5>No companies have registered yet.</h5>
                        <p class="small mb-0">Once a Recruiter posts a job, they will appear here.</p>
                    </td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>