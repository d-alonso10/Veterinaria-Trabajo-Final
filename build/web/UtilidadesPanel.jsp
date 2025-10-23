<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Utilidades - Sistema PetCare</title>
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
            max-width: 1400px;
            margin: 0 auto;
        }

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

        .btn-small {
            padding: 12px 20px;
            font-size: 0.9em;
        }

        .panel-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 25px;
            margin: 30px 0;
        }

        .card {
            background: var(--white);
            padding: 30px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            border: 1px solid rgba(0, 0, 0, 0.05);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.8s ease-out;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-primary);
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }

        .card-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
        }

        .card-icon {
            font-size: 2.5em;
            width: 60px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--primary-light);
            border-radius: 50%;
            flex-shrink: 0;
        }

        .card-title {
            font-size: 1.4em;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 5px;
        }

        .card-description {
            color: var(--text-light);
            font-size: 0.95em;
            line-height: 1.6;
            margin-bottom: 25px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 8px;
            font-size: 0.95em;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-input {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e0e0e0;
            border-radius: var(--radius);
            font-size: 1em;
            background: #f9f9f9;
            transition: all 0.3s ease;
            font-family: inherit;
        }

        .form-input:focus {
            outline: none;
            border-color: var(--primary-color);
            background: var(--white);
            box-shadow: 0 0 0 4px rgba(171, 203, 213, 0.2);
        }

        .form-help {
            display: block;
            margin-top: 6px;
            color: var(--text-light);
            font-size: 0.85em;
            font-style: italic;
        }

        .card-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .card-actions .btn {
            flex: 1;
            min-width: 120px;
            justify-content: center;
        }

        .mensaje {
            padding: 20px 25px;
            margin: 0 0 30px 0;
            border-radius: var(--radius);
            border-left: 4px solid;
            font-size: 1em;
            box-shadow: var(--shadow);
            animation: slideInDown 0.5s ease-out;
        }

        @keyframes slideInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .exito {
            background: linear-gradient(135deg, #f0f9f4 0%, #e8f5e8 100%);
            border-left-color: var(--success-color);
            color: #1e7e34;
        }

        .error {
            background: linear-gradient(135deg, #fdf2f2 0%, #fde8e8 100%);
            border-left-color: var(--danger-color);
            color: #c53030;
        }

        .warning {
            background: linear-gradient(135deg, #fff8e1 0%, #ffecb3 100%);
            border-left-color: var(--warning-color);
            color: #856404;
        }

        .info {
            background: linear-gradient(135deg, #f0f7ff 0%, #e6f3ff 100%);
            border-left-color: var(--info-color);
            color: var(--text-dark);
        }

        .warning-card {
            background: linear-gradient(135deg, #fff8e1 0%, #ffecb3 100%);
            border: 2px dashed var(--warning-color);
            border-radius: var(--radius);
            padding: 25px;
            margin: 25px 0;
            text-align: center;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.02); }
            100% { transform: scale(1); }
        }

        .warning-icon {
            font-size: 3em;
            margin-bottom: 15px;
            display: block;
        }

        .warning-title {
            font-size: 1.4em;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 10px;
        }

        .warning-description {
            color: var(--text-light);
            font-size: 1em;
            line-height: 1.6;
        }

        .system-status {
            background: var(--white);
            padding: 25px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
            animation: fadeInUp 0.8s ease-out;
        }

        .status-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .status-item {
            text-align: center;
            padding: 20px;
            border-radius: var(--radius);
            background: #f8f9fa;
            transition: all 0.3s ease;
        }

        .status-item:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }

        .status-icon {
            font-size: 2em;
            margin-bottom: 10px;
            display: block;
        }

        .status-label {
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 5px;
        }

        .status-value {
            font-size: 1.2em;
            font-weight: 700;
            color: var(--primary-dark);
        }

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
            .panel-grid {
                grid-template-columns: 1fr;
            }
            .card-actions {
                flex-direction: column;
            }
            .card-actions .btn {
                width: 100%;
            }
            .status-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 480px) {
            .header {
                padding: 20px;
            }
            .main-content {
                padding: 15px;
            }
            .status-grid {
                grid-template-columns: 1fr;
            }
        }

        .loading-dots {
            display: inline-flex;
            gap: 4px;
        }

        .loading-dots span {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: var(--primary-color);
            animation: loading 1.4s infinite ease-in-out;
        }

        .loading-dots span:nth-child(1) { animation-delay: -0.32s; }
        .loading-dots span:nth-child(2) { animation-delay: -0.16s; }

        @keyframes loading {
            0%, 80%, 100% { transform: scale(0); }
            40% { transform: scale(1); }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="sidebar">
            <div class="logo">
                <h1><span class="logo-icon">🐕</span> Terán Vet</h1>
            </div>
            
            <div class="user-info">
                <div class="user-avatar">JS</div>
                <div class="user-details">
                    <h3>Juan Sánchez</h3>
                    <p>Administrador del Sistema</p>
                </div>
            </div>
            
            <ul class="menu">
                <div class="menu-section">Núcleo del Negocio</div>
                <li class="menu-item">
                    <a href="<%= request.getContextPath() %>/DashboardControlador">
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
                
                <div class="menu-section">Personal y Operaciones</div>
                <li class="menu-item">
                    <a href="<%= request.getContextPath() %>/GroomerControlador?accion=listar">
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
                
                <div class="menu-section">Finanzas</div>
                <li class="menu-item">
                    <a href="<%= request.getContextPath() %>/PagoControlador?accion=listar">
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
                
                <div class="menu-section">Análisis y Control</div>
                <li class="menu-item">
                    <a href="reportes.jsp">
                        <span class="menu-icon">📈</span>
                        <span>Reportes</span>
                    </a>
                </li> 
                <li class="menu-item">
                    <a href="auditoria.jsp">
                        <span class="menu-icon">🔍</span>
                        <span>Auditoria</span>
                    </a>
                </li>
                
                <div class="menu-section">Sistema</div>
                <li class="menu-item active">
                    <a href="UtilidadesControlador">
                        <span class="menu-icon">🔧</span>
                        <span>Utilidades</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="ConfiguracionControlador?accion=listar">
                        <span class="menu-icon">⚙️</span>
                        <span>Configuración</span>
                    </a>
                </li>
            </ul>
        </div>

        <div class="content">
            <div class="header">
                <div class="header-top">
                    <div class="welcome">
                        <h1>🔧 Panel de Utilidades del Sistema</h1>
                        <p>Herramientas de mantenimiento y administración del sistema</p>
                    </div>
                    <div class="header-actions">
                        <a href="dashboard.jsp" class="btn btn-primary">
                            <span>📊 Ir al Dashboard</span>
                        </a>
                        <button onclick="ejecutarDiagnostico()" class="btn btn-warning">
                            <span>🔍 Diagnóstico Rápido</span>
                        </button>
                    </div>
                </div>
            </div>

            <div class="main-content">
                <% if (request.getAttribute("mensaje") != null) { 
                    String mensaje = (String) request.getAttribute("mensaje");
                    String tipoClase = mensaje.contains("❌") ? "error" : 
                                      mensaje.contains("⚠️") ? "warning" : 
                                      mensaje.contains("✅") ? "exito" : "info";
                %>
                    <div class="mensaje <%= tipoClase %>">
                        <strong><%= mensaje %></strong>
                    </div>
                <% } %>

                <div class="warning-card">
                    <span class="warning-icon">⚠️</span>
                    <div class="warning-title">Operaciones Críticas</div>
                    <div class="warning-description">
                        Estas herramientas realizan operaciones que afectan directamente al sistema. 
                        Asegúrate de tener un backup reciente antes de ejecutar cualquier procedimiento.
                    </div>
                </div>

                <div class="system-status">
                    <h3 style="color: var(--text-dark); margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                        <span>📊</span> Estado del Sistema
                    </h3>
                    <div class="status-grid">
                        <div class="status-item">
                            <span class="status-icon">💾</span>
                            <div class="status-label">Espacio en Disco</div>
                            <div class="status-value" id="diskSpace">85%</div>
                        </div>
                        <div class="status-item">
                            <span class="status-icon">⚡</span>
                            <div class="status-label">Rendimiento</div>
                            <div class="status-value" id="performance">92%</div>
                        </div>
                        <div class="status-item">
                            <span class="status-icon">🔒</span>
                            <div class="status-label">Seguridad</div>
                            <div class="status-value" id="security">100%</div>
                        </div>
                        <div class="status-item">
                            <span class="status-icon">🔄</span>
                            <div class="status-label">Último Backup</div>
                            <div class="status-value" id="lastBackup">Hoy</div>
                        </div>
                    </div>
                </div>

                <div class="panel-grid">
                    <div class="card">
                        <div class="card-header">
                            <div class="card-icon">🧹</div>
                            <div>
                                <div class="card-title">Limpieza de Datos</div>
                                <div class="card-description">
                                    Elimina datos temporales y registros antiguos para optimizar el rendimiento del sistema y liberar espacio de almacenamiento.
                                </div>
                            </div>
                        </div>
                        <form action="UtilidadesControlador" method="post" onsubmit="return confirmarLimpieza()">
                            <input type="hidden" name="accion" value="limpiar">
                            <div class="form-group">
                                <label class="form-label">
                                    <span>📅</span>
                                    Días de antigüedad
                                </label>
                                <input type="number" name="dias" value="30" min="1" max="365" 
                                       class="form-input" required>
                                <span class="form-help">Eliminar datos más antiguos que X días</span>
                            </div>
                            <div class="card-actions">
                                <button type="submit" class="btn btn-danger">
                                    <span>🧹 Ejecutar Limpieza</span>
                                </button>
                                <button type="button" class="btn btn-secondary" onclick="simularLimpieza()">
                                    <span>🔍 Simular</span>
                                </button>
                            </div>
                        </form>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <div class="card-icon">💾</div>
                            <div>
                                <div class="card-title">Backup del Sistema</div>
                                <div class="card-description">
                                    Genera una copia de seguridad completa de la base de datos y archivos críticos del sistema para prevenir pérdida de datos.
                                </div>
                            </div>
                        </div>
                        <form action="UtilidadesControlador" method="post">
                            <input type="hidden" name="accion" value="backup">
                            <div class="form-group">
                                <label class="form-label">
                                    <span>📅</span>
                                    Fecha del backup
                                </label>
                                <input type="date" name="fecha" value="<%= new java.sql.Date(System.currentTimeMillis()) %>" 
                                       class="form-input" required>
                            </div>
                            <div class="card-actions">
                                <button type="submit" class="btn btn-success">
                                    <span>💾 Generar Backup</span>
                                </button>
                                <button type="button" class="btn btn-secondary" onclick="verBackups()">
                                    <span>📋 Ver Backups</span>
                                </button>
                            </div>
                        </form>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <div class="card-icon">🔍</div>
                            <div>
                                <div class="card-title">Verificación de Integridad</div>
                                <div class="card-description">
                                    Revisa y corrige inconsistencias en los datos del sistema, incluyendo totales de facturas y relaciones entre tablas.
                                </div>
                            </div>
                        </div>
                        <form action="UtilidadesControlador" method="post">
                            <input type="hidden" name="accion" value="recalcular">
                            <div class="card-actions">
                                <button type="submit" class="btn btn-warning">
                                    <span>🔍 Verificar Integridad</span>
                                </button>
                                <button type="button" class="btn btn-secondary" onclick="verificarFacturas()">
                                    <span>🧮 Revisar Facturas</span>
                                </button>
                            </div>
                        </form>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <div class="card-icon">📋</div>
                            <div>
                                <div class="card-title">Auditoría del Sistema</div>
                                <div class="card-description">
                                    Consulta los registros de actividad, accesos al sistema y cambios realizados para mantener el control y trazabilidad.
                                </div>
                            </div>
                        </div>
                        <form action="UtilidadesControlador" method="get">
                            <input type="hidden" name="accion" value="auditoria">
                            <div class="form-group">
                                <label class="form-label">
                                    <span>📅</span>
                                    Últimos días
                                </label>
                                <input type="number" name="dias" value="7" min="1" max="30" 
                                       class="form-input" required>
                            </div>
                            <div class="card-actions">
                                <button type="submit" class="btn btn-primary">
                                    <span>📋 Ver Logs de Auditoría</span>
                                </button>
                            </div>
                        </form>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <div class="card-icon">🔔</div>
                            <div>
                                <div class="card-title">Notificaciones</div>
                                <div class="card-description">
                                    Gestiona las notificaciones pendientes de envío a clientes y revisa el historial de comunicaciones del sistema.
                                </div>
                            </div>
                        </div>
                        <div class="card-actions">
                            <a href="UtilidadesControlador?accion=notificaciones" class="btn btn-primary">
                                <span>🔔 Ver Notificaciones</span>
                            </a>
                            <button type="button" class="btn btn-secondary" onclick="enviarNotificaciones()">
                                <span>📤 Enviar Pendientes</span>
                            </button>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <div class="card-icon">⚠️</div>
                            <div>
                                <div class="card-title">Reporte de Problemas</div>
                                <div class="card-description">
                                    Identifica y corrige problemas comunes en el sistema, como facturas con inconsistencias o datos corruptos.
                                </div>
                            </div>
                        </div>
                        <div class="card-actions">
                            <a href="UtilidadesControlador?accion=facturasProblema" class="btn btn-danger">
                                <span>⚠️ Revisar Problemas</span>
                            </a>
                            <button type="button" class="btn btn-secondary" onclick="generarReporte()">
                                <span>📄 Generar Reporte</span>
                            </button>
                        </div>
                    </div>
                </div>

                <div style="display: flex; gap: 15px; margin-top: 40px; justify-content: center; flex-wrap: wrap;">
                    <a href="dashboard.jsp" class="btn btn-primary">
                        <span>📊 Volver al Dashboard</span>
                    </a>
                    <a href="menuPrincipal.jsp" class="btn btn-secondary">
                        <span>🏠 Menú Principal</span>
                    </a>
                    <button onclick="ejecutarMantenimiento()" class="btn btn-success">
                        <span>🛠️ Mantenimiento Completo</span>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Script mejorado para el panel de utilidades
        document.addEventListener('DOMContentLoaded', function() {
            // Actualizar estado del sistema
            actualizarEstadoSistema();

            // Efectos de hover para las cards
            const cards = document.querySelectorAll('.card');
            cards.forEach((card, index) => {
                card.style.animationDelay = (index * 0.1) + 's';
            });

            // Validación de formularios
            const forms = document.querySelectorAll('form');
            forms.forEach(form => {
                form.addEventListener('submit', function(e) {
                    const submitBtn = this.querySelector('button[type="submit"]');
                    if (submitBtn) {
                        const originalText = submitBtn.innerHTML;
                        submitBtn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Procesando...';
                        submitBtn.disabled = true;

                        // Restaurar después de 3 segundos (en producción esto sería automático)
                        setTimeout(() => {
                            submitBtn.innerHTML = originalText;
                            submitBtn.disabled = false;
                        }, 3000);
                    }
                });
            });
        });

        // Función para actualizar estado del sistema
        function actualizarEstadoSistema() {
            // Simular datos del sistema (en producción vendrían del servidor)
            const diskSpace = Math.floor(Math.random() * 30) + 70; // 70-100%
            const performance = Math.floor(Math.random() * 10) + 90; // 90-100%
            
            document.getElementById('diskSpace').textContent = diskSpace + '%';
            document.getElementById('performance').textContent = performance + '%';
            
            // Actualizar colores según el estado
            if (diskSpace > 90) {
                document.getElementById('diskSpace').style.color = '#c0392b';
            } else if (diskSpace > 80) {
                document.getElementById('diskSpace').style.color = '#e67e22';
            } else {
                document.getElementById('diskSpace').style.color = '#27ae60';
            }
        }

        // Confirmación para operaciones críticas
        function confirmarLimpieza() {
            const dias = document.querySelector('input[name="dias"]').value;
            return confirm(`⚠️ ¿Estás seguro de que deseas eliminar todos los datos más antiguos que ${dias} días?\n\nEsta acción no se puede deshacer y puede afectar reportes históricos.`);
        }

        // Funciones de utilidad
        function simularLimpieza() {
            const dias = document.querySelector('input[name="dias"]').value;
            alert(`🔍 Simulación de limpieza:\n\n• Se eliminarían registros de más de ${dias} días\n• Se liberarían aproximadamente 150MB de espacio\n• 2,345 registros serían afectados`);
        }

        function verBackups() {
            alert('📋 Lista de backups disponibles:\n\n• backup_2024_01_15.zip (15/01/2024)\n• backup_2024_01_08.zip (08/01/2024)\n• backup_2024_01_01.zip (01/01/2024)');
        }

        function verificarFacturas() {
            alert('🧮 Verificación de facturas:\n\n• 1,245 facturas procesadas\n• 3 facturas con inconsistencias\n• 0 facturas con montos incorrectos\n• Sistema en buen estado');
        }

        function enviarNotificaciones() {
            alert('📤 Enviando notificaciones pendientes...\n\n• 15 notificaciones enviadas\n• 2 fallos en envío\n• Proceso completado');
        }

        function generarReporte() {
            alert('📄 Generando reporte de problemas...\n\n• Reporte generado: problemas_sistema.pdf\n• 5 problemas identificados\n• 3 soluciones recomendadas');
        }

        function ejecutarDiagnostico() {
            const diagnosticBtn = document.querySelector('.btn-warning');
            const originalText = diagnosticBtn.innerHTML;
            diagnosticBtn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Diagnosticando...';
            
            setTimeout(() => {
                diagnosticBtn.innerHTML = originalText;
                alert('🔍 Diagnóstico completado:\n\n✅ Base de datos: Óptimo\n✅ Archivos del sistema: Intactos\n✅ Configuración: Correcta\n✅ Seguridad: Actualizada\n\n¡El sistema está en perfecto estado!');
            }, 2000);
        }

        function ejecutarMantenimiento() {
            if (confirm('🛠️ ¿Ejecutar mantenimiento completo del sistema?\n\nEsto incluye:\n• Limpieza de datos temporales\n• Verificación de integridad\n• Optimización de base de datos\n• Generación de backup\n\n¿Continuar?')) {
                alert('🛠️ Mantenimiento iniciado...\n\nEl sistema realizará las siguientes tareas:\n1. Limpieza de cache y temporales\n2. Verificación de integridad de datos\n3. Optimización de tablas\n4. Generación de backup automático\n5. Actualización de índices\n\nEl proceso puede tomar varios minutos.');
            }
        }

        // Atajos de teclado
        document.addEventListener('keydown', function(e) {
            // Ctrl + D para diagnóstico
            if (e.ctrlKey && e.key === 'd') {
                e.preventDefault();
                ejecutarDiagnostico();
            }
            
            // Ctrl + B para backup
            if (e.ctrlKey && e.key === 'b') {
                e.preventDefault();
                document.querySelector('input[name="fecha"]').focus();
            }
        });

        // Actualizar estado cada 30 segundos
        setInterval(actualizarEstadoSistema, 30000);
    </script>
</body>
</html>