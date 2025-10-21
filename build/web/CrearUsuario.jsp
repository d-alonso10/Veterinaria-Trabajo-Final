<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.UsuarioSistema"%>
<%
    // Verificar si el usuario está logueado y es administrador
    HttpSession userSession = request.getSession(false);
    UsuarioSistema usuarioLogueado = null;
    if (userSession != null) {
        usuarioLogueado = (UsuarioSistema) userSession.getAttribute("usuarioLogueado");
    }
    
    // Redirigir si no es administrador
    if (usuarioLogueado == null || !"ADMINISTRADOR".equals(usuarioLogueado.getRol())) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Usuario - Sistema PetCare</title>
    <style>
        :root {
            --primary-color: #abcbd5;
            --primary-dark: #8fb6c1;
            --primary-light: #c5dce3;
            --secondary-color: #d5c4ad;
            --accent-color: #d5adc7;
            --success-color: #4CAF50;
            --warning-color: #FFC107;
            --danger-color: #F44336;
            --info-color: #2196F3;
            --text-dark: #2c3e50;
            --text-light: #5d6d7e;
            --bg-light: #f8f9fa;
            --white: #ffffff;
            --shadow: 0 8px 32px rgba(0,0,0,0.1);
            --radius: 16px;
            --gradient-primary: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            --gradient-success: linear-gradient(135deg, var(--success-color) 0%, #45a049 100%);
            --gradient-warning: linear-gradient(135deg, var(--warning-color) 0%, #ffb300 100%);
            --gradient-danger: linear-gradient(135deg, var(--danger-color) 0%, #d32f2f 100%);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #f5f7fa 0%, var(--primary-light) 100%);
            color: var(--text-dark);
            line-height: 1.6;
            min-height: 100vh;
        }

        .container {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 280px;
            background: var(--gradient-primary);
            color: var(--white);
            padding: 0;
            box-shadow: var(--shadow);
            position: relative;
            z-index: 10;
        }

        .logo {
            padding: 30px 20px;
            text-align: center;
            background: rgba(255, 255, 255, 0.1);
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
        }

        .logo h1 {
            font-size: 1.8em;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }

        .user-info {
            padding: 25px 20px;
            display: flex;
            align-items: center;
            gap: 15px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            background: rgba(255, 255, 255, 0.05);
        }

        .menu {
            list-style: none;
            padding: 25px 0;
        }

        .menu-item {
            padding: 16px 30px;
            border-left: 4px solid transparent;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .menu-item:hover, .menu-item.active {
            background: rgba(255, 255, 255, 0.15);
            border-left-color: var(--white);
            transform: translateX(8px);
        }

        .menu-item a {
            color: var(--white);
            text-decoration: none;
            font-weight: 500;
        }

        .main-content {
            flex: 1;
            padding: 40px;
            overflow-y: auto;
        }

        .header {
            background: var(--white);
            padding: 30px 40px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
            position: relative;
        }

        .header h1 {
            font-size: 2.2em;
            color: var(--text-dark);
            margin-bottom: 8px;
            font-weight: 700;
        }

        .header p {
            color: var(--text-light);
            font-size: 1.1em;
        }

        .form-panel {
            background: var(--white);
            padding: 30px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 20px;
        }

        .form-panel h3 {
            color: var(--text-dark);
            margin-bottom: 25px;
            font-size: 1.3em;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 30px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-group label {
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--text-dark);
        }

        .form-control {
            padding: 14px 18px;
            border: 2px solid #e0e0e0;
            border-radius: var(--radius);
            font-size: 1em;
            transition: all 0.3s ease;
            background: var(--white);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(171, 203, 213, 0.1);
        }

        .btn {
            padding: 14px 28px;
            border: none;
            border-radius: var(--radius);
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
            font-size: 1em;
            justify-content: center;
        }

        .btn-primary {
            background: var(--gradient-primary);
            color: var(--white);
            box-shadow: 0 4px 15px rgba(171, 203, 213, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(171, 203, 213, 0.4);
        }

        .btn-secondary {
            background: #6c757d;
            color: var(--white);
        }

        .btn-success {
            background: var(--gradient-success);
            color: var(--white);
        }

        .btn-warning {
            background: var(--gradient-warning);
            color: var(--text-dark);
        }

        .role-selector {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        .role-option {
            padding: 20px;
            border: 2px solid #e0e0e0;
            border-radius: var(--radius);
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            background: var(--white);
        }

        .role-option:hover {
            border-color: var(--primary-color);
            transform: translateY(-2px);
        }

        .role-option.selected {
            border-color: var(--primary-color);
            background: rgba(171, 203, 213, 0.1);
        }

        .role-icon {
            font-size: 2.5em;
            margin-bottom: 10px;
        }

        .role-label {
            font-weight: 600;
            font-size: 1.1em;
            margin-bottom: 5px;
        }

        .role-description {
            color: var(--text-light);
            font-size: 0.9em;
        }

        .permissions-panel {
            background: var(--bg-light);
            padding: 20px;
            border-radius: var(--radius);
            margin-top: 20px;
        }

        .permissions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
        }

        .permission-group {
            background: var(--white);
            padding: 15px;
            border-radius: 12px;
            border: 1px solid #e0e0e0;
        }

        .permission-title {
            font-weight: 600;
            margin-bottom: 10px;
            color: var(--text-dark);
        }

        .permission-item {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 8px;
        }

        .permission-checkbox {
            width: 18px;
            height: 18px;
            accent-color: var(--primary-color);
        }

        .password-strength {
            margin-top: 8px;
        }

        .strength-bar {
            height: 4px;
            background: #e0e0e0;
            border-radius: 2px;
            overflow: hidden;
            margin-bottom: 5px;
        }

        .strength-fill {
            height: 100%;
            width: 0%;
            transition: all 0.3s ease;
        }

        .strength-weak { background: var(--danger-color); width: 25%; }
        .strength-fair { background: var(--warning-color); width: 50%; }
        .strength-good { background: var(--info-color); width: 75%; }
        .strength-strong { background: var(--success-color); width: 100%; }

        .strength-text {
            font-size: 0.85em;
            font-weight: 500;
        }

        .actions-section {
            display: flex;
            gap: 15px;
            justify-content: space-between;
            margin-top: 30px;
        }

        .message {
            padding: 15px 20px;
            border-radius: var(--radius);
            margin: 20px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .message.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .message.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .security-tips {
            background: linear-gradient(135deg, var(--info-color) 0%, #0b7dda 100%);
            color: var(--white);
            padding: 20px;
            border-radius: var(--radius);
            margin-bottom: 20px;
        }

        .tips-title {
            font-weight: 700;
            margin-bottom: 15px;
            font-size: 1.1em;
        }

        .tips-list {
            list-style: none;
            padding-left: 0;
        }

        .tips-list li {
            margin-bottom: 8px;
            padding-left: 20px;
            position: relative;
        }

        .tips-list li:before {
            content: "🔒";
            position: absolute;
            left: 0;
            top: 0;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .role-selector {
                grid-template-columns: 1fr;
            }
            
            .permissions-grid {
                grid-template-columns: 1fr;
            }
            
            .actions-section {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="logo">
                <h1>🐾 PetCare</h1>
            </div>
            
            <div class="user-info">
                <div class="user-avatar" style="width: 50px; height: 50px; border-radius: 50%; background: rgba(255, 255, 255, 0.2); display: flex; align-items: center; justify-content: center; font-weight: bold;">
                    <%= usuarioLogueado != null ? usuarioLogueado.getNombre().charAt(0) : "👤" %>
                </div>
                <div class="user-details">
                    <h3><%= usuarioLogueado != null ? usuarioLogueado.getNombre() : "Usuario" %></h3>
                    <p><%= usuarioLogueado != null ? usuarioLogueado.getRol() : "Rol" %></p>
                </div>
            </div>

            <ul class="menu">
                <li class="menu-item">
                    <span>📊</span>
                    <a href="Menu.jsp">Dashboard</a>
                </li>
                <li class="menu-item">
                    <span>👥</span>
                    <a href="ListaClientes.jsp">Clientes</a>
                </li>
                <li class="menu-item">
                    <span>🐕</span>
                    <a href="ListaMascotas.jsp">Mascotas</a>
                </li>
                <li class="menu-item">
                    <span>👨‍⚕️</span>
                    <a href="ListaGroomers.jsp">Groomers</a>
                </li>
                <li class="menu-item">
                    <span>🎯</span>
                    <a href="ListaServicios.jsp">Servicios</a>
                </li>
                <li class="menu-item">
                    <span>📅</span>
                    <a href="ProximasCitas.jsp">Citas</a>
                </li>
                <li class="menu-item">
                    <span>⏰</span>
                    <a href="ColaAtencion.jsp">Cola de Atención</a>
                </li>
                <li class="menu-item">
                    <span>💰</span>
                    <a href="UtilidadesFacturas.jsp">Facturas</a>
                </li>
                <li class="menu-item">
                    <span>💳</span>
                    <a href="ListaPagos.jsp">Pagos</a>
                </li>
                <li class="menu-item">
                    <span>📋</span>
                    <a href="ListaPaquetesServicios.jsp">Paquetes</a>
                </li>
                <li class="menu-item">
                    <span>🎁</span>
                    <a href="ListaPromociones.jsp">Promociones</a>
                </li>
                <li class="menu-item">
                    <span>🔧</span>
                    <a href="ListaDetallesServicios.jsp">Detalles Servicios</a>
                </li>
                <li class="menu-item">
                    <span>🔔</span>
                    <a href="UtilidadesNotificaciones.jsp">Notificaciones</a>
                </li>
                <li class="menu-item active">
                    <span>👤</span>
                    <a href="UsuarioSistemaControlador?accion=listarUsuarios">Usuarios</a>
                </li>
                <li class="menu-item">
                    <span>📊</span>
                    <a href="ReporteIngresos.jsp">Reportes</a>
                </li>
                <li class="menu-item">
                    <span>🚪</span>
                    <a href="UsuarioSistemaControlador?accion=logout">Cerrar Sesión</a>
                </li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="header">
                <h1>👤 Crear Usuario</h1>
                <p>Configura un nuevo usuario del sistema con roles y permisos específicos</p>
            </div>

            <!-- Security Tips -->
            <div class="security-tips">
                <div class="tips-title">🔒 Consejos de Seguridad</div>
                <ul class="tips-list">
                    <li>Usa contraseñas seguras con al menos 8 caracteres</li>
                    <li>Asigna solo los permisos necesarios para cada rol</li>
                    <li>Revisa regularmente los accesos y permisos de usuarios</li>
                    <li>Desactiva cuentas que no se usen por períodos prolongados</li>
                </ul>
            </div>

            <!-- Mensajes -->
            <% if (request.getAttribute("mensaje") != null) { %>
                <div class="message <%= request.getAttribute("tipoMensaje") != null ? request.getAttribute("tipoMensaje") : "success" %>">
                    <%= request.getAttribute("mensaje") %>
                </div>
            <% } %>

            <form action="UsuarioSistemaControlador" method="post" id="formUsuario">
                <input type="hidden" name="accion" value="registrar">
                
                <!-- Información Personal -->
                <div class="form-panel">
                    <h3>👤 Información Personal</h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="nombre">Nombre Completo: *</label>
                            <input type="text" id="nombre" name="nombre" class="form-control" 
                                   placeholder="Ej: Dr. Carlos Mendez" 
                                   value="<%= request.getParameter("nombre") != null ? request.getParameter("nombre") : "" %>" 
                                   required maxlength="100">
                        </div>
                        
                        <div class="form-group">
                            <label for="email">Correo Electrónico: *</label>
                            <input type="email" id="email" name="email" class="form-control" 
                                   placeholder="usuario@petcare.com" 
                                   value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>" 
                                   required maxlength="100">
                        </div>
                    </div>
                </div>

                <!-- Credenciales de Acceso -->
                <div class="form-panel">
                    <h3>🔐 Credenciales de Acceso</h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="password">Contraseña: *</label>
                            <input type="password" id="password" name="password" class="form-control" 
                                   placeholder="Mínimo 8 caracteres" 
                                   required minlength="8" onkeyup="evaluarPassword()">
                            <div class="password-strength" id="passwordStrength" style="display: none;">
                                <div class="strength-bar">
                                    <div class="strength-fill" id="strengthFill"></div>
                                </div>
                                <div class="strength-text" id="strengthText">Débil</div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="confirmPassword">Confirmar Contraseña: *</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" 
                                   placeholder="Repetir contraseña" 
                                   required minlength="8">
                        </div>
                    </div>
                </div>

                <!-- Rol y Permisos -->
                <div class="form-panel">
                    <h3>🎭 Rol y Permisos</h3>
                    
                    <div class="form-group">
                        <label>Seleccionar Rol: *</label>
                        <div class="role-selector">
                            <div class="role-option" data-role="ADMINISTRADOR">
                                <div class="role-icon">👑</div>
                                <div class="role-label">Administrador</div>
                                <div class="role-description">Control total del sistema</div>
                            </div>
                            <div class="role-option" data-role="VETERINARIO">
                                <div class="role-icon">👨‍⚕️</div>
                                <div class="role-label">Veterinario</div>
                                <div class="role-description">Consultas y diagnósticos</div>
                            </div>
                            <div class="role-option" data-role="GROOMER">
                                <div class="role-icon">✂️</div>
                                <div class="role-label">Groomer</div>
                                <div class="role-description">Servicios de estética</div>
                            </div>
                            <div class="role-option" data-role="RECEPCIONISTA">
                                <div class="role-icon">📞</div>
                                <div class="role-label">Recepcionista</div>
                                <div class="role-description">Atención al cliente</div>
                            </div>
                        </div>
                        <input type="hidden" name="rol" id="rolSeleccionado" required>
                    </div>
                </div>

                <!-- Acciones -->
                <div class="actions-section">
                    <div>
                        <a href="UsuarioSistemaControlador?accion=listarUsuarios" class="btn btn-secondary">
                            ↩️ Volver a Usuarios
                        </a>
                    </div>
                    <div style="display: flex; gap: 15px;">
                        <button type="button" class="btn btn-warning" onclick="limpiarFormulario()">
                            🔄 Limpiar
                        </button>
                        <button type="submit" class="btn btn-success" id="btnGuardar">
                            💾 Crear Usuario
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Selección de rol
        document.querySelectorAll('.role-option').forEach(function(option) {
            option.addEventListener('click', function() {
                // Limpiar selección anterior
                document.querySelectorAll('.role-option').forEach(function(opt) {
                    opt.classList.remove('selected');
                });
                
                // Seleccionar nueva opción
                this.classList.add('selected');
                
                var rol = this.dataset.role;
                document.getElementById('rolSeleccionado').value = rol;
            });
        });

        // Evaluación de fortaleza de contraseña
        function evaluarPassword() {
            var password = document.getElementById('password').value;
            var strengthDiv = document.getElementById('passwordStrength');
            var fill = document.getElementById('strengthFill');
            var text = document.getElementById('strengthText');
            
            if (password.length === 0) {
                strengthDiv.style.display = 'none';
                return;
            }
            
            strengthDiv.style.display = 'block';
            
            var score = 0;
            if (password.length >= 8) score++;
            if (/[a-z]/.test(password)) score++;
            if (/[A-Z]/.test(password)) score++;
            if (/[0-9]/.test(password)) score++;
            if (/[^A-Za-z0-9]/.test(password)) score++;
            
            fill.className = 'strength-fill';
            
            if (score <= 2) {
                fill.classList.add('strength-weak');
                text.textContent = 'Débil';
                text.style.color = 'var(--danger-color)';
            } else if (score === 3) {
                fill.classList.add('strength-fair');
                text.textContent = 'Regular';
                text.style.color = 'var(--warning-color)';
            } else if (score === 4) {
                fill.classList.add('strength-good');
                text.textContent = 'Buena';
                text.style.color = 'var(--info-color)';
            } else {
                fill.classList.add('strength-strong');
                text.textContent = 'Fuerte';
                text.style.color = 'var(--success-color)';
            }
        }

        // Auto-generar nombre de usuario
        document.getElementById('nombre').addEventListener('blur', function() {
            var emailInput = document.getElementById('email');
            if (!emailInput.value.trim()) {
                var nombres = this.value.trim().toLowerCase().split(' ');
                if (nombres.length >= 2) {
                    var email = nombres[0].toLowerCase() + '.' + nombres[nombres.length - 1].toLowerCase() + '@petcare.com';
                    emailInput.value = email.replace(/[^a-z0-9.@]/g, '');
                }
            }
        });

        // Limpiar formulario
        function limpiarFormulario() {
            if (confirm('¿Está seguro de limpiar todo el formulario?')) {
                document.getElementById('formUsuario').reset();
                document.querySelectorAll('.role-option').forEach(function(opt) {
                    opt.classList.remove('selected');
                });
                document.getElementById('rolSeleccionado').value = '';
                document.getElementById('passwordStrength').style.display = 'none';
            }
        }

        // Validación del formulario
        document.getElementById('formUsuario').addEventListener('submit', function(e) {
            var rol = document.getElementById('rolSeleccionado').value;
            if (!rol) {
                e.preventDefault();
                alert('Debe seleccionar un rol para el usuario');
                return false;
            }

            var password = document.getElementById('password').value;
            var confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Las contraseñas no coinciden');
                return false;
            }

            if (password.length < 8) {
                e.preventDefault();
                alert('La contraseña debe tener al menos 8 caracteres');
                return false;
            }

            return true;
        });

        // Inicializar
        document.addEventListener('DOMContentLoaded', function() {
            // Seleccionar el primer rol por defecto
            document.querySelector('.role-option').click();
        });
    </script>
</body>
</html>