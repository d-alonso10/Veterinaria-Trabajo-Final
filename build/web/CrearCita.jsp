<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.time.LocalDateTime"%>

<%-- =================================================================
     1. SEGURIDAD: Comprobar sesión
   -- ================================================================= --%>
<%
    String rolUsuario = (String) session.getAttribute("rolUsuario");
    
    // Permitir acceso a admin, recepcionista y veterinario
    if (rolUsuario == null || !(rolUsuario.equals("admin") || rolUsuario.equals("recepcionista") || rolUsuario.equals("veterinario"))) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp?mensaje=permiso_denegado");
        return; // Detiene la ejecución del JSP
    }
    
    // Preparar el nombre de usuario y el avatar para el menú
    String nombreUsuario = (String) session.getAttribute("nombreUsuario");
    String avatarLetra = "U";
    if (nombreUsuario != null && !nombreUsuario.isEmpty()) {
        avatarLetra = nombreUsuario.substring(0, 1).toUpperCase();
    }
    
    // Preparar los mensajes de error/éxito del controlador
    String mensaje = (String) request.getAttribute("mensaje");
    String tipoMensaje = (String) request.getAttribute("tipoMensaje");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Cita - Sistema PetCare</title>
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
        }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: linear-gradient(135deg, #f5f7fa 0%, var(--primary-light) 100%); color: var(--text-dark); line-height: 1.6; min-height: 100vh; }
        .container { display: flex; min-height: 100vh; }
        
        /* --- Sidebar (Menú) --- */
        .sidebar { width: 280px; background: var(--gradient-primary); color: var(--white); box-shadow: var(--shadow); position: relative; z-index: 10; }
        .logo { padding: 30px 20px; text-align: center; background: rgba(255, 255, 255, 0.1); border-bottom: 1px solid rgba(255, 255, 255, 0.2); }
        .logo h1 { font-size: 1.8em; font-weight: 700; display: flex; align-items: center; justify-content: center; gap: 12px; }
        .logo-icon { font-size: 2em; }
        .user-info { padding: 25px 20px; display: flex; align-items: center; gap: 15px; border-bottom: 1px solid rgba(255, 255, 255, 0.2); background: rgba(255, 255, 255, 0.05); }
        .user-avatar { width: 50px; height: 50px; border-radius: 50%; background: rgba(255, 255, 255, 0.2); display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 1.2em; border: 2px solid rgba(255, 255, 255, 0.3); }
        .user-details h3 { font-size: 1.1em; margin-bottom: 5px; font-weight: 600; }
        .user-details p { font-size: 0.85em; opacity: 0.9; }
        .menu { list-style: none; padding: 25px 0; }
        .menu-section { padding: 15px 25px; font-size: 0.75em; text-transform: uppercase; color: rgba(255, 255, 255, 0.7); letter-spacing: 1.5px; margin-top: 15px; font-weight: 600; background: rgba(255, 255, 255, 0.05); }
        .menu-item { padding: 16px 30px; border-left: 4px solid transparent; transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1); cursor: pointer; display: flex; align-items: center; gap: 15px; }
        .menu-item:hover { background-color: rgba(255, 255, 255, 0.1); border-left-color: var(--white); transform: translateX(5px); }
        .menu-item.active { background-color: rgba(255, 255, 255, 0.15); border-left-color: var(--white); }
        .menu-item a { color: var(--white); text-decoration: none; display: flex; align-items: center; gap: 15px; width: 100%; font-size: 0.95em; font-weight: 500; }
        .menu-icon { font-size: 1.3em; width: 24px; text-align: center; }

        /* --- Contenido Principal --- */
        .content { flex: 1; padding: 0; background: transparent; overflow-y: auto; }
        .header { background: var(--white); padding: 25px 40px; border-bottom: 1px solid rgba(0, 0, 0, 0.05); box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1); position: relative; }
        .header::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px; background: var(--gradient-primary); }
        .header-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
        .welcome h1 { font-size: 2.2em; color: var(--text-dark); margin-bottom: 8px; font-weight: 700; }
        .welcome p { color: var(--text-light); font-size: 1.1em; font-weight: 500; }
        .header-actions { display: flex; gap: 15px; }
        .main-content { padding: 40px; max-width: 900px; margin: 0 auto; }

        /* --- Botones --- */
        .btn { padding: 16px 28px; border: none; border-radius: var(--radius); cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; gap: 10px; font-weight: 600; transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1); font-size: 0.95em; position: relative; overflow: hidden; border: 1px solid transparent; }
        .btn:hover { transform: translateY(-3px); }
        .btn-primary { background: var(--gradient-primary); color: var(--white); box-shadow: 0 8px 25px rgba(171, 203, 213, 0.3); }
        .btn-secondary { background: linear-gradient(135deg, var(--secondary-color) 0%, #c9b18c 100%); color: var(--text-dark); box-shadow: 0 8px 25px rgba(213, 196, 173, 0.3); }
        .btn-back { background: #6c757d; color: var(--white); padding: 14px 24px; font-size: 0.9em; }
        .btn-back:hover { background: #5a6268; }
        .search-btn { padding: 10px 16px; font-size: 0.85em; border-radius: 10px; background: var(--info-color); color: var(--white); border: none; cursor: pointer; transition: all 0.3s ease; margin-top: 8px; display: inline-flex; align-items: center; gap: 6px; }
        .search-btn:hover { background: #0b7dda; transform: translateY(-2px); }

        /* --- Mensajes --- */
        .mensaje { padding: 20px 25px; margin: 0 0 30px 0; border-radius: var(--radius); font-size: 1em; box-shadow: var(--shadow); border-left: 4px solid; animation: fadeInUp 0.6s ease-out; }
        .mensaje.exito { background-color: #f0f9f4; border-left-color: var(--success-color); color: #1e7e34; }
        .mensaje.error { background-color: #fdf2f2; border-left-color: var(--danger-color); color: #c53030; }
        .mensaje.info { background-color: #f0f7ff; border-left-color: var(--info-color); color: var(--text-dark); }

        /* --- Formulario --- */
        .form-container { background: var(--white); padding: 40px; border-radius: var(--radius); box-shadow: var(--shadow); border-top: 4px solid var(--primary-color); animation: fadeInUp 0.6s ease-out; }
        .form-title { color: var(--text-dark); margin-bottom: 30px; font-size: 1.8em; font-weight: 700; text-align: center; display: flex; align-items: center; justify-content: center; gap: 15px; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 25px; margin-bottom: 25px; }
        .form-group { margin-bottom: 25px; }
        .form-group.full-width { grid-column: 1 / -1; }
        .form-group label { display: block; margin-bottom: 10px; font-weight: 600; color: var(--text-dark); font-size: 1em; display: flex; align-items: center; gap: 8px; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 16px 20px; border: 2px solid #e9ecef; border-radius: var(--radius); font-size: 1em; transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1); background-color: #f8f9fa; box-shadow: inset 0 2px 4px rgba(0,0,0,0.05); }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus { outline: none; border-color: var(--primary-color); background-color: var(--white); box-shadow: 0 0 0 3px rgba(171, 203, 213, 0.3), inset 0 2px 4px rgba(0,0,0,0.05); transform: translateY(-2px); }
        .form-group input:required, .form-group select:required { border-left: 4px solid var(--primary-color); }
        .form-group input:disabled, .form-group select:disabled { background-color: #e9ecef; opacity: 0.7; cursor: not-allowed; }
        .form-group textarea { resize: vertical; min-height: 120px; font-family: inherit; line-height: 1.5; }
        .form-actions { display: flex; gap: 20px; margin-top: 40px; justify-content: center; }
        .navigation { display: flex; gap: 15px; margin-top: 30px; justify-content: center; flex-wrap: wrap; }
        .field-info { font-size: 0.85em; color: var(--text-light); margin-top: 8px; display: flex; align-items: center; gap: 8px; transition: all 0.3s ease; }
        .required-mark { color: var(--danger-color); font-weight: bold; }
        .form-section { margin-bottom: 35px; padding-bottom: 25px; border-bottom: 1px solid rgba(0, 0, 0, 0.1); }
        .section-title { color: var(--text-dark); margin-bottom: 20px; font-size: 1.3em; font-weight: 600; display: flex; align-items: center; gap: 12px; padding: 12px 0; border-bottom: 2px solid var(--primary-light); }
        .quick-help { background: linear-gradient(135deg, #f8f9fa 0%, var(--primary-light) 100%); padding: 25px; border-radius: var(--radius); margin-bottom: 30px; border-left: 4px solid var(--info-color); box-shadow: var(--shadow); animation: fadeInUp 0.6s ease-out; }
        .quick-help h4 { color: var(--text-dark); margin-bottom: 15px; display: flex; align-items: center; gap: 12px; font-size: 1.2em; font-weight: 600; }
        .quick-help ul { list-style: none; padding-left: 0; }
        .quick-help li { padding: 8px 0; display: flex; align-items: center; gap: 12px; color: var(--text-dark); font-size: 0.95em; }
        .char-counter { font-size: 0.8em; color: var(--text-light); text-align: right; margin-top: 8px; }
        .char-counter.danger { color: var(--danger-color); font-weight: 600; }
        .char-counter.warning { color: var(--warning-color); }
        .form-group select { appearance: none; background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%235d6d7e' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E"); background-repeat: no-repeat; background-position: right 20px center; background-size: 14px; padding-right: 50px; cursor: pointer; }
        
        /* --- Animaciones --- */
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(40px); } to { opacity: 1; transform: translateY(0); } }
        .loading-dots { display: inline-flex; gap: 4px; }
        .loading-dots span { width: 6px; height: 6px; border-radius: 50%; background: currentColor; animation: loading 1.4s infinite ease-in-out; }
        .loading-dots span:nth-child(1) { animation-delay: -0.32s; }
        .loading-dots span:nth-child(2) { animation-delay: -0.16s; }
        @keyframes loading { 0%, 80%, 100% { transform: scale(0); } 40% { transform: scale(1); } }

        /* --- Responsividad --- */
        @media (max-width: 1200px) {
            .container { flex-direction: column; }
            .sidebar { width: 100%; height: auto; }
            .menu { display: flex; flex-wrap: wrap; justify-content: center; padding: 15px; }
            .menu-item { flex: 1 0 200px; justify-content: center; }
            .menu-section { display: none; }
        }
        @media (max-width: 768px) {
            .main-content { padding: 20px; }
            .header-top { flex-direction: column; gap: 20px; align-items: flex-start; }
            .header-actions { width: 100%; justify-content: center; }
            .form-container { padding: 25px; }
            .form-grid { grid-template-columns: 1fr; }
            .form-actions { flex-direction: column; }
            .btn { width: 100%; justify-content: center; }
        }
        @media (max-width: 480px) {
            .header { padding: 20px; }
            .main-content { padding: 15px; }
            .form-container { padding: 20px; }
            .form-title { font-size: 1.5em; }
            .section-title { font-size: 1.1em; }
        }
    </style>
</head>
<body>
    <div class="container">
        
        <!-- =================================================================
             MENÚ DINÁMICO (Datos de Sesión)
           ================================================================= -->
        <div class="sidebar">
            <div class="logo">
                <h1><span class="logo-icon">🐕</span> Terán Vet</h1>
            </div>
            
            <div class="user-info">
                <div class="user-avatar"><%= avatarLetra %></div>
                <div class="user-details">
                    <h3><%= nombreUsuario %></h3>
                    <p><%= rolUsuario %></p>
                </div>
            </div>
            
            <ul class="menu">
                <!-- Núcleo del Negocio -->
                <div class="menu-section">Núcleo del Negocio</div>
                <li class="menu-item">
                    <a href="<%= request.getContextPath() %>/DashboardControlador?accion=metricas">
                        <span class="menu-icon">📊</span>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="menu-item active"> <%-- La clase 'active' está aquí --%>
                    <a href="<%= request.getContextPath() %>/CitaControlador?accion=todasCitas">
                        <span class="menu-icon">📅</span>
                        <span>Citas</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="<%= request.getContextPath() %>/AtencionControlador">
                        <span class="menu-icon">🎯</span>
                        <span>Atención</span>
                    </a>
                </li>
                
                <!-- Gestión de Clientes -->
                <div class="menu-section">Gestión de Clientes</div>
                <li class="menu-item">
                    <a href="<%= request.getContextPath() %>/ClienteControlador?accion=listarTodos">
                        <span class="menu-icon">👥</span>
                        <span>Clientes</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="<%= request.getContextPath() %>/MascotaControlador?accion=listarTodas">
                        <span class="menu-icon">🐾</span>
                        <span>Mascotas</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="<%= request.getContextPath() %>/ServicioControlador">
                        <span class="menu-icon">🛠️</span>
                        <span>Servicios</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="<%= request.getContextPath() %>/ClienteControlador?accion=listarFrecuentes">
                        <span class="menu-icon">🏆</span>
                        <span>Clientes Frecuentes</span>
                    </a>
                </li>
                
                <!-- Personal y Operaciones -->
                <div class="menu-section">Personal y Operaciones</div>
                <li class="menu-item">
                    <a href="<%= request.getContextPath() %>/GroomerControlador">
                        <span class="menu-icon">✂️</span>
                        <span>Groomers</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="<%= request.getContextPath() %>/SucursalControlador?accion=listar">
                        <span class="menu-icon">🏢</span>
                        <span>Sucursales</span>
                    </a>
                </li>
                
                <!-- Finanzas -->
                <div class="menu-section">Finanzas</div>
                <li class="menu-item">
                    <a href="<%= request.getContextPath() %>/pagos.jsp">
                        <span class="menu-icon">💳</span>
                        <span>Pagos</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="<%= request.getContextPath() %>/facturas.jsp">
                        <span class="menu-icon">🧾</span>
                        <span>Facturas</span>
                    </a>
                </li>
                
                <!-- Análisis y Control -->
                <div class="menu-section">Análisis y Control</div>
                <li class="menu-item">
                    <a href="<%= request.getContextPath() %>/ReporteControlador">
                        <span class="menu-icon">📈</span>
                        <span>Reportes</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="<%= request.getContextPath() %>/AuditControlador?accion=listar">
                        <span class="menu-icon">🔍</span>
                        <span>Auditoria</span>
                    </a>
                </li>
                
                <!-- Sistema -->
                <div class="menu-section">Sistema</div>
                <li class="menu-item">
                    <a href="<%= request.getContextPath() %>/ConfiguracionControlador?accion=listar">
                        <span class="menu-icon">⚙️</span>
                        <span>Configuración</span>
                    </a>
                </li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="content">
            <div class="header">
                <div class="header-top">
                    <div class="welcome">
                        <h1>➕ Crear Nueva Cita</h1>
                        <p>Programe una nueva cita para sus clientes y mascotas</p>
                    </div>
                    <div class="header-actions">
                        <a href="<%= request.getContextPath() %>/CitaControlador?accion=todasCitas" class="btn btn-back">← Volver a Citas</a>
                    </div>
                </div>
            </div>

            <div class="main-content">
                
                <!-- --- CORRECCIÓN: Mostrar Mensajes del Controlador --- -->
                <% if (mensaje != null) { %>
                    <%-- Determina la clase CSS basada en el tipoMensaje --%>
                    <div class="mensaje <%= (tipoMensaje != null && tipoMensaje.equals("exito")) ? "exito" : (tipoMensaje != null && tipoMensaje.equals("info")) ? "info" : "error" %>">
                        <%= mensaje %>
                    </div>
                <% } %>

                <!-- Ayuda rápida -->
                <div class="quick-help">
                    <h4>💡 Información Importante</h4>
                    <ul>
                        <li>✅ <strong>ID Cliente</strong> es obligatorio. Úsalo para buscar y cargar sus mascotas.</li>
                        <li>🐾 <strong>Mascota</strong> se habilitará después de buscar un cliente.</li>
                        <li>📅 <strong>Fecha Programada</strong> debe ser una fecha futura.</li>
                    </ul>
                </div>
                
                <div class="form-container">
                    <div class="form-title">
                        <span>📅 Información de la Cita</span>
                    </div>
                    
                    <%-- El action apunta al controlador. El botón 'Confirmar' con name="acc" lo activa. --%>
                    <form action="<%= request.getContextPath() %>/CitaControlador" method="POST" id="citaForm">
                        
                        <div class="form-section">
                            <h3 class="section-title">🆔 Identificación</h3>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="idCliente">
                                        <span>👤 ID Cliente</span>
                                        <span class="required-mark">*</span>
                                    </label>
                                    <input type="number" id="idCliente" name="idCliente" required 
                                           placeholder="Ingrese el ID del cliente"
                                           value="<%= request.getAttribute("idCliente") != null ? request.getAttribute("idCliente") : "" %>"
                                           min="1">
                                    <div class="field-info">🔍 Identificación única del cliente propietario</div>
                                    
                                    <%-- Botón para AJAX --%>
                                    <button type="button" class="search-btn" id="btnBuscarCliente">
                                        🔍 Buscar Cliente
                                    </button>
                                </div>
                                
                                <div class="form-group">
                                    <label for="idMascota">
                                        <span>🐕 ID Mascota</span>
                                        <span class="required-mark">*</span>
                                    </label>
                                    <%-- Campo de mascota deshabilitado hasta buscar cliente --%>
                                    <select id="idMascota" name="idMascota" required disabled>
                                        <option value="">--- Busque un cliente primero ---</option>
                                    </select>
                                    <div class="field-info" id="mascota-info">
                                        🐾 Las mascotas del cliente aparecerán aquí
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <h3 class="section-title">🏢 Detalles del Servicio</h3>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="idSucursal">
                                        <span>🏢 ID Sucursal</span>
                                    </label>
                                    <input type="number" id="idSucursal" name="idSucursal" 
                                           placeholder="ID de la sucursal (ej: 1)"
                                           min="1">
                                    <div class="field-info">📍 Sucursal (opcional)</div>
                                </div>
                                
                                <div class="form-group">
                                    <label for="idServicio">
                                        <span>🛠️ ID Servicio</span>
                                    </label>
                                    <input type="number" id="idServicio" name="idServicio" 
                                           placeholder="ID del servicio (ej: 1)"
                                           min="1">
                                    <div class="field-info">⚡ Tipo de servicio (opcional)</div>
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <h3 class="section-title">📅 Programación</h3>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="fechaProgramada">
                                        <span>📅 Fecha Programada</span>
                                        <span class="required-mark">*</span>
                                    </label>
                                    <input type="datetime-local" id="fechaProgramada" name="fechaProgramada" required
                                           min="<%= LocalDateTime.now().toString().substring(0,16) %>">
                                    <div class="field-info">⏰ Fecha y hora programada</div>
                                </div>
                                
                                <div class="form-group">
                                    <label for="modalidad">
                                        <span>🌐 Modalidad</span>
                                    </label>
                                    <select id="modalidad" name="modalidad">
                                        <option value="presencial" selected>🏢 Presencial</option>
                                        <option value="virtual">💻 Virtual</option>
                                    </select>
                                    <div class="field-info">🎯 Modalidad de atención</div>
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <h3 class="section-title">🗒️ Información Adicional</h3>
                            <div class="form-group full-width">
                                <label for="notas">
                                    <span>📝 Notas y Observaciones</span>
                                </label>
                                <textarea id="notas" name="notas" 
                                          placeholder="Ingrese observaciones importantes: alergias, comportamientos, etc."
                                          maxlength="500"></textarea>
                                <div class="char-counter" id="charCounter"><span id="charCount">0</span>/500 caracteres</div>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" name="acc" value="Confirmar" class="btn btn-primary" id="submitBtn">
                                ✅ Confirmar y Programar Cita
                            </button>
                            <button type="reset" class="btn btn-secondary" id="resetBtn">
                                🗑️ Limpiar Formulario
                            </button>
                        </div>
                    </form>
                </div>

                <div class="navigation">
                    <a href="<%= request.getContextPath() %>/CitaControlador?accion=todasCitas" class="btn btn-back">📅 Ver Todas las Citas</a>
                    <a href="<%= request.getContextPath() %>/ClienteControlador?accion=listarTodos" class="btn btn-back">👥 Buscar Clientes</a>
                </div>
            </div>
        </div>
    </div>

    <%-- =================================================================
         5. JAVASCRIPT CON AJAX (Llama a MascotaControlador?accion=obtenerMascotasJSON)
       ================================================================= --%>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            
            const btnBuscarCliente = document.getElementById('btnBuscarCliente');
            const selectMascota = document.getElementById('idMascota');
            const inputCliente = document.getElementById('idCliente');
            const mascotaInfo = document.getElementById('mascota-info');
            const submitBtn = document.getElementById('submitBtn');

            // --- 1. Lógica para Buscar Cliente y Cargar Mascotas ---
            
            btnBuscarCliente.addEventListener('click', function() {
                const idCliente = inputCliente.value;
                if (!idCliente || idCliente < 1) {
                    showTemporalMessage(mascotaInfo, '❌ Por favor ingrese un ID de cliente válido.', 'error');
                    return;
                }
                
                // Mostrar estado de carga
                const originalText = this.innerHTML;
                this.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Buscando...';
                this.disabled = true;
                selectMascota.disabled = true;
                selectMascota.innerHTML = '<option value="">Cargando mascotas...</option>';

                // --- INICIO DE AJAX ---
                // Llama a la acción 'obtenerMascotasJSON' del MascotaControlador
                fetch(`<%= request.getContextPath() %>/MascotaControlador?accion=obtenerMascotasJSON&idCliente=${idCliente}`)
                    .then(response => {
                        if (response.ok) {
                            return response.json();
                        } else {
                            // Si el servidor falla (500) o no encuentra el cliente (404)
                            return response.json().then(err => { throw new Error(err.error || 'No se pudo encontrar el cliente.'); });
                        }
                    })
                    .then(mascotas => {
                        // Éxito: Servidor respondió con una lista de mascotas (JSON)
                        this.innerHTML = '🔍 Buscar Cliente';
                        this.disabled = false;

                        if (mascotas && mascotas.length > 0) {
                            selectMascota.innerHTML = '<option value="">-- Seleccione una mascota --</option>';
                            mascotas.forEach(mascota => {
                                const option = document.createElement('option');
                                option.value = mascota.idMascota;
                                option.textContent = `${mascota.nombre} (ID: ${mascota.idMascota}, Especie: ${mascota.especie})`;
                                selectMascota.appendChild(option);
                            });
                            selectMascota.disabled = false;
                            showTemporalMessage(mascotaInfo, `✅ Cliente encontrado. ${mascotas.length} mascotas cargadas.`, 'success');
                        } else {
                            // Cliente encontrado, pero no tiene mascotas
                            selectMascota.innerHTML = '<option value="">-- Sin mascotas registradas --</option>';
                            showTemporalMessage(mascotaInfo, 'ℹ️ Cliente encontrado, pero no tiene mascotas registradas.', 'info');
                        }
                    })
                    .catch(error => {
                        // Error: No se encontró el cliente o hubo un error de red/servidor
                        console.error('Error AJAX:', error);
                        this.innerHTML = '🔍 Buscar Cliente';
                        this.disabled = false;
                        selectMascota.innerHTML = '<option value="">--- Busque un cliente ---</option>';
                        showTemporalMessage(mascotaInfo, `❌ ${error.message || 'Error al buscar cliente.'}`, 'error');
                    });
                // --- FIN DE AJAX ---
            });

            // --- 2. Contador de Caracteres ---
            const notasTextarea = document.getElementById('notas');
            const charCount = document.getElementById('charCount');
            const charCounter = document.getElementById('charCounter');
            
            if (notasTextarea && charCount && charCounter) {
                notasTextarea.addEventListener('input', function() {
                    const length = this.value.length;
                    charCount.textContent = length;
                    charCounter.className = 'char-counter';
                    if (length > 490) {
                        charCounter.classList.add('danger');
                    } else if (length > 450) {
                        charCounter.classList.add('warning');
                    }
                });
                charCount.textContent = notasTextarea.value.length;
            }

            // --- 3. Validación de Fecha Mínima y Valor por Defecto ---
            const fechaInput = document.getElementById('fechaProgramada');
            if (fechaInput) {
                const now = new Date();
                // Corrección para zona horaria local
                const offset = now.getTimezoneOffset();
                const nowLocal = new Date(now.getTime() - (offset * 60000));
                const localDateTime = nowLocal.toISOString().slice(0, 16);
                
                fechaInput.min = localDateTime;
                
                if (!fechaInput.value) {
                    const tomorrow = new Date(now);
                    tomorrow.setDate(tomorrow.getDate() + 1);
                    tomorrow.setHours(9, 0, 0, 0);
                    const tomorrowLocal = new Date(tomorrow.getTime() - (offset * 60000));
                    fechaInput.value = tomorrowLocal.toISOString().slice(0, 16);
                }
            }
            
            // --- 4. Limpieza de Formulario ---
            const resetButton = document.getElementById('resetBtn');
            if (resetButton) {
                resetButton.addEventListener('click', function(e) {
                    selectMascota.innerHTML = '<option value="">--- Busque un cliente primero ---</option>';
                    selectMascota.disabled = true;
                    showTemporalMessage(mascotaInfo, '🐾 Las mascotas del cliente aparecerán aquí', 'info');
                    // El reset del formulario (type="reset") se encarga del resto
                });
            }

            // --- 5. Animación de Carga en Submit (Sin 'alert') ---
            document.getElementById('citaForm').addEventListener('submit', function(e) {
                let isValid = true;
                const requiredFields = [inputCliente, selectMascota, fechaInput];
                
                requiredFields.forEach(field => {
                    if (!field.value) {
                        isValid = false;
                        field.style.borderColor = 'var(--danger-color)';
                        field.style.backgroundColor = '#fdf2f2';
                    } else {
                        field.style.borderColor = '#e9ecef';
                        field.style.backgroundColor = '#f8f9fa';
                    }
                });

                if (!isValid) {
                    e.preventDefault(); // Detiene el envío
                    let errorDiv = document.querySelector('.mensaje.error');
                    if (!errorDiv) {
                        errorDiv = document.createElement('div');
                        errorDiv.className = 'mensaje error';
                        const formContainer = document.querySelector('.form-container');
                        formContainer.prepend(errorDiv);
                    }
                    errorDiv.textContent = '❌ Por favor complete todos los campos obligatorios (*)';
                    window.scrollTo(0, 0); // Subir al mensaje de error
                } else {
                    submitBtn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Procesando...';
                    submitBtn.disabled = true;
                }
            });

            // --- Función auxiliar para mostrar mensajes ---
            function showTemporalMessage(element, message, type) {
                element.textContent = message;
                // Aplicar clase de color al 'field-info'
                element.style.color = type === 'error' ? 'var(--danger-color)' : (type === 'success' ? 'var(--success-color)' : 'var(--text-light)');
            }
            
            // --- Efectos visuales ---
            const formElements = document.querySelectorAll('.form-group input, .form-group select, .form-group textarea');
            formElements.forEach(element => {
                element.addEventListener('focus', function() {
                    this.parentElement.style.transform = 'translateY(-2px)';
                });
                
                element.addEventListener('blur', function() {
                    this.parentElement.style.transform = 'translateY(0)';
                });
            });

        });
    </script>
</body>
</html>