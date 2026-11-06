<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login - HireNest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; margin: 0; padding: 0; background-color: #0F172A; min-height: 100vh; display: flex; flex-direction: column; }
        .login-wrapper { flex: 1; display: flex; flex-direction: row; min-height: calc(100vh - 50px); }
        .split-left { background-color: #0F172A; color: white; display: flex; flex-direction: column; justify-content: center; padding: 3rem 4rem; border-right: 1px solid rgba(255, 255, 255, 0.05); width: 45%; }
        .left-illustration { font-size: 5rem; margin-bottom: 1.5rem; color: #3b82f6; }
        .stats-box { display: flex; gap: 2rem; margin-top: 2rem; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 1.5rem; }
        .stat-number { font-size: 1.5rem; font-weight: 700; color: #60a5fa; }
        .stat-label { font-size: 0.875rem; color: #94a3b8; }
        .split-right { background: linear-gradient(135deg, #1e293b 0%, #0F172A 100%); display: flex; align-items: center; justify-content: center; padding: 2rem; width: 55%; }
        .login-form-container { width: 100%; max-width: 420px; background: rgba(30, 41, 59, 0.7); backdrop-filter: blur(16px); padding: 2.5rem; border-radius: 20px; border: 1px solid rgba(255, 255, 255, 0.1); }
        .brand-logo { font-size: 2rem; font-weight: 800; color: white; display: flex; align-items: center; gap: 10px; margin-bottom: 1rem; }
        .brand-logo i { color: #3b82f6; }
        h2 { color: white; }
        .text-muted { color: #94a3b8 !important; }
        .form-control { border-radius: 8px; padding: 0.75rem 1rem; border: 1px solid rgba(255, 255, 255, 0.1); background-color: rgba(15, 23, 42, 0.6); color: white; }
        .form-control:focus { background-color: rgba(15, 23, 42, 0.9); border-color: #3b82f6; color: white; box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.2); }
        .form-control::placeholder { color: #64748b; }
        .input-group-text { background-color: rgba(15, 23, 42, 0.6); border: 1px solid rgba(255, 255, 255, 0.1); border-right: none; color: #94a3b8; }
        .form-control.with-icon { border-left: none; }
        .btn-primary-custom { background-color: #3b82f6; color: white; border-radius: 8px; padding: 0.875rem; font-weight: 600; width: 100%; border: none; }
        .btn-primary-custom:hover { background-color: #2563eb; color: white; }
        .divider { display: flex; align-items: center; text-align: center; margin: 1.2rem 0; color: #64748b; font-size: 0.875rem; }
        .divider::before, .divider::after { content: ''; flex: 1; border-bottom: 1px solid rgba(255, 255, 255, 0.1); }
        .divider:not(:empty)::before { margin-right: .5em; }
        .divider:not(:empty)::after { margin-left: .5em; }
        .btn-outline-custom { border: 1px solid rgba(255, 255, 255, 0.2); background-color: transparent; color: white; border-radius: 8px; padding: 0.875rem; font-weight: 600; width: 100%; }
        .login-footer { height: 50px; display: flex; align-items: center; justify-content: center; color: #64748b; font-size: 0.85rem; background-color: #0F172A; border-top: 1px solid rgba(255, 255, 255, 0.05); }
        @media (max-width: 768px) { .login-wrapper { flex-direction: column; } .split-left { display: none; } .split-right { width: 100%; min-height: calc(100vh - 50px); } }
    </style>
</head>
<body>

<div class="login-wrapper">
    <div class="split-left">
        <i class="bi bi-mortarboard-fill left-illustration"></i>
        <h1 class="display-6 fw-bold mb-3">Your Gateway to<br>Dream Placement</h1>
        <p class="lead text-light opacity-75">Join the most advanced campus placement matrix platform.</p>
        <div class="stats-box">
            <div><div class="stat-number">5000+</div><div class="stat-label">Students Placed</div></div>
            <div><div class="stat-number">200+</div><div class="stat-label">Partner Companies</div></div>
        </div>
    </div>

    <div class="split-right">
        <div class="login-form-container">
            <div class="brand-logo"><i class="bi bi-bezier2"></i> HireNest</div>
            <h2 class="h3 fw-bold mb-1">Welcome Back</h2>
            <p class="text-muted mb-4">Login to your placement journey</p>

            <% String error = (String) request.getAttribute("error");
                if (error != null) { %>
            <div class="alert alert-danger py-2" style="border-radius: 8px; font-size: 0.9rem; background: rgba(239, 68, 68, 0.1); border-color: rgba(239, 68, 68, 0.2); color: #fca5a5;">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> <%= error %>
            </div>
            <% } %>

            <!-- NO ROLE SELECTION HERE -->
            <form action="${pageContext.request.contextPath}/login" method="POST">
                <div class="mb-3">
                    <label class="form-label text-light small fw-medium">Email Address</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                        <input type="email" name="email" class="form-control with-icon" placeholder="you@university.edu" required>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label text-light small fw-medium">Password</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-lock"></i></span>
                        <input type="password" name="password" id="password" class="form-control with-icon" placeholder="Enter your password" required>
                        <button class="btn btn-outline-secondary border-0 bg-transparent text-muted" type="button" onclick="togglePassword()" style="z-index: 5;">
                            <i class="bi bi-eye-slash" id="eyeIcon"></i>
                        </button>
                    </div>
                </div>

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="remember">
                        <label class="form-check-label text-muted small" for="remember">Remember me</label>
                    </div>
                    <a href="${pageContext.request.contextPath}/forgot-password" class="text-decoration-none small fw-medium" style="color: #60a5fa;">Forgot Password?</a>
                </div>

                <button type="submit" class="btn btn-primary-custom mb-3">Login</button>
            </form>

            <div class="divider">OR</div>

            <form action="${pageContext.request.contextPath}/login-otp" method="POST">
                <div class="input-group mb-3">
                    <span class="input-group-text"><i class="bi bi-envelope-check"></i></span>
                    <input type="email" name="email" class="form-control with-icon" placeholder="Enter email for OTP" required>
                </div>
                <button type="submit" class="btn btn-outline-custom">
                    <i class="bi bi-shield-lock me-2"></i> Login with OTP
                </button>
            </form>

            <div class="text-center text-muted small mt-4">
                Don't have an account? <br>
                <a href="${pageContext.request.contextPath}/register" class="text-decoration-none fw-semibold mt-1 d-inline-block" style="color: #60a5fa;">Register here</a>
            </div>
        </div>
    </div>
</div>

<footer class="login-footer">
    &copy; 2026 HireNest - Built for Campuses
</footer>

<script>
    function togglePassword() {
        const input = document.getElementById('password');
        const icon = document.getElementById('eyeIcon');
        if (input.type === 'password') { input.type = 'text'; icon.classList.replace('bi-eye-slash', 'bi-eye'); }
        else { input.type = 'password'; icon.classList.replace('bi-eye', 'bi-eye-slash'); }
    }
</script>
</body>
</html>