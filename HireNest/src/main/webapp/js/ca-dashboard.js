/* ============================================
   CA-DASHBOARD.JS — College Admin Charts
   ============================================ */

document.addEventListener('DOMContentLoaded', function () {

    // ==========================================
    // BRANCH-WISE PLACEMENT BAR CHART
    // ==========================================
    const branchCanvas = document.getElementById('branchChart');
    if (branchCanvas && typeof Chart !== 'undefined') {

        // Parse JSON data from data-* attributes
        let labels = [];
        let values = [];

        try {
            labels = JSON.parse(branchCanvas.dataset.labels || '[]');
            values = JSON.parse(branchCanvas.dataset.values || '[]');
        } catch (e) {
            console.error('Branch chart data parse error:', e);
        }

        new Chart(branchCanvas.getContext('2d'), {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Placed %',
                    data: values,
                    backgroundColor: ['#0d9488', '#14b8a6', '#2dd4bf', '#5eead4', '#99f6e4'],
                    borderRadius: 8,
                    barThickness: 42
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        backgroundColor: '#134e4a',
                        padding: 12,
                        cornerRadius: 8,
                        callbacks: {
                            label: function (ctx) { return ctx.parsed.y + '% placed'; }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 100,
                        ticks: { callback: v => v + '%', color: '#64748b' },
                        grid: { color: '#f0fdfa' }
                    },
                    x: {
                        ticks: { color: '#64748b', font: { family: 'Inter', size: 12 } },
                        grid: { display: false }
                    }
                },
                animation: { duration: 1000 }
            }
        });
    }

    // ==========================================
    // STUDENT STATUS DOUGHNUT CHART
    // ==========================================
    const statusCanvas = document.getElementById('studentStatusChart');
    if (statusCanvas && typeof Chart !== 'undefined') {

        const approved = parseInt(statusCanvas.dataset.approved) || 0;
        const pending  = parseInt(statusCanvas.dataset.pending)  || 0;

        new Chart(statusCanvas.getContext('2d'), {
            type: 'doughnut',
            data: {
                labels: ['Approved', 'Pending'],
                datasets: [{
                    data: [approved, pending],
                    backgroundColor: ['#0d9488', '#f59e0b'],
                    borderWidth: 0,
                    hoverOffset: 8
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
                            font: { family: 'Inter', size: 13, weight: '500' },
                            color: '#64748b'
                        }
                    },
                    tooltip: {
                        backgroundColor: '#134e4a',
                        padding: 12,
                        cornerRadius: 8
                    }
                },
                animation: { animateScale: true, animateRotate: true, duration: 1200 }
            }
        });
    }

    console.log('✅ College Admin Dashboard loaded');
});