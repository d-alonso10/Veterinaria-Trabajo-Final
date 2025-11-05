var header = document.getElementById('Header')

window.addEventListener("scroll", function(){
    var scroll = window.scrollY;
    if(scrollY>0){
        header.style.backgroundColor = '#121212';
    }
    else{
        header.style.backgroundColor = 'transparent';
    }
})

// Smooth scrolling for menu items
document.addEventListener('DOMContentLoaded', function() {
    // Add smooth scrolling to menu items
    const menuItems = document.querySelectorAll('.menu-item');
    menuItems.forEach(item => {
        item.addEventListener('click', function(e) {
            if (this.textContent === 'Home') {
                e.preventDefault();
                window.scrollTo({
                    top: 0,
                    behavior: 'smooth'
                });
            }
        });
    });

    // Form submission handling
    const appointmentForm = document.getElementById('appointmentForm');
    if (appointmentForm) {
        appointmentForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Get form data
            const petName = document.getElementById('petName').value;
            const ownerName = document.getElementById('ownerName').value;
            const phone = document.getElementById('phone').value;
            const service = document.getElementById('service').value;
            const message = document.getElementById('message').value;
            
            // Simple validation
            if (!petName || !ownerName || !phone || !service) {
                alert('Por favor, completa todos los campos obligatorios.');
                return;
            }
            
            // Show success message
            alert(`¡Gracias ${ownerName}! Hemos recibido tu solicitud de cita para ${petName}. Te contactaremos pronto al ${phone}.`);
            
            // Reset form
            this.reset();
        });
    }

    // Add animation to service cards on scroll
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);

    // Observe service columns
    const serviceColumns = document.querySelectorAll('.service-column');
    serviceColumns.forEach(column => {
        column.style.opacity = '0';
        column.style.transform = 'translateY(30px)';
        column.style.transition = 'all 0.6s ease';
        observer.observe(column);
    });

    // Observe testimonial cards
    const testimonialCards = document.querySelectorAll('.testimonial-card');
    testimonialCards.forEach((card, index) => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(30px)';
        card.style.transition = `all 0.6s ease ${index * 0.2}s`;
        observer.observe(card);
    });

    // Add hover effects to contact items
    const contactItems = document.querySelectorAll('.contact-item');
    contactItems.forEach(item => {
        item.addEventListener('mouseenter', function() {
            this.style.transform = 'translateX(10px) scale(1.02)';
        });
        
        item.addEventListener('mouseleave', function() {
            this.style.transform = 'translateX(0) scale(1)';
        });
    });

    // Social media links functionality
    const socialLinks = document.querySelectorAll('.social-link');
    socialLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const platform = this.querySelector('img').alt;
            alert(`Síguenos en ${platform}! (Enlace de ejemplo)`);
        });
    });

    // Add typing effect to main title
    const mainTitle = document.querySelector('.main-title');
    if (mainTitle) {
        const text = mainTitle.innerHTML;
        mainTitle.innerHTML = '';
        let i = 0;
        
        function typeWriter() {
            if (i < text.length) {
                mainTitle.innerHTML += text.charAt(i);
                i++;
                setTimeout(typeWriter, 100);
            }
        }
        
        // Start typing effect when element is visible
        const titleObserver = new IntersectionObserver(function(entries) {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    typeWriter();
                    titleObserver.unobserve(entry.target);
                }
            });
        });
        
        titleObserver.observe(mainTitle);
    }
});

// Legacy code for login/register (if needed)
if (typeof $ !== 'undefined') {
    $('#Register').click(function(){
        document.getElementById('Container').style.transform = 'rotateY(360deg)';
        setTimeout(function(){
            document.getElementById('LoginContainer').style.display = 'none';
            document.getElementById('RegisterContainer').style.display = 'flex';
        }, 400);
    });
    
    $('#Login').click(function(){
        document.getElementById('Container').style.transform = 'rotateY(0deg)';
        setTimeout(function(){
            document.getElementById('LoginContainer').style.display = 'flex';
            document.getElementById('RegisterContainer').style.display = 'none';
        }, 400);
    });
}
