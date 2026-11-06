<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    if (!"STUDENT".equals(session.getAttribute("role"))) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>My Interviews - HireNest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>body { font-family: 'Inter', sans-serif; background: #f8fafc; }</style>
</head>
<body class="d-flex">
<!-- Standard Student Sidebar goes here -->

<main class="flex-grow-1 p-4">
    <h2 class="fw-bold mb-4">Scheduled Interviews</h2>
    <div class="row g-4">
        <c:forEach items="${interviews}" var="i">
        <div class="col-md-6">
            <div class="card shadow-sm border-0 rounded-4 p-4 h-100">
                <div class="d-flex justify-content-between align-items-start mb-3">
                    <h5 class="fw-bold mb-0">${i.company}</h5>
                    <span class="badge bg-primary">${i.mode}</span>
                </div>
                <p class="text-muted mb-2">Role: <strong>${i.title}</strong></p>
                <div class="bg-light p-3 rounded-3 mt-auto">
                    <div class="mb-2"><i class="bi bi-calendar-event text-danger me-2"></i> <fmt:formatDate value="${i.date}" pattern="dd MMM yyyy"/></p>
                        <div class="mb-2"><i class="bi bi-clock text-danger me-2"></i> ${i.time}</div>
                        <div><i class="bi bi-camera-video text-danger me-2"></i> <a href="${i.link}" target="_blank">Join Meeting</a></div>
                    </div>
                </div>
            </div>
            </c:forEach>
            <c:if test="${empty interviews}">
                <div class="col-12 text-center py-5 text-muted">
                    <i class="bi bi-calendar-x fs-1"></i><br>No interviews scheduled yet.
                </div>
            </c:if>
        </div>
</main>
</body>
</html>