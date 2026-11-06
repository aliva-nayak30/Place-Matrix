<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<%
    Integer statusCode = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
    if (statusCode == null) statusCode = 500;
    String errMsg = (String) request.getAttribute("jakarta.servlet.error.message");
    if (errMsg == null || errMsg.isBlank()) errMsg = "Something went wrong.";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Error <%= statusCode %> — HireNest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-light d-flex align-items-center" style="min-height:100vh;">
<div class="container text-center">
    <h1 class="display-1 fw-bold text-primary"><%= statusCode %></h1>
    <p class="lead text-muted"><%= errMsg %></p>
    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary">
        <i class="fas fa-home"></i> Back to Home
    </a>
</div>
</body>
</html>