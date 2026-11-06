// Handle Role Selection (No default selection)
function selectRole(role) {
    // 1. Update the hidden input
    document.getElementById('roleInput').value = role;

    // 2. Toggle the blue 'active' class
    document.querySelectorAll('.role-btn').forEach(btn => {
        if (btn.dataset.role === role) {
            btn.classList.add('active');
        } else {
            btn.classList.remove('active');
        }
    });
}

// Toggle Password Visibility
function togglePassword(inputId) {
    const input = document.getElementById(inputId);
    const icon = document.getElementById(inputId + 'Icon');

    if (input.type === 'password') {
        input.type = 'text';
        icon.classList.remove('fa-eye');
        icon.classList.add('fa-eye-slash');
    } else {
        input.type = 'password';
        icon.classList.remove('fa-eye-slash');
        icon.classList.add('fa-eye');
    }
}

// Basic Frontend Validation
function validateForm() {
    const email = document.getElementById('email').value.trim();
    const password = document.getElementById('password').value;
    let isValid = true;

    // Clear previous errors
    document.getElementById('emailError').innerText = '';
    document.getElementById('passwordError').innerText = '';

    if (!email) {
        document.getElementById('emailError').innerText = 'Email is required';
        isValid = false;
    }
    if (!password) {
        document.getElementById('passwordError').innerText = 'Password is required';
        isValid = false;
    }

    return isValid;
}