/* ============================================
   MY-APPLICATIONS.JS
   ============================================ */

// ==================================================
// OPEN DETAILS MODAL
// ==================================================
function openDetails(company, role, appliedDate, status, interviewDate, interviewLocation, remarks) {

    // Company header
    document.getElementById('mCompany').textContent = company || '—';
    document.getElementById('mRole').textContent = role || '—';
    document.getElementById('mInitial').textContent = company ? company.charAt(0).toUpperCase() : '?';

    // Applied date
    document.getElementById('mAppliedDate').textContent = appliedDate || '—';

    // Shortlisted block
    const shortlistBlock = document.getElementById('mShortlistedBlock');
    if (status === 'Shortlisted' || status === 'Interview' || status === 'Hired' || status === 'Rejected') {
        shortlistBlock.style.display = 'block';
    } else {
        shortlistBlock.style.display = 'none';
    }

    // Interview block
    const interviewBlock = document.getElementById('mInterviewBlock');
    if (interviewDate && interviewDate.trim() !== '') {
        interviewBlock.style.display = 'block';
        document.getElementById('mInterviewDate').textContent = interviewDate;
        document.getElementById('mInterviewLocation').textContent =
            interviewLocation && interviewLocation.trim() !== '' ? '📍 ' + interviewLocation : '';
    } else {
        interviewBlock.style.display = 'none';
    }

    // Remarks block
    const remarksBlock = document.getElementById('mRemarksBlock');
    if (remarks && remarks.trim() !== '') {
        remarksBlock.style.display = 'block';
        document.getElementById('mRemarks').textContent = remarks;
    } else {
        remarksBlock.style.display = 'none';
    }

    // Show modal
    const modal = new bootstrap.Modal(document.getElementById('detailsModal'));
    modal.show();
}

// ==================================================
// CONFIRM WITHDRAW
// ==================================================
function confirmWithdraw(applicationId, companyName) {
    Swal.fire({
        title: 'Withdraw Application?',
        html: 'Are you sure you want to withdraw your application from <b>' + companyName + '</b>?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#dc2626',
        cancelButtonColor: '#64748b',
        confirmButtonText: 'Yes, withdraw',
        cancelButtonText: 'Cancel'
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = window.location.pathname + '?action=withdraw&id=' + applicationId;
        }
    });
}

// ==================================================
// ACTIVE TAB / FILTER PRESERVATION
// ==================================================
document.addEventListener('DOMContentLoaded', function () {
    console.log('📋 My Applications loaded');
});