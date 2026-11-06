<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%
    if (!"RECRUITER".equals(session.getAttribute("role"))) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Post Job - HireNest</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>body { font-family: 'Inter', sans-serif; background: #f8fafc; }</style>
</head>
<body class="flex h-screen overflow-hidden">
<!-- SIDEBAR (Paste same sidebar here) -->
<aside class="w-64 bg-slate-900 text-slate-300 flex flex-col hidden md:flex">
    <!-- ... Same Sidebar ... -->
    <nav class="flex-1 py-4 space-y-2 px-4">
        <a href="?page=dashboard" class="block px-4 py-2 hover:bg-slate-800 rounded text-slate-300"><i class="bi bi-grid-1x2-fill mr-2"></i> Dashboard</a>
        <a href="?page=post-job" class="block px-4 py-2 bg-blue-600 text-white rounded font-medium"><i class="bi bi-plus-circle-fill mr-2"></i> Post Job</a>
        <a href="?page=my-jobs" class="block px-4 py-2 hover:bg-slate-800 rounded text-slate-300"><i class="bi bi-briefcase-fill mr-2"></i> My Jobs</a>
        <a href="?page=applications" class="block px-4 py-2 hover:bg-slate-800 rounded text-slate-300"><i class="bi bi-people-fill mr-2"></i> Applications</a>
    </nav>
</aside>

<main class="flex-1 flex flex-col overflow-hidden">
    <header class="h-16 bg-white border-b flex items-center px-8 shadow-sm">
        <h1 class="text-xl font-bold text-gray-800">Post a New Job</h1>
    </header>

    <div class="flex-1 overflow-y-auto p-8">
        <div class="bg-white p-8 rounded-xl shadow-sm border border-gray-100 max-w-4xl mx-auto">
            <form action="${pageContext.request.contextPath}/recruiter/dashboard" method="POST">
                <input type="hidden" name="action" value="postJob">
                <div class="grid grid-cols-2 gap-4">
                    <div class="col-span-2"><label class="font-medium text-sm text-gray-700">Job Title</label><input type="text" name="title" class="w-full border p-2 rounded mt-1" required></div>
                    <div><label class="font-medium text-sm text-gray-700">Job Type</label>
                        <select name="jobType" class="w-full border p-2 rounded mt-1">
                            <option>Full Time</option><option>Internship</option><option>Part Time</option>
                        </select>
                    </div>
                    <div><label class="font-medium text-sm text-gray-700">Location</label><input type="text" name="location" class="w-full border p-2 rounded mt-1" required></div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Interview Venue</label>
                        <input type="text" name="venue" placeholder="e.g. Block A, Room 101" class="w-full border p-2 rounded-lg">
                    </div>
                    <div><label class="font-medium text-sm text-gray-700">Salary (CTC)</label><input type="number" step="0.1" name="salary" class="w-full border p-2 rounded mt-1" required></div>
                    <div><label class="font-medium text-sm text-gray-700">Last Date to Apply</label><input type="date" name="lastDate" class="w-full border p-2 rounded mt-1" required></div>
                    <div><label class="font-medium text-sm text-gray-700">Required Skills</label><input type="text" name="skills" class="w-full border p-2 rounded mt-1" placeholder="Java, Spring Boot" required></div>
                    <div><label class="font-medium text-sm text-gray-700">Eligible Branches</label><input type="text" name="eligibleBranches" class="w-full border p-2 rounded mt-1" placeholder="CSE, MCA" required></div>
                    <div class="col-span-2"><label class="font-medium text-sm text-gray-700">Description</label><textarea name="description" rows="4" class="w-full border p-2 rounded mt-1" required></textarea></div>
                </div>
                <div class="mt-6 text-right"><button type="submit" class="bg-blue-600 text-white px-6 py-2 rounded font-bold">Post Job</button></div>
            </form>
        </div>
    </div>
</main>
</body>
</html>