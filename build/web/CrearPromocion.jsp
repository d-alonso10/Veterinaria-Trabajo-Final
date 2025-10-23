<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Promoción - Sistema PetCare</title>
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

        .discount-type-selector {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 20px;
        }

        .discount-option {
            padding: 20px;
            border: 2px solid #e0e0e0;
            border-radius: var(--radius);
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            background: var(--white);
        }

        .discount-option:hover {
            border-color: var(--primary-color);
        }

        .discount-option.selected {
            border-color: var(--primary-color);
            background: rgba(171, 203, 213, 0.1);
        }

        .discount-icon {
            font-size: 2em;
            margin-bottom: 10px;
        }

        .discount-label {
            font-weight: 600;
            font-size: 1.1em;
            margin-bottom: 5px;
        }

        .discount-description {
            color: var(--text-light);
            font-size: 0.9em;
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
            background: linear-gradient(135deg, var(--accent-color) 0%, #c299b8 100%);
            color: var(--white);
            padding: 25px;
            border-radius: 12px;
            text-align: center;
            margin-bottom: 15px;
        }

        .preview-badge {
            background: rgba(255, 255, 255, 0.2);
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.8em;
            margin-bottom: 10px;
            display: inline-block;
        }

        .preview-title {
            font-size: 1.4em;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .preview-discount {
            font-size: 2.5em;
            font-weight: 800;
            margin-bottom: 5px;
        }

        .tips-panel {
            background: linear-gradient(135deg, var(--info-color) 0%, #0b7dda 100%);
            color: var(--white);
            padding: 20px;
            border-radius: var(--radius);
            margin-bottom: 20px;
        }

        .tips-title {
            font-weight: 700;
            margin-bottom: 15px;
            font-size: 1.1em;
        }

        .tips-list {
            list-style: none;
            padding-left: 0;
        }

        .tips-list li {
            margin-bottom: 8px;
            padding-left: 20px;
            position: relative;
        }

        .tips-list li:before {
            content: "💡";
            position: absolute;
            left: 0;
            top: 0;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .discount-type-selector {
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
                <li class="menu-item">
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
                <li class="menu-item active">
                    <span>🎁</span>
                    <a href="<%= request.getContextPath() %>/PromocionControlador?accion=listar">Promociones</a>
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
                <h1>🎁 Crear Nueva Promoción</h1>
                <p>Diseña ofertas atractivas para incrementar las ventas y fidelizar clientes</p>
            </div>

            <!-- Tips Panel -->
            <div class="tips-panel">
                <div class="tips-title">💡 Consejos para Promociones Exitosas</div>
                <ul class="tips-list">
                    <li>Crea códigos fáciles de recordar (ej: VERANO2024, PRIMERAVEZ)</li>
                    <li>Establece límites de uso para crear urgencia</li>
                    <li>Define montos mínimos para aumentar el valor promedio de compra</li>
                    <li>Usa fechas específicas para promociones estacionales</li>
                </ul>
            </div>

            <!-- Mensajes -->
            <% if (request.getAttribute("mensaje") != null) { %>
                <div class="message <%= request.getAttribute("tipoMensaje") != null ? request.getAttribute("tipoMensaje") : "info" %>">
                    <%= request.getAttribute("mensaje") %>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/PromocionControlador" method="post" id="formPromocion">
                <input type="hidden" name="accion" value="crearPromocion">
                
                <!-- Información Básica -->
                <div class="form-panel">
                    <h3>📋 Información Básica</h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="nombre">Nombre de la Promoción: *</label>
                            <input type="text" id="nombre" name="nombre" class="form-control" 
                                   placeholder="Ej: Descuento Primera Visita" 
                                   value="<%= request.getParameter("nombre") != null ? request.getParameter("nombre") : "" %>" 
                                   required maxlength="100">
                        </div>
                        
                        <div class="form-group">
                            <label for="codigo">Código de Promoción: *</label>
                            <input type="text" id="codigo" name="codigo" class="form-control" 
                                   placeholder="Ej: PRIMERAVEZ" 
                                   value="<%= request.getParameter("codigo") != null ? request.getParameter("codigo") : "" %>" 
                                   required maxlength="20" style="text-transform: uppercase;">
                        </div>
                        
                        <div class="form-group full-width">
                            <label for="descripcion">Descripción:</label>
                            <textarea id="descripcion" name="descripcion" class="form-control" rows="3" 
                                      placeholder="Describe los beneficios y características de la promoción..."
                                      maxlength="500"><%= request.getParameter("descripcion") != null ? request.getParameter("descripcion") : "" %></textarea>
                        </div>
                    </div>
                </div>

                <!-- Tipo de Descuento -->
                <div class="form-panel">
                    <h3>💰 Tipo de Descuento</h3>
                    <div class="discount-type-selector">
                        <div class="discount-option" data-type="PORCENTAJE">
                            <div class="discount-icon">📊</div>
                            <div class="discount-label">Porcentaje</div>
                            <div class="discount-description">Descuento del X% del total</div>
                        </div>
                        <div class="discount-option" data-type="MONTO_FIJO">
                            <div class="discount-icon">💵</div>
                            <div class="discount-label">Monto Fijo</div>
                            <div class="discount-description">Descuento de $X pesos</div>
                        </div>
                    </div>
                    <input type="hidden" name="tipoDescuento" id="tipoDescuentoSeleccionado" required>

                    <div class="form-grid">
                        <div class="form-group">
                            <label for="valorDescuento">Valor del Descuento: *</label>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <span id="simboloDescuento" style="font-weight: bold; font-size: 1.2em;">-</span>
                                <input type="number" id="valorDescuento" name="valorDescuento" class="form-control" 
                                       step="0.01" min="0.01" 
                                       placeholder="0.00" required 
                                       onchange="actualizarVistaPrevia()">
                                <span id="unidadDescuento" style="font-weight: bold; font-size: 1.2em;">-</span>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="montoMinimo">Monto Mínimo de Compra:</label>
                            <input type="number" id="montoMinimo" name="montoMinimo" class="form-control" 
                                   step="0.01" min="0" 
                                   placeholder="0.00 (Opcional)" 
                                   value="<%= request.getParameter("montoMinimo") != null ? request.getParameter("montoMinimo") : "" %>">
                        </div>
                    </div>
                </div>

                <!-- Vigencia y Límites -->
                <div class="form-panel">
                    <h3>📅 Vigencia y Límites</h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="fechaInicio">Fecha de Inicio: *</label>
                            <input type="date" id="fechaInicio" name="fechaInicio" class="form-control" 
                                   value="<%= request.getParameter("fechaInicio") != null ? request.getParameter("fechaInicio") : "" %>" 
                                   required>
                        </div>
                        
                        <div class="form-group">
                            <label for="fechaFin">Fecha de Fin: *</label>
                            <input type="date" id="fechaFin" name="fechaFin" class="form-control" 
                                   value="<%= request.getParameter("fechaFin") != null ? request.getParameter("fechaFin") : "" %>" 
                                   required>
                        </div>
                        
                        <div class="form-group">
                            <label for="usosMaximos">Límite de Usos:</label>
                            <input type="number" id="usosMaximos" name="usosMaximos" class="form-control" 
                                   min="1" placeholder="Sin límite (Opcional)" 
                                   value="<%= request.getParameter("usosMaximos") != null ? request.getParameter("usosMaximos") : "" %>">
                        </div>
                        
                        <div class="form-group">
                            <label for="estado">Estado Inicial:</label>
                            <select id="estado" name="estado" class="form-control">
                                <option value="ACTIVA" <%= "ACTIVA".equals(request.getParameter("estado")) ? "selected" : "" %>>🔥 Activa</option>
                                <option value="INACTIVA" <%= "INACTIVA".equals(request.getParameter("estado")) ? "selected" : "" %>>⏸️ Inactiva</option>
                            </select>
                        </div>
                        
                        <div class="form-group full-width">
                            <label for="condicionesUso">Términos y Condiciones:</label>
                            <textarea id="condicionesUso" name="condicionesUso" class="form-control" rows="4" 
                                      placeholder="Ej: Válido solo para nuevos clientes. No acumulable con otras promociones. Un uso por cliente..."
                                      maxlength="1000"><%= request.getParameter("condicionesUso") != null ? request.getParameter("condicionesUso") : "" %></textarea>
                        </div>
                    </div>
                </div>

                <!-- Vista Previa -->
                <div class="form-panel">
                    <div class="preview-panel">
                        <h3>👁️ Vista Previa de la Promoción</h3>
                        
                        <div class="preview-header" id="previewHeader">
                            <div class="preview-badge">🔥 OFERTA ESPECIAL</div>
                            <div class="preview-title" id="previewNombre">Nombre de la Promoción</div>
                            <div class="preview-discount" id="previewDescuento">-% OFF</div>
                            <div style="font-size: 0.9em;" id="previewCodigo">Código: PROMOCION</div>
                        </div>
                        
                        <div id="previewDescripcion" style="color: var(--text-light); font-style: italic; margin-bottom: 15px;">
                            Descripción de la promoción aparecerá aquí
                        </div>
                        
                        <div id="previewCondiciones">
                            <strong>📋 Condiciones:</strong>
                            <div style="color: var(--text-light); font-size: 0.9em;">
                                Las condiciones aparecerán aquí
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Acciones -->
                <div class="actions-section">
                    <div>
                        <a href="ListaPromociones.jsp" class="btn btn-secondary">
                            ↩️ Volver a Promociones
                        </a>
                    </div>
                    <div style="display: flex; gap: 15px;">
                        <button type="button" class="btn btn-warning" onclick="limpiarFormulario()">
                            🔄 Limpiar
                        </button>
                        <button type="submit" class="btn btn-success" id="btnGuardar">
                            💾 Crear Promoción
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Selección de tipo de descuento
        document.querySelectorAll('.discount-option').forEach(option => {
            option.addEventListener('click', function() {
                // Limpiar selección anterior
                document.querySelectorAll('.discount-option').forEach(opt => opt.classList.remove('selected'));
                
                // Seleccionar nueva opción
                this.classList.add('selected');
                
                const tipo = this.dataset.type;
                document.getElementById('tipoDescuentoSeleccionado').value = tipo;
                
                // Actualizar símbolos
                if (tipo === 'PORCENTAJE') {
                    document.getElementById('simboloDescuento').textContent = '%';
                    document.getElementById('unidadDescuento').textContent = 'OFF';
                    document.getElementById('valorDescuento').max = '100';
                    document.getElementById('valorDescuento').placeholder = 'Ej: 15';
                } else {
                    document.getElementById('simboloDescuento').textContent = '$';
                    document.getElementById('unidadDescuento').textContent = 'OFF';
                    document.getElementById('valorDescuento').removeAttribute('max');
                    document.getElementById('valorDescuento').placeholder = 'Ej: 50.00';
                }
                
                actualizarVistaPrevia();
            });
        });

        // Actualizar vista previa en tiempo real
        document.getElementById('nombre').addEventListener('input', actualizarVistaPrevia);
        document.getElementById('codigo').addEventListener('input', actualizarVistaPrevia);
        document.getElementById('descripcion').addEventListener('input', actualizarVistaPrevia);
        document.getElementById('condicionesUso').addEventListener('input', actualizarVistaPrevia);
        document.getElementById('valorDescuento').addEventListener('input', actualizarVistaPrevia);

        function actualizarVistaPrevia() {
            const nombre = document.getElementById('nombre').value || 'Nombre de la Promoción';
            const codigo = document.getElementById('codigo').value || 'PROMOCION';
            const descripcion = document.getElementById('descripcion').value || 'Descripción de la promoción aparecerá aquí';
            const condiciones = document.getElementById('condicionesUso').value || 'Las condiciones aparecerán aquí';
            const tipo = document.getElementById('tipoDescuentoSeleccionado').value;
            const valor = document.getElementById('valorDescuento').value || '0';
            
            // Actualizar contenido
            document.getElementById('previewNombre').textContent = nombre;
            document.getElementById('previewCodigo').textContent = `Código: ${codigo.toUpperCase()}`;
            document.getElementById('previewDescripcion').textContent = descripcion;
            document.querySelector('#previewCondiciones div').textContent = condiciones;
            
            // Actualizar descuento
            if (tipo === 'PORCENTAJE') {
                document.getElementById('previewDescuento').textContent = `${valor}% OFF`;
            } else if (tipo === 'MONTO_FIJO') {
                document.getElementById('previewDescuento').textContent = `$${valor} OFF`;
            } else {
                document.getElementById('previewDescuento').textContent = '-% OFF';
            }
        }

        function limpiarFormulario() {
            if (confirm('¿Está seguro de limpiar todo el formulario?')) {
                document.getElementById('formPromocion').reset();
                document.querySelectorAll('.discount-option').forEach(opt => opt.classList.remove('selected'));
                document.getElementById('tipoDescuentoSeleccionado').value = '';
                document.getElementById('simboloDescuento').textContent = '-';
                document.getElementById('unidadDescuento').textContent = '-';
                actualizarVistaPrevia();
            }
        }

        // Auto-generar código basado en el nombre
        document.getElementById('nombre').addEventListener('blur', function() {
            const codigoInput = document.getElementById('codigo');
            if (!codigoInput.value.trim()) {
                let codigo = this.value.trim()
                    .replace(/[^a-zA-Z0-9\s]/g, '') // Remover caracteres especiales
                    .replace(/\s+/g, '') // Remover espacios
                    .substring(0, 15) // Limitar a 15 caracteres
                    .toUpperCase();
                codigoInput.value = codigo;
                actualizarVistaPrevia();
            }
        });

        // Validar fechas
        document.getElementById('fechaInicio').addEventListener('change', function() {
            const fechaFin = document.getElementById('fechaFin');
            if (this.value) {
                fechaFin.min = this.value;
                if (fechaFin.value && fechaFin.value < this.value) {
                    fechaFin.value = this.value;
                }
            }
        });

        // Validación del formulario
        document.getElementById('formPromocion').addEventListener('submit', function(e) {
            const tipo = document.getElementById('tipoDescuentoSeleccionado').value;
            if (!tipo) {
                e.preventDefault();
                alert('Debe seleccionar un tipo de descuento');
                return false;
            }

            const valor = parseFloat(document.getElementById('valorDescuento').value);
            if (!valor || valor <= 0) {
                e.preventDefault();
                alert('Debe ingresar un valor de descuento válido');
                return false;
            }

            if (tipo === 'PORCENTAJE' && valor > 100) {
                e.preventDefault();
                alert('El porcentaje de descuento no puede ser mayor a 100%');
                return false;
            }

            const fechaInicio = new Date(document.getElementById('fechaInicio').value);
            const fechaFin = new Date(document.getElementById('fechaFin').value);
            
            if (fechaFin <= fechaInicio) {
                e.preventDefault();
                alert('La fecha de fin debe ser posterior a la fecha de inicio');
                return false;
            }

            return true;
        });

        // Inicializar fecha mínima como hoy
        const hoy = new Date().toISOString().split('T')[0];
        document.getElementById('fechaInicio').value = hoy;
        document.getElementById('fechaInicio').min = hoy;

        // Inicializar vista previa
        actualizarVistaPrevia();
    </script>
</body>
</html>