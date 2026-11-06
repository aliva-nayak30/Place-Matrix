<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    if (!"STUDENT".equals(session.getAttribute("role"))) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Company Jobs - HireNest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>body { font-family: 'Inter', sans-serif; background: #f8fafc; }</style>
</head>
<body class="d-flex">
<aside class="bg-dark text-white p-3" style="width: 250px; min-height: 100vh; background-color: #0F172A !important;">
    <h4 class="fw-bold mb-4 text-white"><i class="bi bi-mortarboard-fill text-primary"></i> HireNest</h4>
    <a href="${pageContext.request.contextPath}/student/dashboard" class="d-block text-white text-decoration-none py-2 px-3 mb-2 rounded">Dashboard</a>
    <a href="${pageContext.request.contextPath}/student/eligible-companies" class="d-block bg-primary text-white text-decoration-none py-2 px-3 mb-2 rounded">Eligible Companies</a>
</aside>

<main class="flex-grow-1 p-4">
    <!-- 🔥 Shows the Company Name -->
    <h2 class="fw-bold mb-4">Jobs at ${companyName != null ? companyName : 'Company'}</h2>

    <div class="row g-4">
        <c:forEach items="${jobs}" var="j">
            <div class="col-md-6">
                <div class="card shadow-sm border-0 rounded-4 h-100">
                    <div class="card-body">
                        <h5 class="fw-bold">${j.title}</h5>
                        <p class="text-success fw-bold mb-2">${j.packageLpa} LPA</p>
                        <p class="text-muted small mb-3">
                            <i class="bi bi-calendar-event"></i> Apply By: <fmt:formatDate value="${j.driveDate}" pattern="dd MMM yyyy"/>
                        </p>

                        <c:choose>
                            <c:when test="${appliedJobs.contains(j.id)}">
                                <button class="btn btn-secondary w-100" disabled>Already Applied</button>
                            </c:when>
                            <c:otherwise>
                                <form action="${pageContext.request.contextPath}/student/apply" method="POST">
                                    <input type="hidden" name="companyId" value="${j.id}">
                                    <button type="submit" class="btn btn-primary w-100">Apply Now</button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty jobs}">
            <div class="col-12 text-center text-muted py-5">
                <i class="bi bi-briefcase fs-1"></i>
                <p class="mt-2">No active jobs found for this company.</p>
            </div>
        </c:if>
    </div>
</main>
</body>
</html>