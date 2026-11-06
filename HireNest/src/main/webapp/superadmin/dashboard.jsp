<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    // Session check for SUPER_ADMIN
    String userRole = (String) session.getAttribute("role");
    if (!"SUPER_ADMIN".equals(userRole)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Super Admin Dashboard - HireNest</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; }
        .sidebar-item:hover { background-color: rgba(255, 255, 255, 0.1); }
        .sidebar-item.active { background-color: #2563eb; color: white; }
        .card-shadow { box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03); }
    </style>
</head>
<body class="flex h-screen overflow-hidden">

<!-- Sidebar -->
<aside class="w-64 bg-slate-900 text-slate-300 flex flex-col hidden md:flex">
    <div class="h-16 flex items-center px-6 border-b border-slate-800">
        <i class="fas fa-graduation-cap text-blue-500 text-2xl mr-3"></i>
        <span class="text-white text-xl font-bold tracking-wide">HireNest</span>
    </div>
    <nav class="flex-1 overflow-y-auto py-4">
        <a href="${pageContext.request.contextPath}/superadmin/dashboard" class="sidebar-item active flex items-center px-6 py-3 text-sm font-medium">
            <i class="fas fa-home w-6"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/superadmin/college-admins" class="sidebar-item flex items-center px-6 py-3 text-sm font-medium transition duration-150">
            <i class="fas fa-user-shield w-6"></i> College Admins
        </a>
        <a href="${pageContext.request.contextPath}/superadmin/colleges" class="sidebar-item flex items-center px-6 py-3 text-sm font-medium transition duration-150">
            <i class="fas fa-university w-6"></i> Colleges
        </a>
        <a href="${pageContext.request.contextPath}/superadmin/students" class="sidebar-item flex items-center px-6 py-3 text-sm font-medium transition duration-150">
            <i class="fas fa-user-graduate w-6"></i> Students
        </a>
        <a href="${pageContext.request.contextPath}/superadmin/recruiters" class="sidebar-item flex items-center px-6 py-3 text-sm font-medium transition duration-150">
            <i class="fas fa-building w-6"></i> Recruiters
        </a>
        <a href="${pageContext.request.contextPath}/superadmin/reports" class="sidebar-item flex items-center px-6 py-3 text-sm font-medium transition duration-150">
            <i class="fas fa-chart-pie w-6"></i> Reports
        </a>
        <a href="${pageContext.request.contextPath}/superadmin/announcements" class="sidebar-item flex items-center px-6 py-3 text-sm font-medium transition duration-150">
            <i class="fas fa-bullhorn w-6"></i> Announcements
        </a>
    </nav>
    <div class="border-t border-slate-800 p-4">
        <a href="${pageContext.request.contextPath}/logout" class="sidebar-item flex items-center px-4 py-2 text-sm font-medium text-red-400 hover:text-red-300 rounded transition duration-150">
            <i class="fas fa-sign-out-alt w-6"></i> Logout
        </a>
    </div>
</aside>

<!-- Main Content -->
<main class="flex-1 flex flex-col overflow-hidden">
    <!-- Top Navbar -->
    <header class="h-16 bg-white border-b border-gray-200 flex items-center justify-between px-8 card-shadow">
        <h1 class="text-xl font-semibold text-gray-800">Dashboard Overview</h1>
        <div class="flex items-center space-x-4">
            <span class="text-sm text-gray-500">Welcome, <strong class="text-gray-800">${sessionScope.userName}</strong></span>
            <div class="h-8 w-8 rounded-full bg-blue-600 text-white flex items-center justify-center font-bold">
                <i class="fas fa-crown"></i>
            </div>
        </div>
    </header>

    <!-- Scrollable Content -->
    <div class="flex-1 overflow-y-auto p-8">

        <!-- Row 1: Stat Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">

            <!-- Total Colleges -->
            <div class="bg-white rounded-xl p-6 card-shadow border border-gray-100 flex items-center">
                <div class="h-12 w-12 rounded-full bg-blue-50 text-blue-500 flex items-center justify-center text-xl mr-4">
                    <i class="fas fa-university"></i>
                </div>
                <div>
                    <p class="text-sm font-medium text-gray-500">Total Colleges</p>
                    <h3 class="text-2xl font-bold text-gray-800">${empty totalColleges ? 0 : totalColleges}</h3>
                    <p class="text-xs text-gray-400 mt-1">
                        <span class="text-green-500"><i class="fas fa-arrow-up"></i> ${empty activeColleges ? 0 : activeColleges} Active</span> /
                        <span class="text-orange-500">${empty pendingColleges ? 0 : pendingColleges} Pending</span>
                    </p>
                </div>
            </div>

            <!-- Total Students -->
            <div class="bg-white rounded-xl p-6 card-shadow border border-gray-100 flex items-center">
                <div class="h-12 w-12 rounded-full bg-indigo-50 text-indigo-500 flex items-center justify-center text-xl mr-4">
                    <i class="fas fa-user-graduate"></i>
                </div>
                <div>
                    <p class="text-sm font-medium text-gray-500">Total Students</p>
                    <h3 class="text-2xl font-bold text-gray-800">${empty totalStudents ? 0 : totalStudents}</h3>
                    <p class="text-xs text-gray-400 mt-1">
                        <span class="text-green-500">${empty placedStudents ? 0 : placedStudents} Placed</span> /
                        <span class="text-gray-500">${empty unplacedStudents ? 0 : unplacedStudents} Unplaced</span>
                    </p>
                </div>
            </div>

            <!-- Total Recruiters -->
            <div class="bg-white rounded-xl p-6 card-shadow border border-gray-100 flex items-center">
                <div class="h-12 w-12 rounded-full bg-green-50 text-green-500 flex items-center justify-center text-xl mr-4">
                    <i class="fas fa-briefcase"></i>
                </div>
                <div>
                    <p class="text-sm font-medium text-gray-500">Total Recruiters</p>
                    <h3 class="text-2xl font-bold text-gray-800">${empty totalRecruiters ? 0 : totalRecruiters}</h3>
                    <p class="text-xs text-gray-400 mt-1">Registered across all colleges</p>
                </div>
            </div>

            <!-- Total College Admins -->
            <div class="bg-white rounded-xl p-6 card-shadow border border-gray-100 flex items-center">
                <div class="h-12 w-12 rounded-full bg-orange-50 text-orange-500 flex items-center justify-center text-xl mr-4">
                    <i class="fas fa-users"></i>
                </div>
                <div>
                    <p class="text-sm font-medium text-gray-500">College Admins</p>
                    <h3 class="text-2xl font-bold text-gray-800">${empty totalCollegeAdmins ? 0 : totalCollegeAdmins}</h3>
                    <p class="text-xs text-gray-400 mt-1">Across all institutions</p>
                </div>
            </div>

        </div>

        <!-- Row 2: Charts -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
            <!-- Doughnut Chart -->
            <div class="bg-white rounded-xl p-6 card-shadow border border-gray-100">
                <h3 class="text-lg font-semibold text-gray-800 mb-4">Placement Statistics</h3>
                <div class="h-64 flex justify-center">
                    <canvas id="placementChart"></canvas>
                </div>
            </div>

            <!-- Bar Chart -->
            <div class="bg-white rounded-xl p-6 card-shadow border border-gray-100">
                <h3 class="text-lg font-semibold text-gray-800 mb-4">Top 5 Colleges by Students</h3>
                <div class="h-64">
                    <canvas id="collegeChart"></canvas>
                </div>
            </div>
        </div>

        <!-- Row 3: Recent Requests Table -->
        <div class="bg-white rounded-xl card-shadow border border-gray-100 mb-8 overflow-hidden">
            <div class="p-6 border-b border-gray-100 flex justify-between items-center">
                <h3 class="text-lg font-semibold text-gray-800">Recent College Admin Requests</h3>
                <a href="${pageContext.request.contextPath}/superadmin/college-admins" class="text-sm font-medium text-blue-600 hover:text-blue-800">
                    View All <i class="fas fa-arrow-right ml-1"></i>
                </a>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                    <tr class="bg-gray-50 text-gray-500 text-sm uppercase tracking-wider border-b border-gray-100">
                        <th class="px-6 py-4 font-medium">Name</th>
                        <th class="px-6 py-4 font-medium">Email</th>
                        <th class="px-6 py-4 font-medium">College</th>
                        <th class="px-6 py-4 font-medium">Requested Date</th>
                        <th class="px-6 py-4 font-medium text-right">Action</th>
                    </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                    <c:choose>
                        <c:when test="${not empty pendingAdmins}">
                            <c:forEach var="admin" items="${pendingAdmins}" end="4">
                                <tr class="hover:bg-gray-50 transition duration-150">
                                    <td class="px-6 py-4 text-sm text-gray-800 font-medium"><c:out value="${admin.name}" /></td>
                                    <td class="px-6 py-4 text-sm text-gray-500"><c:out value="${admin.email}" /></td>
                                    <td class="px-6 py-4 text-sm text-gray-800"><c:out value="${admin.collegeName}" /></td>
                                    <td class="px-6 py-4 text-sm text-gray-500"><c:out value="${admin.requestedDate}" /></td>
                                    <td class="px-6 py-4 text-right space-x-2">
                                        <form action="${pageContext.request.contextPath}/superadmin/approve-admin" method="POST" class="inline">
                                            <input type="hidden" name="userId" value="${admin.userId}">
                                            <button type="submit" class="bg-green-50 text-green-600 hover:bg-green-100 px-3 py-1 rounded text-sm font-medium transition">Approve</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/superadmin/reject-admin" method="POST" class="inline">
                                            <input type="hidden" name="userId" value="${admin.userId}">
                                            <button type="submit" class="bg-red-50 text-red-600 hover:bg-red-100 px-3 py-1 rounded text-sm font-medium transition">Reject</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="5" class="px-6 py-8 text-center text-gray-500 text-sm">
                                    <i class="fas fa-check-circle text-gray-400 text-2xl mb-2 block"></i>
                                    No pending requests right now.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</main>

<!-- Chart.js Scripts -->
<script>
    // 1. Placement Doughnut Chart
    const placed = ${empty placedStudents ? 0 : placedStudents};
    const unplaced = ${empty unplacedStudents ? 0 : unplacedStudents};
    const ctx1 = document.getElementById('placementChart').getContext('2d');
    new Chart(ctx1, {
        type: 'doughnut',
        data: {
            labels: ['Placed', 'Unplaced'],
            datasets: [{
                data: [placed, unplaced],
                backgroundColor: ['#10b981', '#e5e7eb'],
                borderWidth: 0,
                hoverOffset: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '70%',
            plugins: {
                legend: { position: 'bottom' }
            }
        }
    });

    // 2. College-wise Students Bar Chart
    // Controller must provide collegeNames and collegeStudentCounts as JS arrays
    const collegeNames = ${empty collegeNames ? "['No Data']" : collegeNames};
    const collegeCounts = ${empty collegeStudentCounts ? "[0]" : collegeStudentCounts};

    const ctx2 = document.getElementById('collegeChart').getContext('2d');
    new Chart(ctx2, {
        type: 'bar',
        data: {
            labels: collegeNames,
            datasets: [{
                label: 'Students',
                data: collegeCounts,
                backgroundColor: '#3b82f6',
                borderRadius: 6,
                barThickness: 30
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false }
            },
            scales: {
                y: { beginAtZero: true, grid: { borderDash: [2, 4] } },
                x: { grid: { display: false } }
            }
        }
    });
</script>
</body>
</html>