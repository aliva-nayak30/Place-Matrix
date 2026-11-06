<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
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
  <title>Manage Students - HireNest</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <style>body { font-family: 'Inter', sans-serif; background-color: #f8fafc; }</style>
</head>
<body class="flex h-screen overflow-hidden">

<!-- Sidebar -->
<aside class="w-64 bg-slate-900 text-slate-300 flex flex-col hidden md:flex">
  <div class="h-16 flex items-center px-6 border-b border-slate-800">
    <i class="fas fa-graduation-cap text-blue-500 text-2xl mr-3"></i>
    <span class="text-white text-xl font-bold tracking-wide">HireNest</span>
  </div>
  <nav class="flex-1 overflow-y-auto py-4">
    <a href="${pageContext.request.contextPath}/superadmin/dashboard" class="flex items-center px-6 py-3 text-sm font-medium hover:bg-slate-800 transition"><i class="fas fa-home w-6"></i> Dashboard</a>
    <a href="${pageContext.request.contextPath}/superadmin/college-admins" class="flex items-center px-6 py-3 text-sm font-medium hover:bg-slate-800 transition"><i class="fas fa-user-shield w-6"></i> College Admins</a>
    <a href="${pageContext.request.contextPath}/superadmin/colleges" class="flex items-center px-6 py-3 text-sm font-medium hover:bg-slate-800 transition"><i class="fas fa-university w-6"></i> Colleges</a>
    <a href="${pageContext.request.contextPath}/superadmin/students" class="flex items-center px-6 py-3 text-sm font-medium bg-blue-600 text-white"><i class="fas fa-user-graduate w-6"></i> Students</a>
    <a href="${pageContext.request.contextPath}/superadmin/recruiters" class="flex items-center px-6 py-3 text-sm font-medium hover:bg-slate-800 transition"><i class="fas fa-building w-6"></i> Recruiters</a>
    <a href="${pageContext.request.contextPath}/superadmin/reports" class="flex items-center px-6 py-3 text-sm font-medium hover:bg-slate-800 transition"><i class="fas fa-chart-pie w-6"></i> Reports</a>
    <a href="${pageContext.request.contextPath}/superadmin/announcements" class="flex items-center px-6 py-3 text-sm font-medium hover:bg-slate-800 transition"><i class="fas fa-bullhorn w-6"></i> Announcements</a>
  </nav>
  <div class="border-t border-slate-800 p-4">
    <a href="${pageContext.request.contextPath}/logout" class="flex items-center px-4 py-2 text-sm font-medium text-red-400 hover:text-red-300 transition"><i class="fas fa-sign-out-alt w-6"></i> Logout</a>
  </div>
</aside>

<!-- Main Content -->
<main class="flex-1 flex flex-col overflow-hidden">
  <header class="h-16 bg-white border-b border-gray-200 flex items-center justify-between px-8">
    <h1 class="text-xl font-semibold text-gray-800">Manage Students</h1>
    <div class="flex items-center space-x-4">
      <span class="text-sm text-gray-500">Welcome, <strong class="text-gray-800">${sessionScope.userName}</strong></span>
      <div class="h-8 w-8 rounded-full bg-blue-600 text-white flex items-center justify-center font-bold">
        <i class="fas fa-crown"></i>
      </div>
    </div>
  </header>

  <div class="flex-1 overflow-y-auto p-8">

    <!-- Filters -->
    <div class="bg-white rounded-xl p-6 shadow-sm border border-gray-100 mb-6">
      <form class="grid grid-cols-1 md:grid-cols-4 gap-4" action="${pageContext.request.contextPath}/superadmin/students" method="GET">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Search</label>
          <input type="text" name="search" value="${search}" placeholder="Name, email, roll no..." class="w-full border-gray-300 rounded-lg shadow-sm focus:border-blue-500 focus:ring-blue-500">
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Branch</label>
          <select name="branch" class="w-full border-gray-300 rounded-lg shadow-sm focus:border-blue-500 focus:ring-blue-500">
            <option value="">All Branches</option>
            <c:forEach items="${branches}" var="b">
              <option value="${b}" ${filterBranch == b ? 'selected' : ''}>${b}</option>
            </c:forEach>
          </select>
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Min CGPA</label>
          <input type="number" name="minCgpa" step="0.1" value="${filterCgpa}" class="w-full border-gray-300 rounded-lg shadow-sm focus:border-blue-500 focus:ring-blue-500">
        </div>
        <div class="flex items-end">
          <button type="submit" class="w-full bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg transition">
            <i class="fas fa-filter mr-2"></i> Filter
          </button>
        </div>
      </form>
    </div>

    <p class="text-sm text-gray-500 mb-4">Showing ${fn:length(students)} students</p>

    <!-- Students Table -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
      <table class="w-full text-left border-collapse">
        <thead>
        <tr class="bg-gray-50 text-gray-500 text-sm uppercase border-b">
          <th class="px-6 py-4">Name</th>
          <th class="px-6 py-4">Roll No</th>
          <th class="px-6 py-4">Branch</th>
          <th class="px-6 py-4">CGPA</th>
          <th class="px-6 py-4">Placement Status</th>
          <th class="px-6 py-4 text-right">Actions</th>
        </tr>
        </thead>
        <tbody class="divide-y divide-gray-100">
        <c:choose>
          <c:when test="${empty students}">
            <tr>
              <td colspan="6" class="px-6 py-12 text-center text-gray-500">
                <i class="fas fa-user-graduate text-4xl text-gray-300 mb-3 block"></i>
                No students found
              </td>
            </tr>
          </c:when>
          <c:otherwise>
            <c:forEach items="${students}" var="s">
              <tr class="hover:bg-gray-50">
                <td class="px-6 py-4">
                  <div class="text-sm font-medium text-gray-800">${s.name}</div>
                  <div class="text-xs text-gray-500">${s.email}</div>
                </td>
                <td class="px-6 py-4 text-sm text-gray-500"><code>${s.registrationNo}</code></td>
                <td class="px-6 py-4 text-sm text-gray-800">${s.branch}</td>
                <td class="px-6 py-4 text-sm font-bold text-gray-800">${s.cgpa}</td>
                <td class="px-6 py-4">
                  <c:choose>
                    <c:when test="${s.placed}">
                      <span class="bg-green-100 text-green-700 px-2 py-1 rounded text-xs font-bold block mb-1">Placed</span>
                      <div class="text-xs text-gray-500">${s.placedCompany} (${s.placedPackage} LPA)</div>
                    </c:when>
                    <c:otherwise>
                      <span class="bg-orange-100 text-orange-700 px-2 py-1 rounded text-xs font-bold">Unplaced</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td class="px-6 py-4 text-right space-x-2">
                  <!-- Removed Trophy Icon. Super Admin can only view and Delete. -->
                  <a href="${pageContext.request.contextPath}/superadmin/students?action=delete&id=${s.id}&userId=${s.userId}" class="text-red-600 hover:text-red-800 px-2" title="Delete" onclick="return confirm('Delete permanently?');">
                    <i class="fas fa-trash"></i>
                  </a>
                </td>
              </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
        </tbody>
      </table>
    </div>
  </div>
</main>
</body>
</html>