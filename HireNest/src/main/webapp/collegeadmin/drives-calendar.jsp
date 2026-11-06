<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Drive Calendar - HireNest</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.css' rel='stylesheet' />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ca-dashboard.css">
    <style>
        #calendar { background: white; padding: 20px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .fc-event { cursor: pointer; font-weight: 600; border: none; }
    </style>
</head>
<body>
<header class="ca-topbar">
    <div class="ca-brand"><div class="ca-brand-icon"><i class="fas fa-university"></i></div><div><div class="ca-brand-name">HireNest</div></div></div>
    <nav class="ca-tabs">
        <a href="${pageContext.request.contextPath}/collegeadmin/dashboard" class="ca-tab"><i class="fas fa-chart-line"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/collegeadmin/drives-calendar" class="ca-tab active"><i class="fas fa-calendar-alt"></i> Calendar</a>
    </nav>
    <div class="ca-user"><div class="ca-avatar">${fn:substring(sessionScope.userName, 0, 1)}</div></div>
</header>

<main class="ca-main">
    <h2 style="font-weight: 700; color: #1e293b; margin-bottom: 20px;">Company Drive Schedule</h2>
    <div id='calendar'></div>
</main>

<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js'></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        var calendarEl = document.getElementById('calendar');
        var calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: 'dayGridMonth,timeGridWeek'
            },
            events: '${pageContext.request.contextPath}/collegeadmin/calendar-events'
        });
        calendar.render();
    });
</script>
</body>
</html>