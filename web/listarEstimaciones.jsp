<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="modelo.EstimacionTiempoDTO" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Configuración de Estimaciones - Sistema PetCare</title>
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

        .btn-action {
            padding: 8px 16px;
            font-size: 0.85em;
            border-radius: 12px;
            margin: 2px;
        }

        /* Stats Container Mejorado */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin: 30px 0;
        }

        .stat-card {
            background: var(--white);
            padding: 30px 25px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            text-align: center;
            border: 1px solid rgba(0, 0, 0, 0.05);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
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
            background: var(--gradient-primary);
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

        .stat-number {
            font-size: 2.5em;
            font-weight: 800;
            margin: 10px 0;
            color: var(--primary-dark);
        }

        .stat-label {
            color: var(--text-light);
            font-size: 1em;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* Table Container Mejorado */
        .table-container {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 30px;
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

        .badge-positive {
            background: linear-gradient(135deg, #e8f6ef 0%, #d1f2eb 100%);
            color: #1e8449;
            border: 1px solid #a3e4d7;
        }

        .badge-negative {
            background: linear-gradient(135deg, #fdedec 0%, #fadbd8 100%);
            color: #c0392b;
            border: 1px solid #f5b7b1;
        }

        .badge-neutral {
            background: linear-gradient(135deg, #f0f3f4 0%, #e5e8e8 100%);
            color: #566573;
            border: 1px solid #d0d3d4;
        }

        .badge-efficiency {
            background: linear-gradient(135deg, #fef9e7 0%, #fcf3cf 100%);
            color: #b7950b;
            border: 1px solid #f9e79f;
        }

        .service-badge {
            background: var(--primary-light);
            color: var(--text-dark);
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.85em;
            border: 1px solid var(--primary-color);
        }

        .groomer-badge {
            background: linear-gradient(135deg, #e8f4f8 0%, #d4eaf0 100%);
            color: var(--text-dark);
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 600;
            border: 1px solid var(--primary-light);
        }

        .time-display {
            font-family: 'Courier New', monospace;
            font-weight: 700;
            font-size: 1.1em;
            color: var(--text-dark);
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

        /* Empty State Mejorado */
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

        /* Filtros adicionales */
        .filters-container {
            background: var(--white);
            padding: 25px;
            border-radius: var(--radius);
            margin-bottom: 25px;
            box-shadow: var(--shadow);
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            align-items: center;
        }

        .filter-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .filter-label {
            font-weight: 600;
            color: var(--text-dark);
            font-size: 0.9em;
        }

        .filter-select {
            padding: 10px 15px;
            border: 2px solid #e0e0e0;
            border-radius: var(--radius);
            background: #f9f9f9;
            font-size: 0.9em;
            transition: all 0.3s ease;
        }

        .filter-select:focus {
            outline: none;
            border-color: var(--primary-color);
            background: var(--white);
        }

        /* Responsive Design - Coherente con Dashboard */
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
            .stats-container {
                grid-template-columns: 1fr;
            }
            .filters-container {
                flex-direction: column;
                align-items: stretch;
            }
            .filter-group {
                width: 100%;
                justify-content: space-between;
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
            .empty-state {
                padding: 40px 20px;
            }
            .empty-state-icon {
                font-size: 3em;
            }
        }

        /* Efectos especiales adicionales */
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

        /* Action Buttons Mejorados */
        .btn-edit {
            background: linear-gradient(135deg, var(--warning-color) 0%, #e0a800 100%);
            color: var(--text-dark);
            padding: 10px 18px;
            font-size: 0.85em;
            border-radius: 12px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.3s ease;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(255, 193, 7, 0.3);
        }

        .btn-edit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(255, 193, 7, 0.4);
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
                    <a href="<%= request.getContextPath() %>/MascotaControlador?accion=listarTodas">
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
                <li class="menu-item active">
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
                        <h1>⚙️ Configuración de Estimaciones</h1>
                        <p>Gestiona los tiempos estimados para servicios y groomers</p>
                    </div>
                    <div class="header-actions">
                        <a href="agregarEstimacion.jsp" class="btn btn-success">
                            <span>➕ Nueva Estimación</span>
                        </a>
                        <a href="dashboard.jsp" class="btn btn-primary">
                            <span>📊 Ir al Dashboard</span>
                        </a>
                    </div>
                </div>
            </div>

            <div class="main-content">
                <!-- Mensajes -->
                <% String mensaje = (String) request.getAttribute("mensaje"); %>
                <% if (mensaje != null) { %>
                    <div class="mensaje <%= mensaje.contains("✅") ? "exito" : "info" %>">
                        <%= mensaje %>
                    </div>
                <% } %>

                <!-- Estadísticas de Estimaciones -->
                <%
                    List<EstimacionTiempoDTO> lista = (List<EstimacionTiempoDTO>) request.getAttribute("estimaciones");
                    int totalEstimaciones = lista != null ? lista.size() : 0;
                    int optimizadas = 0;
                    int sobreTiempo = 0;
                    int iguales = 0;
                    
                    if (lista != null) {
                        for (EstimacionTiempoDTO est : lista) {
                            int diferencia = est.getTiempoEstimadoMin() - est.getDuracionBase();
                            if (diferencia < 0) optimizadas++;
                            else if (diferencia > 0) sobreTiempo++;
                            else iguales++;
                        }
                    }
                %>

                <div class="stats-container">
                    <div class="stat-card floating">
                        <span class="stat-icon">⏱️</span>
                        <div class="stat-number" id="totalEstimaciones"><%= totalEstimaciones %></div>
                        <div class="stat-label">Total Estimaciones</div>
                    </div>
                    <div class="stat-card floating" style="animation-delay: 0.2s;">
                        <span class="stat-icon">🚀</span>
                        <div class="stat-number" id="optimizadasCount"><%= optimizadas %></div>
                        <div class="stat-label">Optimizadas</div>
                    </div>
                    <div class="stat-card floating" style="animation-delay: 0.4s;">
                        <span class="stat-icon">⚠️</span>
                        <div class="stat-number" id="sobreTiempoCount"><%= sobreTiempo %></div>
                        <div class="stat-label">Sobre Tiempo</div>
                    </div>
                    <div class="stat-card floating" style="animation-delay: 0.6s;">
                        <span class="stat-icon">⚖️</span>
                        <div class="stat-number" id="igualesCount"><%= iguales %></div>
                        <div class="stat-label">En Tiempo</div>
                    </div>
                </div>

                <!-- Tabla de Estimaciones Mejorada -->
                <% if (lista != null && !lista.isEmpty()) { %>
                    <div class="table-container">
                        <div class="table-wrapper">
                            <table>
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Servicio</th>
                                        <th>Groomer</th>
                                        <th>Duración Base</th>
                                        <th>Tiempo Estimado</th>
                                        <th>Diferencia</th>
                                        <th>Eficiencia</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        int i = 1;
                                        for (EstimacionTiempoDTO est : lista) {
                                            int diferencia = est.getTiempoEstimadoMin() - est.getDuracionBase();
                                            String eficiencia = est.getNivelEficiencia() != null ? est.getNivelEficiencia() : "";
                                            
                                            String diferenciaBadgeClass = "badge-neutral";
                                            String diferenciaText = "Igual";
                                            
                                            if (diferencia > 0) {
                                                diferenciaBadgeClass = "badge-negative";
                                                diferenciaText = "+" + diferencia + " min";
                                            } else if (diferencia < 0) {
                                                diferenciaBadgeClass = "badge-positive";
                                                diferenciaText = diferencia + " min";
                                            }
                                    %>
                                    <tr class="fade-in-row">
                                        <td>
                                            <span class="service-badge">#<%= i++ %></span>
                                        </td>
                                        <td>
                                            <strong><%= est.getServicio() %></strong>
                                        </td>
                                        <td>
                                            <span class="groomer-badge"><%= est.getGroomer() %></span>
                                        </td>
                                        <td>
                                            <span class="time-display"><%= est.getDuracionBase() %> min</span>
                                        </td>
                                        <td>
                                            <span class="time-display"><%= est.getTiempoEstimadoMin() %> min</span>
                                        </td>
                                        <td>
                                            <span class="badge <%= diferenciaBadgeClass %>"><%= diferenciaText %></span>
                                        </td>
                                        <td>
                                            <% if (!eficiencia.isEmpty()) { %>
                                                <span class="badge badge-efficiency"><%= eficiencia %></span>
                                            <% } else { %>
                                                <span class="no-data">-</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="ConfiguracionControlador?accion=editar&idServicio=<%= est.getIdServicio()%>&idGroomer=<%= est.getIdGroomer()%>" 
                                                   class="btn-edit"
                                                   title="Editar estimación">
                                                    ✏️ Editar
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Resumen de resultados -->
                    <div class="info" style="margin: 20px 0; padding: 15px 25px;">
                        <strong>📊 Resumen:</strong> 
                        <strong><%= totalEstimaciones %></strong> <%= totalEstimaciones == 1 ? "estimación configurada" : "estimaciones configuradas" %> | 
                        <span style="color: #1e8449;"><strong><%= optimizadas %></strong> optimizadas</span> | 
                        <span style="color: #c0392b;"><strong><%= sobreTiempo %></strong> sobre tiempo</span> | 
                        <span style="color: #566573;"><strong><%= iguales %></strong> en tiempo</span>
                    </div>

                <% } else { %>
                    <div class="empty-state">
                        <span class="empty-state-icon">⏱️</span>
                        <h3>No hay estimaciones configuradas</h3>
                        <p>
                            Comienza configurando las estimaciones de tiempo para los diferentes servicios y groomers. 
                            Esto te ayudará a planificar mejor las citas y optimizar los tiempos de atención.
                        </p>
                        <a href="agregarEstimacion.jsp" class="btn btn-success btn-large">
                            <span>➕ Configurar Primera Estimación</span>
                        </a>
                    </div>
                <% } %>

                <!-- Navegación mejorada -->
                <div style="display: flex; gap: 15px; margin-top: 30px; flex-wrap: wrap;">
                    <a href="agregarEstimacion.jsp" class="btn btn-success">
                        <span>➕ Nueva Estimación</span>
                    </a>
                    <a href="menuConfiguracion.jsp" class="btn btn-secondary">
                        <span>⚙️ Menú Configuración</span>
                    </a>
                    <a href="dashboard.jsp" class="btn btn-primary">
                        <span>📊 Volver al Dashboard</span>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Script mejorado para la página de estimaciones
        document.addEventListener('DOMContentLoaded', function() {
            // Efecto de carga suave para las filas de la tabla
            const tableRows = document.querySelectorAll('tbody tr');
            tableRows.forEach((row, index) => {
                row.style.opacity = '0';
                row.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    row.style.transition = 'all 0.5s cubic-bezier(0.4, 0, 0.2, 1)';
                    row.style.opacity = '1';
                    row.style.transform = 'translateY(0)';
                }, index * 100);
            });

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
                const totalElement = document.getElementById('totalEstimaciones');
                const optimizadasElement = document.getElementById('optimizadasCount');
                const sobreTiempoElement = document.getElementById('sobreTiempoCount');
                const igualesElement = document.getElementById('igualesCount');
                
                if (totalElement) animateCounter(totalElement, <%= totalEstimaciones %>);
                if (optimizadasElement) animateCounter(optimizadasElement, <%= optimizadas %>);
                if (sobreTiempoElement) animateCounter(sobreTiempoElement, <%= sobreTiempo %>);
                if (igualesElement) animateCounter(igualesElement, <%= iguales %>);
            }, 500);

            // Efectos hover mejorados para botones de acción
            const actionButtons = document.querySelectorAll('.btn-edit');
            actionButtons.forEach(button => {
                button.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-3px) scale(1.05)';
                });
                button.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0) scale(1)';
                });
            });

            // Tooltips para las diferencias de tiempo
            const diferenciaBadges = document.querySelectorAll('.badge-positive, .badge-negative, .badge-neutral');
            diferenciaBadges.forEach(badge => {
                let tooltipText = "";
                if (badge.classList.contains('badge-positive')) {
                    tooltipText = "⏰ Este groomer completa el servicio más rápido que el tiempo base";
                } else if (badge.classList.contains('badge-negative')) {
                    tooltipText = "⏰ Este groomer necesita más tiempo que el tiempo base";
                } else {
                    tooltipText = "⏰ El tiempo estimado coincide con el tiempo base";
                }
                
                badge.setAttribute('title', tooltipText);
            });
        });

        // Función para exportar datos (placeholder)
        function exportarEstimaciones() {
            if (confirm('¿Desea exportar la configuración de estimaciones?')) {
                const exportBtn = document.querySelector('.btn-export');
                const originalText = exportBtn.innerHTML;
                exportBtn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Exportando...';
                
                setTimeout(() => {
                    exportBtn.innerHTML = originalText;
                    alert('✅ Configuración de estimaciones exportada correctamente');
                }, 2000);
            }
        }

        // Función para análisis de eficiencia
        function analizarEficiencia() {
            const optimizadas = <%= optimizadas %>;
            const total = <%= totalEstimaciones %>;
            
            if (total > 0) {
                const porcentajeOptimizadas = (optimizadas / total * 100).toFixed(1);
                alert(`📊 Análisis de Eficiencia:\n\n• ${optimizadas} de ${total} estimaciones optimizadas\n• ${porcentajeOptimizadas}% de eficiencia general\n\n¡Sigue optimizando los tiempos!`);
            } else {
                alert('No hay datos suficientes para el análisis de eficiencia.');
            }
        }
    </script>
</body>
</html>