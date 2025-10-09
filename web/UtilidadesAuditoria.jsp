<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, modelo.AuditLog"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logs de Auditoría - Sistema PetCare</title>
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
            max-width: 1400px;
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

        .stat-card.insert::before {
            background: var(--gradient-success);
        }

        .stat-card.update::before {
            background: var(--gradient-warning);
        }

        .stat-card.delete::before {
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

        /* Filtros Container */
        .filters-container {
            background: var(--white);
            padding: 25px;
            border-radius: var(--radius);
            margin-bottom: 30px;
            box-shadow: var(--shadow);
            border-top: 4px solid var(--primary-color);
            animation: fadeInUp 0.6s ease-out;
        }

        .filters-form {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            align-items: end;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .filter-label {
            font-weight: 600;
            color: var(--text-dark);
            font-size: 0.95em;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .filter-label-icon {
            font-size: 1.2em;
        }

        .filter-input, .filter-select {
            padding: 14px 16px;
            border: 2px solid #e0e0e0;
            border-radius: var(--radius);
            font-size: 1em;
            background: #f9f9f9;
            transition: all 0.3s ease;
            font-family: inherit;
        }

        .filter-input:focus, .filter-select:focus {
            outline: none;
            border-color: var(--primary-color);
            background: var(--white);
            box-shadow: 0 0 0 4px rgba(171, 203, 213, 0.2);
        }

        .filter-actions {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        /* Table Container Mejorado */
        .table-container {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            margin: 30px 0;
            border: 1px solid rgba(0, 0, 0, 0.05);
            animation: fadeInUp 0.8s ease-out;
        }

        .table-wrapper {
            overflow-x: auto;
            border-radius: var(--radius);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1000px;
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
            font-size: 0.95em;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        td {
            padding: 18px 20px;
            text-align: left;
            border-bottom: 1px solid rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            font-size: 0.95em;
        }

        tr {
            transition: all 0.3s ease;
        }

        tr:hover td {
            background-color: rgba(171, 203, 213, 0.05);
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        /* Badges y Estados Mejorados */
        .badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.85em;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .badge-success {
            background: linear-gradient(135deg, #e8f6ef 0%, #d1f2eb 100%);
            color: #1e8449;
            border: 1px solid #a3e4d7;
        }

        .badge-warning {
            background: linear-gradient(135deg, #fff8e1 0%, #ffecb3 100%);
            color: #b7950b;
            border: 1px solid #ffd54f;
        }

        .badge-danger {
            background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%);
            color: #c62828;
            border: 1px solid #ef9a9a;
        }

        .badge-info {
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            color: #1565c0;
            border: 1px solid #90caf9;
        }

        .log-id {
            background: var(--primary-light);
            color: var(--text-dark);
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.85em;
            border: 1px solid var(--primary-color);
        }

        .entity-badge {
            background: linear-gradient(135deg, #e8f4f8 0%, #d4eaf0 100%);
            color: var(--text-dark);
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: 600;
            border: 1px solid var(--primary-light);
        }

        .timestamp {
            font-family: 'Courier New', monospace;
            font-size: 0.9em;
            color: var(--text-light);
        }

        .json-data {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 12px;
            font-family: 'Courier New', monospace;
            font-size: 0.85em;
            max-height: 80px;
            overflow-y: auto;
            color: var(--text-dark);
            line-height: 1.4;
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

        /* Export Section */
        .export-section {
            background: var(--white);
            padding: 25px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-top: 30px;
            text-align: center;
            animation: fadeInUp 0.8s ease-out;
        }

        .export-section h3 {
            color: var(--text-dark);
            margin-bottom: 15px;
            font-size: 1.3em;
            font-weight: 600;
        }

        .export-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn-export {
            background: linear-gradient(135deg, #9b59b6 0%, #8e44ad 100%);
            color: white;
            box-shadow: 0 8px 25px rgba(155, 89, 182, 0.3);
        }

        .btn-export:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(155, 89, 182, 0.4);
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
            .filters-form {
                grid-template-columns: 1fr;
            }
            .stats-container {
                grid-template-columns: repeat(2, 1fr);
            }
            .export-actions {
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
                <li class="menu-item active">
                    <a href="auditoria.jsp">
                        <span class="menu-icon">🔍</span>
                        <span>Auditoria</span>
                    </a>
                </li>
                
                <!-- Sistema -->
                <div class="menu-section">Sistema</div>
                <li class="menu-item">
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
                        <h1>🔍 Logs de Auditoría</h1>
                        <p>Registro completo de actividades y cambios en el sistema</p>
                    </div>
                    <div class="header-actions">
                        <a href="UtilidadesControlador" class="btn btn-secondary">
                            <span>🔧 Volver al Panel</span>
                        </a>
                        <a href="dashboard.jsp" class="btn btn-primary">
                            <span>📊 Ir al Dashboard</span>
                        </a>
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

                <!-- Estadísticas de Auditoría -->
                <%
                    List<AuditLog> logs = (List<AuditLog>) request.getAttribute("logs");
                    Integer totalLogs = (Integer) request.getAttribute("totalLogs");
                    int insertCount = 0;
                    int updateCount = 0;
                    int deleteCount = 0;
                    
                    if (logs != null) {
                        for (AuditLog log : logs) {
                            if (log.getAccion() != null) {
                                String accion = log.getAccion().toLowerCase();
                                if (accion.contains("insert")) insertCount++;
                                else if (accion.contains("update")) updateCount++;
                                else if (accion.contains("delete")) deleteCount++;
                            }
                        }
                    }
                %>

                <div class="stats-container">
                    <div class="stat-card total">
                        <span class="stat-icon">📋</span>
                        <div class="stat-number" id="totalLogs"><%= totalLogs != null ? totalLogs : 0 %></div>
                        <div class="stat-label">Total de Registros</div>
                    </div>
                    <div class="stat-card insert">
                        <span class="stat-icon">➕</span>
                        <div class="stat-number" id="insertCount"><%= insertCount %></div>
                        <div class="stat-label">Inserciones</div>
                    </div>
                    <div class="stat-card update">
                        <span class="stat-icon">✏️</span>
                        <div class="stat-number" id="updateCount"><%= updateCount %></div>
                        <div class="stat-label">Actualizaciones</div>
                    </div>
                    <div class="stat-card delete">
                        <span class="stat-icon">🗑️</span>
                        <div class="stat-number" id="deleteCount"><%= deleteCount %></div>
                        <div class="stat-label">Eliminaciones</div>
                    </div>
                </div>

                <!-- Filtros Mejorados -->
                <div class="filters-container">
                    <form action="UtilidadesControlador" method="get" class="filters-form" id="filtersForm">
                        <input type="hidden" name="accion" value="auditoria">

                        <div class="filter-group">
                            <label class="filter-label">
                                <span class="filter-label-icon">📅</span>
                                Últimos días
                            </label>
                            <input type="number" name="dias" value="<%= request.getAttribute("diasConsulta") != null ? request.getAttribute("diasConsulta") : 7 %>" 
                                   min="1" max="365" class="filter-input" required>
                        </div>

                        <div class="filter-group">
                            <label class="filter-label">
                                <span class="filter-label-icon">🏷️</span>
                                Tipo de Acción
                            </label>
                            <select name="tipoAccion" class="filter-select">
                                <option value="">Todas las acciones</option>
                                <option value="INSERT">INSERT</option>
                                <option value="UPDATE">UPDATE</option>
                                <option value="DELETE">DELETE</option>
                            </select>
                        </div>

                        <div class="filter-group">
                            <label class="filter-label">
                                <span class="filter-label-icon">📊</span>
                                Entidad
                            </label>
                            <input type="text" name="entidad" placeholder="Ej: cliente, mascota, cita..." 
                                   class="filter-input">
                        </div>

                        <div class="filter-actions">
                            <button type="submit" class="btn btn-success">
                                <span>🔍 Aplicar Filtros</span>
                            </button>
                            <a href="UtilidadesControlador?accion=auditoria" class="btn btn-secondary">
                                <span>🔄 Limpiar Filtros</span>
                            </a>
                        </div>
                    </form>
                </div>

                <!-- Tabla de Logs Mejorada -->
                <% if (logs != null && !logs.isEmpty()) { %>
                    <div class="table-container">
                        <div class="table-wrapper">
                            <table>
                                <thead>
                                    <tr>
                                        <th>ID Log</th>
                                        <th>Timestamp</th>
                                        <th>Entidad</th>
                                        <th>ID Entidad</th>
                                        <th>Acción</th>
                                        <th>Usuario</th>
                                        <th>Detalles</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (AuditLog log : logs) { 
                                        String badgeClass = "badge-info";
                                        if (log.getAccion() != null) {
                                            String accion = log.getAccion().toLowerCase();
                                            if (accion.contains("insert")) badgeClass = "badge-success";
                                            else if (accion.contains("update")) badgeClass = "badge-warning";
                                            else if (accion.contains("delete")) badgeClass = "badge-danger";
                                        }
                                    %>
                                        <tr class="fade-in-row">
                                            <td>
                                                <span class="log-id">#<%= log.getIdLog() %></span>
                                            </td>
                                            <td>
                                                <span class="timestamp"><%= log.getTimestamp() != null ? log.getTimestamp().toString() : "N/A" %></span>
                                            </td>
                                            <td>
                                                <span class="entity-badge"><%= log.getEntidad() != null ? log.getEntidad() : "N/A" %></span>
                                            </td>
                                            <td>
                                                <span class="badge badge-info"><%= log.getEntidadId() %></span>
                                            </td>
                                            <td>
                                                <span class="badge <%= badgeClass %>">
                                                    <%= log.getAccion() != null ? log.getAccion() : "N/A" %>
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge badge-info">ID: <%= log.getIdUsuario() %></span>
                                            </td>
                                            <td style="min-width: 300px;">
                                                <div style="display: flex; flex-direction: column; gap: 8px;">
                                                    <% if (log.getAntes() != null && !log.getAntes().isEmpty()) { %>
                                                        <div>
                                                            <strong>📝 Antes:</strong>
                                                            <div class="json-data" title="<%= log.getAntes() %>">
                                                                <%= log.getAntes().length() > 100 ? log.getAntes().substring(0, 100) + "..." : log.getAntes() %>
                                                            </div>
                                                        </div>
                                                    <% } %>
                                                    <% if (log.getDespues() != null && !log.getDespues().isEmpty()) { %>
                                                        <div>
                                                            <strong>✅ Después:</strong>
                                                            <div class="json-data" title="<%= log.getDespues() %>">
                                                                <%= log.getDespues().length() > 100 ? log.getDespues().substring(0, 100) + "..." : log.getDespues() %>
                                                            </div>
                                                        </div>
                                                    <% } %>
                                                </div>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Resumen del Reporte -->
                    <div class="info" style="margin: 20px 0; padding: 15px 25px;">
                        <strong>📋 Resumen del Período:</strong> 
                        <strong><%= logs.size() %></strong> registros encontrados | 
                        <strong><%= insertCount %></strong> inserciones | 
                        <strong><%= updateCount %></strong> actualizaciones | 
                        <strong><%= deleteCount %></strong> eliminaciones
                    </div>

                <% } else { %>
                    <div class="empty-state">
                        <span class="empty-state-icon">📋</span>
                        <h3>No se encontraron logs de auditoría</h3>
                        <p>
                            No hay registros de auditoría para el período seleccionado. 
                            Los logs aparecerán aquí cuando se realicen operaciones en el sistema.
                        </p>
                        <div style="display: flex; gap: 15px; justify-content: center; margin-top: 20px;">
                            <button onclick="document.querySelector('input[name=\"dias\"]').focus()" class="btn btn-primary">
                                <span>📅 Cambiar Período</span>
                            </button>
                            <a href="UtilidadesControlador?accion=auditoria&dias=30" class="btn btn-success">
                                <span>🔄 Últimos 30 días</span>
                            </a>
                        </div>
                    </div>
                <% } %>

                <!-- Sección de Exportación -->
                <div class="export-section">
                    <h3>📤 Exportar Logs de Auditoría</h3>
                    <p>Descarga el registro completo de auditoría en diferentes formatos para su análisis externo o respaldo.</p>
                    <div class="export-actions">
                        <button onclick="exportarPDF()" class="btn btn-export">
                            <span>📄 Exportar PDF</span>
                        </button>
                        <button onclick="exportarExcel()" class="btn btn-success">
                            <span>📊 Exportar Excel</span>
                        </button>
                        <button onclick="exportarCSV()" class="btn btn-primary">
                            <span>📝 Exportar CSV</span>
                        </button>
                    </div>
                </div>

                <!-- Navegación -->
                <div style="display: flex; gap: 15px; margin-top: 40px; justify-content: center; flex-wrap: wrap;">
                    <a href="UtilidadesControlador" class="btn btn-secondary">
                        <span>🔧 Panel de Utilidades</span>
                    </a>
                    <a href="auditoria.jsp" class="btn btn-primary">
                        <span>🔍 Auditoría Completa</span>
                    </a>
                    <a href="dashboard.jsp" class="btn btn-success">
                        <span>📊 Dashboard Principal</span>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Script mejorado para logs de auditoría
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
                const totalElement = document.getElementById('totalLogs');
                const insertElement = document.getElementById('insertCount');
                const updateElement = document.getElementById('updateCount');
                const deleteElement = document.getElementById('deleteCount');
                
                if (totalElement) animateCounter(totalElement, <%= totalLogs != null ? totalLogs : 0 %>);
                if (insertElement) animateCounter(insertElement, <%= insertCount %>);
                if (updateElement) animateCounter(updateElement, <%= updateCount %>);
                if (deleteElement) animateCounter(deleteElement, <%= deleteCount %>);
            }, 500);

            // Efectos de hover para las filas de la tabla
            const tableRows = document.querySelectorAll('tbody tr');
            tableRows.forEach((row, index) => {
                row.style.animationDelay = (index * 0.1) + 's';
            });

            // Expandir/contraer datos JSON al hacer clic
            const jsonDataElements = document.querySelectorAll('.json-data');
            jsonDataElements.forEach(element => {
                const fullText = element.getAttribute('title');
                if (fullText && fullText.length > 100) {
                    element.style.cursor = 'pointer';
                    element.addEventListener('click', function() {
                        if (this.style.maxHeight && this.style.maxHeight !== '80px') {
                            this.style.maxHeight = '80px';
                            this.textContent = fullText.substring(0, 100) + '...';
                        } else {
                            this.style.maxHeight = 'none';
                            this.textContent = fullText;
                        }
                    });
                }
            });

            // Auto-enfoque en el campo de días
            setTimeout(() => {
                document.querySelector('input[name="dias"]').focus();
            }, 1000);
        });

        // Funciones de exportación
        function exportarPDF() {
            const total = <%= totalLogs != null ? totalLogs : 0 %>;
            if (total === 0) {
                alert('No hay datos para exportar.');
                return;
            }

            const btn = event.target;
            const originalText = btn.innerHTML;
            btn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Generando PDF...';
            
            setTimeout(() => {
                btn.innerHTML = originalText;
                alert(`✅ Reporte PDF de ${total} logs generado correctamente`);
                // En una implementación real, aquí se descargaría el PDF
            }, 2000);
        }

        function exportarExcel() {
            const total = <%= totalLogs != null ? totalLogs : 0 %>;
            if (total === 0) {
                alert('No hay datos para exportar.');
                return;
            }

            const btn = event.target;
            const originalText = btn.innerHTML;
            btn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Generando Excel...';
            
            setTimeout(() => {
                btn.innerHTML = originalText;
                alert(`✅ Reporte Excel de ${total} logs generado correctamente`);
                // En una implementación real, aquí se descargaría el Excel
            }, 2000);
        }

        function exportarCSV() {
            const total = <%= totalLogs != null ? totalLogs : 0 %>;
            if (total === 0) {
                alert('No hay datos para exportar.');
                return;
            }

            const btn = event.target;
            const originalText = btn.innerHTML;
            btn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Generando CSV...';
            
            setTimeout(() => {
                btn.innerHTML = originalText;
                alert(`✅ Reporte CSV de ${total} logs generado correctamente`);
                // En una implementación real, aquí se descargaría el CSV
            }, 2000);
        }

        // Función para análisis de actividad
        function analizarActividad() {
            const total = <%= totalLogs != null ? totalLogs : 0 %>;
            const inserts = <%= insertCount %>;
            const updates = <%= updateCount %>;
            const deletes = <%= deleteCount %>;
            
            if (total === 0) {
                alert('No hay actividad para analizar.');
                return;
            }

            const porcentajeInserts = ((inserts / total) * 100).toFixed(1);
            const porcentajeUpdates = ((updates / total) * 100).toFixed(1);
            const porcentajeDeletes = ((deletes / total) * 100).toFixed(1);

            alert(`📊 Análisis de Actividad:\n\n• ${total} operaciones registradas\n• ${inserts} inserciones (${porcentajeInserts}%)\n• ${updates} actualizaciones (${porcentajeUpdates}%)\n• ${deletes} eliminaciones (${porcentajeDeletes}%)\n\nPeríodo: últimos ${<%= request.getAttribute("diasConsulta") != null ? request.getAttribute("diasConsulta") : 7 %>} días`);
        }

        // Atajos de teclado
        document.addEventListener('keydown', function(e) {
            // Ctrl + P para exportar PDF
            if (e.ctrlKey && e.key === 'p') {
                e.preventDefault();
                exportarPDF();
            }
            
            // F5 para refrescar
            if (e.key === 'F5') {
                e.preventDefault();
                document.getElementById('filtersForm').submit();
            }
            
            // Ctrl + A para análisis
            if (e.ctrlKey && e.key === 'a') {
                e.preventDefault();
                analizarActividad();
            }
        });
    </script>
</body>
</html>