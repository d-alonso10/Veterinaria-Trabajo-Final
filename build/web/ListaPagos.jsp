<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, modelo.PagoFacturaDTO, modelo.Pago"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Pagos - Sistema PetCare</title>
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

        .status-badge.confirmado {
            background: #d4edda;
            color: #155724;
        }

        .status-badge.pendiente {
            background: #fff3cd;
            color: #856404;
        }

        .status-badge.anulado {
            background: #f8d7da;
            color: #721c24;
        }

        .method-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: 500;
        }

        .method-badge.efectivo {
            background: #d1ecf1;
            color: #0c5460;
        }

        .method-badge.tarjeta_credito {
            background: #d4edda;
            color: #155724;
        }

        .method-badge.tarjeta_debito {
            background: #fff3cd;
            color: #856404;
        }

        .method-badge.transferencia {
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
            padding: 40px 20px;
            color: var(--text-light);
            font-style: italic;
        }

        .payment-summary {
            background: var(--bg-light);
            padding: 20px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            border-top: 1px solid #e0e0e0;
        }

        .summary-item {
            text-align: center;
        }

        .summary-number {
            font-size: 1.3em;
            font-weight: 700;
            color: var(--primary-dark);
        }

        .summary-label {
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
                <li class="menu-item active">
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
                <h1>💳 Gestión de Pagos</h1>
                <p>Control y seguimiento de todos los pagos del sistema</p>
            </div>

            <!-- Estadísticas de Pagos -->
            <div class="stats-panel">
                <h3>📊 Estadísticas de Pagos</h3>
                <div class="stats-grid">
                    <div class="stat-item">
                        <div class="stat-number">${totalPagos != null ? totalPagos : 0}</div>
                        <div class="stat-label">Total Pagos</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">$${totalMontoPagos != null ? String.format("%.2f", totalMontoPagos) : "0.00"}</div>
                        <div class="stat-label">Monto Total</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">${pagosConfirmados != null ? pagosConfirmados : 0}</div>
                        <div class="stat-label">Pagos Confirmados</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">${pagosPendientes != null ? pagosPendientes : 0}</div>
                        <div class="stat-label">Pagos Pendientes</div>
                    </div>
                </div>
            </div>

            <!-- Panel de Acciones -->
            <div class="actions-panel">
                <a href="RegistrarPago.jsp" class="btn btn-success">
                    ➕ Registrar Pago
                </a>
                <a href="PagoControlador?accion=listarTodos" class="btn btn-primary">
                    📋 Todos los Pagos
                </a>
                <a href="PagoControlador?accion=pagosPendientes" class="btn btn-warning">
                    ⏳ Pagos Pendientes
                </a>
                <a href="ReportePagos.jsp" class="btn btn-info">
                    📊 Reporte de Pagos
                </a>
            </div>

            <!-- Panel de Filtros -->
            <div class="filters-panel">
                <h3>🔍 Filtros de Búsqueda</h3>
                <form action="PagoControlador" method="post" class="filters-form">
                    <input type="hidden" name="accion" value="buscarPagos">
                    
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
                        <label for="metodoPago">Método de Pago:</label>
                        <select id="metodoPago" name="metodoPago" class="form-control">
                            <option value="">Todos los métodos</option>
                            <option value="EFECTIVO" ${metodoSeleccionado == 'EFECTIVO' ? 'selected' : ''}>Efectivo</option>
                            <option value="TARJETA_CREDITO" ${metodoSeleccionado == 'TARJETA_CREDITO' ? 'selected' : ''}>Tarjeta de Crédito</option>
                            <option value="TARJETA_DEBITO" ${metodoSeleccionado == 'TARJETA_DEBITO' ? 'selected' : ''}>Tarjeta de Débito</option>
                            <option value="TRANSFERENCIA" ${metodoSeleccionado == 'TRANSFERENCIA' ? 'selected' : ''}>Transferencia</option>
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

            <!-- Lista de Pagos -->
            <div class="content-panel">
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>📄 Factura</th>
                                <th>👤 Cliente</th>
                                <th>📅 Fecha Pago</th>
                                <th>💰 Monto</th>
                                <th>💳 Método</th>
                                <th>📊 Estado</th>
                                <th>🏦 Referencia</th>
                                <th>⚙️ Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                List<PagoFacturaDTO> pagos = (List<PagoFacturaDTO>) request.getAttribute("pagos");
                                if (pagos != null && !pagos.isEmpty()) {
                                    for (PagoFacturaDTO pago : pagos) {
                            %>
                            <tr>
                                <td>
                                    <strong><%= pago.getSerieFactura() %>-<%= pago.getNumeroFactura() %></strong><br>
                                    <small style="color: var(--text-light);">
                                        Total: $<%= String.format("%.2f", pago.getTotalFactura()) %>
                                    </small>
                                </td>
                                <td>
                                    <%= pago.getNombreCliente() %> <%= pago.getApellidoCliente() %><br>
                                    <small style="color: var(--text-light);"><%= pago.getTelefonoCliente() %></small>
                                </td>
                                <td><%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(pago.getFechaPago()) %></td>
                                <td><strong>$<%= String.format("%.2f", pago.getMonto()) %></strong></td>
                                <td>
                                    <span class="method-badge <%= pago.getMetodoPago().toLowerCase().replace("_", "_") %>">
                                        <%= pago.getMetodoPago().replace("_", " ") %>
                                    </span>
                                </td>
                                <td>
                                    <span class="status-badge <%= pago.getEstado().toLowerCase() %>">
                                        <%= pago.getEstado() %>
                                    </span>
                                </td>
                                <td>
                                    <%= pago.getReferenciaTransaccion() != null ? pago.getReferenciaTransaccion() : "N/A" %>
                                </td>
                                <td>
                                    <% if ("PENDIENTE".equals(pago.getEstado())) { %>
                                    <a href="PagoControlador?accion=confirmar&idPago=<%= pago.getIdPago() %>" 
                                       class="btn btn-success" style="font-size: 0.8em; padding: 8px 12px;">
                                        ✅ Confirmar
                                    </a>
                                    <a href="PagoControlador?accion=anular&idPago=<%= pago.getIdPago() %>" 
                                       class="btn btn-danger" style="font-size: 0.8em; padding: 8px 12px;"
                                       onclick="return confirm('¿Está seguro de anular este pago?')">
                                        ❌ Anular
                                    </a>
                                    <% } else { %>
                                    <a href="PagoControlador?accion=verDetalle&idPago=<%= pago.getIdPago() %>" 
                                       class="btn btn-info" style="font-size: 0.8em; padding: 8px 12px;">
                                        👁️ Ver Detalle
                                    </a>
                                    <% } %>
                                </td>
                            </tr>
                            <% 
                                    }
                                } else { 
                            %>
                            <tr>
                                <td colspan="8" class="no-data">
                                    No se encontraron pagos registrados
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <!-- Resumen de Pagos -->
                <% if (pagos != null && !pagos.isEmpty()) { %>
                <div class="payment-summary">
                    <div class="summary-item">
                        <div class="summary-number">${pagosMostrados != null ? pagosMostrados : 0}</div>
                        <div class="summary-label">Pagos Mostrados</div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-number">$${montoMostrado != null ? String.format("%.2f", montoMostrado) : "0.00"}</div>
                        <div class="summary-label">Monto Mostrado</div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-number">${pagosEfectivo != null ? pagosEfectivo : 0}</div>
                        <div class="summary-label">Pagos en Efectivo</div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-number">${pagosTarjeta != null ? pagosTarjeta : 0}</div>
                        <div class="summary-label">Pagos con Tarjeta</div>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>