<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Sistema Veterinario</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
    <style>
        :root {
            --primary: #007bff;
            --primary-dark: #0056b3;
            --success: #28a745;
            --danger: #dc3545;
            --warning: #ffc107;
            --info: #17a2b8;
            --light: #f8f9fa;
            --dark: #343a40;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
            background-size: 400% 400%;
            animation: gradient 15s ease infinite;
            height: 100vh;
            overflow: hidden;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
        }
        
        @keyframes gradient {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        
        #particles-js {
            position: absolute;
            width: 100%;
            height: 100%;
            z-index: 0;
        }
        
        .login-container {
            background: rgba(255, 255, 255, 0.95);
            padding: 40px 35px;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 420px;
            z-index: 10;
            position: relative;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            transform: translateY(0);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .login-container:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.25);
        }
        
        .login-header {
            text-align: center;
            margin-bottom: 30px;
            position: relative;
        }
        
        .login-header h2 {
            color: #333;
            font-size: 28px;
            margin-bottom: 10px;
            font-weight: 700;
            background: linear-gradient(45deg, #007bff, #00c6ff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            position: relative;
            display: inline-block;
        }
        
        .login-header h2:after {
            content: '';
            position: absolute;
            width: 60%;
            height: 4px;
            background: linear-gradient(45deg, #007bff, #00c6ff);
            bottom: -10px;
            left: 20%;
            border-radius: 10px;
        }
        
        .login-header p {
            color: #666;
            font-size: 14px;
            margin-top: 15px;
        }
        
        .form-group {
            margin-bottom: 20px;
            position: relative;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 600;
            font-size: 14px;
            transition: color 0.3s;
        }
        
        .input-with-icon {
            position: relative;
        }
        
        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #aaa;
            transition: color 0.3s;
            z-index: 1;
        }
        
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 15px 15px 15px 45px;
            border: 2px solid #e1e5eb;
            border-radius: 12px;
            font-size: 16px;
            transition: all 0.3s;
            background: #f9fafb;
            position: relative;
        }
        
        input[type="email"]:focus,
        input[type="password"]:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
            outline: none;
            background: white;
        }
        
        input[type="email"]:focus + .input-icon,
        input[type="password"]:focus + .input-icon {
            color: var(--primary);
        }
        
        .checkbox-group {
            margin-bottom: 25px;
            display: flex;
            align-items: center;
        }
        
        .checkbox-group input {
            margin-right: 10px;
            transform: scale(1.2);
        }
        
        .checkbox-group label {
            display: flex;
            align-items: center;
            font-size: 14px;
            font-weight: normal;
            color: #666;
            cursor: pointer;
        }
        
        .btn {
            width: 100%;
            padding: 16px;
            background: linear-gradient(45deg, var(--primary), var(--primary-dark));
            color: white;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
            z-index: 1;
        }
        
        .btn:before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: 0.5s;
            z-index: -1;
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 7px 15px rgba(0, 123, 255, 0.4);
        }
        
        .btn:hover:before {
            left: 100%;
        }
        
        .btn:active {
            transform: translateY(0);
        }
        
        .register-link {
            text-align: center;
            margin-top: 25px;
            font-size: 14px;
            color: #666;
        }
        
        .register-link a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s;
        }
        
        .register-link a:hover {
            color: var(--primary-dark);
            text-decoration: underline;
        }
        
        /* Estilos para mensajes */
        .message-box {
            text-align: center;
            margin-bottom: 20px;
            padding: 15px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 500;
            animation: fadeIn 0.5s ease;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .error {
            color: #721c24;
            background: linear-gradient(45deg, #f8d7da, #f1b0b7);
            border-left: 5px solid var(--danger);
        }
        
        .success {
            color: #155724;
            background: linear-gradient(45deg, #d4edda, #c3e6cb);
            border-left: 5px solid var(--success);
        }
        
        .info {
            color: #004085;
            background: linear-gradient(45deg, #cce5ff, #b8daff);
            border-left: 5px solid var(--info);
        }
        
        .floating-animals {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            pointer-events: none;
            z-index: 5;
        }
        
        .animal {
            position: absolute;
            font-size: 24px;
            opacity: 0.7;
            animation: float 15s infinite linear;
        }
        
        @keyframes float {
            0% { transform: translateY(100vh) rotate(0deg); }
            100% { transform: translateY(-100px) rotate(360deg); }
        }
        
        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #aaa;
            cursor: pointer;
            font-size: 18px;
            transition: color 0.3s;
        }
        
        .password-toggle:hover {
            color: var(--primary);
        }
        
        .paw-print {
            position: absolute;
            font-size: 20px;
            opacity: 0.1;
            z-index: 1;
        }
        
        @media (max-width: 480px) {
            .login-container {
                padding: 30px 20px;
                margin: 0 15px;
            }
            
            .login-header h2 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <div id="particles-js"></div>
    <div class="floating-animals" id="floatingAnimals"></div>
    
    <div class="login-container">
        <div class="login-header">
            <h2>Iniciar Sesión</h2>
            <p>Acceda a su cuenta del sistema veterinario</p>
        </div>
        
        <%-- 
          CORRECCIÓN: Bloque de Mensajes Unificado.
          Maneja tanto los mensajes de 'forward' (setAttribute) como los de 'redirect' (getParameter).
        --%>
        <%
            // 1. Intentar obtener mensaje de FORWARD (atributo)
            String mensaje = (String) request.getAttribute("mensaje");
            String tipoMensaje = (String) request.getAttribute("tipoMensaje"); // "error", "info", etc.

            // 2. Si no hay, intentar obtener mensaje de REDIRECT (parámetro)
            if (mensaje == null) {
                String mensajeParam = request.getParameter("mensaje");
                if (mensajeParam != null) {
                    // Determinar el tipo basado en el parámetro
                    switch(mensajeParam) {
                        case "logout_exitoso":
                            mensaje = "✅ Sesión cerrada exitosamente";
                            tipoMensaje = "success";
                            break;
                        case "error_logout":
                            mensaje = "❌ Error al cerrar sesión";
                            tipoMensaje = "error";
                            break;
                        case "sesion_expirada":
                            mensaje = "⚠️ Su sesión ha expirado, ingrese nuevamente";
                            tipoMensaje = "info";
                            break;
                        case "error_inesperado":
                            mensaje = "❌ Error inesperado del sistema";
                            tipoMensaje = "error";
                            break;
                        case "permiso_denegado":
                            mensaje = "❌ No tiene permisos para acceder a esa página";
                            tipoMensaje = "error";
                            break;
                        default:
                            mensaje = mensajeParam; // Mostrar mensaje genérico
                            tipoMensaje = "info";
                    }
                }
            }

            // 3. Mostrar el mensaje si existe
            if (mensaje != null && !mensaje.isEmpty()) {
                if (tipoMensaje == null) {
                    tipoMensaje = "info"; // Default si el tipo no fue seteado
                }
        %>
            <div class="message-box <%= tipoMensaje %>">
                <%= mensaje %>
            </div>
        <%
            }
        %>
        
        <%-- Preparar emailIntentado para el formulario --%>
        <%
            String emailIntentado = (String) request.getAttribute("emailIntentado");
            if (emailIntentado == null) {
                emailIntentado = "";
            }
        %>
        
        <form action="UsuarioSistemaControlador?accion=login" method="post" id="loginForm">
            <div class="form-group">
                <label for="email">Email:</label>
                <div class="input-with-icon">
                    <i class="input-icon">✉️</i>
                    <input type="email" id="email" name="email" 
                           value="<%= emailIntentado %>" 
                           required placeholder="usuario@ejemplo.com">
                </div>
            </div>
            
            <div class="form-group">
                <label for="password">Contraseña:</label>
                <div class="input-with-icon">
                    <i class="input-icon">🔒</i>
                    <input type="password" id="password" name="password" required placeholder="Ingrese su contraseña">
                    <button type="button" class="password-toggle" id="passwordToggle">👁️</button>
                </div>
            </div>
            
            <div class="checkbox-group">
                <label>
                    <input type="checkbox" name="recordarSesion"> Recordar sesión
                </label>
            </div>
            
            <button type="submit" class="btn" id="submitBtn">
                <span id="btnText">Iniciar Sesión</span>
                <div id="btnLoader" style="display: none;">
                    <svg width="20" height="20" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
                        <circle cx="10" cy="10" r="8" stroke="white" stroke-width="2" fill="none" stroke-dasharray="30" stroke-dashoffset="10">
                            <animateTransform attributeName="transform" type="rotate" from="0 10 10" to="360 10 10" dur="1s" repeatCount="indefinite"/>
                        </circle>
                    </svg>
                </div>
            </button>
        </form>
        
        <div class="register-link">
            <p>¿No tienes cuenta? <a href="javascript:void(0)" id="contactAdmin">Contacta al administrador</a></p>
        </div>
    </div>

    <script>
        // Efectos de partículas en el fondo
        document.addEventListener('DOMContentLoaded', function() {
            // Configuración de partículas
            const particlesConfig = {
                particles: {
                    number: { value: 80, density: { enable: true, value_area: 800 } },
                    color: { value: "#ffffff" },
                    shape: { type: "circle" },
                    opacity: { value: 0.5, random: true },
                    size: { value: 3, random: true },
                    line_linked: {
                        enable: true,
                        distance: 150,
                        color: "#ffffff",
                        opacity: 0.2,
                        width: 1
                    },
                    move: {
                        enable: true,
                        speed: 2,
                        direction: "none",
                        random: true,
                        straight: false,
                        out_mode: "out",
                        bounce: false
                    }
                },
                interactivity: {
                    detect_on: "canvas",
                    events: {
                        onhover: { enable: true, mode: "repulse" },
                        onclick: { enable: true, mode: "push" },
                        resize: true
                    }
                }
            };
            
            // Inicializar partículas
            if (typeof particlesJS !== 'undefined') {
                particlesJS('particles-js', particlesConfig);
            }
            
            // Animales flotantes
            const animalsContainer = document.getElementById('floatingAnimals');
            const animals = ['🐶', '🐱', '🐰', '🐹', '🐻', '🐼', '🐨', '🐯', '🦁', '🐮', '🐷'];
            
            for (let i = 0; i < 12; i++) {
                const animal = document.createElement('div');
                animal.className = 'animal';
                animal.textContent = animals[Math.floor(Math.random() * animals.length)];
                animal.style.left = Math.random() * 100 + 'vw';
                animal.style.animationDelay = Math.random() * 15 + 's';
                animal.style.fontSize = (Math.random() * 20 + 20) + 'px';
                animalsContainer.appendChild(animal);
            }
            
            // Huellas de patas en el fondo
            for (let i = 0; i < 25; i++) {
                const paw = document.createElement('div');
                paw.className = 'paw-print';
                paw.innerHTML = '🐾';
                paw.style.left = Math.random() * 100 + 'vw';
                paw.style.top = Math.random() * 100 + 'vh';
                paw.style.transform = `rotate(${Math.random() * 360}deg)`;
                paw.style.fontSize = (Math.random() * 15 + 10) + 'px';
                document.body.appendChild(paw);
            }
            
            // Toggle para mostrar/ocultar contraseña
            const passwordToggle = document.getElementById('passwordToggle');
            const passwordInput = document.getElementById('password');
            
            passwordToggle.addEventListener('click', function() {
                if (passwordInput.type === 'password') {
                    passwordInput.type = 'text';
                    passwordToggle.textContent = '🙈';
                } else {
                    passwordInput.type = 'password';
                    passwordToggle.textContent = '👁️';
                }
            });
            
            // Efecto de carga en el botón de envío
            const loginForm = document.getElementById('loginForm');
            const submitBtn = document.getElementById('submitBtn');
            const btnText = document.getElementById('btnText');
            const btnLoader = document.getElementById('btnLoader');
            
            loginForm.addEventListener('submit', function() {
                btnText.style.display = 'none';
                btnLoader.style.display = 'block';
                submitBtn.disabled = true;
            });
            
            // Efecto de contacto con administrador
            const contactAdmin = document.getElementById('contactAdmin');
            contactAdmin.addEventListener('click', function() {
                alert('Para solicitar una cuenta, por favor contacte al administrador del sistema en admin@sistemaveterinario.com o al teléfono +1 234 567 8900.');
            });
            
            // Efectos de entrada para los campos
            const inputs = document.querySelectorAll('input');
            inputs.forEach(input => {
                input.addEventListener('focus', function() {
                    this.parentElement.parentElement.querySelector('label').style.color = '#007bff';
                });
                
                input.addEventListener('blur', function() {
                    this.parentElement.parentElement.querySelector('label').style.color = '#555';
                });
            });
            
            // Efecto de vibración para campos vacíos al enviar
            loginForm.addEventListener('submit', function(e) {
                let isValid = true;
                inputs.forEach(input => {
                    if (input.hasAttribute('required') && !input.value) {
                        isValid = false;
                        input.style.borderColor = '#dc3545';
                        input.style.animation = 'shake 0.5s';
                        
                        setTimeout(() => {
                            input.style.animation = '';
                        }, 500);
                    }
                });
                
                if (!isValid) {
                    e.preventDefault();
                    btnText.style.display = 'block';
                    btnLoader.style.display = 'none';
                    submitBtn.disabled = false;
                }
            });
            
            // Agregar estilo de animación shake
            const style = document.createElement('style');
            style.textContent = `
                @keyframes shake {
                    0%, 100% { transform: translateX(0); }
                    10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
                    20%, 40%, 60%, 80% { transform: translateX(5px); }
                }
            `;
            document.head.appendChild(style);
        });
    </script>
</body>
</html>