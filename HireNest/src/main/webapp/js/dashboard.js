/* ============================================
   DASHBOARD.JS - HireNest Student Dashboard
   ============================================ */

document.addEventListener('DOMContentLoaded', function() {

    console.log('🚀 HireNest Dashboard loaded');

    // ============================================
    // 1. CHART.JS DOUGHNUT CHART
    // ============================================
    initApplicationChart();

    // ============================================
    // 2. STAT COUNTER ANIMATION
    // ============================================
    animateStatCounters();

});


/* ============================================
   APPLICATION CHART
   ============================================ */
function initApplicationChart() {
    var canvas = document.getElementById('applicationChart');
    if (!canvas) return;

    var ctx = canvas.getContext('2d');

    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Applied', 'Shortlisted', 'Interview', 'Rejected'],
            datasets: [{
                data: [10, 2, 1, 3],
                backgroundColor: [
                    '#3b82f6',
                    '#10b981',
                    '#f59e0b',
                    '#ef4444'
                ],
                borderWidth: 0,
                hoverOffset: 8,
                spacing: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '65%',
            plugins: {
                legend: {
                    position: 'right',
                    labels: {
                        padding: 18,
                        usePointStyle: true,
                        pointStyle: 'circle',
                        font: {
                            family: 'Inter',
                            size: 13,
                            weight: '500'
                        },
                        color: '#64748b',
                        generateLabels: function(chart) {
                            var data = chart.data;
                            if (data.labels.length && data.datasets.length) {
                                var dataset = data.datasets[0];
                                return data.labels.map(function(label, i) {
                                    var value = dataset.data[i];
                                    return {
                                        text: label + '  (' + value + ')',
                                        fillStyle: dataset.backgroundColor[i],
                                        strokeStyle: dataset.backgroundColor[i],
                                        lineWidth: 0,
                                        pointStyle: 'circle',
                                        hidden: false,
                                        index: i
                                    };
                                });
                            }
                            return [];
                        }
                    }
                },
                tooltip: {
                    backgroundColor: '#1e293b',
                    padding: 12,
                    titleFont: {
                        family: 'Inter',
                        size: 13,
                        weight: '600'
                    },
                    bodyFont: {
                        family: 'Inter',
                        size: 12
                    },
                    cornerRadius: 8,
                    displayColors: true,
                    callbacks: {
                        label: function(context) {
                            return '  ' + context.label + ': ' + context.parsed;
                        }
                    }
                }
            },
            animation: {
                animateScale: true,
                animateRotate: true,
                duration: 1200,
                easing: 'easeOutQuart'
            }
        }
    });
}


/* ============================================
   STAT COUNTER ANIMATION
   ============================================ */
function animateStatCounters() {
    var statValues = document.querySelectorAll('.stat-value');

    statValues.forEach(function(el) {
        var target = parseInt(el.getAttribute('data-target')) || 0;
        var suffix = el.getAttribute('data-suffix') || '';
        var current = 0;
        var increment = target / 40;
        var duration = 1000;
        var step = duration / 40;

        var timer = setInterval(function() {
            current += increment;
            if (current >= target) {
                el.textContent = target + suffix;
                clearInterval(timer);
            } else {
                el.textContent = Math.floor(current) + suffix;
            }
        }, step);
    });
}


/* ============================================
   MOBILE SIDEBAR TOGGLE
   ============================================ */
function toggleSidebar() {
    var sidebar = document.getElementById('sidebar');
    if (sidebar) {
        sidebar.classList.toggle('open');
    }
}

// Close sidebar when clicking outside on mobile
document.addEventListener('click', function(e) {
    var sidebar = document.getElementById('sidebar');
    var toggle = document.querySelector('.mobile-toggle');

    if (!sidebar || !toggle) return;

    if (window.innerWidth <= 992) {
        if (!sidebar.contains(e.target) && !toggle.contains(e.target)) {
            sidebar.classList.remove('open');
        }
    }
});


/* ============================================
   NOTIFICATION BELL CLICK
   ============================================ */
document.addEventListener('DOMContentLoaded', function() {
    var bellBtn = document.querySelector('.navbar-icon-btn');
    if (bellBtn) {
        bellBtn.addEventListener('click', function() {
            console.log('Notifications clicked');
            // Add your notification panel logic here
        });
    }
});