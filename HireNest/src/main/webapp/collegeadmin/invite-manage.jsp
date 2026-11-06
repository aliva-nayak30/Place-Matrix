<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    if (!"COLLEGE_ADMIN".equals(session.getAttribute("role"))) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Manage Invites - HireNest</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>body { font-family: 'Inter', sans-serif; background: #f8fafc; }</style>
</head>
<body class="flex h-screen overflow-hidden">
<!-- Include your College Admin Sidebar here (omitted for brevity, copy from dashboard) -->
<aside class="w-64 bg-slate-900 text-white flex flex-col hidden md:flex">
    <div class="h-16 flex items-center px-6 border-b border-slate-800 font-bold text-xl">HireNest</div>
    <nav class="flex-1 py-4 space-y-2 px-4">
        <a href="${pageContext.request.contextPath}/collegeadmin/dashboard" class="block px-4 py-2 hover:bg-slate-800 rounded">Dashboard</a>
        <a href="${pageContext.request.contextPath}/collegeadmin/invites" class="block px-4 py-2 bg-teal-600 rounded text-white font-medium">Manage Invites</a>
        <a href="${pageContext.request.contextPath}/collegeadmin/companies" class="block px-4 py-2 hover:bg-slate-800 rounded">Companies</a>
        <a href="${pageContext.request.contextPath}/collegeadmin/applications" class="block px-4 py-2 hover:bg-slate-800 rounded">Applications</a>
    </nav>
</aside>

<main class="flex-1 flex flex-col overflow-hidden">
    <header class="h-16 bg-white border-b flex justify-between items-center px-8 shadow-sm">
        <h1 class="text-xl font-bold text-gray-800">Manage Invite Links</h1>
    </header>

    <div class="flex-1 overflow-y-auto p-8">
        <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100 mb-6">
            <div class="mb-5">
                <h2 class="text-lg font-bold text-gray-800">Generate New Link</h2>
                <p class="text-sm text-gray-500">Create a link for students to join your college.</p>
            </div>

            <c:if test="${not empty sessionScope.successMsg}">
                <div class="bg-green-100 text-green-700 p-4 rounded-lg mb-5">
                    <i class="fas fa-check-circle"></i> ${sessionScope.successMsg}
                    <c:remove var="successMsg" scope="session"/>
                </div>
            </c:if>
            <c:if test="${not empty sessionScope.errorMsg}">
                <div class="bg-red-100 text-red-700 p-4 rounded-lg mb-5">
                    <i class="fas fa-exclamation-circle"></i> ${sessionScope.errorMsg}
                    <c:remove var="errorMsg" scope="session"/>
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/collegeadmin/invites" class="grid grid-cols-1 md:grid-cols-4 gap-4 items-end">
                <!-- CRITICAL: This tells the controller to generate a token -->
                <input type="hidden" name="action" value="create">

                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Role</label>
                    <select name="role" class="w-full border p-2.5 rounded-lg focus:ring-2 focus:ring-teal-500 bg-white" required>
                        <option value="STUDENT" selected>Student</option>
                        <option value="RECRUITER">Recruiter</option>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Max Uses</label>
                    <input type="number" name="maxUses" value="100" min="1" class="w-full border p-2.5 rounded-lg focus:ring-2 focus:ring-teal-500" required>
                </div>

                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-2">Days Valid</label>
                    <input type="number" name="daysValid" value="7" min="1" class="w-full border p-2.5 rounded-lg focus:ring-2 focus:ring-teal-500" required>
                </div>

                <div>
                    <button type="submit" class="w-full bg-teal-600 hover:bg-teal-700 text-white px-6 py-2.5 rounded-lg font-medium transition">
                        <i class="fas fa-plus mr-2"></i> Generate Code
                    </button>
                </div>
            </form>
        </div>

        <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
            <table class="w-full text-left border-collapse">
                <thead>
                <tr class="bg-gray-50 text-gray-500 text-sm uppercase border-b">
                    <th class="px-6 py-4">Code</th>
                    <th class="px-6 py-4">Expiry Date</th>
                    <th class="px-6 py-4">Status</th>
                    <th class="px-6 py-4 text-right">Copy Link</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                <c:forEach items="${invites}" var="i">
                    <tr class="hover:bg-gray-50">
                        <td class="px-6 py-4 font-mono font-bold text-teal-700 break-all">
                            <!-- Full clickable link -->
                            <a href="${pageContext.request.contextPath}/join?token=${i.code}" target="_blank" class="text-blue-600 hover:underline">
                                    ${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/join?token=${i.code}
                            </a>
                        </td>
                        <td class="px-6 py-4 text-sm text-gray-600">${i.expiry}</td>
                        <td class="px-6 py-4">
                            <span class="bg-green-100 text-green-700 px-2 py-1 rounded text-xs font-bold">ACTIVE</span>
                        </td>
                        <td class="px-6 py-4 text-right">
                            <button onclick="copyLink('${i.code}')" class="bg-gray-100 hover:bg-gray-200 text-gray-700 px-4 py-2 rounded-lg text-sm font-medium transition">
                                <i class="fas fa-copy mr-1"></i> Copy
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</main>
<script>
    function copyLink(code) {
        const url = window.location.origin + '${pageContext.request.contextPath}/join?token=' + code;
        navigator.clipboard.writeText(url);
        alert('Link Copied:\n' + url);
    }
</script>
</body>
</html>