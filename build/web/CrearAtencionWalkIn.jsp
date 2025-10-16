<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nueva Atención Walk-in - Sistema Terán Vet</title>
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
            max-width: 1200px;
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
            font-size: 0.85em;
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

        /* Form Styles - Mejorados */
        .form-container {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            padding: 40px;
            margin-bottom: 30px;
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

        .form-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid rgba(0, 0, 0, 0.05);
        }

        .form-icon {
            font-size: 2.5em;
            color: var(--primary-color);
        }

        .form-header h2 {
            color: var(--text-dark);
            font-size: 1.8em;
            font-weight: 700;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 30px;
        }

        .form-group {
            margin-bottom: 25px;
            transition: all 0.3s ease;
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

        .form-group .required::after {
            content: " *";
            color: var(--danger-color);
            font-weight: bold;
        }

        .form-control {
            width: 100%;
            padding: 16px 20px;
            border: 2px solid #e0e0e0;
            border-radius: var(--radius);
            font-size: 1em;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            background-color: #fcfcfc;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.05);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(171, 203, 213, 0.3), inset 0 2px 4px rgba(0,0,0,0.05);
            background-color: var(--white);
            transform: translateY(-2px);
        }

        .form-control:disabled {
            background-color: #f5f5f5;
            color: #999;
            cursor: not-allowed;
        }

        textarea.form-control {
            min-height: 120px;
            resize: vertical;
            line-height: 1.5;
        }

        .form-hint {
            font-size: 0.85em;
            color: var(--text-light);
            margin-top: 8px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .form-row {
            display: flex;
            gap: 20px;
        }

        .form-row .form-group {
            flex: 1;
        }

        .form-actions {
            display: flex;
            gap: 20px;
            margin-top: 40px;
            padding-top: 25px;
            border-top: 2px solid rgba(0, 0, 0, 0.05);
            justify-content: flex-end;
        }

        /* Quick Actions - Mejorados */
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .action-card {
            background: var(--white);
            padding: 25px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            text-align: center;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            cursor: pointer;
            border-top: 4px solid var(--primary-color);
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out;
        }

        .action-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.6s;
        }

        .action-card:hover::before {
            left: 100%;
        }

        .action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }

        .action-icon {
            font-size: 3em;
            margin-bottom: 15px;
            display: block;
            transition: all 0.3s ease;
        }

        .action-card:hover .action-icon {
            transform: scale(1.1);
        }

        .action-title {
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 10px;
            font-size: 1.1em;
        }

        .action-desc {
            font-size: 0.9em;
            color: var(--text-light);
            line-height: 1.5;
        }

        /* Stats Card - Mejorado */
        .stats-card {
            background: var(--white);
            padding: 30px;
            border-radius: var(--radius);
            margin-bottom: 30px;
            box-shadow: var(--shadow);
            border-left: 4px solid var(--info-color);
            display: flex;
            align-items: center;
            gap: 20px;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out;
        }

        .stats-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-info);
        }

        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }

        .stats-icon {
            font-size: 2.5em;
            color: var(--info-color);
        }

        .stats-content h3 {
            color: var(--text-dark);
            margin-bottom: 10px;
            font-size: 1.4em;
            font-weight: 700;
        }

        .stats-content p {
            color: var(--text-light);
            font-size: 1em;
            line-height: 1.6;
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

        .floating {
            animation: floating 3s ease-in-out infinite;
        }

        @keyframes floating {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
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
            .form-grid {
                grid-template-columns: 1fr;
            }
            .form-row {
                flex-direction: column;
                gap: 0;
            }
            .form-actions {
                flex-direction: column;
            }
            .form-actions .btn {
                width: 100%;
                justify-content: center;
            }
            .quick-actions {
                grid-template-columns: 1fr;
            }
            .stats-card {
                flex-direction: column;
                text-align: center;
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
                padding: 25px;
            }
            .form-header {
                flex-direction: column;
                text-align: center;
                gap: 10px;
            }
        }

        /* Additional Styling */
        .id-badge {
            background: var(--primary-light);
            color: var(--text-dark);
            padding: 6px 12px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.9em;
            transition: all 0.3s ease;
        }

        .id-badge:hover {
            background: var(--primary-color);
            transform: scale(1.05);
        }

        .dni-badge {
            background: #e8f4f8;
            color: var(--text-dark);
            padding: 6px 12px;
            border-radius: 8px;
            font-family: 'Courier New', monospace;
            font-size: 0.9em;
            border: 1px solid var(--primary-light);
            transition: all 0.3s ease;
        }

        .no-data {
            color: var(--text-light);
            font-style: italic;
        }

        .contact-info {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--text-light);
            font-size: 0.9em;
        }

        .pets-count {
            background: #e8f4f8;
            color: var(--text-dark);
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: 600;
            margin-left: 5px;
            transition: all 0.3s ease;
        }

        /* Form Validation Styles - Mejorados */
        .is-invalid {
            border-color: var(--danger-color) !important;
            box-shadow: 0 0 0 3px rgba(244, 67, 54, 0.1) !important;
            background-color: #fdf2f2;
        }

        .invalid-feedback {
            color: var(--danger-color);
            font-size: 0.85em;
            margin-top: 8px;
            display: flex;
            align-items: center;
            gap: 6px;
            font-weight: 500;
        }

        .is-valid {
            border-color: var(--success-color) !important;
            box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.1) !important;
            background-color: #f0f9f4;
        }

        .valid-feedback {
            color: var(--success-color);
            font-size: 0.85em;
            margin-top: 8px;
            display: flex;
            align-items: center;
            gap: 6px;
            font-weight: 500;
        }

        /* Loading Animation - Mejorado */
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

        /* Priority Indicator */
        .priority-indicator {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: 8px;
        }

        .priority-bar {
            flex: 1;
            height: 6px;
            background: #e0e0e0;
            border-radius: 3px;
            overflow: hidden;
        }

        .priority-fill {
            height: 100%;
            background: var(--gradient-primary);
            border-radius: 3px;
            transition: all 0.3s ease;
        }

        .priority-value {
            font-size: 0.85em;
            font-weight: 600;
            color: var(--text-dark);
            min-width: 30px;
            text-align: center;
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
                <li class="menu-item active">
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
                        <h1>➕ Nueva Atención Walk-in</h1>
                        <p>Registro de atención inmediata sin cita previa - <%= new java.text.SimpleDateFormat("EEEE, d 'de' MMMM 'de' yyyy").format(new java.util.Date()) %></p>
                    </div>
                    <div class="header-actions">
                        <a href="AtencionControlador" class="btn btn-secondary">↶ Volver a la Cola</a>
                    </div>
                </div>
            </div>

            <div class="main-content">
                <!-- Mostrar mensajes -->
                <% if (request.getAttribute("mensaje") != null) { %>
                    <div class="mensaje <%= request.getAttribute("mensaje").toString().contains("✅") ? "exito" : "error" %>">
                        <%= request.getAttribute("mensaje") %>
                    </div>
                <% } %>

                <!-- Quick Actions -->
                <div class="quick-actions">
                    <div class="action-card" onclick="document.getElementById('idMascota').focus()">
                        <span class="action-icon">🐕</span>
                        <div class="action-title">Buscar Mascota</div>
                        <div class="action-desc">Ingresar ID de mascota existente</div>
                    </div>
                    <div class="action-card" onclick="document.getElementById('idCliente').focus()">
                        <span class="action-icon">👤</span>
                        <div class="action-title">Buscar Cliente</div>
                        <div class="action-desc">Ingresar ID de cliente registrado</div>
                    </div>
                    <div class="action-card" onclick="document.getElementById('idGroomer').focus()">
                        <span class="action-icon">✂️</span>
                        <div class="action-title">Asignar Groomer</div>
                        <div class="action-desc">Seleccionar especialista disponible</div>
                    </div>
                    <div class="action-card" onclick="document.getElementById('prioridad').focus()">
                        <span class="action-icon">🚨</span>
                        <div class="action-title">Definir Prioridad</div>
                        <div class="action-desc">Establecer nivel de urgencia</div>
                    </div>
                </div>

                <!-- Form Container -->
                <div class="form-container">
                    <div class="form-header">
                        <span class="form-icon">📋</span>
                        <h2>Formulario de Atención Inmediata</h2>
                    </div>

                    <form action="AtencionControlador" method="POST" id="atencionForm">
                        <div class="form-grid">
                            <!-- Columna 1: Información Principal -->
                            <div>
                                <div class="form-group">
                                    <label for="idMascota" class="required">
                                        <span>🐕 ID Mascota</span>
                                    </label>
                                    <input type="number" id="idMascota" name="idMascota" class="form-control" required 
                                           placeholder="Ingrese ID de la mascota" min="1">
                                    <span class="form-hint">🔍 Número de identificación único de la mascota</span>
                                </div>

                                <div class="form-group">
                                    <label for="idCliente" class="required">
                                        <span>👤 ID Cliente</span>
                                    </label>
                                    <input type="number" id="idCliente" name="idCliente" class="form-control" required 
                                           placeholder="Ingrese ID del cliente" min="1">
                                    <span class="form-hint">🔍 Número de identificación del dueño de la mascota</span>
                                </div>

                                <div class="form-group">
                                    <label for="idGroomer" class="required">
                                        <span>✂️ ID Groomer</span>
                                    </label>
                                    <input type="number" id="idGroomer" name="idGroomer" class="form-control" required 
                                           placeholder="Ingrese ID del groomer" min="1">
                                    <span class="form-hint">👨‍💼 Especialista que realizará la atención</span>
                                </div>

                                <div class="form-group">
                                    <label for="idSucursal">
                                        <span>🏢 ID Sucursal</span>
                                    </label>
                                    <input type="number" id="idSucursal" name="idSucursal" class="form-control"
                                           placeholder="Opcional - ID de la sucursal" min="1">
                                    <span class="form-hint">📍 Dejar en blanco para sucursal principal</span>
                                </div>
                            </div>

                            <!-- Columna 2: Información de Tiempo y Prioridad -->
                            <div>
                                <div class="form-group">
                                    <label for="turnoNum">
                                        <span>🎫 Número de Turno</span>
                                    </label>
                                    <input type="number" id="turnoNum" name="turnoNum" class="form-control"
                                           placeholder="Opcional - Número de turno" min="1">
                                    <span class="form-hint">🔢 Asignar número de turno manualmente</span>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="tiempoEstimadoInicio">
                                            <span>⏰ Tiempo Estimado Inicio</span>
                                        </label>
                                        <input type="datetime-local" id="tiempoEstimadoInicio" name="tiempoEstimadoInicio" class="form-control">
                                        <span class="form-hint">🕒 Hora prevista de inicio</span>
                                    </div>

                                    <div class="form-group">
                                        <label for="tiempoEstimadoFin">
                                            <span>⏱️ Tiempo Estimado Fin</span>
                                        </label>
                                        <input type="datetime-local" id="tiempoEstimadoFin" name="tiempoEstimadoFin" class="form-control">
                                        <span class="form-hint">🕓 Hora prevista de finalización</span>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="prioridad">
                                        <span>🚨 Prioridad (1-10)</span>
                                    </label>
                                    <input type="number" id="prioridad" name="prioridad" class="form-control" min="1" max="10" 
                                           placeholder="1 = baja, 10 = alta" value="5">
                                    <div class="priority-indicator">
                                        <div class="priority-bar">
                                            <div class="priority-fill" id="priorityFill" style="width: 50%;"></div>
                                        </div>
                                        <div class="priority-value" id="priorityValue">5</div>
                                    </div>
                                    <span class="form-hint">📊 1 = Baja prioridad, 10 = Máxima urgencia</span>
                                </div>

                                <div class="form-group">
                                    <label for="observaciones">
                                        <span>📝 Observaciones</span>
                                    </label>
                                    <textarea id="observaciones" name="observaciones" class="form-control"
                                             placeholder="Observaciones adicionales sobre la atención..."></textarea>
                                    <span class="form-hint">💡 Detalles específicos sobre la mascota o el servicio requerido</span>
                                </div>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="button" class="btn btn-secondary" onclick="window.location.href='AtencionControlador'">
                                ❌ Cancelar
                            </button>
                            <button type="reset" class="btn btn-secondary">
                                🗑️ Limpiar Formulario
                            </button>
                            <button type="submit" name="acc" value="Confirmar" class="btn btn-success" id="submitBtn">
                                ✅ Crear Atención
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Información Adicional -->
                <div class="stats-card floating">
                    <div class="stats-icon">💡</div>
                    <div class="stats-content">
                        <h3>Información sobre Atenciones Walk-in</h3>
                        <p>Las atenciones walk-in son servicios que se prestan sin cita previa. Se recomienda verificar la disponibilidad de groomers antes de registrar la atención. Las atenciones de alta prioridad (8-10) serán atendidas primero.</p>
                    </div>
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

            // Validación del formulario
            const form = document.getElementById('atencionForm');
            const submitBtn = document.getElementById('submitBtn');
            
            form.addEventListener('submit', function(e) {
                let isValid = true;
                
                // Validar campos requeridos
                const requiredFields = form.querySelectorAll('[required]');
                requiredFields.forEach(field => {
                    if (!field.value.trim()) {
                        field.classList.add('is-invalid');
                        isValid = false;
                    } else {
                        field.classList.remove('is-invalid');
                        field.classList.add('is-valid');
                    }
                });
                
                // Validar prioridad
                const prioridad = document.getElementById('prioridad');
                if (prioridad.value < 1 || prioridad.value > 10) {
                    prioridad.classList.add('is-invalid');
                    isValid = false;
                } else {
                    prioridad.classList.remove('is-invalid');
                    prioridad.classList.add('is-valid');
                }
                
                if (!isValid) {
                    e.preventDefault();
                    alert('⚠️ Por favor, complete todos los campos requeridos correctamente.');
                    return false;
                }
                
                // Mostrar loading
                submitBtn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Procesando...';
                submitBtn.disabled = true;
                
                return true;
            });

            // Auto-calcular tiempo de finalización
            const tiempoInicio = document.getElementById('tiempoEstimadoInicio');
            const tiempoFin = document.getElementById('tiempoEstimadoFin');
            
            tiempoInicio.addEventListener('change', function() {
                if (this.value && !tiempoFin.value) {
                    const inicio = new Date(this.value);
                    const fin = new Date(inicio.getTime() + 60 * 60 * 1000); // +1 hora
                    tiempoFin.value = fin.toISOString().slice(0, 16);
                }
            });

            // Gestión de prioridad con barra visual
            const prioridadInput = document.getElementById('prioridad');
            const priorityFill = document.getElementById('priorityFill');
            const priorityValue = document.getElementById('priorityValue');
            
            prioridadInput.addEventListener('input', function() {
                const value = this.value;
                const percentage = (value / 10) * 100;
                priorityFill.style.width = percentage + '%';
                priorityValue.textContent = value;
                
                // Cambiar color según la prioridad
                if (value >= 8) {
                    priorityFill.style.background = 'var(--gradient-danger)';
                } else if (value >= 5) {
                    priorityFill.style.background = 'var(--gradient-warning)';
                } else {
                    priorityFill.style.background = 'var(--gradient-primary)';
                }
            });

            // Focus management for quick actions
            const quickActionCards = document.querySelectorAll('.action-card');
            quickActionCards.forEach(card => {
                card.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter' || e.key === ' ') {
                        card.click();
                    }
                });
                
                // Mejorar accesibilidad
                card.setAttribute('tabindex', '0');
                card.setAttribute('role', 'button');
                
                // Efectos hover mejorados
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-5px)';
                });
                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                });
            });

            // Set current datetime as default for tiempoEstimadoInicio
            const now = new Date();
            const localDateTime = new Date(now.getTime() - now.getTimezoneOffset() * 60000).toISOString().slice(0, 16);
            if (!tiempoInicio.value) {
                tiempoInicio.value = localDateTime;
            }

            // Auto-increment turnoNum
            const turnoNum = document.getElementById('turnoNum');
            if (!turnoNum.value) {
                // En un sistema real, esto vendría de la base de datos
                turnoNum.value = Math.floor(Math.random() * 50) + 1;
            }

            // Animaciones de entrada para elementos
            const animatedElements = document.querySelectorAll('.quick-actions, .form-container, .stats-card');
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
                    this.style.transform = 'translateY(-3px)';
                });
                button.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                });
            });

            // Efectos de focus en campos de formulario
            const formControls = form.querySelectorAll('.form-control');
            formControls.forEach(control => {
                control.addEventListener('focus', function() {
                    this.parentElement.style.transform = 'translateY(-2px)';
                });
                control.addEventListener('blur', function() {
                    this.parentElement.style.transform = 'translateY(0)';
                });
            });
        });

        // Función para buscar cliente (simulación)
        function buscarCliente(idCliente) {
            if (idCliente) {
                // En un sistema real, aquí se haría una petición AJAX
                console.log(`Buscando cliente con ID: ${idCliente}`);
                // Simular búsqueda exitosa
                return true;
            }
            return false;
        }

        // Función para buscar mascota (simulación)
        function buscarMascota(idMascota) {
            if (idMascota) {
                // En un sistema real, aquí se haría una petición AJAX
                console.log(`Buscando mascota con ID: ${idMascota}`);
                // Simular búsqueda exitosa
                return true;
            }
            return false;
        }

        // Validación en tiempo real
        document.getElementById('idCliente').addEventListener('blur', function() {
            if (this.value && !buscarCliente(this.value)) {
                this.classList.add('is-invalid');
                alert('❌ Cliente no encontrado. Verifique el ID.');
            } else if (this.value) {
                this.classList.remove('is-invalid');
                this.classList.add('is-valid');
            }
        });

        document.getElementById('idMascota').addEventListener('blur', function() {
            if (this.value && !buscarMascota(this.value)) {
                this.classList.add('is-invalid');
                alert('❌ Mascota no encontrada. Verifique el ID.');
            } else if (this.value) {
                this.classList.remove('is-invalid');
                this.classList.add('is-valid');
            }
        });

        // Función para confirmar antes de limpiar el formulario
        document.querySelector('button[type="reset"]').addEventListener('click', function(e) {
            if (!confirm('¿Está seguro de que desea limpiar todos los campos del formulario?')) {
                e.preventDefault();
            }
        });

        // Función para simular búsqueda con efecto visual
        function simularBusqueda(campoId, tipo) {
            const campo = document.getElementById(campoId);
            if (campo.value) {
                const originalBorder = campo.style.borderColor;
                campo.style.borderColor = 'var(--warning-color)';
                campo.disabled = true;
                
                setTimeout(() => {
                    campo.style.borderColor = originalBorder;
                    campo.disabled = false;
                    campo.classList.add('is-valid');
                    alert(`✅ ${tipo} encontrado con ID: ${campo.value}`);
                }, 1000);
            }
        }

        // Agregar botones de búsqueda rápida
        document.addEventListener('DOMContentLoaded', function() {
            const idMascotaGroup = document.getElementById('idMascota').parentElement;
            const buscarMascotaBtn = document.createElement('button');
            buscarMascotaBtn.type = 'button';
            buscarMascotaBtn.className = 'btn btn-info btn-small';
            buscarMascotaBtn.style.marginTop = '8px';
            buscarMascotaBtn.innerHTML = '🔍 Buscar Mascota';
            buscarMascotaBtn.onclick = () => simularBusqueda('idMascota', 'Mascota');
            idMascotaGroup.appendChild(buscarMascotaBtn);

            const idClienteGroup = document.getElementById('idCliente').parentElement;
            const buscarClienteBtn = document.createElement('button');
            buscarClienteBtn.type = 'button';
            buscarClienteBtn.className = 'btn btn-info btn-small';
            buscarClienteBtn.style.marginTop = '8px';
            buscarClienteBtn.innerHTML = '🔍 Buscar Cliente';
            buscarClienteBtn.onclick = () => simularBusqueda('idCliente', 'Cliente');
            idClienteGroup.appendChild(buscarClienteBtn);
        });
    </script>
</body>
</html>