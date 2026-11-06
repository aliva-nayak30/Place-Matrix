<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%
    if (!"RECRUITER".equals(session.getAttribute("role"))) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Company Profile - HireNest</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>body { font-family: 'Inter', sans-serif; background: #f8fafc; }</style>
</head>
<body class="flex h-screen overflow-hidden">
<aside class="w-64 bg-slate-900 text-slate-300 flex flex-col hidden md:flex">
    <div class="h-16 flex items-center px-6 border-b border-slate-800 font-bold text-xl text-white">
        <i class="bi bi-buildings-fill text-blue-500 mr-3"></i> HireNest
    </div>
    <nav class="flex-1 py-4 space-y-2 px-4">
        <a href="?page=dashboard" class="block px-4 py-2 hover:bg-slate-800 rounded text-slate-300"><i class="bi bi-grid-1x2-fill mr-2"></i> Dashboard</a>
        <a href="?page=post-job" class="block px-4 py-2 hover:bg-slate-800 rounded text-slate-300"><i class="bi bi-plus-circle-fill mr-2"></i> Post Job</a>
        <a href="?page=my-jobs" class="block px-4 py-2 hover:bg-slate-800 rounded text-slate-300"><i class="bi bi-briefcase-fill mr-2"></i> My Jobs</a>
        <a href="?page=applications" class="block px-4 py-2 hover:bg-slate-800 rounded text-slate-300"><i class="bi bi-people-fill mr-2"></i> Applications</a>
        <a href="?page=profile" class="block px-4 py-2 bg-blue-600 text-white rounded font-medium"><i class="bi bi-building mr-2"></i> Company Profile</a>
    </nav>
    <div class="p-4 border-t border-slate-800">
        <a href="${pageContext.request.contextPath}/logout" class="block px-4 py-2 text-red-400 hover:bg-slate-800 rounded"><i class="bi bi-box-arrow-right mr-2"></i> Logout</a>
    </div>
</aside>

<main class="flex-1 flex flex-col overflow-hidden">
    <header class="h-16 bg-white border-b flex items-center px-8 shadow-sm">
        <h1 class="text-xl font-bold text-gray-800">Company Profile</h1>
    </header>

    <div class="flex-1 overflow-y-auto p-8">
        <div class="bg-white rounded-xl shadow-sm border border-gray-100 max-w-3xl mx-auto overflow-hidden">

            <!-- Company Banner -->
            <div class="h-32 bg-gradient-to-r from-blue-600 to-indigo-700 relative">
                <div class="absolute -bottom-10 left-8">
                    <c:choose>
                        <c:when test="${not empty profile.logoUrl}">
                            <img src="${profile.logoUrl}" class="h-24 w-24 rounded-xl object-cover border-4 border-white shadow-md">
                        </c:when>
                        <c:otherwise>
                            <div class="h-24 w-24 bg-white rounded-xl shadow-md flex items-center justify-center border-4 border-white">
                                <i class="bi bi-building text-4xl text-blue-600"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="pt-14 px-8 pb-8">
                <div class="flex justify-between items-start mb-6">
                    <div>
                        <h2 class="text-2xl font-bold text-gray-800">${profile.companyName != null ? profile.companyName : 'Your Company'}</h2>
                        <p class="text-gray-500 text-sm mt-1">Update your company details to attract top talent.</p>
                    </div>
                    <c:if test="${not empty profile.website}">
                        <a href="${profile.website}" target="_blank" class="text-sm font-medium text-blue-600 bg-blue-50 px-3 py-1.5 rounded-lg hover:bg-blue-100">
                            <i class="bi bi-globe mr-1"></i> Visit Website
                        </a>
                    </c:if>
                </div>

                <c:if test="${not empty sessionScope.successMsg}">
                    <div class="bg-green-100 text-green-700 p-4 rounded-lg mb-6 flex justify-between items-center">
                        <span><i class="bi bi-check-circle"></i> ${sessionScope.successMsg}</span>
                        <c:remove var="successMsg" scope="session"/>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/recruiter/dashboard" method="POST">
                    <input type="hidden" name="action" value="updateProfile">

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-2">Company Name</label>
                            <input type="text" name="companyName" value="${profile.companyName}" class="w-full border p-2.5 rounded-lg focus:ring-2 focus:ring-blue-500" required>
                        </div>
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-2">Website URL</label>
                            <input type="url" name="website" value="${profile.website}" placeholder="https://www.company.com" class="w-full border p-2.5 rounded-lg focus:ring-2 focus:ring-blue-500">
                        </div>
                        <div class="md:col-span-2">
                            <label class="block text-sm font-bold text-gray-700 mb-2">Company Logo URL</label>
                            <input type="url" name="logoUrl" value="${profile.logoUrl}" placeholder="https://example.com/logo.png" class="w-full border p-2.5 rounded-lg focus:ring-2 focus:ring-blue-500">
                            <p class="text-xs text-gray-400 mt-1">Paste a direct image link (e.g. from your website). Leave blank to use the default icon.</p>
                        </div>
                    </div>

                    <div class="mb-6">
                        <label class="block text-sm font-bold text-gray-700 mb-2">About Company</label>
                        <textarea name="about" rows="5" placeholder="Tell students about your company..." class="w-full border p-3 rounded-lg focus:ring-2 focus:ring-blue-500">${profile.about}</textarea>
                    </div>

                    <div class="text-right border-t pt-6">
                        <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white px-8 py-2.5 rounded-lg font-bold transition">
                            <i class="bi bi-save mr-2"></i> Save Profile Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>
</body>
</html>