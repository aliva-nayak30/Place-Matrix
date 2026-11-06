<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String pendingEmail = (String) session.getAttribute("pendingEmail");
    if (pendingEmail == null) {
        response.sendRedirect("register");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Verify Email — HireNest</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f3f4f6; margin: 0; padding: 40px; }
        .card { max-width: 420px; margin: auto; background: #fff; padding: 32px;
            border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
        h1   { color: #1e3a8a; margin: 0 0 8px; font-size: 24px; }
        p    { color: #4b5563; margin: 0 0 20px; }
        .alert-error   { background: #fee2e2; color: #991b1b; padding: 10px 14px;
            border-radius: 8px; margin-bottom: 16px; font-size: 14px; }
        .alert-success { background: #dcfce7; color: #166534; padding: 10px 14px;
            border-radius: 8px; margin-bottom: 16px; font-size: 14px; }
        input[type=text] { width: 100%; padding: 14px; font-size: 24px; letter-spacing: 8px;
            text-align: center; border: 1px solid #d1d5db; border-radius: 8px;
            box-sizing: border-box; margin-bottom: 16px; }
        button { width: 100%; padding: 12px; font-size: 15px; border: none;
            border-radius: 8px; cursor: pointer; }
        .btn-primary { background: #1e3a8a; color: #fff; }
        .btn-primary:hover { background: #1e40af; }
        .resend-row { display: flex; justify-content: space-between; align-items: center;
            margin-top: 16px; font-size: 14px; color: #6b7280; }
        .btn-link { background: none; color: #1e3a8a; padding: 0; width: auto;
            text-decoration: underline; cursor: pointer; border: none; font-size: 14px; }
    </style>
</head>
<body>
<div class="card">
    <h1>Verify your email</h1>
    <p>We sent a 6-digit code to <b><%= pendingEmail %></b>. It expires in 5 minutes.</p>

    <% String error   = (String) request.getAttribute("error");   %>
    <% String success = (String) request.getAttribute("success"); %>
    <% if (error   != null) { %><div class="alert-error"><%= error %></div><% } %>
    <% if (success != null) { %><div class="alert-success"><%= success %></div><% } %>

    <form method="post" action="verify-otp">
        <input type="text" name="otp" maxlength="6" pattern="[0-9]{6}"
               inputmode="numeric" autocomplete="one-time-code" required autofocus />
        <button type="submit" class="btn-primary">Verify</button>
    </form>

    <div class="resend-row">
        <span>Didn't receive it?</span>
        <form method="post" action="resend-otp" style="margin:0;">
            <button type="submit" class="btn-link">Resend OTP</button>
        </form>
    </div>
</div>
</body>
</html>