<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reprogramar Cita - Sistema PetCare</title>
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

        /* Sidebar Styles - Coherente con Dashboard */
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

        /* Botones - Coherentes con Dashboard */
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

        .btn-full {
            width: 100%;
            justify-content: center;
        }

        /* Form Container Mejorado */
        .form-container {
            background: var(--white);
            padding: 40px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
            border-top: 4px solid var(--warning-color);
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.8s ease-out;
        }

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

        .form-header {
            text-align: center;
            margin-bottom: 40px;
            padding-bottom: 25px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.08);
        }

        .form-icon {
            font-size: 4em;
            margin-bottom: 20px;
            display: block;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
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

        /* Form Styles Mejorados */
        .form-group {
            margin-bottom: 30px;
        }

        .form-group label {
            display: block;
            margin-bottom: 12px;
            font-weight: 600;
            color: var(--text-dark);
            font-size: 1.1em;
        }

        .form-control {
            width: 100%;
            padding: 16px 20px;
            border: 2px solid #e0e0e0;
            border-radius: var(--radius);
            font-size: 1em;
            transition: all 0.3s ease;
            background-color: #f9f9f9;
            font-family: inherit;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
            background-color: var(--white);
            box-shadow: 0 0 0 4px rgba(171, 203, 213, 0.2);
            transform: translateY(-2px);
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 25px;
        }

        .form-help {
            font-size: 0.9em;
            color: var(--text-light);
            margin-top: 8px;
            font-style: italic;
            transition: color 0.3s ease;
        }

        .required::after {
            content: " *";
            color: var(--danger-color);
        }

        /* Section Styles Mejorados */
        .form-section {
            background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
            padding: 25px;
            border-radius: var(--radius);
            margin-bottom: 30px;
            border-left: 4px solid var(--warning-color);
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
        }

        .form-section:hover {
            transform: translateX(5px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
        }

        .section-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
            color: var(--text-dark);
        }

        .section-icon {
            font-size: 1.5em;
            color: var(--warning-color);
        }

        .section-title {
            font-size: 1.3em;
            font-weight: 700;
        }

        /* Información de Cita Actual */
        .current-appointment {
            background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
            padding: 25px;
            border-radius: var(--radius);
            margin-bottom: 30px;
            border-left: 4px solid var(--warning-color);
            box-shadow: var(--shadow);
        }

        .appointment-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
        }

        .appointment-icon {
            font-size: 2em;
            color: var(--warning-color);
        }

        .appointment-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }

        .detail-item {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .detail-label {
            font-weight: 600;
            color: var(--text-dark);
            font-size: 0.9em;
        }

        .detail-value {
            color: var(--text-light);
            font-size: 1.1em;
            font-weight: 500;
        }

        /* Disponibilidad Section */
        .availability-section {
            background: linear-gradient(135deg, #e8f4f8 0%, #d4eaf0 100%);
            padding: 25px;
            border-radius: var(--radius);
            margin-bottom: 30px;
            border-left: 4px solid var(--info-color);
        }

        .availability-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
        }

        .availability-icon {
            font-size: 2em;
            color: var(--info-color);
        }

        .availability-slots {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }

        .time-slot {
            background: var(--white);
            padding: 15px;
            border-radius: var(--radius);
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }

        .time-slot:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }

        .time-slot.available {
            border-color: var(--success-color);
            background: linear-gradient(135deg, #f0f9f4 0%, #e8f5e8 100%);
        }

        .time-slot.unavailable {
            border-color: var(--danger-color);
            background: linear-gradient(135deg, #fdf2f2 0%, #fde8e8 100%);
            opacity: 0.6;
            cursor: not-allowed;
        }

        .time-slot.selected {
            border-color: var(--primary-color);
            background: var(--gradient-primary);
            color: var(--white);
        }

        .slot-time {
            font-weight: 600;
            font-size: 1.1em;
        }

        .slot-status {
            font-size: 0.8em;
            margin-top: 5px;
        }

        /* Form Actions Mejorados */
        .form-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid rgba(0, 0, 0, 0.08);
        }

        .form-actions .btn {
            width: 100%;
            justify-content: center;
        }

        /* Navigation Mejorado */
        .navigation {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin: 40px 0;
        }

        .navigation .btn {
            width: 100%;
            justify-content: center;
            padding: 20px;
            font-size: 1em;
        }

        /* Mensajes de estado mejorados */
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

        .info {
            background: linear-gradient(135deg, #f0f7ff 0%, #e6f3ff 100%);
            border-left-color: var(--info-color);
            color: var(--text-dark);
        }

        .warning {
            background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
            border-left-color: var(--warning-color);
            color: #856404;
        }

        /* Responsive Design - Coherente con Dashboard */
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
                grid-template-columns: 1fr;
            }
            .appointment-details {
                grid-template-columns: 1fr;
            }
            .availability-slots {
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
            .form-container {
                padding: 20px;
            }
            .form-header h2 {
                font-size: 1.8em;
            }
            .availability-slots {
                grid-template-columns: 1fr;
            }
            .btn {
                width: 100%;
                justify-content: center;
            }
        }

        /* Efectos especiales adicionales */
        .floating {
            animation: floating 3s ease-in-out infinite;
        }

        @keyframes floating {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
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

        /* Badges informativos */
        .info-badge {
            background: var(--info-color);
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: 600;
            margin-left: 8px;
        }

        .warning-badge {
            background: var(--warning-color);
            color: var(--text-dark);
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: 600;
            margin-left: 8px;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Sidebar Menu - Coherente con Dashboard -->
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
                    <a href="configuracion.jsp">
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
                        <h1>🔄 Reprogramar Cita</h1>
                        <p>Reagendar cita existente - Gestión de cambios en el calendario</p>
                    </div>
                    <div class="header-actions">
                        <a href="CitaControlador?accion=todasCitas" class="btn btn-secondary">
                            <span>← Volver a Citas</span>
                        </a>
                        <a href="dashboard.jsp" class="btn btn-primary">
                            <span>📊 Ir al Dashboard</span>
                        </a>
                    </div>
                </div>
            </div>

            <div class="main-content">
                <!-- Mensajes -->
                <% 
                    String mensaje = (String) request.getAttribute("mensaje");
                    String idCita = request.getParameter("idCita");
                    if (idCita == null) idCita = "";
                    
                    // Simular datos de cita actual (en un caso real, estos vendrían del controlador)
                    String clienteNombre = "María González";
                    String mascotaNombre = "Max";
                    String servicio = "Baño completo y corte";
                    String fechaOriginal = "2024-01-15 10:00";
                    String groomerAsignado = "Ana López";
                %>

                <% if (mensaje != null) { %>
                    <div class="mensaje <%= mensaje.contains("✅") ? "exito" : mensaje.contains("❌") ? "error" : mensaje.contains("⚠️") ? "warning" : "info" %>">
                        <%= mensaje %>
                    </div>
                <% } %>

                <!-- Información de la Cita Actual -->
                <div class="current-appointment">
                    <div class="appointment-header">
                        <span class="appointment-icon">📅</span>
                        <div>
                            <h3 style="color: var(--text-dark); margin: 0;">Cita Actual</h3>
                            <p style="color: var(--text-light); margin: 5px 0 0 0;">Información de la cita que será reprogramada</p>
                        </div>
                    </div>
                    <div class="appointment-details">
                        <div class="detail-item">
                            <span class="detail-label">👤 Cliente</span>
                            <span class="detail-value"><%= clienteNombre %></span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">🐾 Mascota</span>
                            <span class="detail-value"><%= mascotaNombre %></span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">🛠️ Servicio</span>
                            <span class="detail-value"><%= servicio %></span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">✂️ Groomer</span>
                            <span class="detail-value"><%= groomerAsignado %></span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">📅 Fecha Original</span>
                            <span class="detail-value" style="color: var(--warning-color); font-weight: 600;">
                                <%= fechaOriginal %>
                            </span>
                        </div>
                    </div>
                </div>

                <div class="form-container">
                    <div class="form-header">
                        <span class="form-icon floating">🔄</span>
                        <h2>Seleccionar Nueva Fecha y Hora</h2>
                        <p>Elija la nueva programación para la cita. Se verificará la disponibilidad automáticamente.</p>
                    </div>

                    <form action="CitaControlador" method="POST" id="rescheduleForm">
                        <input type="hidden" name="accion" value="reprogramar">
                        
                        <!-- Información Básica -->
                        <div class="form-section">
                            <div class="section-header">
                                <span class="section-icon">📋</span>
                                <span class="section-title">Información de la Cita</span>
                            </div>
                            
                            <div class="form-group">
                                <label for="idCita" class="required">ID de la Cita:</label>
                                <input type="number" id="idCita" name="idCita" class="form-control" 
                                       value="<%= idCita %>" required
                                       placeholder="Ingrese el ID de la cita a reprogramar"
                                       oninput="validarIdCita(this)">
                                <div class="form-help">Número único de identificación de la cita en el sistema</div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="nuevaFecha" class="required">Nueva Fecha:</label>
                                    <input type="date" id="nuevaFecha" name="nuevaFecha" class="form-control" required
                                           onchange="cargarHorariosDisponibles()">
                                    <div class="form-help">Seleccione la nueva fecha para la cita</div>
                                </div>
                                
                                <div class="form-group">
                                    <label for="nuevaHora" class="required">Nueva Hora:</label>
                                    <select id="nuevaHora" name="nuevaHora" class="form-control" required disabled>
                                        <option value="">Primero seleccione una fecha</option>
                                    </select>
                                    <div class="form-help">Horarios disponibles para la fecha seleccionada</div>
                                </div>
                            </div>
                        </div>

                        <!-- Motivo de Reprogramación -->
                        <div class="form-section">
                            <div class="section-header">
                                <span class="section-icon">📝</span>
                                <span class="section-title">Motivo del Cambio</span>
                            </div>
                            
                            <div class="form-group">
                                <label for="motivo">Razón de la Reprogramación:</label>
                                <select id="motivo" name="motivo" class="form-control">
                                    <option value="">Seleccione un motivo (opcional)</option>
                                    <option value="cliente_solicito">Cliente solicitó cambio</option>
                                    <option value="groomer_no_disponible">Groomer no disponible</option>
                                    <option value="emergencia_clinica">Emergencia en la clínica</option>
                                    <option value="problema_mascota">Problema de salud de la mascota</option>
                                    <option value="otro">Otro motivo</option>
                                </select>
                                <div class="form-help">Ayuda a mantener un registro de los motivos de reprogramación</div>
                            </div>

                            <div class="form-group">
                                <label for="observaciones">Observaciones Adicionales:</label>
                                <textarea id="observaciones" name="observaciones" class="form-control" 
                                          rows="3" placeholder="Agregue cualquier observación adicional sobre el cambio..."
                                          oninput="contarCaracteres(this)"></textarea>
                                <div class="form-help">
                                    <span id="contadorCaracteres">0</span>/500 caracteres
                                </div>
                            </div>
                        </div>

                        <!-- Disponibilidad de Groomers -->
                        <div class="availability-section">
                            <div class="availability-header">
                                <span class="availability-icon">👥</span>
                                <div>
                                    <h3 style="color: var(--text-dark); margin: 0;">Disponibilidad de Groomers</h3>
                                    <p style="color: var(--text-light); margin: 5px 0 0 0;">Groomers disponibles para la nueva fecha</p>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="groomerAsignado">Groomer Asignado:</label>
                                <select id="groomerAsignado" name="groomerAsignado" class="form-control" disabled>
                                    <option value="">Seleccione fecha primero</option>
                                </select>
                                <div class="form-help">Puede cambiar el groomer asignado si es necesario</div>
                            </div>

                            <div id="availabilitySlots" style="display: none;">
                                <h4 style="margin-bottom: 15px; color: var(--text-dark);">Horarios Disponibles</h4>
                                <div class="availability-slots" id="timeSlotsContainer">
                                    <!-- Los horarios se cargarán dinámicamente -->
                                </div>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-success" onclick="return validarReprogramacion()">
                                <span>✅ Confirmar Reprogramación</span>
                            </button>
                            <button type="button" class="btn btn-warning" onclick="sugerirProximaDisponibilidad()">
                                <span>🔍 Sugerir Próxima Disponibilidad</span>
                            </button>
                            <button type="button" class="btn btn-secondary" onclick="limpiarFormulario()">
                                <span>🔄 Limpiar Formulario</span>
                            </button>
                            <a href="CitaControlador?accion=todasCitas" class="btn btn-danger">
                                <span>❌ Cancelar</span>
                            </a>
                        </div>
                    </form>
                </div>

                <!-- Información adicional -->
                <div class="info" style="margin-top: 20px;">
                    <strong>💡 Información importante sobre reprogramación:</strong><br>
                    • El cliente será notificado automáticamente del cambio<br>
                    • Se verificará la disponibilidad del groomer seleccionado<br>
                    • Los horarios en rojo indican que no hay disponibilidad<br>
                    • Puede cambiar el groomer si el original no está disponible<br>
                    • Se mantendrá un historial de todos los cambios realizados
                </div>

                <!-- Navegación mejorada -->
                <div class="navigation">
                    <a href="CitaControlador?accion=todasCitas" class="btn btn-secondary">
                        <span>← Volver a Citas</span>
                    </a>
                    <a href="CitaControlador?accion=formularioInsertar" class="btn btn-primary">
                        <span>➕ Crear Nueva Cita</span>
                    </a>
                    <a href="dashboard.jsp" class="btn btn-info">
                        <span>📊 Dashboard Principal</span>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Script mejorado para manejar la reprogramación
        document.addEventListener('DOMContentLoaded', function() {
            const menuItems = document.querySelectorAll('.menu-item');
            
            menuItems.forEach(item => {
                item.addEventListener('click', function() {
                    menuItems.forEach(i => i.classList.remove('active'));
                    this.classList.add('active');
                });
            });

            // Establecer fecha mínima como hoy
            const fechaInput = document.getElementById('nuevaFecha');
            const hoy = new Date();
            const fechaMinima = hoy.toISOString().split('T')[0];
            fechaInput.min = fechaMinima;

            // Si hay un ID de cita en la URL, cargarlo automáticamente
            const urlParams = new URLSearchParams(window.location.search);
            const idCitaParam = urlParams.get('idCita');
            if (idCitaParam) {
                document.getElementById('idCita').value = idCitaParam;
                validarIdCita(document.getElementById('idCita'));
            }

            // Inicializar contador de caracteres
            contarCaracteres(document.getElementById('observaciones'));

            // Efectos de aparición para secciones
            const sections = document.querySelectorAll('.form-section, .current-appointment, .availability-section');
            sections.forEach((section, index) => {
                section.style.opacity = '0';
                section.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    section.style.transition = 'all 0.6s cubic-bezier(0.4, 0, 0.2, 1)';
                    section.style.opacity = '1';
                    section.style.transform = 'translateY(0)';
                }, index * 200);
            });
        });

        // Función para validar ID de cita
        function validarIdCita(input) {
            const valor = input.value.trim();
            const ayuda = input.parentElement.querySelector('.form-help');
            
            if (valor && (isNaN(valor) || valor < 1)) {
                ayuda.style.color = 'var(--danger-color)';
                ayuda.textContent = '❌ El ID de cita debe ser un número válido mayor a 0';
                input.style.borderColor = 'var(--danger-color)';
                return false;
            } else if (valor) {
                ayuda.style.color = 'var(--success-color)';
                ayuda.textContent = '✅ ID de cita válido';
                input.style.borderColor = 'var(--success-color)';
                return true;
            } else {
                ayuda.style.color = 'var(--text-light)';
                ayuda.textContent = 'Número único de identificación de la cita en el sistema';
                input.style.borderColor = '#e0e0e0';
                return false;
            }
        }

        // Función para cargar horarios disponibles
        function cargarHorariosDisponibles() {
            const fechaInput = document.getElementById('nuevaFecha');
            const horaSelect = document.getElementById('nuevaHora');
            const groomerSelect = document.getElementById('groomerAsignado');
            const availabilitySlots = document.getElementById('availabilitySlots');
            
            if (!fechaInput.value) {
                horaSelect.disabled = true;
                groomerSelect.disabled = true;
                availabilitySlots.style.display = 'none';
                return;
            }

            // Simular carga de datos
            mostrarLoading(horaSelect);
            mostrarLoading(groomerSelect);

            setTimeout(() => {
                // Simular horarios disponibles
                const horarios = [
                    '08:00', '09:00', '10:00', '11:00', 
                    '14:00', '15:00', '16:00', '17:00'
                ];

                // Simular groomers disponibles
                const groomers = [
                    { id: 1, nombre: 'Ana López', especialidad: 'Corte y baño' },
                    { id: 2, nombre: 'Carlos Ruiz', especialidad: 'Estilizado' },
                    { id: 3, nombre: 'María García', especialidad: 'Razas pequeñas' }
                ];

                // Actualizar select de horas
                horaSelect.innerHTML = '<option value="">Seleccione una hora</option>';
                horarios.forEach(hora => {
                    const option = document.createElement('option');
                    option.value = hora;
                    option.textContent = hora;
                    horaSelect.appendChild(option);
                });
                horaSelect.disabled = false;

                // Actualizar select de groomers
                groomerSelect.innerHTML = '<option value="">Seleccione un groomer</option>';
                groomers.forEach(groomer => {
                    const option = document.createElement('option');
                    option.value = groomer.id;
                    option.textContent = `${groomer.nombre} - ${groomer.especialidad}`;
                    groomerSelect.appendChild(option);
                });
                groomerSelect.disabled = false;

                // Mostrar slots de disponibilidad
                mostrarSlotsDisponibilidad(horarios);
                availabilitySlots.style.display = 'block';

            }, 1500);
        }

        // Función para mostrar slots de disponibilidad
        function mostrarSlotsDisponibilidad(horarios) {
            const container = document.getElementById('timeSlotsContainer');
            container.innerHTML = '';

            horarios.forEach((hora, index) => {
                const slot = document.createElement('div');
                const disponible = index % 3 !== 0; // Simular algunos no disponibles
                
                slot.className = `time-slot ${disponible ? 'available' : 'unavailable'}`;
                slot.innerHTML = `
                    <div class="slot-time">${hora}</div>
                    <div class="slot-status">${disponible ? '✅ Disponible' : '❌ Ocupado'}</div>
                `;

                if (disponible) {
                    slot.addEventListener('click', function() {
                        // Remover selección anterior
                        document.querySelectorAll('.time-slot.selected').forEach(s => {
                            s.classList.remove('selected');
                        });
                        
                        // Seleccionar este slot
                        this.classList.add('selected');
                        document.getElementById('nuevaHora').value = hora;
                    });
                }

                container.appendChild(slot);
            });
        }

        // Función para mostrar loading
        function mostrarLoading(element) {
            const originalHTML = element.innerHTML;
            element.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Cargando...';
            element.disabled = true;

            setTimeout(() => {
                element.innerHTML = originalHTML;
                element.disabled = false;
            }, 1500);
        }

        // Función para contar caracteres
        function contarCaracteres(textarea) {
            const valor = textarea.value;
            const contador = document.getElementById('contadorCaracteres');
            contador.textContent = valor.length;

            if (valor.length > 450) {
                contador.style.color = 'var(--warning-color)';
                contador.style.fontWeight = '600';
            } else if (valor.length > 500) {
                contador.style.color = 'var(--danger-color)';
                contador.style.fontWeight = '600';
            } else {
                contador.style.color = 'var(--text-light)';
                contador.style.fontWeight = 'normal';
            }
        }

        // Función para validar la reprogramación completa
        function validarReprogramacion() {
            const idCita = document.getElementById('idCita').value;
            const nuevaFecha = document.getElementById('nuevaFecha').value;
            const nuevaHora = document.getElementById('nuevaHora').value;
            const groomerAsignado = document.getElementById('groomerAsignado').value;

            // Validar ID de cita
            if (!validarIdCita(document.getElementById('idCita'))) {
                alert('⚠️ Por favor, ingrese un ID de cita válido.');
                document.getElementById('idCita').focus();
                return false;
            }

            // Validar fecha y hora
            if (!nuevaFecha || !nuevaHora) {
                alert('⚠️ Por favor, seleccione una fecha y hora válidas.');
                return false;
            }

            const fechaSeleccionada = new Date(nuevaFecha + 'T' + nuevaHora);
            if (fechaSeleccionada < new Date()) {
                alert('❌ La fecha y hora seleccionadas no pueden ser anteriores a la fecha actual.');
                return false;
            }

            // Validar groomer
            if (!groomerAsignado) {
                alert('⚠️ Por favor, seleccione un groomer para la cita.');
                return false;
            }

            // Confirmación final
            const confirmar = confirm(`¿Está seguro de que desea reprogramar la cita?\n\n` +
                `📅 Nueva fecha: ${nuevaFecha} ${nuevaHora}\n` +
                `✂️ Groomer asignado: ${document.getElementById('groomerAsignado').options[document.getElementById('groomerAsignado').selectedIndex].text}\n` +
                `📝 ID de cita: ${idCita}\n\n` +
                `El cliente será notificado automáticamente del cambio.`);

            if (confirmar) {
                // Mostrar loading en el botón de enviar
                const submitBtn = document.querySelector('button[type="submit"]');
                const originalText = submitBtn.innerHTML;
                submitBtn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Reprogramando...';
                submitBtn.disabled = true;

                // Simular tiempo de procesamiento
                setTimeout(() => {
                    submitBtn.innerHTML = originalText;
                    submitBtn.disabled = false;
                }, 2000);

                return true;
            }

            return false;
        }

        // Función para sugerir próxima disponibilidad
        function sugerirProximaDisponibilidad() {
            const hoy = new Date();
            const proximosDias = [1, 2, 3]; // Días a verificar
            
            for (let dias of proximosDias) {
                const fecha = new Date(hoy);
                fecha.setDate(hoy.getDate() + dias);
                const fechaStr = fecha.toISOString().split('T')[0];
                
                // En una implementación real, aquí se verificaría la disponibilidad real
                const horariosDisponibles = ['10:00', '14:00', '16:00'];
                
                if (horariosDisponibles.length > 0) {
                    const confirmar = confirm(`¿Desea reprogramar para el ${fechaStr} a las ${horariosDisponibles[0]}?`);
                    if (confirmar) {
                        document.getElementById('nuevaFecha').value = fechaStr;
                        cargarHorariosDisponibles();
                        
                        // Esperar a que carguen los horarios y seleccionar el primero disponible
                        setTimeout(() => {
                            document.getElementById('nuevaHora').value = horariosDisponibles[0];
                        }, 1600);
                    }
                    break;
                }
            }
        }

        // Función para limpiar el formulario
        function limpiarFormulario() {
            if (confirm('¿Está seguro de que desea limpiar todos los campos del formulario?')) {
                document.getElementById('rescheduleForm').reset();
                document.getElementById('nuevaHora').disabled = true;
                document.getElementById('groomerAsignado').disabled = true;
                document.getElementById('availabilitySlots').style.display = 'none';
                contarCaracteres(document.getElementById('observaciones'));
                
                // Restablecer estilos
                const formControls = document.querySelectorAll('.form-control');
                formControls.forEach(control => {
                    control.style.borderColor = '#e0e0e0';
                });
                
                const formHelps = document.querySelectorAll('.form-help');
                formHelps.forEach(help => {
                    help.style.color = 'var(--text-light)';
                });
                
                alert('✅ Formulario limpiado correctamente.');
            }
        }

        // Función para ver disponibilidad de la semana
        function verDisponibilidadSemana() {
            alert('📅 Mostrando disponibilidad de la próxima semana...\nEsta función mostraría un calendario con los horarios disponibles.');
        }

        // Manejar tecla Enter en el formulario
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && e.target.tagName !== 'TEXTAREA' && e.target.type !== 'submit') {
                const form = e.target.form;
                if (form) {
                    e.preventDefault();
                    // Enfocar siguiente campo
                    const elements = Array.from(form.elements);
                    const currentIndex = elements.indexOf(e.target);
                    if (currentIndex < elements.length - 1) {
                        elements[currentIndex + 1].focus();
                    }
                }
            }
        });

        // Efectos hover mejorados para botones
        const buttons = document.querySelectorAll('.btn');
        buttons.forEach(button => {
            button.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-3px) scale(1.02)';
            });
            button.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
            });
        });
    </script>
</body>
</html>