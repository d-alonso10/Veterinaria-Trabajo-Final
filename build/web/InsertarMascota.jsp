<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Insertar Mascota - Sistema PetCare</title>
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
            --gradient-accent: linear-gradient(135deg, var(--accent-color) 0%, #c98cb1 100%);
            --gradient-info: linear-gradient(135deg, var(--info-color) 0%, #0b7dda 100%);
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

        /* Sidebar Styles */
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
            max-width: 1000px;
            margin: 0 auto;
        }

        /* Botones */
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
            background: var(--gradient-accent);
            color: var(--white);
            box-shadow: 0 8px 25px rgba(213, 173, 196, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(213, 173, 196, 0.4);
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

        .btn-danger {
            background: var(--gradient-danger);
            color: var(--white);
            box-shadow: 0 8px 25px rgba(244, 67, 54, 0.3);
        }

        .btn-danger:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(244, 67, 54, 0.4);
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

        .btn-info {
            background: var(--gradient-info);
            color: var(--white);
            box-shadow: 0 8px 25px rgba(33, 150, 243, 0.3);
        }

        .btn-info:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(33, 150, 243, 0.4);
        }

        .btn-small {
            padding: 12px 20px;
            font-size: 0.9em;
        }

        /* Mensajes de estado */
        .mensaje {
            padding: 20px 25px;
            margin: 0 0 30px 0;
            border-radius: var(--radius);
            border-left: 4px solid;
            font-size: 1em;
            box-shadow: var(--shadow);
            animation: fadeInUp 0.6s ease-out;
            background: var(--white);
        }

        .exito {
            border-left-color: var(--success-color);
            background: linear-gradient(135deg, #f0f9f4 0%, #e8f5e9 100%);
            color: #1e7e34;
        }

        .error {
            border-left-color: var(--danger-color);
            background: linear-gradient(135deg, #fdf2f2 0%, #ffebee 100%);
            color: #c53030;
        }

        /* Form Container */
        .form-container {
            background: var(--white);
            padding: 40px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
            border-top: 4px solid var(--accent-color);
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.8s ease-out;
        }

        .form-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-accent);
        }

        .form-header {
            text-align: center;
            margin-bottom: 35px;
            padding-bottom: 25px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        }

        .form-icon {
            font-size: 4em;
            margin-bottom: 20px;
            display: block;
            animation: pulse 2s infinite;
        }

        .form-header h2 {
            color: var(--text-dark);
            margin-bottom: 15px;
            font-size: 2.2em;
            font-weight: 700;
        }

        .form-header p {
            color: var(--text-light);
            font-size: 1.2em;
            font-weight: 500;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 25px;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-group label {
            display: block;
            margin-bottom: 10px;
            font-weight: 600;
            color: var(--text-dark);
            font-size: 1.05em;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 16px 20px;
            border: 1px solid rgba(0, 0, 0, 0.1);
            border-radius: var(--radius);
            font-size: 1em;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            background-color: #f9f9f9;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.05);
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--accent-color);
            background-color: var(--white);
            box-shadow: 0 0 0 3px rgba(213, 173, 196, 0.3), inset 0 2px 4px rgba(0,0,0,0.05);
            transform: translateY(-2px);
        }

        .form-group input:required,
        .form-group select:required {
            border-left: 3px solid var(--accent-color);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 120px;
            font-family: inherit;
            line-height: 1.5;
        }

        .form-actions {
            display: flex;
            gap: 20px;
            margin-top: 40px;
            padding-top: 25px;
            border-top: 1px solid rgba(0, 0, 0, 0.05);
        }

        .form-actions .btn {
            flex: 1;
        }

        /* Navigation */
        .navigation {
            display: flex;
            gap: 20px;
            margin-top: 40px;
            justify-content: center;
            flex-wrap: wrap;
        }

        /* Field Info */
        .field-info {
            font-size: 0.9em;
            color: var(--text-light);
            margin-top: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-style: italic;
        }

        .required-mark {
            color: var(--danger-color);
            font-weight: bold;
        }

        /* Character Counter */
        .char-counter {
            font-size: 0.85em;
            color: var(--text-light);
            text-align: right;
            margin-top: 8px;
            font-weight: 500;
        }

        .char-counter.warning {
            color: var(--warning-color);
        }

        .char-counter.danger {
            color: var(--danger-color);
            font-weight: 600;
        }

        /* Form Sections */
        .form-section {
            margin-bottom: 35px;
            padding-bottom: 25px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        }

        .section-title {
            color: var(--text-dark);
            margin-bottom: 20px;
            font-size: 1.4em;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 15px 20px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: var(--radius);
            border-left: 4px solid var(--accent-color);
        }

        /* Custom Select Styling */
        .form-group select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%235d6d7e' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 20px center;
            background-size: 16px;
            padding-right: 50px;
        }

        /* Species Icons */
        .species-option {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 8px 0;
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
            0% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.05);
            }
            100% {
                transform: scale(1);
            }
        }

        .floating {
            animation: floating 3s ease-in-out infinite;
        }

        @keyframes floating {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
        }

        /* Loading animation */
        .loading-dots {
            display: inline-flex;
            gap: 4px;
        }

        .loading-dots span {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: var(--white);
            animation: loading 1.4s infinite ease-in-out;
        }

        .loading-dots span:nth-child(1) { animation-delay: -0.32s; }
        .loading-dots span:nth-child(2) { animation-delay: -0.16s; }

        @keyframes loading {
            0%, 80%, 100% { transform: scale(0); }
            40% { transform: scale(1); }
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
            .form-grid {
                grid-template-columns: 1fr;
            }
            .form-actions {
                flex-direction: column;
            }
            .navigation {
                flex-direction: column;
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
            .form-header h2 {
                font-size: 1.8em;
            }
            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Sidebar Menu -->
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
                    <a href="dashboard.jsp">
                        <span class="menu-icon">📊</span>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="CitaControlador?accion=todasCitas">
                        <span class="menu-icon">📅</span>
                        <span>Citas</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="AtencionControlador">
                        <span class="menu-icon">🎯</span>
                        <span>Atención</span>
                    </a>
                </li>
                
                <!-- Gestión de Clientes -->
                <div class="menu-section">Gestión de Clientes</div>
                <li class="menu-item">
                    <a href="Clientes.jsp">
                        <span class="menu-icon">👥</span>
                        <span>Clientes</span>
                    </a>
                </li>
                <li class="menu-item active">
                    <a href="InsertarMascota.jsp">
                        <span class="menu-icon">➕</span>
                        <span>Nueva Mascota</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="ListaMascotas.jsp">
                        <span class="menu-icon">🐾</span>
                        <span>Mascotas</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="ServicioControlador">
                        <span class="menu-icon">🛠️</span>
                        <span>Servicios</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="ClienteControlador?accion=listarFrecuentes">
                        <span class="menu-icon">🏆</span>
                        <span>Clientes Frecuentes</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="BuscarClientes.jsp">
                        <span class="menu-icon">🔍</span>
                        <span>Búsqueda Avanzada</span>
                    </a>
                </li>
                
                <!-- Personal y Operaciones -->
                <div class="menu-section">Personal y Operaciones</div>
                <li class="menu-item">
                    <a href="GroomerControlador">
                        <span class="menu-icon">✂️</span>
                        <span>Groomers</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="SucursalControlador?accion=listar">
                        <span class="menu-icon">🏢</span>
                        <span>Sucursales</span>
                    </a>
                </li>
                
                <!-- Finanzas -->
                <div class="menu-section">Finanzas</div>
                <li class="menu-item">
                    <a href="pagos.jsp">
                        <span class="menu-icon">💳</span>
                        <span>Pagos</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="facturas.jsp">
                        <span class="menu-icon">🧾</span>
                        <span>Facturas</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="promociones.jsp">
                        <span class="menu-icon">🎁</span>
                        <span>Promociones</span>
                    </a>
                </li>
                
                <!-- Análisis y Control -->
                <div class="menu-section">Análisis y Control</div>
                <li class="menu-item">
                    <a href="ReporteControlador">
                        <span class="menu-icon">📈</span>
                        <span>Reportes</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="AuditControlador?accion=listar">
                        <span class="menu-icon">🔍</span>
                        <span>Auditoria</span>
                    </a>
                </li>
                
                <!-- Sistema -->
                <div class="menu-section">Sistema</div>
                <li class="menu-item">
                    <a href="ConfiguracionControlador?accion=listar">
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
                        <h1>➕ Registrar Nueva Mascota</h1>
                        <p>Complete el formulario para agregar una nueva mascota al sistema - <%= new java.text.SimpleDateFormat("EEEE, d 'de' MMMM 'de' yyyy").format(new java.util.Date()) %></p>
                    </div>
                    <div class="header-actions">
                        <a href="Clientes.jsp" class="btn btn-secondary">👥 Volver a Clientes</a>
                        <a href="ListaMascotas.jsp" class="btn btn-info">🐾 Ver Todas las Mascotas</a>
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
                
                <div class="form-container">
                    <div class="form-header">
                        <div class="form-icon">🐕</div>
                        <h2>Información de la Mascota</h2>
                        <p>Complete todos los campos requeridos para registrar una nueva mascota</p>
                    </div>
                    
                    <form action="MascotaControlador" method="POST" id="mascotaForm">
                        <input type="hidden" name="acc" value="Confirmar">
                        
                        <div class="form-section">
                            <h3 class="section-title">📋 Datos Básicos</h3>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="idCliente">ID Cliente <span class="required-mark">*</span></label>
                                    <input type="number" id="idCliente" name="idCliente" required 
                                           placeholder="Ingrese el ID del cliente"
                                           min="1" class="form-control">
                                    <div class="field-info">🔢 Número de identificación del cliente propietario</div>
                                </div>
                                
                                <div class="form-group">
                                    <label for="nombre">Nombre de la Mascota <span class="required-mark">*</span></label>
                                    <input type="text" id="nombre" name="nombre" required 
                                           placeholder="Ej: Max, Luna, Toby"
                                           maxlength="50" class="form-control">
                                    <div class="field-info">🐾 Nombre de la mascota (máx. 50 caracteres)</div>
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <h3 class="section-title">🎨 Características</h3>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="especie">Especie <span class="required-mark">*</span></label>
                                    <select id="especie" name="especie" required class="form-control">
                                        <option value="">Seleccione una especie</option>
                                        <option value="perro">🐕 Perro</option>
                                        <option value="gato">🐈 Gato</option>
                                        <option value="ave">🐦 Ave</option>
                                        <option value="roedor">🐹 Roedor</option>
                                        <option value="reptil">🦎 Reptil</option>
                                        <option value="otro">🐾 Otro</option>
                                    </select>
                                    <div class="field-info">🔍 Especie principal de la mascota</div>
                                </div>
                                
                                <div class="form-group">
                                    <label for="raza">Raza</label>
                                    <input type="text" id="raza" name="raza" 
                                           placeholder="Ej: Labrador, Siames, Mestizo"
                                           maxlength="50" class="form-control">
                                    <div class="field-info">📝 Raza o tipo de la mascota (opcional)</div>
                                </div>
                                
                                <div class="form-group">
                                    <label for="sexo">Sexo</label>
                                    <select id="sexo" name="sexo" class="form-control">
                                        <option value="">Seleccione sexo</option>
                                        <option value="macho">♂️ Macho</option>
                                        <option value="hembra">♀️ Hembra</option>
                                    </select>
                                    <div class="field-info">⚧️ Sexo de la mascota (opcional)</div>
                                </div>
                                
                                <div class="form-group">
                                    <label for="fechaNacimiento">Fecha de Nacimiento</label>
                                    <input type="date" id="fechaNacimiento" name="fechaNacimiento"
                                           max="<%= java.time.LocalDate.now() %>" class="form-control">
                                    <div class="field-info">📅 Fecha aproximada de nacimiento (opcional)</div>
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <h3 class="section-title">🔐 Identificación</h3>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="microchip">Número de Microchip</label>
                                    <input type="text" id="microchip" name="microchip" 
                                           placeholder="Ej: 985120003456789"
                                           maxlength="20"
                                           pattern="[0-9]{15}"
                                           title="El microchip debe contener 15 dígitos" class="form-control">
                                    <div class="field-info">🔢 Número de microchip (15 dígitos, opcional)</div>
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <h3 class="section-title">📝 Información Adicional</h3>
                            <div class="form-group full-width">
                                <label for="observaciones">Observaciones y Notas</label>
                                <textarea id="observaciones" name="observaciones" 
                                          placeholder="Ingrese observaciones importantes sobre la mascota: alergias, comportamientos especiales, condiciones médicas, etc."
                                          maxlength="500" class="form-control"></textarea>
                                <div class="char-counter" id="charCounter"><span id="charCount">0</span>/500 caracteres</div>
                                <div class="field-info">💡 Información adicional relevante sobre la mascota</div>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-success btn-full" id="submitBtn">
                                <span>✅ Confirmar y Registrar Mascota</span>
                            </button>
                            <button type="reset" class="btn btn-secondary btn-full">
                                <span>🔄 Limpiar Formulario</span>
                            </button>
                        </div>
                    </form>
                </div>

                <div class="navigation">
                    <a href="Clientes.jsp" class="btn btn-secondary">👥 Ver Todos los Clientes</a>
                    <a href="ListaMascotas.jsp" class="btn btn-info">🐾 Ver Todas las Mascotas</a>
                    <a href="MascotasPorCliente.jsp" class="btn btn-warning">🔍 Ver Mascotas por Cliente</a>
                    <a href="dashboard.jsp" class="btn btn-primary">📊 Ir al Dashboard</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Animaciones y efectos interactivos
        document.addEventListener('DOMContentLoaded', function() {
            // Efecto de aparición escalonada para los elementos
            const elements = document.querySelectorAll('.form-container, .mensaje');
            elements.forEach((element, index) => {
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
                    this.style.transform = 'translateY(-3px)';
                });
                button.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                });
            });

            // Contador de caracteres para observaciones
            const observacionesTextarea = document.getElementById('observaciones');
            const charCount = document.getElementById('charCount');
            const charCounter = document.getElementById('charCounter');
            
            if (observacionesTextarea && charCount) {
                observacionesTextarea.addEventListener('input', function() {
                    const length = this.value.length;
                    charCount.textContent = length;
                    
                    if (length > 450) {
                        charCounter.className = 'char-counter warning';
                    } else if (length > 490) {
                        charCounter.className = 'char-counter danger';
                    } else {
                        charCounter.className = 'char-counter';
                    }
                });
                
                // Inicializar contador
                charCount.textContent = observacionesTextarea.value.length;
            }

            // Focus en el primer campo al cargar la página
            const firstInput = document.getElementById('idCliente');
            if (firstInput) {
                setTimeout(() => {
                    firstInput.focus();
                }, 500);
            }

            // Validación de microchip
            const microchipInput = document.getElementById('microchip');
            if (microchipInput) {
                microchipInput.addEventListener('input', function() {
                    // Permitir solo números
                    this.value = this.value.replace(/\D/g, '');
                    
                    // Limitar a 15 caracteres
                    if (this.value.length > 15) {
                        this.value = this.value.slice(0, 15);
                    }
                });
            }

            // Mejorar la experiencia de fecha
            const fechaNacimientoInput = document.getElementById('fechaNacimiento');
            if (fechaNacimientoInput) {
                // Establecer fecha máxima como hoy
                const today = new Date().toISOString().split('T')[0];
                fechaNacimientoInput.max = today;
            }

            // Efectos visuales para campos con foco
            const formElements = document.querySelectorAll('input, select, textarea');
            formElements.forEach(element => {
                element.addEventListener('focus', function() {
                    this.parentElement.style.transform = 'translateY(-2px)';
                });
                
                element.addEventListener('blur', function() {
                    this.parentElement.style.transform = 'translateY(0)';
                });
            });

            // Validación en tiempo real de campos requeridos
            const requiredInputs = document.querySelectorAll('input[required], select[required]');
            
            requiredInputs.forEach(input => {
                input.addEventListener('blur', function() {
                    if (this.value.trim() === '') {
                        this.style.borderColor = 'var(--danger-color)';
                        this.style.backgroundColor = '#fdf2f2';
                    } else {
                        this.style.borderColor = 'var(--success-color)';
                        this.style.backgroundColor = '#f0f9f4';
                    }
                });
                
                input.addEventListener('input', function() {
                    if (this.value.trim() !== '') {
                        this.style.borderColor = 'var(--accent-color)';
                        this.style.backgroundColor = 'var(--white)';
                    }
                });
            });

            // Actualizar hora en tiempo real
            function updateTime() {
                const now = new Date();
                const options = { 
                    weekday: 'long', 
                    year: 'numeric', 
                    month: 'long', 
                    day: 'numeric',
                    hour: '2-digit',
                    minute: '2-digit',
                    second: '2-digit'
                };
                document.querySelector('.welcome p').textContent = 
                    'Complete el formulario para agregar una nueva mascota al sistema - ' + now.toLocaleDateString('es-ES', options);
            }

            setInterval(updateTime, 1000);
        });

        // Función para validar el formulario antes de enviar
        function validarFormulario() {
            const idCliente = document.getElementById('idCliente').value;
            const nombre = document.getElementById('nombre').value;
            const especie = document.getElementById('especie').value;
            
            if (!idCliente || !nombre || !especie) {
                mostrarMensaje('Por favor complete todos los campos requeridos (*)', 'error');
                return false;
            }
            
            if (idCliente < 1) {
                mostrarMensaje('El ID Cliente debe ser un número positivo', 'error');
                return false;
            }
            
            const microchip = document.getElementById('microchip').value;
            if (microchip && microchip.length !== 15) {
                mostrarMensaje('El número de microchip debe contener exactamente 15 dígitos', 'error');
                return false;
            }
            
            return true;
        }

        // Función para mostrar mensajes temporales
        function mostrarMensaje(mensaje, tipo) {
            // Remover mensajes existentes
            const mensajesExistentes = document.querySelectorAll('.mensaje-temp');
            mensajesExistentes.forEach(msg => msg.remove());
            
            const mensajeDiv = document.createElement('div');
            mensajeDiv.className = `mensaje ${tipo === 'error' ? 'error' : 'exito'} mensaje-temp`;
            mensajeDiv.innerHTML = `<strong>${tipo === 'error' ? '❌ Error:' : '✅ Éxito:'}</strong> ${mensaje}`;
            
            const mainContent = document.querySelector('.main-content');
            const formContainer = document.querySelector('.form-container');
            mainContent.insertBefore(mensajeDiv, formContainer);
            
            setTimeout(() => {
                mensajeDiv.remove();
            }, 5000);
        }

        // Agregar validación al enviar el formulario
        document.getElementById('mascotaForm').addEventListener('submit', function(e) {
            if (!validarFormulario()) {
                e.preventDefault();
                return;
            }
            
            // Mostrar loading en el botón de envío
            const submitBtn = document.getElementById('submitBtn');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Procesando...';
            submitBtn.disabled = true;
            
            // Simular procesamiento (en un caso real, esto sería el envío del formulario)
            setTimeout(() => {
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
                
                // Confirmación antes de enviar (en desarrollo)
                if (!confirm('¿Está seguro de que desea registrar esta mascota?')) {
                    e.preventDefault();
                }
            }, 1500);
        });

        // Confirmación antes de limpiar el formulario
        document.querySelector('button[type="reset"]').addEventListener('click', function(e) {
            const hasData = Array.from(document.querySelectorAll('input, select, textarea'))
                .some(element => element.value.trim() !== '');
                
            if (hasData && !confirm('¿Está seguro de que desea limpiar todos los campos del formulario?')) {
                e.preventDefault();
            }
        });

        // Cargar datos de ejemplo para desarrollo
        function cargarDatosEjemplo() {
            // Solo cargar datos de ejemplo si estamos en localhost o en desarrollo
            if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
                document.getElementById('idCliente').value = '1001';
                document.getElementById('nombre').value = 'Luna';
                document.getElementById('especie').value = 'gato';
                document.getElementById('raza').value = 'Siamés';
                document.getElementById('sexo').value = 'hembra';
                document.getElementById('microchip').value = '985120003456789';
                document.getElementById('observaciones').value = 'Mascota tranquila, le gusta jugar con pelotas. Alergia a ciertos tipos de comida.';
                
                console.log('Datos de ejemplo cargados para desarrollo');
            }
        }

        // Ejecutar carga de datos de ejemplo
        cargarDatosEjemplo();
    </script>
</body>
</html>