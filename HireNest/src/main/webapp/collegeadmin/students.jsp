<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Students - HireNest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; overflow-x: hidden; }

        /* Teal Sidebar */
        .sidebar { width: 260px; background-color: #0F172A; color: #94a3b8; position: fixed; height: 100vh; top: 0; left: 0; z-index: 1000; padding-top: 1rem; border-right: 1px solid #1e293b; }
        .sidebar-brand { color: white; font-size: 1.5rem; font-weight: 700; padding: 1rem 1.5rem; display: flex; align-items: center; gap: 10px; margin-bottom: 1rem; }
        .sidebar-brand i { color: #0d9488; }
        .nav-item { margin: 0.25rem 1rem; }
        .nav-link { color: #94a3b8; border-radius: 8px; padding: 0.75rem 1rem; font-weight: 500; display: flex; align-items: center; gap: 12px; transition: all 0.2s; text-decoration: none; }
        .nav-link:hover, .nav-link.active { background-color: rgba(255, 255, 255, 0.1); color: white; }
        .nav-link.active { background-color: #0d9488; color: white; }

        .main-content { margin-left: 260px; padding: 2rem; min-height: 100vh; }
        .top-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; background: rgba(255, 255, 255, 0.7); backdrop-filter: blur(10px); padding: 1rem 1.5rem; border-radius: 16px; border: 1px solid rgba(255, 255, 255, 0.5); box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05); }
        .glass-card { background: white; border-radius: 16px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05); border: 1px solid #e2e8f0; padding: 1.5rem; }
    </style>
</head>
<body>

<aside class="sidebar">
    <div class="sidebar-brand"><i class="bi bi-bank"></i> HireNest</div>
    <ul class="nav flex-column mt-3">
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/collegeadmin/dashboard"><i class="bi bi-grid-1x2-fill"></i> Dashboard</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/collegeadmin/pending-approvals"><i class="bi bi-person-check-fill"></i> Approvals</a></li>
        <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/collegeadmin/students"><i class="bi bi-people-fill"></i> Students</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/collegeadmin/companies"><i class="bi bi-building"></i> Companies</a></li>
        <li class="nav-item mt-5"><a class="nav-link text-danger" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
    </ul>
</aside>

<main class="main-content">
    <header class="top-header">
        <div>
            <h2 class="h4 fw-bold mb-1" style="color:#0f766e;">Student Placements</h2>
            <p class="text-muted small mb-0">Manage and record placements for your college.</p>
        </div>
        <div class="d-flex align-items-center gap-3">
            <div class="bg-teal-100 rounded-circle d-flex align-items-center justify-content-center fw-bold" style="width: 42px; height: 42px; background:#ccfbf1; color:#0f766e;">
                ${fn:substring(sessionScope.userName, 0, 1)}
            </div>
        </div>
    </header>

    <!-- NEW: Success/Error + CSV Upload Form - Added here, after header, before table -->
    <div class="mb-4">
        <c:if test="${not empty sessionScope.successMsg}">
            <div class="alert alert-success alert-dismissible">${sessionScope.successMsg}<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
            <c:remove var="successMsg" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.errorMsg}">
            <div class="alert alert-danger alert-dismissible">${sessionScope.errorMsg}<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
            <c:remove var="errorMsg" scope="session"/>
        </c:if>

        <!-- CSV UPLOAD FORM -->
        <form action="${pageContext.request.contextPath}/collegeadmin/import-students" method="POST" enctype="multipart/form-data" class="d-flex gap-2 align-items-center bg-white p-3 rounded shadow-sm border">
            <label class="fw-bold text-muted small mb-0">Bulk Import (CSV):</label>
            <input type="file" name="file" accept=".csv" required class="form-control form-control-sm w-auto">
            <button type="submit" class="btn btn-sm btn-primary fw-bold"><i class="bi bi-upload"></i> Upload CSV</button>
            <span class="text-muted small">Format: Name, Email, RollNo, Branch, Phone, CGPA</span>
        </form>
    </div>

    <div class="glass-card">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                <tr>
                    <th>Student Name</th>
                    <th>Roll No</th>
                    <th>Branch</th>
                    <th>CGPA</th>
                    <th>Placement Status</th>
                    <th class="text-end">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${students}" var="s">
                    <tr>
                        <td>
                            <div class="fw-bold text-dark">${s.name}</div>
                            <div class="small text-muted">${s.email}</div>
                        </td>
                        <td>${s.registrationNo}</td>
                        <td>${s.branch}</td>
                        <td><span class="badge bg-secondary">${s.cgpa}</span></td>
                        <td>
                            <c:choose>
                                <c:when test="${s.placed}">
                                    <span class="badge bg-success mb-1">PLACED</span>
                                    <div class="small text-muted">${s.placedCompany} (${s.placedPackage} LPA)</div>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-warning text-dark">UNPLACED</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-end">
                            <c:choose>
                                <c:when test="${s.placed}">
                                    <!-- Revert Button -->
                                    <form action="${pageContext.request.contextPath}/collegeadmin/students" method="POST" class="d-inline" onsubmit="return confirm('Revert placement?');">
                                        <input type="hidden" name="action" value="unplace">
                                        <input type="hidden" name="studentId" value="${s.id}">
                                        <button type="submit" class="btn btn-sm btn-outline-danger" title="Mark Unplaced"><i class="bi bi-x-circle"></i></button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <!-- Trophy Button triggers modal -->
                                    <button type="button" class="btn btn-sm btn-outline-success fw-bold" data-bs-toggle="modal" data-bs-target="#placeModal${s.id}">
                                        <i class="bi bi-trophy-fill"></i> Mark Placed
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty students}">
                    <tr><td colspan="6" class="text-center py-4 text-muted">No students found.</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</main>

<!-- Modals -->
<c:forEach items="${students}" var="s">
    <c:if test="${!s.placed}">
        <div class="modal fade" id="placeModal${s.id}" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg" style="border-radius: 16px;">
                    <form action="${pageContext.request.contextPath}/collegeadmin/students" method="POST">
                        <input type="hidden" name="action" value="markPlaced">
                        <input type="hidden" name="studentId" value="${s.id}">
                        <div class="modal-header bg-teal-50 border-0" style="border-radius: 16px 16px 0 0; background-color: #ccfbf1;">
                            <h5 class="modal-title fw-bold" style="color: #0f766e;"><i class="bi bi-trophy-fill me-2"></i> Register Placement</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body p-4">
                            <p class="text-muted mb-4">Enter placement details for <strong>${s.name}</strong>.</p>
                            <div class="mb-3">
                                <label class="form-label fw-bold small">Company Name</label>
                                <input type="text" name="companyName" class="form-control" required placeholder="e.g. TCS, Infosys">
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold small">Package (LPA)</label>
                                <input type="number" step="0.1" name="packageLpa" class="form-control" required placeholder="e.g. 12.5">
                            </div>
                        </div>
                        <div class="modal-footer border-0">
                            <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-success">Save Placement</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </c:if>
</c:forEach>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>