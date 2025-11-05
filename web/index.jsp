<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Veterinaria Terán Vet - Cuidado Profesional para tu Mascota</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="css/styles.css" rel="stylesheet" />
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link
        href="https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;0,800;1,300;1,400;1,500;1,600;1,700;1,800&display=swap"
        rel="stylesheet">
</head>

<body>

    <header id="Header">
        <img src="img/LOGO SIN FONDO.png" alt="" class="logo">

        <ul class="main-menu">
            <li class="menu-item">Home</li>
            <li class="menu-item" onClick="location.href = 'especialidades.html'">Especialidades</li>
            <li class="menu-item" onClick="location.href = 'citas.jsp'">Citas</li>
            <li class="menu-item" onClick="location.href = 'veterinarios.html'">Veterinarios</li>
            <a href="LoginRegistro.jsp" style="text-decoration: none">
                <li class="cta">Sign In</li>
            </a>
        </ul>
    </header>
    <br>
    <main>
        <section class="about-section">
            <div class="contenedor">
                <div class="about-hero">
                    <h2 class="section-title">Sobre Nosotros</h2>
                    <div class="hero-content">
                        <div class="hero-text">
                            <p class="intro-text">Con más de 15 años de experiencia, somos una clínica veterinaria comprometida con el bienestar de tu mascota.</p>
                            <div class="features-grid">
                                <div class="feature">
                                    <span class="feature-icon">🏥</span>
                                    <h4>Especialistas Certificados</h4>
                                </div>
                                <div class="feature">
                                    <span class="feature-icon">⚕️</span>
                                    <h4>Tecnología Moderna</h4>
                                </div>
                                <div class="feature">
                                    <span class="feature-icon">❤️</span>
                                    <h4>Atención Personalizada</h4>
                                </div>
                                <div class="feature">
                                    <span class="feature-icon">🕐</span>
                                    <h4>Emergencias 24/7</h4>
                                </div>
                            </div>
                        </div>
                        <div class="hero-image">
                            <img src="img/perro.JPG" alt="Veterinaria profesional" class="about-img">
                            <div class="stats-overlay">
                                <div class="stat">
                                    <span class="number">15+</span>
                                    <span class="label">Años</span>
                                </div>
                                <div class="stat">
                                    <span class="number">5000+</span>
                                    <span class="label">Mascotas</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <br>
        <div>

            <div class="main-container">
                <h3 class="main-title">Tenemos lo que tu mascota necesita</h3>
            </div>

            <div class="service-column">
                <div class="column-content">
                    <div class="service-item">
                        <i class="icon icon-service-1"></i>
                        <h3 class="service-title">Medicina Veterinaria</h3>
                        <p>
                            <span>Consultas</span>
                            <span>Vacunas</span>
                            <span>Tratamientos</span>
                            <span>Cirugías</span>
                            <span>Hospitalización</span>
                            <span>Emergencias</span>
                        </p>
                    </div>
                </div>
            </div>

            <div class="service-column">
                <div class="column-content">
                    <div class="service-item">
                        <i class="icon icon-service-2"></i>
                        <h3 class="service-title">Grooming</h3>
                        <p>
                            <span>Baño Spa</span>
                            <span>Corte</span>
                            <span>Baños Medicados</span>
                            <span>Colorimetría</span>
                        </p>
                    </div>
                </div>
            </div>

            <div class="service-column">
                <div class="column-content">
                    <div class="service-item">
                        <i class="icon icon-service-3"></i>
                        <h3 class="service-title">Otros Servicios</h3>
                        <p>
                            <span>Hospedaje Canino</span>
                            <span>Adiestramiento</span>
                            <span>Trámite para Viajes</span>
                            <span>Microchip</span>
                            <span>Paseos</span>
                        </p>
                    </div>
                </div>
            </div>

        </div>

        <section class="testimonials-section">
            <div class="contenedor">
                <h2 class="titulo">Lo que dicen nuestros clientes</h2>
                <div class="testimonials-container">
                    <div class="testimonial-card">
                        <div class="testimonial-image">
                            <img src="img/CXZ2WOFDR5CMPL245QQIWK2HNU.jpg" alt="Cliente satisfecho">
                        </div>
                        <div class="testimonial-content">
                            <p>"Excelente atención para mi perro Max. El Dr. García fue muy profesional y cariñoso.
                                Definitivamente regresaré."</p>
                            <h4>- María González</h4>
                            <div class="stars">★★★★★</div>
                        </div>
                    </div>

                    <div class="testimonial-card">
                        <div class="testimonial-image">
                            <img src="img/Imagen de WhatsApp 2023-11-06 a las 16.42.25_91764804.jpg"
                                alt="Cliente satisfecho">
                        </div>
                        <div class="testimonial-content">
                            <p>"Mi gata Luna recibió el mejor cuidado durante su cirugía. El equipo es increíble y muy
                                profesional."</p>
                            <h4>- Carlos Rodríguez</h4>
                            <div class="stars">★★★★★</div>
                        </div>
                    </div>

                    <div class="testimonial-card">
                        <div class="testimonial-image">
                            <img src="img/Hero.jpg" alt="Cliente satisfecho">
                        </div>
                        <div class="testimonial-content">
                            <p>"El servicio de grooming es fantástico. Mi perro siempre sale hermoso y relajado. Muy
                                recomendado."</p>
                            <h4>- Ana Martínez</h4>
                            <div class="stars">★★★★★</div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="contact-section">
            <div class="contenedor">
                <h2 class="titulo">Contáctanos</h2>
                <div class="contact-container">
                    <div class="contact-info">
                        <div class="contact-item">
                            <div class="contact-icon">📍</div>
                            <div class="contact-details">
                                <h3>Dirección</h3>
                                <p>Av. Pacasmayo B-16<br>San Martín de Porres 15112, Lima - Perú</p>
                            </div>
                        </div>

                        <div class="contact-item">
                            <div class="contact-icon">📞</div>
                            <div class="contact-details">
                                <h3>Teléfonos</h3>
                                <p>6914907 / 947884669<br>980 817 332 - Emergencias 24/7</p>
                            </div>
                        </div>

                        <div class="contact-item">
                            <div class="contact-icon">🕒</div>
                            <div class="contact-details">
                                <h3>Horarios</h3>
                                <p>Lun - Vie: 8:00 AM - 8:00 PM<br>Sáb - Dom: 9:00 AM - 6:00 PM</p>
                            </div>
                        </div>

                        <div class="contact-item">
                            <div class="contact-icon">✉️</div>
                            <div class="contact-details">
                                <h3>Email</h3>
                                <p>info@veterinariateranvet.com<br>citas@veterinariateranvet.com</p>
                            </div>
                        </div>
                    </div>

                    <div class="contact-form">
                        <h3>Agenda tu cita</h3>
                        <form id="appointmentForm">
                            <div class="form-group">
                                <input type="text" id="petName" placeholder="Nombre de tu mascota" required>
                            </div>
                            <div class="form-group">
                                <input type="text" id="ownerName" placeholder="Tu nombre" required>
                            </div>
                            <div class="form-group">
                                <input type="tel" id="phone" placeholder="Teléfono" required>
                            </div>
                            <div class="form-group">
                                <select id="service" required>
                                    <option value="">Selecciona un servicio</option>
                                    <option value="consulta">Consulta General</option>
                                    <option value="vacuna">Vacunación</option>
                                    <option value="grooming">Grooming</option>
                                    <option value="cirugia">Cirugía</option>
                                    <option value="emergencia">Emergencia</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <textarea id="message" placeholder="Mensaje adicional (opcional)"></textarea>
                            </div>
                            <button type="submit" class="cta-button">Agendar Cita</button>
                        </form>
                    </div>
                </div>
            </div>
        </section>

    </main>

    <footer class="footer">
        <div class="contenedor">
            <div class="footer-content">
                <div class="footer-section">
                    <img src="img/LOGO SIN FONDO.png" alt="Logo" class="footer-logo">
                    <h4 style="color: var(--main-color); margin-bottom: 10px;">Veterinaria Terán Vet</h4>
                    <p style="font-size: 0.9rem; margin-bottom: 15px;">Corporación Andes S.A.C.</p>
                    <p>Cuidando a tus mascotas con amor y profesionalismo desde hace más de 10 años.</p>
                </div>

                <div class="footer-section">
                    <h3>Servicios</h3>
                    <ul>
                        <li>Medicina Veterinaria</li>
                        <li>Grooming</li>
                        <li>Hospedaje</li>
                        <li>Emergencias 24/7</li>
                    </ul>
                </div>

                <div class="footer-section">
                    <h3>Síguenos</h3>
                    <div class="social-links">
                        <a href="#" class="social-link">
                            <img src="img/FacebookBlanco.png" alt="Facebook">
                        </a>
                        <a href="#" class="social-link">
                            <img src="img/InstagramBlanco.png" alt="Instagram">
                        </a>
                        <a href="#" class="social-link">
                            <img src="img/TwitterBlanco.png" alt="Twitter">
                        </a>
                        <a href="#" class="social-link">
                            <img src="img/LinkedinBlanco.png" alt="LinkedIn">
                        </a>
                    </div>
                </div>
            </div>

            <div class="footer-bottom">
                <p>&copy; 2024 Veterinaria Terán Vet - Corporación Andes S.A.C. Todos los derechos reservados.</p>
            </div>
        </div>
    </footer>

    <script src="js/code.js"></script>
</body>

</html>