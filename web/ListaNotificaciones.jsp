<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, modelo.NotificacionClienteDTO, modelo.Notificacion"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Notificaciones - Sistema PetCare</title>
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

        .actions-panel {
            background: var(--white);
            padding: 25px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .filters-panel {
            background: var(--white);
            padding: 25px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
        }

        .filters-form {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr auto;
            gap: 15px;
            align-items: end;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--text-dark);
        }

        .form-control {
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

        .btn-warning {
            background: var(--gradient-warning);
            color: var(--text-dark);
        }

        .btn-danger {
            background: var(--gradient-danger);
            color: var(--white);
        }

        .btn-info {
            background: linear-gradient(135deg, var(--info-color) 0%, #0b7dda 100%);
            color: var(--white);
        }

        .notifications-container {
            display: grid;
            gap: 20px;
        }

        .notification-card {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            border-left: 5px solid var(--info-color);
            transition: transform 0.3s ease;
        }

        .notification-card:hover {
            transform: translateY(-2px);
        }

        .notification-card.unread {
            border-left-color: var(--warning-color);
            background: linear-gradient(135deg, rgba(255, 193, 7, 0.05) 0%, var(--white) 100%);
        }

        .notification-card.success {
            border-left-color: var(--success-color);
        }

        .notification-card.warning {
            border-left-color: var(--warning-color);
        }

        .notification-card.error {
            border-left-color: var(--danger-color);
        }

        .notification-header {
            padding: 20px 25px;
            border-bottom: 1px solid #f0f0f0;
            display: flex;
            justify-content: space-between;
            align-items: start;
        }

        .notification-title {
            font-size: 1.2em;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 5px;
        }

        .notification-meta {
            color: var(--text-light);
            font-size: 0.9em;
        }

        .notification-actions {
            display: flex;
            gap: 10px;
        }

        .notification-body {
            padding: 20px 25px;
        }

        .notification-message {
            color: var(--text-dark);
            line-height: 1.6;
            margin-bottom: 15px;
        }

        .notification-details {
            background: var(--bg-light);
            padding: 15px;
            border-radius: 8px;
            font-size: 0.9em;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 500;
        }

        .status-badge.leida {
            background: #d4edda;
            color: #155724;
        }

        .status-badge.no_leida {
            background: #fff3cd;
            color: #856404;
        }

        .priority-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.75em;
            font-weight: 600;
            text-transform: uppercase;
        }

        .priority-badge.alta {
            background: #f8d7da;
            color: #721c24;
        }

        .priority-badge.media {
            background: #fff3cd;
            color: #856404;
        }

        .priority-badge.baja {
            background: #d1ecf1;
            color: #0c5460;
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
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
        }

        .stats-panel {
            background: var(--white);
            padding: 20px 25px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }

        .stat-item {
            text-align: center;
            padding: 15px;
            background: var(--bg-light);
            border-radius: 12px;
        }

        .stat-number {
            font-size: 1.8em;
            font-weight: 700;
            color: var(--primary-dark);
        }

        .stat-label {
            color: var(--text-light);
            font-size: 0.9em;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="logo">
                <h1>🐾 PetCare</h1>
            </div>
            
            <div class="user-info">
                <div class="user-avatar" style="width: 50px; height: 50px; border-radius: 50%; background: rgba(255, 255, 255, 0.2); display: flex; align-items: center; justify-content: center; font-weight: bold;">👨‍⚕️</div>
                <div class="user-details">
                    <h3>Dr. Admin</h3>
                    <p>Administrador</p>
                </div>
            </div>

            <ul class="menu">
                <li class="menu-item">
                    <span>📊</span>
                    <a href="Menu.jsp">Dashboard</a>
                </li>
                <li class="menu-item">
                    <span>👥</span>
                    <a href="ListaClientes.jsp">Clientes</a>
                </li>
                <li class="menu-item">
                    <span>🐕</span>
                    <a href="ListaMascotas.jsp">Mascotas</a>
                </li>
                <li class="menu-item">
                    <span>👨‍⚕️</span>
                    <a href="ListaGroomers.jsp">Groomers</a>
                </li>
                <li class="menu-item">
                    <span>🎯</span>
                    <a href="ListaServicios.jsp">Servicios</a>
                </li>
                <li class="menu-item">
                    <span>📅</span>
                    <a href="ProximasCitas.jsp">Citas</a>
                </li>
                <li class="menu-item">
                    <span>⏰</span>
                    <a href="ColaAtencion.jsp">Cola de Atención</a>
                </li>
                <li class="menu-item">
                    <span>💰</span>
                    <a href="UtilidadesFacturas.jsp">Facturas</a>
                </li>
                <li class="menu-item">
                    <span>💳</span>
                    <a href="ListaPagos.jsp">Pagos</a>
                </li>
                <li class="menu-item">
                    <span>📋</span>
                    <a href="ListaPaquetesServicios.jsp">Paquetes</a>
                </li>
                <li class="menu-item">
                    <span>🎁</span>
                    <a href="ListaPromociones.jsp">Promociones</a>
                </li>
                <li class="menu-item active">
                    <span>🔔</span>
                    <a href="UtilidadesNotificaciones.jsp">Notificaciones</a>
                </li>
                <li class="menu-item">
                    <span>👤</span>
                    <a href="ListaUsuarios.jsp">Usuarios</a>
                </li>
                <li class="menu-item">
                    <span>📊</span>
                    <a href="ReporteIngresos.jsp">Reportes</a>
                </li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="header">
                <h1>🔔 Centro de Notificaciones</h1>
                <p>Gestiona todas las notificaciones del sistema veterinario</p>
            </div>

            <!-- Estadísticas -->
            <div class="stats-panel">
                <div class="stats-grid">
                    <div class="stat-item">
                        <div class="stat-number">${totalNotificaciones != null ? totalNotificaciones : 0}</div>
                        <div class="stat-label">Total Notificaciones</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">${notificacionesNoLeidas != null ? notificacionesNoLeidas : 0}</div>
                        <div class="stat-label">Sin Leer</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">${notificacionesHoy != null ? notificacionesHoy : 0}</div>
                        <div class="stat-label">Hoy</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">${notificacionesUrgentes != null ? notificacionesUrgentes : 0}</div>
                        <div class="stat-label">Urgentes</div>
                    </div>
                </div>
            </div>

            <!-- Panel de Acciones -->
            <div class="actions-panel">
                <a href="CrearNotificacion.jsp" class="btn btn-success">
                    ➕ Nueva Notificación
                </a>
                <a href="NotificacionControlador?accion=listarTodas" class="btn btn-primary">
                    📋 Todas las Notificaciones
                </a>
                <a href="NotificacionControlador?accion=marcarTodasLeidas" class="btn btn-warning">
                    ✅ Marcar Todas como Leídas
                </a>
                <a href="NotificacionControlador?accion=limpiarNotificaciones" class="btn btn-danger"
                   onclick="return confirm('¿Está seguro de limpiar las notificaciones leídas?')">
                    🗑️ Limpiar Leídas
                </a>
            </div>

            <!-- Panel de Filtros -->
            <div class="filters-panel">
                <h3>🔍 Filtros de Notificaciones</h3>
                <form action="NotificacionControlador" method="post" class="filters-form">
                    <input type="hidden" name="accion" value="filtrarNotificaciones">
                    
                    <div class="form-group">
                        <label for="estado">Estado:</label>
                        <select id="estado" name="estado" class="form-control">
                            <option value="">Todos los estados</option>
                            <option value="LEIDA" ${estadoSeleccionado == 'LEIDA' ? 'selected' : ''}>Leídas</option>
                            <option value="NO_LEIDA" ${estadoSeleccionado == 'NO_LEIDA' ? 'selected' : ''}>Sin Leer</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="tipo">Tipo:</label>
                        <select id="tipo" name="tipo" class="form-control">
                            <option value="">Todos los tipos</option>
                            <option value="CITA_RECORDATORIO" ${tipoSeleccionado == 'CITA_RECORDATORIO' ? 'selected' : ''}>Recordatorio de Cita</option>
                            <option value="PAGO_PENDIENTE" ${tipoSeleccionado == 'PAGO_PENDIENTE' ? 'selected' : ''}>Pago Pendiente</option>
                            <option value="PROMOCION" ${tipoSeleccionado == 'PROMOCION' ? 'selected' : ''}>Promoción</option>
                            <option value="SISTEMA" ${tipoSeleccionado == 'SISTEMA' ? 'selected' : ''}>Sistema</option>
                            <option value="EMERGENCIA" ${tipoSeleccionado == 'EMERGENCIA' ? 'selected' : ''}>Emergencia</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="fechaDesde">Desde:</label>
                        <input type="date" id="fechaDesde" name="fechaDesde" class="form-control" 
                               value="${fechaDesde}">
                    </div>
                    
                    <button type="submit" class="btn btn-primary">🔍 Filtrar</button>
                </form>
            </div>

            <!-- Mensajes -->
            <% if (request.getAttribute("mensaje") != null) { %>
                <div class="message <%= request.getAttribute("tipoMensaje") != null ? request.getAttribute("tipoMensaje") : "info" %>">
                    <%= request.getAttribute("mensaje") %>
                </div>
            <% } %>

            <!-- Lista de Notificaciones -->
            <div class="notifications-container">
                <% 
                    List<NotificacionClienteDTO> notificaciones = (List<NotificacionClienteDTO>) request.getAttribute("notificaciones");
                    if (notificaciones != null && !notificaciones.isEmpty()) {
                        for (NotificacionClienteDTO notificacion : notificaciones) {
                %>
                <div class="notification-card <%= notificacion.getEstado().equals("NO_LEIDA") ? "unread" : "" %> <%= notificacion.getTipo().toLowerCase() %>">
                    <div class="notification-header">
                        <div>
                            <div class="notification-title">
                                <%= getIconoTipo(notificacion.getTipo()) %> <%= notificacion.getTitulo() %>
                                <span class="priority-badge <%= notificacion.getPrioridad().toLowerCase() %>">
                                    <%= notificacion.getPrioridad() %>
                                </span>
                            </div>
                            <div class="notification-meta">
                                📅 <%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(notificacion.getFechaCreacion()) %>
                                • 👤 <%= notificacion.getNombreCliente() %> <%= notificacion.getApellidoCliente() %>
                                • 📱 <%= notificacion.getTelefonoCliente() %>
                            </div>
                        </div>
                        <div class="notification-actions">
                            <span class="status-badge <%= notificacion.getEstado().toLowerCase() %>">
                                <%= notificacion.getEstado().replace("_", " ") %>
                            </span>
                            <% if ("NO_LEIDA".equals(notificacion.getEstado())) { %>
                            <a href="NotificacionControlador?accion=marcarLeida&idNotificacion=<%= notificacion.getIdNotificacion() %>" 
                               class="btn btn-primary" style="font-size: 0.8em; padding: 6px 12px;">
                                ✅ Marcar Leída
                            </a>
                            <% } %>
                        </div>
                    </div>
                    
                    <div class="notification-body">
                        <div class="notification-message">
                            <%= notificacion.getMensaje() %>
                        </div>
                        
                        <% if (notificacion.getMetadatos() != null && !notificacion.getMetadatos().trim().isEmpty()) { %>
                        <div class="notification-details">
                            <strong>📋 Detalles adicionales:</strong><br>
                            <%= notificacion.getMetadatos() %>
                        </div>
                        <% } %>
                        
                        <% if (notificacion.getFechaLectura() != null) { %>
                        <div style="margin-top: 15px; color: var(--text-light); font-size: 0.9em;">
                            ✅ Leído el: <%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(notificacion.getFechaLectura()) %>
                        </div>
                        <% } %>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <div class="no-data">
                    🔔 No hay notificaciones para mostrar
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <%!
        public String getIconoTipo(String tipo) {
            switch (tipo) {
                case "CITA_RECORDATORIO": return "📅";
                case "PAGO_PENDIENTE": return "💰";
                case "PROMOCION": return "🎁";
                case "SISTEMA": return "⚙️";
                case "EMERGENCIA": return "🚨";
                default: return "🔔";
            }
        }
    %>
</body>
</html>