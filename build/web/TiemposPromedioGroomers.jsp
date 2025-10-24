<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, modelo.TiempoPromedioGroomerDTO, java.sql.Date" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tiempos Promedio de Groomers - Sistema PetCare</title>
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
            max-width: 1400px;
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

        /* Date Filter */
        .date-filter {
            background: var(--white);
            padding: 30px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.8s ease-out;
        }

        .date-filter::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-info);
        }

        .filter-form {
            display: flex;
            gap: 20px;
            align-items: flex-end;
            flex-wrap: wrap;
        }

        .form-group {
            flex: 1;
            min-width: 200px;
        }

        .form-group label {
            display: block;
            margin-bottom: 10px;
            font-weight: 600;
            color: var(--text-dark);
            font-size: 0.95em;
        }

        .form-control {
            width: 100%;
            padding: 14px 16px;
            border: 1px solid #e0e0e0;
            border-radius: var(--radius);
            font-size: 1em;
            transition: all 0.3s ease;
            background-color: #f9f9f9;
            font-family: inherit;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
            background-color: var(--white);
            box-shadow: 0 0 0 3px rgba(171, 203, 213, 0.2);
        }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: var(--white);
            padding: 30px 25px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            text-align: center;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.8s ease-out;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-info);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }

        .stat-icon {
            font-size: 3em;
            margin-bottom: 15px;
            display: block;
        }

        .stat-value {
            font-size: 2.5em;
            font-weight: 800;
            color: var(--primary-dark);
            margin: 10px 0;
        }

        .stat-label {
            color: var(--text-light);
            font-size: 1em;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* Period Info */
        .period-info {
            background: var(--white);
            padding: 25px 30px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.8s ease-out;
        }

        .period-info::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-primary);
        }

        .period-dates {
            font-size: 1.2em;
            font-weight: 600;
            color: var(--text-dark);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .period-stats {
            display: flex;
            gap: 20px;
            align-items: center;
            flex-wrap: wrap;
        }

        .stat-badge {
            background: var(--primary-light);
            color: var(--text-dark);
            padding: 10px 18px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9em;
            border: 1px solid rgba(171, 203, 213, 0.3);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* Table Container */
        .table-container {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 30px;
            animation: fadeInUp 0.8s ease-out;
            position: relative;
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
            position: sticky;
            top: 0;
            font-size: 0.95em;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        td {
            padding: 18px 20px;
            text-align: left;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }

        tr:hover td {
            background-color: rgba(171, 203, 213, 0.05);
            transform: translateY(-1px);
        }

        /* Status Badges */
        .groomer-name {
            font-weight: 600;
            color: var(--text-dark);
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.05em;
        }

        .atenciones-badge {
            background: var(--primary-light);
            color: var(--text-dark);
            padding: 8px 14px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9em;
            border: 1px solid rgba(171, 203, 213, 0.3);
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .tiempo-badge {
            padding: 8px 14px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.85em;
            text-align: center;
            display: inline-block;
        }

        .tiempo-promedio {
            background: linear-gradient(135deg, #e8f8f4 0%, #d1f2eb 100%);
            color: var(--success-color);
            border: 1px solid #c3e6cb;
        }

        .tiempo-minimo {
            background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
            color: #856404;
            border: 1px solid #ffeaa7;
        }

        .tiempo-maximo {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            color: var(--danger-color);
            border: 1px solid #f5c6cb;
        }

        /* Performance Indicators */
        .performance-indicator {
            display: inline-block;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            margin-right: 10px;
        }

        .performance-excelente { background-color: var(--success-color); }
        .performance-buena { background-color: #28a745; }
        .performance-regular { background-color: var(--warning-color); }
        .performance-mejorable { background-color: var(--danger-color); }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 80px 40px;
            color: var(--text-light);
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            animation: fadeInUp 0.8s ease-out;
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

        /* Navigation */
        .navigation {
            display: flex;
            gap: 20px;
            margin-top: 40px;
            justify-content: center;
            flex-wrap: wrap;
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

        @keyframes floating {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
        }

        .floating {
            animation: floating 3s ease-in-out infinite;
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
            .filter-form {
                flex-direction: column;
                gap: 15px;
            }
            .period-info {
                flex-direction: column;
                text-align: center;
                gap: 15px;
            }
            .period-stats {
                justify-content: center;
            }
            .stats-grid {
                grid-template-columns: 1fr;
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
        }

        @media (max-width: 480px) {
            .header {
                padding: 20px;
            }
            .main-content {
                padding: 15px;
            }
            .date-filter {
                padding: 20px;
            }
            .stat-badge {
                width: 100%;
                justify-content: center;
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
                    <a href="ServicioControlador">
                        <span class="menu-icon">🛠️</span>
                        <span>Servicios</span>
                    </a>
                </li>
                
                <!-- Personal y Operaciones -->
                <div class="menu-section">Personal y Operaciones</div>
                <li class="menu-item active">
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
                        <h1>⏱️ Tiempos Promedio de Groomers</h1>
                        <p>Análisis de eficiencia y desempeño del personal de grooming</p>
                    </div>
                    <div class="header-actions">
                        <a href="GroomerControlador" class="btn btn-secondary">← Volver al Listado</a>
                    </div>
                </div>
            </div>

            <div class="main-content">
                <!-- Mensajes -->
                <% if (request.getAttribute("mensaje") != null) { %>
                    <div class="mensaje error">
                        <%= request.getAttribute("mensaje") %>
                    </div>
                <% } %>

                <!-- Filtro de fechas -->
                <div class="date-filter">
                    <form action="GroomerControlador" method="GET" id="filterForm">
                        <input type="hidden" name="accion" value="tiemposPromedio">
                        
                        <div class="filter-form">
                            <div class="form-group">
                                <label for="fechaInicio">📅 Fecha de Inicio:</label>
                                <input type="date" id="fechaInicio" name="fechaInicio" class="form-control" 
                                       value="<%= request.getAttribute("fechaInicio") != null ? request.getAttribute("fechaInicio") : "" %>"
                                       onchange="validarFechas()">
                            </div>

                            <div class="form-group">
                                <label for="fechaFin">📅 Fecha de Fin:</label>
                                <input type="date" id="fechaFin" name="fechaFin" class="form-control"
                                       value="<%= request.getAttribute("fechaFin") != null ? request.getAttribute("fechaFin") : "" %>"
                                       onchange="validarFechas()">
                            </div>

                            <button type="submit" class="btn btn-primary">
                                <span>🔍 Consultar Tiempos</span>
                            </button>
                            <button type="button" class="btn btn-info" onclick="establecerUltimoMes()">
                                <span>📅 Último Mes</span>
                            </button>
                        </div>
                    </form>
                </div>

                <%
                    List<TiempoPromedioGroomerDTO> tiempos = (List<TiempoPromedioGroomerDTO>) request.getAttribute("tiemposPromedio");
                    Integer totalRegistros = (Integer) request.getAttribute("totalRegistros");
                    Date fechaInicio = (Date) request.getAttribute("fechaInicio");
                    Date fechaFin = (Date) request.getAttribute("fechaFin");
                %>

                <!-- Información del período -->
                <% if (fechaInicio != null && fechaFin != null) { %>
                    <div class="period-info">
                        <div class="period-dates">
                            <span>📅</span>
                            Período analizado: <strong><%= fechaInicio %></strong> al <strong><%= fechaFin %></strong>
                        </div>
                        <div class="period-stats">
                            <span class="stat-badge">📊 Total de Registros: <%= totalRegistros != null ? totalRegistros : 0 %></span>
                            <span class="stat-badge">👥 Groomers Analizados: <%= tiempos != null ? tiempos.size() : 0 %></span>
                        </div>
                    </div>
                <% } %>

                <!-- Estadísticas generales -->
                <% if (tiempos != null && !tiempos.isEmpty()) { 
                    double tiempoPromedioGeneral = 0;
                    int totalAtenciones = 0;
                    for (TiempoPromedioGroomerDTO tiempo : tiempos) {
                        tiempoPromedioGeneral += tiempo.getTiempoPromedioMinutos();
                        totalAtenciones += tiempo.getTotalAtenciones();
                    }
                    tiempoPromedioGeneral = tiempos.size() > 0 ? tiempoPromedioGeneral / tiempos.size() : 0;
                %>
                    <div class="stats-grid">
                        <div class="stat-card floating">
                            <span class="stat-icon">⏱️</span>
                            <div class="stat-value"><%= String.format("%.1f", tiempoPromedioGeneral) %></div>
                            <div class="stat-label">Minutos Promedio General</div>
                        </div>
                        
                        <div class="stat-card floating" style="animation-delay: 0.2s;">
                            <span class="stat-icon">📋</span>
                            <div class="stat-value"><%= totalAtenciones %></div>
                            <div class="stat-label">Total de Atenciones</div>
                        </div>
                        
                        <div class="stat-card floating" style="animation-delay: 0.4s;">
                            <span class="stat-icon">👥</span>
                            <div class="stat-value"><%= tiempos.size() %></div>
                            <div class="stat-label">Groomers Analizados</div>
                        </div>
                        
                        <div class="stat-card floating" style="animation-delay: 0.6s;">
                            <span class="stat-icon">📈</span>
                            <div class="stat-value"><%= String.format("%.1f", totalAtenciones > 0 ? (double) totalAtenciones / tiempos.size() : 0) %></div>
                            <div class="stat-label">Atenciones por Groomer</div>
                        </div>
                    </div>
                <% } %>

                <!-- Tabla de tiempos promedio -->
                <h3 style="margin-bottom: 20px; color: var(--text-dark); font-weight: 700; font-size: 1.4em; display: flex; align-items: center; gap: 10px;">
                    <span>📊</span> Desempeño por Groomer
                </h3>

                <% if (tiempos != null && !tiempos.isEmpty()) { %>
                    <div class="table-container">
                        <div class="table-wrapper">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Groomer</th>
                                        <th>Total Atenciones</th>
                                        <th>Tiempo Promedio</th>
                                        <th>Tiempo Mínimo</th>
                                        <th>Tiempo Máximo</th>
                                        <th>Eficiencia</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (TiempoPromedioGroomerDTO tiempo : tiempos) { 
                                        String eficiencia = calcularEficiencia(tiempo.getTiempoPromedioMinutos());
                                    %>
                                        <tr>
                                            <td>
                                                <div class="groomer-name">
                                                    <span>✂️</span>
                                                    <%= tiempo.getNombreGroomer() %>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="atenciones-badge">
                                                    📋 <%= tiempo.getTotalAtenciones() %>
                                                </span>
                                            </td>
                                            <td>
                                                <span class="tiempo-badge tiempo-promedio">
                                                    ⏱️ <%= String.format("%.1f", tiempo.getTiempoPromedioMinutos()) %> min
                                                </span>
                                            </td>
                                            <td>
                                                <span class="tiempo-badge tiempo-minimo">
                                                    📉 <%= tiempo.getTiempoMinimo() %> min
                                                </span>
                                            </td>
                                            <td>
                                                <span class="tiempo-badge tiempo-maximo">
                                                    📈 <%= tiempo.getTiempoMaximo() %> min
                                                </span>
                                            </td>
                                            <td>
                                                <span class="performance-indicator <%= eficiencia %>"></span>
                                                <%= obtenerTextoEficiencia(eficiencia) %>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                <% } else { %>
                    <div class="empty-state">
                        <h3>⏱️ No hay datos de tiempos promedio</h3>
                        <p>
                            <% if (fechaInicio != null && fechaFin != null) { %>
                                No se encontraron datos de tiempos promedio para el período <%= fechaInicio %> al <%= fechaFin %>.
                            <% } else { %>
                                Selecciona un rango de fechas para consultar los tiempos promedio de los groomers.
                            <% } %>
                        </p>
                        <button type="button" class="btn btn-primary" onclick="establecerUltimoMes()">
                            <span>📅 Consultar Último Mes</span>
                        </button>
                    </div>
                <% } %>

                <!-- Navegación -->
                <div class="navigation">
                    <a href="GroomerControlador" class="btn btn-secondary">← Volver al Listado de Groomers</a>
                    <a href="GroomerControlador?accion=disponibilidad" class="btn btn-primary">📅 Ver Disponibilidad</a>
                    <a href="GroomerControlador?accion=ocupacion" class="btn btn-info">📊 Ver Ocupación</a>
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
            
            // Establecer fechas por defecto si no están definidas
            const fechaInicio = document.getElementById('fechaInicio');
            const fechaFin = document.getElementById('fechaFin');
            
            if (fechaInicio && !fechaInicio.value) {
                const haceUnMes = new Date();
                haceUnMes.setMonth(haceUnMes.getMonth() - 1);
                fechaInicio.value = haceUnMes.toISOString().split('T')[0];
            }
            
            if (fechaFin && !fechaFin.value) {
                const hoy = new Date().toISOString().split('T')[0];
                fechaFin.value = hoy;
            }
            
            // Agregar efectos hover a las filas de la tabla
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

            // Animación para las tarjetas de estadísticas
            const statCards = document.querySelectorAll('.stat-card');
            statCards.forEach((card, index) => {
                card.style.animationDelay = (index * 0.1) + 's';
            });
        });

        // Función para validar fechas
        function validarFechas() {
            const fechaInicio = document.getElementById('fechaInicio').value;
            const fechaFin = document.getElementById('fechaFin').value;
            
            if (fechaInicio && fechaFin) {
                const inicio = new Date(fechaInicio);
                const fin = new Date(fechaFin);
                
                if (fin < inicio) {
                    alert('⚠️ La fecha de fin no puede ser anterior a la fecha de inicio.');
                    document.getElementById('fechaFin').value = '';
                    return false;
                }
            }
            return true;
        }

        // Función para establecer el último mes
        function establecerUltimoMes() {
            const hoy = new Date();
            const haceUnMes = new Date();
            haceUnMes.setMonth(haceUnMes.getMonth() - 1);
            
            document.getElementById('fechaInicio').value = haceUnMes.toISOString().split('T')[0];
            document.getElementById('fechaFin').value = hoy.toISOString().split('T')[0];
            document.getElementById('filterForm').submit();
        }

        // Función para filtrar por eficiencia
        function filtrarPorEficiencia(nivel) {
            const rows = document.querySelectorAll('tbody tr');
            rows.forEach(row => {
                const indicador = row.querySelector('.performance-indicator');
                if (nivel === 'todos') {
                    row.style.display = '';
                } else if (indicador.classList.contains('performance-' + nivel)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        // Agregar filtros si hay datos
        <% if (tiempos != null && !tiempos.isEmpty()) { %>
        document.addEventListener('DOMContentLoaded', function() {
            const tableContainer = document.querySelector('.table-container');
            const filterDiv = document.createElement('div');
            filterDiv.style.marginBottom = '15px';
            filterDiv.style.display = 'flex';
            filterDiv.style.gap = '10px';
            filterDiv.style.alignItems = 'center';
            filterDiv.style.flexWrap = 'wrap';
            filterDiv.innerHTML = `
                <strong>Filtrar por eficiencia:</strong>
                <button onclick="filtrarPorEficiencia('todos')" class="btn btn-small">Todos</button>
                <button onclick="filtrarPorEficiencia('excelente')" class="btn btn-small">✅ Excelente</button>
                <button onclick="filtrarPorEficiencia('buena')" class="btn btn-small">👍 Buena</button>
                <button onclick="filtrarPorEficiencia('regular')" class="btn btn-small">⚠️ Regular</button>
                <button onclick="filtrarPorEficiencia('mejorable')" class="btn btn-small">📉 Mejorable</button>
            `;
            tableContainer.parentNode.insertBefore(filterDiv, tableContainer);
        });
        <% } %>

        // Función para exportar reporte
        function exportarReporte() {
            alert('📊 Exportando reporte de tiempos promedio...\nFormato: CSV\nPeríodo: <%= fechaInicio %> a <%= fechaFin %>');
            // Aquí iría la lógica real de exportación
        }

        // Función para ver tendencias
        function verTendencias() {
            alert('📈 Mostrando tendencias de tiempos...\nEsta función mostraría gráficos de evolución de tiempos por groomer.');
        }
    </script>
</body>
</html>

<%!
    // Método para calcular la eficiencia basada en el tiempo promedio
    private String calcularEficiencia(double tiempoPromedio) {
        if (tiempoPromedio <= 30) {
            return "performance-excelente";
        } else if (tiempoPromedio <= 45) {
            return "performance-buena";
        } else if (tiempoPromedio <= 60) {
            return "performance-regular";
        } else {
            return "performance-mejorable";
        }
    }

    // Método para obtener el texto de eficiencia
    private String obtenerTextoEficiencia(String eficiencia) {
        switch (eficiencia) {
            case "performance-excelente": return "Excelente";
            case "performance-buena": return "Buena";
            case "performance-regular": return "Regular";
            case "performance-mejorable": return "Mejorable";
            default: return "Sin datos";
        }
    }
%>