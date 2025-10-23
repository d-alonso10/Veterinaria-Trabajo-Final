<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, modelo.FacturaClienteDTO, modelo.Factura"%>
<%@page import="dao.FacturaDao"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Facturas - Sistema PetCare</title>
    <link rel="stylesheet" href="includes/menu-styles.css">
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

        .search-panel {
            background: var(--white);
            padding: 25px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
        }

        .search-form {
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

        .content-panel {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .table-container {
            overflow-x: auto;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table th,
        .data-table td {
            padding: 16px 20px;
            text-align: left;
            border-bottom: 1px solid #f0f0f0;
        }

        .data-table th {
            background: var(--bg-light);
            font-weight: 600;
            color: var(--text-dark);
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .data-table tr:hover {
            background: rgba(171, 203, 213, 0.05);
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 500;
        }

        .status-badge.pagada {
            background: #d4edda;
            color: #155724;
        }

        .status-badge.pendiente {
            background: #fff3cd;
            color: #856404;
        }

        .status-badge.anulada {
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

        .stats-row {
            background: var(--bg-light);
            padding: 20px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            border-top: 1px solid #e0e0e0;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 1.5em;
            font-weight: 700;
            color: var(--primary-dark);
        }

        .stat-label {
            color: var(--text-light);
            font-size: 0.9em;
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
        <%@ include file="includes/menu.jsp" %>

        <!-- Main Content -->
        <div class="main-content">
            <div class="header">
                <h1>💰 Gestión de Facturas</h1>
                <p>Administra todas las facturas del sistema veterinario</p>
            </div>

            <!-- Panel de Acciones -->
            <div class="actions-panel">
                <a href="<%= request.getContextPath() %>/CrearFactura.jsp" class="btn btn-success">
                    ➕ Nueva Factura
                </a>
                <a href="<%= request.getContextPath() %>/FacturaControlador?accion=listarTodas" class="btn btn-primary">
                    📋 Todas las Facturas
                </a>
                <a href="<%= request.getContextPath() %>/BuscarFacturas.jsp" class="btn btn-info">
                    🔍 Búsqueda Avanzada
                </a>
                <a href="<%= request.getContextPath() %>/ReporteFacturas.jsp" class="btn btn-warning">
                    📊 Generar Reporte
                </a>
            </div>

            <!-- Panel de Búsqueda -->
            <div class="search-panel">
                <h3>🔍 Buscar Facturas</h3>
                <form action="<%= request.getContextPath() %>/FacturaControlador" method="post" class="search-form">
                    <input type="hidden" name="accion" value="buscarFacturas">
                    
                    <div class="form-group">
                        <label for="termino">Término de Búsqueda:</label>
                        <input type="text" id="termino" name="termino" class="form-control" 
                               placeholder="Serie, número o cliente..." value="${terminoBusqueda}">
                    </div>
                    
                    <div class="form-group">
                        <label for="fechaInicio">Fecha Inicio:</label>
                        <input type="date" id="fechaInicio" name="fechaInicio" class="form-control" 
                               value="${fechaInicio}">
                    </div>
                    
                    <div class="form-group">
                        <label for="fechaFin">Fecha Fin:</label>
                        <input type="date" id="fechaFin" name="fechaFin" class="form-control" 
                               value="${fechaFin}">
                    </div>
                    
                    <div class="form-group">
                        <label for="estado">Estado:</label>
                        <select id="estado" name="estado" class="form-control">
                            <option value="">Todos los estados</option>
                            <option value="PENDIENTE" ${estadoSeleccionado == 'PENDIENTE' ? 'selected' : ''}>Pendiente</option>
                            <option value="PAGADA" ${estadoSeleccionado == 'PAGADA' ? 'selected' : ''}>Pagada</option>
                            <option value="ANULADA" ${estadoSeleccionado == 'ANULADA' ? 'selected' : ''}>Anulada</option>
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

            <!-- Lista de Facturas -->
            <div class="content-panel">
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>📄 Serie/Número</th>
                                <th>👤 Cliente</th>
                                <th>📅 Fecha</th>
                                <th>💰 Subtotal</th>
                                <th>🏷️ Impuesto</th>
                                <th>💳 Total</th>
                                <th>📊 Estado</th>
                                <th>💰 Método Pago</th>
                                <th>⚙️ Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                List<FacturaClienteDTO> facturas = (List<FacturaClienteDTO>) request.getAttribute("facturas");
                                if (facturas != null && !facturas.isEmpty()) {
                                    for (FacturaClienteDTO factura : facturas) {
                            %>
                            <tr>
                                <td><strong><%= factura.getSerie() %>-<%= factura.getNumero() %></strong></td>
                                <td><%= factura.getNombreCliente() %> <%= factura.getApellidoCliente() %></td>
                                <td><%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(factura.getFechaEmision()) %></td>
                                <td>$<%= String.format("%.2f", factura.getSubtotal()) %></td>
                                <td>$<%= String.format("%.2f", factura.getImpuesto()) %></td>
                                <td><strong>$<%= String.format("%.2f", factura.getTotal()) %></strong></td>
                                <td>
                                    <span class="status-badge <%= factura.getEstado().toLowerCase() %>">
                                        <%= factura.getEstado() %>
                                    </span>
                                </td>
                                <td><%= factura.getMetodoPagoSugerido() %></td>
                                <td>
                                    <a href="FacturaControlador?accion=obtenerDetalle&idFactura=<%= factura.getIdFactura() %>" 
                                       class="btn btn-info" style="font-size: 0.8em; padding: 8px 12px;">
                                        👁️ Ver
                                    </a>
                                    <% if ("PENDIENTE".equals(factura.getEstado())) { %>
                                    <a href="FacturaControlador?accion=anular&idFactura=<%= factura.getIdFactura() %>" 
                                       class="btn btn-danger" style="font-size: 0.8em; padding: 8px 12px;"
                                       onclick="return confirm('¿Está seguro de anular esta factura?')">
                                        ❌ Anular
                                    </a>
                                    <% } %>
                                </td>
                            </tr>
                            <% 
                                    }
                                } else { 
                            %>
                            <tr>
                                <td colspan="9" class="no-data">
                                    No se encontraron facturas
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <!-- Estadísticas -->
                <% if (facturas != null && !facturas.isEmpty()) { %>
                <div class="stats-row">
                    <div class="stat-item">
                        <div class="stat-number">${totalFacturas != null ? totalFacturas : 0}</div>
                        <div class="stat-label">Total Facturas</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">$${totalFacturado != null ? String.format("%.2f", totalFacturado) : "0.00"}</div>
                        <div class="stat-label">Total Facturado</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">${facturasPagadas != null ? facturasPagadas : 0}</div>
                        <div class="stat-label">Facturas Pagadas</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">${facturasPendientes != null ? facturasPendientes : 0}</div>
                        <div class="stat-label">Facturas Pendientes</div>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>