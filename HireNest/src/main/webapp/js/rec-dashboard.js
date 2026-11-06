/* RECRUITER DASHBOARD CHARTS */

document.addEventListener('DOMContentLoaded', function () {

    const canvas = document.getElementById('pipelineChart');
    if (!canvas || typeof Chart === 'undefined') return;

    const applied     = parseInt(canvas.dataset.applied)     || 0;
    const shortlisted = parseInt(canvas.dataset.shortlisted) || 0;
    const interview   = parseInt(canvas.dataset.interview)   || 0;
    const hired       = parseInt(canvas.dataset.hired)       || 0;
    const rejected    = parseInt(canvas.dataset.rejected)    || 0;

    new Chart(canvas.getContext('2d'), {
        type: 'line',
        data: {
            labels: ['Applied', 'Shortlisted', 'Interview', 'Hired', 'Rejected'],
            datasets: [{
                label: 'Candidates',
                data: [applied, shortlisted, interview, hired, rejected],
                borderColor: '#d97706',
                backgroundColor: 'rgba(217, 119, 6, 0.1)',
                fill: true,
                tension: 0.4,
                borderWidth: 3,
                pointBackgroundColor: '#d97706',
                pointBorderColor: '#fff',
                pointBorderWidth: 2,
                pointRadius: 6,
                pointHoverRadius: 9
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false },
                tooltip: {
                    backgroundColor: '#1c1917',
                    padding: 12,
                    cornerRadius: 8
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: { precision: 0, color: '#78716c' },
                    grid: { color: '#fef3c7' }
                },
                x: {
                    ticks: { color: '#78716c', font: { family: 'Inter', size: 12, weight: '500' } },
                    grid: { display: false }
                }
            },
            animation: { duration: 1200 }
        }
    });

    console.log('✅ Recruiter Dashboard loaded');
});