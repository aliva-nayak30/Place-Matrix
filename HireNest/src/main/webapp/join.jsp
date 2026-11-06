
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="entity.InviteToken, entity.College" %>

<%
    InviteToken invite = (InviteToken) request.getAttribute("invite");
    College college = (College) request.getAttribute("college");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Join HireNest</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: #0F172A;
            color: white;
            padding: 40px 20px;
            min-height: 100vh;
        }

        .join-card {
            max-width: 500px;
            margin: auto;
            background: rgba(30, 41, 59, 0.7);
            backdrop-filter: blur(16px);
            padding: 40px;
            border-radius: 20px;
            border: 1px solid rgba(255,255,255,0.1);
        }

        .form-control {
            background: rgba(15, 23, 42, 0.6);
            border: 1px solid rgba(255,255,255,0.1);
            color: white;
            padding: 12px;
        }

        .form-control:focus {
            background: rgba(15, 23, 42, 0.9);
            color: white;
            border-color: #3b82f6;
            box-shadow: 0 0 0 0.2rem rgba(59,130,246,0.2);
        }

        .form-control[readonly] {
            background: rgba(255,255,255,0.1);
            cursor: not-allowed;
        }

        .form-control::placeholder {
            color: #94a3b8;
        }

        .form-label {
            color: #e2e8f0;
        }

        .register-btn {
            background: #3b82f6;
            border: none;
            font-weight: 600;
        }

        .register-btn:hover {
            background: #2563eb;
        }

        .text-muted {
            color: #94a3b8 !important;
        }
    </style>
</head>

<body>

<div class="join-card">

    <div class="text-center mb-4">

        <i class="bi bi-mortarboard-fill text-primary"
           style="font-size: 3rem;"></i>

        <h2 class="fw-bold mt-3">Join HireNest</h2>

        <% if (college != null) { %>
        <p class="text-muted">
            You are joining
            <strong><%= college.getCollegeName() %></strong>
        </p>
        <% } %>

    </div>

    <% if (error != null) { %>
    <div class="alert alert-danger">
        <i class="bi bi-exclamation-circle"></i>
        <%= error %>
    </div>
    <% } %>

    <% if (invite == null) { %>

    <div class="text-center py-5">

        <i class="bi bi-link-45deg text-danger"
           style="font-size: 4rem;"></i>

        <h4 class="mt-3">Link Invalid</h4>

        <p class="text-muted">
            This invite link is expired or invalid.
        </p>

        <a href="${pageContext.request.contextPath}/login.jsp"
           class="btn btn-outline-light mt-3">
            Go to Login
        </a>

    </div>

    <% } else { %>

    <form action="${pageContext.request.contextPath}/join"
          method="POST">

        <!-- Invitation token -->
        <input type="hidden"
               name="token"
               value="<%= invite.getToken() %>">

        <!-- College -->
        <div class="mb-3">

            <label class="form-label small">College</label>

            <input type="text"
                   class="form-control"
                   value="<%= college != null ? college.getCollegeName() : "" %>"
                   readonly>

        </div>

        <!-- Role -->
        <div class="mb-3">

            <label class="form-label small">Role</label>

            <input type="text"
                   class="form-control"
                   value="<%= "STUDENT".equals(invite.getRole()) ? "Student" : "Recruiter" %>"
                   readonly>

        </div>

        <!-- Full Name -->
        <div class="mb-3">

            <label class="form-label small">
                Full Name *
            </label>

            <input type="text"
                   name="name"
                   class="form-control"
                   placeholder="Enter your full name"
                   maxlength="100"
                   required>

        </div>

        <!-- Email -->
        <div class="mb-3">

            <label class="form-label small">
                Email Address *
            </label>

            <input type="email"
                   name="email"
                   class="form-control"
                   placeholder="Enter your email"
                   maxlength="150"
                   required>

        </div>

        <!-- Phone Number -->
        <div class="mb-3">

            <label class="form-label small">
                Phone Number *
            </label>

            <input type="tel"
                   name="phone"
                   class="form-control"
                   placeholder="Enter 10 digit mobile number"
                   pattern="[0-9]{10}"
                   maxlength="10"
                   minlength="10"
                   required>

        </div>

        <!-- Password -->
        <div class="mb-3">

            <label class="form-label small">
                Password *
            </label>

            <input type="password"
                   name="password"
                   id="password"
                   class="form-control"
                   placeholder="Minimum 8 characters"
                   minlength="8"
                   required>

        </div>

        <!-- Confirm Password -->
        <div class="mb-3">

            <label class="form-label small">
                Confirm Password *
            </label>

            <input type="password"
                   id="confirmPassword"
                   class="form-control"
                   placeholder="Re-enter your password"
                   minlength="8"
                   required>

            <small id="passwordMessage"
                   class="text-danger"></small>

        </div>

        <!-- Student-specific fields -->
        <% if ("STUDENT".equals(invite.getRole())) { %>

        <div class="mb-3">

            <label class="form-label small">
                Registration Number *
            </label>

            <input type="text"
                   name="regNo"
                   class="form-control"
                   placeholder="Enter registration number"
                   required>

        </div>

        <div class="mb-3">

            <label class="form-label small">
                Branch *
            </label>

            <input type="text"
                   name="branch"
                   class="form-control"
                   placeholder="Enter your branch"
                   required>

        </div>

        <% } %>

        <!-- Register Button -->
        <button type="submit"
                class="btn btn-primary register-btn w-100 py-2 mt-3">

            <i class="bi bi-person-plus-fill"></i>
            Register

        </button>

    </form>

    <% } %>

</div>

<script>
    const form = document.querySelector("form");

    if (form) {
        form.addEventListener("submit", function(event) {

            const password =
                document.getElementById("password").value;

            const confirmPassword =
                document.getElementById("confirmPassword").value;

            const message =
                document.getElementById("passwordMessage");

            if (password !== confirmPassword) {

                event.preventDefault();

                message.textContent = "Passwords do not match.";

                document.getElementById("confirmPassword").focus();

                return;
            }

            message.textContent = "";
        });
    }
</script>

</body>
</html>
