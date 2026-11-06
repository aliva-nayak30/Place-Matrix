// =============================================
// INDEX.JS - HireNest Landing Page
// =============================================

document.addEventListener('DOMContentLoaded', function() {
    console.log('🚀 HireNest - Smart Campus Placement Platform');
    console.log('📚 Where Talent Nests, Opportunities Fly.');

    // =============================================
    // ANIMATE ON SCROLL
    // =============================================
    const observerOptions = {
        threshold: 0.3,
        rootMargin: '0px'
    };

    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(function(entry) {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);

    // Animate stat items
    document.querySelectorAll('.stat-item').forEach(function(stat, index) {
        stat.style.opacity = '0';
        stat.style.transform = 'translateY(30px)';
        stat.style.transition = `all 0.6s ease ${index * 0.1}s`;
        observer.observe(stat);
    });

    // Animate feature cards
    document.querySelectorAll('.feature-card').forEach(function(feature, index) {
        feature.style.opacity = '0';
        feature.style.transform = 'translateY(30px)';
        feature.style.transition = `all 0.6s ease ${index * 0.1 + 0.3}s`;
        observer.observe(feature);
    });

    // Animate step cards
    document.querySelectorAll('.step-card').forEach(function(step, index) {
        step.style.opacity = '0';
        step.style.transform = 'translateY(30px)';
        step.style.transition = `all 0.6s ease ${index * 0.1}s`;
        observer.observe(step);
    });

    // =============================================
    // PARALLAX EFFECT
    // =============================================
    document.addEventListener('mousemove', function(e) {
        const x = e.clientX / window.innerWidth;
        const y = e.clientY / window.innerHeight;

        const logo = document.querySelector('.logo');
        if (logo) {
            logo.style.transform = `translate(${x * 5}px, ${y * 5}px)`;
        }

        const title = document.querySelector('.hero-title');
        if (title) {
            title.style.transform = `translate(${x * 3}px, ${y * 3}px)`;
        }
    });

    // =============================================
    // SMOOTH SCROLL
    // =============================================
    document.querySelectorAll('a[href^="#"]').forEach(function(anchor) {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        });
    });
});