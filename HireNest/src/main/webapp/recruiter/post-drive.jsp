<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (!"RECRUITER".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Post a Drive - HireNest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>body { font-family: 'Inter', sans-serif; background: #f8fafc; }</style>
</head>
<body class="d-flex h-100">
<!-- Sidebar -->
<aside class="sidebar w-64 bg-slate-900 text-white flex flex-col hidden md:flex" style="width: 260px; min-height: 100vh; background:#0F172A;">
    <div class="h-16 flex items-center px-6 border-b border-slate-800 font-bold text-xl"><i class="bi bi-buildings-fill text-primary mr-3"></i> HireNest</div>
    <nav class="flex-1 py-4 space-y-2 px-4">
        <a href="${pageContext.request.contextPath}/recruiter/dashboard" class="block px-4 py-2 text-slate-300 hover:bg-slate-800 rounded"><i class="bi bi-people-fill mr-2"></i> View Applicants</a>
        <a href="${pageContext.request.contextPath}/recruiter/post-drive" class="block px-4 py-2 bg-blue-600 text-white rounded font-medium"><i class="bi bi-plus-circle-fill mr-2"></i> Post a Drive</a>
    </nav>
</aside>

<!-- Main Content -->
<main class="flex-grow-1 p-8">
    <h2 class="fw-bold mb-4 text-dark">Create New Placement Drive</h2>

    <div class="bg-white rounded-4 shadow-sm border p-4 max-w-3xl">
        <form action="${pageContext.request.contextPath}/recruiter/post-drive" method="POST">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label fw-bold">Job Role / Title</label>
                    <input type="text" name="jobTitle" class="form-control" required placeholder="e.g. Software Engineer">
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-bold">Package (LPA)</label>
                    <input type="number" step="0.1" name="packageLpa" class="form-control" required placeholder="e.g. 12.5">
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-bold">Eligible Branches</label>
                    <input type="text" name="eligibleBranches" class="form-control" required placeholder="e.g. CSE, MCA, ECE">
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-bold">Drive Date</label>
                    <input type="date" name="driveDate" class="form-control" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-bold">Minimum CGPA</label>
                    <input type="number" step="0.1" name="minCgpa" class="form-control" required value="6.0">
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-bold">Max Backlogs Allowed</label>
                    <input type="number" name="maxBacklogs" class="form-control" required value="0">
                </div>
                <div class="col-12 text-end mt-4">
                    <button type="submit" class="btn btn-primary px-5 fw-bold" style="background:#6366f1; border:none;">Post Drive</button>
                </div>
            </div>
        </form>
    </div>
</main>
</body>
</html>