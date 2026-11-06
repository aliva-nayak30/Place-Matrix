<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
    <title>System Reports - HireNest</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>body { font-family: 'Inter', sans-serif; background-color: #f8fafc; }</style>
</head>
<body class="flex h-screen overflow-hidden">

<!-- Sidebar (Keep your existing sidebar) -->
<aside class="w-64 bg-slate-900 text-slate-300 flex flex-col hidden md:flex">
    <div class="h-16 flex items-center px-6 border-b border-slate-800">
        <i class="fas fa-graduation-cap text-blue-500 text-2xl mr-3"></i>
        <span class="text-white text-xl font-bold tracking-wide">HireNest</span>
    </div>
    <nav class="flex-1 overflow-y-auto py-4">
        <a href="${pageContext.request.contextPath}/superadmin/dashboard" class="flex items-center px-6 py-3 text-sm font-medium hover:bg-slate-800 transition"><i class="fas fa-home w-6"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/superadmin/reports" class="flex items-center px-6 py-3 text-sm font-medium bg-blue-600 text-white"><i class="fas fa-chart-pie w-6"></i> Reports</a>
    </nav>
</aside>

<!-- Main Content -->
<main class="flex-1 flex flex-col overflow-hidden">
    <header class="h-16 bg-white border-b border-gray-200 flex items-center justify-between px-8">
        <h1 class="text-xl font-semibold text-gray-800">System Analytics & Reports</h1>
        <a href="${pageContext.request.contextPath}/superadmin/export-report" class="bg-green-600 hover:bg-green-700 text-white font-bold py-2 px-4 rounded-lg text-sm transition">
            <i class="fas fa-file-excel mr-2"></i> Export Report
        </a>
    </header>

    <div class="flex-1 overflow-y-auto p-8">

        <!-- NEW: Top College Highlight Card -->
        <div class="bg-gradient-to-r from-blue-900 to-indigo-800 rounded-xl p-8 text-white shadow-lg mb-8 flex justify-between items-center relative overflow-hidden">
            <div class="relative z-10">
                <p class="text-blue-200 text-sm font-bold uppercase tracking-wider mb-1">🏆 Highest Package Achieved By</p>
                <h2 class="text-4xl font-extrabold mb-2">${topCollege}</h2>
                <div class="inline-flex items-center bg-white bg-opacity-20 rounded-full px-4 py-1 text-sm font-bold">
                    <i class="fas fa-medal text-yellow-400 mr-2"></i> ${topPackage} LPA
                </div>
            </div>
            <div class="absolute right-0 top-0 opacity-10">
                <i class="fas fa-trophy" style="font-size: 200px; transform: translate(20px, -20px);"></i>
            </div>
        </div>

        <!-- NEW: College Leaderboard Table -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden mb-8">
            <div class="p-6 border-b border-gray-100">
                <h3 class="text-lg font-bold text-gray-800"><i class="fas fa-list-ol text-blue-600 mr-2"></i> College Placement Leaderboard</h3>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                    <tr class="bg-gray-50 text-gray-500 text-xs uppercase tracking-wider border-b">
                        <th class="px-6 py-4 font-bold">Rank</th>
                        <th class="px-6 py-4 font-bold">College Name</th>
                        <th class="px-6 py-4 font-bold text-center">Total Students</th>
                        <th class="px-6 py-4 font-bold text-center">Placed</th>
                        <th class="px-6 py-4 font-bold">Placement Rate</th>
                        <th class="px-6 py-4 font-bold text-right">Highest Package</th>
                    </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                    <c:forEach items="${collegeStats}" var="stat" varStatus="loop">
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-4 text-gray-500 font-bold">#${loop.index + 1}</td>
                            <td class="px-6 py-4 font-bold text-gray-800">${stat.collegeName}</td>
                            <td class="px-6 py-4 text-center font-medium">${stat.totalStudents}</td>
                            <td class="px-6 py-4 text-center text-green-600 font-bold">${stat.placedStudents}</td>
                            <td class="px-6 py-4">
                                <div class="flex items-center gap-2">
                                    <div class="w-full bg-gray-200 rounded-full h-2.5 max-w-[100px]">
                                        <div class="bg-blue-600 h-2.5 rounded-full" style="width: ${stat.placementRate}%"></div>
                                    </div>
                                    <span class="text-xs font-bold text-gray-700">${stat.placementRate}%</span>
                                </div>
                            </td>
                            <td class="px-6 py-4 text-right font-bold text-indigo-600">
                                <c:choose>
                                    <c:when test="${stat.highestPackage > 0}">${stat.highestPackage} LPA</c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Keep your existing Charts below -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <!-- Doughnut Chart -->
            <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
                <h3 class="text-lg font-semibold text-gray-800 mb-4">Placement Statistics</h3>
                <div class="h-64 flex justify-center">
                    <canvas id="placementChart"></canvas>
                </div>
            </div>

            <!-- Bar Chart -->
            <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
                <h3 class="text-lg font-semibold text-gray-800 mb-4">Top 5 Colleges by Students</h3>
                <div class="h-64">
                    <canvas id="collegeChart"></canvas>
                </div>
            </div>
        </div>

    </div>
</main>

<!-- Chart.js Scripts (Keep your existing logic here) -->
<script>
    // Placeholder for your existing Chart.js code
</script>
</body>
</html>