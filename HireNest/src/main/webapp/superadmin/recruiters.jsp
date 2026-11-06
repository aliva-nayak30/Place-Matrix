<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Recruiters - HireNest</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-slate-50 flex h-screen overflow-hidden">
<aside class="w-64 bg-slate-900 text-white flex flex-col hidden md:flex">
    <div class="h-16 flex items-center px-6 border-b border-slate-800 font-bold text-xl"><i class="fas fa-graduation-cap text-blue-500 mr-3"></i> HireNest</div>
    <nav class="flex-1 py-4 space-y-2 px-4">
        <a href="${pageContext.request.contextPath}/superadmin/dashboard" class="block px-4 py-2 hover:bg-slate-800 rounded text-slate-300"><i class="fas fa-home w-6"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/superadmin/recruiters" class="block px-4 py-2 bg-blue-600 rounded text-white font-medium"><i class="fas fa-building w-6"></i> Recruiters</a>
    </nav>
</aside>

<main class="flex-1 overflow-y-auto p-8">
    <h1 class="text-2xl font-bold text-gray-800 mb-6">Manage Recruiters</h1>
    <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
        <table class="w-full text-left border-collapse">
            <thead>
            <tr class="bg-gray-50 text-gray-500 text-sm uppercase border-b">
                <th class="px-6 py-4">Name</th>
                <th class="px-6 py-4">Email</th>
                <th class="px-6 py-4">Status</th>
            </tr>
            </thead>
            <tbody class="divide-y divide-gray-100">
            <c:forEach items="${recruiters}" var="r">
                <tr class="hover:bg-gray-50">
                    <td class="px-6 py-4 font-bold text-gray-800">${r.name}</td>
                    <td class="px-6 py-4 text-gray-500">${r.email}</td>
                    <td class="px-6 py-4">
                        <span class="bg-green-100 text-green-700 px-2 py-1 rounded text-xs font-bold">ACTIVE</span>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</main>
</body>
</html>