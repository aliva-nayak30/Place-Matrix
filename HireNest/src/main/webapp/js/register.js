/* ============================================
   REGISTER.JS - HireNest Registration
   ============================================ */

// =============================================
// ROLE SWITCHING — Show/hide fields by role
// =============================================
function selectRole(role) {
    console.log("Selected role: " + role);

    // Update hidden input
    document.getElementById('roleInput').value = role;

    // Update role buttons
    var buttons = document.querySelectorAll('.role-btn');
    for (var i = 0; i < buttons.length; i++) {
        buttons[i].classList.remove('active');
        if (buttons[i].getAttribute('data-role') === role) {
            buttons[i].classList.add('active');
        }
    }

    // Get all sections
    var collegeSelectGroup = document.getElementById('collegeSelectGroup');
    var studentFields = document.getElementById('studentFields');
    var recruiterFields = document.getElementById('recruiterFields');
    var collegeAdminFields = document.getElementById('collegeAdminFields');
    var recruiterInfoBox = document.getElementById('recruiterInfoBox');
    var studentInfoBox = document.getElementById('studentInfoBox');

    // Hide everything first
    if (studentFields) studentFields.style.display = 'none';
    if (recruiterFields) recruiterFields.style.display = 'none';
    if (collegeAdminFields) collegeAdminFields.style.display = 'block';
    if (collegeSelectGroup) collegeSelectGroup.style.display = 'block';
    if (recruiterInfoBox) recruiterInfoBox.style.display = 'none';
    if (studentInfoBox) studentInfoBox.style.display = 'none';

    // Show the section for the selected role
    if (role === 'STUDENT') {
        if (studentFields) studentFields.style.display = 'block';
        if (studentInfoBox) studentInfoBox.style.display = 'flex';
        if (collegeSelectGroup) collegeSelectGroup.style.display = 'block';

    } else if (role === 'RECRUITER') {
        if (recruiterFields) recruiterFields.style.display = 'block';
        if (recruiterInfoBox) recruiterInfoBox.style.display = 'flex';
        if (collegeSelectGroup) collegeSelectGroup.style.display = 'block';

    } else if (role === 'COLLEGE_ADMIN') {
        if (collegeAdminFields) collegeAdminFields.style.display = 'block';
        // College Admin does NOT select from dropdown — they create a new college
        if (collegeSelectGroup) collegeSelectGroup.style.display = 'none';
    }

    // Clear previous errors
    clearErrors();
}

// =============================================
// CLEAR ALL ERRORS
// =============================================
function clearErrors() {
    var errorMessages = document.querySelectorAll('.error-message');
    for (var i = 0; i < errorMessages.length; i++) {
        errorMessages[i].textContent = '';
    }
    var inputs = document.querySelectorAll('.form-group input, .form-group select');
    for (var i = 0; i < inputs.length; i++) {
        inputs[i].classList.remove('error');
    }
}

// =============================================
// TOGGLE PASSWORD VISIBILITY
// =============================================
function togglePassword(fieldId) {
    var field = document.getElementById(fieldId);
    var icon = document.getElementById(fieldId + 'Icon');
    if (field.type === 'password') {
        field.type = 'text';
        icon.className = 'fas fa-eye-slash';
    } else {
        field.type = 'password';
        icon.className = 'fas fa-eye';
    }
}

// =============================================
// PASSWORD STRENGTH CHECKER
// =============================================
document.addEventListener('DOMContentLoaded', function () {
    var passwordField = document.getElementById('password');
    if (passwordField) {
        passwordField.addEventListener('keyup', function () {
            var password = this.value;
            var strengthBar = document.getElementById('strengthBar');
            var strengthText = document.getElementById('strengthText');
            if (!strengthBar || !strengthText) return;

            var strength = 0;
            if (password.length >= 8) strength++;
            if (password.match(/[a-z]+/)) strength++;
            if (password.match(/[A-Z]+/)) strength++;
            if (password.match(/[0-9]+/)) strength++;
            if (password.match(/[$@#&!]+/)) strength++;

            var percentage = (strength / 5) * 100;
            strengthBar.style.width = percentage + '%';

            if (strength <= 2) {
                strengthBar.style.background = '#e74c3c';
                strengthText.textContent = 'Weak password';
                strengthText.style.color = '#e74c3c';
            } else if (strength <= 3) {
                strengthBar.style.background = '#f39c12';
                strengthText.textContent = 'Medium password';
                strengthText.style.color = '#f39c12';
            } else if (strength <= 4) {
                strengthBar.style.background = '#2ecc71';
                strengthText.textContent = 'Strong password';
                strengthText.style.color = '#2ecc71';
            } else {
                strengthBar.style.background = '#27ae60';
                strengthText.textContent = 'Very strong password!';
                strengthText.style.color = '#27ae60';
            }
        });
    }
});

// =============================================
// FORM VALIDATION — role-aware
// =============================================
function validateForm() {
    var isValid = true;
    var role = document.getElementById('roleInput').value;

    clearErrors();

    // -------- COMMON VALIDATION --------
    var name = document.getElementById('name');
    if (!name.value.trim() || name.value.trim().length < 2) {
        document.getElementById('nameError').textContent = 'Name must be at least 2 characters';
        name.classList.add('error');
        isValid = false;
    }

    var email = document.getElementById('email');
    var emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    if (!emailPattern.test(email.value.trim())) {
        document.getElementById('emailError').textContent = 'Please enter a valid email';
        email.classList.add('error');
        isValid = false;
    }

    var password = document.getElementById('password');
    if (password.value.length < 8) {
        document.getElementById('passwordError').textContent = 'Password must be at least 8 characters';
        password.classList.add('error');
        isValid = false;
    }

    var phone = document.getElementById('phone');
    var phonePattern = /^[0-9]{10}$/;
    if (!phonePattern.test(phone.value.trim())) {
        document.getElementById('phoneError').textContent = 'Please enter a valid 10-digit phone number';
        phone.classList.add('error');
        isValid = false;
    }

    // -------- ROLE-SPECIFIC VALIDATION --------
    if (role === 'STUDENT' || role === 'RECRUITER') {
        // Both need college selection
        var collegeId = document.getElementById('collegeId');
        if (!collegeId.value) {
            document.getElementById('collegeIdError').textContent = 'Please select your college';
            collegeId.classList.add('error');
            isValid = false;
        }
    }

    if (role === 'STUDENT') {
        var regNo = document.getElementById('regNo');
        if (!regNo.value.trim() || regNo.value.trim().length < 2) {
            document.getElementById('regNoError').textContent = 'Please enter a valid registration number';
            regNo.classList.add('error');
            isValid = false;
        }

        var branch = document.getElementById('branch');
        if (!branch.value) {
            document.getElementById('branchError').textContent = 'Please select your branch';
            branch.classList.add('error');
            isValid = false;
        }
    }

    if (role === 'RECRUITER') {
        var companyName = document.getElementById('companyName');
        if (!companyName.value.trim() || companyName.value.trim().length < 2) {
            document.getElementById('companyNameError').textContent = 'Company name is required';
            companyName.classList.add('error');
            isValid = false;
        }
    }

    if (role === 'COLLEGE_ADMIN') {
        var collegeName = document.getElementById('collegeName');
        if (!collegeName.value.trim() || collegeName.value.trim().length < 2) {
            document.getElementById('collegeNameError').textContent = 'College name is required';
            collegeName.classList.add('error');
            isValid = false;
        }

        var collegeCode = document.getElementById('collegeCode');
        if (!collegeCode.value.trim() || collegeCode.value.trim().length < 2) {
            document.getElementById('collegeCodeError').textContent = 'College code is required (min 2 chars)';
            collegeCode.classList.add('error');
            isValid = false;
        }
    }

    if (!isValid) {
        var firstError = document.querySelector('.form-group input.error, .form-group select.error');
        if (firstError) {
            firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
            firstError.focus();
        }
    }

    return isValid;
}

// =============================================
// AUTO-INIT ON PAGE LOAD
// =============================================
document.addEventListener('DOMContentLoaded', function () {
    // Ensure student is selected by default
    selectRole('STUDENT');
    console.log('✅ Register page ready');
});