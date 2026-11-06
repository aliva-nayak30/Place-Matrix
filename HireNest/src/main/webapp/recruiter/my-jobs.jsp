<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    if (!"RECRUITER".equals(session.getAttribute("role"))) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>My Jobs - HireNest</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>body { font-family: 'Inter', sans-serif; background: #f8fafc; }</style>
</head>
<body class="flex h-screen overflow-hidden">
<!-- SIDEBAR (Paste same sidebar here) -->
<aside class="w-64 bg-slate-900 text-slate-300 flex flex-col hidden md:flex">
    <nav class="flex-1 py-4 space-y-2 px-4 mt-16">
        <a href="?page=dashboard" class="block px-4 py-2 hover:bg-slate-800 rounded text-slate-300"><i class="bi bi-grid-1x2-fill mr-2"></i> Dashboard</a>
        <a href="?page=post-job" class="block px-4 py-2 hover:bg-slate-800 rounded text-slate-300"><i class="bi bi-plus-circle-fill mr-2"></i> Post Job</a>
        <a href="?page=my-jobs" class="block px-4 py-2 bg-blue-600 text-white rounded font-medium"><i class="bi bi-briefcase-fill mr-2"></i> My Jobs</a>
        <a href="?page=applications" class="block px-4 py-2 hover:bg-slate-800 rounded text-slate-300"><i class="bi bi-people-fill mr-2"></i> Applications</a>
    </nav>
</aside>

<main class="flex-1 flex flex-col overflow-hidden">
    <header class="h-16 bg-white border-b flex items-center px-8 shadow-sm">
        <h1 class="text-xl font-bold text-gray-800">My Posted Jobs</h1>
    </header>

    <div class="flex-1 overflow-y-auto p-8">
        <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
            <table class="w-full text-left border-collapse">
                <thead>
                <tr class="bg-gray-50 text-gray-500 text-xs uppercase border-b">
                    <th class="px-6 py-4">Job Title</th>
                    <th class="px-6 py-4">Type</th>
                    <th class="px-6 py-4">Salary</th>
                    <th class="px-6 py-4">Last Date</th>
                    <th class="px-6 py-4">Status</th>
                    <th class="px-6 py-4">Actions</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                <c:forEach items="${jobs}" var="j">
                    <tr class="hover:bg-gray-50">
                        <td class="px-6 py-4 font-bold text-gray-800">${j.title}</td>
                        <td class="px-6 py-4 text-sm">${j.jobType}</td>
                        <td class="px-6 py-4 font-bold text-green-600">${j.salary} LPA</td>
                        <td class="px-6 py-4 text-sm text-gray-500"><fmt:formatDate value="${j.lastDate}" pattern="dd MMM yyyy"/></td>
                        <td class="px-6 py-4"><span class="bg-green-100 text-green-700 px-2 py-1 rounded text-xs font-bold">${j.status}</span></td>
                        <td class="px-6 py-4">
                            <a href="${pageContext.request.contextPath}/recruiter/download-csv?jobId=${j.id}" class="inline-flex items-center gap-1 bg-green-600 hover:bg-green-700 text-white text-xs font-bold px-3 py-1.5 rounded">
                                <i class="bi bi-download"></i> Download CSV
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty jobs}"><tr><td colspan="6" class="text-center py-8 text-gray-500">No jobs posted yet.</td></tr></c:if>
                </tbody>
            </table>
        </div>
    </div>
</main>
</body>
</html>