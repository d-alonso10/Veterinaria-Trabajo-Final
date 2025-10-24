<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, modelo.Notificacion"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notificaciones Pendientes - Sistema PetCare</title>
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

        /* Sidebar Styles - Coherente con Dashboard */
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
            max-width: 1200px;
            margin: 0 auto;
        }

        /* Botones - Coherentes con Dashboard */
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

        .btn-small {
            padding: 12px 20px;
            font-size: 0.9em;
        }

        /* Stats Container */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }

        .stat-card {
            background: var(--white);
            padding: 25px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            text-align: center;
            border: 1px solid rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.8s ease-out;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
        }

        .stat-card.pending::before {
            background: var(--gradient-warning);
        }

        .stat-card.sent::before {
            background: var(--gradient-success);
        }

        .stat-card.failed::before {
            background: var(--gradient-danger);
        }

        .stat-card.total::before {
            background: var(--gradient-primary);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }

        .stat-icon {
            font-size: 2.5em;
            margin-bottom: 10px;
            display: block;
        }

        .stat-number {
            font-size: 2.2em;
            font-weight: 800;
            margin: 10px 0;
            color: var(--text-dark);
        }

        .stat-label {
            color: var(--text-light);
            font-size: 0.95em;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Notifications Container */
        .notifications-container {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            margin: 30px 0;
            border: 1px solid rgba(0, 0, 0, 0.05);
            animation: fadeInUp 0.8s ease-out;
        }

        .notification-item {
            padding: 25px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .notification-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            bottom: 0;
            width: 4px;
            background: var(--warning-color);
        }

        .notification-item:hover {
            background-color: rgba(255, 193, 7, 0.05);
            transform: translateY(-2px);
        }

        .notification-item:last-child {
            border-bottom: none;
        }

        .notification-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
            gap: 15px;
        }

        .notification-title {
            font-size: 1.3em;
            font-weight: 700;
            color: var(--text-dark);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
            flex: 1;
        }

        .notification-badges {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.85em;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .badge-warning {
            background: linear-gradient(135deg, #fff8e1 0%, #ffecb3 100%);
            color: #b7950b;
            border: 1px solid #ffd54f;
        }

        .badge-success {
            background: linear-gradient(135deg, #e8f6ef 0%, #d1f2eb 100%);
            color: #1e8449;
            border: 1px solid #a3e4d7;
        }

        .badge-info {
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            color: #1565c0;
            border: 1px solid #90caf9;
        }

        .badge-danger {
            background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%);
            color: #c62828;
            border: 1px solid #ef9a9a;
        }

        .notification-content {
            color: var(--text-dark);
            font-size: 1em;
            line-height: 1.6;
            margin-bottom: 15px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: var(--radius);
            border-left: 3px solid var(--primary-color);
        }

        .notification-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: var(--text-light);
            font-size: 0.9em;
            flex-wrap: wrap;
            gap: 15px;
        }

        .notification-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .btn-action {
            padding: 8px 16px;
            font-size: 0.85em;
            border-radius: 12px;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 80px 40px;
            color: var(--text-light);
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin: 30px 0;
            animation: fadeInUp 0.8s ease-out;
        }

        .empty-state-icon {
            font-size: 4em;
            margin-bottom: 20px;
            display: block;
            opacity: 0.7;
        }

        .empty-state h3 {
            font-size: 1.8em;
            margin-bottom: 15px;
            color: var(--text-dark);
            font-weight: 600;
        }

        .empty-state p {
            font-size: 1.1em;
            margin-bottom: 30px;
            max-width: 500px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.8;
        }

        /* Mensajes de estado mejorados */
        .mensaje {
            padding: 20px 25px;
            margin: 0 0 30px 0;
            border-radius: var(--radius);
            border-left: 4px solid;
            font-size: 1em;
            box-shadow: var(--shadow);
            animation: slideInDown 0.5s ease-out;
        }

        @keyframes slideInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .exito {
            background: linear-gradient(135deg, #f0f9f4 0%, #e8f5e8 100%);
            border-left-color: var(--success-color);
            color: #1e7e34;
        }

        .error {
            background: linear-gradient(135deg, #fdf2f2 0%, #fde8e8 100%);
            border-left-color: var(--danger-color);
            color: #c53030;
        }

        .info {
            background: linear-gradient(135deg, #f0f7ff 0%, #e6f3ff 100%);
            border-left-color: var(--info-color);
            color: var(--text-dark);
        }

        /* Bulk Actions */
        .bulk-actions {
            background: var(--white);
            padding: 20px 25px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 25px;
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
            animation: fadeInUp 0.6s ease-out;
        }

        .bulk-actions-label {
            font-weight: 600;
            color: var(--text-dark);
            font-size: 1em;
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
            .notification-header {
                flex-direction: column;
                align-items: flex-start;
            }
            .notification-meta {
                flex-direction: column;
                align-items: flex-start;
            }
            .notification-actions {
                width: 100%;
                justify-content: center;
            }
            .bulk-actions {
                flex-direction: column;
                align-items: stretch;
            }
            .stats-container {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 480px) {
            .header {
                padding: 20px;
            }
            .main-content {
                padding: 15px;
            }
            .stats-container {
                grid-template-columns: 1fr;
            }
            .btn {
                width: 100%;
                justify-content: center;
            }
        }

        /* Loading animation */
        .loading-dots {
            display: inline-flex;
            gap: 4px;
        }

        .loading-dots span {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: var(--primary-color);
            animation: loading 1.4s infinite ease-in-out;
        }

        .loading-dots span:nth-child(1) { animation-delay: -0.32s; }
        .loading-dots span:nth-child(2) { animation-delay: -0.16s; }

        @keyframes loading {
            0%, 80%, 100% { transform: scale(0); }
            40% { transform: scale(1); }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Sidebar Menu - Coherente con Dashboard -->
        <div class="sidebar">
            <div class="logo">
                <h1><span class="logo-icon">🐕</span> Terán Vet</h1>
            </div>
            
            <div class="user-info">
                <div class="user-avatar">JS</div>
                <div class="user-details">
                    <h3>Juan Sánchez</h3>
                    <p>Administrador del Sistema</p>
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
                <li class="menu-item">
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
                    <a href="<%= request.getContextPath() %>/MascotaControlador?accion=listarTodas">
                        <span class="menu-icon">🐾</span>
                        <span>Mascotas</span>
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
                
                <!-- Análisis y Control -->
                <div class="menu-section">Análisis y Control</div>
                <li class="menu-item">
                    <a href="reportes.jsp">
                        <span class="menu-icon">📈</span>
                        <span>Reportes</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="auditoria.jsp">
                        <span class="menu-icon">🔍</span>
                        <span>Auditoria</span>
                    </a>
                </li>
                
                <!-- Sistema -->
                <div class="menu-section">Sistema</div>
                <li class="menu-item active">
                    <a href="UtilidadesControlador">
                        <span class="menu-icon">🔧</span>
                        <span>Utilidades</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="configuracion.jsp">
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
                        <h1>🔔 Notificaciones Pendientes</h1>
                        <p>Gestión y envío de comunicaciones del sistema</p>
                    </div>
                    <div class="header-actions">
                        <a href="UtilidadesControlador" class="btn btn-secondary">
                            <span>🔧 Volver al Panel</span>
                        </a>
                        <button onclick="enviarTodasNotificaciones()" class="btn btn-success">
                            <span>📤 Enviar Todas</span>
                        </button>
                    </div>
                </div>
            </div>

            <div class="main-content">
                <!-- Mensajes -->
                <% if (request.getAttribute("mensaje") != null) { %>
                    <div class="mensaje exito">
                        <strong><%= request.getAttribute("mensaje") %></strong>
                    </div>
                <% } %>

                <!-- Estadísticas de Notificaciones -->
                <%
                    List<Notificacion> notificaciones = (List<Notificacion>) request.getAttribute("notificaciones");
                    Integer totalNotificaciones = (Integer) request.getAttribute("totalNotificaciones");
                    int notificacionesEmail = 0;
                    int notificacionesSMS = 0;
                    int notificacionesPush = 0;
                    
                    if (notificaciones != null) {
                        for (Notificacion notif : notificaciones) {
                            if ("EMAIL".equalsIgnoreCase(notif.getCanal())) notificacionesEmail++;
                            else if ("SMS".equalsIgnoreCase(notif.getCanal())) notificacionesSMS++;
                            else if ("PUSH".equalsIgnoreCase(notif.getCanal())) notificacionesPush++;
                        }
                    }
                %>

                <div class="stats-container">
                    <div class="stat-card total">
                        <span class="stat-icon">📨</span>
                        <div class="stat-number" id="totalNotificaciones"><%= totalNotificaciones != null ? totalNotificaciones : 0 %></div>
                        <div class="stat-label">Total Pendientes</div>
                    </div>
                    <div class="stat-card pending">
                        <span class="stat-icon">📧</span>
                        <div class="stat-number" id="notificacionesEmail"><%= notificacionesEmail %></div>
                        <div class="stat-label">Notificaciones Email</div>
                    </div>
                    <div class="stat-card pending">
                        <span class="stat-icon">📱</span>
                        <div class="stat-number" id="notificacionesSMS"><%= notificacionesSMS %></div>
                        <div class="stat-label">Notificaciones SMS</div>
                    </div>
                    <div class="stat-card pending">
                        <span class="stat-icon">🔔</span>
                        <div class="stat-number" id="notificacionesPush"><%= notificacionesPush %></div>
                        <div class="stat-label">Notificaciones Push</div>
                    </div>
                </div>

                <!-- Acciones Masivas -->
                <% if (notificaciones != null && !notificaciones.isEmpty()) { %>
                    <div class="bulk-actions">
                        <div class="bulk-actions-label">Acciones Masivas:</div>
                        <button onclick="seleccionarTodas()" class="btn btn-small btn-secondary">
                            <span>✅ Seleccionar Todas</span>
                        </button>
                        <button onclick="enviarSeleccionadas()" class="btn btn-small btn-success">
                            <span>📤 Enviar Seleccionadas</span>
                        </button>
                        <button onclick="eliminarSeleccionadas()" class="btn btn-small btn-danger">
                            <span>🗑️ Eliminar Seleccionadas</span>
                        </button>
                    </div>
                <% } %>

                <!-- Lista de Notificaciones -->
                <% if (notificaciones != null && !notificaciones.isEmpty()) { %>
                    <div class="notifications-container">
                        <% 
                            int index = 0;
                            for (Notificacion notif : notificaciones) { 
                                index++;
                        %>
                            <div class="notification-item" data-notification-index="<%= index %>">
                                <div class="notification-header">
                                    <div class="notification-title">
                                        <span><%= notif.getTipo() != null ? notif.getTipo() : "Notificación del Sistema" %></span>
                                        <div class="notification-badges">
                                            <span class="badge badge-warning">PENDIENTE</span>
                                            <% if (notif.getCanal() != null) { %>
                                                <span class="badge badge-info"><%= notif.getCanal() %></span>
                                            <% } %>
                                            <!-- Removido getPrioridad() ya que no existe en la clase -->
                                        </div>
                                    </div>
                                    <div class="notification-actions">
                                        <button onclick="enviarNotificacion(<%= index %>)" class="btn btn-success btn-action">
                                            <span>📤 Enviar</span>
                                        </button>
                                        <button onclick="editarNotificacion(<%= index %>)" class="btn btn-primary btn-action">
                                            <span>✏️ Editar</span>
                                        </button>
                                        <button onclick="eliminarNotificacion(<%= index %>)" class="btn btn-danger btn-action">
                                            <span>🗑️ Eliminar</span>
                                        </button>
                                        <input type="checkbox" class="notification-checkbox" data-index="<%= index %>" style="margin-left: 10px;">
                                    </div>
                                </div>
                                
                                <div class="notification-content">
                                    <strong>📝 Contenido:</strong><br>
                                    <%= notif.getContenido() != null ? notif.getContenido() : "Sin contenido especificado" %>
                                </div>
                                
                                <div class="notification-meta">
                                    <div>
                                        <strong>👤 Destinatario ID:</strong> 
                                        <span class="badge badge-info"><%= notif.getDestinatarioId() %></span>
                                        <% if (notif.getReferenciaTipo() != null) { %>
                                            | <strong>🔗 Referencia:</strong> 
                                            <span class="badge badge-secondary"><%= notif.getReferenciaTipo() %> #<%= notif.getReferenciaId() %></span>
                                        <% } %>
                                    </div>
                                    <div>
                                        <strong>⏰ Programada:</strong> 
                                        <span class="badge"><%= notif.getEnviadoAt() != null ? notif.getEnviadoAt().toString() : "Inmediata" %></span>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>

                    <!-- Resumen -->
                    <div class="info" style="margin: 20px 0; padding: 15px 25px;">
                        <strong>📋 Resumen:</strong> 
                        <strong><%= notificaciones.size() %></strong> notificaciones pendientes | 
                        <strong><%= notificacionesEmail %></strong> por email | 
                        <strong><%= notificacionesSMS %></strong> por SMS | 
                        <strong><%= notificacionesPush %></strong> push notifications
                    </div>

                <% } else { %>
                    <div class="empty-state">
                        <span class="empty-state-icon">🎉</span>
                        <h3>¡No hay notificaciones pendientes!</h3>
                        <p>
                            Todas las notificaciones han sido procesadas correctamente. 
                            El sistema está al día con las comunicaciones pendientes.
                        </p>
                        <div style="display: flex; gap: 15px; justify-content: center; margin-top: 20px;">
                            <a href="UtilidadesControlador" class="btn btn-primary">
                                <span>🔧 Volver al Panel</span>
                            </a>
                            <a href="dashboard.jsp" class="btn btn-success">
                                <span>📊 Ir al Dashboard</span>
                            </a>
                        </div>
                    </div>
                <% } %>

                <!-- Navegación -->
                <div style="display: flex; gap: 15px; margin-top: 40px; justify-content: center; flex-wrap: wrap;">
                    <a href="UtilidadesControlador" class="btn btn-secondary">
                        <span>🔧 Panel de Utilidades</span>
                    </a>
                    <a href="dashboard.jsp" class="btn btn-primary">
                        <span>📊 Dashboard Principal</span>
                    </a>
                    <a href="menuPrincipal.jsp" class="btn btn-success">
                        <span>🏠 Menú Principal</span>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Script mejorado para gestión de notificaciones
        document.addEventListener('DOMContentLoaded', function() {
            // Animación de contadores en las estadísticas
            function animateCounter(element, target) {
                let current = 0;
                const increment = target / 50;
                const timer = setInterval(() => {
                    current += increment;
                    if (current >= target) {
                        element.textContent = target;
                        clearInterval(timer);
                    } else {
                        element.textContent = Math.floor(current);
                    }
                }, 40);
            }

            // Animar contadores después de un pequeño delay
            setTimeout(() => {
                const totalElement = document.getElementById('totalNotificaciones');
                const emailElement = document.getElementById('notificacionesEmail');
                const smsElement = document.getElementById('notificacionesSMS');
                const pushElement = document.getElementById('notificacionesPush');
                
                if (totalElement) animateCounter(totalElement, <%= totalNotificaciones != null ? totalNotificaciones : 0 %>);
                if (emailElement) animateCounter(emailElement, <%= notificacionesEmail %>);
                if (smsElement) animateCounter(smsElement, <%= notificacionesSMS %>);
                if (pushElement) animateCounter(pushElement, <%= notificacionesPush %>);
            }, 500);

            // Efectos de hover para notificaciones
            const notificationItems = document.querySelectorAll('.notification-item');
            notificationItems.forEach((item, index) => {
                item.style.animationDelay = (index * 0.1) + 's';
            });

            // Selección de notificaciones
            const checkboxes = document.querySelectorAll('.notification-checkbox');
            checkboxes.forEach(checkbox => {
                checkbox.addEventListener('change', function() {
                    updateBulkActions();
                });
            });
        });

        // Funciones de gestión de notificaciones
        function enviarNotificacion(index) {
            if (confirm(`¿Estás seguro de que deseas enviar esta notificación ahora?`)) {
                const btn = event.target.closest('.btn');
                const originalText = btn.innerHTML;
                btn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Enviando...';
                btn.disabled = true;

                // Simular envío (en producción sería una llamada AJAX)
                setTimeout(() => {
                    btn.innerHTML = originalText;
                    btn.disabled = false;
                    alert(`✅ Notificación #${index} enviada correctamente`);
                    // Recargar la página o actualizar la interfaz
                    location.reload();
                }, 2000);
            }
        }

        function editarNotificacion(index) {
            alert(`✏️ Editando notificación #${index}\n\nEsta función abriría un formulario de edición en una implementación completa.`);
        }

        function eliminarNotificacion(index) {
            if (confirm(`⚠️ ¿Estás seguro de que deseas eliminar esta notificación?\n\nEsta acción no se puede deshacer.`)) {
                const btn = event.target.closest('.btn');
                const originalText = btn.innerHTML;
                btn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Eliminando...';
                btn.disabled = true;

                // Simular eliminación
                setTimeout(() => {
                    btn.innerHTML = originalText;
                    btn.disabled = false;
                    alert(`🗑️ Notificación #${index} eliminada correctamente`);
                    // Recargar la página o actualizar la interfaz
                    location.reload();
                }, 1500);
            }
        }

        // Funciones de acciones masivas
        function seleccionarTodas() {
            const checkboxes = document.querySelectorAll('.notification-checkbox');
            const allChecked = Array.from(checkboxes).every(cb => cb.checked);
            
            checkboxes.forEach(checkbox => {
                checkbox.checked = !allChecked;
            });
            
            updateBulkActions();
        }

        function enviarSeleccionadas() {
            const selectedIndexes = getSelectedNotificationIndexes();
            if (selectedIndexes.length === 0) {
                alert('⚠️ Por favor, selecciona al menos una notificación para enviar.');
                return;
            }

            if (confirm(`¿Estás seguro de que deseas enviar ${selectedIndexes.length} notificaciones seleccionadas?`)) {
                const btn = event.target;
                const originalText = btn.innerHTML;
                btn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Enviando...';
                btn.disabled = true;

                setTimeout(() => {
                    btn.innerHTML = originalText;
                    btn.disabled = false;
                    alert(`✅ ${selectedIndexes.length} notificaciones enviadas correctamente`);
                    location.reload();
                }, 3000);
            }
        }

        function eliminarSeleccionadas() {
            const selectedIndexes = getSelectedNotificationIndexes();
            if (selectedIndexes.length === 0) {
                alert('⚠️ Por favor, selecciona al menos una notificación para eliminar.');
                return;
            }

            if (confirm(`⚠️ ¿Estás seguro de que deseas eliminar ${selectedIndexes.length} notificaciones seleccionadas?\n\nEsta acción no se puede deshacer.`)) {
                const btn = event.target;
                const originalText = btn.innerHTML;
                btn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Eliminando...';
                btn.disabled = true;

                setTimeout(() => {
                    btn.innerHTML = originalText;
                    btn.disabled = false;
                    alert(`🗑️ ${selectedIndexes.length} notificaciones eliminadas correctamente`);
                    location.reload();
                }, 2500);
            }
        }

        function getSelectedNotificationIndexes() {
            const checkboxes = document.querySelectorAll('.notification-checkbox:checked');
            return Array.from(checkboxes).map(cb => cb.getAttribute('data-index'));
        }

        function updateBulkActions() {
            const selectedCount = getSelectedNotificationIndexes().length;
            const bulkLabel = document.querySelector('.bulk-actions-label');
            if (bulkLabel) {
                bulkLabel.textContent = `Acciones Masivas (${selectedCount} seleccionadas):`;
            }
        }

        function enviarTodasNotificaciones() {
            const total = <%= totalNotificaciones != null ? totalNotificaciones : 0 %>;
            if (total === 0) {
                alert('No hay notificaciones pendientes para enviar.');
                return;
            }

            if (confirm(`¿Estás seguro de que deseas enviar todas las ${total} notificaciones pendientes?`)) {
                const btn = event.target;
                const originalText = btn.innerHTML;
                btn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Enviando todas...';
                btn.disabled = true;

                setTimeout(() => {
                    btn.innerHTML = originalText;
                    btn.disabled = false;
                    alert(`✅ Todas las notificaciones (${total}) han sido enviadas correctamente`);
                    location.reload();
                }, 4000);
            }
        }

        // Atajos de teclado
        document.addEventListener('keydown', function(e) {
            // Ctrl + A para seleccionar todas
            if (e.ctrlKey && e.key === 'a') {
                e.preventDefault();
                seleccionarTodas();
            }
            
            // Ctrl + E para enviar todas
            if (e.ctrlKey && e.key === 'e') {
                e.preventDefault();
                enviarTodasNotificaciones();
            }
        });

        // Auto-selección al hacer clic en la notificación
        document.addEventListener('click', function(e) {
            if (e.target.closest('.notification-item') && !e.target.closest('.notification-actions')) {
                const checkbox = e.target.closest('.notification-item').querySelector('.notification-checkbox');
                if (checkbox) {
                    checkbox.checked = !checkbox.checked;
                    updateBulkActions();
                }
            }
        });
    </script>
</body>
</html>