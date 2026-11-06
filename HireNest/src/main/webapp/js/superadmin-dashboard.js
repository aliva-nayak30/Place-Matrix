/* ============================================
   SUPERADMIN-DASHBOARD.JS
   ============================================ */

document.addEventListener('DOMContentLoaded', function () {

    // ==========================================
    // PIE CHART: Placed vs Unplaced
    // ==========================================
    const placedCanvas = document.getElementById('placedChart');
    if (placedCanvas && typeof Chart !== 'undefined') {
        const placed   = parseInt(placedCanvas.dataset.placed)   || 0;
        const unplaced = parseInt(placedCanvas.dataset.unplaced) || 0;

        new Chart(placedCanvas.getContext('2d'), {
            type: 'doughnut',
            data: {
                labels: ['Placed', 'Unplaced'],
                datasets: [{
                    data: [placed, unplaced],
                    backgroundColor: ['#10b981', '#e5e7eb'],
                    borderWidth: 0,
                    hoverOffset: 6
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
                        backgroundColor: '#1e293b',
                        padding: 12,
                        cornerRadius: 8,
                        titleFont: { family: 'Inter', size: 13, weight: '600' },
                        bodyFont: { family: 'Inter', size: 12 }
                    }
                },
                animation: { animateScale: true, animateRotate: true, duration: 1200 }
            }
        });
    }

    // ==========================================
    // BAR CHART: Package Distribution
    // ==========================================
    const packageCanvas = document.getElementById('packageChart');
    if (packageCanvas && typeof Chart !== 'undefined') {
        const r1 = parseInt(packageCanvas.dataset.range1) || 0;
        const r2 = parseInt(packageCanvas.dataset.range2) || 0;
        const r3 = parseInt(packageCanvas.dataset.range3) || 0;
        const r4 = parseInt(packageCanvas.dataset.range4) || 0;

        new Chart(packageCanvas.getContext('2d'), {
            type: 'bar',
            data: {
                labels: ['0-3 LPA', '3-6 LPA', '6-10 LPA', '10+ LPA'],
                datasets: [{
                    label: 'Drives',
                    data: [r1, r2, r3, r4],
                    backgroundColor: ['#a78bfa', '#7c3aed', '#6d28d9', '#4c1d95'],
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
                        backgroundColor: '#1e293b',
                        padding: 12,
                        cornerRadius: 8,
                        titleFont: { family: 'Inter', size: 13, weight: '600' },
                        bodyFont: { family: 'Inter', size: 12 }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: { precision: 0, color: '#64748b' },
                        grid: { color: '#f1f5f9' }
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

    console.log('✅ Super Admin Dashboard loaded');
});

// ============================================
// SIDEBAR TOGGLE (Mobile)
// ============================================
function toggleSidebar() {
    const sidebar = document.getElementById('sidebar');
    if (sidebar) sidebar.classList.toggle('open');
}

// Close sidebar when clicking outside on mobile
document.addEventListener('click', function (e) {
    const sidebar = document.getElementById('sidebar');
    const toggleBtn = e.target.closest('[onclick*="toggleSidebar"]');

    if (!sidebar || !toggleBtn) return;

    if (window.innerWidth <= 992) {
        // Let the click proceed normally (toggled by onclick)
    }
});