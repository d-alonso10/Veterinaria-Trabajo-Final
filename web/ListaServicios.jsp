<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, modelo.Servicio" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Servicios - Sistema PetCare</title>
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

        /* Action Buttons */
        .action-buttons {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
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

        /* Stats Container */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
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

        /* Filter Container */
        .filter-container {
            background: var(--white);
            padding: 30px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .filter-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
        }

        .filter-icon {
            font-size: 1.8em;
            color: var(--primary-color);
        }

        .filter-title {
            font-size: 1.4em;
            font-weight: 700;
            color: var(--text-dark);
        }

        .filter-options {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        /* Table Container */
        .table-container {
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

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: var(--gradient-primary);
            color: var(--white);
            font-weight: 700;
            padding: 20px;
            text-align: left;
            position: sticky;
            top: 0;
            font-size: 0.95em;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        td {
            padding: 18px 20px;
            text-align: left;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }

        tr {
            transition: all 0.3s ease;
        }

        tr:hover {
            background: rgba(171, 203, 213, 0.05);
        }

        tr:hover td {
            transform: translateX(5px);
        }

        /* Categoría Badges */
        .categoria-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.8em;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            border: 2px solid transparent;
        }

        .categoria-bano {
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            color: #1565c0;
            border-color: #90caf9;
        }

        .categoria-corte {
            background: linear-gradient(135deg, #f3e5f5 0%, #e1bee7 100%);
            color: #7b1fa2;
            border-color: #ce93d8;
        }

        .categoria-dental {
            background: linear-gradient(135deg, #e8f5e8 0%, #c8e6c9 100%);
            color: #2e7d32;
            border-color: #a5d6a7;
        }

        .categoria-paquete {
            background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
            color: #ef6c00;
            border-color: #ffb74d;
        }

        .categoria-otro {
            background: linear-gradient(135deg, #f5f5f5 0%, #e0e0e0 100%);
            color: #616161;
            border-color: #bdbdbd;
        }

        /* Action Buttons in Table */
        .action-buttons-table {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .btn-action {
            padding: 10px 16px;
            font-size: 0.85em;
            border-radius: 12px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.3s ease;
            font-weight: 600;
            border: 2px solid transparent;
        }

        .btn-edit {
            background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
            color: #ef6c00;
            border-color: #ffb74d;
        }

        .btn-edit:hover {
            background: #ffb74d;
            color: white;
            transform: translateY(-2px);
        }

        .btn-view {
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            color: #1565c0;
            border-color: #90caf9;
        }

        .btn-view:hover {
            background: #2196f3;
            color: white;
            transform: translateY(-2px);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 80px 40px;
            color: var(--text-light);
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            border: 2px dashed var(--primary-light);
        }

        .empty-state h3 {
            font-size: 2em;
            margin-bottom: 20px;
            color: var(--text-dark);
        }

        .empty-state p {
            font-size: 1.1em;
            margin-bottom: 30px;
            color: var(--text-light);
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
            .action-buttons {
                grid-template-columns: 1fr;
            }
            .filter-options {
                flex-direction: column;
            }
            .table-container {
                overflow-x: auto;
            }
            table {
                min-width: 800px;
            }
            .stats-container {
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
            .filter-container {
                padding: 20px;
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
                <li class="menu-item active">
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
                        <h1>💈 Gestión de Servicios</h1>
                        <p>Administra y organiza todos los servicios de grooming</p>
                    </div>
                    <div class="header-actions">
                        <a href="ServicioControlador?accion=formularioInsertar" class="btn btn-success">➕ Nuevo Servicio</a>
                        <a href="ServicioControlador" class="btn btn-info">🔄 Actualizar</a>
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

                <%
                    List<Servicio> servicios = (List<Servicio>) request.getAttribute("servicios");
                    Integer totalServicios = (Integer) request.getAttribute("totalServicios");
                    String[] categorias = (String[]) request.getAttribute("categorias");
                %>

                <!-- Estadísticas -->
                <div class="stats-container">
                    <div class="stat-card floating">
                        <span class="stat-icon">📊</span>
                        <div class="stat-number"><%= totalServicios != null ? totalServicios : 0 %></div>
                        <div class="stat-label">Total Servicios</div>
                    </div>
                    <div class="stat-card floating" style="animation-delay: 0.2s;">
                        <span class="stat-icon">🏷️</span>
                        <div class="stat-number"><%= categorias != null ? categorias.length : 5 %></div>
                        <div class="stat-label">Categorías</div>
                    </div>
                    <div class="stat-card floating" style="animation-delay: 0.4s;">
                        <span class="stat-icon">💎</span>
                        <div class="stat-number"><%= servicios != null ? servicios.size() : 0 %></div>
                        <div class="stat-label">Activos</div>
                    </div>
                    <div class="stat-card floating" style="animation-delay: 0.6s;">
                        <span class="stat-icon">⭐</span>
                        <div class="stat-number">4.8</div>
                        <div class="stat-label">Rating Promedio</div>
                    </div>
                </div>

                <!-- Botones de acciones principales -->
                <div class="action-buttons">
                    <a href="ServicioControlador?accion=formularioInsertar" class="btn btn-success pulse">
                        <span>➕</span> Nuevo Servicio
                    </a>
                    <a href="ServicioControlador?accion=serviciosMasSolicitados" class="btn btn-primary">
                        <span>📊</span> Servicios Más Solicitados
                    </a>
                    <a href="ServicioControlador" class="btn btn-info">
                        <span>🔄</span> Actualizar Lista
                    </a>
                    <a href="dashboard.jsp" class="btn btn-secondary">
                        <span>📊</span> Ir al Dashboard
                    </a>
                </div>

                <!-- Filtros por categoría -->
                <div class="filter-container">
                    <div class="filter-header">
                        <span class="filter-icon">🔍</span>
                        <span class="filter-title">Filtrar por Categoría</span>
                    </div>
                    <div class="filter-options">
                        <a href="ServicioControlador" class="btn btn-info btn-small">Todas las Categorías</a>
                        <% if (categorias != null) { 
                            for (String categoria : categorias) { 
                                String badgeClass = "categoria-" + categoria.replace("á", "a").toLowerCase();
                        %>
                            <a href="ServicioControlador?accion=porCategoria&categoria=<%= categoria %>" 
                               class="btn btn-info btn-small">
                               <%= categoria.toUpperCase() %>
                            </a>
                        <% } } %>
                    </div>
                </div>

                <!-- Tabla de servicios -->
                <div class="table-container">
                    <h3 style="padding: 25px; margin: 0; color: var(--text-dark); border-bottom: 1px solid rgba(0,0,0,0.1);">
                        📋 Lista de Servicios 
                        <% if (totalServicios != null && totalServicios > 0) { %>
                            <span style="color: var(--text-light); font-size: 16px; font-weight: 500;">
                                (<%= totalServicios %> servicios encontrados)
                            </span>
                        <% } %>
                    </h3>

                    <% if (servicios != null && !servicios.isEmpty()) { %>
                        <table>
                            <thead>
                                <tr>
                                    <th style="width: 100px;">Código</th>
                                    <th>Nombre del Servicio</th>
                                    <th>Descripción</th>
                                    <th style="width: 140px;">Categoría</th>
                                    <th style="width: 120px;">Duración</th>
                                    <th style="width: 120px;">Precio</th>
                                    <th style="width: 200px; text-align: center;">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Servicio servicio : servicios) { 
                                    String categoriaClass = "categoria-" + servicio.getCategoria().replace("á", "a").toLowerCase();
                                %>
                                    <tr>
                                        <td>
                                            <strong style="color: var(--primary-dark); font-size: 1.1em;">
                                                <%= servicio.getCodigo() %>
                                            </strong>
                                        </td>
                                        <td>
                                            <strong style="color: var(--text-dark); font-size: 1.05em;">
                                                <%= servicio.getNombre() %>
                                            </strong>
                                        </td>
                                        <td>
                                            <% if (servicio.getDescripcion() != null && !servicio.getDescripcion().isEmpty()) { %>
                                                <span style="color: var(--text-light);">
                                                    <%= servicio.getDescripcion() %>
                                                </span>
                                            <% } else { %>
                                                <em style="color: #999;">Sin descripción</em>
                                            <% } %>
                                        </td>
                                        <td>
                                            <span class="categoria-badge <%= categoriaClass %>">
                                                <%= servicio.getCategoria().toUpperCase() %>
                                            </span>
                                        </td>
                                        <td style="text-align: center;">
                                            <span style="font-weight: bold; color: var(--info-color); font-size: 1.1em;">
                                                <%= servicio.getDuracionEstimadaMin() %> min
                                            </span>
                                        </td>
                                        <td style="text-align: right;">
                                            <span style="font-weight: bold; color: var(--success-color); font-size: 1.1em;">
                                                S/ <%= String.format("%.2f", servicio.getPrecioBase()) %>
                                            </span>
                                        </td>
                                        <td style="text-align: center;">
                                            <div class="action-buttons-table">
                                                <a href="ServicioControlador?accion=formularioActualizar&idServicio=<%= servicio.getIdServicio() %>" 
                                                   class="btn-action btn-edit" 
                                                   title="Editar servicio">
                                                   ✏️ Editar
                                                </a>
                                                
                                                <a href="ServicioControlador?accion=porCategoria&categoria=<%= servicio.getCategoria() %>" 
                                                   class="btn-action btn-view"
                                                   title="Ver servicios similares">
                                                   👁️ Ver
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } else { %>
                        <div class="empty-state">
                            <h3>📭 No hay servicios registrados</h3>
                            <p>Comienza agregando tu primer servicio al sistema</p>
                            <a href="ServicioControlador?accion=formularioInsertar" class="btn btn-success pulse">
                                ➕ Agregar Primer Servicio
                            </a>
                        </div>
                    <% } %>
                </div>

                <!-- Botones al final -->
                <div style="text-align: center; margin-top: 30px;">
                    <a href="ServicioControlador?accion=formularioInsertar" class="btn btn-success">➕ Nuevo Servicio</a>
                    <a href="ServicioControlador" class="btn btn-info">🔄 Actualizar Lista</a>
                    <a href="ServicioControlador?accion=serviciosMasSolicitados" class="btn btn-primary">📊 Ver Estadísticas</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Animaciones y efectos interactivos
        document.addEventListener('DOMContentLoaded', function() {
            // Efecto de aparición escalonada para las filas de la tabla
            const tableRows = document.querySelectorAll('tbody tr');
            tableRows.forEach((row, index) => {
                row.style.opacity = '0';
                row.style.transform = 'translateY(30px)';
                
                setTimeout(() => {
                    row.style.transition = 'all 0.6s cubic-bezier(0.4, 0, 0.2, 1)';
                    row.style.opacity = '1';
                    row.style.transform = 'translateY(0)';
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

            // Contador animado para las estadísticas
            const statNumbers = document.querySelectorAll('.stat-number');
            statNumbers.forEach(stat => {
                const target = parseInt(stat.textContent);
                if (!isNaN(target)) {
                    let current = 0;
                    const increment = target / 60;
                    const timer = setInterval(() => {
                        current += increment;
                        if (current >= target) {
                            stat.textContent = target;
                            clearInterval(timer);
                        } else {
                            stat.textContent = Math.floor(current);
                        }
                    }, 30);
                }
            });

            // Confirmación para acciones importantes
            const deleteButtons = document.querySelectorAll('.btn-danger');
            deleteButtons.forEach(button => {
                button.addEventListener('click', function(e) {
                    if (!confirm('¿Está seguro de que desea realizar esta acción?')) {
                        e.preventDefault();
                    }
                });
            });
        });

        // Función para mostrar loading en botones
        function showLoading(button) {
            const originalText = button.innerHTML;
            button.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Procesando...';
            button.disabled = true;
            
            setTimeout(() => {
                button.innerHTML = originalText;
                button.disabled = false;
            }, 2000);
        }

        // Agregar evento de loading a los botones de formulario
        const formButtons = document.querySelectorAll('form .btn, a[href*="accion="]');
        formButtons.forEach(button => {
            button.addEventListener('click', function(e) {
                if (!this.href || this.href.includes('accion=')) {
                    showLoading(this);
                }
            });
        });
    </script>
</body>
</html>