<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, modelo.Promocion"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Promociones - Sistema PetCare</title>
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

        .stats-panel {
            background: var(--white);
            padding: 25px;
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
            padding: 20px;
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
            margin-top: 5px;
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

        .promotions-container {
            display: grid;
            gap: 25px;
        }

        .promotion-card {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            transition: all 0.3s ease;
            border-left: 5px solid;
        }

        .promotion-card.activa {
            border-left-color: var(--success-color);
        }

        .promotion-card.inactiva {
            border-left-color: var(--danger-color);
        }

        .promotion-card.proximamente {
            border-left-color: var(--warning-color);
        }

        .promotion-card.vencida {
            border-left-color: #6c757d;
            opacity: 0.7;
        }

        .promotion-card:hover {
            transform: translateY(-5px);
        }

        .promotion-header {
            background: linear-gradient(135deg, var(--accent-color) 0%, #c299b8 100%);
            color: var(--white);
            padding: 25px;
            text-align: center;
        }

        .promotion-badge {
            background: rgba(255, 255, 255, 0.2);
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.8em;
            margin-bottom: 10px;
            display: inline-block;
        }

        .promotion-title {
            font-size: 1.4em;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .promotion-discount {
            font-size: 2.5em;
            font-weight: 800;
            margin-bottom: 5px;
        }

        .promotion-body {
            padding: 25px;
        }

        .promotion-description {
            color: var(--text-light);
            margin-bottom: 20px;
            line-height: 1.6;
        }

        .promotion-details {
            background: var(--bg-light);
            padding: 15px;
            border-radius: 12px;
            margin-bottom: 20px;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 0;
            border-bottom: 1px solid #dee2e6;
        }

        .detail-row:last-child {
            border-bottom: none;
        }

        .detail-label {
            font-weight: 500;
            color: var(--text-dark);
        }

        .detail-value {
            color: var(--text-light);
        }

        .promotion-conditions {
            font-size: 0.9em;
            color: var(--text-light);
            font-style: italic;
            border-top: 1px solid #dee2e6;
            padding-top: 15px;
            margin-top: 15px;
        }

        .promotion-actions {
            padding: 20px 25px;
            display: flex;
            gap: 10px;
            justify-content: center;
            border-top: 1px solid #f0f0f0;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 500;
        }

        .status-badge.activa {
            background: #d4edda;
            color: #155724;
        }

        .status-badge.inactiva {
            background: #f8d7da;
            color: #721c24;
        }

        .status-badge.proximamente {
            background: #fff3cd;
            color: #856404;
        }

        .status-badge.vencida {
            background: #e2e3e5;
            color: #383d41;
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
            padding: 60px 20px;
            color: var(--text-light);
            font-style: italic;
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
        }

        .no-data .icon {
            font-size: 3em;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .urgency-indicator {
            position: absolute;
            top: 15px;
            right: 15px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            animation: pulse 2s infinite;
        }

        .urgency-indicator.red {
            background: var(--danger-color);
        }

        .urgency-indicator.yellow {
            background: var(--warning-color);
        }

        @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.5; }
            100% { opacity: 1; }
        }

        @media (max-width: 768px) {
            .filters-form {
                grid-template-columns: 1fr;
            }
            
            .stats-grid {
                grid-template-columns: 1fr 1fr;
            }
            
            .promotion-actions {
                flex-direction: column;
            }
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
                <li class="menu-item active">
                    <span>🎁</span>
                    <a href="ListaPromociones.jsp">Promociones</a>
                </li>
                <li class="menu-item">
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
                <h1>🎁 Promociones Especiales</h1>
                <p>Gestiona ofertas y descuentos especiales para atraer más clientes</p>
            </div>

            <!-- Estadísticas -->
            <div class="stats-panel">
                <h3>📊 Estadísticas de Promociones</h3>
                <div class="stats-grid">
                    <div class="stat-item">
                        <div class="stat-number">${totalPromociones != null ? totalPromociones : 0}</div>
                        <div class="stat-label">Total Promociones</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">${promocionesActivas != null ? promocionesActivas : 0}</div>
                        <div class="stat-label">Promociones Activas</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">${promocionesUsadas != null ? promocionesUsadas : 0}</div>
                        <div class="stat-label">Veces Utilizadas</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">${descuentoTotal != null ? "$" + String.format("%.0f", descuentoTotal) : "$0"}</div>
                        <div class="stat-label">Total Ahorrado</div>
                    </div>
                </div>
            </div>

            <!-- Panel de Acciones -->
            <div class="actions-panel">
                <a href="CrearPromocion.jsp" class="btn btn-success">
                    ➕ Nueva Promoción
                </a>
                <a href="PromocionControlador?accion=listarTodas" class="btn btn-primary">
                    📋 Todas las Promociones
                </a>
                <a href="PromocionControlador?accion=promocionesActivas" class="btn btn-info">
                    ⚡ Promociones Activas
                </a>
                <a href="PromocionControlador?accion=promocionesVencidas" class="btn btn-warning">
                    ⏰ Próximas a Vencer
                </a>
            </div>

            <!-- Panel de Filtros -->
            <div class="filters-panel">
                <h3>🔍 Filtros de Promociones</h3>
                <form action="PromocionControlador" method="post" class="filters-form">
                    <input type="hidden" name="accion" value="buscarPromociones">
                    
                    <div class="form-group">
                        <label for="termino">Buscar Promoción:</label>
                        <input type="text" id="termino" name="termino" class="form-control" 
                               placeholder="Nombre o código..." value="${terminoBusqueda}">
                    </div>
                    
                    <div class="form-group">
                        <label for="estado">Estado:</label>
                        <select id="estado" name="estado" class="form-control">
                            <option value="">Todos los estados</option>
                            <option value="ACTIVA" ${estadoSeleccionado == 'ACTIVA' ? 'selected' : ''}>Activas</option>
                            <option value="INACTIVA" ${estadoSeleccionado == 'INACTIVA' ? 'selected' : ''}>Inactivas</option>
                            <option value="VENCIDA" ${estadoSeleccionado == 'VENCIDA' ? 'selected' : ''}>Vencidas</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="tipoDescuento">Tipo:</label>
                        <select id="tipoDescuento" name="tipoDescuento" class="form-control">
                            <option value="">Todos los tipos</option>
                            <option value="PORCENTAJE" ${tipoSeleccionado == 'PORCENTAJE' ? 'selected' : ''}>Porcentaje</option>
                            <option value="MONTO_FIJO" ${tipoSeleccionado == 'MONTO_FIJO' ? 'selected' : ''}>Monto Fijo</option>
                        </select>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">🔍 Buscar</button>
                </form>
            </div>

            <!-- Mensajes -->
            <% if (request.getAttribute("mensaje") != null) { %>
                <div class="message <%= request.getAttribute("tipoMensaje") != null ? request.getAttribute("tipoMensaje") : "info" %>">
                    <%= request.getAttribute("mensaje") %>
                </div>
            <% } %>

            <!-- Lista de Promociones -->
            <div class="promotions-container">
                <% 
                    List<Promocion> promociones = (List<Promocion>) request.getAttribute("promociones");
                    if (promociones != null && !promociones.isEmpty()) {
                        java.util.Date fechaActual = new java.util.Date();
                        for (Promocion promocion : promociones) {
                            // Determinar el estado actual de la promoción
                            String estadoActual = "inactiva";
                            if ("ACTIVA".equals(promocion.getEstado())) {
                                if (promocion.getFechaInicio().after(fechaActual)) {
                                    estadoActual = "proximamente";
                                } else if (promocion.getFechaFin().before(fechaActual)) {
                                    estadoActual = "vencida";
                                } else {
                                    estadoActual = "activa";
                                }
                            }
                            
                            // Calcular días restantes
                            long diasRestantes = 0;
                            if (promocion.getFechaFin() != null && promocion.getFechaFin().after(fechaActual)) {
                                diasRestantes = (promocion.getFechaFin().getTime() - fechaActual.getTime()) / (1000 * 60 * 60 * 24);
                            }
                %>
                <div class="promotion-card <%= estadoActual %>">
                    <% if (estadoActual.equals("activa") && diasRestantes <= 3) { %>
                    <div class="urgency-indicator <%= diasRestantes <= 1 ? "red" : "yellow" %>"></div>
                    <% } %>
                    
                    <div class="promotion-header">
                        <div class="promotion-badge">
                            <%= estadoActual.equals("activa") ? "🔥 ACTIVA" : 
                                estadoActual.equals("proximamente") ? "⏰ PRÓXIMAMENTE" :
                                estadoActual.equals("vencida") ? "❌ VENCIDA" : "⏸️ INACTIVA" %>
                        </div>
                        <div class="promotion-title"><%= promocion.getNombre() %></div>
                        <div class="promotion-discount">
                            <% if ("PORCENTAJE".equals(promocion.getTipoDescuento())) { %>
                                <%= String.format("%.0f", promocion.getValorDescuento()) %>% OFF
                            <% } else { %>
                                $<%= String.format("%.0f", promocion.getValorDescuento()) %> OFF
                            <% } %>
                        </div>
                        <% if (estadoActual.equals("activa") && diasRestantes > 0) { %>
                        <div style="font-size: 0.9em; opacity: 0.9;">
                            ⏰ <%= diasRestantes %> día<%= diasRestantes != 1 ? "s" : "" %> restante<%= diasRestantes != 1 ? "s" : "" %>
                        </div>
                        <% } %>
                    </div>
                    
                    <div class="promotion-body">
                        <% if (promocion.getDescripcion() != null && !promocion.getDescripcion().trim().isEmpty()) { %>
                        <div class="promotion-description">
                            <%= promocion.getDescripcion() %>
                        </div>
                        <% } %>
                        
                        <div class="promotion-details">
                            <div class="detail-row">
                                <span class="detail-label">📄 Código:</span>
                                <span class="detail-value"><strong><%= promocion.getCodigo() %></strong></span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">📅 Vigencia:</span>
                                <span class="detail-value">
                                    <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(promocion.getFechaInicio()) %> - 
                                    <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(promocion.getFechaFin()) %>
                                </span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">🎯 Usos:</span>
                                <span class="detail-value">
                                    <%= promocion.getUsosRealizados() != null ? promocion.getUsosRealizados() : 0 %> / 
                                    <%= promocion.getUsosMaximos() != null ? promocion.getUsosMaximos() : "∞" %>
                                </span>
                            </div>
                            <% if (promocion.getMontoMinimo() != null && promocion.getMontoMinimo() > 0) { %>
                            <div class="detail-row">
                                <span class="detail-label">💰 Monto Mínimo:</span>
                                <span class="detail-value">$<%= String.format("%.2f", promocion.getMontoMinimo()) %></span>
                            </div>
                            <% } %>
                            <div class="detail-row">
                                <span class="detail-label">📊 Estado:</span>
                                <span class="detail-value">
                                    <span class="status-badge <%= estadoActual %>">
                                        <%= estadoActual.toUpperCase() %>
                                    </span>
                                </span>
                            </div>
                        </div>
                        
                        <% if (promocion.getCondicionesUso() != null && !promocion.getCondicionesUso().trim().isEmpty()) { %>
                        <div class="promotion-conditions">
                            <strong>📋 Términos y Condiciones:</strong><br>
                            <%= promocion.getCondicionesUso() %>
                        </div>
                        <% } %>
                    </div>
                    
                    <div class="promotion-actions">
                        <a href="PromocionControlador?accion=verDetalle&idPromocion=<%= promocion.getIdPromocion() %>" 
                           class="btn btn-info" style="font-size: 0.9em;">
                            👁️ Ver Detalle
                        </a>
                        <a href="EditarPromocion.jsp?idPromocion=<%= promocion.getIdPromocion() %>" 
                           class="btn btn-warning" style="font-size: 0.9em;">
                            ✏️ Editar
                        </a>
                        <% if ("ACTIVA".equals(promocion.getEstado())) { %>
                        <a href="PromocionControlador?accion=cambiarEstado&idPromocion=<%= promocion.getIdPromocion() %>&nuevoEstado=INACTIVA" 
                           class="btn btn-danger" style="font-size: 0.9em;"
                           onclick="return confirm('¿Está seguro de desactivar esta promoción?')">
                            ❌ Desactivar
                        </a>
                        <% } else { %>
                        <a href="PromocionControlador?accion=cambiarEstado&idPromocion=<%= promocion.getIdPromocion() %>&nuevoEstado=ACTIVA" 
                           class="btn btn-success" style="font-size: 0.9em;">
                            ✅ Activar
                        </a>
                        <% } %>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <div class="no-data">
                    <div class="icon">🎁</div>
                    <h3>No hay promociones disponibles</h3>
                    <p>Crea promociones atractivas para aumentar las ventas y fidelizar clientes</p>
                    <br>
                    <a href="CrearPromocion.jsp" class="btn btn-success">
                        ➕ Crear Primera Promoción
                    </a>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <script>
        // Auto-refresh cada 5 minutos para actualizar estados de promociones
        setTimeout(function() {
            location.reload();
        }, 300000);

        // Mostrar notificaciones para promociones próximas a vencer
        // (Esta funcionalidad se puede implementar con AJAX o en el servidor)
    </script>
</body>
</html>