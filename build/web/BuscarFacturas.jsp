<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, modelo.FacturaClienteDTO"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Búsqueda de Facturas - Sistema PetCare</title>
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

        .btn-secondary {
            background: linear-gradient(135deg, var(--secondary-color) 0%, #c9b18c 100%);
            color: var(--text-dark);
            box-shadow: 0 8px 25px rgba(213, 196, 173, 0.3);
        }

        .search-box {
            background: var(--white);
            padding: 30px;
            border-radius: var(--radius);
            margin-bottom: 30px;
            box-shadow: var(--shadow);
            border-top: 4px solid var(--primary-color);
            animation: fadeInUp 0.6s ease-out;
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

        .search-form {
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .search-input {
            flex: 1;
            padding: 16px 20px;
            border: 2px solid #e0e0e0;
            border-radius: var(--radius);
            font-size: 1em;
            background: #f9f9f9;
            transition: all 0.3s ease;
            font-family: inherit;
        }

        .search-input:focus {
            outline: none;
            border-color: var(--primary-color);
            background: var(--white);
            box-shadow: 0 0 0 4px rgba(171, 203, 213, 0.2);
            transform: translateY(-2px);
        }

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
            min-width: 1200px;
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

        tr:hover td {
            background-color: rgba(171, 203, 213, 0.05);
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .factura-badge {
            background: var(--primary-light);
            color: var(--text-dark);
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.9em;
            border: 2px solid var(--primary-color);
            font-family: 'Courier New', monospace;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.8em;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-emitida {
            background: linear-gradient(135deg, #e8f5e8 0%, #c8e6c9 100%);
            color: #2e7d32;
            border: 1px solid #4caf50;
        }

        .status-anulada {
            background: linear-gradient(135deg, #fde8e8 0%, #f8d7da 100%);
            color: #c62828;
            border: 1px solid #f44336;
        }

        .currency {
            font-family: 'Courier New', monospace;
            font-weight: 700;
            color: var(--success-color);
            font-size: 1.1em;
        }

        .currency.negative {
            color: var(--danger-color);
        }

        .date-info {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .date-primary {
            font-weight: 600;
            color: var(--text-dark);
        }

        .date-secondary {
            font-size: 0.8em;
            color: var(--text-light);
        }

        .action-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .btn-view {
            background: linear-gradient(135deg, #2196f3 0%, #1976d2 100%);
            color: white;
            padding: 8px 15px;
            font-size: 0.8em;
            border-radius: 12px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.3s ease;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(33, 150, 243, 0.3);
        }

        .btn-view:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(33, 150, 243, 0.4);
        }

        .btn-pay {
            background: var(--gradient-success);
            color: white;
            padding: 8px 15px;
            font-size: 0.8em;
            border-radius: 12px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.3s ease;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
        }

        .btn-pay:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(76, 175, 80, 0.4);
        }

        .btn-print {
            background: linear-gradient(135deg, var(--secondary-color) 0%, #c9b18c 100%);
            color: var(--text-dark);
            padding: 8px 15px;
            font-size: 0.8em;
            border-radius: 12px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.3s ease;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(213, 196, 173, 0.3);
        }

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

        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
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

        .navigation {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin: 40px 0;
        }

        .navigation .btn {
            width: 100%;
            justify-content: center;
            padding: 20px;
            font-size: 1em;
        }

        @media (max-width: 768px) {
            .main-content {
                padding: 20px;
            }
            .search-form {
                flex-direction: column;
            }
            .stats-container {
                grid-template-columns: 1fr;
            }
            .navigation {
                grid-template-columns: 1fr;
            }
            .action-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="sidebar">
            <div class="logo">
                <h1><span>🐕</span> Terán Vet</h1>
            </div>
        </div>

        <div class="content">
            <div class="header">
                <div class="header-top">
                    <div class="welcome">
                        <h1>🧾 Búsqueda de Facturas</h1>
                        <p>Encuentra y gestiona todas las facturas del sistema</p>
                    </div>
                    <div class="header-actions">
                        <a href="CrearFactura.jsp" class="btn btn-success">
                            <span>➕ Nueva Factura</span>
                        </a>
                        <a href="dashboard.jsp" class="btn btn-primary">
                            <span>📊 Dashboard</span>
                        </a>
                    </div>
                </div>
            </div>

            <div class="main-content">
                <% if (request.getAttribute("mensaje") != null) { %>
                    <div class="mensaje <%= request.getAttribute("mensaje").toString().contains("✅") ? "exito" : "error" %>">
                        <%= request.getAttribute("mensaje") %>
                    </div>
                <% } %>

                <div class="search-box">
                    <form action="FacturaControlador" method="POST" class="search-form">
                        <input type="hidden" name="accion" value="buscar">
                        <input type="text" name="termino" placeholder="🔍 Buscar por número, serie, cliente..." 
                               class="search-input"
                               value="<%= request.getParameter("termino") != null ? request.getParameter("termino") : "" %>">
                        <button type="submit" class="btn btn-primary">
                            <span>🔍 Buscar Facturas</span>
                        </button>
                        <% if (request.getParameter("termino") != null && !request.getParameter("termino").isEmpty()) { %>
                            <a href="BuscarFacturas.jsp" class="btn btn-secondary">
                                <span>🔄 Limpiar</span>
                            </a>
                        <% } %>
                    </form>
                </div>

                <%
                    List<FacturaClienteDTO> facturas = (List<FacturaClienteDTO>) request.getAttribute("facturas");
                    Integer totalFacturas = (Integer) request.getAttribute("totalFacturas");
                    
                    if (totalFacturas == null) totalFacturas = 0;
                    if (facturas == null) facturas = new java.util.ArrayList<FacturaClienteDTO>();

                    // Calcular estadísticas
                    double totalEmitidas = 0;
                    double totalAnuladas = 0;
                    int facturasEmitidas = 0;
                    int facturasAnuladas = 0;
                    
                    for (FacturaClienteDTO factura : facturas) {
                        if ("emitida".equals(factura.getEstado())) {
                            totalEmitidas += factura.getTotal();
                            facturasEmitidas++;
                        } else if ("anulada".equals(factura.getEstado())) {
                            totalAnuladas += factura.getTotal();
                            facturasAnuladas++;
                        }
                    }
                %>

                <!-- Estadísticas -->
                <div class="stats-container">
                    <div class="stat-card">
                        <span class="stat-icon">🧾</span>
                        <div class="stat-number"><%= totalFacturas %></div>
                        <div class="stat-label">Total Facturas</div>
                    </div>
                    <div class="stat-card" style="animation-delay: 0.2s;">
                        <span class="stat-icon">✅</span>
                        <div class="stat-number"><%= facturasEmitidas %></div>
                        <div class="stat-label">Emitidas</div>
                    </div>
                    <div class="stat-card" style="animation-delay: 0.4s;">
                        <span class="stat-icon">❌</span>
                        <div class="stat-number"><%= facturasAnuladas %></div>
                        <div class="stat-label">Anuladas</div>
                    </div>
                    <div class="stat-card" style="animation-delay: 0.6s;">
                        <span class="stat-icon">💰</span>
                        <div class="stat-number">S/ <%= String.format("%.2f", totalEmitidas) %></div>
                        <div class="stat-label">Total Emitidas</div>
                    </div>
                </div>

                <!-- Tabla de facturas -->
                <% if (!facturas.isEmpty()) { %>
                    <div class="table-container">
                        <div class="table-wrapper">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Número</th>
                                        <th>Cliente</th>
                                        <th>Fecha Emisión</th>
                                        <th>Total</th>
                                        <th>Estado</th>
                                        <th>Método Pago</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (FacturaClienteDTO factura : facturas) { %>
                                    <tr>
                                        <td>
                                            <span class="factura-badge">
                                                <%= factura.getNumeroFactura() != null ? factura.getNumeroFactura() : "F-" + factura.getIdFactura() %>
                                            </span>
                                        </td>
                                        <td>
                                            <div style="display: flex; flex-direction: column;">
                                                <strong><%= factura.getCliente() != null ? factura.getCliente() : "Sin cliente" %></strong>
                                                <small style="color: var(--text-light);">ID: <%= factura.getIdFactura() %></small>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="date-info">
                                                <span class="date-primary">
                                                    <%= factura.getFechaEmision() != null ? 
                                                        new java.text.SimpleDateFormat("dd/MM/yyyy").format(factura.getFechaEmision()) : 
                                                        "Sin fecha" %>
                                                </span>
                                                <span class="date-secondary">
                                                    <%= factura.getFechaEmision() != null ? 
                                                        new java.text.SimpleDateFormat("HH:mm").format(factura.getFechaEmision()) : 
                                                        "" %>
                                                </span>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="currency">
                                                S/ <%= String.format("%.2f", factura.getTotal()) %>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="status-badge status-<%= factura.getEstado() != null ? factura.getEstado() : "emitida" %>">
                                                <%= "emitida".equals(factura.getEstado()) ? "✅ Emitida" : 
                                                   "anulada".equals(factura.getEstado()) ? "❌ Anulada" : "📝 " + factura.getEstado() %>
                                            </span>
                                        </td>
                                        <td>
                                            <%= factura.getMetodoPagoSugerido() != null ? 
                                                ("efectivo".equals(factura.getMetodoPagoSugerido()) ? "💵 Efectivo" :
                                                 "tarjeta".equals(factura.getMetodoPagoSugerido()) ? "💳 Tarjeta" :
                                                 "transfer".equals(factura.getMetodoPagoSugerido()) ? "🏦 Transferencia" :
                                                 "🔄 " + factura.getMetodoPagoSugerido()) : 
                                                "💵 No especificado" %>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="FacturaControlador?accion=ver&id=<%= factura.getIdFactura() %>" 
                                                   class="btn-view">
                                                    👁️ Ver
                                                </a>
                                                <% if ("emitida".equals(factura.getEstado())) { %>
                                                <a href="RegistrarPago.jsp?idFactura=<%= factura.getIdFactura() %>" 
                                                   class="btn-pay">
                                                    💰 Pagar
                                                </a>
                                                <% } %>
                                                <a href="FacturaControlador?accion=imprimir&id=<%= factura.getIdFactura() %>" 
                                                   class="btn-print"
                                                   target="_blank">
                                                    🖨️ Imprimir
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                <% } else { %>
                    <div class="empty-state">
                        <span class="empty-state-icon">🧾</span>
                        <h3>No se encontraron facturas</h3>
                        <p>
                            <% if (request.getParameter("termino") != null && !request.getParameter("termino").isEmpty()) { %>
                                No hay facturas que coincidan con tu búsqueda: "<strong><%= request.getParameter("termino") %></strong>"
                            <% } else { %>
                                No hay facturas registradas en el sistema. Las facturas se generan automáticamente al completar atenciones.
                            <% } %>
                        </p>
                        <a href="CrearFactura.jsp" class="btn btn-primary">
                            <span>➕ Crear Primera Factura</span>
                        </a>
                    </div>
                <% } %>

                <!-- Navegación -->
                <div class="navigation">
                    <a href="CrearFactura.jsp" class="btn btn-success">
                        <span>➕ Nueva Factura</span>
                    </a>
                    <a href="FacturaControlador?accion=listarPorCliente" class="btn btn-primary">
                        <span>👥 Por Cliente</span>
                    </a>
                    <a href="ReporteControlador?accion=ingresos" class="btn btn-primary">
                        <span>📊 Reporte Ingresos</span>
                    </a>
                    <a href="dashboard.jsp" class="btn btn-secondary">
                        <span>📊 Volver al Dashboard</span>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Focus en búsqueda
            const searchInput = document.querySelector('.search-input');
            if (searchInput) {
                searchInput.focus();
            }

            // Animación de filas
            const rows = document.querySelectorAll('tbody tr');
            rows.forEach((row, index) => {
                row.style.opacity = '0';
                row.style.transform = 'translateY(20px)';
                setTimeout(() => {
                    row.style.transition = 'all 0.5s ease';
                    row.style.opacity = '1';
                    row.style.transform = 'translateY(0)';
                }, index * 100);
            });

            // Actualizar totales en tiempo real
            function actualizarTotales() {
                const rows = document.querySelectorAll('tbody tr:not([style*="display: none"])');
                let totalVisible = rows.length;
                let totalEmitidas = 0;
                
                rows.forEach(row => {
                    const statusBadge = row.querySelector('.status-badge');
                    if (statusBadge && statusBadge.textContent.includes('Emitida')) {
                        const totalCell = row.cells[3].textContent;
                        const amount = parseFloat(totalCell.replace('S/ ', '').replace(',', ''));
                        if (!isNaN(amount)) {
                            totalEmitidas += amount;
                        }
                    }
                });

                // Actualizar estadísticas si existen
                const statNumbers = document.querySelectorAll('.stat-number');
                if (statNumbers.length >= 4) {
                    statNumbers[0].textContent = totalVisible;
                    statNumbers[3].textContent = 'S/ ' + totalEmitidas.toFixed(2);
                }
            }
        });

        // Función para confirmar anulación
        function confirmarAnulacion(numeroFactura) {
            return confirm(`¿Está seguro de anular la factura ${numeroFactura}?\n\nEsta acción no se puede deshacer.`);
        }

        // Función para imprimir factura
        function imprimirFactura(idFactura) {
            window.open(`FacturaControlador?accion=imprimir&id=${idFactura}`, '_blank');
        }
    </script>
</body>
</html>
