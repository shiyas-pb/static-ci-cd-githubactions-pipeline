// Update deployment information in footer
document.addEventListener('DOMContentLoaded', function() {
    // Set current date as deployment date
    const deployDateElement = document.getElementById('deploy-date');
    if (deployDateElement) {
        const now = new Date();
        deployDateElement.textContent = now.toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    }

    // Update build information from environment variables
    // These would be replaced by GitHub Actions during deployment
    const buildIdElement = document.getElementById('build-id');
    const commitShaElement = document.getElementById('commit-sha');
    
    if (buildIdElement && commitShaElement) {
        // In a real scenario, these would come from GitHub Actions environment variables
        // For demo purposes, we'll show placeholder values
        buildIdElement.textContent = process.env.GITHUB_RUN_NUMBER || '#123';
        commitShaElement.textContent = process.env.GITHUB_SHA ? 
            process.env.GITHUB_SHA.substring(0, 7) : 'abc1234';
    }

    // Smooth scrolling for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href');
            if (targetId !== '#') {
                const targetElement = document.querySelector(targetId);
                if (targetElement) {
                    targetElement.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            }
        });
    });

    // Add active class to current page in navigation
    const currentPage = window.location.pathname.split('/').pop();
    document.querySelectorAll('.nav-links a').forEach(link => {
        const linkPage = link.getAttribute('href');
        if (linkPage === currentPage || 
            (currentPage === '' && linkPage === 'index.html')) {
            link.classList.add('active');
        }
    });
});
