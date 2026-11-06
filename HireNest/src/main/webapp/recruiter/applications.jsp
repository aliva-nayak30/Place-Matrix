<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%
    if (!"RECRUITER".equals(session.getAttribute("role"))) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Applications - HireNest</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>body { font-family: 'Inter', sans-serif; background: #f8fafc; }</style>
</head>
<body class="flex h-screen overflow-hidden">

<aside class="w-64 bg-slate-900 text-white flex flex-col hidden md:flex">
    <!-- Sidebar -->
    <div class="h-16 flex items-center px-6 border-b border-slate-800 font-bold text-xl">
        <i class="fas fa-building text-blue-500 mr-3"></i> HireNest
    </div>
    <nav class="flex-1 py-4 space-y-2 px-4">
        <a href="?page=dashboard" class="block px-4 py-2 hover:bg-slate-800 rounded text-slate-300">Dashboard</a>
        <a href="?page=applications" class="block px-4 py-2 bg-blue-600 rounded text-white font-medium">Applications</a>
    </nav>
</aside>

<main class="flex-1 flex flex-col overflow-hidden">
    <header class="h-16 bg-white border-b flex justify-between items-center px-8 shadow-sm">
        <h1 class="text-xl font-bold text-gray-800">Student Applications</h1>
    </header>

    <div class="flex-1 overflow-y-auto p-8">

        <c:if test="${not empty sessionScope.successMsg}">
            <div class="bg-green-100 text-green-700 p-4 rounded-lg mb-4 flex justify-between items-center">
                <span><i class="bi bi-check-circle"></i> ${sessionScope.successMsg}</span>
                <c:remove var="successMsg" scope="session"/>
            </div>
        </c:if>

        <!-- 🔥 ADVANCED FILTER BAR -->
        <form action="${pageContext.request.contextPath}/recruiter/dashboard" method="GET" class="bg-white p-5 rounded-xl shadow-sm border border-gray-100 mb-6">
            <input type="hidden" name="page" value="applications">
            <div class="grid grid-cols-1 md:grid-cols-5 gap-4">

                <div>
                    <label class="block text-xs font-bold text-gray-500 mb-1">Search Name</label>
                    <input type="text" name="search" value="${param.search}" class="w-full border p-2 rounded-lg text-sm">
                </div>

                <div>
                    <label class="block text-xs font-bold text-gray-500 mb-1">Job Role</label>
                    <select name="jobId" class="w-full border p-2 rounded-lg text-sm">
                        <option value="">All Jobs</option>
                        <c:forEach items="${myJobs}" var="j">
                            <option value="${j.id}" ${param.jobId == j.id ? 'selected' : ''}>${j.title}</option>
                        </c:forEach>
                    </select>
                </div>

                <div>
                    <label class="block text-xs font-bold text-gray-500 mb-1">Branch</label>
                    <select name="branch" class="w-full border p-2 rounded-lg text-sm">
                        <option value="">All Branches</option>
                        <option value="MCA" ${param.branch == 'MCA' ? 'selected' : ''}>MCA</option>
                        <option value="CSE" ${param.branch == 'CSE' ? 'selected' : ''}>CSE</option>
                        <option value="ECE" ${param.branch == 'ECE' ? 'selected' : ''}>ECE</option>
                    </select>
                </div>

                <div>
                    <label class="block text-xs font-bold text-gray-500 mb-1">Min CGPA</label>
                    <input type="number" step="0.1" name="minCgpa" value="${param.minCgpa}" class="w-full border p-2 rounded-lg text-sm">
                </div>

                <div class="flex items-end gap-2">
                    <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded-lg font-bold text-sm w-full"><i class="bi bi-funnel"></i> Filter</button>
                    <a href="?page=applications" class="bg-gray-100 text-gray-600 px-4 py-2 rounded-lg font-bold text-sm">Clear</a>
                </div>
            </div>
        </form>

        <!-- BULK ACTION FORM -->
        <form action="${pageContext.request.contextPath}/recruiter/dashboard" method="POST" id="bulkForm">
            <input type="hidden" name="action" value="bulkUpdate">
            <input type="hidden" name="bulkStatus" id="bulkStatusInput" value="">

            <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">

                <!-- Bulk Buttons & Select All -->
                <div class="p-4 bg-gray-50 border-b flex justify-between items-center">
                    <div class="flex items-center gap-2">
                        <input type="checkbox" id="selectAll" onclick="toggleAll(this)" class="w-4 h-4 cursor-pointer">
                        <label for="selectAll" class="text-sm font-bold text-gray-700 cursor-pointer">Select All Filtered</label>
                    </div>
                    <div class="flex gap-2">
                        <button type="button" onclick="bulkAction('SHORTLISTED')" class="bg-amber-100 text-amber-700 px-3 py-1.5 rounded font-bold text-sm hover:bg-amber-200">Shortlist Selected</button>
                        <button type="button" onclick="bulkAction('REJECTED')" class="bg-red-100 text-red-700 px-3 py-1.5 rounded font-bold text-sm hover:bg-red-200">Reject Selected</button>
                    </div>
                </div>

                <table class="w-full text-left border-collapse">
                    <thead>
                    <tr class="bg-gray-50 text-gray-500 text-xs uppercase border-b">
                        <th class="px-4 py-4 w-10"></th>
                        <th class="px-4 py-4">Student</th>
                        <th class="px-4 py-4">Job Role</th>
                        <th class="px-4 py-4">Resume</th>
                        <th class="px-4 py-4">Status</th>
                        <th class="px-4 py-4 text-right">Single Actions</th>
                    </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                    <c:forEach items="${applications}" var="a">
                        <tr class="hover:bg-gray-50">
                            <td class="px-4 py-4"><input type="checkbox" name="appIds" value="${a.id}" class="app-checkbox w-4 h-4 cursor-pointer"></td>
                            <td class="px-4 py-4">
                                <div class="font-bold text-gray-800">${a.name}</div>
                                <div class="text-xs text-gray-500">${a.branch} | CGPA: ${a.cgpa}</div>
                            </td>
                            <td class="px-4 py-4 text-sm font-medium">${a.jobTitle}</td>
                            <td class="px-4 py-4">
                                <c:if test="${not empty a.resumePath}">
                                    <a href="${pageContext.request.contextPath}/${a.resumePath}" target="_blank" class="text-blue-600 text-sm hover:underline"><i class="bi bi-file-pdf"></i> PDF</a>
                                </c:if>
                            </td>
                            <td class="px-4 py-4"><span class="bg-blue-100 text-blue-700 px-2 py-1 rounded text-xs font-bold">${a.status}</span></td>
                            <td class="px-4 py-4 text-right">
                                <a href="${pageContext.request.contextPath}/recruiter/update-status?applicationId=${a.id}&status=SELECTED" class="bg-green-50 text-green-600 px-3 py-1 rounded text-xs font-bold">Hire</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty applications}">
                        <tr><td colspan="6" class="text-center py-8 text-gray-500">No applications match your filters.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </form>
    </div>
</main>

<script>
    function toggleAll(source) {
        document.querySelectorAll('.app-checkbox').forEach(cb => cb.checked = source.checked);
    }

    function bulkAction(status) {
        const selected = document.querySelectorAll('.app-checkbox:checked');
        if (selected.length === 0) {
            alert('Please select at least one student.');
            return;
        }
        document.getElementById('bulkStatusInput').value = status;
        document.getElementById('bulkForm').submit();
    }
</script>
</body>
</html>