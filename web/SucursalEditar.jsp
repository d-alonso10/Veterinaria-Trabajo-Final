<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Sucursal" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Sucursal - Sistema PetCare</title>
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
            padding: 14px 24px;
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
            padding: 10px 16px;
            font-size: 0.85em;
        }

        /* Form Styles */
        .form-container {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            padding: 40px;
            margin: 30px auto;
            max-width: 600px;
            animation: fadeInUp 0.8s ease-out;
            position: relative;
            overflow: hidden;
        }

        .form-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-info);
        }

        .form-header {
            text-align: center;
            margin-bottom: 35px;
        }

        .form-header h2 {
            font-size: 2em;
            color: var(--text-dark);
            margin-bottom: 10px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }

        .form-header p {
            color: var(--text-light);
            font-size: 1.1em;
        }

        .sucursal-info {
            background: rgba(33, 150, 243, 0.1);
            padding: 20px;
            border-radius: var(--radius);
            margin-bottom: 25px;
            border-left: 4px solid var(--info-color);
        }

        .sucursal-info h4 {
            color: var(--text-dark);
            margin-bottom: 10px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .sucursal-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }

        .detail-item {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .detail-label {
            font-size: 0.85em;
            color: var(--text-light);
            font-weight: 500;
        }

        .detail-value {
            font-weight: 600;
            color: var(--text-dark);
        }

        .form-group {
            margin-bottom: 25px;
            position: relative;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--text-dark);
            font-size: 1em;
        }

        .form-input {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e9ecef;
            border-radius: var(--radius);
            font-size: 1em;
            transition: all 0.3s ease;
            background: var(--bg-light);
        }

        .form-input:focus {
            outline: none;
            border-color: var(--info-color);
            background: var(--white);
            box-shadow: 0 0 0 3px rgba(33, 150, 243, 0.1);
            transform: translateY(-2px);
        }

        .form-input:hover {
            border-color: var(--primary-light);
        }

        .form-required::after {
            content: '*';
            color: var(--danger-color);
            margin-left: 4px;
        }

        .form-actions {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            margin-top: 35px;
            padding-top: 25px;
            border-top: 1px solid rgba(0, 0, 0, 0.1);
        }

        .form-help {
            background: rgba(33, 150, 243, 0.1);
            padding: 15px 20px;
            border-radius: var(--radius);
            margin-top: 25px;
            border-left: 4px solid var(--info-color);
        }

        .form-help h4 {
            color: var(--text-dark);
            margin-bottom: 8px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-help p {
            color: var(--text-light);
            font-size: 0.9em;
            line-height: 1.5;
        }

        /* Input Icons */
        .input-with-icon {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 1.2em;
            color: var(--text-light);
        }

        .input-with-icon .form-input {
            padding-left: 50px;
        }

        /* Validation Styles */
        .form-input:invalid:not(:focus):not(:placeholder-shown) {
            border-color: var(--danger-color);
            background: rgba(244, 67, 54, 0.05);
        }

        .form-input:valid:not(:focus):not(:placeholder-shown) {
            border-color: var(--success-color);
            background: rgba(76, 175, 80, 0.05);
        }

        .validation-message {
            font-size: 0.85em;
            margin-top: 6px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .validation-error {
            color: var(--danger-color);
        }

        .validation-success {
            color: var(--success-color);
        }

        /* Error State */
        .error-container {
            background: rgba(244, 67, 54, 0.1);
            border: 1px solid var(--danger-color);
            border-radius: var(--radius);
            padding: 25px;
            text-align: center;
            margin: 30px auto;
            max-width: 500px;
            animation: fadeInUp 0.8s ease-out;
        }

        .error-icon {
            font-size: 3em;
            margin-bottom: 15px;
            display: block;
        }

        .error-title {
            color: var(--danger-color);
            font-size: 1.5em;
            margin-bottom: 10px;
            font-weight: 600;
        }

        .error-message {
            color: var(--text-light);
            margin-bottom: 20px;
        }

        /* Animations */
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

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        .shake {
            animation: shake 0.5s ease-in-out;
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
                margin: 20px;
            }
            .form-actions {
                flex-direction: column;
            }
            .btn {
                width: 100%;
                justify-content: center;
            }
            .sucursal-details {
                grid-template-columns: 1fr;
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
                margin: 10px;
            }
            .form-header h2 {
                font-size: 1.6em;
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

        /* Success Animation */
        @keyframes successCheck {
            0% { transform: scale(0); }
            50% { transform: scale(1.2); }
            100% { transform: scale(1); }
        }

        .success-check {
            animation: successCheck 0.6s ease-in-out;
        }

        /* Change Highlight */
        .change-highlight {
            background: rgba(255, 193, 7, 0.1);
            border: 1px solid var(--warning-color);
            border-radius: var(--radius);
            padding: 10px 15px;
            margin-top: 8px;
            font-size: 0.85em;
        }

        .change-item {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 5px 0;
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
                <li class="menu-item active">
                    <a href="SucursalControlador?accion=listar">
                        <span class="menu-icon">🏢</span>
                        <span>Sucursales</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="GroomerControlador">
                        <span class="menu-icon">✂️</span>
                        <span>Groomers</span>
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
                        <h1>✏️ Editar Sucursal</h1>
                        <p>Actualice la información de la sucursal - <%= new java.text.SimpleDateFormat("EEEE, d 'de' MMMM 'de' yyyy").format(new java.util.Date()) %></p>
                    </div>
                    <div class="header-actions">
                        <a href="SucursalControlador?accion=listar" class="btn btn-primary">📋 Volver al Listado</a>
                    </div>
                </div>
            </div>

            <div class="main-content">
                <%
                    Sucursal s = (Sucursal) request.getAttribute("sucursal");
                    if (s == null) {
                %>
                    <div class="error-container">
                        <span class="error-icon">❌</span>
                        <h2 class="error-title">Sucursal No Encontrada</h2>
                        <p class="error-message">No se pudo encontrar la sucursal solicitada. Puede que haya sido eliminada o no exista.</p>
                        <a href="SucursalControlador?accion=listar" class="btn btn-primary">📋 Volver al Listado</a>
                    </div>
                <%
                    } else {
                %>
                    <div class="form-container">
                        <div class="form-header">
                            <h2><span>✏️</span> Editar Información</h2>
                            <p>Modifique los datos de la sucursal según sea necesario</p>
                        </div>

                        <div class="sucursal-info">
                            <h4>📋 Información Actual</h4>
                            <div class="sucursal-details">
                                <div class="detail-item">
                                    <span class="detail-label">ID Sucursal</span>
                                    <span class="detail-value"><%= s.getIdSucursal() %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Estado</span>
                                    <span class="detail-value">🟢 Activa</span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Última Actualización</span>
                                    <span class="detail-value"><%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(new java.util.Date()) %></span>
                                </div>
                            </div>
                        </div>

                        <form id="sucursalForm" action="SucursalControlador" method="post">
                            <input type="hidden" name="accion" value="actualizar">
                            <input type="hidden" name="idSucursal" value="<%= s.getIdSucursal() %>">

                            <div class="form-group">
                                <label for="nombre" class="form-label form-required">🏢 Nombre de la Sucursal</label>
                                <div class="input-with-icon">
                                    <span class="input-icon">🏢</span>
                                    <input type="text" 
                                           id="nombre" 
                                           name="nombre" 
                                           class="form-input" 
                                           value="<%= s.getNombre() %>"
                                           placeholder="Ingrese el nombre de la sucursal"
                                           required
                                           maxlength="100">
                                </div>
                                <div class="validation-message" id="nombreValidation"></div>
                            </div>

                            <div class="form-group">
                                <label for="direccion" class="form-label form-required">📍 Dirección</label>
                                <div class="input-with-icon">
                                    <span class="input-icon">📍</span>
                                    <input type="text" 
                                           id="direccion" 
                                           name="direccion" 
                                           class="form-input" 
                                           value="<%= s.getDireccion() %>"
                                           placeholder="Ingrese la dirección completa"
                                           required
                                           maxlength="200">
                                </div>
                                <div class="validation-message" id="direccionValidation"></div>
                            </div>

                            <div class="form-group">
                                <label for="telefono" class="form-label form-required">📞 Teléfono</label>
                                <div class="input-with-icon">
                                    <span class="input-icon">📞</span>
                                    <input type="tel" 
                                           id="telefono" 
                                           name="telefono" 
                                           class="form-input" 
                                           value="<%= s.getTelefono() %>"
                                           placeholder="Ingrese el número de teléfono"
                                           required
                                           pattern="[0-9+\-\s()]{9,15}"
                                           maxlength="15">
                                </div>
                                <div class="validation-message" id="telefonoValidation"></div>
                            </div>

                            <div id="changesContainer" style="display: none;">
                                <div class="change-highlight">
                                    <h4>📝 Cambios Detectados</h4>
                                    <div id="changesList"></div>
                                </div>
                            </div>

                            <div class="form-help">
                                <h4>💡 Información Importante</h4>
                                <p>• Todos los campos marcados con <span style="color: var(--danger-color);">*</span> son obligatorios</p>
                                <p>• Los cambios se reflejarán inmediatamente en el sistema</p>
                                <p>• Verifique que la información sea correcta antes de guardar</p>
                                <p>• Los clientes verán la información actualizada en sus próximas visitas</p>
                            </div>

                            <div class="form-actions">
                                <button type="button" onclick="window.location.href='SucursalControlador?accion=listar'" class="btn btn-warning">
                                    ❌ Cancelar
                                </button>
                                <button type="button" id="resetBtn" class="btn btn-danger">
                                    🔄 Restablecer
                                </button>
                                <button type="submit" class="btn btn-success" id="submitBtn">
                                    💾 Actualizar Sucursal
                                </button>
                            </div>
                        </form>
                    </div>
                <%
                    }
                %>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            <%
                if (s != null) {
            %>
            const form = document.getElementById('sucursalForm');
            const submitBtn = document.getElementById('submitBtn');
            const resetBtn = document.getElementById('resetBtn');
            const inputs = form.querySelectorAll('input[required]');
            const changesContainer = document.getElementById('changesContainer');
            const changesList = document.getElementById('changesList');

            // Valores originales para detectar cambios
            const originalValues = {
                nombre: '<%= s.getNombre() %>',
                direccion: '<%= s.getDireccion() %>',
                telefono: '<%= s.getTelefono() %>'
            };

            // Validación en tiempo real
            inputs.forEach(input => {
                input.addEventListener('input', function() {
                    validateField(this);
                    detectChanges();
                });

                input.addEventListener('blur', function() {
                    validateField(this);
                });
            });

            // Botón de restablecer
            resetBtn.addEventListener('click', function() {
                if (confirm('¿Está seguro de que desea restablecer todos los cambios?')) {
                    document.getElementById('nombre').value = originalValues.nombre;
                    document.getElementById('direccion').value = originalValues.direccion;
                    document.getElementById('telefono').value = originalValues.telefono;
                    
                    inputs.forEach(input => validateField(input));
                    changesContainer.style.display = 'none';
                    
                    // Efecto visual de restablecimiento
                    resetBtn.innerHTML = '✅ Restablecido!';
                    setTimeout(() => {
                        resetBtn.innerHTML = '🔄 Restablecer';
                    }, 2000);
                }
            });

            // Validación del formulario
            form.addEventListener('submit', function(e) {
                e.preventDefault();
                
                let isValid = true;
                inputs.forEach(input => {
                    if (!validateField(input)) {
                        isValid = false;
                    }
                });

                if (isValid) {
                    const hasChanges = detectChanges();
                    if (!hasChanges) {
                        if (confirm('No se detectaron cambios. ¿Desea continuar de todos modos?')) {
                            showLoading();
                            setTimeout(() => form.submit(), 1500);
                        }
                    } else {
                        showLoading();
                        setTimeout(() => form.submit(), 1500);
                    }
                } else {
                    showValidationErrors();
                }
            });

            function validateField(field) {
                const validationElement = document.getElementById(field.id + 'Validation');
                let isValid = true;
                let message = '';

                if (field.value.trim() === '') {
                    isValid = false;
                    message = '⚠️ Este campo es obligatorio';
                    field.classList.add('shake');
                } else if (field.id === 'telefono' && !isValidPhone(field.value)) {
                    isValid = false;
                    message = '⚠️ Formato de teléfono inválido';
                    field.classList.add('shake');
                } else {
                    message = '✅ Campo válido';
                    field.classList.remove('shake');
                }

                validationElement.textContent = message;
                validationElement.className = 'validation-message ' + 
                    (isValid ? 'validation-success' : 'validation-error');

                // Actualizar estilos del campo
                if (isValid) {
                    field.style.borderColor = 'var(--success-color)';
                    field.style.background = 'rgba(76, 175, 80, 0.05)';
                } else {
                    field.style.borderColor = 'var(--danger-color)';
                    field.style.background = 'rgba(244, 67, 54, 0.05)';
                }

                return isValid;
            }

            function isValidPhone(phone) {
                const phoneRegex = /^[0-9+\-\s()]{9,15}$/;
                return phoneRegex.test(phone);
            }

            function detectChanges() {
                const currentValues = {
                    nombre: document.getElementById('nombre').value,
                    direccion: document.getElementById('direccion').value,
                    telefono: document.getElementById('telefono').value
                };

                const changes = [];
                
                if (currentValues.nombre !== originalValues.nombre) {
                    changes.push({
                        field: 'Nombre',
                        from: originalValues.nombre,
                        to: currentValues.nombre
                    });
                }
                
                if (currentValues.direccion !== originalValues.direccion) {
                    changes.push({
                        field: 'Dirección',
                        from: originalValues.direccion,
                        to: currentValues.direccion
                    });
                }
                
                if (currentValues.telefono !== originalValues.telefono) {
                    changes.push({
                        field: 'Teléfono',
                        from: originalValues.telefono,
                        to: currentValues.telefono
                    });
                }

                if (changes.length > 0) {
                    changesList.innerHTML = '';
                    changes.forEach(change => {
                        const changeItem = document.createElement('div');
                        changeItem.className = 'change-item';
                        changeItem.innerHTML = `
                            <span>📝</span>
                            <strong>${change.field}:</strong>
                            <span style="text-decoration: line-through; color: var(--danger-color);">${change.from}</span>
                            <span>→</span>
                            <span style="color: var(--success-color); font-weight: 600;">${change.to}</span>
                        `;
                        changesList.appendChild(changeItem);
                    });
                    changesContainer.style.display = 'block';
                    return true;
                } else {
                    changesContainer.style.display = 'none';
                    return false;
                }
            }

            function showLoading() {
                const originalText = submitBtn.innerHTML;
                submitBtn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Actualizando...';
                submitBtn.disabled = true;
                resetBtn.disabled = true;

                // Agregar animación de éxito después de guardar
                setTimeout(() => {
                    submitBtn.innerHTML = '✅ Actualizado Exitoso!';
                    submitBtn.classList.add('success-check');
                }, 1500);
            }

            function showValidationErrors() {
                const firstInvalid = form.querySelector('input:invalid');
                if (firstInvalid) {
                    firstInvalid.focus();
                    firstInvalid.classList.add('shake');
                    
                    setTimeout(() => {
                        firstInvalid.classList.remove('shake');
                    }, 500);
                }
            }

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
                    'Actualice la información de la sucursal - ' + now.toLocaleDateString('es-ES', options);
            }

            setInterval(updateTime, 1000);
            <%
                }
            %>
        });
    </script>
</body>
</html>