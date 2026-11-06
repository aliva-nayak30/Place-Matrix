<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    if (!"COLLEGE_ADMIN".equals(session.getAttribute("role"))) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>${companyName} Applicants - HireNest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ca-dashboard.css">
</head>
<body>

<main class="ca-main p-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 style="font-weight: 700; color: #1e293b;">${companyName} Applicants</h2>
            <p class="text-muted small mb-0">Filter students by branch to view specific applicants.</p>
        </div>
        <a href="${pageContext.request.contextPath}/collegeadmin/applications" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left"></i> Back to Drives
        </a>
    </div>

    <!-- 🔥 FILTER BAR -->
    <div class="ca-card p-3 mb-4">
        <form action="${pageContext.request.contextPath}/collegeadmin/drive-details" method="GET" class="d-flex align-items-center gap-3">
            <input type="hidden" name="recruiterId" value="${recruiterId}">
            <input type="hidden" name="companyName" value="${companyName}">

            <label class="fw-bold text-muted mb-0">Filter by Branch:</label>
            <select name="branch" class="form-select w-auto" onchange="this.form.submit()">
                <option value="">All Branches</option>
                <option value="MCA" ${branchFilter == 'MCA' ? 'selected' : ''}>MCA</option>
                <option value="BTech CSE" ${branchFilter == 'BTech CSE' ? 'selected' : ''}>BTech CSE</option>
                <option value="BTech ECE" ${branchFilter == 'BTech ECE' ? 'selected' : ''}>BTech ECE</option>
                <option value="BTech ME" ${branchFilter == 'BTech ME' ? 'selected' : ''}>BTech ME</option>
                <option value="MBA" ${branchFilter == 'MBA' ? 'selected' : ''}>MBA</option>
            </select>

            <c:if test="${not empty branchFilter}">
                <a href="${pageContext.request.contextPath}/collegeadmin/drive-details?recruiterId=${recruiterId}&companyName=${companyName}"
                   class="btn btn-sm btn-outline-danger ms-auto">Clear Filter</a>
            </c:if>
        </form>
    </div>

    <!-- APPLICANTS TABLE -->
    <div class="ca-card">
        <div class="table-responsive">
            <table class="ca-table">
                <thead>
                <tr>
                    <th>Student</th>
                    <th>Branch</th>
                    <th>CGPA</th>
                    <th>Job Role</th>
                    <th>Applied On</th>
                    <th>Status</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${applications}" var="a">
                    <tr>
                        <td><strong>${a.studentName}</strong></td>
                        <td><span class="badge bg-light text-dark border">${a.branch}</span></td>
                        <td><span class="badge bg-secondary">${a.cgpa}</span></td>
                        <td>${a.jobTitle}</td>
                        <td><fmt:formatDate value="${a.appliedAt}" pattern="dd MMM yyyy"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${a.status == 'SELECTED'}"><span class="badge bg-success">SELECTED</span></c:when>
                                <c:when test="${a.status == 'REJECTED'}"><span class="badge bg-danger">REJECTED</span></c:when>
                                <c:otherwise><span class="badge bg-primary">${a.status}</span></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty applications}">
                    <tr><td colspan="6" class="text-center py-5 text-muted">
                        <i class="fas fa-users-slash fs-2 mb-3"></i><br>
                        No students found for this branch.
                    </td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</main>
</body>
</html>