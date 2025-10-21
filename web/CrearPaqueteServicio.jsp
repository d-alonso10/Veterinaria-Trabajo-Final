<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, modelo.Servicio"%>
<%@page import="dao.ServicioDao"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Paquete de Servicios - Sistema PetCare</title>
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

        .btn-danger {
            background: var(--gradient-danger);
            color: var(--white);
        }

        .services-section {
            background: var(--bg-light);
            padding: 25px;
            border-radius: var(--radius);
            margin-bottom: 25px;
        }

        .available-services {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 15px;
            margin-bottom: 25px;
        }

        .service-card {
            background: var(--white);
            padding: 15px;
            border-radius: 12px;
            border: 2px solid #e0e0e0;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .service-card:hover {
            border-color: var(--primary-color);
        }

        .service-card.selected {
            border-color: var(--primary-color);
            background: rgba(171, 203, 213, 0.1);
        }

        .service-card h4 {
            color: var(--text-dark);
            margin-bottom: 5px;
        }

        .service-card p {
            color: var(--text-light);
            font-size: 0.9em;
            margin-bottom: 10px;
        }

        .service-card .price {
            font-weight: 700;
            color: var(--primary-dark);
            font-size: 1.1em;
        }

        .selected-services {
            background: var(--white);
            padding: 20px;
            border-radius: 12px;
            border: 2px dashed #dee2e6;
        }

        .selected-service-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px;
            background: var(--bg-light);
            border-radius: 8px;
            margin-bottom: 10px;
        }

        .selected-service-item:last-child {
            margin-bottom: 0;
        }

        .pricing-section {
            background: var(--primary-light);
            padding: 25px;
            border-radius: var(--radius);
            text-align: center;
        }

        .pricing-display {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .price-item {
            background: var(--white);
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .price-label {
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 8px;
        }

        .price-value {
            font-size: 1.5em;
            font-weight: 700;
            color: var(--primary-dark);
        }

        .discount-controls {
            display: flex;
            gap: 15px;
            align-items: center;
            justify-content: center;
            margin-top: 20px;
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

        .preview-panel {
            background: var(--white);
            padding: 20px;
            border-radius: var(--radius);
            border: 2px dashed #dee2e6;
            margin-bottom: 20px;
        }

        .preview-header {
            background: var(--gradient-primary);
            color: var(--white);
            padding: 20px;
            border-radius: 12px;
            text-align: center;
            margin-bottom: 15px;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .pricing-display {
                grid-template-columns: 1fr;
            }
            
            .available-services {
                grid-template-columns: 1fr;
            }
            
            .actions-section {
                flex-direction: column;
            }
            
            .discount-controls {
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
                <h1>📦 Crear Paquete de Servicios</h1>
                <p>Diseña paquetes especiales con descuentos atractivos para tus clientes</p>
            </div>

            <!-- Mensajes -->
            <% if (request.getAttribute("mensaje") != null) { %>
                <div class="message <%= request.getAttribute("tipoMensaje") != null ? request.getAttribute("tipoMensaje") : "info" %>">
                    <%= request.getAttribute("mensaje") %>
                </div>
            <% } %>

            <form action="PaqueteServicioControlador" method="post" id="formPaquete">
                <input type="hidden" name="accion" value="crearPaqueteServicio">
                
                <!-- Información Básica del Paquete -->
                <div class="form-panel">
                    <h3>📋 Información Básica</h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="nombre">Nombre del Paquete: *</label>
                            <input type="text" id="nombre" name="nombre" class="form-control" 
                                   placeholder="Ej: Paquete Completo de Belleza" 
                                   value="<%= request.getParameter("nombre") != null ? request.getParameter("nombre") : "" %>" 
                                   required maxlength="100">
                        </div>
                        
                        <div class="form-group">
                            <label for="estado">Estado Inicial:</label>
                            <select id="estado" name="estado" class="form-control">
                                <option value="ACTIVO" <%= "ACTIVO".equals(request.getParameter("estado")) ? "selected" : "" %>>✅ Activo</option>
                                <option value="INACTIVO" <%= "INACTIVO".equals(request.getParameter("estado")) ? "selected" : "" %>>❌ Inactivo</option>
                            </select>
                        </div>
                        
                        <div class="form-group full-width">
                            <label for="descripcion">Descripción:</label>
                            <textarea id="descripcion" name="descripcion" class="form-control" rows="3" 
                                      placeholder="Describe las ventajas y características del paquete..."
                                      maxlength="500"><%= request.getParameter("descripcion") != null ? request.getParameter("descripcion") : "" %></textarea>
                        </div>
                    </div>
                </div>

                <!-- Selección de Servicios -->
                <div class="form-panel">
                    <h3>🎯 Servicios del Paquete</h3>
                    
                    <div class="services-section">
                        <h4>Servicios Disponibles (Haga clic para agregar):</h4>
                        <div class="available-services">
                            <% 
                                // ✅ PATRÓN MVC CORRECTO: Solo usar datos del controlador
                                List<Servicio> servicios = (List<Servicio>) request.getAttribute("servicios");
                                if (servicios != null) {
                                    for (Servicio servicio : servicios) {
                            %>
                            <div class="service-card" data-id="<%= servicio.getIdServicio() %>" 
                                 data-name="<%= servicio.getNombre() %>" 
                                 data-price="<%= servicio.getPrecio() %>"
                                 data-description="<%= servicio.getDescripcion() != null ? servicio.getDescripcion() : "" %>"
                                 onclick="toggleService(this)">
                                <h4><%= servicio.getNombre() %></h4>
                                <p><%= servicio.getDescripcion() != null ? servicio.getDescripcion() : "Sin descripción" %></p>
                                <div class="price">$<%= String.format("%.2f", servicio.getPrecio()) %></div>
                            </div>
                            <% 
                                    }
                                }
                            %>
                        </div>
                        
                        <h4>Servicios Seleccionados:</h4>
                        <div class="selected-services" id="selectedServices">
                            <p style="text-align: center; color: var(--text-light); font-style: italic;">
                                No hay servicios seleccionados. Haga clic en los servicios de arriba para agregarlos.
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Configuración de Precios -->
                <div class="form-panel">
                    <div class="pricing-section">
                        <h3>💰 Configuración de Precios</h3>
                        
                        <div class="pricing-display">
                            <div class="price-item">
                                <div class="price-label">Precio Original</div>
                                <div class="price-value" id="precioOriginal">$0.00</div>
                            </div>
                            <div class="price-item">
                                <div class="price-label">Descuento</div>
                                <div class="price-value" id="montoDescuento">$0.00</div>
                            </div>
                            <div class="price-item">
                                <div class="price-label">Precio Final</div>
                                <div class="price-value" id="precioFinal">$0.00</div>
                            </div>
                        </div>
                        
                        <div class="discount-controls">
                            <label for="porcentajeDescuento" style="font-weight: 600;">Porcentaje de Descuento:</label>
                            <input type="number" id="porcentajeDescuento" name="porcentajeDescuento" 
                                   class="form-control" style="width: 120px;" 
                                   min="0" max="50" step="0.1" value="10" 
                                   onchange="actualizarPrecios()">
                            <span style="font-weight: 600;">%</span>
                        </div>
                        
                        <input type="hidden" name="serviciosIds" id="serviciosIds">
                        <input type="hidden" name="precioOriginalTotal" id="precioOriginalTotal">
                        <input type="hidden" name="precioFinalTotal" id="precioFinalTotal">
                    </div>
                </div>

                <!-- Vista Previa -->
                <div class="form-panel">
                    <div class="preview-panel">
                        <h3>👁️ Vista Previa del Paquete</h3>
                        
                        <div class="preview-header" id="previewHeader">
                            <div style="font-size: 1.4em; font-weight: 700;" id="previewNombre">Nombre del Paquete</div>
                            <div style="font-size: 2em; font-weight: 800;" id="previewPrecio">$0.00</div>
                            <div style="font-size: 0.9em;" id="previewDescuento">Sin descuento</div>
                        </div>
                        
                        <div id="previewDescripcion" style="color: var(--text-light); font-style: italic; margin-bottom: 15px;">
                            Descripción del paquete aparecerá aquí
                        </div>
                        
                        <div id="previewServicios">
                            <h4>🎯 Servicios Incluidos:</h4>
                            <p style="color: var(--text-light); font-style: italic;">No hay servicios seleccionados</p>
                        </div>
                    </div>
                </div>

                <!-- Acciones -->
                <div class="actions-section">
                    <div>
                        <a href="ListaPaquetesServicios.jsp" class="btn btn-secondary">
                            ↩️ Volver a Paquetes
                        </a>
                    </div>
                    <div style="display: flex; gap: 15px;">
                        <button type="button" class="btn btn-warning" onclick="limpiarFormulario()">
                            🔄 Limpiar Todo
                        </button>
                        <button type="submit" class="btn btn-success" id="btnGuardar">
                            💾 Crear Paquete
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script>
        let serviciosSeleccionados = [];

        function toggleService(element) {
            const id = element.dataset.id;
            const name = element.dataset.name;
            const price = parseFloat(element.dataset.price);
            
            if (element.classList.contains('selected')) {
                // Quitar servicio
                element.classList.remove('selected');
                serviciosSeleccionados = serviciosSeleccionados.filter(s => s.id !== id);
            } else {
                // Agregar servicio
                element.classList.add('selected');
                serviciosSeleccionados.push({
                    id: id,
                    name: name,
                    price: price
                });
            }
            
            actualizarServiciosSeleccionados();
            actualizarPrecios();
            actualizarVistaPrevia();
        }

        function actualizarServiciosSeleccionados() {
            const container = document.getElementById('selectedServices');
            
            if (serviciosSeleccionados.length === 0) {
                container.innerHTML = '<p style="text-align: center; color: var(--text-light); font-style: italic;">No hay servicios seleccionados. Haga clic en los servicios de arriba para agregarlos.</p>';
                return;
            }

            let html = '';
            serviciosSeleccionados.forEach(servicio => {
                html += `
                    <div class="selected-service-item">
                        <span><strong>${servicio.name}</strong></span>
                        <span>$${servicio.price.toFixed(2)}</span>
                        <button type="button" onclick="removerServicio('${servicio.id}')" 
                                style="background: var(--danger-color); color: white; border: none; border-radius: 50%; width: 25px; height: 25px; cursor: pointer;">
                            ×
                        </button>
                    </div>
                `;
            });
            
            container.innerHTML = html;
            
            // Actualizar campo oculto
            document.getElementById('serviciosIds').value = serviciosSeleccionados.map(s => s.id).join(',');
        }

        function removerServicio(id) {
            // Desmarcar en la vista
            const serviceCard = document.querySelector(`[data-id="${id}"]`);
            if (serviceCard) {
                serviceCard.classList.remove('selected');
            }
            
            // Quitar del array
            serviciosSeleccionados = serviciosSeleccionados.filter(s => s.id !== id);
            
            actualizarServiciosSeleccionados();
            actualizarPrecios();
            actualizarVistaPrevia();
        }

        function actualizarPrecios() {
            const precioOriginal = serviciosSeleccionados.reduce((total, servicio) => total + servicio.price, 0);
            const porcentajeDescuento = parseFloat(document.getElementById('porcentajeDescuento').value) || 0;
            const montoDescuento = precioOriginal * (porcentajeDescuento / 100);
            const precioFinal = precioOriginal - montoDescuento;

            document.getElementById('precioOriginal').textContent = `$${precioOriginal.toFixed(2)}`;
            document.getElementById('montoDescuento').textContent = `$${montoDescuento.toFixed(2)}`;
            document.getElementById('precioFinal').textContent = `$${precioFinal.toFixed(2)}`;
            
            // Actualizar campos ocultos
            document.getElementById('precioOriginalTotal').value = precioOriginal.toFixed(2);
            document.getElementById('precioFinalTotal').value = precioFinal.toFixed(2);
        }

        function actualizarVistaPrevia() {
            const nombre = document.getElementById('nombre').value || 'Nombre del Paquete';
            const descripcion = document.getElementById('descripcion').value || 'Descripción del paquete aparecerá aquí';
            const porcentajeDescuento = parseFloat(document.getElementById('porcentajeDescuento').value) || 0;
            const precioFinal = parseFloat(document.getElementById('precioFinalTotal').value) || 0;
            const precioOriginal = parseFloat(document.getElementById('precioOriginalTotal').value) || 0;

            document.getElementById('previewNombre').textContent = nombre;
            document.getElementById('previewPrecio').textContent = `$${precioFinal.toFixed(2)}`;
            document.getElementById('previewDescripcion').textContent = descripcion;
            
            if (porcentajeDescuento > 0) {
                document.getElementById('previewDescuento').innerHTML = `
                    🎁 ${porcentajeDescuento}% de descuento 
                    <small style="text-decoration: line-through; opacity: 0.7;">$${precioOriginal.toFixed(2)}</small>
                `;
            } else {
                document.getElementById('previewDescuento').textContent = 'Sin descuento';
            }

            // Actualizar servicios
            const serviciosContainer = document.getElementById('previewServicios');
            if (serviciosSeleccionados.length === 0) {
                serviciosContainer.innerHTML = '<h4>🎯 Servicios Incluidos:</h4><p style="color: var(--text-light); font-style: italic;">No hay servicios seleccionados</p>';
            } else {
                let serviciosHtml = '<h4>🎯 Servicios Incluidos:</h4><ul style="list-style: none; padding-left: 0;">';
                serviciosSeleccionados.forEach(servicio => {
                    serviciosHtml += `<li style="padding: 5px 0; border-bottom: 1px solid #f0f0f0;">
                        <div style="display: flex; justify-content: space-between;">
                            <span>✓ ${servicio.name}</span>
                            <span>$${servicio.price.toFixed(2)}</span>
                        </div>
                    </li>`;
                });
                serviciosHtml += '</ul>';
                serviciosContainer.innerHTML = serviciosHtml;
            }
        }

        function limpiarFormulario() {
            if (confirm('¿Está seguro de limpiar todo el formulario?')) {
                // Limpiar servicios seleccionados
                serviciosSeleccionados = [];
                document.querySelectorAll('.service-card.selected').forEach(card => {
                    card.classList.remove('selected');
                });
                
                // Resetear formulario
                document.getElementById('formPaquete').reset();
                
                // Actualizar vistas
                actualizarServiciosSeleccionados();
                actualizarPrecios();
                actualizarVistaPrevia();
            }
        }

        // Event listeners
        document.getElementById('nombre').addEventListener('input', actualizarVistaPrevia);
        document.getElementById('descripcion').addEventListener('input', actualizarVistaPrevia);
        document.getElementById('porcentajeDescuento').addEventListener('input', function() {
            actualizarPrecios();
            actualizarVistaPrevia();
        });

        // Validación del formulario
        document.getElementById('formPaquete').addEventListener('submit', function(e) {
            const nombre = document.getElementById('nombre').value.trim();
            if (!nombre) {
                e.preventDefault();
                alert('Debe ingresar un nombre para el paquete');
                return false;
            }

            if (serviciosSeleccionados.length < 2) {
                e.preventDefault();
                alert('Debe seleccionar al menos 2 servicios para crear un paquete');
                return false;
            }

            const porcentajeDescuento = parseFloat(document.getElementById('porcentajeDescuento').value);
            if (porcentajeDescuento < 0 || porcentajeDescuento > 50) {
                e.preventDefault();
                alert('El porcentaje de descuento debe estar entre 0% y 50%');
                return false;
            }

            return true;
        });

        // Inicializar vista previa
        actualizarVistaPrevia();
    </script>
</body>
</html>