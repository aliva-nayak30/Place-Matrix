<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
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
    <title>My Applications - HireNest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; overflow-x: hidden; }
        .sidebar { width: 260px; background-color: #0F172A; color: #94a3b8; position: fixed; height: 100vh; top: 0; left: 0; z-index: 1000; padding-top: 1rem; }
        .sidebar-brand { color: white; font-size: 1.5rem; font-weight: 700; padding: 1rem 1.5rem; display: flex; align-items: center; gap: 10px; margin-bottom: 1rem; }
        .sidebar-brand i { color: #3b82f6; }
        .nav-item { margin: 0.25rem 1rem; }
        .nav-link { color: #94a3b8; border-radius: 8px; padding: 0.75rem 1rem; font-weight: 500; display: flex; align-items: center; gap: 12px; transition: all 0.2s; text-decoration: none; }
        .nav-link:hover, .nav-link.active { background-color: rgba(255, 255, 255, 0.1); color: white; }
        .nav-link.active { background-color: #3b82f6; color: white; }
        .main-content { margin-left: 260px; padding: 2rem; min-height: 100vh; }
        .top-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; background: rgba(255, 255, 255, 0.7); backdrop-filter: blur(10px); padding: 1rem 1.5rem; border-radius: 16px; border: 1px solid rgba(255, 255, 255, 0.5); box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05); }
        .glass-card { background: rgba(255, 255, 255, 0.7); backdrop-filter: blur(10px); border: 1px solid rgba(255, 255, 255, 0.5); border-radius: 16px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05); padding: 1.5rem; }
        .table > :not(caption) > * > * { background-color: transparent; padding: 1rem 0.5rem; }
    </style>
</head>
<body>

<aside class="sidebar">
    <div class="sidebar-brand"><i class="bi bi-mortarboard-fill"></i> HireNest</div>
    <ul class="nav flex-column mt-3">
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/student/dashboard"><i class="bi bi-grid-1x2-fill"></i> Dashboard</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/student/eligible-companies"><i class="bi bi-briefcase-fill"></i> Eligible Companies</a></li>
        <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/student/my-applications"><i class="bi bi-file-earmark-text-fill"></i> My Applications</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/student/resume"><i class="bi bi-file-pdf-fill"></i> Resume & ATS</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/student/profile"><i class="bi bi-person-fill"></i> My Profile</a></li>
        <li class="nav-item mt-5"><a class="nav-link text-danger" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
    </ul>
</aside>

<main class="main-content">
    <header class="top-header">
        <div>
            <h2 class="h4 fw-bold mb-1">My Applications</h2>
            <p class="text-muted small mb-0">Track the status of all your job applications.</p>
        </div>
        <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center fw-bold shadow-sm" style="width: 42px; height: 42px;">
            ${fn:substring(sessionScope.userName, 0, 1)}
        </div>
    </header>

    <div class="glass-card">
        <div class="table-responsive">
            <table class="table table-hover align-middle border-0">
                <thead class="border-bottom border-light">
                <tr>
                    <th class="text-muted small fw-bold">Company</th>
                    <th class="text-muted small fw-bold">Package</th>
                    <th class="text-muted small fw-bold">Applied Date</th>
                    <th class="text-muted small fw-bold">Status</th>
                    <th class="text-muted small fw-bold">Feedback & Rating</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${applications}" var="a">
                    <tr>
                        <td class="fw-bold fs-6 text-dark">${a.companyName}</td>
                        <td class="text-success fw-bold">${a.packageLpa} LPA</td>
                        <td class="text-muted"><fmt:formatDate value="${a.appliedAt}" pattern="dd MMM yyyy"/></td>
                        <td>
                                <span class="badge ${a.status == 'SELECTED' ? 'bg-success' : (a.status == 'REJECTED' ? 'bg-danger' : 'bg-primary')} rounded-pill px-3 py-2">
                                        ${a.status}
                                </span>
                        </td>
                        <td>
                            <c:if test="${not empty a.feedback}">
                                <div class="text-warning mb-1">
                                    <c:forEach begin="1" end="${a.rating}"><i class="bi bi-star-fill"></i></c:forEach>
                                    <c:forEach begin="${a.rating + 1}" end="5"><i class="bi bi-star"></i></c:forEach>
                                </div>
                                <small class="text-muted fst-italic">"${a.feedback}"</small>
                            </c:if>
                            <c:if test="${empty a.feedback}"><span class="text-muted small">Pending</span></c:if>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty applications}">
                    <tr><td colspan="5" class="text-center py-5 text-muted">
                        <i class="bi bi-inbox fs-1 d-block mb-2 text-secondary"></i>
                        You haven't applied to any companies yet.
                    </td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</main>
</body>
</html>