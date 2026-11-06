<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, entity.College" %>
<%
    String selectedRole = (String) request.getAttribute("selectedRole");
    if (selectedRole == null) selectedRole = "STUDENT";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register - HireNest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { font-family: 'Inter', sans-serif; background: #0F172A; color: white; padding: 40px 20px; }
        .register-card { max-width: 600px; margin: auto; background: rgba(30, 41, 59, 0.7); backdrop-filter: blur(16px); padding: 40px; border-radius: 20px; border: 1px solid rgba(255,255,255,0.1); box-shadow: 0 25px 50px -12px rgba(0,0,0,0.5); }
        .form-control, .form-select { background: rgba(15, 23, 42, 0.6); border: 1px solid rgba(255,255,255,0.1); color: white; }
        .form-control:focus, .form-select:focus { background: rgba(15, 23, 42, 0.9); color: white; border-color: #3b82f6; box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.2); }
        .form-select option { background: #0F172A; color: white; }
        .role-selector { display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; margin-bottom: 20px; }
        .role-btn { background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); padding: 15px; border-radius: 12px; text-align: center; cursor: pointer; color: #94a3b8; transition: 0.2s; }
        .role-btn.active { background: rgba(59, 130, 246, 0.2); border-color: #3b82f6; color: #60a5fa; }
        .role-btn i { font-size: 1.5rem; margin-bottom: 5px; display: block; }
    </style>
</head>
<body>

<div class="register-card">
    <div class="text-center mb-4">
        <h2 class="fw-bold">Create your account</h2>
    </div>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger"><i class="bi bi-exclamation-circle"></i> <%= request.getAttribute("error") %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/register" method="POST" id="regForm">
        <input type="hidden" name="role" id="roleInput" value="<%= selectedRole %>">

        <label class="form-label text-light small fw-medium mb-2">Select Your Role</label>
        <div class="role-selector">
            <div class="role-btn <%= "STUDENT".equals(selectedRole) ? "active" : "" %>" onclick="setRole('STUDENT', this)">
                <i class="bi bi-mortarboard"></i> Student
            </div>
            <div class="role-btn <%= "RECRUITER".equals(selectedRole) ? "active" : "" %>" onclick="setRole('RECRUITER', this)">
                <i class="bi bi-building"></i> Recruiter
            </div>
            <div class="role-btn <%= "COLLEGE_ADMIN".equals(selectedRole) ? "active" : "" %>" onclick="setRole('COLLEGE_ADMIN', this)">
                <i class="bi bi-bank"></i> Admin
            </div>
        </div>

        <div class="mb-3" id="collegeGroup">
            <label class="form-label text-light small fw-medium">Select College</label>
            <select name="collegeId" id="collegeSelect" class="form-select">
                <option value="">-- Select your college --</option>
                <% List<College> colleges = (List<College>) request.getAttribute("colleges");
                    if (colleges != null) { for (College c : colleges) { %>
                <option value="<%= c.getId() %>"><%= c.getCollegeName() %></option>
                <% } } %>
            </select>
        </div>

        <div class="mb-3">
            <label class="form-label text-light small fw-medium">Full Name *</label>
            <input type="text" name="name" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label text-light small fw-medium">Email Address *</label>
            <input type="email" name="email" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label text-light small fw-medium">Password *</label>
            <input type="password" name="password" class="form-control" required minlength="8">
        </div>

        <div class="mb-3">
            <label class="form-label text-light small fw-medium">Phone Number</label>
            <input type="tel" name="phone" class="form-control">
        </div>

        <!-- Student Fields -->
        <div id="studentFields">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label text-light small fw-medium">Registration No *</label>
                    <input type="text" name="regNo" class="form-control">
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label text-light small fw-medium">Branch *</label>
                    <input type="text" name="branch" class="form-control" placeholder="e.g. MCA">
                </div>
            </div>
        </div>

        <!-- College Admin Fields -->
        <div id="adminFields" style="display: none;">
            <div class="mb-3">
                <label class="form-label text-light small fw-medium">College Name *</label>
                <input type="text" name="collegeName" class="form-control">
            </div>
            <div class="mb-3">
                <label class="form-label text-light small fw-medium">College Code *</label>
                <input type="text" name="collegeCode" class="form-control">
            </div>
        </div>

        <button type="submit" class="btn btn-primary w-100 py-2 mt-4" style="background:#3b82f6; border:none; font-weight:600;">
            Create Account <i class="bi bi-arrow-right"></i>
        </button>
    </form>
</div>

<script>
    function setRole(role, el) {
        document.getElementById('roleInput').value = role;
        document.querySelectorAll('.role-btn').forEach(b => b.classList.remove('active'));
        el.classList.add('active');

        // Toggle fields
        if (role === 'STUDENT') {
            document.getElementById('studentFields').style.display = 'block';
            document.getElementById('adminFields').style.display = 'none';
            document.getElementById('collegeGroup').style.display = 'block';
        } else if (role === 'COLLEGE_ADMIN') {
            document.getElementById('studentFields').style.display = 'none';
            document.getElementById('adminFields').style.display = 'block';
            document.getElementById('collegeGroup').style.display = 'none';
        } else {
            document.getElementById('studentFields').style.display = 'none';
            document.getElementById('adminFields').style.display = 'none';
            document.getElementById('collegeGroup').style.display = 'block';
        }
    }
    // Trigger on load
    setRole('<%= selectedRole %>', document.querySelector('.role-btn.active'));
</script>
</body>
</html>