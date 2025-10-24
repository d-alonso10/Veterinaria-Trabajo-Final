<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Detalle de Servicio - Sistema PetCare</title>
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

        .form-panel h3 {
            color: var(--text-dark);
            margin-bottom: 25px;
            font-size: 1.3em;
            display: flex;
            align-items: center;
            gap: 10px;
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

        .material-manager {
            background: var(--bg-light);
            padding: 20px;
            border-radius: var(--radius);
            margin-top: 15px;
        }

        .material-input-group {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
        }

        .material-input {
            flex: 1;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 8px;
        }

        .material-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 10px;
        }

        .material-tag {
            background: var(--primary-color);
            color: var(--white);
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 0.9em;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .material-tag .remove-btn {
            background: rgba(255, 255, 255, 0.3);
            border: none;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            color: var(--white);
            font-weight: bold;
        }

        .cost-calculator {
            background: linear-gradient(135deg, var(--info-color) 0%, #0b7dda 100%);
            color: var(--white);
            padding: 20px;
            border-radius: var(--radius);
            margin-bottom: 20px;
        }

        .calculator-title {
            font-weight: 700;
            margin-bottom: 15px;
            font-size: 1.2em;
        }

        .cost-breakdown {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        .cost-item {
            display: flex;
            justify-content: space-between;
            padding: 10px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
        }

        .tips-section {
            background: linear-gradient(135deg, var(--success-color) 0%, #45a049 100%);
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
            
            .actions-section {
                flex-direction: column;
            }
            
            .cost-breakdown {
                grid-template-columns: 1fr;
            }
            
            .material-input-group {
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
                    <span>🔧</span>
                    <a href="ListaDetallesServicios.jsp">Detalles Servicios</a>
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
                <h1>🔧 <%= request.getParameter("id") != null ? "Editar" : "Crear" %> Detalle de Servicio</h1>
                <p>Define los componentes específicos y especificaciones técnicas del servicio</p>
            </div>

            <!-- Tips Section -->
            <div class="tips-section">
                <div class="tips-title">💡 Consejos para Detalles Efectivos</div>
                <ul class="tips-list">
                    <li>Sé específico en las descripciones para evitar confusiones</li>
                    <li>Incluye todos los materiales necesarios para el procedimiento</li>
                    <li>Define tiempos realistas basados en la experiencia</li>
                    <li>Establece costos que cubran materiales y tiempo invertido</li>
                </ul>
            </div>

            <!-- Mensajes -->
            <% if (request.getAttribute("mensaje") != null) { %>
                <div class="message <%= request.getAttribute("tipoMensaje") != null ? request.getAttribute("tipoMensaje") : "info" %>">
                    <%= request.getAttribute("mensaje") %>
                </div>
            <% } %>

            <form action="DetalleServicioControlador" method="post" id="formDetalleServicio">
                <input type="hidden" name="accion" value="<%= request.getParameter("id") != null ? "actualizarDetalle" : "crearDetalle" %>">
                <% if (request.getParameter("id") != null) { %>
                    <input type="hidden" name="id" value="<%= request.getParameter("id") %>">
                <% } %>
                
                <!-- Información Básica -->
                <div class="form-panel">
                    <h3>📋 Información Básica</h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="nombre">Nombre del Detalle: *</label>
                            <input type="text" id="nombre" name="nombre" class="form-control" 
                                   placeholder="Ej: Corte de Uñas Especializado" 
                                   value="<%= request.getParameter("nombre") != null ? request.getParameter("nombre") : "" %>" 
                                   required maxlength="100">
                        </div>
                        
                        <div class="form-group">
                            <label for="servicioId">Servicio Principal: *</label>
                            <select id="servicioId" name="servicioId" class="form-control" required>
                                <option value="">Seleccionar servicio...</option>
                                <option value="1" <%= "1".equals(request.getParameter("servicioId")) ? "selected" : "" %>>Grooming Completo</option>
                                <option value="2" <%= "2".equals(request.getParameter("servicioId")) ? "selected" : "" %>>Consulta Veterinaria</option>
                                <option value="3" <%= "3".equals(request.getParameter("servicioId")) ? "selected" : "" %>>Baño Medicado</option>
                                <option value="4" <%= "4".equals(request.getParameter("servicioId")) ? "selected" : "" %>>Vacunación</option>
                                <option value="5" <%= "5".equals(request.getParameter("servicioId")) ? "selected" : "" %>>Cirugía Menor</option>
                                <option value="6" <%= "6".equals(request.getParameter("servicioId")) ? "selected" : "" %>>Desparasitación</option>
                            </select>
                        </div>
                        
                        <div class="form-group full-width">
                            <label for="descripcion">Descripción Detallada:</label>
                            <textarea id="descripcion" name="descripcion" class="form-control" rows="3" 
                                      placeholder="Describe específicamente qué incluye este detalle del servicio..."
                                      maxlength="500"><%= request.getParameter("descripcion") != null ? request.getParameter("descripcion") : "" %></textarea>
                        </div>
                    </div>
                </div>

                <!-- Costos y Tiempo -->
                <div class="form-panel">
                    <h3>💰 Costos y Tiempos</h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="costo">Costo del Detalle: *</label>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <span style="font-weight: bold; font-size: 1.2em;">$</span>
                                <input type="number" id="costo" name="costo" class="form-control" 
                                       step="0.01" min="0.01" 
                                       placeholder="0.00" required 
                                       value="<%= request.getParameter("costo") != null ? request.getParameter("costo") : "" %>"
                                       onchange="actualizarCalculadora()">
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="tiempoEstimado">Tiempo Estimado (minutos): *</label>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <input type="number" id="tiempoEstimado" name="tiempoEstimado" class="form-control" 
                                       min="1" max="300" 
                                       placeholder="15" required 
                                       value="<%= request.getParameter("tiempoEstimado") != null ? request.getParameter("tiempoEstimado") : "" %>"
                                       onchange="actualizarCalculadora()">
                                <span style="font-weight: bold;">min</span>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="costoMateriales">Costo de Materiales:</label>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <span style="font-weight: bold; font-size: 1.2em;">$</span>
                                <input type="number" id="costoMateriales" name="costoMateriales" class="form-control" 
                                       step="0.01" min="0" 
                                       placeholder="0.00" 
                                       value="<%= request.getParameter("costoMateriales") != null ? request.getParameter("costoMateriales") : "" %>"
                                       onchange="actualizarCalculadora()">
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="estado">Estado:</label>
                            <select id="estado" name="estado" class="form-control">
                                <option value="ACTIVO" <%= "ACTIVO".equals(request.getParameter("estado")) ? "selected" : "" %>>🟢 Activo</option>
                                <option value="INACTIVO" <%= "INACTIVO".equals(request.getParameter("estado")) ? "selected" : "" %>>🔴 Inactivo</option>
                            </select>
                        </div>
                    </div>
                    
                    <!-- Calculadora de Costos -->
                    <div class="cost-calculator" id="costCalculator">
                        <div class="calculator-title">📊 Análisis de Costos</div>
                        <div class="cost-breakdown">
                            <div class="cost-item">
                                <span>Costo de Materiales:</span>
                                <span id="displayMateriales">$0.00</span>
                            </div>
                            <div class="cost-item">
                                <span>Costo de Mano de Obra:</span>
                                <span id="displayManoObra">$0.00</span>
                            </div>
                            <div class="cost-item">
                                <span>Tiempo por Hora:</span>
                                <span id="displayHoras">0.0 hrs</span>
                            </div>
                            <div class="cost-item">
                                <span>Costo Total:</span>
                                <span id="displayTotal">$0.00</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Materiales e Instrucciones -->
                <div class="form-panel">
                    <h3>🧰 Materiales e Instrucciones</h3>
                    
                    <div class="form-group">
                        <label for="instrucciones">Instrucciones de Procedimiento:</label>
                        <textarea id="instrucciones" name="instrucciones" class="form-control" rows="4" 
                                  placeholder="Describe paso a paso cómo realizar este procedimiento, precauciones especiales, etc..."
                                  maxlength="1000"><%= request.getParameter("instrucciones") != null ? request.getParameter("instrucciones") : "" %></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label>Materiales Necesarios:</label>
                        <div class="material-manager">
                            <div class="material-input-group">
                                <input type="text" id="nuevoMaterial" class="material-input" 
                                       placeholder="Agregar material o herramienta..." maxlength="100">
                                <button type="button" class="btn btn-primary" onclick="agregarMaterial()">
                                    ➕ Agregar
                                </button>
                            </div>
                            <div class="material-tags" id="materialesList">
                                <!-- Los materiales se agregan dinámicamente aquí -->
                            </div>
                            <input type="hidden" name="materiales" id="materialesHidden">
                        </div>
                    </div>
                </div>

                <!-- Acciones -->
                <div class="actions-section">
                    <div>
                        <a href="ListaDetallesServicios.jsp" class="btn btn-secondary">
                            ↩️ Volver a Detalles
                        </a>
                    </div>
                    <div style="display: flex; gap: 15px;">
                        <button type="button" class="btn btn-warning" onclick="limpiarFormulario()">
                            🔄 Limpiar
                        </button>
                        <button type="submit" class="btn btn-success" id="btnGuardar">
                            💾 <%= request.getParameter("id") != null ? "Actualizar" : "Crear" %> Detalle
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script>
        let materiales = [];

        // Agregar material
        function agregarMaterial() {
            const input = document.getElementById('nuevoMaterial');
            const material = input.value.trim();
            
            if (material && !materiales.includes(material)) {
                materiales.push(material);
                renderizarMateriales();
                input.value = '';
                actualizarMaterialesHidden();
            }
        }

        // Renderizar lista de materiales
        function renderizarMateriales() {
            const container = document.getElementById('materialesList');
            container.innerHTML = materiales.map((material, index) => `
                <div class="material-tag">
                    <span>${material}</span>
                    <button type="button" class="remove-btn" onclick="eliminarMaterial(${index})">×</button>
                </div>
            `).join('');
        }

        // Eliminar material
        function eliminarMaterial(index) {
            materiales.splice(index, 1);
            renderizarMateriales();
            actualizarMaterialesHidden();
        }

        // Actualizar campo hidden de materiales
        function actualizarMaterialesHidden() {
            document.getElementById('materialesHidden').value = JSON.stringify(materiales);
        }

        // Actualizar calculadora de costos
        function actualizarCalculadora() {
            const costo = parseFloat(document.getElementById('costo').value) || 0;
            const tiempo = parseFloat(document.getElementById('tiempoEstimado').value) || 0;
            const costoMateriales = parseFloat(document.getElementById('costoMateriales').value) || 0;
            
            const horas = tiempo / 60;
            const manoObra = costo - costoMateriales;
            
            document.getElementById('displayMateriales').textContent = `$${costoMateriales.toFixed(2)}`;
            document.getElementById('displayManoObra').textContent = `$${manoObra.toFixed(2)}`;
            document.getElementById('displayHoras').textContent = `${horas.toFixed(1)} hrs`;
            document.getElementById('displayTotal').textContent = `$${costo.toFixed(2)}`;
        }

        // Limpiar formulario
        function limpiarFormulario() {
            if (confirm('¿Está seguro de limpiar todo el formulario?')) {
                document.getElementById('formDetalleServicio').reset();
                materiales = [];
                renderizarMateriales();
                actualizarMaterialesHidden();
                actualizarCalculadora();
            }
        }

        // Permitir agregar material con Enter
        document.getElementById('nuevoMaterial').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                agregarMaterial();
            }
        });

        // Validación del formulario
        document.getElementById('formDetalleServicio').addEventListener('submit', function(e) {
            const costo = parseFloat(document.getElementById('costo').value);
            const tiempo = parseInt(document.getElementById('tiempoEstimado').value);
            
            if (!costo || costo <= 0) {
                e.preventDefault();
                alert('Debe ingresar un costo válido mayor a 0');
                return false;
            }

            if (!tiempo || tiempo <= 0) {
                e.preventDefault();
                alert('Debe ingresar un tiempo estimado válido');
                return false;
            }

            const costoMateriales = parseFloat(document.getElementById('costoMateriales').value) || 0;
            if (costoMateriales > costo) {
                e.preventDefault();
                alert('El costo de materiales no puede ser mayor al costo total');
                return false;
            }

            return true;
        });

        // Inicializar calculadora
        document.addEventListener('DOMContentLoaded', function() {
            actualizarCalculadora();
            
            // Cargar materiales predefinidos si es necesario
            const materialesIniciales = [];
            if (materialesIniciales.length > 0) {
                materiales = materialesIniciales;
                renderizarMateriales();
                actualizarMaterialesHidden();
            }
        });

        // Sugerencias predefinidas de materiales
        const materialesSugeridos = [
            "Cortauñas profesional",
            "Lima para mascotas",
            "Toallas absorbentes",
            "Guantes de nitrilo",
            "Jeringas desechables",
            "Agujas estériles",
            "Alcohol 70%",
            "Gasas estériles",
            "Champú medicado",
            "Termómetro digital",
            "Estetoscopio",
            "Otoscopio",
            "Balanza digital",
            "Tijeras quirúrgicas",
            "Pinzas hemostáticas"
        ];

        // Autocompletado para materiales
        document.getElementById('nuevoMaterial').addEventListener('input', function() {
            const valor = this.value.toLowerCase();
            if (valor.length >= 2) {
                const sugerencias = materialesSugeridos.filter(material => 
                    material.toLowerCase().includes(valor) && !materiales.includes(material)
                );
                
                // Aquí podrías implementar un dropdown de sugerencias
                console.log('Sugerencias:', sugerencias);
            }
        });
    </script>
</body>
</html>