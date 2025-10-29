<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, modelo.PaqueteServicio, modelo.PaqueteServicioItem"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Paquetes de Servicios - Sistema PetCare</title>
    <style>
        /* Mantener todos los estilos CSS que tenías anteriormente */
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
            grid-template-columns: 1fr 1fr auto;
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

        .packages-container {
            display: grid;
            gap: 25px;
        }

        .package-card {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            transition: transform 0.3s ease;
        }

        .package-card:hover {
            transform: translateY(-5px);
        }

        .package-header {
            background: var(--gradient-primary);
            color: var(--white);
            padding: 25px;
            text-align: center;
        }

        .package-title {
            font-size: 1.4em;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .package-price {
            font-size: 2em;
            font-weight: 800;
            margin-bottom: 5px;
        }

        .package-body {
            padding: 25px;
        }

        .package-description {
            color: var(--text-light);
            margin-bottom: 20px;
            font-style: italic;
        }

        .services-list {
            list-style: none;
            margin-bottom: 20px;
        }

        .service-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .service-item:last-child {
            border-bottom: none;
        }

        .service-name {
            font-weight: 500;
        }

        .service-price {
            color: var(--text-light);
            font-size: 0.9em;
        }

        .package-stats {
            background: var(--bg-light);
            padding: 15px 25px;
            display: flex;
            justify-content: space-between;
            font-size: 0.9em;
        }

        .package-actions {
            padding: 20px 25px;
            display: flex;
            gap: 10px;
            justify-content: center;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 500;
        }

        .status-badge.activo {
            background: #d4edda;
            color: #155724;
        }

        .status-badge.inactivo {
            background: #f8d7da;
            color: #721c24;
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

        @media (max-width: 768px) {
            .filters-form {
                grid-template-columns: 1fr;
            }
            
            .stats-grid {
                grid-template-columns: 1fr 1fr;
            }
            
            .package-stats {
                flex-direction: column;
                gap: 10px;
            }
            
            .package-actions {
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
                    <a href="<%= request.getContextPath() %>/MascotaControlador?accion=listarTodas">Mascotas</a>
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
                <li class="menu-item active">
                    <span>📋</span>
                    <a href="ListaPaquetesServicios.jsp">Paquetes</a>
                </li>
                <li class="menu-item">
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
                <h1>📋 Paquetes de Servicios</h1>
                <p>Gestiona paquetes especiales con descuentos exclusivos</p>
            </div>

            <!-- Estadísticas -->
            <div class="stats-panel">
                <h3>📊 Estadísticas de Paquetes</h3>
                <div class="stats-grid">
                    <div class="stat-item">
                        <div class="stat-number">${totalPaquetes != null ? totalPaquetes : 0}</div>
                        <div class="stat-label">Total Paquetes</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">${paquetesActivos != null ? paquetesActivos : 0}</div>
                        <div class="stat-label">Paquetes Activos</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">${descuentoPromedio != null ? descuentoPromedio : 0}%</div>
                        <div class="stat-label">Descuento Promedio</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">${paquetesVendidos != null ? paquetesVendidos : 0}</div>
                        <div class="stat-label">Paquetes Vendidos</div>
                    </div>
                </div>
            </div>

            <!-- Panel de Acciones -->
            <div class="actions-panel">
                <a href="CrearPaqueteServicio.jsp" class="btn btn-success">
                    ➕ Nuevo Paquete
                </a>
                <a href="<%= request.getContextPath() %>/PaqueteServicioControlador?accion=listar" class="btn btn-primary">
                    📋 Todos los Paquetes
                </a>
                <a href="ReportePaquetes.jsp" class="btn btn-warning">
                    📊 Reporte de Ventas
                </a>
            </div>

            <!-- Panel de Filtros -->
            <div class="filters-panel">
                <h3>🔍 Filtros de Búsqueda</h3>
                <form action="<%= request.getContextPath() %>/PaqueteServicioControlador" method="post" class="filters-form">
                    <input type="hidden" name="accion" value="buscarPaquetes">
                    
                    <div class="form-group">
                        <label for="termino">Buscar Paquete:</label>
                        <input type="text" id="termino" name="termino" class="form-control" 
                               placeholder="Nombre del paquete..." value="${terminoBusqueda != null ? terminoBusqueda : ''}">
                    </div>
                    
                    <div class="form-group">
                        <label for="estado">Estado:</label>
                        <select id="estado" name="estado" class="form-control">
                            <option value="">Todos los estados</option>
                            <option value="ACTIVO" ${estadoBusqueda == 'ACTIVO' ? 'selected' : ''}>Activos</option>
                            <option value="INACTIVO" ${estadoBusqueda == 'INACTIVO' ? 'selected' : ''}>Inactivos</option>
                        </select>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">🔍 Buscar</button>
                </form>
            </div>

            <!-- Mensajes -->
            <% 
                String mensaje = (String) request.getAttribute("mensaje");
                String tipoMensaje = (String) request.getAttribute("tipoMensaje");
                if (mensaje != null) { 
            %>
                <div class="message <%= "exito".equals(tipoMensaje) ? "success" : "error" %>">
                    <%= mensaje %>
                </div>
            <% } %>

            <!-- Lista de Paquetes -->
            <div class="packages-container">
                <% 
                    List<PaqueteServicio> paquetes = (List<PaqueteServicio>) request.getAttribute("paquetes");
                    if (paquetes != null && !paquetes.isEmpty()) {
                        for (PaqueteServicio paquete : paquetes) {
                %>
                <div class="package-card">
                    <div class="package-header">
                        <div class="package-title"><%= paquete.getNombre() != null ? paquete.getNombre() : "Sin nombre" %></div>
                        <div class="package-price">
                            $<%= String.format("%.2f", paquete.getPrecioTotal()) %>
                        </div>
                        <div class="package-discount">
                            🎁 Paquete con descuento
                        </div>
                    </div>
                    
                    <div class="package-body">
                        <% if (paquete.getDescripcion() != null && !paquete.getDescripcion().trim().isEmpty()) { %>
                        <div class="package-description">
                            <%= paquete.getDescripcion() %>
                        </div>
                        <% } %>
                        
                        <h4>🎯 Información del Paquete:</h4>
                        <ul class="services-list">
                            <li class="service-item">
                                <span class="service-name">ID del Paquete</span>
                                <span class="service-price">#<%= paquete.getIdPaquete() %></span>
                            </li>
                            <li class="service-item">
                                <span class="service-name">Precio Total</span>
                                <span class="service-price">$<%= String.format("%.2f", paquete.getPrecioTotal()) %></span>
                            </li>
                            <li class="service-item">
                                <span class="service-name">Fecha Creación</span>
                                <span class="service-price">
                                    <% if (paquete.getCreatedAt() != null) { 
                                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                                    %>
                                        <%= sdf.format(paquete.getCreatedAt()) %>
                                    <% } else { %>
                                        No disponible
                                    <% } %>
                                </span>
                            </li>
                        </ul>
                        
                        <p><em>💡 Los servicios incluidos se muestran en el detalle del paquete.</em></p>
                    </div>
                    
                    <div class="package-stats">
                        <span>
                            📊 Estado: 
                            <span class="status-badge activo">
                                ACTIVO
                            </span>
                        </span>
                        <span>
                            📅 Creado: 
                            <% if (paquete.getCreatedAt() != null) { 
                                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                            %>
                                <%= sdf.format(paquete.getCreatedAt()) %>
                            <% } else { %>
                                No disponible
                            <% } %>
                        </span>
                    </div>
                    
                    <div class="package-actions">
                        <a href="<%= request.getContextPath() %>/PaqueteServicioControlador?accion=obtenerDetalle&idPaquete=<%= paquete.getIdPaquete() %>" 
                           class="btn btn-info" style="font-size: 0.9em;">
                            👁️ Ver Detalle
                        </a>
                        <a href="EditarPaqueteServicio.jsp?idPaquete=<%= paquete.getIdPaquete() %>" 
                           class="btn btn-warning" style="font-size: 0.9em;">
                            ✏️ Editar
                        </a>
                        <a href="<%= request.getContextPath() %>/PaqueteServicioControlador?accion=eliminar&idPaquete=<%= paquete.getIdPaquete() %>" 
                           class="btn btn-danger" style="font-size: 0.9em;"
                           onclick="return confirm('¿Está seguro de eliminar este paquete?')">
                            🗑️ Eliminar
                        </a>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <div class="no-data">
                    <div class="icon">📦</div>
                    <h3>No hay paquetes de servicios</h3>
                    <p>Comienza creando tu primer paquete de servicios con descuentos especiales</p>
                    <br>
                    <a href="CrearPaqueteServicio.jsp" class="btn btn-success">
                        ➕ Crear Primer Paquete
                    </a>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <script>
        // Script para manejar confirmaciones y mejoras de UX
        document.addEventListener('DOMContentLoaded', function() {
            // Mejorar la experiencia de usuario
            const mensajes = document.querySelectorAll('.message');
            mensajes.forEach(mensaje => {
                setTimeout(() => {
                    mensaje.style.opacity = '0';
                    mensaje.style.transition = 'opacity 0.5s ease';
                    setTimeout(() => mensaje.remove(), 500);
                }, 5000);
            });
        });
    </script>
</body>
</html>