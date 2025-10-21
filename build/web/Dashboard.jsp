<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, modelo.MetricasDashboardDTO, modelo.EstadisticasMensualesDTO"%>
<%@page import="dao.DashboardDao"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Sistema PetCare</title>
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

        .user-info {
            padding: 25px 20px;
            display: flex;
            align-items: center;
            gap: 15px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            background: rgba(255, 255, 255, 0.05);
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
        }

        .menu-item:hover, .menu-item.active {
            background: rgba(255, 255, 255, 0.15);
            border-left-color: var(--white);
            transform: translateX(8px);
        }

        .menu-item a {
            color: var(--white);
            text-decoration: none;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 15px;
            width: 100%;
        }

        .menu-icon {
            font-size: 1.3em;
            width: 24px;
            text-align: center;
        }

        .main-content {
            flex: 1;
            padding: 40px;
            overflow-y: auto;
        }

        .header {
            background: var(--white);
            padding: 30px 40px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
            position: relative;
        }

        .header h1 {
            font-size: 2.2em;
            color: var(--text-dark);
            margin-bottom: 8px;
            font-weight: 700;
        }

        .header p {
            color: var(--text-light);
            font-size: 1.1em;
        }

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
            transition: all 0.4s ease;
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
            font-size: 1.1em;
            color: var(--text-light);
            font-weight: 500;
        }

        .chart-container {
            background: var(--white);
            padding: 30px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin: 30px 0;
        }

        .chart-title {
            font-size: 1.5em;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 20px;
            text-align: center;
        }

        .date-filter {
            background: var(--white);
            padding: 25px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
        }

        .filter-form {
            display: flex;
            gap: 20px;
            align-items: end;
        }

        .form-group {
            flex: 1;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--text-dark);
        }

        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e0e0e0;
            border-radius: var(--radius);
            font-size: 1em;
            transition: all 0.3s ease;
            background: var(--white);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(171, 203, 213, 0.1);
        }

        .btn {
            padding: 12px 24px;
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
            box-shadow: 0 4px 15px rgba(171, 203, 213, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(171, 203, 213, 0.4);
        }

        .btn-success {
            background: var(--gradient-success);
            color: var(--white);
        }

        .btn-info {
            background: linear-gradient(135deg, var(--info-color) 0%, #0b7dda 100%);
            color: var(--white);
        }

        .message {
            padding: 15px 20px;
            border-radius: var(--radius);
            margin: 20px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .message.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .message.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .message.info {
            background: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }

        .no-data {
            text-align: center;
            padding: 40px 20px;
            color: var(--text-light);
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Sidebar -->
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
                <li class="menu-item active">
                    <a href="Dashboard.jsp">
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
                <li class="menu-item">
                    <a href="ServicioControlador">
                        <span class="menu-icon">🛠️</span>
                        <span>Servicios</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="ListaDetallesServicios.jsp">
                        <span class="menu-icon">🔧</span>
                        <span>Detalles de Servicios</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="CrearDetalleServicio.jsp">
                        <span class="menu-icon">⚡</span>
                        <span>Crear Detalle Servicio</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="ListaPaquetesServicios.jsp">
                        <span class="menu-icon">📦</span>
                        <span>Paquetes de Servicios</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="CrearPaqueteServicio.jsp">
                        <span class="menu-icon">🎯</span>
                        <span>Crear Paquete Servicio</span>
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
                    <a href="ListaPagos.jsp">
                        <span class="menu-icon">💳</span>
                        <span>Lista de Pagos</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="RegistrarPago.jsp">
                        <span class="menu-icon">💰</span>
                        <span>Registrar Pago</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="ListaFacturas.jsp">
                        <span class="menu-icon">🧾</span>
                        <span>Lista de Facturas</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="CrearFactura.jsp">
                        <span class="menu-icon">📄</span>
                        <span>Crear Factura</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="ListaPromociones.jsp">
                        <span class="menu-icon">🎁</span>
                        <span>Lista de Promociones</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="CrearPromocion.jsp">
                        <span class="menu-icon">🎉</span>
                        <span>Crear Promoción</span>
                    </a>
                </li>
                
                <!-- Comunicaciones -->
                <div class="menu-section">Comunicaciones</div>
                <li class="menu-item">
                    <a href="ListaNotificaciones.jsp">
                        <span class="menu-icon">🔔</span>
                        <span>Lista de Notificaciones</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="CrearNotificacion.jsp">
                        <span class="menu-icon">📢</span>
                        <span>Crear Notificación</span>
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
                    <a href="ListaUsuarios.jsp">
                        <span class="menu-icon">👤</span>
                        <span>Lista de Usuarios</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="CrearUsuario.jsp">
                        <span class="menu-icon">👥</span>
                        <span>Crear Usuario</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="UtilidadesControlador">
                        <span class="menu-icon">🔧</span>
                        <span>Utilidades</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="ConfiguracionControlador?accion=listar">
                        <span class="menu-icon">⚙️</span>
                        <span>Configuración</span>
                    </a>
                </li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="header">
                <h1>📊 Dashboard Principal</h1>
                <p>Resumen general del sistema y métricas importantes</p>
            </div>

            <!-- Filtros de Fecha -->
            <div class="date-filter">
                <h3>🔍 Filtrar Métricas por Fecha</h3>
                <form action="DashboardControlador" method="post" class="filter-form">
                    <input type="hidden" name="accion" value="metricasRango">
                    
                    <div class="form-group">
                        <label for="fechaInicio">Fecha Inicio:</label>
                        <input type="date" id="fechaInicio" name="fechaInicio" class="form-control" 
                               value="${fechaInicio}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="fechaFin">Fecha Fin:</label>
                        <input type="date" id="fechaFin" name="fechaFin" class="form-control" 
                               value="${fechaFin}" required>
                    </div>
                    
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">
                            🔍 Consultar Métricas
                        </button>
                    </div>
                </form>
            </div>

            <!-- Mensajes -->
            <% if (request.getAttribute("mensaje") != null) { %>
                <div class="message <%= request.getAttribute("tipoMensaje") != null ? request.getAttribute("tipoMensaje") : "info" %>">
                    <%= request.getAttribute("mensaje") %>
                </div>
            <% } %>

            <!-- Métricas principales -->
            <% 
                MetricasDashboardDTO metricas = (MetricasDashboardDTO) request.getAttribute("metricas");
                if (metricas != null) { 
            %>
            <div class="stats-container">
                <div class="stat-card">
                    <span class="stat-icon">👥</span>
                    <div class="stat-number"><%= metricas.getTotalClientes() %></div>
                    <div class="stat-label">Total Clientes</div>
                </div>
                
                <div class="stat-card">
                    <span class="stat-icon">🐕</span>
                    <div class="stat-number"><%= metricas.getTotalMascotas() %></div>
                    <div class="stat-label">Total Mascotas</div>
                </div>
                
                <div class="stat-card">
                    <span class="stat-icon">📅</span>
                    <div class="stat-number"><%= metricas.getCitasHoy() %></div>
                    <div class="stat-label">Citas Hoy</div>
                </div>
                
                <div class="stat-card">
                    <span class="stat-icon">💰</span>
                    <div class="stat-number">$<%= String.format("%.2f", metricas.getIngresosMes()) %></div>
                    <div class="stat-label">Ingresos del Mes</div>
                </div>
                
                <div class="stat-card">
                    <span class="stat-icon">⏰</span>
                    <div class="stat-number"><%= metricas.getAtencionesCurso() %></div>
                    <div class="stat-label">Atenciones en Curso</div>
                </div>
            </div>
            <% } else { %>
            <div class="no-data">
                <p>No se han cargado métricas. Use los filtros de fecha para consultar.</p>
            </div>
            <% } %>

            <!-- Estadísticas Mensuales -->
            <div class="chart-container">
                <h3 class="chart-title">📈 Estadísticas Mensuales</h3>
                <form action="DashboardControlador" method="post" class="filter-form">
                    <input type="hidden" name="accion" value="estadisticasMensuales">
                    
                    <div class="form-group">
                        <label for="anio">Año:</label>
                        <select id="anio" name="anio" class="form-control">
                            <% 
                                int anioActual = java.time.LocalDate.now().getYear();
                                for (int i = anioActual; i >= anioActual - 5; i--) { 
                            %>
                            <option value="<%= i %>" <%= request.getAttribute("anioConsulta") != null && 
                                request.getAttribute("anioConsulta").equals(i) ? "selected" : "" %>><%= i %></option>
                            <% } %>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="mes">Mes:</label>
                        <select id="mes" name="mes" class="form-control">
                            <% 
                                String[] meses = {"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
                                                "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"};
                                for (int i = 1; i <= 12; i++) { 
                            %>
                            <option value="<%= i %>" <%= request.getAttribute("mesConsulta") != null && 
                                request.getAttribute("mesConsulta").equals(i) ? "selected" : "" %>><%= meses[i-1] %></option>
                            <% } %>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <button type="submit" class="btn btn-success">
                            📊 Ver Estadísticas
                        </button>
                    </div>
                </form>

                <% 
                    EstadisticasMensualesDTO estadisticas = (EstadisticasMensualesDTO) request.getAttribute("estadisticas");
                    if (estadisticas != null) { 
                %>
                <div class="stats-container">
                    <div class="stat-card">
                        <span class="stat-icon">💰</span>
                        <div class="stat-number">$<%= String.format("%.2f", estadisticas.getTotalFacturado()) %></div>
                        <div class="stat-label">Total Facturado</div>
                    </div>
                    
                    <div class="stat-card">
                        <span class="stat-icon">👥</span>
                        <div class="stat-number"><%= estadisticas.getClientesNuevos() %></div>
                        <div class="stat-label">Clientes Nuevos</div>
                    </div>
                    
                    <div class="stat-card">
                        <span class="stat-icon">🎯</span>
                        <div class="stat-number"><%= estadisticas.getAtencionesRealizadas() %></div>
                        <div class="stat-label">Atenciones Realizadas</div>
                    </div>
                    
                    <div class="stat-card">
                        <span class="stat-icon">⭐</span>
                        <div class="stat-number" style="font-size: 1.2em;"><%= estadisticas.getServicioPopular() != null ? estadisticas.getServicioPopular() : "N/A" %></div>
                        <div class="stat-label">Servicio Más Popular</div>
                    </div>
                </div>
                <% } %>
            </div>

            <!-- Acciones Rápidas -->
            <div class="chart-container">
                <h3 class="chart-title">🚀 Acciones Rápidas</h3>
                <div class="stats-container">
                    <a href="ProximasCitas.jsp" class="btn btn-primary" style="justify-content: center; padding: 20px;">
                        📅 Ver Citas del Día
                    </a>
                    <a href="ColaAtencion.jsp" class="btn btn-success" style="justify-content: center; padding: 20px;">
                        ⏰ Cola de Atención
                    </a>
                    <a href="ReporteIngresos.jsp" class="btn btn-info" style="justify-content: center; padding: 20px;">
                        📊 Generar Reporte
                    </a>
                    <a href="UtilidadesNotificaciones.jsp" class="btn btn-primary" style="justify-content: center; padding: 20px;">
                        🔔 Notificaciones
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>