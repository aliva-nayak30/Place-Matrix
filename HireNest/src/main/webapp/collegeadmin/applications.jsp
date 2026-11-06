<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%
    if (!"COLLEGE_ADMIN".equals(session.getAttribute("role"))) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Applications - HireNest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ca-dashboard.css">
</head>
<body>
<header class="ca-topbar">
    <!-- Your Topbar code here -->
</header>

<main class="ca-main">
    <h2 style="font-weight: 700; color: #1e293b; margin-bottom: 20px;">Campus Drives</h2>

    <div class="row g-4">
        <c:forEach items="${drives}" var="d">
            <div class="col-md-4">
                <div class="ca-card p-4 text-center">
                    <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center mx-auto mb-3" style="width: 60px; height: 60px; font-size: 1.5rem; font-weight: bold;">
                            ${fn:substring(d.companyName, 0, 1)}
                    </div>
                    <h4 class="fw-bold">${d.companyName}</h4>
                    <p class="text-muted mb-4">${d.totalApps} Students Applied</p>

                    <!-- Links to a page showing the students for THIS company only -->
                    <a href="${pageContext.request.contextPath}/collegeadmin/drive-details?recruiterId=${d.recruiterId}&companyName=${d.companyName}"
                       class="btn btn-outline-primary w-100 fw-bold">
                        View Applicants <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty drives}">
            <div class="col-12 text-center py-5 text-muted">
                <i class="fas fa-folder-open fs-1 mb-3"></i>
                <h5>No drives have been posted yet.</h5>
            </div>
        </c:if>
    </div>
</main>
</body>
</html>