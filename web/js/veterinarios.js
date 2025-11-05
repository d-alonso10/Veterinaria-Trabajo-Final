// Veterinarios Page JavaScript
document.addEventListener('DOMContentLoaded', function() {
    // Mobile menu functionality
    const mobileMenuToggle = document.querySelector('.mobile-menu-toggle');
    const navMenu = document.querySelector('.nav-menu');
    
    if (mobileMenuToggle) {
        mobileMenuToggle.addEventListener('click', function() {
            navMenu.classList.toggle('active');
            const icon = this.querySelector('i');
            icon.classList.toggle('fa-bars');
            icon.classList.toggle('fa-times');
        });
    }

    // Smooth scrolling for navigation links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Team member cards animation on scroll
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);

    // Observe team members
    document.querySelectorAll('.team-member').forEach(member => {
        observer.observe(member);
    });

    // Observe founder section
    const founderCard = document.querySelector('.founder-card');
    if (founderCard) {
        observer.observe(founderCard);
    }
});

// Contact modal functionality
function showContactModal(doctorId) {
    const modal = document.getElementById('contactModal');
    const modalTitle = document.getElementById('modalTitle');
    const modalBody = document.getElementById('modalBody');
    
    const doctorInfo = {
        ruben: {
            name: 'Dr. Rubén Pérez',
            specialty: 'Medicina General',
            email: 'ruben.perez@veterinaria.com',
            phone: '+1 (555) 123-4567',
            schedule: 'Lunes a Viernes: 8:00 AM - 6:00 PM',
            experience: '10 años de experiencia',
            education: 'Universidad Nacional de Veterinaria'
        },
        marcos: {
            name: 'Dr. Marcos Rodríguez',
            specialty: 'Cirugía Veterinaria',
            email: 'marcos.rodriguez@veterinaria.com',
            phone: '+1 (555) 234-5678',
            schedule: 'Martes a Sábado: 9:00 AM - 5:00 PM',
            experience: '15 años de experiencia',
            education: 'Universidad de Medicina Veterinaria'
        },
        carmen: {
            name: 'Dra. Carmen Fernández',
            specialty: 'Dermatología Veterinaria',
            email: 'carmen.fernandez@veterinaria.com',
            phone: '+1 (555) 345-6789',
            schedule: 'Lunes, Miércoles, Viernes: 10:00 AM - 4:00 PM',
            experience: '12 años de experiencia',
            education: 'Especialización en Dermatología Veterinaria'
        },
        maria: {
            name: 'Dra. María José Reinoso',
            specialty: 'Cardiología Veterinaria',
            email: 'maria.reinoso@veterinaria.com',
            phone: '+1 (555) 456-7890',
            schedule: 'Lunes a Jueves: 8:00 AM - 4:00 PM',
            experience: '18 años de experiencia',
            education: 'Especialización en Cardiología Veterinaria'
        }
    };
    
    const doctor = doctorInfo[doctorId];
    if (doctor) {
        modalTitle.textContent = `Contactar a ${doctor.name}`;
        modalBody.innerHTML = `
            <div class="doctor-contact-info">
                <div class="contact-header">
                    <h4>${doctor.name}</h4>
                    <p class="specialty">${doctor.specialty}</p>
                </div>
                
                <div class="contact-details">
                    <div class="contact-item">
                        <i class="fas fa-envelope"></i>
                        <div>
                            <strong>Email:</strong>
                            <a href="mailto:${doctor.email}">${doctor.email}</a>
                        </div>
                    </div>
                    
                    <div class="contact-item">
                        <i class="fas fa-phone"></i>
                        <div>
                            <strong>Teléfono:</strong>
                            <a href="tel:${doctor.phone}">${doctor.phone}</a>
                        </div>
                    </div>
                    
                    <div class="contact-item">
                        <i class="fas fa-clock"></i>
                        <div>
                            <strong>Horarios:</strong>
                            <span>${doctor.schedule}</span>
                        </div>
                    </div>
                    
                    <div class="contact-item">
                        <i class="fas fa-graduation-cap"></i>
                        <div>
                            <strong>Formación:</strong>
                            <span>${doctor.education}</span>
                        </div>
                    </div>
                    
                    <div class="contact-item">
                        <i class="fas fa-award"></i>
                        <div>
                            <strong>Experiencia:</strong>
                            <span>${doctor.experience}</span>
                        </div>
                    </div>
                </div>
                
                <div class="contact-actions">
                    <button class="primary-btn" onclick="window.location.href='mailto:${doctor.email}'">
                        <i class="fas fa-envelope"></i> Enviar Email
                    </button>
                    <button class="secondary-btn" onclick="window.location.href='tel:${doctor.phone}'">
                        <i class="fas fa-phone"></i> Llamar
                    </button>
                </div>
            </div>
        `;
        
        modal.style.display = 'block';
        document.body.style.overflow = 'hidden';
    }
}

function closeContactModal() {
    const modal = document.getElementById('contactModal');
    modal.style.display = 'none';
    document.body.style.overflow = 'auto';
}

// Close modal when clicking outside
window.addEventListener('click', function(event) {
    const modal = document.getElementById('contactModal');
    if (event.target === modal) {
        closeContactModal();
    }
});

// Close modal with Escape key
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeContactModal();
    }
});

// Header scroll effect
window.addEventListener('scroll', function() {
    const header = document.getElementById('header');
    if (window.scrollY > 100) {
        header.classList.add('scrolled');
    } else {
        header.classList.remove('scrolled');
    }
});

// Team member filter functionality (future enhancement)
function filterTeamMembers(specialty) {
    const members = document.querySelectorAll('.team-member');
    
    members.forEach(member => {
        if (specialty === 'all' || member.dataset.specialty === specialty) {
            member.style.display = 'block';
            member.classList.add('fade-in');
        } else {
            member.style.display = 'none';
            member.classList.remove('fade-in');
        }
    });
}

// Add loading animation for images
document.querySelectorAll('img').forEach(img => {
    img.addEventListener('load', function() {
        this.classList.add('loaded');
    });
    
    if (img.complete) {
        img.classList.add('loaded');
    }
});
