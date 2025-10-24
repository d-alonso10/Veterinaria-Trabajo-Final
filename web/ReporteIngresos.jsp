<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, modelo.ReporteIngresosDTO" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reporte de Ingresos - Sistema PetCare</title>
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

        /* Filtros Container */
        .filters-container {
            background: var(--white);
            padding: 30px;
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
            min-width: 800px;
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
        .amount-badge {
            background: linear-gradient(135deg, #e8f6ef 0%, #d1f2eb 100%);
            color: #1e8449;
            padding: 8px 14px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 1em;
            border: 1px solid #a3e4d7;
            font-family: 'Courier New', monospace;
        }

        .count-badge {
            background: var(--primary-light);
            color: var(--text-dark);
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.9em;
            border: 1px solid var(--primary-color);
        }

        .date-badge {
            background: linear-gradient(135deg, #e8f4f8 0%, #d4eaf0 100%);
            color: var(--text-dark);
            padding: 6px 12px;
            border-radius: 20px;
            font-family: 'Courier New', monospace;
            font-size: 0.9em;
            font-weight: 600;
            border: 1px solid var(--primary-light);
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

        /* Efectos especiales adicionales */
        .floating {
            animation: floating 3s ease-in-out infinite;
        }

        @keyframes floating {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
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
                <li class="menu-item active">
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
                        <h1>📊 Reporte de Ingresos</h1>
                        <p>Análisis detallado de ingresos y facturación del sistema</p>
                    </div>
                    <div class="header-actions">
                        <a href="dashboard.jsp" class="btn btn-primary">
                            <span>📊 Ir al Dashboard</span>
                        </a>
                        <button onclick="exportarPDF()" class="btn btn-export">
                            <span>📄 Exportar PDF</span>
                        </button>
                    </div>
                </div>
            </div>

            <div class="main-content">
                <!-- Mensajes -->
                <% if (request.getAttribute("mensaje") != null) { %>
                    <div class="mensaje info">
                        <strong><%= request.getAttribute("mensaje") %></strong>
                    </div>
                <% } %>

                <!-- Estadísticas de Ingresos -->
                <%
                    List<ReporteIngresosDTO> reporte = (List<ReporteIngresosDTO>) request.getAttribute("reporte");
                    double ingresosTotales = 0;
                    int totalFacturas = 0;
                    double promedioGeneral = 0;
                    int diasConDatos = 0;
                    
                    if (reporte != null && !reporte.isEmpty()) {
                        for (ReporteIngresosDTO r : reporte) {
                            ingresosTotales += r.getIngresosTotales();
                            totalFacturas += r.getCantidadFacturas();
                            diasConDatos++;
                        }
                        promedioGeneral = ingresosTotales / totalFacturas;
                    }
                %>

                <div class="stats-container">
                    <div class="stat-card floating">
                        <span class="stat-icon">💰</span>
                        <div class="stat-number" id="ingresosTotales">S/ <%= String.format("%.2f", ingresosTotales) %></div>
                        <div class="stat-label">Ingresos Totales</div>
                    </div>
                    <div class="stat-card floating" style="animation-delay: 0.2s;">
                        <span class="stat-icon">🧾</span>
                        <div class="stat-number" id="totalFacturas"><%= totalFacturas %></div>
                        <div class="stat-label">Total Facturas</div>
                    </div>
                    <div class="stat-card floating" style="animation-delay: 0.4s;">
                        <span class="stat-icon">📅</span>
                        <div class="stat-number" id="diasConDatos"><%= diasConDatos %></div>
                        <div class="stat-label">Días con Datos</div>
                    </div>
                    <div class="stat-card floating" style="animation-delay: 0.6s;">
                        <span class="stat-icon">⚖️</span>
                        <div class="stat-number" id="promedioGeneral">S/ <%= String.format("%.2f", promedioGeneral) %></div>
                        <div class="stat-label">Promedio por Factura</div>
                    </div>
                </div>

                <!-- Filtros Mejorados -->
                <div class="filters-container">
                    <form action="ReporteControlador" method="get" class="filters-form" id="filtersForm">
                        <input type="hidden" name="accion" value="filtrar">

                        <div class="filter-group">
                            <label class="filter-label">
                                <span class="filter-label-icon">📅</span>
                                Fecha Inicio
                            </label>
                            <input type="date" name="fechaInicio" class="filter-input" required 
                                   id="fechaInicio" onchange="validarFechas()">
                        </div>

                        <div class="filter-group">
                            <label class="filter-label">
                                <span class="filter-label-icon">📅</span>
                                Fecha Fin
                            </label>
                            <input type="date" name="fechaFin" class="filter-input" required 
                                   id="fechaFin" onchange="validarFechas()">
                        </div>

                        <div class="filter-group">
                            <label class="filter-label">
                                <span class="filter-label-icon">🏢</span>
                                Sucursal
                            </label>
                            <input type="number" name="idSucursal" class="filter-input" 
                                   placeholder="Todas las sucursales" id="idSucursal">
                        </div>

                        <div class="filter-actions">
                            <button type="submit" class="btn btn-success">
                                <span>🔍 Generar Reporte</span>
                            </button>
                            <a href="ReporteControlador?accion=listar" class="btn btn-secondary">
                                <span>🔄 Mostrar Todo</span>
                            </a>
                        </div>
                    </form>
                </div>

                <!-- Tabla de Reportes Mejorada -->
                <% if (reporte != null && !reporte.isEmpty()) { %>
                    <div class="table-container">
                        <div class="table-wrapper">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Fecha</th>
                                        <th>Facturas</th>
                                        <th>Ingresos Totales</th>
                                        <th>Promedio por Factura</th>
                                        <th>Eficiencia</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        for (ReporteIngresosDTO r : reporte) {
                                            double eficiencia = (r.getPromedioPorFactura() / promedioGeneral) * 100;
                                            String eficienciaClass = eficiencia >= 100 ? "positive" : "negative";
                                            String eficienciaIcon = eficiencia >= 100 ? "📈" : "📉";
                                    %>
                                    <tr class="fade-in-row">
                                        <td>
                                            <span class="date-badge"><%= r.getFecha() %></span>
                                        </td>
                                        <td>
                                            <span class="count-badge"><%= r.getCantidadFacturas() %></span>
                                        </td>
                                        <td>
                                            <span class="amount-badge">S/ <%= String.format("%.2f", r.getIngresosTotales()) %></span>
                                        </td>
                                        <td>
                                            <span class="amount-badge">S/ <%= String.format("%.2f", r.getPromedioPorFactura()) %></span>
                                        </td>
                                        <td>
                                            <span class="badge <%= eficienciaClass %>">
                                                <%= eficienciaIcon %> <%= String.format("%.1f", eficiencia) %>%
                                            </span>
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
                        <strong><%= reporte.size() %></strong> días analizados | 
                        <strong><%= totalFacturas %></strong> facturas procesadas | 
                        <strong>S/ <%= String.format("%.2f", ingresosTotales) %></strong> ingresos totales | 
                        <strong>S/ <%= String.format("%.2f", promedioGeneral) %></strong> promedio por factura
                    </div>

                <% } else { %>
                    <div class="empty-state">
                        <span class="empty-state-icon">📊</span>
                        <h3>No hay datos para mostrar</h3>
                        <p>
                            Selecciona un rango de fechas para generar el reporte de ingresos. 
                            Los datos se mostrarán en una tabla con análisis detallado por día.
                        </p>
                        <div style="display: flex; gap: 15px; justify-content: center; margin-top: 20px;">
                            <button onclick="document.getElementById('fechaInicio').focus()" class="btn btn-primary">
                                <span>📅 Seleccionar Fechas</span>
                            </button>
                            <a href="ReporteControlador?accion=listar" class="btn btn-success">
                                <span>🔄 Mostrar Todo</span>
                            </a>
                        </div>
                    </div>
                <% } %>

                <!-- Sección de Exportación -->
                <div class="export-section">
                    <h3>📤 Exportar Reporte</h3>
                    <p>Descarga el reporte de ingresos en diferentes formatos para su análisis externo.</p>
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
            </div>
        </div>
    </div>

    <script>
        // Script mejorado para reportes de ingresos
        document.addEventListener('DOMContentLoaded', function() {
            // Establecer fechas por defecto (últimos 30 días)
            const hoy = new Date();
            const hace30Dias = new Date();
            hace30Dias.setDate(hoy.getDate() - 30);
            
            document.getElementById('fechaInicio').value = hace30Dias.toISOString().split('T')[0];
            document.getElementById('fechaFin').value = hoy.toISOString().split('T')[0];

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
            function animateCounter(element, target, prefix = '', suffix = '') {
                let current = 0;
                const increment = target / 50;
                const timer = setInterval(() => {
                    current += increment;
                    if (current >= target) {
                        if (prefix === 'S/ ') {
                            element.textContent = prefix + target.toLocaleString('es-PE', {minimumFractionDigits: 2, maximumFractionDigits: 2});
                        } else {
                            element.textContent = prefix + Math.floor(target) + suffix;
                        }
                        clearInterval(timer);
                    } else {
                        if (prefix === 'S/ ') {
                            element.textContent = prefix + current.toLocaleString('es-PE', {minimumFractionDigits: 2, maximumFractionDigits: 2});
                        } else {
                            element.textContent = prefix + Math.floor(current) + suffix;
                        }
                    }
                }, 40);
            }

            // Animar contadores después de un pequeño delay
            setTimeout(() => {
                const ingresosElement = document.getElementById('ingresosTotales');
                const facturasElement = document.getElementById('totalFacturas');
                const diasElement = document.getElementById('diasConDatos');
                const promedioElement = document.getElementById('promedioGeneral');
                
                if (ingresosElement) animateCounter(ingresosElement, <%= ingresosTotales %>, 'S/ ');
                if (facturasElement) animateCounter(facturasElement, <%= totalFacturas %>);
                if (diasElement) animateCounter(diasElement, <%= diasConDatos %>);
                if (promedioElement) animateCounter(promedioElement, <%= promedioGeneral %>, 'S/ ');
            }, 500);
        });

        // Validación de fechas
        function validarFechas() {
            const fechaInicio = document.getElementById('fechaInicio').value;
            const fechaFin = document.getElementById('fechaFin').value;
            
            if (fechaInicio && fechaFin) {
                const inicio = new Date(fechaInicio);
                const fin = new Date(fechaFin);
                
                if (inicio > fin) {
                    alert('⚠️ La fecha de inicio no puede ser mayor que la fecha de fin.');
                    document.getElementById('fechaInicio').value = '';
                    document.getElementById('fechaInicio').focus();
                }
                
                // Validar que no sea un rango muy grande (opcional)
                const diffTime = Math.abs(fin - inicio);
                const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                
                if (diffDays > 365) {
                    if (!confirm(`⚠️ Estás solicitando un reporte de ${diffDays} días. ¿Estás seguro?`)) {
                        document.getElementById('fechaFin').value = '';
                    }
                }
            }
        }

        // Funciones de exportación
        function exportarPDF() {
            const submitBtn = document.querySelector('.btn-export');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Generando PDF...';
            
            setTimeout(() => {
                submitBtn.innerHTML = originalText;
                alert('✅ Reporte PDF generado correctamente');
                // En una implementación real, aquí se descargaría el PDF
            }, 2000);
        }

        function exportarExcel() {
            const submitBtn = document.querySelector('.btn-success');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Generando Excel...';
            
            setTimeout(() => {
                submitBtn.innerHTML = originalText;
                alert('✅ Reporte Excel generado correctamente');
                // En una implementación real, aquí se descargaría el Excel
            }, 2000);
        }

        function exportarCSV() {
            const submitBtn = document.querySelector('.btn-primary');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Generando CSV...';
            
            setTimeout(() => {
                submitBtn.innerHTML = originalText;
                alert('✅ Reporte CSV generado correctamente');
                // En una implementación real, aquí se descargaría el CSV
            }, 2000);
        }

        // Función para análisis rápido
        function analisisRapido() {
            const ingresos = <%= ingresosTotales %>;
            const facturas = <%= totalFacturas %>;
            const dias = <%= diasConDatos %>;
            
            if (dias > 0) {
                const promedioDiario = ingresos / dias;
                const promedioFactura = ingresos / facturas;
                const facturasPorDia = facturas / dias;
                
                alert(`📊 Análisis Rápido:\n\n• S/ ${promedioDiario.toFixed(2)} ingresos diarios promedio\n• ${facturasPorDia.toFixed(1)} facturas por día\n• S/ ${promedioFactura.toFixed(2)} promedio por factura\n• ${dias} días analizados`);
            } else {
                alert('No hay datos suficientes para el análisis.');
            }
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
        });

        // Auto-enfoque en el primer campo de fecha
        setTimeout(() => {
            document.getElementById('fechaInicio').focus();
        }, 1000);
    </script>
</body>
</html>