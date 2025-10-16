<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, modelo.ServicioMasSolicitadoDTO, java.sql.Date" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Servicios Más Solicitados - Sistema PetCare</title>
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
            transition: all 0.4s ease;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 15px;
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
        }

        .exito {
            background: #f0f9f4;
            border-left-color: var(--success-color);
            color: #2e7d32;
        }

        .error {
            background: #fdf2f2;
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
            transition: all 0.3s ease;
            font-size: 0.95em;
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
            background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
            color: var(--white);
        }

        .btn-success:hover {
            transform: translateY(-3px);
        }

        .btn-secondary {
            background: linear-gradient(135deg, var(--secondary-color) 0%, #c9b18c 100%);
            color: var(--text-dark);
        }

        .btn-secondary:hover {
            transform: translateY(-3px);
        }

        .btn-info {
            background: linear-gradient(135deg, var(--info-color) 0%, #0b7dda 100%);
            color: var(--white);
        }

        .btn-info:hover {
            transform: translateY(-3px);
        }

        .btn-small {
            padding: 12px 20px;
            font-size: 0.9em;
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

        .filter-form {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            align-items: end;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .form-group label {
            font-weight: 600;
            color: var(--text-dark);
            font-size: 0.95em;
        }

        .form-control {
            padding: 14px 16px;
            border: 1px solid #e0e0e0;
            border-radius: var(--radius);
            font-size: 1em;
            transition: all 0.3s ease;
            background-color: #fcfcfc;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(171, 203, 213, 0.2);
            background-color: var(--white);
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
            transition: all 0.3s ease;
            position: relative;
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

        /* Table Container */
        .table-container {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 40px;
            border: 1px solid rgba(0, 0, 0, 0.05);
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
        }

        tr:hover {
            background: rgba(171, 203, 213, 0.05);
        }

        /* Ranking Badges */
        .ranking-badge {
            background: var(--warning-color);
            color: var(--text-dark);
            padding: 10px 16px;
            border-radius: 50%;
            font-weight: bold;
            font-size: 1.1em;
            margin-right: 10px;
            box-shadow: 0 4px 12px rgba(255, 193, 7, 0.3);
            border: 2px solid #ffb300;
        }

        .ranking-gold {
            background: linear-gradient(135deg, #FFD700 0%, #FFA500 100%);
            color: #000;
            border-color: #FF8C00;
        }

        .ranking-silver {
            background: linear-gradient(135deg, #C0C0C0 0%, #A9A9A9 100%);
            color: #000;
            border-color: #808080;
        }

        .ranking-bronze {
            background: linear-gradient(135deg, #CD7F32 0%, #8B4513 100%);
            color: #fff;
            border-color: #654321;
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

        /* Navigation */
        .navigation {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            justify-content: center;
            flex-wrap: wrap;
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
                grid-template-columns: 1fr;
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
            .filter-container {
                padding: 20px;
            }
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
            background: #e3f2fd;
            color: #1565c0;
            border-color: #90caf9;
        }

        .categoria-corte {
            background: #f3e5f5;
            color: #7b1fa2;
            border-color: #ce93d8;
        }

        .categoria-dental {
            background: #e8f5e8;
            color: #2e7d32;
            border-color: #a5d6a7;
        }

        .categoria-paquete {
            background: #fff3e0;
            color: #ef6c00;
            border-color: #ffb74d;
        }

        .categoria-otro {
            background: #f5f5f5;
            color: #616161;
            border-color: #bdbdbd;
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
                <li class="menu-item">
                    <a href="ServicioControlador">
                        <span class="menu-icon">🛠️</span>
                        <span>Servicios</span>
                    </a>
                </li>
                <li class="menu-item active">
                    <a href="ServicioControlador?accion=serviciosMasSolicitados">
                        <span class="menu-icon">📊</span>
                        <span>Estadísticas</span>
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
                        <h1>📊 Servicios Más Solicitados</h1>
                        <p>Análisis estadístico de los servicios más populares</p>
                    </div>
                    <div class="header-actions">
                        <a href="ServicioControlador" class="btn btn-secondary">📋 Volver a Servicios</a>
                        <a href="ServicioControlador?accion=serviciosMasSolicitados" class="btn btn-info">🔄 Actualizar</a>
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

                <!-- Formulario de filtros -->
                <div class="filter-container">
                    <div class="filter-header">
                        <span class="filter-icon">🔍</span>
                        <span class="filter-title">Filtrar por Fecha</span>
                    </div>
                    <form action="ServicioControlador" method="GET" class="filter-form">
                        <input type="hidden" name="accion" value="serviciosMasSolicitados">
                        
                        <div class="form-group">
                            <label for="fechaInicio">Fecha Inicio:</label>
                            <input type="date" id="fechaInicio" name="fechaInicio" class="form-control"
                                   value="<%= request.getAttribute("fechaInicio") != null ? request.getAttribute("fechaInicio") : "" %>">
                        </div>
                        
                        <div class="form-group">
                            <label for="fechaFin">Fecha Fin:</label>
                            <input type="date" id="fechaFin" name="fechaFin" class="form-control"
                                   value="<%= request.getAttribute("fechaFin") != null ? request.getAttribute("fechaFin") : "" %>">
                        </div>
                        
                        <div class="form-group">
                            <label>&nbsp;</label>
                            <div style="display: flex; gap: 10px;">
                                <button type="submit" class="btn btn-primary">🔍 Generar Reporte</button>
                                <a href="ServicioControlador?accion=serviciosMasSolicitados" class="btn btn-secondary">🔄 Limpiar Filtros</a>
                            </div>
                        </div>
                    </form>
                </div>

                <%
                    List<ServicioMasSolicitadoDTO> servicios = (List<ServicioMasSolicitadoDTO>) request.getAttribute("serviciosMasSolicitados");
                    Date fechaInicio = (Date) request.getAttribute("fechaInicio");
                    Date fechaFin = (Date) request.getAttribute("fechaFin");
                    
                    // Calcular totales
                    double totalIngresos = 0;
                    int totalSolicitudes = 0;
                    if (servicios != null && !servicios.isEmpty()) {
                        for (ServicioMasSolicitadoDTO servicio : servicios) {
                            totalIngresos += servicio.getIngresosGenerados();
                            totalSolicitudes += servicio.getVecesSolicitado();
                        }
                    }
                %>

                <!-- Estadísticas -->
                <% if (servicios != null && !servicios.isEmpty()) { %>
                    <div class="stats-container">
                        <div class="stat-card">
                            <span class="stat-icon">📈</span>
                            <div class="stat-number"><%= servicios.size() %></div>
                            <div class="stat-label">Servicios Analizados</div>
                        </div>
                        <div class="stat-card">
                            <span class="stat-icon">💰</span>
                            <div class="stat-number">
                                S/ <%= String.format("%.0f", totalIngresos) %>
                            </div>
                            <div class="stat-label">Ingresos Totales</div>
                        </div>
                        <div class="stat-card">
                            <span class="stat-icon">🔄</span>
                            <div class="stat-number">
                                <%= totalSolicitudes %>
                            </div>
                            <div class="stat-label">Total Solicitudes</div>
                        </div>
                        <div class="stat-card">
                            <span class="stat-icon">⭐</span>
                            <div class="stat-number"><%= servicios.get(0).getNombre() %></div>
                            <div class="stat-label">Servicio #1</div>
                        </div>
                    </div>

                    <!-- Información del período -->
                    <div style="text-align: center; margin: 25px 0;">
                        <h3 style="color: var(--text-dark); margin-bottom: 10px;">
                            📅 Período Analizado
                        </h3>
                        <p style="color: var(--text-light); font-size: 1.1em;">
                            <%= fechaInicio != null ? fechaInicio.toString() : "Todo el tiempo" %> 
                            <%= fechaFin != null ? " - " + fechaFin.toString() : "" %>
                        </p>
                    </div>

                    <!-- Tabla de ranking -->
                    <div class="table-container">
                        <h3 style="padding: 25px; margin: 0; color: var(--text-dark); border-bottom: 1px solid rgba(0,0,0,0.1);">
                            🏆 Ranking de Servicios Más Solicitados
                        </h3>

                        <table>
                            <thead>
                                <tr>
                                    <th style="width: 100px;">Posición</th>
                                    <th>Servicio</th>
                                    <th style="width: 140px;">Categoría</th>
                                    <th style="width: 120px;">Veces Solicitado</th>
                                    <th style="width: 120px;">Cantidad Total</th>
                                    <th style="width: 150px;">Ingresos Generados (S/)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                int posicion = 1;
                                for (ServicioMasSolicitadoDTO servicio : servicios) { 
                                    String rankingClass = "";
                                    if (posicion == 1) {
                                        rankingClass = "ranking-gold";
                                    } else if (posicion == 2) {
                                        rankingClass = "ranking-silver";
                                    } else if (posicion == 3) {
                                        rankingClass = "ranking-bronze";
                                    }
                                %>
                                    <tr>
                                        <td style="text-align: center;">
                                            <% if (posicion <= 3) { %>
                                                <span class="ranking-badge <%= rankingClass %>"><%= posicion %></span>
                                            <% } else { %>
                                                <span style="font-weight: bold; color: var(--text-light);"><%= posicion %></span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <strong style="color: var(--text-dark);">
                                                <%= servicio.getNombre() %>
                                            </strong>
                                        </td>
                                        <td>
                                            <%
                                                String categoriaClass = "categoria-" + servicio.getCategoria().replace("á", "a").toLowerCase();
                                            %>
                                            <span class="categoria-badge <%= categoriaClass %>">
                                                <%= servicio.getCategoria().toUpperCase() %>
                                            </span>
                                        </td>
                                        <td style="text-align: center;">
                                            <span style="font-weight: bold; color: #e91e63; font-size: 1.1em;">
                                                <%= servicio.getVecesSolicitado() %>
                                            </span>
                                        </td>
                                        <td style="text-align: center;">
                                            <span style="color: var(--info-color); font-weight: 600;">
                                                <%= servicio.getCantidadTotal() %>
                                            </span>
                                        </td>
                                        <td style="text-align: right;">
                                            <span style="font-weight: bold; color: var(--success-color); font-size: 1.1em;">
                                                S/ <%= String.format("%.2f", servicio.getIngresosGenerados()) %>
                                            </span>
                                        </td>
                                    </tr>
                                <% 
                                    posicion++;
                                } 
                                %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <div class="empty-state">
                        <h3>📊 No hay datos de servicios solicitados</h3>
                        <p>No se encontraron servicios en el período seleccionado</p>
                        <a href="ServicioControlador?accion=serviciosMasSolicitados" class="btn btn-primary">
                            🔄 Intentar con otro período
                        </a>
                    </div>
                <% } %>

                <!-- Botones de navegación -->
                <div class="navigation">
                    <a href="ServicioControlador" class="btn btn-secondary">📋 Volver a Servicios</a>
                    <a href="ServicioControlador?accion=serviciosMasSolicitados" class="btn btn-info">🔄 Actualizar Reporte</a>
                    <a href="dashboard.jsp" class="btn btn-primary">📊 Ir al Dashboard</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Script para manejar la interacción del menú
        document.addEventListener('DOMContentLoaded', function() {
            const menuItems = document.querySelectorAll('.menu-item');
            
            menuItems.forEach(function(item) {
                item.addEventListener('click', function() {
                    menuItems.forEach(function(i) {
                        i.classList.remove('active');
                    });
                    this.classList.add('active');
                });
            });

            // Set fecha por defecto (últimos 30 días)
            const fechaFinInput = document.getElementById('fechaFin');
            const fechaInicioInput = document.getElementById('fechaInicio');
            
            if (fechaFinInput && !fechaFinInput.value) {
                const today = new Date();
                fechaFinInput.value = today.toISOString().split('T')[0];
                
                const lastMonth = new Date();
                lastMonth.setDate(today.getDate() - 30);
                fechaInicioInput.value = lastMonth.toISOString().split('T')[0];
            }
        });
    </script>
</body>
</html>