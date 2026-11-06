<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%
    if (!"STUDENT".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Profile - HireNest</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>body { font-family: 'Inter', sans-serif; background: #f8fafc; }</style>
</head>
<body class="flex h-screen overflow-hidden">

<!-- Sidebar -->
<aside class="w-64 bg-slate-900 text-white flex flex-col hidden md:flex">
    <div class="h-16 flex items-center px-6 border-b border-slate-800 font-bold text-xl">
        <i class="fas fa-graduation-cap text-teal-500 mr-3"></i> HireNest
    </div>
    <nav class="flex-1 py-4 space-y-2 px-4">
        <!-- Dashboard Link -->
        <a href="${pageContext.request.contextPath}/student/dashboard" class="block px-4 py-2 hover:bg-slate-800 rounded text-slate-300">
            <i class="fas fa-chart-line mr-2"></i> Dashboard
        </a>
        <!-- Eligible Companies Link -->
        <a href="${pageContext.request.contextPath}/student/eligible-companies" class="block px-4 py-2 hover:bg-slate-800 rounded text-slate-300">
            <i class="fas fa-briefcase mr-2"></i> Eligible Companies
        </a>
        <!-- Resume Link -->
        <a href="${pageContext.request.contextPath}/student/resume" class="block px-4 py-2 hover:bg-slate-800 rounded text-slate-300">
            <i class="fas fa-file-pdf mr-2"></i> My Resume
        </a>
        <!-- Profile Link (Active) -->
        <a href="${pageContext.request.contextPath}/student/profile" class="block px-4 py-2 bg-teal-600 rounded text-white font-medium">
            <i class="fas fa-user mr-2"></i> My Profile
        </a>
        <!-- Change Password Link -->
        <a href="${pageContext.request.contextPath}/student/change-password" class="block px-4 py-2 hover:bg-slate-800 rounded text-slate-300">
            <i class="fas fa-shield-alt mr-2"></i> Change Password
        </a>
    </nav>
    <div class="p-4 border-t border-slate-800">
        <a href="${pageContext.request.contextPath}/logout" class="block px-4 py-2 text-red-400 hover:bg-slate-800 rounded">
            <i class="fas fa-sign-out-alt mr-2"></i> Logout
        </a>
    </div>
</aside>

<!-- Main Content -->
<main class="flex-1 flex flex-col overflow-hidden">
    <header class="h-16 bg-white border-b flex justify-between items-center px-8 shadow-sm">
        <h1 class="text-xl font-bold text-gray-800">My Profile</h1>
        <div class="flex items-center space-x-4">
            <span class="text-sm font-medium text-teal-600 bg-teal-50 px-3 py-1 rounded-full">
                <i class="fas fa-chart-line mr-1"></i> ${profilePercent}% Complete
            </span>
            <div class="h-9 w-9 bg-teal-100 text-teal-700 rounded-full flex items-center justify-center font-bold">
                ${fn:substring(student.name, 0, 1)}
            </div>
        </div>
    </header>

    <div class="flex-1 overflow-y-auto p-8">

        <!-- Alerts -->
        <c:if test="${not empty sessionScope.successMsg}">
            <div class="bg-green-100 text-green-700 p-4 rounded-lg mb-6 flex justify-between items-center">
                <span><i class="fas fa-check-circle"></i> ${sessionScope.successMsg}</span>
                <c:remove var="successMsg" scope="session"/>
            </div>
        </c:if>
        <c:if test="${not empty sessionScope.errorMsg}">
            <div class="bg-red-100 text-red-700 p-4 rounded-lg mb-6 flex justify-between items-center">
                <span><i class="fas fa-exclamation-circle"></i> ${sessionScope.errorMsg}</span>
                <c:remove var="errorMsg" scope="session"/>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/student/profile" method="post" enctype="multipart/form-data">
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

                <!-- Left Column -->
                <div class="lg:col-span-1 space-y-6">
                    <!-- Profile Photo -->
                    <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6 text-center">
                        <div class="mb-4 flex justify-center">
                            <c:choose>
                                <c:when test="${not empty student.profilePhoto}">
                                    <img src="${pageContext.request.contextPath}/${student.profilePhoto}" class="h-32 w-32 rounded-full object-cover border-4 border-teal-100 shadow-sm">
                                </c:when>
                                <c:otherwise>
                                    <div class="h-32 w-32 rounded-full bg-slate-100 text-slate-400 flex items-center justify-center text-5xl border-4 border-slate-200">
                                        <i class="fas fa-user"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <label class="block w-full cursor-pointer bg-gray-50 hover:bg-gray-100 border border-gray-200 text-gray-700 text-sm font-medium py-2 px-4 rounded-lg transition">
                            <i class="fas fa-camera mr-2"></i> Change Photo
                            <input type="file" name="profilePhoto" accept="image/*" class="hidden" onchange="this.form.submit()">
                        </label>
                        <p class="text-xs text-gray-400 mt-2">JPG or PNG. Max 5MB.</p>
                    </div>

                    <!-- Read-Only Info -->
                    <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6 space-y-4">
                        <h3 class="font-bold text-gray-800 border-b pb-2">College Details</h3>
                        <div>
                            <label class="text-xs text-gray-500">Registration No</label>
                            <div class="font-medium text-gray-800">${student.registrationNo}</div>
                        </div>
                        <div>
                            <label class="text-xs text-gray-500">Branch</label>
                            <div class="font-medium text-gray-800">${student.branch}</div>
                        </div>
                        <div>
                            <label class="text-xs text-gray-500">Email</label>
                            <div class="font-medium text-gray-800">${student.email}</div>
                        </div>
                    </div>
                </div>

                <!-- Right Column -->
                <div class="lg:col-span-2 space-y-6">
                    <!-- Basic Info -->
                    <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                        <h3 class="font-bold text-gray-800 border-b pb-2 mb-4">Personal Information</h3>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">Full Name *</label>
                                <input type="text" name="name" value="${student.name}" required class="w-full border p-2 rounded-lg focus:ring-teal-500 focus:border-teal-500">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">Phone Number</label>
                                <input type="tel" name="phone" value="${student.phone}" class="w-full border p-2 rounded-lg focus:ring-teal-500 focus:border-teal-500">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">Gender</label>
                                <select name="gender" class="w-full border p-2 rounded-lg focus:ring-teal-500 focus:border-teal-500">
                                    <option value="">Select</option>
                                    <option value="Male" ${student.gender == 'Male' ? 'selected' : ''}>Male</option>
                                    <option value="Female" ${student.gender == 'Female' ? 'selected' : ''}>Female</option>
                                    <option value="Other" ${student.gender == 'Other' ? 'selected' : ''}>Other</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">Date of Birth</label>
                                <input type="date" name="dob" value="${student.dob}" class="w-full border p-2 rounded-lg focus:ring-teal-500 focus:border-teal-500">
                            </div>
                            <div class="md:col-span-2">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Address</label>
                                <textarea name="address" rows="2" class="w-full border p-2 rounded-lg focus:ring-teal-500 focus:border-teal-500">${student.address}</textarea>
                            </div>
                        </div>
                    </div>

                    <!-- Academic Info -->
                    <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                        <h3 class="font-bold text-gray-800 border-b pb-2 mb-4">Academic Information</h3>
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">CGPA (out of 10)</label>
                                <input type="number" step="0.01" name="cgpa" value="${student.cgpa}" class="w-full border p-2 rounded-lg focus:ring-teal-500 focus:border-teal-500">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">Active Backlogs</label>
                                <input type="number" name="backlogs" value="${student.backlogs}" class="w-full border p-2 rounded-lg focus:ring-teal-500 focus:border-teal-500">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">Passout Year</label>
                                <input type="number" name="passoutYear" value="${student.passoutYear}" class="w-full border p-2 rounded-lg focus:ring-teal-500 focus:border-teal-500">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">10th %</label>
                                <input type="number" step="0.01" name="tenthPercentage" value="${student.tenthPercentage}" class="w-full border p-2 rounded-lg focus:ring-teal-500 focus:border-teal-500">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">12th %</label>
                                <input type="number" step="0.01" name="twelfthPercentage" value="${student.twelfthPercentage}" class="w-full border p-2 rounded-lg focus:ring-teal-500 focus:border-teal-500">
                            </div>
                            <div class="md:col-span-3">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Technical Skills (comma separated)</label>
                                <textarea name="skills" rows="2" class="w-full border p-2 rounded-lg focus:ring-teal-500 focus:border-teal-500" placeholder="Java, Python, SQL, React">${student.skills}</textarea>
                            </div>
                        </div>
                    </div>

                    <!-- Links -->
                    <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                        <h3 class="font-bold text-gray-800 border-b pb-2 mb-4">Professional Links</h3>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1"><i class="fab fa-linkedin text-blue-600"></i> LinkedIn URL</label>
                                <input type="url" name="linkedinUrl" value="${student.linkedinUrl}" class="w-full border p-2 rounded-lg focus:ring-teal-500 focus:border-teal-500">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1"><i class="fab fa-github text-gray-800"></i> GitHub URL</label>
                                <input type="url" name="githubUrl" value="${student.githubUrl}" class="w-full border p-2 rounded-lg focus:ring-teal-500 focus:border-teal-500">
                            </div>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <div class="flex justify-end gap-3">
                        <a href="${pageContext.request.contextPath}/student/dashboard" class="px-6 py-2.5 rounded-lg font-bold text-gray-600 bg-gray-100 hover:bg-gray-200 transition">
                            Cancel
                        </a>
                        <button type="submit" class="px-8 py-2.5 rounded-lg font-bold text-white bg-teal-600 hover:bg-teal-700 transition">
                            <i class="fas fa-save mr-2"></i> Save Changes
                        </button>
                    </div>

                </div>
            </div>
        </form>
    </div>
</main>
</body>
</html>