<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Cita - Sistema PetCare</title>
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

        /* Sidebar Styles - Manteniendo el diseño del dashboard */
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

        /* Botones - Usando el mismo estilo del dashboard */
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
            font-size: 0.85em;
        }

        .btn-back {
            background: #6c757d;
            color: var(--white);
            padding: 14px 24px;
            font-size: 0.9em;
        }

        .btn-back:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        /* Mensajes de estado - Mejorados */
        .mensaje {
            padding: 20px 25px;
            margin: 0 0 30px 0;
            border-radius: var(--radius);
            font-size: 1em;
            box-shadow: var(--shadow);
            border-left: 4px solid;
            animation: fadeInUp 0.6s ease-out;
            position: relative;
            overflow: hidden;
        }

        .mensaje::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            opacity: 0;
            transition: opacity 0.3s;
        }

        .mensaje:hover::before {
            opacity: 1;
        }

        .exito {
            background-color: #f0f9f4;
            border-left-color: var(--success-color);
            color: #1e7e34;
        }

        .error {
            background-color: #fdf2f2;
            border-left-color: var(--danger-color);
            color: #c53030;
        }

        .info {
            background-color: #f0f7ff;
            border-left-color: var(--info-color);
            color: var(--text-dark);
        }

        /* Form Container - Mejorado */
        .form-container {
            background: var(--white);
            padding: 40px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            border-top: 4px solid var(--primary-color);
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out;
        }

        .form-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-primary);
        }

        .form-title {
            color: var(--text-dark);
            margin-bottom: 30px;
            font-size: 1.8em;
            font-weight: 700;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 25px;
        }

        .form-group {
            margin-bottom: 25px;
            transition: all 0.3s ease;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
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

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 16px 20px;
            border: 2px solid #e9ecef;
            border-radius: var(--radius);
            font-size: 1em;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            background-color: #f8f9fa;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.05);
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--primary-color);
            background-color: var(--white);
            box-shadow: 0 0 0 3px rgba(171, 203, 213, 0.3), inset 0 2px 4px rgba(0,0,0,0.05);
            transform: translateY(-2px);
        }

        .form-group input:required,
        .form-group select:required {
            border-left: 4px solid var(--primary-color);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 120px;
            font-family: inherit;
            line-height: 1.5;
        }

        .form-actions {
            display: flex;
            gap: 20px;
            margin-top: 40px;
            justify-content: center;
        }

        /* Navigation */
        .navigation {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            justify-content: center;
            flex-wrap: wrap;
        }

        /* Field Info */
        .field-info {
            font-size: 0.85em;
            color: var(--text-light);
            margin-top: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }

        .required-mark {
            color: var(--danger-color);
            font-weight: bold;
        }

        /* Form Sections */
        .form-section {
            margin-bottom: 35px;
            padding-bottom: 25px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        .section-title {
            color: var(--text-dark);
            margin-bottom: 20px;
            font-size: 1.3em;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 0;
            border-bottom: 2px solid var(--primary-light);
        }

        /* Quick Help - Mejorado */
        .quick-help {
            background: linear-gradient(135deg, #f8f9fa 0%, var(--primary-light) 100%);
            padding: 25px;
            border-radius: var(--radius);
            margin-bottom: 30px;
            border-left: 4px solid var(--info-color);
            box-shadow: var(--shadow);
            animation: fadeInUp 0.6s ease-out;
            position: relative;
            overflow: hidden;
        }

        .quick-help::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-primary);
        }

        .quick-help h4 {
            color: var(--text-dark);
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 1.2em;
            font-weight: 600;
        }

        .quick-help ul {
            list-style: none;
            padding-left: 0;
        }

        .quick-help li {
            padding: 8px 0;
            display: flex;
            align-items: center;
            gap: 12px;
            color: var(--text-dark);
            font-size: 0.95em;
            transition: all 0.3s ease;
        }

        .quick-help li:hover {
            transform: translateX(5px);
            color: var(--primary-dark);
        }

        /* Character Counter */
        .char-counter {
            font-size: 0.8em;
            color: var(--text-light);
            text-align: right;
            margin-top: 8px;
            transition: all 0.3s ease;
        }

        .char-counter.warning {
            color: var(--warning-color);
        }

        .char-counter.danger {
            color: var(--danger-color);
            font-weight: 600;
        }

        /* Custom Select Styling */
        .form-group select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%235d6d7e' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 20px center;
            background-size: 14px;
            padding-right: 50px;
            cursor: pointer;
        }

        /* Search Button */
        .search-btn {
            padding: 10px 16px;
            font-size: 0.85em;
            border-radius: 10px;
            background: var(--info-color);
            color: var(--white);
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 8px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .search-btn:hover {
            background: #0b7dda;
            transform: translateY(-2px);
        }

        /* Animation Effects */
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
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        .pulse {
            animation: pulse 2s infinite;
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
            .form-container {
                padding: 25px;
            }
            .form-grid {
                grid-template-columns: 1fr;
            }
            .form-actions {
                flex-direction: column;
            }
            .btn {
                width: 100%;
                justify-content: center;
            }
        }

        @media (max-width: 480px) {
            .header {
                padding: 20px;
            }
            .main-content {
                padding: 15px;
            }
            .form-container {
                padding: 20px;
            }
            .form-title {
                font-size: 1.5em;
            }
            .section-title {
                font-size: 1.1em;
            }
        }

        /* Loading animation */
        .loading-dots {
            display: inline-flex;
            gap: 4px;
        }

        .loading-dots span {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: currentColor;
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
        <!-- Sidebar Menu - Actualizado para coincidir con el dashboard -->
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
                        <h1>➕ Crear Nueva Cita</h1>
                        <p>Programe una nueva cita para sus clientes y mascotas - <%= new java.text.SimpleDateFormat("EEEE, d 'de' MMMM 'de' yyyy").format(new java.util.Date()) %></p>
                    </div>
                    <div class="header-actions">
                        <a href="CitaControlador?accion=todasCitas" class="btn btn-back">← Volver a Citas</a>
                    </div>
                </div>
            </div>

            <div class="main-content">
                <!-- Mostrar mensajes -->
                <% String mensaje = (String) request.getAttribute("mensaje"); %>
                <% if (mensaje != null) { %>
                    <div class="mensaje <%= mensaje.contains("✅") ? "exito" : "error" %>">
                        <strong><%= mensaje.contains("✅") ? "✅ Éxito:" : "❌ Error:" %></strong> <%= mensaje %>
                    </div>
                <% } %>

                <!-- Ayuda rápida -->
                <div class="quick-help">
                    <h4>💡 Información Importante</h4>
                    <ul>
                        <li>✅ <strong>ID Mascota y Cliente</strong> son campos obligatorios</li>
                        <li>📅 <strong>Fecha Programada</strong> debe ser una fecha futura</li>
                        <li>🏢 <strong>Sucursal y Servicio</strong> son opcionales pero recomendados</li>
                        <li>🗒️ <strong>Notas</strong> pueden incluir observaciones especiales</li>
                    </ul>
                </div>
                
                <div class="form-container">
                    <div class="form-title">
                        <span>📅 Información de la Cita</span>
                    </div>
                    
                    <form action="CitaControlador" method="POST" id="citaForm">
                        <div class="form-section">
                            <h3 class="section-title">🆔 Identificación</h3>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="idMascota">
                                        <span>🐕 ID Mascota</span>
                                        <span class="required-mark">*</span>
                                    </label>
                                    <input type="number" id="idMascota" name="idMascota" required 
                                           placeholder="Ingrese el ID de la mascota"
                                           min="1">
                                    <div class="field-info">🔍 Identificación única de la mascota</div>
                                    <button type="button" class="search-btn" onclick="buscarInfoMascota()">
                                        🔍 Buscar Mascota
                                    </button>
                                </div>
                                
                                <div class="form-group">
                                    <label for="idCliente">
                                        <span>👤 ID Cliente</span>
                                        <span class="required-mark">*</span>
                                    </label>
                                    <input type="number" id="idCliente" name="idCliente" required 
                                           placeholder="Ingrese el ID del cliente"
                                           min="1">
                                    <div class="field-info">🔍 Identificación única del cliente propietario</div>
                                    <button type="button" class="search-btn" onclick="buscarInfoCliente()">
                                        🔍 Buscar Cliente
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <h3 class="section-title">🏢 Detalles del Servicio</h3>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="idSucursal">
                                        <span>🏢 ID Sucursal</span>
                                    </label>
                                    <input type="number" id="idSucursal" name="idSucursal" 
                                           placeholder="Ingrese el ID de la sucursal"
                                           min="1">
                                    <div class="field-info">📍 Sucursal donde se realizará el servicio (opcional)</div>
                                </div>
                                
                                <div class="form-group">
                                    <label for="idServicio">
                                        <span>🛠️ ID Servicio</span>
                                    </label>
                                    <input type="number" id="idServicio" name="idServicio" 
                                           placeholder="Ingrese el ID del servicio"
                                           min="1">
                                    <div class="field-info">⚡ Tipo de servicio a realizar (opcional)</div>
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <h3 class="section-title">📅 Programación</h3>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="fechaProgramada">
                                        <span>📅 Fecha Programada</span>
                                        <span class="required-mark">*</span>
                                    </label>
                                    <input type="datetime-local" id="fechaProgramada" name="fechaProgramada" required
                                           min="<%= java.time.LocalDateTime.now().toString().substring(0,16) %>">
                                    <div class="field-info">⏰ Fecha y hora programada para la cita</div>
                                </div>
                                
                                <div class="form-group">
                                    <label for="modalidad">
                                        <span>🌐 Modalidad</span>
                                    </label>
                                    <select id="modalidad" name="modalidad">
                                        <option value="">Seleccione modalidad</option>
                                        <option value="presencial">🏢 Presencial</option>
                                        <option value="virtual">💻 Virtual</option>
                                    </select>
                                    <div class="field-info">🎯 Modalidad de atención (presencial o virtual)</div>
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <h3 class="section-title">🗒️ Información Adicional</h3>
                            <div class="form-group full-width">
                                <label for="notas">
                                    <span>📝 Notas y Observaciones</span>
                                </label>
                                <textarea id="notas" name="notas" 
                                          placeholder="Ingrese observaciones importantes sobre la cita: preferencias especiales, comportamientos de la mascota, alergias, etc."
                                          maxlength="500"></textarea>
                                <div class="char-counter" id="charCounter"><span id="charCount">0</span>/500 caracteres</div>
                                <div class="field-info">💡 Información adicional relevante para la cita</div>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" name="acc" value="Confirmar" class="btn btn-primary" id="submitBtn">
                                ✅ Confirmar y Programar Cita
                            </button>
                            <button type="reset" class="btn btn-secondary" id="resetBtn">
                                🗑️ Limpiar Formulario
                            </button>
                        </div>
                    </form>
                </div>

                <div class="navigation">
                    <a href="CitaControlador?accion=todasCitas" class="btn btn-back">📅 Ver Todas las Citas</a>
                    <a href="Clientes.jsp" class="btn btn-back">👥 Buscar Clientes</a>
                    <a href="ListaMascotas.jsp" class="btn btn-back">🐾 Buscar Mascotas</a>
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

            // Validación en tiempo real del formulario
            const form = document.getElementById('citaForm');
            const inputs = form.querySelectorAll('input[required], select[required]');
            
            inputs.forEach(input => {
                input.addEventListener('blur', function() {
                    validateField(this);
                });
                
                input.addEventListener('input', function() {
                    if (this.value.trim() !== '') {
                        this.style.borderColor = 'var(--primary-color)';
                        this.style.backgroundColor = 'var(--white)';
                        this.parentElement.style.transform = 'translateY(0)';
                    }
                });

                input.addEventListener('focus', function() {
                    this.parentElement.style.transform = 'translateY(-2px)';
                });
                
                input.addEventListener('blur', function() {
                    this.parentElement.style.transform = 'translateY(0)';
                });
            });

            // Contador de caracteres para notas
            const notasTextarea = document.getElementById('notas');
            const charCount = document.getElementById('charCount');
            const charCounter = document.getElementById('charCounter');
            
            if (notasTextarea && charCount && charCounter) {
                notasTextarea.addEventListener('input', function() {
                    const length = this.value.length;
                    charCount.textContent = length;
                    
                    if (length > 450) {
                        charCounter.className = 'char-counter warning';
                    } else if (length > 490) {
                        charCounter.className = 'char-counter danger';
                    } else {
                        charCounter.className = 'char-counter';
                    }
                });
                
                // Inicializar contador
                charCount.textContent = notasTextarea.value.length;
            }

            // Focus en el primer campo al cargar la página
            const firstInput = document.getElementById('idMascota');
            if (firstInput) {
                setTimeout(() => {
                    firstInput.focus();
                }, 500);
            }

            // Confirmación antes de limpiar el formulario
            const resetButton = document.getElementById('resetBtn');
            if (resetButton) {
                resetButton.addEventListener('click', function(e) {
                    const hasData = Array.from(inputs).some(input => input.value.trim() !== '') || 
                                   notasTextarea.value.trim() !== '';
                    if (hasData && !confirm('¿Está seguro de que desea limpiar todos los campos del formulario?')) {
                        e.preventDefault();
                    }
                });
            }

            // Validación de números positivos
            const numberInputs = form.querySelectorAll('input[type="number"]');
            numberInputs.forEach(input => {
                input.addEventListener('input', function() {
                    if (this.value < 0) {
                        this.value = Math.abs(this.value);
                    }
                });
            });

            // Establecer fecha mínima como hoy y valor por defecto
            const fechaInput = document.getElementById('fechaProgramada');
            if (fechaInput) {
                const now = new Date();
                const localDateTime = now.toISOString().slice(0, 16);
                fechaInput.min = localDateTime;
                
                // Si no hay valor, establecer uno por defecto (mañana a las 9 AM)
                if (!fechaInput.value) {
                    const tomorrow = new Date(now);
                    tomorrow.setDate(tomorrow.getDate() + 1);
                    tomorrow.setHours(9, 0, 0, 0);
                    fechaInput.value = tomorrow.toISOString().slice(0, 16);
                }
            }

            // Efectos visuales para campos con foco
            const formElements = form.querySelectorAll('input, select, textarea');
            formElements.forEach(element => {
                element.addEventListener('focus', function() {
                    this.parentElement.style.transform = 'translateY(-2px)';
                });
                
                element.addEventListener('blur', function() {
                    this.parentElement.style.transform = 'translateY(0)';
                });
            });

            // Animaciones de entrada para elementos
            const animatedElements = document.querySelectorAll('.quick-help, .form-container');
            animatedElements.forEach((element, index) => {
                element.style.opacity = '0';
                element.style.transform = 'translateY(30px)';
                
                setTimeout(() => {
                    element.style.transition = 'all 0.6s cubic-bezier(0.4, 0, 0.2, 1)';
                    element.style.opacity = '1';
                    element.style.transform = 'translateY(0)';
                }, index * 100);
            });

            // Efecto hover para botones
            const buttons = document.querySelectorAll('.btn, .search-btn');
            buttons.forEach(button => {
                button.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-2px)';
                });
                button.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                });
            });
        });

        // Función para validar campos individuales
        function validateField(field) {
            if (field.value.trim() === '') {
                field.style.borderColor = 'var(--danger-color)';
                field.style.backgroundColor = '#fdf2f2';
                return false;
            } else {
                field.style.borderColor = 'var(--success-color)';
                field.style.backgroundColor = '#f0f9f4';
                return true;
            }
        }

        // Función para validar el formulario antes de enviar
        function validarFormulario() {
            const idMascota = document.getElementById('idMascota');
            const idCliente = document.getElementById('idCliente');
            const fechaProgramada = document.getElementById('fechaProgramada');
            
            let isValid = true;
            
            if (!validateField(idMascota)) isValid = false;
            if (!validateField(idCliente)) isValid = false;
            if (!validateField(fechaProgramada)) isValid = false;
            
            if (idMascota.value < 1 || idCliente.value < 1) {
                alert('Los IDs deben ser números positivos');
                isValid = false;
            }
            
            const fechaSeleccionada = new Date(fechaProgramada.value);
            const ahora = new Date();
            
            if (fechaSeleccionada <= ahora) {
                alert('La fecha programada debe ser una fecha futura');
                fechaProgramada.style.borderColor = 'var(--danger-color)';
                isValid = false;
            }
            
            return isValid;
        }

        // Agregar validación al enviar el formulario
        document.getElementById('citaForm').addEventListener('submit', function(e) {
            if (!validarFormulario()) {
                e.preventDefault();
            } else {
                // Mostrar loading en el botón de enviar
                const submitBtn = document.getElementById('submitBtn');
                const originalText = submitBtn.innerHTML;
                submitBtn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Procesando...';
                submitBtn.disabled = true;
                
                // Re-enable after 3 seconds (in case of error)
                setTimeout(() => {
                    submitBtn.innerHTML = originalText;
                    submitBtn.disabled = false;
                }, 3000);
            }
        });

        // Función para buscar información de mascota
        function buscarInfoMascota() {
            const idMascota = document.getElementById('idMascota').value;
            if (idMascota) {
                // Simular búsqueda con efecto visual
                const button = event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Buscando...';
                button.disabled = true;
                
                setTimeout(() => {
                    button.innerHTML = originalText;
                    button.disabled = false;
                    
                    // En un sistema real, aquí harías una consulta AJAX
                    // Por ahora mostramos un mensaje simulado
                    alert(`🔍 Buscando información de la mascota ID: ${idMascota}\n\nEn un sistema real, esto cargaría automáticamente los datos de la mascota y podría autocompletar el ID del cliente.`);
                    
                    // Simular autocompletado del ID Cliente
                    if (idMascota && !document.getElementById('idCliente').value) {
                        document.getElementById('idCliente').value = parseInt(idMascota) + 1000;
                        validateField(document.getElementById('idCliente'));
                    }
                }, 1500);
            } else {
                alert('Por favor ingrese un ID de mascota para buscar');
                document.getElementById('idMascota').focus();
            }
        }

        // Función para buscar información de cliente
        function buscarInfoCliente() {
            const idCliente = document.getElementById('idCliente').value;
            if (idCliente) {
                // Simular búsqueda con efecto visual
                const button = event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Buscando...';
                button.disabled = true;
                
                setTimeout(() => {
                    button.innerHTML = originalText;
                    button.disabled = false;
                    
                    // En un sistema real, aquí harías una consulta AJAX
                    alert(`🔍 Buscando información del cliente ID: ${idCliente}\n\nEn un sistema real, esto cargaría automáticamente los datos del cliente y sus mascotas.`);
                }, 1500);
            } else {
                alert('Por favor ingrese un ID de cliente para buscar');
                document.getElementById('idCliente').focus();
            }
        }

        // Función para formatear fecha
        function formatDate(date) {
            return new Date(date).toLocaleDateString('es-ES', {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            });
        }

        // Mostrar preview de la cita al cambiar la fecha
        document.getElementById('fechaProgramada').addEventListener('change', function() {
            const fecha = this.value;
            if (fecha) {
                console.log('Cita programada para:', formatDate(fecha));
            }
        });
    </script>
</body>
</html>