
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Recruiters - College Admin</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ca-dashboard.css">
</head>

<body>

<header class="ca-topbar">

    <div class="ca-brand">
        <div class="ca-brand-icon">
            <i class="fas fa-university"></i>
        </div>

        <div>
            <div class="ca-brand-name">HireNest</div>
            <div class="ca-brand-sub">
                <c:out value="${sessionScope.collegeName}"/>
            </div>
        </div>
    </div>

    <nav class="ca-tabs">
        <a href="${pageContext.request.contextPath}/collegeadmin/dashboard" class="ca-tab">
            <i class="fas fa-chart-line"></i> Dashboard
        </a>

        <a href="${pageContext.request.contextPath}/collegeadmin/students" class="ca-tab">
            <i class="fas fa-user-graduate"></i> Students
        </a>

        <a href="${pageContext.request.contextPath}/collegeadmin/recruiters" class="ca-tab active">
            <i class="fas fa-building"></i> Recruiters
        </a>

        <a href="${pageContext.request.contextPath}/collegeadmin/applications" class="ca-tab">
            <i class="fas fa-file-alt"></i> Applications
        </a>
    </nav>

    <div class="ca-user">
        <div class="ca-avatar">
            <c:out value="${fn:substring(sessionScope.userName, 0, 1)}"/>
        </div>

        <div class="ca-user-info">
            <div class="ca-user-name">
                <c:out value="${sessionScope.userName}"/>
            </div>
            <div class="ca-user-role">College Admin</div>
        </div>

        <a href="${pageContext.request.contextPath}/collegeadmin/logout" class="ca-logout">
            <i class="fas fa-sign-out-alt"></i>
        </a>
    </div>

</header>


<main class="ca-main">

    <!-- SUCCESS MESSAGE -->
    <c:if test="${not empty sessionScope.successMsg}">
        <div class="alert alert-success alert-dismissible fade show">
            <i class="fas fa-check-circle"></i>
            <c:out value="${sessionScope.successMsg}"/>

            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>

        <c:remove var="successMsg" scope="session"/>
    </c:if>


    <!-- ERROR MESSAGE -->
    <c:if test="${not empty sessionScope.errorMsg}">
        <div class="alert alert-danger alert-dismissible fade show">
            <i class="fas fa-exclamation-circle"></i>
            <c:out value="${sessionScope.errorMsg}"/>

            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>

        <c:remove var="errorMsg" scope="session"/>
    </c:if>


    <!-- PAGE TITLE AND FILTERS -->
    <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">

        <h2 style="font-size:22px; font-weight:700; color:#134e4a; margin:0;">
            Manage Recruiters
        </h2>

        <div class="d-flex flex-wrap gap-1">

            <a href="${pageContext.request.contextPath}/collegeadmin/recruiters"
               class="btn btn-sm ${empty filter ? 'btn-success' : 'btn-outline-secondary'}">
                All (${statusCounts.Total})
            </a>

            <a href="${pageContext.request.contextPath}/collegeadmin/recruiters?status=PENDING"
               class="btn btn-sm ${filter == 'PENDING' ? 'btn-success' : 'btn-outline-secondary'}">
                Pending (${statusCounts.PENDING})
            </a>

            <a href="${pageContext.request.contextPath}/collegeadmin/recruiters?status=APPROVED"
               class="btn btn-sm ${filter == 'APPROVED' ? 'btn-success' : 'btn-outline-secondary'}">
                Approved (${statusCounts.APPROVED})
            </a>

            <a href="${pageContext.request.contextPath}/collegeadmin/recruiters?status=REJECTED"
               class="btn btn-sm ${filter == 'REJECTED' ? 'btn-success' : 'btn-outline-secondary'}">
                Rejected (${statusCounts.REJECTED})
            </a>

        </div>
    </div>


    <!-- RECRUITER TABLE -->
    <div class="ca-card">

        <c:choose>

            <c:when test="${empty recruiters}">

                <div class="ca-empty">
                    <i class="fas fa-building"></i>
                    <p>No recruiters found</p>
                </div>

            </c:when>


            <c:otherwise>

                <div class="table-responsive">

                    <table class="ca-table">

                        <thead>
                        <tr>
                            <th>Company</th>
                            <th>HR Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Website</th>
                            <th>Registered</th>
                            <th>Email Verification</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                        </thead>


                        <tbody>

                        <c:forEach items="${recruiters}" var="r">

                            <tr>

                                <!-- COMPANY -->
                                <td>
                                    <strong>
                                        <c:out value="${r.companyName}"/>
                                    </strong>
                                </td>


                                <!-- HR NAME -->
                                <td>
                                    <c:out value="${r.hrName}"/>
                                </td>


                                <!-- EMAIL -->
                                <td>
                                    <c:out value="${r.hrEmail}"/>
                                </td>


                                <!-- PHONE -->
                                <td>
                                    <c:out value="${r.phone}"/>
                                </td>


                                <!-- WEBSITE -->
                                <td>

                                    <c:if test="${not empty r.website}">

                                        <a href="<c:out value='${r.website}'/>"
                                           target="_blank"
                                           rel="noopener noreferrer"
                                           style="color:#0d9488;">

                                            <i class="fas fa-external-link-alt"></i>

                                        </a>

                                    </c:if>

                                </td>


                                <!-- REGISTRATION DATE -->
                                <td>

                                    <c:if test="${not empty r.createdAt}">
                                        <fmt:formatDate value="${r.createdAt}"
                                                        pattern="dd MMM yyyy"/>
                                    </c:if>

                                    <c:if test="${empty r.createdAt}">
                                        -
                                    </c:if>

                                </td>


                                <!-- EMAIL VERIFICATION -->
                                <td>

                                    <c:choose>

                                        <c:when test="${r.emailVerified == true}">
                                            <span class="ca-badge ca-badge-green">
                                                <i class="fas fa-check-circle"></i>
                                                Verified
                                            </span>
                                        </c:when>

                                        <c:otherwise>
                                            <span class="ca-badge ca-badge-amber">
                                                <i class="fas fa-clock"></i>
                                                Not Verified
                                            </span>
                                        </c:otherwise>

                                    </c:choose>

                                </td>


                                <!-- RECRUITER STATUS -->
                                <td>

                                    <c:choose>

                                        <c:when test="${r.status == 'APPROVED'}">
                                            <span class="ca-badge ca-badge-green">
                                                Approved
                                            </span>
                                        </c:when>

                                        <c:when test="${r.status == 'PENDING'}">
                                            <span class="ca-badge ca-badge-amber">
                                                Pending
                                            </span>
                                        </c:when>

                                        <c:when test="${r.status == 'REJECTED'}">
                                            <span class="ca-badge ca-badge-red">
                                                Rejected
                                            </span>
                                        </c:when>

                                        <c:otherwise>
                                            <span class="ca-badge">
                                                <c:out value="${r.status}"/>
                                            </span>
                                        </c:otherwise>

                                    </c:choose>

                                </td>


                                <!-- ACTIONS -->
                                <td>

                                    <!-- PENDING RECRUITER -->
                                    <c:if test="${r.status == 'PENDING'}">

                                        <c:choose>

                                            <c:when test="${r.emailVerified == true}">

                                                <!-- APPROVE FORM -->
                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/collegeadmin/recruiters"
                                                      style="display:inline;">

                                                    <input type="hidden" name="id"
                                                           value="<c:out value='${r.id}'/>">

                                                    <input type="hidden" name="action"
                                                           value="approve">

                                                    <button type="submit"
                                                            class="btn btn-sm btn-success"
                                                            onclick="return confirm('Approve this recruiter?');">

                                                        <i class="fas fa-check"></i>
                                                        Approve

                                                    </button>

                                                </form>


                                                <!-- REJECT FORM -->
                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/collegeadmin/recruiters"
                                                      style="display:inline;">

                                                    <input type="hidden" name="id"
                                                           value="<c:out value='${r.id}'/>">

                                                    <input type="hidden" name="action"
                                                           value="reject">

                                                    <button type="submit"
                                                            class="btn btn-sm btn-danger"
                                                            onclick="return confirm('Reject this recruiter?');">

                                                        <i class="fas fa-times"></i>
                                                        Reject

                                                    </button>

                                                </form>

                                            </c:when>


                                            <c:otherwise>

                                                <span style="color:#d97706; font-size:12px;">
                                                    <i class="fas fa-exclamation-circle"></i>
                                                    Verify email first
                                                </span>

                                            </c:otherwise>

                                        </c:choose>

                                    </c:if>


                                    <!-- APPROVED RECRUITER -->
                                    <c:if test="${r.status == 'APPROVED'}">

                                        <span style="color:#0d9488; font-size:12px;">
                                            <i class="fas fa-check-circle"></i>
                                            Can post jobs
                                        </span>

                                    </c:if>


                                    <!-- REJECTED RECRUITER -->
                                    <c:if test="${r.status == 'REJECTED'}">

                                        <form method="post"
                                              action="${pageContext.request.contextPath}/collegeadmin/recruiters"
                                              style="display:inline;">

                                            <input type="hidden" name="id"
                                                   value="<c:out value='${r.id}'/>">

                                            <input type="hidden" name="action"
                                                   value="approve">

                                            <button type="submit"
                                                    class="btn btn-sm btn-outline-success"
                                                    onclick="return confirm('Approve this recruiter again?');">

                                                <i class="fas fa-redo"></i>
                                                Reconsider

                                            </button>

                                        </form>

                                    </c:if>

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


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
