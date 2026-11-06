<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    if (!"RECRUITER".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Recruiter Dashboard - HireNest</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>body { font-family: 'Inter', sans-serif; background: #f8fafc; }</style>
</head>
<body class="flex h-screen overflow-hidden">

<!-- Sidebar -->
<aside class="w-64 bg-slate-900 text-white flex flex-col hidden md:flex">
    <div class="h-16 flex items-center px-6 border-b border-slate-800 font-bold text-xl">
        <i class="fas fa-building text-blue-500 mr-3"></i> HireNest
    </div>
    <nav class="flex-1 py-4 space-y-2 px-4">
        <a href="${pageContext.request.contextPath}/recruiter/dashboard?page=dashboard" class="block px-4 py-2 bg-blue-600 rounded text-white font-medium">
            <i class="fas fa-chart-line mr-2"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/recruiter/dashboard?page=post-job" class="block px-4 py-2 hover:bg-slate-800 rounded text-slate-300">
            <i class="fas fa-plus-circle mr-2"></i> Post Job
        </a>
        <a href="${pageContext.request.contextPath}/recruiter/dashboard?page=my-jobs" class="block px-4 py-2 hover:bg-slate-800 rounded text-slate-300">
            <i class="fas fa-briefcase mr-2"></i> My Jobs
        </a>
        <a href="${pageContext.request.contextPath}/recruiter/dashboard?page=applications" class="block px-4 py-2 hover:bg-slate-800 rounded text-slate-300">
            <i class="fas fa-users mr-2"></i> Applications
        </a>
        <a href="${pageContext.request.contextPath}/recruiter/dashboard?page=profile" class="block px-4 py-2 hover:bg-slate-800 rounded text-slate-300">
            <i class="fas fa-building mr-2"></i> Company Profile
        </a>
    </nav>
    <div class="p-4 border-t border-slate-800">
        <a href="${pageContext.request.contextPath}/logout" class="block px-4 py-2 text-red-400 hover:bg-slate-800 rounded">
            <i class="fas fa-sign-out-alt mr-2"></i> Logout
        </a>
    </div>
</aside>

<!-- Main Content -->
<main class="flex-1 flex flex-col overflow-hidden">
    <header class="h-16 bg-white border-b flex justify-between items-center px-8 shadow-sm">
        <h1 class="text-xl font-bold text-gray-800">Recruiter Dashboard</h1>
        <div class="flex items-center space-x-3">
            <span class="text-sm text-gray-500 font-medium">Welcome, <strong>${sessionScope.userName}</strong></span>
            <div class="h-9 w-9 bg-blue-100 text-blue-700 rounded-full flex items-center justify-center font-bold">
                ${fn:substring(sessionScope.userName, 0, 1)}
            </div>
        </div>
    </header>

    <div class="flex-1 overflow-y-auto p-8">
        <!-- Stat Cards -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
            <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100 flex items-center gap-4">
                <div class="h-12 w-12 bg-blue-50 text-blue-600 rounded-lg flex items-center justify-center text-2xl"><i class="fas fa-briefcase"></i></div>
                <div><p class="text-sm text-gray-500">Total Jobs</p><h3 class="text-2xl font-bold">${stats.totalJobs}</h3></div>
            </div>
            <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100 flex items-center gap-4">
                <div class="h-12 w-12 bg-purple-50 text-purple-600 rounded-lg flex items-center justify-center text-2xl"><i class="fas fa-users"></i></div>
                <div><p class="text-sm text-gray-500">Applications</p><h3 class="text-2xl font-bold">${stats.totalApps}</h3></div>
            </div>
            <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100 flex items-center gap-4">
                <div class="h-12 w-12 bg-amber-50 text-amber-600 rounded-lg flex items-center justify-center text-2xl"><i class="fas fa-star"></i></div>
                <div><p class="text-sm text-gray-500">Shortlisted</p><h3 class="text-2xl font-bold">${stats.shortlisted}</h3></div>
            </div>
            <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100 flex items-center gap-4">
                <div class="h-12 w-12 bg-green-50 text-green-600 rounded-lg flex items-center justify-center text-2xl"><i class="fas fa-trophy"></i></div>
                <div><p class="text-sm text-gray-500">Hired</p><h3 class="text-2xl font-bold">${stats.hired}</h3></div>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <!-- Recent Applications -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                <h3 class="text-lg font-bold text-gray-800 mb-4">Recent Applications</h3>
                <table class="w-full text-left border-collapse">
                    <thead>
                    <tr class="text-gray-400 text-xs uppercase border-b">
                        <th class="pb-2">Student</th>
                        <th class="pb-2">Job</th>
                        <th class="pb-2 text-right">Status</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${recentApps}" var="app">
                        <tr class="border-b last:border-0">
                            <td class="py-3">
                                <div class="text-sm font-bold text-gray-800">${app.studentName}</div>
                                <div class="text-xs text-gray-500">${app.branch}</div>
                            </td>
                            <td class="py-3 text-sm text-gray-600">${app.jobTitle}</td>
                            <td class="py-3 text-right">
                                <span class="badge ${app.status == 'SELECTED' ? 'bg-success' : (app.status == 'REJECTED' ? 'bg-danger' : 'bg-primary')}">${app.status}</span>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty recentApps}">
                        <tr><td colspan="3" class="text-center text-gray-500 py-4 text-sm">No applications yet.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

            <!-- Upcoming Interviews (FIXED: changed var="int" to var="i") -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                <h3 class="text-lg font-bold text-gray-800 mb-4">Upcoming Interviews</h3>
                <div class="space-y-3">
                    <c:forEach items="${upcomingInterviews}" var="i">
                        <div class="p-3 bg-gray-50 rounded-lg border border-gray-100 flex justify-between items-center">
                            <div>
                                <div class="text-sm font-bold text-gray-800">${i.studentName}</div>
                                <div class="text-xs text-gray-500">${i.jobTitle} | ${i.mode}</div>
                            </div>
                            <div class="text-right">
                                <div class="text-sm font-bold text-blue-600"><fmt:formatDate value="${i.date}" pattern="dd MMM"/></div>
                                <div class="text-xs text-gray-500">${i.time}</div>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty upcomingInterviews}">
                        <div class="text-center text-gray-500 py-4 text-sm">No upcoming interviews.</div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</main>
</body>
</html>