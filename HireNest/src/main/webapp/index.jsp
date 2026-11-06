<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HireNest - Smart Campus Placement</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- FORCED NEW THEME CSS (Overrides any old cache) -->
    <style>
        :root {
            --bg-dark: #0B1120;
            --bg-card: rgba(30, 41, 59, 0.6);
            --primary: #7C3AED;
            --primary-hover: #6D28D9;
            --accent: #10B981;
            --text-main: #F8FAFC;
            --text-muted: #94A3B8;
            --border-color: rgba(255, 255, 255, 0.1);
        }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: var(--bg-dark);
            color: var(--text-main);
            margin: 0;
            padding: 0;
            overflow-x: hidden;
        }

        .hero {
            min-height: 100vh;
            background: radial-gradient(circle at 10% 20%, rgba(124, 58, 237, 0.15) 0%, transparent 40%),
            radial-gradient(circle at 90% 80%, rgba(16, 185, 129, 0.1) 0%, transparent 40%);
            display: flex;
            align-items: center;
            padding: 40px 0;
        }

        .hero-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            width: 100%;
        }

        /* Logo */
        .logo { display: flex; align-items: center; gap: 15px; margin-bottom: 50px; }
        .logo-icon {
            width: 50px; height: 50px; background: linear-gradient(135deg, #7C3AED, #4C1D95);
            border-radius: 12px; display: flex; align-items: center; justify-content: center;
            font-size: 24px; color: white; box-shadow: 0 8px 16px rgba(124, 58, 237, 0.3);
        }
        .logo-text h1 { font-size: 28px; margin: 0; font-weight: 800; letter-spacing: -0.5px; color: white; }
        .logo-text h1 span { color: var(--primary); }
        .logo-text p { margin: 0; font-size: 13px; color: var(--text-muted); font-style: italic; }

        /* Hero Title */
        .hero-title {
            font-size: 56px; font-weight: 800; line-height: 1.1; margin-bottom: 24px; letter-spacing: -1px; color: white;
        }
        .hero-title span {
            background: linear-gradient(to right, #7C3AED, #A78BFA, #10B981);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }
        .hero-description {
            font-size: 18px; color: var(--text-muted); line-height: 1.6; margin-bottom: 40px; max-width: 90%;
        }

        /* Buttons */
        .hero-buttons { display: flex; gap: 16px; }
        .btn-hero {
            padding: 14px 32px; border-radius: 12px; font-weight: 600; font-size: 16px;
            text-decoration: none; display: inline-flex; align-items: center; gap: 10px;
            transition: all 0.3s ease;
        }
        .btn-hero-primary { background: var(--primary); color: white; box-shadow: 0 8px 20px rgba(124, 58, 237, 0.4); }
        .btn-hero-primary:hover { background: var(--primary-hover); transform: translateY(-2px); color: white; }
        .btn-hero-outline { background: transparent; color: white; border: 1px solid var(--border-color); }
        .btn-hero-outline:hover { background: rgba(255, 255, 255, 0.05); border-color: white; color: white; }

        /* Hero Image Box */
        .hero-image {
            background: var(--bg-card); border: 1px solid var(--border-color);
            border-radius: 24px; padding: 60px 40px; text-align: center;
            backdrop-filter: blur(10px); box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
        }
        .hero-image i { font-size: 80px; color: var(--primary); margin-bottom: 20px; }
        .hero-image h3 { color: white; font-weight: 700; }
        .hero-image p { color: var(--text-muted); }

        /* Stats */
        .stats { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin: 60px 0; }
        .stat-item {
            background: var(--bg-card); border: 1px solid var(--border-color);
            padding: 30px; border-radius: 16px; text-align: center; backdrop-filter: blur(10px);
        }
        .stat-item h3 { font-size: 36px; margin: 0 0 10px 0; color: var(--primary); font-weight: 800; }
        .stat-item p { margin: 0; color: var(--text-muted); font-weight: 500; }

        /* Features Grid */
        .features-section { margin-bottom: 80px; }
        .features-title { text-align: center; font-size: 32px; margin: 0 0 40px 0; font-weight: 800; color: white; }
        .features-title span { color: var(--accent); }
        .features-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; }
        .feature-card {
            background: var(--bg-card); border: 1px solid var(--border-color);
            padding: 30px; border-radius: 20px; transition: transform 0.3s;
        }
        .feature-card:hover { transform: translateY(-5px); border-color: rgba(124, 58, 237, 0.5); }
        .feature-icon {
            width: 50px; height: 50px; background: rgba(124, 58, 237, 0.1); color: var(--primary);
            border-radius: 12px; display: flex; align-items: center; justify-content: center;
            font-size: 24px; margin-bottom: 20px;
        }
        .feature-card h4 { color: white; font-weight: 700; font-size: 18px; margin-bottom: 10px; }
        .feature-card p { color: var(--text-muted); font-size: 14px; }

        /* How it works */
        .how-it-works { margin-bottom: 80px; }
        .section-title { text-align: center; font-size: 32px; margin-bottom: 40px; font-weight: 800; color: white; }
        .section-title span { color: var(--accent); }
        .steps-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; }
        .step-card {
            background: var(--bg-card); border: 1px solid var(--border-color);
            padding: 30px 20px; border-radius: 20px; text-align: center;
        }
        .step-number {
            width: 40px; height: 40px; background: var(--accent); color: #0B1120;
            border-radius: 50%; display: flex; align-items: center; justify-content: center;
            font-weight: 800; font-size: 18px; margin: 0 auto 15px;
        }
        .step-card h4 { color: white; font-weight: 700; margin-bottom: 10px; }
        .step-card p { color: var(--text-muted); font-size: 14px; }

        /* CTA Section */
        .cta-section {
            background: linear-gradient(135deg, rgba(124, 58, 237, 0.2), rgba(16, 185, 129, 0.1));
            border: 1px solid rgba(124, 58, 237, 0.3); border-radius: 24px;
            padding: 60px; text-align: center; margin-bottom: 60px;
        }
        .cta-section h2 { color: white; font-weight: 800; font-size: 32px; margin-bottom: 15px; }
        .cta-section p { color: var(--text-muted); font-size: 18px; margin-bottom: 30px; }

        /* Footer */
        .footer { text-align: center; padding: 30px 0; border-top: 1px solid var(--border-color); }
        .footer-brand { font-size: 24px; font-weight: 800; color: white; margin-bottom: 10px; }
        .footer-brand i { color: var(--primary); margin-right: 10px; }
        .footer p { color: var(--text-muted); margin: 5px 0; }
        .footer-tagline { font-size: 14px; font-style: italic; }

        @media (max-width: 768px) {
            .hero-title { font-size: 40px; }
            .stats, .steps-grid { grid-template-columns: 1fr 1fr; }
            .features-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<div class="hero">
    <div class="hero-content">

        <!-- LOGO -->
        <div class="logo">
            <div class="logo-icon"><i class="fas fa-graduation-cap"></i></div>
            <div class="logo-text">
                <h1>Hire<span>Nest</span></h1>
                <p>Where Talent Nests, Opportunities Fly.</p>
            </div>
        </div>

        <!-- HERO SECTION -->
        <div class="row align-items-center hero-row">
            <div class="col-lg-7">
                <h2 class="hero-title">
                    Smart Campus Placement<br>
                    <span>Matrix Platform</span>
                </h2>
                <p class="hero-description">
                    Connect students, recruiters, and placement cells on a unified platform.
                    Multi-tenant, college-specific placement management system.
                </p>
                <div class="hero-buttons">
                    <a href="${pageContext.request.contextPath}/login.jsp" class="btn-hero btn-hero-primary">
                        <i class="fas fa-sign-in-alt"></i> Login
                    </a>
                    <a href="${pageContext.request.contextPath}/register" class="btn-hero btn-hero-outline">
                        <i class="fas fa-user-plus"></i> Register
                    </a>
                </div>
            </div>
            <div class="col-lg-5 d-none d-lg-block">
                <div class="hero-image">
                    <i class="fas fa-users"></i>
                    <h3>HireNest</h3>
                    <p>Smart Placement Platform</p>
                </div>
            </div>
        </div>

        <!-- STATS -->
        <div class="stats">
            <div class="stat-item">
                <h3>50+</h3>
                <p>Colleges</p>
            </div>
            <div class="stat-item">
                <h3>10K+</h3>
                <p>Students</p>
            </div>
            <div class="stat-item">
                <h3>500+</h3>
                <p>Recruiters</p>
            </div>
            <div class="stat-item">
                <h3>1000+</h3>
                <p>Drives</p>
            </div>
        </div>

        <!-- FEATURES SECTION -->
        <div class="features-section">
            <h2 class="features-title">Why <span>HireNest</span>?</h2>
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon"><i class="fas fa-university"></i></div>
                    <h4>Multi-College</h4>
                    <p>Support for multiple colleges with complete data isolation</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon"><i class="fas fa-file-excel"></i></div>
                    <h4>Bulk Upload</h4>
                    <p>Upload students via Excel with a single click</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon"><i class="fas fa-filter"></i></div>
                    <h4>Smart Filtering</h4>
                    <p>Filter students by CGPA, Backlogs, Skills & more</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon"><i class="fas fa-chart-line"></i></div>
                    <h4>Analytics</h4>
                    <p>Real-time placement analytics and reports</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon"><i class="fas fa-file-pdf"></i></div>
                    <h4>Export Reports</h4>
                    <p>Export filtered data to Excel or PDF</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon"><i class="fas fa-bell"></i></div>
                    <h4>Notifications</h4>
                    <p>Real-time alerts for new drives and updates</p>
                </div>
            </div>
        </div>

        <!-- HOW IT WORKS -->
        <div class="how-it-works">
            <h2 class="section-title">How It <span>Works</span></h2>
            <div class="steps-grid">
                <div class="step-card">
                    <div class="step-number">1</div>
                    <h4>Register</h4>
                    <p>Sign up as Student, Recruiter, or College Admin</p>
                </div>
                <div class="step-card">
                    <div class="step-number">2</div>
                    <h4>Get Approved</h4>
                    <p>College Admin verifies and approves your account</p>
                </div>
                <div class="step-card">
                    <div class="step-number">3</div>
                    <h4>Apply/Post</h4>
                    <p>Students apply to drives, Recruiters post jobs</p>
                </div>
                <div class="step-card">
                    <div class="step-number">4</div>
                    <h4>Get Placed</h4>
                    <p>Track applications and get hired by top companies</p>
                </div>
            </div>
        </div>

        <!-- CTA SECTION -->
        <div class="cta-section">
            <h2>Ready to Start Your Journey?</h2>
            <p>Join thousands of students and recruiters using HireNest</p>
            <a href="${pageContext.request.contextPath}/register" class="btn-hero btn-hero-primary" style="margin-top: 10px;">
                <i class="fas fa-rocket"></i> Get Started Now
            </a>
        </div>

        <!-- FOOTER -->
        <div class="footer">
            <div class="footer-brand"><i class="fas fa-graduation-cap"></i> HireNest</div>
            <p>&copy; 2026 <strong>HireNest</strong>. All rights reserved.</p>
            <p class="footer-tagline">Where Talent Nests, Opportunities Fly.</p>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>