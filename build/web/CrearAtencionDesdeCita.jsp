<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Atención desde Cita - Sistema PetCare</title>
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
            max-width: 1200px;
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

        .btn-full {
            width: 100%;
            justify-content: center;
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

        .info {
            border-left-color: var(--info-color);
            background: linear-gradient(135deg, #f0f7ff 0%, #e3f2fd 100%);
            color: var(--text-dark);
        }

        /* Form Styles */
        .form-container {
            background: var(--white);
            padding: 40px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
            border-top: 4px solid var(--success-color);
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
            background: var(--gradient-success);
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

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            margin-bottom: 10px;
            font-weight: 600;
            color: var(--text-dark);
            font-size: 1.05em;
        }

        .form-control {
            width: 100%;
            padding: 16px 20px;
            border: 1px solid rgba(0, 0, 0, 0.1);
            border-radius: var(--radius);
            font-size: 1em;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            background-color: #f9f9f9;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.05);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
            background-color: var(--white);
            box-shadow: 0 0 0 3px rgba(171, 203, 213, 0.3), inset 0 2px 4px rgba(0,0,0,0.05);
            transform: translateY(-2px);
        }

        .form-row {
            display: flex;
            gap: 25px;
            margin-bottom: 25px;
        }

        .form-row .form-group {
            flex: 1;
        }

        .form-help {
            font-size: 0.9em;
            color: var(--text-light);
            margin-top: 8px;
            font-style: italic;
        }

        .required::after {
            content: " *";
            color: var(--danger-color);
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

        /* Info Panel */
        .info-panel {
            background: linear-gradient(135deg, #f0f7ff 0%, #e3f2fd 100%);
            padding: 25px 30px;
            border-radius: var(--radius);
            margin-bottom: 30px;
            border-left: 4px solid var(--info-color);
            box-shadow: var(--shadow);
            animation: fadeInUp 0.6s ease-out;
        }

        .info-panel h3 {
            color: var(--text-dark);
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 1.3em;
            font-weight: 600;
        }

        .info-panel ul {
            list-style: none;
            padding: 0;
        }

        .info-panel li {
            padding: 10px 0;
            display: flex;
            align-items: center;
            gap: 12px;
            transition: all 0.3s ease;
        }

        .info-panel li:hover {
            transform: translateX(5px);
        }

        .info-icon {
            color: var(--info-color);
            font-size: 1.2em;
            width: 24px;
            text-align: center;
        }

        /* Navigation */
        .navigation {
            display: flex;
            gap: 20px;
            margin-top: 40px;
            justify-content: center;
            flex-wrap: wrap;
        }

        /* Priority Indicator */
        .priority-indicator {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-top: 10px;
        }

        .priority-bar {
            flex: 1;
            height: 8px;
            background: #e0e0e0;
            border-radius: 4px;
            overflow: hidden;
            position: relative;
        }

        .priority-fill {
            height: 100%;
            border-radius: 4px;
            transition: all 0.4s ease;
        }

        .priority-low { background: var(--success-color); width: 30%; }
        .priority-medium { background: var(--warning-color); width: 60%; }
        .priority-high { background: var(--danger-color); width: 90%; }
        .priority-urgent { background: #8b0000; width: 100%; }

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
            .form-row {
                flex-direction: column;
                gap: 0;
            }
            .form-actions {
                flex-direction: column;
            }
            .form-container {
                padding: 25px;
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
                <li class="menu-item active">
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
                        <h1>⚡ Crear Atención desde Cita</h1>
                        <p>Convertir una cita programada en una atención activa - <%= new java.text.SimpleDateFormat("EEEE, d 'de' MMMM 'de' yyyy").format(new java.util.Date()) %></p>
                    </div>
                    <div class="header-actions">
                        <a href="CitaControlador?accion=todasCitas" class="btn btn-secondary">← Volver a Citas</a>
                        <a href="dashboard.jsp" class="btn btn-info">📊 Dashboard</a>
                    </div>
                </div>
            </div>

            <div class="main-content">
                <!-- Mensajes -->
                <% String mensaje = (String) request.getAttribute("mensaje"); %>
                <% if (mensaje != null) { %>
                    <div class="mensaje <%= mensaje.contains("✅") ? "exito" : mensaje.contains("❌") ? "error" : "info" %>">
                        <%= mensaje %>
                    </div>
                <% } %>

                <!-- Info Panel -->
                <div class="info-panel">
                    <h3><span class="info-icon">💡</span> Información Importante</h3>
                    <ul>
                        <li>
                            <span class="info-icon">📅</span>
                            Esta función convierte una cita existente en una atención activa en el sistema
                        </li>
                        <li>
                            <span class="info-icon">⏱️</span>
                            Los tiempos estimados ayudan a planificar la agenda del groomer
                        </li>
                        <li>
                            <span class="info-icon">🎯</span>
                            La prioridad afecta el orden de atención (0 = baja, 10 = alta)
                        </li>
                    </ul>
                </div>

                <div class="form-container">
                    <div class="form-header">
                        <div class="form-icon">⚡</div>
                        <h2>Datos de la Atención</h2>
                        <p>Complete la información para crear una nueva atención desde la cita</p>
                    </div>

                    <form action="CitaControlador" method="POST" id="atencionForm">
                        <input type="hidden" name="accion" value="crearAtencion">
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="idCita" class="required">ID Cita:</label>
                                <input type="number" id="idCita" name="idCita" class="form-control" required
                                       placeholder="Ingrese el ID de la cita" min="1">
                                <div class="form-help">Número identificador de la cita a convertir</div>
                            </div>
                            
                            <div class="form-group">
                                <label for="idGroomer" class="required">ID Groomer:</label>
                                <input type="number" id="idGroomer" name="idGroomer" class="form-control" required
                                       placeholder="ID del groomer asignado" min="1">
                                <div class="form-help">Profesional que realizará la atención</div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="idSucursal">ID Sucursal:</label>
                                <input type="number" id="idSucursal" name="idSucursal" class="form-control"
                                       placeholder="ID de la sucursal" min="1">
                                <div class="form-help">Opcional - Sucursal donde se realiza la atención</div>
                            </div>
                            
                            <div class="form-group">
                                <label for="turnoNum">Número de Turno:</label>
                                <input type="number" id="turnoNum" name="turnoNum" class="form-control"
                                       placeholder="Número de turno" min="1">
                                <div class="form-help">Opcional - Número de turno asignado</div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="tiempoEstimadoInicio">Tiempo Estimado Inicio:</label>
                                <input type="datetime-local" id="tiempoEstimadoInicio" name="tiempoEstimadoInicio" 
                                       class="form-control">
                                <div class="form-help">Fecha y hora estimada de inicio</div>
                            </div>
                            
                            <div class="form-group">
                                <label for="tiempoEstimadoFin">Tiempo Estimado Fin:</label>
                                <input type="datetime-local" id="tiempoEstimadoFin" name="tiempoEstimadoFin" 
                                       class="form-control">
                                <div class="form-help">Fecha y hora estimada de finalización</div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="prioridad">Prioridad (0-10):</label>
                            <input type="range" id="prioridad" name="prioridad" class="form-control" 
                                   min="0" max="10" value="5" step="1"
                                   oninput="actualizarPrioridad(this.value)">
                            <div class="priority-indicator">
                                <span id="nivelPrioridad" class="priority-label">Prioridad media</span>
                                <div class="priority-bar">
                                    <div id="priorityFill" class="priority-fill priority-medium"></div>
                                </div>
                            </div>
                            <div class="form-help">
                                <span id="descripcionPrioridad">Atención estándar - Tiempo de espera moderado</span>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-success btn-full" id="submitBtn">
                                <span>⚡ Crear Atención</span>
                            </button>
                            <button type="reset" class="btn btn-secondary btn-full">
                                <span>🔄 Limpiar Formulario</span>
                            </button>
                        </div>
                    </form>
                </div>

                <div class="navigation">
                    <a href="CitaControlador?accion=todasCitas" class="btn btn-secondary">← Volver a Citas</a>
                    <a href="CrearCita.jsp" class="btn btn-primary">➕ Crear Nueva Cita</a>
                    <a href="AtencionControlador" class="btn btn-warning">🎯 Ver Atenciones Activas</a>
                    <a href="dashboard.jsp" class="btn btn-info">📊 Ir al Dashboard</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Animaciones y efectos interactivos
        document.addEventListener('DOMContentLoaded', function() {
            // Efecto de aparición escalonada para los elementos
            const elements = document.querySelectorAll('.form-container, .info-panel, .mensaje');
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

            // Establecer fecha mínima como hoy para los campos de fecha
            const fechaHoy = new Date();
            const fechaMinima = fechaHoy.toISOString().slice(0, 16);
            
            const fechaInicio = document.getElementById('tiempoEstimadoInicio');
            const fechaFin = document.getElementById('tiempoEstimadoFin');
            
            if (fechaInicio) fechaInicio.min = fechaMinima;
            if (fechaFin) fechaFin.min = fechaMinima;
            
            // Si hay un ID de cita en la URL, cargarlo automáticamente
            const urlParams = new URLSearchParams(window.location.search);
            const idCitaParam = urlParams.get('idCita');
            if (idCitaParam) {
                document.getElementById('idCita').value = idCitaParam;
            }
            
            // Validación del formulario
            const form = document.getElementById('atencionForm');
            form.addEventListener('submit', function(e) {
                const idCita = document.getElementById('idCita').value;
                const idGroomer = document.getElementById('idGroomer').value;
                const fechaInicio = document.getElementById('tiempoEstimadoInicio').value;
                const fechaFin = document.getElementById('tiempoEstimadoFin').value;
                
                // Validar campos requeridos
                if (!idCita || !idGroomer) {
                    e.preventDefault();
                    mostrarMensaje('Por favor, complete los campos requeridos (ID Cita e ID Groomer).', 'error');
                    return;
                }
                
                // Validar que fecha fin no sea anterior a fecha inicio
                if (fechaInicio && fechaFin) {
                    const inicio = new Date(fechaInicio);
                    const fin = new Date(fechaFin);
                    
                    if (fin < inicio) {
                        e.preventDefault();
                        mostrarMensaje('La fecha de finalización no puede ser anterior a la fecha de inicio.', 'error');
                        return;
                    }
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
                    if (!confirm('¿Está seguro de que desea crear esta atención?')) {
                        e.preventDefault();
                    }
                }, 1000);
            });
            
            // Cargar datos de ejemplo para desarrollo
            cargarDatosEjemplo();
            
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
                    'Convertir una cita programada en una atención activa - ' + now.toLocaleDateString('es-ES', options);
            }

            setInterval(updateTime, 1000);
        });

        // Función para actualizar la descripción de prioridad
        function actualizarPrioridad(valor) {
            const nivelElement = document.getElementById('nivelPrioridad');
            const descripcionElement = document.getElementById('descripcionPrioridad');
            const priorityFill = document.getElementById('priorityFill');
            
            let nivel = '';
            let descripcion = '';
            let priorityClass = '';
            
            if (valor <= 2) {
                nivel = 'Prioridad muy baja';
                descripcion = 'Atención estándar sin urgencia - Tiempo de espera flexible';
                priorityClass = 'priority-low';
            } else if (valor <= 4) {
                nivel = 'Prioridad baja';
                descripcion = 'Atención normal - Tiempo de espera moderado';
                priorityClass = 'priority-low';
            } else if (valor <= 6) {
                nivel = 'Prioridad media';
                descripcion = 'Atención estándar - Tiempo de espera moderado';
                priorityClass = 'priority-medium';
            } else if (valor <= 8) {
                nivel = 'Prioridad alta';
                descripcion = 'Atención prioritaria - Reducir tiempo de espera';
                priorityClass = 'priority-high';
            } else {
                nivel = 'Prioridad urgente';
                descripcion = 'Máxima prioridad - Atención inmediata requerida';
                priorityClass = 'priority-urgent';
            }
            
            nivelElement.textContent = nivel;
            descripcionElement.textContent = descripcion;
            priorityFill.className = 'priority-fill ' + priorityClass;
        }

        // Función para cargar datos de ejemplo (solo en desarrollo)
        function cargarDatosEjemplo() {
            // Solo cargar datos de ejemplo si estamos en localhost o en desarrollo
            if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
                document.getElementById('idCita').value = '1001';
                document.getElementById('idGroomer').value = '201';
                document.getElementById('idSucursal').value = '301';
                document.getElementById('turnoNum').value = '5';
                document.getElementById('prioridad').value = '5';
                
                // Establecer fechas por defecto (2 horas a partir de ahora)
                const ahora = new Date();
                const inicio = new Date(ahora.getTime() + 2 * 60 * 60 * 1000);
                const fin = new Date(inicio.getTime() + 1 * 60 * 60 * 1000);
                
                document.getElementById('tiempoEstimadoInicio').value = inicio.toISOString().slice(0, 16);
                document.getElementById('tiempoEstimadoFin').value = fin.toISOString().slice(0, 16);
                
                // Actualizar descripción de prioridad
                actualizarPrioridad(5);
                
                console.log('Datos de ejemplo cargados para desarrollo');
            }
        }

        // Función para mostrar mensajes temporales
        function mostrarMensaje(mensaje, tipo) {
            const mensajeDiv = document.createElement('div');
            mensajeDiv.className = `mensaje ${tipo === 'error' ? 'error' : tipo === 'success' ? 'exito' : 'info'}`;
            mensajeDiv.textContent = mensaje;
            
            const mainContent = document.querySelector('.main-content');
            mainContent.insertBefore(mensajeDiv, mainContent.firstChild);
            
            setTimeout(() => {
                mensajeDiv.remove();
            }, 5000);
        }

        // Función para buscar información de la cita
        function buscarInfoCita() {
            const idCita = document.getElementById('idCita').value;
            if (idCita) {
                // Simular búsqueda de información de la cita
                mostrarMensaje(`Buscando información de la cita ID: ${idCita}...`, 'info');
                
                // Simular respuesta después de un tiempo
                setTimeout(() => {
                    mostrarMensaje(`Información de la cita ${idCita} cargada correctamente.`, 'success');
                }, 1500);
            } else {
                mostrarMensaje('Por favor, ingrese un ID de cita primero.', 'error');
            }
        }

        // Función para autocompletar desde la última atención
        function autocompletarDesdeUltima() {
            // Simular autocompletado desde la última atención creada
            document.getElementById('idGroomer').value = '201';
            document.getElementById('idSucursal').value = '301';
            document.getElementById('prioridad').value = '5';
            mostrarMensaje('Datos autocompletados desde la última atención creada.', 'info');
        }
    </script>
</body>
</html>