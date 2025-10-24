<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, modelo.Cliente"%>
<%@page import="dao.ClienteDao"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Notificación - Sistema PetCare</title>
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

        .form-control[type="textarea"] {
            resize: vertical;
            min-height: 120px;
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

        .notification-preview {
            background: var(--bg-light);
            padding: 20px;
            border-radius: var(--radius);
            border: 2px dashed #dee2e6;
            margin-top: 20px;
        }

        .preview-header {
            font-weight: 600;
            margin-bottom: 15px;
            color: var(--text-dark);
        }

        .preview-card {
            background: var(--white);
            padding: 20px;
            border-radius: 12px;
            border-left: 5px solid var(--info-color);
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .preview-title {
            font-size: 1.1em;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .preview-meta {
            color: var(--text-light);
            font-size: 0.9em;
            margin-bottom: 15px;
        }

        .preview-message {
            color: var(--text-dark);
            line-height: 1.6;
        }

        .type-selector {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .type-option {
            flex: 1;
            padding: 15px;
            border: 2px solid #e0e0e0;
            border-radius: var(--radius);
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            background: var(--white);
        }

        .type-option:hover {
            border-color: var(--primary-color);
        }

        .type-option.selected {
            border-color: var(--primary-color);
            background: rgba(171, 203, 213, 0.1);
        }

        .type-icon {
            font-size: 1.5em;
            margin-bottom: 8px;
        }

        .type-label {
            font-weight: 500;
            font-size: 0.9em;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .type-selector {
                flex-direction: column;
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
                <h1>🔔 Crear Nueva Notificación</h1>
                <p>Envía notificaciones personalizadas a los clientes</p>
            </div>

            <!-- Mensajes -->
            <% if (request.getAttribute("mensaje") != null) { %>
                <div class="message <%= request.getAttribute("tipoMensaje") != null ? request.getAttribute("tipoMensaje") : "info" %>">
                    <%= request.getAttribute("mensaje") %>
                </div>
            <% } %>

            <form action="NotificacionControlador" method="post" id="formNotificacion">
                <input type="hidden" name="accion" value="registrarNotificacion">
                
                <!-- Tipo de Notificación -->
                <div class="form-panel">
                    <h3>📋 Tipo de Notificación</h3>
                    <div class="type-selector">
                        <div class="type-option" data-type="CITA_RECORDATORIO">
                            <div class="type-icon">📅</div>
                            <div class="type-label">Recordatorio de Cita</div>
                        </div>
                        <div class="type-option" data-type="PAGO_PENDIENTE">
                            <div class="type-icon">💰</div>
                            <div class="type-label">Pago Pendiente</div>
                        </div>
                        <div class="type-option" data-type="PROMOCION">
                            <div class="type-icon">🎁</div>
                            <div class="type-label">Promoción</div>
                        </div>
                        <div class="type-option" data-type="SISTEMA">
                            <div class="type-icon">⚙️</div>
                            <div class="type-label">Sistema</div>
                        </div>
                        <div class="type-option" data-type="EMERGENCIA">
                            <div class="type-icon">🚨</div>
                            <div class="type-label">Emergencia</div>
                        </div>
                    </div>
                    <input type="hidden" name="tipo" id="tipoSeleccionado" required>
                </div>

                <!-- Información de la Notificación -->
                <div class="form-panel">
                    <h3>📝 Detalles de la Notificación</h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="idCliente">Cliente Destinatario: *</label>
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
                            <label for="prioridad">Prioridad: *</label>
                            <select id="prioridad" name="prioridad" class="form-control" required>
                                <option value="">Seleccione prioridad</option>
                                <option value="BAJA" <%= "BAJA".equals(request.getParameter("prioridad")) ? "selected" : "" %>>🟢 Baja</option>
                                <option value="MEDIA" <%= "MEDIA".equals(request.getParameter("prioridad")) ? "selected" : "" %>>🟡 Media</option>
                                <option value="ALTA" <%= "ALTA".equals(request.getParameter("prioridad")) ? "selected" : "" %>>🔴 Alta</option>
                            </select>
                        </div>
                        
                        <div class="form-group full-width">
                            <label for="titulo">Título de la Notificación: *</label>
                            <input type="text" id="titulo" name="titulo" class="form-control" 
                                   placeholder="Ingrese el título de la notificación..." 
                                   value="<%= request.getParameter("titulo") != null ? request.getParameter("titulo") : "" %>" 
                                   required maxlength="200">
                        </div>
                        
                        <div class="form-group full-width">
                            <label for="mensaje">Mensaje: *</label>
                            <textarea id="mensaje" name="mensaje" class="form-control" rows="5" 
                                      placeholder="Escriba el mensaje completo de la notificación..." 
                                      required maxlength="1000"><%= request.getParameter("mensaje") != null ? request.getParameter("mensaje") : "" %></textarea>
                        </div>
                        
                        <div class="form-group full-width">
                            <label for="metadatos">Información Adicional (JSON):</label>
                            <textarea id="metadatos" name="metadatos" class="form-control" rows="3" 
                                      placeholder='Ejemplo: {"cita_id": 123, "fecha": "2024-01-15", "servicio": "Consulta General"}'><%= request.getParameter("metadatos") != null ? request.getParameter("metadatos") : "" %></textarea>
                            <small style="color: var(--text-light); font-size: 0.9em;">
                                Información opcional en formato JSON para contexto adicional
                            </small>
                        </div>
                    </div>
                </div>

                <!-- Vista Previa -->
                <div class="form-panel">
                    <div class="notification-preview">
                        <div class="preview-header">👁️ Vista Previa de la Notificación</div>
                        <div class="preview-card" id="previewCard">
                            <div class="preview-title" id="previewTitulo">
                                <span id="previewIcon">🔔</span> Título de la notificación
                            </div>
                            <div class="preview-meta">
                                📅 <span id="previewFecha"></span> • 👤 <span id="previewCliente">Cliente seleccionado</span>
                            </div>
                            <div class="preview-message" id="previewMensaje">
                                Mensaje de la notificación aparecerá aquí...
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Acciones -->
                <div class="actions-section">
                    <div>
                        <a href="UtilidadesNotificaciones.jsp" class="btn btn-secondary">
                            ↩️ Volver a Notificaciones
                        </a>
                    </div>
                    <div style="display: flex; gap: 15px;">
                        <button type="reset" class="btn btn-warning" onclick="limpiarFormulario()">
                            🔄 Limpiar
                        </button>
                        <button type="submit" class="btn btn-success" id="btnGuardar">
                            📤 Enviar Notificación
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Iconos por tipo de notificación
        const tipoIconos = {
            'CITA_RECORDATORIO': '📅',
            'PAGO_PENDIENTE': '💰',
            'PROMOCION': '🎁',
            'SISTEMA': '⚙️',
            'EMERGENCIA': '🚨'
        };

        // Colores por tipo
        const tipoColores = {
            'CITA_RECORDATORIO': '#2196F3',
            'PAGO_PENDIENTE': '#FFC107',
            'PROMOCION': '#4CAF50',
            'SISTEMA': '#6c757d',
            'EMERGENCIA': '#F44336'
        };

        // Selección de tipo
        document.querySelectorAll('.type-option').forEach(option => {
            option.addEventListener('click', function() {
                // Limpiar selección anterior
                document.querySelectorAll('.type-option').forEach(opt => opt.classList.remove('selected'));
                
                // Seleccionar nueva opción
                this.classList.add('selected');
                
                const tipo = this.dataset.type;
                document.getElementById('tipoSeleccionado').value = tipo;
                
                // Actualizar vista previa
                actualizarVistaPrevia();
            });
        });

        // Actualizar vista previa en tiempo real
        document.getElementById('titulo').addEventListener('input', actualizarVistaPrevia);
        document.getElementById('mensaje').addEventListener('input', actualizarVistaPrevia);
        document.getElementById('idCliente').addEventListener('change', actualizarVistaPrevia);

        function actualizarVistaPrevia() {
            const tipo = document.getElementById('tipoSeleccionado').value;
            const titulo = document.getElementById('titulo').value || 'Título de la notificación';
            const mensaje = document.getElementById('mensaje').value || 'Mensaje de la notificación aparecerá aquí...';
            const clienteSelect = document.getElementById('idCliente');
            const clienteTexto = clienteSelect.options[clienteSelect.selectedIndex]?.text || 'Cliente seleccionado';
            
            // Actualizar contenido
            document.getElementById('previewTitulo').innerHTML = `<span id="previewIcon">${tipoIconos[tipo] || '🔔'}</span> ${titulo}`;
            document.getElementById('previewMensaje').textContent = mensaje;
            document.getElementById('previewCliente').textContent = clienteTexto;
            
            // Actualizar fecha actual
            const ahora = new Date();
            document.getElementById('previewFecha').textContent = ahora.toLocaleDateString('es-ES') + ' ' + ahora.toLocaleTimeString('es-ES', {hour: '2-digit', minute: '2-digit'});
            
            // Actualizar color del borde
            const previewCard = document.getElementById('previewCard');
            previewCard.style.borderLeftColor = tipoColores[tipo] || '#2196F3';
        }

        function limpiarFormulario() {
            document.querySelectorAll('.type-option').forEach(opt => opt.classList.remove('selected'));
            document.getElementById('tipoSeleccionado').value = '';
            setTimeout(actualizarVistaPrevia, 100);
        }

        // Validación del formulario
        document.getElementById('formNotificacion').addEventListener('submit', function(e) {
            const tipo = document.getElementById('tipoSeleccionado').value;
            if (!tipo) {
                e.preventDefault();
                alert('Debe seleccionar un tipo de notificación');
                return false;
            }

            const cliente = document.getElementById('idCliente').value;
            if (!cliente) {
                e.preventDefault();
                alert('Debe seleccionar un cliente destinatario');
                return false;
            }

            const titulo = document.getElementById('titulo').value.trim();
            if (!titulo) {
                e.preventDefault();
                alert('Debe ingresar un título para la notificación');
                return false;
            }

            const mensaje = document.getElementById('mensaje').value.trim();
            if (!mensaje) {
                e.preventDefault();
                alert('Debe ingresar un mensaje para la notificación');
                return false;
            }

            // Validar JSON de metadatos si se proporciona
            const metadatos = document.getElementById('metadatos').value.trim();
            if (metadatos) {
                try {
                    JSON.parse(metadatos);
                } catch (e) {
                    alert('El formato de la información adicional no es válido. Debe ser JSON válido.');
                    return false;
                }
            }

            return true;
        });

        // Inicializar vista previa
        actualizarVistaPrevia();

        // Plantillas de mensajes por tipo
        const plantillasMensajes = {
            'CITA_RECORDATORIO': 'Estimado cliente, le recordamos que tiene una cita programada para el [FECHA] a las [HORA]. Por favor confirme su asistencia.',
            'PAGO_PENDIENTE': 'Estimado cliente, le informamos que tiene un pago pendiente por $[MONTO] correspondiente a los servicios veterinarios. Por favor regularice su situación.',
            'PROMOCION': '¡Tenemos una promoción especial para usted! Aproveche [DESCUENTO]% de descuento en [SERVICIOS]. Válido hasta [FECHA_LIMITE].',
            'SISTEMA': 'Información importante del sistema veterinario PetCare.',
            'EMERGENCIA': 'URGENTE: Información importante que requiere su atención inmediata.'
        };

        // Actualizar plantilla cuando se selecciona tipo
        document.querySelectorAll('.type-option').forEach(option => {
            option.addEventListener('click', function() {
                const tipo = this.dataset.type;
                const mensajeTextarea = document.getElementById('mensaje');
                if (!mensajeTextarea.value.trim()) {
                    mensajeTextarea.value = plantillasMensajes[tipo] || '';
                    actualizarVistaPrevia();
                }
            });
        });
    </script>
</body>
</html>