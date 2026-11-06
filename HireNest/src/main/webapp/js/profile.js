/* ============================================
   PROFILE.JS - Client-side validation
   ============================================ */

function validateProfile() {
    const name = document.getElementById('name');
    const phone = document.getElementById('phone');

    // Name required
    if (!name.value.trim() || name.value.trim().length < 2) {
        alert('Please enter a valid name (min 2 characters).');
        name.focus();
        return false;
    }

    // Phone optional but if filled, must be 10 digits
    if (phone.value.trim() && !/^[0-9]{10}$/.test(phone.value.trim())) {
        alert('Phone number must be 10 digits.');
        phone.focus();
        return false;
    }

    return true;
}

// Auto-format phone (digits only)
document.addEventListener('DOMContentLoaded', function () {
    const phone = document.getElementById('phone');
    if (phone) {
        phone.addEventListener('input', function () {
            this.value = this.value.replace(/[^0-9]/g, '').slice(0, 10);
        });
    }
});