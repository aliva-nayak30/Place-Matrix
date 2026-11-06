<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    if (!"COLLEGE_ADMIN".equals(session.getAttribute("role"))) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Users - HireNest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ca-dashboard.css">
</head>
<body>
<!-- Include your College Admin Topbar/Sidebar here -->

<main class="ca-main">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 style="font-weight: 700; color: #1e293b;">Registered Users</h2>
        <a href="${pageContext.request.contextPath}/collegeadmin/dashboard" class="btn btn-outline-secondary btn-sm">Back to Dashboard</a>
    </div>

    <div class="ca-card">
        <div class="table-responsive">
            <table class="ca-table">
                <thead>
                <tr>
                    <th>Name</th>
                    <th>Role</th>
                    <th>Email / Phone</th>
                    <th>Details (Roll No / Company)</th>
                    <th>Status</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${users}" var="u">
                    <tr>
                        <td><strong>${u.name}</strong></td>
                        <td>
                            <span class="badge ${u.role == 'STUDENT' ? 'bg-primary' : 'bg-info text-dark'}">${u.role}</span>
                        </td>
                        <td>
                            <div class="small text-muted">${u.email}</div>
                            <div class="small text-muted">${u.phone}</div>
                        </td>
                        <td>
                            <c:if test="${u.role == 'STUDENT'}">
                                <strong>Roll:</strong> ${u.rollNo} <br>
                                <strong>Branch:</strong> ${u.branch}
                            </c:if>
                            <c:if test="${u.role == 'RECRUITER'}">
                                <strong>Company:</strong> ${u.companyName}
                            </c:if>
                        </td>
                        <td>
                                <span class="badge ${u.isActive ? 'bg-success' : 'bg-warning text-dark'}">
                                        ${u.isActive ? 'ACTIVE' : 'PENDING'}
                                </span>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty users}">
                    <tr><td colspan="5" class="text-center py-4 text-muted">No users registered yet.</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</main>
</body>
</html>