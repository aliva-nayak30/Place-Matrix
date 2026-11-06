<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pending Approvals - HireNest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ca-dashboard.css">
</head>
<body>

<header class="ca-topbar">
    <div class="ca-brand">
        <div class="ca-brand-icon"><i class="fas fa-university"></i></div>
        <div>
            <div class="ca-brand-name">HireNest</div>
            <div class="ca-brand-sub">${sessionScope.collegeName}</div>
        </div>
    </div>

    <nav class="ca-tabs">
        <a href="${pageContext.request.contextPath}/collegeadmin/dashboard" class="ca-tab"><i class="fas fa-chart-line"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/collegeadmin/pending-approvals" class="ca-tab active"><i class="fas fa-user-clock"></i> Approvals</a>
        <a href="${pageContext.request.contextPath}/collegeadmin/companies" class="ca-tab"><i class="fas fa-building"></i> Companies</a>
        <a href="${pageContext.request.contextPath}/collegeadmin/applications" class="ca-tab"><i class="fas fa-file-alt"></i> Applications</a>
        <a href="${pageContext.request.contextPath}/collegeadmin/leaderboard" class="ca-tab"><i class="fas fa-trophy"></i> Leaderboard</a>
    </nav>

    <div class="ca-user">
        <div class="ca-avatar">${fn:substring(sessionScope.userName, 0, 1)}</div>
        <div class="ca-user-info">
            <div class="ca-user-name">${sessionScope.userName}</div>
            <div class="ca-user-role">College Admin</div>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="ca-logout"><i class="fas fa-sign-out-alt"></i></a>
    </div>
</header>

<main class="ca-main">

    <h2 style="font-weight: 700; color: #1e293b; margin-bottom: 20px;">Approvals Dashboard</h2>

    <!-- SECTION 1: PENDING RECRUITERS -->
    <div class="ca-card mb-4">
        <div class="ca-card-title">
            <span><i class="fas fa-building text-primary"></i> Pending Recruiter Requests</span>
        </div>

        <c:choose>
            <c:when test="${empty pendingRecruiters}">
                <div class="ca-empty py-3">
                    <i class="fas fa-check-circle text-success"></i> No pending recruiter requests.
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="ca-table">
                        <thead>
                        <tr>
                            <th>Contact Person</th>
                            <th>Company</th>
                            <th>Email</th>
                            <th>Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${pendingRecruiters}" var="r">
                            <tr>
                                <td><strong>${r.name}</strong></td>
                                <td><span class="badge bg-secondary">${r.companyName}</span></td>
                                <td>${r.email}</td>
                                <td>
                                    <form method="POST" action="${pageContext.request.contextPath}/collegeadmin/pending-approvals" style="display:inline;">
                                        <input type="hidden" name="type" value="RECRUITER">
                                        <input type="hidden" name="userId" value="${r.userId}">
                                        <button type="submit" name="action" value="APPROVED" class="btn btn-sm btn-success" style="border-radius:6px;">
                                            <i class="fas fa-check"></i> Approve
                                        </button>
                                        <button type="submit" name="action" value="REJECTED" class="btn btn-sm btn-danger" style="border-radius:6px;" onclick="return confirm('Reject this recruiter?');">
                                            <i class="fas fa-times"></i> Reject
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- SECTION 2: PENDING STUDENTS -->
    <div class="ca-card">
        <div class="ca-card-title">
            <span><i class="fas fa-user-graduate text-warning"></i> Pending Student Approvals</span>
        </div>

        <c:choose>
            <c:when test="${empty pendingStudents}">
                <div class="ca-empty py-3">
                    <i class="fas fa-check-circle text-success"></i> No pending student approvals.
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="ca-table">
                        <thead>
                        <tr>
                            <th>Name</th>
                            <th>Roll No</th>
                            <th>Branch</th>
                            <th>CGPA</th>
                            <th>Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${pendingStudents}" var="s">
                            <tr>
                                <td><strong>${s.name}</strong></td>
                                <td>${s.registrationNo}</td>
                                <td>${s.branch}</td>
                                <td><span class="badge bg-primary">${s.cgpa}</span></td>
                                <td>
                                    <form method="POST" action="${pageContext.request.contextPath}/collegeadmin/pending-approvals" style="display:inline;">
                                        <input type="hidden" name="type" value="STUDENT">
                                        <input type="hidden" name="studentId" value="${s.id}">
                                        <button type="submit" name="action" value="APPROVED" class="btn btn-sm btn-success" style="border-radius:6px;">
                                            <i class="fas fa-check"></i> Approve
                                        </button>
                                        <button type="submit" name="action" value="REJECTED" class="btn btn-sm btn-danger" style="border-radius:6px;" onclick="return confirm('Reject this student?');">
                                            <i class="fas fa-times"></i> Reject
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</main>

</body>
</html>