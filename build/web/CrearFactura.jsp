<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, modelo.Cliente, modelo.Servicio, modelo.DetalleServicio"%>
<%@page import="dao.ClienteDao, dao.ServicioDao"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Factura - Sistema PetCare</title>
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

        .form-panel {
            background: var(--white);
            padding: 30px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 20px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 30px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-group label {
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--text-dark);
        }

        .form-control {
            padding: 14px 18px;
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

        .form-control:invalid {
            border-color: var(--danger-color);
        }

        .btn {
            padding: 14px 28px;
            border: none;
            border-radius: var(--radius);
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
            font-size: 1em;
            justify-content: center;
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

        .btn-secondary {
            background: #6c757d;
            color: var(--white);
        }

        .btn-success {
            background: var(--gradient-success);
            color: var(--white);
        }

        .btn-danger {
            background: var(--gradient-danger);
            color: var(--white);
        }

        .btn-warning {
            background: var(--gradient-warning);
            color: var(--text-dark);
        }

        .services-section {
            background: var(--bg-light);
            padding: 25px;
            border-radius: var(--radius);
            margin-bottom: 25px;
        }

        .service-item {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 80px;
            gap: 15px;
            align-items: center;
            padding: 15px;
            background: var(--white);
            border-radius: 12px;
            margin-bottom: 15px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }

        .service-item:last-child {
            margin-bottom: 0;
        }

        .service-controls {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .total-section {
            background: var(--primary-light);
            padding: 25px;
            border-radius: var(--radius);
            text-align: right;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 0;
            border-bottom: 1px solid rgba(0,0,0,0.1);
            margin-bottom: 10px;
        }

        .total-row.final {
            font-size: 1.3em;
            font-weight: 700;
            border-bottom: 2px solid var(--primary-dark);
            color: var(--primary-dark);
        }

        .actions-section {
            display: flex;
            gap: 15px;
            justify-content: space-between;
            margin-top: 30px;
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

        .message.warning {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .service-item {
                grid-template-columns: 1fr;
                gap: 10px;
            }
            
            .actions-section {
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
                    <a href="<%= request.getContextPath() %>/DashboardControlador">Dashboard</a>
                </li>
                <li class="menu-item">
                    <span>👥</span>
                    <a href="<%= request.getContextPath() %>/ClienteControlador?accion=listarTodos">Clientes</a>
                </li>
                <li class="menu-item">
                    <span>🐕</span>
                    <a href="<%= request.getContextPath() %>/MascotaControlador?accion=listarTodas">Mascotas</a>
                </li>
                <li class="menu-item">
                    <span>👨‍⚕️</span>
                    <a href="<%= request.getContextPath() %>/GroomerControlador">Groomers</a>
                </li>
                <li class="menu-item">
                    <span>🎯</span>
                    <a href="<%= request.getContextPath() %>/ServicioControlador">Servicios</a>
                </li>
                <li class="menu-item">
                    <span>📅</span>
                    <a href="<%= request.getContextPath() %>/CitaControlador?accion=todasCitas">Citas</a>
                </li>
                <li class="menu-item">
                    <span>⏰</span>
                    <a href="<%= request.getContextPath() %>/AtencionControlador">Cola de Atención</a>
                </li>
                <li class="menu-item active">
                    <span>💰</span>
                    <a href="<%= request.getContextPath() %>/FacturaControlador?accion=listar">Facturas</a>
                </li>
                <li class="menu-item">
                    <span>💳</span>
                    <a href="<%= request.getContextPath() %>/PagoControlador?accion=listar">Pagos</a>
                </li>
                <li class="menu-item">
                    <span>📋</span>
                    <a href="<%= request.getContextPath() %>/PaqueteServicioControlador?accion=listar">Paquetes</a>
                </li>
                <li class="menu-item">
                    <span>🎁</span>
                    <a href="<%= request.getContextPath() %>/PromocionControlador?accion=listar">Promociones</a>
                </li>
                <li class="menu-item">
                    <span>🔔</span>
                    <a href="<%= request.getContextPath() %>/UtilidadesControlador?accion=notificaciones">Notificaciones</a>
                </li>
                <li class="menu-item">
                    <span>👤</span>
                    <a href="<%= request.getContextPath() %>/UsuarioSistemaControlador?accion=listar">Usuarios</a>
                </li>
                <li class="menu-item">
                    <span>📊</span>
                    <a href="<%= request.getContextPath() %>/ReporteControlador">Reportes</a>
                </li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="header">
                <h1>📄 Crear Nueva Factura</h1>
                <p>Genera una nueva factura para servicios veterinarios</p>
            </div>

            <!-- Mensajes -->
            <% if (request.getAttribute("mensaje") != null) { %>
                <div class="message <%= request.getAttribute("tipoMensaje") != null ? request.getAttribute("tipoMensaje") : "info" %>">
                    <%= request.getAttribute("mensaje") %>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/FacturaControlador" method="post" id="formFactura">
                <input type="hidden" name="accion" value="crear">
                
                <!-- Información del Cliente -->
                <div class="form-panel">
                    <h3>👤 Información del Cliente</h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="idCliente">Cliente: *</label>
                            <select id="idCliente" name="idCliente" class="form-control" required>
                                <option value="">Seleccione un cliente</option>
                                <% 
                                    // ✅ PATRÓN MVC CORRECTO: Solo usar datos del controlador
                                    List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");
                                    if (clientes != null) {
                                        for (Cliente cliente : clientes) {
                                %>
                                <option value="<%= cliente.getIdCliente() %>" 
                                        <%= request.getParameter("idCliente") != null && 
                                           request.getParameter("idCliente").equals(String.valueOf(cliente.getIdCliente())) ? "selected" : "" %>>
                                    <%= cliente.getNombre() %> <%= cliente.getApellido() %> - <%= cliente.getTelefono() %>
                                </option>
                                <% 
                                        }
                                    }
                                %>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="metodoPagoSugerido">Método de Pago: *</label>
                            <select id="metodoPagoSugerido" name="metodoPagoSugerido" class="form-control" required>
                                <option value="">Seleccione método de pago</option>
                                <option value="EFECTIVO" <%= "EFECTIVO".equals(request.getParameter("metodoPagoSugerido")) ? "selected" : "" %>>Efectivo</option>
                                <option value="TARJETA_CREDITO" <%= "TARJETA_CREDITO".equals(request.getParameter("metodoPagoSugerido")) ? "selected" : "" %>>Tarjeta de Crédito</option>
                                <option value="TARJETA_DEBITO" <%= "TARJETA_DEBITO".equals(request.getParameter("metodoPagoSugerido")) ? "selected" : "" %>>Tarjeta de Débito</option>
                                <option value="TRANSFERENCIA" <%= "TRANSFERENCIA".equals(request.getParameter("metodoPagoSugerido")) ? "selected" : "" %>>Transferencia</option>
                            </select>
                        </div>
                        
                        <div class="form-group full-width">
                            <label for="observaciones">Observaciones:</label>
                            <textarea id="observaciones" name="observaciones" class="form-control" rows="3" 
                                      placeholder="Observaciones adicionales sobre la factura..."><%= request.getParameter("observaciones") != null ? request.getParameter("observaciones") : "" %></textarea>
                        </div>
                    </div>
                </div>

                <!-- Servicios -->
                <div class="form-panel">
                    <h3>🎯 Servicios de la Factura</h3>
                    
                    <div class="service-controls">
                        <select id="servicioSelect" class="form-control" style="flex: 1;">
                            <option value="">Seleccione un servicio para agregar</option>
                            <% 
                                // ✅ PATRÓN MVC CORRECTO: Solo usar datos del controlador
                                List<Servicio> servicios = (List<Servicio>) request.getAttribute("servicios");
                                if (servicios != null) {
                                    for (Servicio servicio : servicios) {
                            %>
                            <option value="<%= servicio.getIdServicio() %>" 
                                    data-nombre="<%= servicio.getNombre() %>" 
                                    data-precio="<%= servicio.getPrecio() %>">
                                <%= servicio.getNombre() %> - $<%= String.format("%.2f", servicio.getPrecio()) %>
                            </option>
                            <% 
                                    }
                                }
                            %>
                        </select>
                        <button type="button" class="btn btn-primary" onclick="agregarServicio()">➕ Agregar Servicio</button>
                    </div>
                    
                    <div class="services-section" id="serviciosContainer">
                        <p style="text-align: center; color: var(--text-light); font-style: italic;" id="noServicesMsg">
                            No hay servicios agregados. Seleccione servicios de la lista superior.
                        </p>
                    </div>
                </div>

                <!-- Total -->
                <div class="form-panel">
                    <div class="total-section">
                        <div class="total-row">
                            <span>Subtotal:</span>
                            <span id="subtotalDisplay">$0.00</span>
                        </div>
                        <div class="total-row">
                            <span>Impuesto (18%):</span>
                            <span id="impuestoDisplay">$0.00</span>
                        </div>
                        <div class="total-row final">
                            <span>Total:</span>
                            <span id="totalDisplay">$0.00</span>
                        </div>
                    </div>
                </div>

                <!-- Acciones -->
                <div class="actions-section">
                    <div>
                        <a href="<%= request.getContextPath() %>/FacturaControlador?accion=listar" class="btn btn-secondary">
                            ↩️ Volver a Facturas
                        </a>
                    </div>
                    <div style="display: flex; gap: 15px;">
                        <button type="reset" class="btn btn-warning" onclick="limpiarFormulario()">
                            🔄 Limpiar
                        </button>
                        <button type="submit" class="btn btn-success" id="btnGuardar">
                            💾 Crear Factura
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script>
        let serviciosAgregados = [];
        let contadorServicios = 0;

        function agregarServicio() {
            const select = document.getElementById('servicioSelect');
            const selectedOption = select.options[select.selectedIndex];
            
            if (!selectedOption.value) {
                alert('Por favor seleccione un servicio');
                return;
            }

            const idServicio = selectedOption.value;
            const nombreServicio = selectedOption.dataset.nombre;
            const precioServicio = parseFloat(selectedOption.dataset.precio);

            // Verificar si el servicio ya está agregado
            if (serviciosAgregados.find(s => s.id === idServicio)) {
                alert('Este servicio ya está agregado a la factura');
                return;
            }

            const servicio = {
                id: idServicio,
                nombre: nombreServicio,
                precio: precioServicio,
                cantidad: 1,
                contador: contadorServicios++
            };

            serviciosAgregados.push(servicio);
            actualizarVistaServicios();
            actualizarTotales();
            
            // Limpiar selección
            select.selectedIndex = 0;
        }

        function eliminarServicio(contador) {
            serviciosAgregados = serviciosAgregados.filter(s => s.contador !== contador);
            actualizarVistaServicios();
            actualizarTotales();
        }

        function actualizarCantidad(contador, nuevaCantidad) {
            const servicio = serviciosAgregados.find(s => s.contador === contador);
            if (servicio && nuevaCantidad > 0) {
                servicio.cantidad = parseInt(nuevaCantidad);
                actualizarTotales();
            }
        }

        function actualizarVistaServicios() {
            const container = document.getElementById('serviciosContainer');
            const noServicesMsg = document.getElementById('noServicesMsg');
            
            if (serviciosAgregados.length === 0) {
                container.innerHTML = '<p style="text-align: center; color: var(--text-light); font-style: italic;" id="noServicesMsg">No hay servicios agregados. Seleccione servicios de la lista superior.</p>';
                return;
            }

            let html = '';
            serviciosAgregados.forEach(servicio => {
                html += `
                    <div class="service-item">
                        <div>
                            <strong>${servicio.nombre}</strong>
                            <input type="hidden" name="servicios[]" value="${servicio.id}">
                        </div>
                        <div>
                            <input type="number" 
                                   name="cantidades[]" 
                                   value="${servicio.cantidad}" 
                                   min="1" 
                                   class="form-control" 
                                   style="width: 80px;"
                                   onchange="actualizarCantidad(${servicio.contador}, this.value)">
                        </div>
                        <div style="text-align: right;">
                            <strong>$${(servicio.precio * servicio.cantidad).toFixed(2)}</strong>
                        </div>
                        <div>
                            <button type="button" class="btn btn-danger" style="padding: 8px; font-size: 0.8em;" 
                                    onclick="eliminarServicio(${servicio.contador})">
                                🗑️
                            </button>
                        </div>
                    </div>
                `;
            });
            
            container.innerHTML = html;
        }

        function actualizarTotales() {
            let subtotal = 0;
            serviciosAgregados.forEach(servicio => {
                subtotal += servicio.precio * servicio.cantidad;
            });

            const impuesto = subtotal * 0.18; // 18% de impuesto
            const total = subtotal + impuesto;

            document.getElementById('subtotalDisplay').textContent = `$${subtotal.toFixed(2)}`;
            document.getElementById('impuestoDisplay').textContent = `$${impuesto.toFixed(2)}`;
            document.getElementById('totalDisplay').textContent = `$${total.toFixed(2)}`;
        }

        function limpiarFormulario() {
            serviciosAgregados = [];
            contadorServicios = 0;
            actualizarVistaServicios();
            actualizarTotales();
        }

        // Validación del formulario antes del envío
        document.getElementById('formFactura').addEventListener('submit', function(e) {
            if (serviciosAgregados.length === 0) {
                e.preventDefault();
                alert('Debe agregar al menos un servicio a la factura');
                return false;
            }

            const cliente = document.getElementById('idCliente').value;
            if (!cliente) {
                e.preventDefault();
                alert('Debe seleccionar un cliente');
                return false;
            }

            const metodoPago = document.getElementById('metodoPagoSugerido').value;
            if (!metodoPago) {
                e.preventDefault();
                alert('Debe seleccionar un método de pago');
                return false;
            }

            return true;
        });
    </script>
</body>
</html>