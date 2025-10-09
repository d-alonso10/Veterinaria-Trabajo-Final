<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Actualizar Estado de Atención - Sistema PetCare</title>
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
            --gradient-success: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
            --gradient-warning: linear-gradient(135deg, #FFC107 0%, #ffb300 100%);
            --gradient-danger: linear-gradient(135deg, #F44336 0%, #d32f2f 100%);
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
            max-width: 1400px;
            margin: 0 auto;
        }

        /* Mensajes de estado */
        .mensaje {
            padding: 20px 25px;
            margin: 0 0 30px 0;
            border-radius: var(--radius);
            border-left: 6px solid;
            font-size: 1em;
            box-shadow: var(--shadow);
            background: var(--white);
            border: 1px solid rgba(0, 0, 0, 0.05);
            animation: slideInUp 0.6s ease-out;
        }

        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .exito {
            background: linear-gradient(135deg, rgba(76, 175, 80, 0.1) 0%, rgba(76, 175, 80, 0.05) 100%);
            border-left-color: var(--success-color);
            color: #2e7d32;
        }

        .error {
            background: linear-gradient(135deg, rgba(244, 67, 54, 0.1) 0%, rgba(244, 67, 54, 0.05) 100%);
            border-left-color: var(--danger-color);
            color: #c62828;
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
            background: linear-gradient(135deg, var(--info-color) 0%, #0b7dda 100%);
            color: var(--white);
            box-shadow: 0 8px 25px rgba(33, 150, 243, 0.3);
        }

        .btn-info:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(33, 150, 243, 0.4);
        }

        .btn-small {
            padding: 12px 20px;
            font-size: 0.9em;
        }

        /* Form Container */
        .form-container {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 40px;
            border: 1px solid rgba(0, 0, 0, 0.05);
            animation: fadeInUp 0.8s ease-out;
        }

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

        .form-header {
            padding: 25px 30px;
            background: var(--gradient-primary);
            color: var(--white);
        }

        .form-header h2 {
            font-size: 1.8em;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .form-body {
            padding: 30px;
        }

        /* Form Styles */
        .form-group {
            margin-bottom: 25px;
            animation: fadeInUp 0.6s ease-out;
        }

        .form-group label {
            display: block;
            margin-bottom: 10px;
            font-weight: 600;
            color: var(--text-dark);
            font-size: 1em;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .required::after {
            content: " *";
            color: var(--danger-color);
            font-weight: bold;
        }

        .form-control {
            width: 100%;
            padding: 15px 20px;
            border: 2px solid rgba(0, 0, 0, 0.1);
            border-radius: var(--radius);
            font-size: 1em;
            transition: all 0.3s ease;
            background: var(--bg-light);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(171, 203, 213, 0.2);
            background: var(--white);
            transform: translateY(-2px);
        }

        textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }

        select.form-control {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%235d6d7e' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 20px center;
            background-size: 16px;
            padding-right: 50px;
        }

        .form-help {
            display: block;
            margin-top: 8px;
            color: var(--text-light);
            font-size: 0.85em;
            font-style: italic;
        }

        .form-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid rgba(0, 0, 0, 0.1);
        }

        /* Quick Actions */
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }

        .action-card {
            background: var(--white);
            padding: 25px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            text-align: center;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid rgba(0, 0, 0, 0.05);
            cursor: pointer;
            animation: fadeInUp 0.8s ease-out;
        }

        .action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }

        .action-icon {
            font-size: 2.5em;
            margin-bottom: 15px;
            display: block;
        }

        .action-title {
            font-size: 1.1em;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 10px;
        }

        .action-description {
            color: var(--text-light);
            font-size: 0.9em;
            margin-bottom: 15px;
        }

        /* Estado Preview */
        .estado-preview {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin: 30px 0;
        }

        .estado-item {
            background: var(--white);
            padding: 20px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            text-align: center;
            border-top: 4px solid;
            transition: all 0.3s ease;
        }

        .estado-item:hover {
            transform: translateY(-3px);
        }

        .estado-indicator {
            width: 16px;
            height: 16px;
            border-radius: 50%;
            display: inline-block;
            margin-right: 8px;
        }

        .indicator-pendiente { 
            background-color: var(--warning-color);
            border-top-color: var(--warning-color);
        }
        .indicator-proceso { 
            background-color: var(--info-color);
            border-top-color: var(--info-color);
        }
        .indicator-completada { 
            background-color: var(--success-color);
            border-top-color: var(--success-color);
        }
        .indicator-cancelada { 
            background-color: var(--danger-color);
            border-top-color: var(--danger-color);
        }

        .estado-item strong {
            font-size: 1.1em;
            margin-bottom: 8px;
            display: block;
        }

        /* Estado Badges */
        .estado-badge {
            padding: 10px 16px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }

        .estado-badge:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        }

        .estado-pendiente {
            background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
            color: #ef6c00;
            border-color: #ffb74d;
        }

        .estado-proceso {
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            color: #1565c0;
            border-color: #90caf9;
        }

        .estado-completada {
            background: linear-gradient(135deg, #e8f5e8 0%, #c8e6c9 100%);
            color: #2e7d32;
            border-color: #a5d6a7;
        }

        .estado-cancelada {
            background: linear-gradient(135deg, #fdeaea 0%, #f5c6cb 100%);
            color: #c62828;
            border-color: #e57373;
        }

        /* Info Card */
        .info-card {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            margin: 30px 0;
            border: 1px solid rgba(0, 0, 0, 0.05);
            animation: fadeInUp 0.8s ease-out;
        }

        .info-header {
            padding: 20px 25px;
            background: var(--gradient-primary);
            color: var(--white);
            font-size: 1.2em;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .info-body {
            padding: 25px;
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
            .form-actions {
                flex-direction: column;
            }
            .quick-actions {
                grid-template-columns: 1fr;
            }
            .estado-preview {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 480px) {
            .header {
                padding: 20px;
            }
            .main-content {
                padding: 15px;
            }
            .btn {
                width: 100%;
                justify-content: center;
            }
        }

        /* Animation Effects */
        .floating {
            animation: floating 3s ease-in-out infinite;
        }

        @keyframes floating {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
        }

        .pulse {
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
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
                <li class="menu-item">
                    <a href="CitaControlador?accion=todasCitas">
                        <span class="menu-icon">📅</span>
                        <span>Citas</span>
                    </a>
                </li>
                <li class="menu-item active">
                    <a href="AtencionControlador">
                        <span class="menu-icon">🎯</span>
                        <span>Atención</span>
                    </a>
                </li>
                
                <!-- Gestión de Clientes -->
                <div class="menu-section">Gestión de Clientes</div>
                <li class="menu-item">
                    <a href="Clientes.jsp">
                        <span class="menu-icon">👥</span>
                        <span>Clientes</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="ListaMascotas.jsp">
                        <span class="menu-icon">🐾</span>
                        <span>Mascotas</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="ServicioControlador">
                        <span class="menu-icon">🛠️</span>
                        <span>Servicios</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="ClienteControlador?accion=listarFrecuentes">
                        <span class="menu-icon">🏆</span>
                        <span>Clientes Frecuentes</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="BuscarClientes.jsp">
                        <span class="menu-icon">🔍</span>
                        <span>Búsqueda Avanzada</span>
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
                        <h1>🔄 Actualizar Estado de Atención</h1>
                        <p>Modificar el estado actual de una atención en el sistema</p>
                    </div>
                    <div class="header-actions">
                        <a href="AtencionControlador" class="btn btn-secondary">📋 Volver a la Cola</a>
                        <a href="CitaControlador?accion=todasCitas" class="btn btn-info">📅 Ver Citas</a>
                    </div>
                </div>
            </div>

            <div class="main-content">
                <!-- Mostrar mensajes -->
                <% if (request.getAttribute("mensaje") != null) { %>
                    <div class="mensaje <%= request.getAttribute("mensaje").toString().contains("✅") ? "exito" : "error" %>">
                        <%= request.getAttribute("mensaje") %>
                    </div>
                <% } %>

                <!-- Acciones Rápidas -->
                <div class="quick-actions">
                    <div class="action-card" onclick="document.getElementById('idAtencion').focus()">
                        <span class="action-icon">🔍</span>
                        <div class="action-title">Buscar Atención</div>
                        <div class="action-description">Ingresar ID de atención existente</div>
                    </div>
                    <div class="action-card" onclick="document.getElementById('nuevoEstado').focus()">
                        <span class="action-icon">📊</span>
                        <div class="action-title">Cambiar Estado</div>
                        <div class="action-description">Seleccionar nuevo estado</div>
                    </div>
                    <div class="action-card" onclick="mostrarEstados()">
                        <span class="action-icon">ℹ️</span>
                        <div class="action-title">Ver Estados</div>
                        <div class="action-description">Información de estados disponibles</div>
                    </div>
                    <div class="action-card" onclick="cargarAtencionEjemplo()">
                        <span class="action-icon">🎯</span>
                        <div class="action-title">Ejemplo</div>
                        <div class="action-description">Cargar datos de ejemplo</div>
                    </div>
                </div>

                <!-- Estado Preview -->
                <div class="estado-preview">
                    <div class="estado-item indicator-pendiente">
                        <span class="estado-indicator indicator-pendiente"></span>
                        <strong>🟡 Pendiente</strong>
                        <div class="form-help">Atención en espera</div>
                    </div>
                    <div class="estado-item indicator-proceso">
                        <span class="estado-indicator indicator-proceso"></span>
                        <strong>🔵 En Proceso</strong>
                        <div class="form-help">Atención en curso</div>
                    </div>
                    <div class="estado-item indicator-completada">
                        <span class="estado-indicator indicator-completada"></span>
                        <strong>🟢 Completada</strong>
                        <div class="form-help">Atención finalizada</div>
                    </div>
                    <div class="estado-item indicator-cancelada">
                        <span class="estado-indicator indicator-cancelada"></span>
                        <strong>🔴 Cancelada</strong>
                        <div class="form-help">Atención cancelada</div>
                    </div>
                </div>

                <!-- Form Container -->
                <div class="form-container">
                    <div class="form-header">
                        <h2>📝 Formulario de Actualización de Estado</h2>
                    </div>

                    <div class="form-body">
                        <form action="AtencionControlador" method="POST" id="estadoForm">
                            <input type="hidden" name="accion" value="actualizarEstado">
                            
                            <div class="form-group">
                                <label for="idAtencion" class="required">🔢 ID Atención</label>
                                <input type="number" id="idAtencion" name="idAtencion" class="form-control" required 
                                       placeholder="Ingrese ID de la atención" min="1">
                                <span class="form-help">Número de identificación único de la atención</span>
                            </div>

                            <div class="form-group">
                                <label for="nuevoEstado" class="required">📊 Nuevo Estado</label>
                                <select id="nuevoEstado" name="nuevoEstado" class="form-control" required>
                                    <option value="">Seleccione un estado</option>
                                    <option value="pendiente">🟡 Pendiente</option>
                                    <option value="en_proceso">🔵 En Proceso</option>
                                    <option value="completada">🟢 Completada</option>
                                    <option value="cancelada">🔴 Cancelada</option>
                                </select>
                                <span class="form-help">Estado actual de la atención en el sistema</span>
                            </div>

                            <div class="form-group">
                                <label for="observaciones">📝 Observaciones (Opcional)</label>
                                <textarea id="observaciones" name="observaciones" class="form-control" 
                                         placeholder="Observaciones sobre el cambio de estado..." rows="4"></textarea>
                                <span class="form-help">Razón o comentarios sobre el cambio de estado</span>
                            </div>

                            <div class="form-actions">
                                <button type="button" class="btn btn-secondary" onclick="window.location.href='AtencionControlador'">
                                    ❌ Cancelar
                                </button>
                                <button type="reset" class="btn btn-warning">
                                    🔄 Limpiar Formulario
                                </button>
                                <button type="submit" class="btn btn-success pulse" id="submitBtn">
                                    💾 Actualizar Estado
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Información Adicional -->
                <div class="info-card">
                    <div class="info-header">
                        <span>💡 Información sobre Estados de Atención</span>
                    </div>
                    <div class="info-body">
                        <p>Los estados definen el progreso de cada atención en el sistema. Asegúrese de actualizar los estados de manera precisa para mantener un flujo de trabajo eficiente.</p>
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px; margin-top: 20px;">
                            <div class="estado-badge estado-pendiente">
                                🟡 Pendiente
                                <div style="font-size: 0.8em; opacity: 0.8;">Atención en espera de ser iniciada</div>
                            </div>
                            <div class="estado-badge estado-proceso">
                                🔵 En Proceso
                                <div style="font-size: 0.8em; opacity: 0.8;">Atención actualmente en curso</div>
                            </div>
                            <div class="estado-badge estado-completada">
                                🟢 Completada
                                <div style="font-size: 0.8em; opacity: 0.8;">Atención finalizada exitosamente</div>
                            </div>
                            <div class="estado-badge estado-cancelada">
                                🔴 Cancelada
                                <div style="font-size: 0.8em; opacity: 0.8;">Atención cancelada o no realizada</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Animaciones y efectos interactivos
        document.addEventListener('DOMContentLoaded', function() {
            // Efecto de aparición escalonada para los elementos
            const formGroups = document.querySelectorAll('.form-group, .action-card, .estado-item');
            formGroups.forEach((element, index) => {
                element.style.opacity = '0';
                element.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    element.style.transition = 'all 0.6s cubic-bezier(0.4, 0, 0.2, 1)';
                    element.style.opacity = '1';
                    element.style.transform = 'translateY(0)';
                }, index * 100);
            });

            // Efecto hover para botones
            const buttons = document.querySelectorAll('.btn');
            buttons.forEach(button => {
                button.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-3px)';
                });
                button.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                });
            });

            // Validación del formulario
            const form = document.getElementById('estadoForm');
            const submitBtn = document.getElementById('submitBtn');
            
            form.addEventListener('submit', function(e) {
                let isValid = true;
                
                // Validar campos requeridos
                const requiredFields = form.querySelectorAll('[required]');
                requiredFields.forEach(field => {
                    if (!field.value.trim()) {
                        field.style.borderColor = 'var(--danger-color)';
                        field.style.boxShadow = '0 0 0 3px rgba(244, 67, 54, 0.2)';
                        isValid = false;
                    } else {
                        field.style.borderColor = 'var(--success-color)';
                        field.style.boxShadow = '0 0 0 3px rgba(76, 175, 80, 0.2)';
                    }
                });
                
                if (!isValid) {
                    e.preventDefault();
                    showMessage('Por favor, complete todos los campos requeridos.', 'error');
                    return false;
                }
                
                // Mostrar loading
                const originalText = submitBtn.innerHTML;
                submitBtn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Procesando...';
                submitBtn.disabled = true;
                
                setTimeout(() => {
                    submitBtn.innerHTML = originalText;
                    submitBtn.disabled = false;
                }, 3000);
                
                return true;
            });

            // Efectos visuales para el select de estado
            const estadoSelect = document.getElementById('nuevoEstado');
            estadoSelect.addEventListener('change', function() {
                if (this.value) {
                    const estadoColors = {
                        'pendiente': 'var(--warning-color)',
                        'en_proceso': 'var(--info-color)', 
                        'completada': 'var(--success-color)',
                        'cancelada': 'var(--danger-color)'
                    };
                    
                    if (estadoColors[this.value]) {
                        this.style.borderColor = estadoColors[this.value];
                        this.style.boxShadow = `0 0 0 3px ${estadoColors[this.value]}20`;
                    }
                }
            });

            // Mejorar accesibilidad para action cards
            const actionCards = document.querySelectorAll('.action-card');
            actionCards.forEach(card => {
                card.setAttribute('tabindex', '0');
                card.setAttribute('role', 'button');
                
                card.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter' || e.key === ' ') {
                        card.click();
                    }
                });
            });
        });

        // Función para mostrar información de estados
        function mostrarEstados() {
            const info = `
🟡 PENDIENTE: La atención está en espera de ser iniciada
🔵 EN PROCESO: La atención está actualmente en curso  
🟢 COMPLETADA: La atención fue finalizada exitosamente
🔴 CANCELADA: La atención fue cancelada o no realizada
            `;
            alert(info);
        }

        // Función para cargar datos de ejemplo
        function cargarAtencionEjemplo() {
            document.getElementById('idAtencion').value = Math.floor(Math.random() * 1000) + 1;
            document.getElementById('nuevoEstado').value = 'completada';
            document.getElementById('observaciones').value = 'Atención completada exitosamente - ' + new Date().toLocaleString();
            
            // Trigger change event para actualizar estilos
            document.getElementById('nuevoEstado').dispatchEvent(new Event('change'));
            
            // Aplicar estilos de validación
            document.getElementById('idAtencion').style.borderColor = 'var(--success-color)';
            document.getElementById('idAtencion').style.boxShadow = '0 0 0 3px rgba(76, 175, 80, 0.2)';
            
            showMessage('Datos de ejemplo cargados. Puede enviar el formulario o modificarlos según sea necesario.', 'success');
        }

        // Función para mostrar mensajes
        function showMessage(message, type) {
            const existingMessage = document.querySelector('.mensaje.temp');
            if (existingMessage) {
                existingMessage.remove();
            }
            
            const messageDiv = document.createElement('div');
            messageDiv.className = `mensaje  temp`;
            messageDiv.textContent = message;
            messageDiv.style.animation = 'slideInUp 0.6s ease-out';
            
            const mainContent = document.querySelector('.main-content');
            const firstChild = mainContent.firstChild;
            mainContent.insertBefore(messageDiv, firstChild);
            
            setTimeout(() => {
                messageDiv.remove();
            }, 5000);
        }

        // Efecto de confirmación antes de enviar
        document.getElementById('estadoForm').addEventListener('submit', function(e) {
            const idAtencion = document.getElementById('idAtencion').value;
            const nuevoEstado = document.getElementById('nuevoEstado').value;
            const estadoText = document.getElementById('nuevoEstado').options[document.getElementById('nuevoEstado').selectedIndex].text;
            
            if (idAtencion && nuevoEstado) {
                const confirmacion = confirm(`¿Está seguro de que desea actualizar la atención #${idAtencion} al estado: ${estadoText}?`);
                if (!confirmacion) {
                    e.preventDefault();
                    return false;
                }
            }
        });

        // Efectos de hover para elementos interactivos
        const interactiveElements = document.querySelectorAll('.btn, .action-card, .estado-badge, .estado-item');
        interactiveElements.forEach(element => {
            element.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-3px)';
            });
            element.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });
    </script>
</body>
</html>