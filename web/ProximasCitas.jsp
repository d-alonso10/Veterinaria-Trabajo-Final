<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, modelo.CitaProximaDTO"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Próximas Citas - Sistema PetCare</title>
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
            max-width: 1400px;
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

        /* Action Buttons Container */
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        /* Stats Card - Mejorado */
        .stats-card {
            background: var(--white);
            padding: 30px;
            border-radius: var(--radius);
            margin-bottom: 30px;
            box-shadow: var(--shadow);
            border-left: 4px solid var(--primary-color);
            display: flex;
            align-items: center;
            gap: 20px;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out;
        }

        .stats-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-primary);
        }

        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }

        .stats-icon {
            font-size: 2.5em;
            color: var(--primary-color);
        }

        .stats-content h3 {
            color: var(--text-dark);
            margin-bottom: 10px;
            font-size: 1.4em;
            font-weight: 700;
        }

        .stats-content p {
            color: var(--text-light);
            font-size: 1em;
            line-height: 1.6;
        }

        /* Table Container - Mejorado */
        .table-container {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 30px;
            border: 1px solid rgba(0, 0, 0, 0.05);
            position: relative;
            animation: fadeInUp 0.6s ease-out;
        }

        .table-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-primary);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: var(--gradient-primary);
            color: var(--white);
            font-weight: 600;
            padding: 20px;
            text-align: left;
            border-bottom: 2px solid var(--primary-dark);
            position: sticky;
            top: 0;
        }

        td {
            padding: 18px 20px;
            text-align: left;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }

        tr:hover td {
            background-color: rgba(171, 203, 213, 0.05);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        /* Status Badges - Mejorados */
        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 600;
            text-transform: uppercase;
            transition: all 0.3s ease;
        }

        .status-pendiente {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }

        .status-confirmada {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .status-cancelada {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .status-completada {
            background: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }

        /* Modalidad Badge - Mejorado */
        .modalidad-badge {
            padding: 6px 12px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: 600;
            background: #e8f4f8;
            color: var(--text-dark);
            border: 1px solid var(--primary-light);
            transition: all 0.3s ease;
        }

        .modalidad-badge:hover {
            transform: scale(1.05);
        }

        /* Action Buttons - Mejorados */
        .action-buttons-table {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .btn-action {
            padding: 10px 16px;
            font-size: 0.85em;
            border-radius: 10px;
            margin: 2px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            font-weight: 500;
            position: relative;
            overflow: hidden;
        }

        .btn-action::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.6s;
        }

        .btn-action:hover::before {
            left: 100%;
        }

        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        }

        /* Navigation - Mejorado */
        .navigation {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            justify-content: center;
            flex-wrap: wrap;
        }

        /* Empty State - Mejorado */
        .empty-state {
            text-align: center;
            padding: 80px 40px;
            color: var(--text-light);
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            animation: fadeInUp 0.6s ease-out;
            position: relative;
            overflow: hidden;
        }

        .empty-state::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-primary);
        }

        .empty-state h3 {
            font-size: 1.8em;
            margin-bottom: 20px;
            color: var(--text-dark);
            font-weight: 700;
        }

        .empty-state p {
            font-size: 1.1em;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        /* Additional Styling */
        .id-badge {
            background: var(--primary-light);
            color: var(--text-dark);
            padding: 6px 12px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.9em;
            transition: all 0.3s ease;
        }

        .id-badge:hover {
            background: var(--primary-color);
            transform: scale(1.05);
        }

        .no-data {
            color: var(--text-light);
            font-style: italic;
        }

        .table-wrapper {
            overflow-x: auto;
            border-radius: var(--radius);
        }

        /* Search Container - Nuevo para búsqueda */
        .search-container {
            background: var(--white);
            padding: 25px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 25px;
            border-top: 4px solid var(--primary-color);
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out;
        }

        .search-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-primary);
        }

        .search-input {
            width: 100%;
            padding: 16px 20px;
            border: 1px solid #e0e0e0;
            border-radius: var(--radius);
            font-size: 1em;
            transition: all 0.3s ease;
            background-color: #f9f9f9;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.05);
        }

        .search-input:focus {
            outline: none;
            border-color: var(--primary-color);
            background-color: var(--white);
            box-shadow: 0 0 0 3px rgba(171, 203, 213, 0.3), inset 0 2px 4px rgba(0,0,0,0.05);
            transform: translateY(-2px);
        }

        /* Animation Effects - Igual que el dashboard */
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

        /* Responsive Design - Mejorado */
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
            .action-buttons {
                flex-direction: column;
            }
            .table-container {
                overflow-x: auto;
            }
            table {
                min-width: 800px;
            }
            .navigation {
                flex-direction: column;
                align-items: center;
            }
            .btn {
                width: 100%;
                justify-content: center;
            }
            .action-buttons-table {
                flex-direction: column;
                gap: 8px;
            }
            .stats-card {
                flex-direction: column;
                text-align: center;
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
                        <h1>📅 Todas las Próximas Citas</h1>
                        <p>Gestión y administración de todas las citas programadas - <%= new java.text.SimpleDateFormat("EEEE, d 'de' MMMM 'de' yyyy").format(new java.util.Date()) %></p>
                    </div>
                    <div class="header-actions">
                        <a href="Menu.jsp" class="btn btn-secondary">🏠 Menú Principal</a>
                    </div>
                </div>
            </div>

            <div class="main-content">
                <%
                    List<CitaProximaDTO> proximasCitas = (List<CitaProximaDTO>) request.getAttribute("proximasCitas");
                    Integer totalCitas = (Integer) request.getAttribute("totalCitas");
                %>

                <!-- Mensajes -->
                <% String mensaje = (String) request.getAttribute("mensaje"); %>
                <% if (mensaje != null) { %>
                    <div class="mensaje <%= mensaje.contains("✅") ? "exito" : mensaje.contains("❌") ? "error" : "info" %>">
                        <%= mensaje %>
                    </div>
                <% } %>

                <!-- Botones principales -->
                <div class="action-buttons">
                    <a href="CrearCita.jsp" class="btn btn-primary">➕ Crear Nueva Cita</a>
                    <a href="CrearAtencionDesdeCita.jsp" class="btn btn-success">⚡ Crear Atención desde Cita</a>
                </div>

                <!-- Estadísticas -->
                <% if (totalCitas != null) { %>
                    <div class="stats-card floating">
                        <div class="stats-icon">📊</div>
                        <div class="stats-content">
                            <h3>Resumen de Citas</h3>
                            <p><strong>Total de citas programadas:</strong> <%= totalCitas %></p>
                            <p><em>Todas las citas activas en el sistema</em></p>
                        </div>
                    </div>
                <% } %>

                <!-- Búsqueda -->
                <% if (proximasCitas != null && !proximasCitas.isEmpty()) { %>
                    <div class="search-container">
                        <input type="text" id="searchInput" class="search-input" placeholder="🔍 Buscar en citas por mascota, servicio, estado...">
                        <div style="margin-top: 10px; font-size: 0.85em; color: var(--text-light);">
                            Puedes buscar por nombre de mascota, servicio, estado o modalidad
                        </div>
                    </div>
                <% } %>

                <!-- Tabla de próximas citas -->
                <% if (proximasCitas != null && !proximasCitas.isEmpty()) { %>
                    <div class="table-container">
                        <div class="table-wrapper">
                            <table>
                                <thead>
                                    <tr>
                                        <th>ID Cita</th>
                                        <th>Fecha Programada</th>
                                        <th>Mascota</th>
                                        <th>Servicio</th>
                                        <th>Estado</th>
                                        <th>Modalidad</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (CitaProximaDTO cita : proximasCitas) { 
                                        String statusClass = "status-pendiente";
                                        if ("confirmada".equalsIgnoreCase(cita.getEstado())) {
                                            statusClass = "status-confirmada";
                                        } else if ("cancelada".equalsIgnoreCase(cita.getEstado())) {
                                            statusClass = "status-cancelada";
                                        } else if ("completada".equalsIgnoreCase(cita.getEstado())) {
                                            statusClass = "status-completada";
                                        }
                                    %>
                                    <tr>
                                        <td><span class="id-badge"><%= cita.getIdCita() %></span></td>
                                        <td><strong><%= cita.getFechaProgramada() %></strong></td>
                                        <td>
                                            <% if (cita.getMascota() != null && !cita.getMascota().isEmpty()) { %>
                                                🐕 <%= cita.getMascota() %>
                                            <% } else { %>
                                                <span class="no-data">N/A</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <% if (cita.getServicio() != null && !cita.getServicio().isEmpty()) { %>
                                                🛠️ <%= cita.getServicio() %>
                                            <% } else { %>
                                                <span class="no-data">N/A</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <span class="status-badge <%= statusClass %>">
                                                <%= cita.getEstado() %>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="modalidad-badge"><%= cita.getModalidad() %></span>
                                        </td>
                                        <td>
                                            <div class="action-buttons-table">
                                                <!-- Botón Confirmar Asistencia -->
                                                <a href="CitaControlador?accion=confirmarAsistencia&idCita=<%= cita.getIdCita() %>" 
                                                   class="btn-action btn-success"
                                                   onclick="return confirm('¿Confirmar asistencia a esta cita?')"
                                                   title="Confirmar asistencia">
                                                    ✅ Confirmar
                                                </a>
                                                
                                                <!-- Botón Reprogramar -->
                                                <a href="ReprogramarCita.jsp?idCita=<%= cita.getIdCita() %>" 
                                                   class="btn-action btn-warning"
                                                   title="Reprogramar cita">
                                                    📝 Reprogramar
                                                </a>
                                                
                                                <!-- Botón Cancelar -->
                                                <a href="CitaControlador?accion=cancelar&idCita=<%= cita.getIdCita() %>" 
                                                   class="btn-action btn-danger"
                                                   onclick="return confirm('¿Está seguro de cancelar esta cita?')"
                                                   title="Cancelar cita">
                                                    ❌ Cancelar
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                <% } else { %>
                    <div class="empty-state">
                        <h3>📅 No hay citas próximas</h3>
                        <p>No se encontraron citas activas en el sistema.</p>
                        <a href="CrearCita.jsp" class="btn btn-primary">➕ Crear Primera Cita</a>
                    </div>
                <% } %>

                <!-- Navegación -->
                <div class="navigation">
                    <a href="CrearCita.jsp" class="btn btn-primary">➕ Nueva Cita</a>
                    <a href="CrearAtencionDesdeCita.jsp" class="btn btn-success">⚡ Crear Atención</a>
                    <a href="Menu.jsp" class="btn btn-secondary">🏠 Menú Principal</a>
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
            
            // Efecto de carga suave para la tabla
            const tableRows = document.querySelectorAll('tbody tr');
            tableRows.forEach((row, index) => {
                row.style.opacity = '0';
                row.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    row.style.transition = 'all 0.4s ease';
                    row.style.opacity = '1';
                    row.style.transform = 'translateY(0)';
                }, index * 50);
            });

            // Agregar efectos hover a los botones de acción
            const actionButtons = document.querySelectorAll('.btn-action');
            actionButtons.forEach(button => {
                button.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-2px) scale(1.05)';
                });
                button.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0) scale(1)';
                });
            });

            // Función para filtrar citas por estado
            function filtrarCitas(estado) {
                const rows = document.querySelectorAll('tbody tr');
                rows.forEach(row => {
                    const statusBadge = row.querySelector('.status-badge');
                    if (estado === 'todas') {
                        row.style.display = '';
                    } else if (statusBadge.textContent.toLowerCase().includes(estado)) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            }

            // Función para búsqueda en la tabla
            function buscarEnTabla() {
                const input = document.getElementById('searchInput');
                if (!input) return;
                
                const filter = input.value.toLowerCase();
                const rows = document.querySelectorAll('tbody tr');
                
                rows.forEach(row => {
                    const text = row.textContent.toLowerCase();
                    if (text.includes(filter)) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            }

            // Agregar filtros si hay datos
            <% if (proximasCitas != null && !proximasCitas.isEmpty()) { %>
            document.addEventListener('DOMContentLoaded', function() {
                const tableContainer = document.querySelector('.table-container');
                const filterDiv = document.createElement('div');
                filterDiv.style.marginBottom = '15px';
                filterDiv.style.display = 'flex';
                filterDiv.style.gap = '10px';
                filterDiv.style.alignItems = 'center';
                filterDiv.style.flexWrap = 'wrap';
                filterDiv.innerHTML = `
                    <strong>Filtrar por estado:</strong>
                    <button onclick="filtrarCitas('todas')" class="btn btn-small">Todas</button>
                    <button onclick="filtrarCitas('pendiente')" class="btn btn-small">⏳ Pendientes</button>
                    <button onclick="filtrarCitas('confirmada')" class="btn btn-small">✅ Confirmadas</button>
                    <button onclick="filtrarCitas('cancelada')" class="btn btn-small">❌ Canceladas</button>
                    <button onclick="filtrarCitas('completada')" class="btn btn-small">🎯 Completadas</button>
                `;
                tableContainer.parentNode.insertBefore(filterDiv, tableContainer);

                // Configurar búsqueda
                const searchInput = document.getElementById('searchInput');
                if (searchInput) {
                    searchInput.addEventListener('input', buscarEnTabla);
                }
            });
            <% } %>
            
            // Animaciones de entrada para elementos
            const animatedElements = document.querySelectorAll('.action-buttons, .stats-card, .search-container, .table-container, .empty-state');
            animatedElements.forEach((element, index) => {
                if (element) {
                    element.style.opacity = '0';
                    element.style.transform = 'translateY(30px)';
                    
                    setTimeout(() => {
                        element.style.transition = 'all 0.6s cubic-bezier(0.4, 0, 0.2, 1)';
                        element.style.opacity = '1';
                        element.style.transform = 'translateY(0)';
                    }, index * 100);
                }
            });

            // Efecto hover para botones principales
            const buttons = document.querySelectorAll('.btn');
            buttons.forEach(button => {
                button.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-3px)';
                });
                button.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                });
            });
        });

        // Función para mostrar loading en botones de acción
        function showLoading(button) {
            const originalText = button.innerHTML;
            button.innerHTML = '<span style="display:inline-flex;gap:4px;"><span style="width:6px;height:6px;border-radius:50%;background:currentColor;animation:pulse 1.4s infinite ease-in-out"></span><span style="width:6px;height:6px;border-radius:50%;background:currentColor;animation:pulse 1.4s infinite ease-in-out;animation-delay:0.2s"></span><span style="width:6px;height:6px;border-radius:50%;background:currentColor;animation:pulse 1.4s infinite ease-in-out;animation-delay:0.4s"></span></span> Procesando...';
            button.disabled = true;
            
            setTimeout(() => {
                button.innerHTML = originalText;
                button.disabled = false;
            }, 2000);
        }

        // Agregar evento de loading a los botones de acción
        const actionButtons = document.querySelectorAll('.btn-action');
        actionButtons.forEach(button => {
            button.addEventListener('click', function(e) {
                if (this.href && !this.href.includes('javascript:')) {
                    showLoading(this);
                }
            });
        });
    </script>
</body>
</html>