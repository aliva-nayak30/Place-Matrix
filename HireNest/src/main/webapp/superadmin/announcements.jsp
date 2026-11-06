<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Announcements - HireNest</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="flex h-screen overflow-hidden bg-slate-50">

<!-- Sidebar (Same as superadmin dashboard) -->
<aside class="w-64 bg-slate-900 text-slate-300 flex flex-col hidden md:flex">
    <div class="h-16 flex items-center px-6 border-b border-slate-800">
        <i class="fas fa-graduation-cap text-blue-500 text-2xl mr-3"></i>
        <span class="text-white text-xl font-bold">HireNest</span>
    </div>
    <nav class="flex-1 py-4">
        <a href="${pageContext.request.contextPath}/superadmin/dashboard" class="flex items-center px-6 py-3 text-sm hover:bg-slate-800"><i class="fas fa-home w-6"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/superadmin/announcements" class="flex items-center px-6 py-3 text-sm bg-blue-600 text-white"><i class="fas fa-bullhorn w-6"></i> Announcements</a>
    </nav>
</aside>

<main class="flex-1 flex flex-col overflow-hidden">
    <header class="h-16 bg-white border-b flex items-center px-8 shadow-sm">
        <h1 class="text-xl font-semibold text-gray-800">Post Announcements</h1>
    </header>

    <div class="flex-1 overflow-y-auto p-8">
        <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100 mb-8">
            <form action="${pageContext.request.contextPath}/superadmin/announcements" method="POST">
                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Title</label>
                    <input type="text" name="title" class="w-full border p-2 rounded-lg" required>
                </div>
                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Message</label>
                    <textarea name="message" rows="3" class="w-full border p-2 rounded-lg" required></textarea>
                </div>
                <button type="submit" class="bg-blue-600 text-white px-6 py-2 rounded-lg font-medium hover:bg-blue-700 transition">Post Announcement</button>
            </form>
        </div>

        <h3 class="text-lg font-bold text-gray-800 mb-4">Recent Announcements</h3>
        <div class="space-y-4">
            <c:forEach items="${announcements}" var="a">
                <div class="bg-white p-5 rounded-xl shadow-sm border-l-4 border-blue-500">
                    <div class="flex justify-between items-start">
                        <h4 class="font-bold text-gray-800 text-lg">${a.title}</h4>
                        <span class="text-xs text-gray-400">${a.date}</span>
                    </div>
                    <p class="text-gray-600 mt-2">${a.message}</p>
                </div>
            </c:forEach>
        </div>
    </div>
</main>
</body>
</html>