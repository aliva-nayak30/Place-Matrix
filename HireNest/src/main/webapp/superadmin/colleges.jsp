<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    if (!"SUPER_ADMIN".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Colleges - HireNest</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>body { font-family: 'Inter', sans-serif; background-color: #f8fafc; }</style>
</head>
<body class="flex h-screen overflow-hidden">

<aside class="w-64 bg-slate-900 text-slate-300 flex flex-col hidden md:flex">
    <div class="h-16 flex items-center px-6 border-b border-slate-800">
        <i class="fas fa-graduation-cap text-blue-500 text-2xl mr-3"></i>
        <span class="text-white text-xl font-bold tracking-wide">HireNest</span>
    </div>
    <nav class="flex-1 overflow-y-auto py-4">
        <a href="${pageContext.request.contextPath}/superadmin/dashboard" class="flex items-center px-6 py-3 text-sm font-medium hover:bg-slate-800 transition"><i class="fas fa-home w-6"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/superadmin/college-admins" class="flex items-center px-6 py-3 text-sm font-medium hover:bg-slate-800 transition"><i class="fas fa-user-shield w-6"></i> College Admins</a>
        <a href="${pageContext.request.contextPath}/superadmin/colleges" class="flex items-center px-6 py-3 text-sm font-medium bg-blue-600 text-white"><i class="fas fa-university w-6"></i> Colleges</a>
        <a href="${pageContext.request.contextPath}/superadmin/students" class="flex items-center px-6 py-3 text-sm font-medium hover:bg-slate-800 transition"><i class="fas fa-user-graduate w-6"></i> Students</a>
        <a href="${pageContext.request.contextPath}/superadmin/recruiters" class="flex items-center px-6 py-3 text-sm font-medium hover:bg-slate-800 transition"><i class="fas fa-building w-6"></i> Recruiters</a>
        <a href="${pageContext.request.contextPath}/superadmin/reports" class="flex items-center px-6 py-3 text-sm font-medium hover:bg-slate-800 transition"><i class="fas fa-chart-pie w-6"></i> Reports</a>
        <a href="${pageContext.request.contextPath}/superadmin/announcements" class="flex items-center px-6 py-3 text-sm font-medium hover:bg-slate-800 transition"><i class="fas fa-bullhorn w-6"></i> Announcements</a>
    </nav>
    <div class="border-t border-slate-800 p-4">
        <a href="${pageContext.request.contextPath}/logout" class="flex items-center px-4 py-2 text-sm font-medium text-red-400 hover:text-red-300 transition"><i class="fas fa-sign-out-alt w-6"></i> Logout</a>
    </div>
</aside>

<main class="flex-1 flex flex-col overflow-hidden">
    <header class="h-16 bg-white border-b border-gray-200 flex items-center justify-between px-8">
        <h1 class="text-xl font-semibold text-gray-800">Registered Colleges</h1>
    </header>
    <div class="flex-1 overflow-y-auto p-8">
        <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
            <table class="w-full text-left border-collapse">
                <thead>
                <tr class="bg-gray-50 text-gray-500 text-sm uppercase border-b">
                    <th class="px-6 py-4">College Name</th>
                    <th class="px-6 py-4">Code</th>
                    <th class="px-6 py-4">Location</th>
                    <th class="px-6 py-4">Status</th>
                    <th class="px-6 py-4 text-right">Actions</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                <c:forEach items="${colleges}" var="c">
                    <tr class="hover:bg-gray-50">
                        <td class="px-6 py-4 text-sm font-medium text-gray-800">${c.collegeName}</td>
                        <td class="px-6 py-4 text-sm text-gray-500">${c.collegeCode}</td>
                        <td class="px-6 py-4 text-sm text-gray-500">${c.location}</td>
                        <td class="px-6 py-4">
                            <c:choose>
                                <c:when test="${c.active}"><span class="bg-green-100 text-green-700 px-2 py-1 rounded text-xs font-bold">ACTIVE</span></c:when>
                                <c:otherwise><span class="bg-red-100 text-red-700 px-2 py-1 rounded text-xs font-bold">INACTIVE</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td class="px-6 py-4 text-right">
                            <form action="${pageContext.request.contextPath}/superadmin/toggle-college" method="POST" class="inline">
                                <input type="hidden" name="collegeId" value="${c.id}">
                                <input type="hidden" name="active" value="${!c.active}">
                                <button type="submit" class="px-3 py-1 rounded text-sm font-medium transition ${c.active ? 'bg-red-50 text-red-600 hover:bg-red-100' : 'bg-green-50 text-green-600 hover:bg-green-100'}">
                                        ${c.active ? 'Disable' : 'Enable'}
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</main>
</body>
</html>