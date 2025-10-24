<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Insertar Cliente - Sistema PetCare</title>
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
            --gradient-success: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
            --gradient-warning: linear-gradient(135deg, #FFC107 0%, #ffb300 100%);
            --gradient-danger: linear-gradient(135deg, #F44336 0%, #d32f2f 100%);
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

        /* Sidebar Styles - Manteniendo el diseño del dashboard */
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

        .logo-icon {
            font-size: 2em;
        }

        .user-info {
            padding: 25px 20px;
            display: flex;
            align-items: center;
            gap: 15px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            background: rgba(255, 255, 255, 0.05);
        }

        .user-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 1.2em;
            border: 2px solid rgba(255, 255, 255, 0.3);
        }

        .user-details h3 {
            font-size: 1.1em;
            margin-bottom: 5px;
            font-weight: 600;
        }

        .user-details p {
            font-size: 0.85em;
            opacity: 0.9;
        }

        .menu {
            list-style: none;
            padding: 25px 0;
        }

        .menu-section {
            padding: 15px 25px;
            font-size: 0.75em;
            text-transform: uppercase;
            color: rgba(255, 255, 255, 0.7);
            letter-spacing: 1.5px;
            margin-top: 15px;
            font-weight: 600;
            background: rgba(255, 255, 255, 0.05);
        }

        .menu-item {
            padding: 16px 30px;
            border-left: 4px solid transparent;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 15px;
            position: relative;
            overflow: hidden;
        }

        .menu-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
            transition: left 0.6s;
        }

        .menu-item:hover::before {
            left: 100%;
        }

        .menu-item:hover {
            background-color: rgba(255, 255, 255, 0.1);
            border-left-color: var(--white);
            transform: translateX(5px);
        }

        .menu-item.active {
            background-color: rgba(255, 255, 255, 0.15);
            border-left-color: var(--white);
        }

        .menu-item a {
            color: var(--white);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 15px;
            width: 100%;
            font-size: 0.95em;
            font-weight: 500;
        }

        .menu-icon {
            font-size: 1.3em;
            width: 24px;
            text-align: center;
        }

        /* Main Content Styles */
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
            max-width: 800px;
            margin: 0 auto;
        }

        /* Botones - Usando el mismo estilo del dashboard */
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
            border: 1px solid transparent;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.6s;
        }

        .btn:hover::before {
            left: 100%;
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

        .btn-warning {
            background: var(--gradient-warning);
            color: var(--text-dark);
            box-shadow: 0 8px 25px rgba(255, 193, 7, 0.3);
        }

        .btn-warning:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(255, 193, 7, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, var(--secondary-color) 0%, #c9b18c 100%);
            color: var(--text-dark);
            box-shadow: 0 8px 25px rgba(213, 196, 173, 0.3);
        }

        .btn-secondary:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(213, 196, 173, 0.4);
        }

        .btn-back {
            background: #6c757d;
            color: var(--white);
            padding: 14px 24px;
            font-size: 0.9em;
        }

        .btn-back:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        /* Mensajes de estado - Mejorados */
        .mensaje {
            padding: 20px 25px;
            margin: 0 0 30px 0;
            border-radius: var(--radius);
            font-size: 1em;
            box-shadow: var(--shadow);
            border-left: 4px solid;
            animation: fadeInUp 0.6s ease-out;
            position: relative;
            overflow: hidden;
        }

        .mensaje::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            opacity: 0;
            transition: opacity 0.3s;
        }

        .mensaje:hover::before {
            opacity: 1;
        }

        .exito {
            background-color: #f0f9f4;
            border-left-color: var(--success-color);
            color: #1e7e34;
        }

        .error {
            background-color: #fdf2f2;
            border-left-color: var(--danger-color);
            color: #c53030;
        }

        .info {
            background-color: #f0f7ff;
            border-left-color: var(--info-color);
            color: var(--text-dark);
        }

        /* Form Container - Mejorado */
        .form-container {
            background: var(--white);
            padding: 40px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            border-top: 4px solid var(--primary-color);
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out;
        }

        .form-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-primary);
        }

        .form-title {
            color: var(--text-dark);
            margin-bottom: 30px;
            font-size: 1.8em;
            font-weight: 700;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }

        /* Form Row Layout - Mejorado */
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 25px;
        }

        .form-group {
            margin-bottom: 25px;
            transition: all 0.3s ease;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-group label {
            display: block;
            margin-bottom: 10px;
            font-weight: 600;
            color: var(--text-dark);
            font-size: 1em;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-group input {
            width: 100%;
            padding: 16px 20px;
            border: 2px solid #e9ecef;
            border-radius: var(--radius);
            font-size: 1em;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            background-color: #f8f9fa;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.05);
        }

        .form-group input:focus {
            outline: none;
            border-color: var(--primary-color);
            background-color: var(--white);
            box-shadow: 0 0 0 3px rgba(171, 203, 213, 0.3), inset 0 2px 4px rgba(0,0,0,0.05);
            transform: translateY(-2px);
        }

        .form-group input:required {
            border-left: 4px solid var(--primary-color);
        }

        .form-actions {
            display: flex;
            gap: 20px;
            margin-top: 40px;
            justify-content: center;
        }

        /* Navigation */
        .navigation {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            justify-content: center;
            flex-wrap: wrap;
        }

        /* Field Info - Mejorado */
        .field-info {
            font-size: 0.85em;
            color: var(--text-light);
            margin-top: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }

        .required-mark {
            color: var(--danger-color);
            font-weight: bold;
        }

        /* Quick Help - Nuevo */
        .quick-help {
            background: linear-gradient(135deg, #f8f9fa 0%, var(--primary-light) 100%);
            padding: 25px;
            border-radius: var(--radius);
            margin-bottom: 30px;
            border-left: 4px solid var(--info-color);
            box-shadow: var(--shadow);
            animation: fadeInUp 0.6s ease-out;
            position: relative;
            overflow: hidden;
        }

        .quick-help::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-primary);
        }

        .quick-help h4 {
            color: var(--text-dark);
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 1.2em;
            font-weight: 600;
        }

        .quick-help ul {
            list-style: none;
            padding-left: 0;
        }

        .quick-help li {
            padding: 8px 0;
            display: flex;
            align-items: center;
            gap: 12px;
            color: var(--text-dark);
            font-size: 0.95em;
            transition: all 0.3s ease;
        }

        .quick-help li:hover {
            transform: translateX(5px);
            color: var(--primary-dark);
        }

        /* Animation Effects */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(40px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        .pulse {
            animation: pulse 2s infinite;
        }

        /* Responsive Design */
        @media (max-width: 1200px) {
            .container {
                flex-direction: column;
            }
            .sidebar {
                width: 100%;
                height: auto;
            }
            .menu {
                display: flex;
                flex-wrap: wrap;
                justify-content: center;
                padding: 15px;
            }
            .menu-item {
                flex: 1 0 200px;
                justify-content: center;
            }
            .menu-section {
                display: none;
            }
        }

        @media (max-width: 768px) {
            .main-content {
                padding: 20px;
            }
            .header-top {
                flex-direction: column;
                gap: 20px;
                align-items: flex-start;
            }
            .header-actions {
                width: 100%;
                justify-content: center;
            }
            .form-container {
                padding: 25px;
            }
            .form-row {
                grid-template-columns: 1fr;
            }
            .form-actions {
                flex-direction: column;
            }
            .btn {
                width: 100%;
                justify-content: center;
            }
        }

        @media (max-width: 480px) {
            .header {
                padding: 20px;
            }
            .main-content {
                padding: 15px;
            }
            .form-container {
                padding: 20px;
            }
            .form-title {
                font-size: 1.5em;
            }
        }

        /* Loading animation */
        .loading-dots {
            display: inline-flex;
            gap: 4px;
        }

        .loading-dots span {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: currentColor;
            animation: loading 1.4s infinite ease-in-out;
        }

        .loading-dots span:nth-child(1) { animation-delay: -0.32s; }
        .loading-dots span:nth-child(2) { animation-delay: -0.16s; }

        @keyframes loading {
            0%, 80%, 100% { transform: scale(0); }
            40% { transform: scale(1); }
        }

        /* Character Counter */
        .char-counter {
            font-size: 0.8em;
            color: var(--text-light);
            text-align: right;
            margin-top: 8px;
            transition: all 0.3s ease;
        }

        .char-counter.warning {
            color: var(--warning-color);
        }

        .char-counter.danger {
            color: var(--danger-color);
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Sidebar Menu - Actualizado para coincidir con el dashboard -->
        <div class="sidebar">
            <div class="logo">
                <h1><span class="logo-icon">🐕</span> Terán Vet</h1>
            </div>
            
            <div class="user-info">
                <div class="user-avatar">JS</div>
                <div class="user-details">
                    <h3>Juan Sánchez</h3>
                    <p>Administrador</p>
                </div>
            </div>
            
            <ul class="menu">
                <!-- Núcleo del Negocio -->
                <div class="menu-section">Núcleo del Negocio</div>
                <li class="menu-item">
                    <a href="<%= request.getContextPath() %>/dashboard.jsp">
                        <span class="menu-icon">📊</span>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="menu-item">
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
                <li class="menu-item active">
                    <a href="<%= request.getContextPath() %>/InsertarCliente.jsp">
                        <span class="menu-icon">➕</span>
                        <span>Nuevo Cliente</span>
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
                <li class="menu-item">
                    <a href="<%= request.getContextPath() %>/BuscarClientes.jsp">
                        <span class="menu-icon">🔍</span>
                        <span>Búsqueda Avanzada</span>
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
                <li class="menu-item">
                    <a href="<%= request.getContextPath() %>/promociones.jsp">
                        <span class="menu-icon">🎁</span>
                        <span>Promociones</span>
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
                        <h1>➕ Insertar Nuevo Cliente</h1>
                        <p>Complete el formulario para agregar un nuevo cliente al sistema - <%= new java.text.SimpleDateFormat("EEEE, d 'de' MMMM 'de' yyyy").format(new java.util.Date()) %></p>
                    </div>
                    <div class="header-actions">
                        <a href="<%= request.getContextPath() %>/ClienteControlador?accion=listarTodos" class="btn btn-back">← Volver a Clientes</a>
                    </div>
                </div>
            </div>

            <div class="main-content">
                <!-- Mostrar mensajes -->
                <% String mensaje = (String) request.getAttribute("mensaje"); %>
                <% if (mensaje != null) { %>
                    <div class="mensaje <%= mensaje.contains("✅") ? "exito" : "error" %>">
                        <strong><%= mensaje.contains("✅") ? "✅ Éxito:" : "❌ Error:" %></strong> <%= mensaje %>
                    </div>
                <% } %>

                <!-- Ayuda rápida -->
                <div class="quick-help">
                    <h4>💡 Información Importante</h4>
                    <ul>
                        <li>✅ <strong>Nombres y Apellidos</strong> son campos obligatorios</li>
                        <li>🆔 <strong>DNI/RUC</strong> debe ser único para cada cliente</li>
                        <li>📧 <strong>Email y Teléfono</strong> son opcionales pero recomendados</li>
                        <li>🗒️ <strong>Preferencias</strong> pueden incluir observaciones importantes</li>
                    </ul>
                </div>
                
                <div class="form-container">
                    <div class="form-title">
                        <span>👤 Información del Cliente</span>
                    </div>
                    
                    <form action="<%= request.getContextPath() %>/ClienteControlador" method="POST" id="clienteForm">
                        <div class="form-row">
                            <div class="form-group">
                                <label for="nombre">
                                    <span>👤 NOMBRES</span>
                                    <span class="required-mark">*</span>
                                </label>
                                <input type="text" id="nombre" name="nombre" maxlength="100" required 
                                       placeholder="Ingrese los nombres del cliente">
                                <div class="field-info">📝 Campo obligatorio - Máximo 100 caracteres</div>
                                <div class="char-counter"><span id="nombreCount">0</span>/100 caracteres</div>
                            </div>
                            
                            <div class="form-group">
                                <label for="apellido">
                                    <span>👥 APELLIDOS</span>
                                    <span class="required-mark">*</span>
                                </label>
                                <input type="text" id="apellido" name="apellido" maxlength="100" required 
                                       placeholder="Ingrese los apellidos del cliente">
                                <div class="field-info">📝 Campo obligatorio - Máximo 100 caracteres</div>
                                <div class="char-counter"><span id="apellidoCount">0</span>/100 caracteres</div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="dniRuc">
                                <span>🆔 DNI / RUC</span>
                                <span class="required-mark">*</span>
                            </label>
                            <input type="text" id="dniRuc" name="dniRuc" maxlength="20" required 
                                   placeholder="Ingrese DNI o RUC del cliente"
                                   pattern="[0-9]{8,11}"
                                   title="Ingrese un DNI (8 dígitos) o RUC (11 dígitos) válido">
                            <div class="field-info">🔐 Identificación única del cliente - DNI: 8 dígitos, RUC: 11 dígitos</div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="email">
                                    <span>📧 EMAIL</span>
                                </label>
                                <input type="email" id="email" name="email" maxlength="120" 
                                       placeholder="cliente@ejemplo.com"
                                       pattern="[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
                                       title="Ingrese una dirección de email válida">
                                <div class="field-info">📨 Email de contacto (opcional)</div>
                                <div class="char-counter"><span id="emailCount">0</span>/120 caracteres</div>
                            </div>
                            
                            <div class="form-group">
                                <label for="telefono">
                                    <span>📞 TELÉFONO</span>
                                </label>
                                <input type="tel" id="telefono" name="telefono" maxlength="20" 
                                       placeholder="+51 123 456 789"
                                       pattern="[\+]?[0-9\s\-\(\)]{9,}"
                                       title="Ingrese un número de teléfono válido">
                                <div class="field-info">📱 Teléfono de contacto (opcional)</div>
                                <div class="char-counter"><span id="telefonoCount">0</span>/20 caracteres</div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="direccion">
                                <span>🏠 DIRECCIÓN</span>
                            </label>
                            <input type="text" id="direccion" name="direccion" maxlength="200" 
                                   placeholder="Ingrese la dirección completa">
                            <div class="field-info">📍 Dirección del cliente (opcional)</div>
                            <div class="char-counter"><span id="direccionCount">0</span>/200 caracteres</div>
                        </div>

                        <div class="form-group">
                            <label for="preferencias">
                                <span>⭐ PREFERENCIAS</span>
                            </label>
                            <input type="text" id="preferencias" name="preferencias" maxlength="500" 
                                   placeholder="Preferencias especiales o notas adicionales">
                            <div class="field-info">🎯 Preferencias o observaciones (opcional)</div>
                            <div class="char-counter"><span id="preferenciasCount">0</span>/500 caracteres</div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" name="acc" value="Confirmar" class="btn btn-primary" id="submitBtn">
                                ✅ Confirmar y Guardar
                            </button>
                            <button type="reset" class="btn btn-secondary" id="resetBtn">
                                🗑️ Limpiar Formulario
                            </button>
                        </div>
                    </form>
                </div>

                <div class="navigation">
                    <a href="<%= request.getContextPath() %>/ClienteControlador?accion=listarTodos" class="btn btn-back">📋 Ver Todos los Clientes</a>
                    <a href="<%= request.getContextPath() %>/MascotaControlador?accion=listarTodas" class="btn btn-back">🐾 Gestionar Mascotas</a>
                    <a href="CitaControlador?accion=todasCitas" class="btn btn-back">📅 Ver Citas</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Script para manejar la interacción del menú
        document.addEventListener('DOMContentLoaded', function() {
            const menuItems = document.querySelectorAll('.menu-item');
            
            menuItems.forEach(item => {
                item.addEventListener('click', function() {
                    // Remover clase active de todos los items
                    menuItems.forEach(i => i.classList.remove('active'));
                    // Agregar clase active al item clickeado
                    this.classList.add('active');
                });
            });

            // Validación en tiempo real del formulario
            const form = document.getElementById('clienteForm');
            const inputs = form.querySelectorAll('input[required]');
            
            inputs.forEach(input => {
                input.addEventListener('blur', function() {
                    validateField(this);
                });
                
                input.addEventListener('input', function() {
                    if (this.value.trim() !== '') {
                        this.style.borderColor = 'var(--primary-color)';
                        this.style.backgroundColor = 'var(--white)';
                        this.parentElement.style.transform = 'translateY(0)';
                    }
                });

                input.addEventListener('focus', function() {
                    this.parentElement.style.transform = 'translateY(-2px)';
                });
                
                input.addEventListener('blur', function() {
                    this.parentElement.style.transform = 'translateY(0)';
                });
            });

            // Contadores de caracteres
            setupCharCounter('nombre', 'nombreCount');
            setupCharCounter('apellido', 'apellidoCount');
            setupCharCounter('email', 'emailCount');
            setupCharCounter('telefono', 'telefonoCount');
            setupCharCounter('direccion', 'direccionCount');
            setupCharCounter('preferencias', 'preferenciasCount');

            // Focus en el primer campo al cargar la página
            const firstInput = document.getElementById('nombre');
            if (firstInput) {
                setTimeout(() => {
                    firstInput.focus();
                }, 500);
            }

            // Confirmación antes de limpiar el formulario
            const resetButton = document.getElementById('resetBtn');
            if (resetButton) {
                resetButton.addEventListener('click', function(e) {
                    const hasData = Array.from(inputs).some(input => input.value.trim() !== '');
                    if (hasData && !confirm('¿Está seguro de que desea limpiar todos los campos del formulario?')) {
                        e.preventDefault();
                    } else {
                        // Resetear contadores
                        document.querySelectorAll('.char-counter span').forEach(span => {
                            span.textContent = '0';
                        });
                    }
                });
            }

            // Formateo automático del teléfono
            const phoneInput = document.getElementById('telefono');
            if (phoneInput) {
                phoneInput.addEventListener('blur', function() {
                    formatPhone(this);
                });
            }

            // Animaciones de entrada para elementos
            const animatedElements = document.querySelectorAll('.quick-help, .form-container');
            animatedElements.forEach((element, index) => {
                element.style.opacity = '0';
                element.style.transform = 'translateY(30px)';
                
                setTimeout(() => {
                    element.style.transition = 'all 0.6s cubic-bezier(0.4, 0, 0.2, 1)';
                    element.style.opacity = '1';
                    element.style.transform = 'translateY(0)';
                }, index * 100);
            });

            // Efecto hover para botones
            const buttons = document.querySelectorAll('.btn');
            buttons.forEach(button => {
                button.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-2px)';
                });
                button.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                });
            });
        });

        // Función para configurar contador de caracteres
        function setupCharCounter(inputId, counterId) {
            const input = document.getElementById(inputId);
            const counter = document.getElementById(counterId);
            const maxLength = input.maxLength;
            
            if (input && counter) {
                input.addEventListener('input', function() {
                    const length = this.value.length;
                    counter.textContent = length;
                    
                    const counterElement = counter.parentElement;
                    if (length > maxLength * 0.8) {
                        counterElement.className = 'char-counter warning';
                    } else if (length > maxLength * 0.95) {
                        counterElement.className = 'char-counter danger';
                    } else {
                        counterElement.className = 'char-counter';
                    }
                });
                
                // Inicializar contador
                counter.textContent = input.value.length;
            }
        }

        // Función para validar campos individuales
        function validateField(field) {
            if (field.value.trim() === '') {
                field.style.borderColor = 'var(--danger-color)';
                field.style.backgroundColor = '#fdf2f2';
                return false;
            } else {
                // Validación específica para DNI/RUC
                if (field.id === 'dniRuc') {
                    const value = field.value.trim();
                    if (!/^\d{8,11}$/.test(value)) {
                        field.style.borderColor = 'var(--danger-color)';
                        field.style.backgroundColor = '#fdf2f2';
                        return false;
                    }
                }
                
                field.style.borderColor = 'var(--success-color)';
                field.style.backgroundColor = '#f0f9f4';
                return true;
            }
        }

        // Función para formatear automáticamente el teléfono
        function formatPhone(input) {
            let value = input.value.replace(/\D/g, '');
            if (value.length > 0) {
                if (!value.startsWith('51')) {
                    value = '51' + value;
                }
                // Formato: +51 XXX XXX XXX
                value = '+51 ' + value.substring(2, 5) + ' ' + value.substring(5, 8) + ' ' + value.substring(8);
            }
            input.value = value;
        }

        // Función para validar el formulario antes de enviar
        function validarFormulario() {
            const requiredFields = [
                'nombre', 'apellido', 'dniRuc'
            ];
            
            let isValid = true;
            
            requiredFields.forEach(fieldId => {
                const field = document.getElementById(fieldId);
                if (!validateField(field)) {
                    isValid = false;
                }
            });
            
            // Validación adicional para DNI/RUC
            const dniRuc = document.getElementById('dniRuc');
            if (dniRuc.value.trim() && !/^\d{8,11}$/.test(dniRuc.value.trim())) {
                alert('El DNI/RUC debe contener entre 8 y 11 dígitos numéricos');
                dniRuc.style.borderColor = 'var(--danger-color)';
                isValid = false;
            }
            
            // Validación de email si está presente
            const email = document.getElementById('email');
            if (email.value.trim() && !email.checkValidity()) {
                alert('Por favor ingrese una dirección de email válida');
                email.style.borderColor = 'var(--danger-color)';
                isValid = false;
            }
            
            return isValid;
        }

        // Agregar validación al enviar el formulario
        document.getElementById('clienteForm').addEventListener('submit', function(e) {
            if (!validarFormulario()) {
                e.preventDefault();
            } else {
                // Mostrar loading en el botón de enviar
                const submitBtn = document.getElementById('submitBtn');
                const originalText = submitBtn.innerHTML;
                submitBtn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Guardando...';
                submitBtn.disabled = true;
                
                // Re-enable after 3 seconds (in case of error)
                setTimeout(() => {
                    submitBtn.innerHTML = originalText;
                    submitBtn.disabled = false;
                }, 3000);
            }
        });

        // Función para generar sugerencia de email
        document.getElementById('nombre').addEventListener('blur', function() {
            const nombre = this.value.trim().toLowerCase();
            const apellido = document.getElementById('apellido').value.trim().toLowerCase();
            const emailField = document.getElementById('email');
            
            if (nombre && apellido && !emailField.value) {
                const emailSuggestion = `${nombre}.${apellido}@gmail.com`.replace(/\s+/g, '.');
                emailField.placeholder = `Ej: ${emailSuggestion}`;
            }
        });
    </script>
</body>
</html>