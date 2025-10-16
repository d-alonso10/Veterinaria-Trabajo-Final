<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, modelo.FacturaClienteDTO, modelo.Factura"%>
<%@page import="dao.FacturaDao"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrar Pago - Sistema PetCare</title>
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

        .btn-warning {
            background: var(--gradient-warning);
            color: var(--text-dark);
        }

        .btn-info {
            background: linear-gradient(135deg, var(--info-color) 0%, #0b7dda 100%);
            color: var(--white);
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

        .invoice-info {
            background: var(--bg-light);
            padding: 20px;
            border-radius: var(--radius);
            border: 2px solid #dee2e6;
            margin-bottom: 20px;
        }

        .invoice-header {
            font-weight: 600;
            margin-bottom: 15px;
            color: var(--text-dark);
            font-size: 1.1em;
        }

        .invoice-details {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        .invoice-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #dee2e6;
        }

        .invoice-item:last-child {
            border-bottom: none;
            font-weight: 600;
            font-size: 1.1em;
        }

        .payment-methods {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        .method-option {
            padding: 20px;
            border: 2px solid #e0e0e0;
            border-radius: var(--radius);
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            background: var(--white);
        }

        .method-option:hover {
            border-color: var(--primary-color);
        }

        .method-option.selected {
            border-color: var(--primary-color);
            background: rgba(171, 203, 213, 0.1);
        }

        .method-icon {
            font-size: 2em;
            margin-bottom: 10px;
        }

        .method-label {
            font-weight: 600;
            font-size: 1em;
        }

        .method-description {
            color: var(--text-light);
            font-size: 0.9em;
            margin-top: 5px;
        }

        .payment-details {
            background: var(--white);
            padding: 20px;
            border-radius: var(--radius);
            border: 1px solid #dee2e6;
            display: none;
        }

        .payment-details.active {
            display: block;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .invoice-details {
                grid-template-columns: 1fr;
            }
            
            .payment-methods {
                grid-template-columns: 1fr;
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
                <h1>💳 Registrar Nuevo Pago</h1>
                <p>Procesa el pago de facturas pendientes</p>
            </div>

            <!-- Mensajes -->
            <% if (request.getAttribute("mensaje") != null) { %>
                <div class="message <%= request.getAttribute("tipoMensaje") != null ? request.getAttribute("tipoMensaje") : "info" %>">
                    <%= request.getAttribute("mensaje") %>
                </div>
            <% } %>

            <form action="PagoControlador" method="post" id="formPago">
                <input type="hidden" name="accion" value="registrarPago">
                
                <!-- Selección de Factura -->
                <div class="form-panel">
                    <h3>📄 Seleccionar Factura a Pagar</h3>
                    <div class="form-grid">
                        <div class="form-group full-width">
                            <label for="idFactura">Factura Pendiente: *</label>
                            <select id="idFactura" name="idFactura" class="form-control" required onchange="mostrarInfoFactura()">
                                <option value="">Seleccione una factura pendiente</option>
                                <% 
                                    FacturaDao facturaDao = new FacturaDao();
                                    List<FacturaClienteDTO> facturasPendientes = facturaDao.listarFacturasPendientes();
                                    for (FacturaClienteDTO factura : facturasPendientes) {
                                %>
                                <option value="<%= factura.getIdFactura() %>" 
                                        data-serie="<%= factura.getSerie() %>"
                                        data-numero="<%= factura.getNumero() %>"
                                        data-cliente="<%= factura.getNombreCliente() %> <%= factura.getApellidoCliente() %>"
                                        data-telefono="<%= factura.getTelefonoCliente() %>"
                                        data-fecha="<%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(factura.getFechaEmision()) %>"
                                        data-subtotal="<%= factura.getSubtotal() %>"
                                        data-impuesto="<%= factura.getImpuesto() %>"
                                        data-total="<%= factura.getTotal() %>"
                                        data-metodo-sugerido="<%= factura.getMetodoPagoSugerido() %>"
                                        <%= request.getParameter("idFactura") != null && 
                                           request.getParameter("idFactura").equals(String.valueOf(factura.getIdFactura())) ? "selected" : "" %>>
                                    <%= factura.getSerie() %>-<%= factura.getNumero() %> - 
                                    <%= factura.getNombreCliente() %> <%= factura.getApellidoCliente() %> - 
                                    $<%= String.format("%.2f", factura.getTotal()) %>
                                </option>
                                <% } %>
                            </select>
                        </div>
                    </div>

                    <!-- Información de la Factura Seleccionada -->
                    <div class="invoice-info" id="invoiceInfo" style="display: none;">
                        <div class="invoice-header">📋 Detalles de la Factura</div>
                        <div class="invoice-details">
                            <div>
                                <div class="invoice-item">
                                    <span>📄 Serie/Número:</span>
                                    <strong id="facturaNumero">-</strong>
                                </div>
                                <div class="invoice-item">
                                    <span>👤 Cliente:</span>
                                    <span id="facturaCliente">-</span>
                                </div>
                                <div class="invoice-item">
                                    <span>📱 Teléfono:</span>
                                    <span id="facturaTelefono">-</span>
                                </div>
                                <div class="invoice-item">
                                    <span>📅 Fecha Emisión:</span>
                                    <span id="facturaFecha">-</span>
                                </div>
                            </div>
                            <div>
                                <div class="invoice-item">
                                    <span>💰 Subtotal:</span>
                                    <span id="facturaSubtotal">$0.00</span>
                                </div>
                                <div class="invoice-item">
                                    <span>🏷️ Impuesto:</span>
                                    <span id="facturaImpuesto">$0.00</span>
                                </div>
                                <div class="invoice-item">
                                    <span>💳 Total a Pagar:</span>
                                    <strong id="facturaTotal">$0.00</strong>
                                </div>
                                <div class="invoice-item">
                                    <span>💡 Método Sugerido:</span>
                                    <span id="facturaMetodoSugerido">-</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Método de Pago -->
                <div class="form-panel">
                    <h3>💳 Método de Pago</h3>
                    <div class="payment-methods">
                        <div class="method-option" data-method="EFECTIVO">
                            <div class="method-icon">💵</div>
                            <div class="method-label">Efectivo</div>
                            <div class="method-description">Pago en efectivo</div>
                        </div>
                        <div class="method-option" data-method="TARJETA_CREDITO">
                            <div class="method-icon">💳</div>
                            <div class="method-label">Tarjeta de Crédito</div>
                            <div class="method-description">Visa, MasterCard, etc.</div>
                        </div>
                        <div class="method-option" data-method="TARJETA_DEBITO">
                            <div class="method-icon">💎</div>
                            <div class="method-label">Tarjeta de Débito</div>
                            <div class="method-description">Débito bancario</div>
                        </div>
                        <div class="method-option" data-method="TRANSFERENCIA">
                            <div class="method-icon">🏦</div>
                            <div class="method-label">Transferencia</div>
                            <div class="method-description">Transferencia bancaria</div>
                        </div>
                    </div>
                    <input type="hidden" name="metodoPago" id="metodoPagoSeleccionado" required>
                </div>

                <!-- Detalles del Pago -->
                <div class="form-panel">
                    <h3>📝 Detalles del Pago</h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="monto">Monto a Pagar: *</label>
                            <input type="number" id="monto" name="monto" class="form-control" 
                                   step="0.01" min="0.01" 
                                   placeholder="0.00" required readonly>
                        </div>
                        
                        <div class="form-group">
                            <label for="fechaPago">Fecha del Pago:</label>
                            <input type="datetime-local" id="fechaPago" name="fechaPago" class="form-control" 
                                   value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm").format(new java.util.Date()) %>">
                        </div>
                        
                        <div class="form-group full-width">
                            <label for="referenciaTransaccion">Referencia de Transacción:</label>
                            <input type="text" id="referenciaTransaccion" name="referenciaTransaccion" class="form-control" 
                                   placeholder="Número de referencia, autorización, etc." 
                                   maxlength="100">
                        </div>
                        
                        <div class="form-group full-width">
                            <label for="observaciones">Observaciones:</label>
                            <textarea id="observaciones" name="observaciones" class="form-control" rows="3" 
                                      placeholder="Observaciones adicionales sobre el pago..."></textarea>
                        </div>
                    </div>

                    <!-- Detalles específicos por método de pago -->
                    <div class="payment-details" id="detallesEfectivo">
                        <h4>💵 Detalles del Pago en Efectivo</h4>
                        <div class="form-grid">
                            <div class="form-group">
                                <label for="montoRecibido">Monto Recibido:</label>
                                <input type="number" id="montoRecibido" name="montoRecibido" class="form-control" 
                                       step="0.01" min="0" placeholder="0.00" onchange="calcularCambio()">
                            </div>
                            <div class="form-group">
                                <label for="cambio">Cambio a Entregar:</label>
                                <input type="number" id="cambio" name="cambio" class="form-control" 
                                       step="0.01" placeholder="0.00" readonly>
                            </div>
                        </div>
                    </div>

                    <div class="payment-details" id="detallesTarjeta">
                        <h4>💳 Detalles de Tarjeta</h4>
                        <div class="form-grid">
                            <div class="form-group">
                                <label for="ultimos4Digitos">Últimos 4 dígitos:</label>
                                <input type="text" id="ultimos4Digitos" name="ultimos4Digitos" class="form-control" 
                                       maxlength="4" placeholder="****" pattern="[0-9]{4}">
                            </div>
                            <div class="form-group">
                                <label for="tipoTarjeta">Tipo de Tarjeta:</label>
                                <select id="tipoTarjeta" name="tipoTarjeta" class="form-control">
                                    <option value="">Seleccione tipo</option>
                                    <option value="VISA">Visa</option>
                                    <option value="MASTERCARD">MasterCard</option>
                                    <option value="AMERICAN_EXPRESS">American Express</option>
                                    <option value="OTRA">Otra</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="payment-details" id="detallesTransferencia">
                        <h4>🏦 Detalles de Transferencia</h4>
                        <div class="form-grid">
                            <div class="form-group">
                                <label for="bancoOrigen">Banco de Origen:</label>
                                <input type="text" id="bancoOrigen" name="bancoOrigen" class="form-control" 
                                       placeholder="Nombre del banco" maxlength="100">
                            </div>
                            <div class="form-group">
                                <label for="numeroOperacion">Número de Operación:</label>
                                <input type="text" id="numeroOperacion" name="numeroOperacion" class="form-control" 
                                       placeholder="Número de la transferencia" maxlength="50">
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Acciones -->
                <div class="actions-section">
                    <div>
                        <a href="ListaPagos.jsp" class="btn btn-secondary">
                            ↩️ Volver a Pagos
                        </a>
                    </div>
                    <div style="display: flex; gap: 15px;">
                        <button type="button" class="btn btn-info" onclick="previsualizar()">
                            👁️ Previsualizar
                        </button>
                        <button type="reset" class="btn btn-warning" onclick="limpiarFormulario()">
                            🔄 Limpiar
                        </button>
                        <button type="submit" class="btn btn-success" id="btnGuardar">
                            💾 Registrar Pago
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script>
        function mostrarInfoFactura() {
            const select = document.getElementById('idFactura');
            const selectedOption = select.options[select.selectedIndex];
            const infoDiv = document.getElementById('invoiceInfo');
            
            if (selectedOption.value) {
                // Mostrar información de la factura
                document.getElementById('facturaNumero').textContent = selectedOption.dataset.serie + '-' + selectedOption.dataset.numero;
                document.getElementById('facturaCliente').textContent = selectedOption.dataset.cliente;
                document.getElementById('facturaTelefono').textContent = selectedOption.dataset.telefono;
                document.getElementById('facturaFecha').textContent = selectedOption.dataset.fecha;
                document.getElementById('facturaSubtotal').textContent = '$' + parseFloat(selectedOption.dataset.subtotal).toFixed(2);
                document.getElementById('facturaImpuesto').textContent = '$' + parseFloat(selectedOption.dataset.impuesto).toFixed(2);
                document.getElementById('facturaTotal').textContent = '$' + parseFloat(selectedOption.dataset.total).toFixed(2);
                document.getElementById('facturaMetodoSugerido').textContent = selectedOption.dataset.metodoSugerido.replace('_', ' ');
                
                // Actualizar monto a pagar
                document.getElementById('monto').value = parseFloat(selectedOption.dataset.total).toFixed(2);
                
                infoDiv.style.display = 'block';
                
                // Preseleccionar método sugerido
                const metodoSugerido = selectedOption.dataset.metodoSugerido;
                document.querySelectorAll('.method-option').forEach(option => {
                    if (option.dataset.method === metodoSugerido) {
                        seleccionarMetodoPago(option);
                    }
                });
            } else {
                infoDiv.style.display = 'none';
                document.getElementById('monto').value = '';
            }
        }

        // Selección de método de pago
        document.querySelectorAll('.method-option').forEach(option => {
            option.addEventListener('click', function() {
                seleccionarMetodoPago(this);
            });
        });

        function seleccionarMetodoPago(element) {
            // Limpiar selección anterior
            document.querySelectorAll('.method-option').forEach(opt => opt.classList.remove('selected'));
            document.querySelectorAll('.payment-details').forEach(detail => detail.classList.remove('active'));
            
            // Seleccionar nueva opción
            element.classList.add('selected');
            
            const method = element.dataset.method;
            document.getElementById('metodoPagoSeleccionado').value = method;
            
            // Mostrar detalles específicos
            if (method === 'EFECTIVO') {
                document.getElementById('detallesEfectivo').classList.add('active');
            } else if (method === 'TARJETA_CREDITO' || method === 'TARJETA_DEBITO') {
                document.getElementById('detallesTarjeta').classList.add('active');
            } else if (method === 'TRANSFERENCIA') {
                document.getElementById('detallesTransferencia').classList.add('active');
            }
        }

        function calcularCambio() {
            const monto = parseFloat(document.getElementById('monto').value) || 0;
            const recibido = parseFloat(document.getElementById('montoRecibido').value) || 0;
            const cambio = recibido - monto;
            document.getElementById('cambio').value = cambio >= 0 ? cambio.toFixed(2) : '0.00';
        }

        function previsualizar() {
            const factura = document.getElementById('idFactura');
            const metodo = document.getElementById('metodoPagoSeleccionado').value;
            const monto = document.getElementById('monto').value;
            
            if (!factura.value || !metodo || !monto) {
                alert('Por favor complete los campos obligatorios antes de previsualizar');
                return;
            }
            
            const selectedOption = factura.options[factura.selectedIndex];
            const preview = `
                Resumen del Pago:
                
                Factura: ${selectedOption.dataset.serie}-${selectedOption.dataset.numero}
                Cliente: ${selectedOption.dataset.cliente}
                Monto: $${parseFloat(monto).toFixed(2)}
                Método: ${metodo.replace('_', ' ')}
                Fecha: ${document.getElementById('fechaPago').value}
                
                ¿Desea continuar con el registro?
            `;
            
            if (confirm(preview)) {
                document.getElementById('formPago').submit();
            }
        }

        function limpiarFormulario() {
            document.querySelectorAll('.method-option').forEach(opt => opt.classList.remove('selected'));
            document.querySelectorAll('.payment-details').forEach(detail => detail.classList.remove('active'));
            document.getElementById('invoiceInfo').style.display = 'none';
            document.getElementById('metodoPagoSeleccionado').value = '';
        }

        // Validación del formulario
        document.getElementById('formPago').addEventListener('submit', function(e) {
            const factura = document.getElementById('idFactura').value;
            const metodo = document.getElementById('metodoPagoSeleccionado').value;
            const monto = parseFloat(document.getElementById('monto').value);
            
            if (!factura) {
                e.preventDefault();
                alert('Debe seleccionar una factura');
                return false;
            }
            
            if (!metodo) {
                e.preventDefault();
                alert('Debe seleccionar un método de pago');
                return false;
            }
            
            if (!monto || monto <= 0) {
                e.preventDefault();
                alert('El monto debe ser mayor a 0');
                return false;
            }
            
            // Validaciones específicas por método
            if (metodo === 'EFECTIVO') {
                const recibido = parseFloat(document.getElementById('montoRecibido').value) || 0;
                if (recibido < monto) {
                    e.preventDefault();
                    alert('El monto recibido debe ser mayor o igual al monto a pagar');
                    return false;
                }
            }
            
            return true;
        });

        // Inicializar fecha actual
        const ahora = new Date();
        ahora.setMinutes(ahora.getMinutes() - ahora.getTimezoneOffset());
        document.getElementById('fechaPago').value = ahora.toISOString().slice(0, 16);
    </script>
</body>
</html>