<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cancelar Cita - Sistema PetCare</title>
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
            --gradient-info: linear-gradient(135deg, var(--info-color) 0%, #0b7dda 100%);
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

        /* Sidebar Styles */
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

        .logo-icon {
            font-size: 2em;
        }

        .user-info {
            padding: 25px 20px;
            display: flex;
            align-items: center;
            gap: 15px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            background: rgba(255, 255, 255, 0.05);
        }

        .user-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 1.2em;
            border: 2px solid rgba(255, 255, 255, 0.3);
        }

        .user-details h3 {
            font-size: 1.1em;
            margin-bottom: 5px;
            font-weight: 600;
        }

        .user-details p {
            font-size: 0.85em;
            opacity: 0.9;
        }

        .menu {
            list-style: none;
            padding: 25px 0;
        }

        .menu-section {
            padding: 15px 25px;
            font-size: 0.75em;
            text-transform: uppercase;
            color: rgba(255, 255, 255, 0.7);
            letter-spacing: 1.5px;
            margin-top: 15px;
            font-weight: 600;
            background: rgba(255, 255, 255, 0.05);
        }

        .menu-item {
            padding: 16px 30px;
            border-left: 4px solid transparent;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 15px;
            position: relative;
            overflow: hidden;
        }

        .menu-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
            transition: left 0.6s;
        }

        .menu-item:hover::before {
            left: 100%;
        }

        .menu-item:hover {
            background-color: rgba(255, 255, 255, 0.1);
            border-left-color: var(--white);
            transform: translateX(5px);
        }

        .menu-item.active {
            background-color: rgba(255, 255, 255, 0.15);
            border-left-color: var(--white);
        }

        .menu-item a {
            color: var(--white);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 15px;
            width: 100%;
            font-size: 0.95em;
            font-weight: 500;
        }

        .menu-icon {
            font-size: 1.3em;
            width: 24px;
            text-align: center;
        }

        /* Main Content Styles */
        .content {
            flex: 1;
            padding: 0;
            background: transparent;
            overflow-y: auto;
        }

        .header {
            background: var(--white);
            padding: 25px 40px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
            position: relative;
            overflow: hidden;
        }

        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: var(--gradient-primary);
        }

        .header-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .welcome h1 {
            font-size: 2.2em;
            color: var(--text-dark);
            margin-bottom: 8px;
            font-weight: 700;
        }

        .welcome p {
            color: var(--text-light);
            font-size: 1.1em;
            font-weight: 500;
        }

        .header-actions {
            display: flex;
            gap: 15px;
        }

        .main-content {
            padding: 40px;
            max-width: 900px;
            margin: 0 auto;
        }

        /* Botones */
        .btn {
            padding: 16px 28px;
            border: none;
            border-radius: var(--radius);
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            font-size: 0.95em;
            position: relative;
            overflow: hidden;
            border: 1px solid transparent;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.6s;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-primary {
            background: var(--gradient-primary);
            color: var(--white);
            box-shadow: 0 8px 25px rgba(171, 203, 213, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(171, 203, 213, 0.4);
        }

        .btn-success {
            background: var(--gradient-success);
            color: var(--white);
            box-shadow: 0 8px 25px rgba(76, 175, 80, 0.3);
        }

        .btn-success:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(76, 175, 80, 0.4);
        }

        .btn-warning {
            background: var(--gradient-warning);
            color: var(--text-dark);
            box-shadow: 0 8px 25px rgba(255, 193, 7, 0.3);
        }

        .btn-warning:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(255, 193, 7, 0.4);
        }

        .btn-danger {
            background: var(--gradient-danger);
            color: var(--white);
            box-shadow: 0 8px 25px rgba(244, 67, 54, 0.3);
        }

        .btn-danger:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(244, 67, 54, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, var(--secondary-color) 0%, #c9b18c 100%);
            color: var(--text-dark);
            box-shadow: 0 8px 25px rgba(213, 196, 173, 0.3);
        }

        .btn-secondary:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(213, 196, 173, 0.4);
        }

        .btn-info {
            background: var(--gradient-info);
            color: var(--white);
            box-shadow: 0 8px 25px rgba(33, 150, 243, 0.3);
        }

        .btn-info:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(33, 150, 243, 0.4);
        }

        .btn-small {
            padding: 12px 20px;
            font-size: 0.85em;
        }

        .btn-full {
            width: 100%;
            justify-content: center;
        }

        /* Mensajes de estado */
        .mensaje {
            padding: 20px 25px;
            margin: 0 0 30px 0;
            border-radius: var(--radius);
            border-left: 4px solid;
            font-size: 0.95em;
            box-shadow: var(--shadow);
            background: var(--white);
            animation: fadeInUp 0.6s ease-out;
        }

        .exito {
            border-left-color: var(--success-color);
            color: #1e7e34;
            background: linear-gradient(135deg, #f0f9f4 0%, #e8f5e8 100%);
        }

        .error {
            border-left-color: var(--danger-color);
            color: #c53030;
            background: linear-gradient(135deg, #fdf2f2 0%, #ffeaea 100%);
        }

        .info {
            border-left-color: var(--info-color);
            color: var(--text-dark);
            background: linear-gradient(135deg, #f0f7ff 0%, #e6f2ff 100%);
        }

        /* Info Container */
        .info-container {
            background: var(--white);
            padding: 50px 40px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
            text-align: center;
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.8s ease-out;
        }

        .info-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-danger);
        }

        .info-icon {
            font-size: 5em;
            margin-bottom: 25px;
            color: var(--danger-color);
            animation: pulse 2s infinite;
            display: block;
        }

        .info-container h2 {
            color: var(--text-dark);
            margin-bottom: 20px;
            font-size: 2.2em;
            font-weight: 700;
        }

        .info-container p {
            color: var(--text-light);
            font-size: 1.2em;
            margin-bottom: 30px;
            line-height: 1.8;
        }

        /* Feature List */
        .feature-list {
            text-align: left;
            background: linear-gradient(135deg, #f8f9fa 0%, #f1f3f4 100%);
            padding: 35px 30px;
            border-radius: var(--radius);
            margin: 35px 0;
            border-left: 4px solid var(--primary-color);
            transition: all 0.3s ease;
        }

        .feature-list:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }

        .feature-list h3 {
            color: var(--text-dark);
            margin-bottom: 20px;
            font-size: 1.4em;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .feature-list ul {
            list-style: none;
            padding: 0;
        }

        .feature-list li {
            padding: 15px 0;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            display: flex;
            align-items: center;
            gap: 15px;
            transition: all 0.3s ease;
        }

        .feature-list li:hover {
            background: rgba(255, 255, 255, 0.5);
            transform: translateX(5px);
        }

        .feature-list li:last-child {
            border-bottom: none;
        }

        .feature-icon {
            color: var(--primary-color);
            font-size: 1.3em;
            width: 30px;
            text-align: center;
            flex-shrink: 0;
        }

        .feature-text {
            flex: 1;
        }

        .feature-text strong {
            color: var(--text-dark);
            display: block;
            margin-bottom: 4px;
        }

        .feature-text span {
            color: var(--text-light);
            font-size: 0.95em;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 20px;
            margin-top: 40px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .action-buttons .btn {
            flex: 1;
            min-width: 200px;
            max-width: 280px;
        }

        /* Quick Actions */
        .quick-actions {
            display: flex;
            gap: 15px;
            margin: 25px 0;
            justify-content: center;
            flex-wrap: wrap;
        }

        /* Navigation */
        .navigation {
            display: flex;
            gap: 20px;
            margin-top: 40px;
            justify-content: center;
            flex-wrap: wrap;
        }

        /* Stats Card */
        .stats-card {
            background: var(--white);
            padding: 30px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin: 30px 0;
            display: flex;
            align-items: center;
            gap: 20px;
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.8s ease-out;
        }

        .stats-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-warning);
        }

        .stats-icon {
            font-size: 3em;
            color: var(--warning-color);
        }

        .stats-content h3 {
            color: var(--text-dark);
            margin-bottom: 8px;
            font-size: 1.3em;
            font-weight: 700;
        }

        .stats-content p {
            color: var(--text-light);
            font-size: 1em;
            line-height: 1.6;
        }

        /* Animation */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(40px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes pulse {
            0% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.05);
            }
            100% {
                transform: scale(1);
            }
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        .shake {
            animation: shake 0.5s ease-in-out;
        }

        /* Responsive Design */
        @media (max-width: 1200px) {
            .container {
                flex-direction: column;
            }
            .sidebar {
                width: 100%;
                height: auto;
            }
            .menu {
                display: flex;
                flex-wrap: wrap;
                justify-content: center;
                padding: 15px;
            }
            .menu-item {
                flex: 1 0 200px;
                justify-content: center;
            }
            .menu-section {
                display: none;
            }
        }

        @media (max-width: 768px) {
            .main-content {
                padding: 20px;
            }
            .header-top {
                flex-direction: column;
                gap: 20px;
                align-items: flex-start;
            }
            .header-actions {
                width: 100%;
                justify-content: center;
            }
            .info-container {
                padding: 30px 20px;
            }
            .action-buttons {
                flex-direction: column;
            }
            .action-buttons .btn {
                max-width: none;
            }
            .feature-list {
                padding: 25px 20px;
            }
            .stats-card {
                flex-direction: column;
                text-align: center;
            }
            .navigation {
                flex-direction: column;
            }
        }

        @media (max-width: 480px) {
            .header {
                padding: 20px;
            }
            .main-content {
                padding: 15px;
            }
            .info-container {
                padding: 25px 15px;
            }
            .info-icon {
                font-size: 4em;
            }
            .info-container h2 {
                font-size: 1.8em;
            }
            .feature-list li {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Sidebar Menu -->
        <div class="sidebar">
            <div class="logo">
                <h1><span class="logo-icon">🐕</span> Terán Vet</h1>
            </div>
            
            <div class="user-info">
                <div class="user-avatar">JS</div>
                <div class="user-details">
                    <h3>Juan Sánchez</h3>
                    <p>Administrador</p>
                </div>
            </div>
            
            <ul class="menu">
                <!-- Núcleo del Negocio -->
                <div class="menu-section">Núcleo del Negocio</div>
                <li class="menu-item">
                    <a href="dashboard.jsp">
                        <span class="menu-icon">📊</span>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="menu-item active">
                    <a href="CitaControlador?accion=todasCitas">
                        <span class="menu-icon">📅</span>
                        <span>Citas</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="AtencionControlador">
                        <span class="menu-icon">🎯</span>
                        <span>Atención</span>
                    </a>
                </li>
                
                <!-- Gestión de Clientes -->
                <div class="menu-section">Gestión de Clientes</div>
                <li class="menu-item">
                    <a href="<%= request.getContextPath() %>/ClienteControlador?accion=listarTodos">
                        <span class="menu-icon">👥</span>
                        <span>Clientes</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="ServicioControlador">
                        <span class="menu-icon">🛠️</span>
                        <span>Servicios</span>
                    </a>
                </li>
                
                <!-- Personal y Operaciones -->
                <div class="menu-section">Personal y Operaciones</div>
                <li class="menu-item">
                    <a href="GroomerControlador">
                        <span class="menu-icon">✂️</span>
                        <span>Groomers</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="SucursalControlador?accion=listar">
                        <span class="menu-icon">🏢</span>
                        <span>Sucursales</span>
                    </a>
                </li>
                
                <!-- Finanzas -->
                <div class="menu-section">Finanzas</div>
                <li class="menu-item">
                    <a href="pagos.jsp">
                        <span class="menu-icon">💳</span>
                        <span>Pagos</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="facturas.jsp">
                        <span class="menu-icon">🧾</span>
                        <span>Facturas</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="promociones.jsp">
                        <span class="menu-icon">🎁</span>
                        <span>Promociones</span>
                    </a>
                </li>
                
                <!-- Análisis y Control -->
                <div class="menu-section">Análisis y Control</div>
                <li class="menu-item">
                    <a href="ReporteControlador">
                        <span class="menu-icon">📈</span>
                        <span>Reportes</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="AuditControlador?accion=listar">
                        <span class="menu-icon">🔍</span>
                        <span>Auditoria</span>
                    </a>
                </li>
                
                <!-- Sistema -->
                <div class="menu-section">Sistema</div>
                <li class="menu-item">
                    <a href="ConfiguracionControlador?accion=listar">
                        <span class="menu-icon">⚙️</span>
                        <span>Configuración</span>
                    </a>
                </li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="content">
            <div class="header">
                <div class="header-top">
                    <div class="welcome">
                        <h1>❌ Cancelar Cita</h1>
                        <p>Gestión de cancelación de citas del sistema</p>
                    </div>
                    <div class="header-actions">
                        <a href="CitaControlador?accion=todasCitas" class="btn btn-secondary">← Volver a Citas</a>
                    </div>
                </div>
            </div>

            <div class="main-content">
                <!-- Mensajes -->
                <% String mensaje = (String) request.getAttribute("mensaje"); %>
                <% if (mensaje != null) { %>
                    <div class="mensaje <%= mensaje.contains("✅") ? "exito" : mensaje.contains("❌") ? "error" : "info" %>">
                        <%= mensaje %>
                    </div>
                <% } %>

                <div class="info-container">
                    <div class="info-icon">❌</div>
                    <h2>Cancelación de Citas</h2>
                    <p>Esta funcionalidad está diseñada para usarse directamente desde la tabla de próximas citas.</p>
                    
                    <!-- Estadísticas -->
                    <div class="stats-card">
                        <div class="stats-icon">📊</div>
                        <div class="stats-content">
                            <h3>Proceso de Cancelación</h3>
                            <p>Las cancelaciones se registran automáticamente en el sistema y pueden generar notificaciones a los clientes afectados.</p>
                        </div>
                    </div>

                    <div class="feature-list">
                        <h3><span class="feature-icon">📋</span> Cómo cancelar una cita:</h3>
                        <ul>
                            <li>
                                <span class="feature-icon">1️⃣</span>
                                <div class="feature-text">
                                    <strong>Navega a la sección "Citas"</strong>
                                    <span>En el menú lateral, haz clic en la opción Citas</span>
                                </div>
                            </li>
                            <li>
                                <span class="feature-icon">2️⃣</span>
                                <div class="feature-text">
                                    <strong>Localiza la cita</strong>
                                    <span>Encuentra la cita que deseas cancelar en la tabla de próximas citas</span>
                                </div>
                            </li>
                            <li>
                                <span class="feature-icon">3️⃣</span>
                                <div class="feature-text">
                                    <strong>Haz clic en el botón rojo "❌"</strong>
                                    <span>En la columna de Acciones, selecciona el ícono de cancelación</span>
                                </div>
                            </li>
                            <li>
                                <span class="feature-icon">4️⃣</span>
                                <div class="feature-text">
                                    <strong>Confirma la cancelación</strong>
                                    <span>Verifica los datos y confirma la acción en el diálogo emergente</span>
                                </div>
                            </li>
                        </ul>
                    </div>

                    <p><strong>💡 Nota:</strong> Las cancelaciones se registran en el sistema y pueden generar notificaciones automáticas al cliente.</p>

                    <div class="action-buttons">
                        <a href="CitaControlador?accion=todasCitas" class="btn btn-primary">📅 Ver Próximas Citas</a>
                        <a href="CrearCita.jsp" class="btn btn-success">➕ Crear Nueva Cita</a>
                        <a href="reportes.jsp?tipo=cancelaciones" class="btn btn-info">📊 Reportes de Cancelación</a>
                    </div>

                    <!-- Acciones Rápidas -->
                    <div class="quick-actions">
                        <button onclick="irACitas()" class="btn btn-small btn-primary">🚀 Ir a Citas</button>
                        <button onclick="mostrarAyuda()" class="btn btn-small btn-info">❓ Ayuda Rápida</button>
                        <button onclick="contactarSoporte()" class="btn btn-small btn-warning">📞 Soporte</button>
                    </div>
                </div>

                <div class="navigation">
                    <a href="CitaControlador?accion=todasCitas" class="btn btn-secondary">← Volver a Próximas Citas</a>
                    <a href="dashboard.jsp" class="btn btn-primary">📊 Ir al Dashboard</a>
                    <a href="Menu.jsp" class="btn btn-warning">🏠 Menú Principal</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Script para manejar la interacción del menú
        document.addEventListener('DOMContentLoaded', function() {
            const menuItems = document.querySelectorAll('.menu-item');
            
            menuItems.forEach(item => {
                item.addEventListener('click', function() {
                    // Remover clase active de todos los items
                    menuItems.forEach(i => i.classList.remove('active'));
                    // Agregar clase active al item clickeado
                    this.classList.add('active');
                });
            });

            // Efectos visuales adicionales
            const infoIcon = document.querySelector('.info-icon');
            infoIcon.addEventListener('mouseenter', function() {
                this.style.animation = 'pulse 0.5s infinite';
            });
            
            infoIcon.addEventListener('mouseleave', function() {
                this.style.animation = 'pulse 2s infinite';
            });

            // Efecto hover para elementos de la lista
            const featureItems = document.querySelectorAll('.feature-list li');
            featureItems.forEach(item => {
                item.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateX(8px)';
                });
                item.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateX(0)';
                });
            });

            // Mostrar información adicional si hay parámetros en la URL
            const urlParams = new URLSearchParams(window.location.search);
            const idCita = urlParams.get('idCita');
            const accion = urlParams.get('accion');
            
            if (idCita && accion === 'cancelar') {
                // Si se accede directamente con parámetros de cancelación
                const mensajeDiv = document.createElement('div');
                mensajeDiv.className = 'mensaje info';
                mensajeDiv.innerHTML = `
                    <strong>⚠️ Acceso directo detectado</strong><br>
                    Estás intentando cancelar la cita ID: <strong>${idCita}</strong> directamente.<br>
                    Te recomendamos usar la tabla de citas para una mejor experiencia.
                `;
                document.querySelector('.main-content').insertBefore(mensajeDiv, document.querySelector('.info-container'));
                
                // Agregar botón de cancelación directa
                const directCancelBtn = document.createElement('button');
                directCancelBtn.className = 'btn btn-danger btn-full';
                directCancelBtn.innerHTML = '❌ Cancelar Cita Directamente';
                directCancelBtn.onclick = function() {
                    if (confirm(`¿Estás seguro de cancelar la cita ID: ${idCita}?`)) {
                        window.location.href = `CitaControlador?accion=cancelar&idCita=${idCita}`;
                    }
                };
                document.querySelector('.action-buttons').appendChild(directCancelBtn);
            }

            // Animación de entrada para elementos
            const animatedElements = document.querySelectorAll('.info-container, .feature-list, .stats-card');
            animatedElements.forEach((element, index) => {
                element.style.animationDelay = (index * 0.2) + 's';
            });
        });

        // Funciones de navegación rápida
        function irACitas() {
            window.location.href = 'CitaControlador?accion=todasCitas';
        }

        function mostrarAyuda() {
            alert('📖 Centro de Ayuda:\n\n• Para cancelar citas: Navega a "Citas" → Busca la cita → Haz clic en "❌"\n• Las cancelaciones generan registros automáticos\n• Los clientes reciben notificaciones de cancelación\n\n¿Necesitas más ayuda? Contacta al soporte técnico.');
        }

        function contactarSoporte() {
            alert('📞 Soporte Técnico:\n\n• Email: soporte@teranvet.com\n• Teléfono: +1 234 567 8900\n• Horario: Lunes a Viernes 8:00 - 18:00\n\nEstamos aquí para ayudarte con cualquier problema técnico.');
        }

        // Función para simular cancelación directa (solo para demostración)
        function cancelarCitaDirecta() {
            const idCita = prompt('🔍 Ingrese el ID de la cita a cancelar:');
            if (idCita) {
                if (confirm(`⚠️ ¿Está seguro de que desea cancelar la cita ID: ${idCita}?\n\nEsta acción no se puede deshacer.`)) {
                    // Agregar efecto de loading
                    const btn = event.target;
                    const originalText = btn.innerHTML;
                    btn.innerHTML = '⏳ Procesando...';
                    btn.disabled = true;
                    
                    setTimeout(() => {
                        window.location.href = `CitaControlador?accion=cancelar&idCita=${idCita}`;
                    }, 1500);
                }
            }
        }

        // Efecto de shake para el ícono de advertencia al hacer hover
        document.querySelector('.info-icon').addEventListener('mouseenter', function() {
            this.classList.add('shake');
        });

        document.querySelector('.info-icon').addEventListener('animationend', function() {
            this.classList.remove('shake');
        });
    </script>
</body>
</html>