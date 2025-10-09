<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, modelo.HistorialMascotaDTO"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historial de Mascota - Sistema PetCare</title>
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
            max-width: 1400px;
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

        .btn-accent {
            background: var(--gradient-accent);
            color: var(--white);
            box-shadow: 0 8px 25px rgba(213, 173, 196, 0.3);
        }

        .btn-accent:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(213, 173, 196, 0.4);
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

        .info {
            border-left-color: var(--info-color);
            background: linear-gradient(135deg, #f0f7ff 0%, #e3f2fd 100%);
            color: var(--text-dark);
        }

        /* Pet Info Card */
        .pet-card {
            background: var(--gradient-accent);
            padding: 30px;
            border-radius: var(--radius);
            margin-bottom: 30px;
            box-shadow: var(--shadow);
            color: var(--white);
            display: flex;
            align-items: center;
            gap: 25px;
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out;
        }

        .pet-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: rgba(255, 255, 255, 0.3);
        }

        .pet-icon {
            font-size: 3.5em;
            opacity: 0.9;
            animation: floating 3s ease-in-out infinite;
        }

        .pet-info h3 {
            font-size: 1.6em;
            margin-bottom: 8px;
            font-weight: 700;
        }

        .pet-info p {
            opacity: 0.9;
            font-size: 1.1em;
            font-weight: 500;
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        .stats-card {
            background: var(--white);
            padding: 30px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            border-left: 4px solid;
            display: flex;
            align-items: center;
            gap: 20px;
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out 0.2s both;
        }

        .stats-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
        }

        .stats-card.primary {
            border-left-color: var(--primary-color);
        }

        .stats-card.primary::before {
            background: var(--gradient-primary);
        }

        .stats-card.success {
            border-left-color: var(--success-color);
        }

        .stats-card.success::before {
            background: var(--gradient-success);
        }

        .stats-card.warning {
            border-left-color: var(--warning-color);
        }

        .stats-card.warning::before {
            background: var(--gradient-warning);
        }

        .stats-card.info {
            border-left-color: var(--info-color);
        }

        .stats-card.info::before {
            background: var(--gradient-info);
        }

        .stats-icon {
            font-size: 2.5em;
        }

        .stats-card.primary .stats-icon {
            color: var(--primary-color);
        }

        .stats-card.success .stats-icon {
            color: var(--success-color);
        }

        .stats-card.warning .stats-icon {
            color: var(--warning-color);
        }

        .stats-card.info .stats-icon {
            color: var(--info-color);
        }

        .stats-content h3 {
            color: var(--text-dark);
            margin-bottom: 8px;
            font-size: 1.3em;
            font-weight: 600;
        }

        .stats-content p {
            color: var(--text-light);
            font-size: 1em;
            line-height: 1.5;
        }

        .stats-value {
            font-size: 2em;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .stats-card.primary .stats-value {
            color: var(--primary-color);
        }

        .stats-card.success .stats-value {
            color: var(--success-color);
        }

        .stats-card.warning .stats-value {
            color: var(--warning-color);
        }

        .stats-card.info .stats-value {
            color: var(--info-color);
        }

        /* Table Container */
        .table-container {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 40px;
            position: relative;
            animation: fadeInUp 0.6s ease-out 0.4s both;
        }

        .table-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-primary);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: var(--gradient-primary);
            color: var(--white);
            font-weight: 600;
            padding: 20px 25px;
            text-align: left;
            border-bottom: 2px solid var(--primary-dark);
            position: sticky;
            top: 0;
            font-size: 1em;
            letter-spacing: 0.5px;
        }

        td {
            padding: 18px 25px;
            text-align: left;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            font-size: 0.95em;
        }

        tr:hover td {
            background-color: rgba(171, 203, 213, 0.05);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }

        /* Badges and Status */
        .id-badge {
            background: var(--primary-light);
            color: var(--text-dark);
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.85em;
            border: 1px solid var(--primary-color);
        }

        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.8em;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-completed {
            background: linear-gradient(135deg, #e8f5e8 0%, #d4edda 100%);
            color: var(--success-color);
            border: 1px solid #c3e6cb;
        }

        .status-progress {
            background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
            color: var(--warning-color);
            border: 1px solid #ffeaa7;
        }

        .money {
            color: var(--success-color);
            font-weight: 700;
            font-size: 1.05em;
        }

        .no-data {
            color: var(--text-light);
            font-style: italic;
            font-size: 0.9em;
        }

        .service-list {
            max-width: 250px;
            word-wrap: break-word;
            line-height: 1.4;
        }

        /* Navigation */
        .navigation {
            display: flex;
            gap: 20px;
            margin-top: 40px;
            justify-content: center;
            flex-wrap: wrap;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 80px 40px;
            color: var(--text-light);
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
            animation: fadeInUp 0.6s ease-out;
        }

        .empty-state h3 {
            font-size: 1.8em;
            margin-bottom: 20px;
            color: var(--text-dark);
            font-weight: 700;
        }

        .empty-state p {
            font-size: 1.1em;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .empty-icon {
            font-size: 4em;
            margin-bottom: 20px;
            display: block;
            opacity: 0.7;
        }

        /* Table Wrapper for Responsive */
        .table-wrapper {
            overflow-x: auto;
            border-radius: var(--radius);
        }

        /* Filter Controls */
        .filter-controls {
            background: var(--white);
            padding: 20px 25px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
            animation: fadeInUp 0.6s ease-out 0.3s both;
        }

        .filter-controls strong {
            color: var(--text-dark);
            font-size: 1.1em;
            font-weight: 600;
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

        @keyframes floating {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
        }

        .floating {
            animation: floating 3s ease-in-out infinite;
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
            .stats-grid {
                grid-template-columns: 1fr;
            }
            .table-container {
                overflow-x: auto;
            }
            table {
                min-width: 800px;
            }
            .navigation {
                flex-direction: column;
                align-items: center;
            }
            .btn {
                width: 100%;
                justify-content: center;
            }
            .pet-card {
                flex-direction: column;
                text-align: center;
                gap: 20px;
            }
            .stats-card {
                flex-direction: column;
                text-align: center;
                gap: 15px;
            }
            .filter-controls {
                flex-direction: column;
                align-items: stretch;
            }
        }

        @media (max-width: 480px) {
            .header {
                padding: 20px;
            }
            .main-content {
                padding: 15px;
            }
            .pet-card, .stats-card {
                padding: 25px;
            }
            .empty-state {
                padding: 60px 20px;
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
                <li class="menu-item">
                    <a href="ListaMascotas.jsp">
                        <span class="menu-icon">🐾</span>
                        <span>Mascotas</span>
                    </a>
                </li>
                <li class="menu-item active">
                    <a href="#">
                        <span class="menu-icon">📋</span>
                        <span>Historial Mascota</span>
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
                        <h1>📋 Historial de Atenciones</h1>
                        <p>Registro completo de servicios y atenciones de la mascota - <%= new java.text.SimpleDateFormat("EEEE, d 'de' MMMM 'de' yyyy").format(new java.util.Date()) %></p>
                    </div>
                    <div class="header-actions">
                        <a href="Clientes.jsp" class="btn btn-primary">👥 Ver Clientes</a>
                        <a href="ListaMascotas.jsp" class="btn btn-info">🐾 Ver Mascotas</a>
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

                <!-- Información de la Mascota -->
                <% 
                    Integer idMascota = (Integer) request.getAttribute("idMascota");
                    if (idMascota != null) { 
                %>
                <div class="pet-card">
                    <div class="pet-icon">🐕</div>
                    <div class="pet-info">
                        <h3>Mascota ID: <%= idMascota %></h3>
                        <p>Historial completo de servicios y atenciones recibidas</p>
                    </div>
                </div>
                <% } %>

                <!-- Estadísticas -->
                <% 
                    Integer totalAtenciones = (Integer) request.getAttribute("totalAtenciones");
                    List<HistorialMascotaDTO> historial = (List<HistorialMascotaDTO>) request.getAttribute("historial");
                    
                    // Calcular estadísticas adicionales
                    double totalFacturado = 0;
                    int atencionesCompletadas = 0;
                    int atencionesEnProgreso = 0;
                    
                    if (historial != null) {
                        for (HistorialMascotaDTO atencion : historial) {
                            totalFacturado += atencion.getMontoFacturado();
                            if (atencion.getTiempoRealFin() != null) {
                                atencionesCompletadas++;
                            } else {
                                atencionesEnProgreso++;
                            }
                        }
                    }
                %>

                <% if (totalAtenciones != null) { %>
                <div class="stats-grid">
                    <div class="stats-card primary">
                        <div class="stats-icon">📊</div>
                        <div class="stats-content">
                            <div class="stats-value"><%= totalAtenciones %></div>
                            <h3>Total de Atenciones</h3>
                            <p>Todas las visitas registradas</p>
                        </div>
                    </div>
                    
                    <div class="stats-card success">
                        <div class="stats-icon">💰</div>
                        <div class="stats-content">
                            <div class="stats-value">S/ <%= String.format("%.2f", totalFacturado) %></div>
                            <h3>Total Facturado</h3>
                            <p>Monto total de servicios</p>
                        </div>
                    </div>
                    
                    <div class="stats-card info">
                        <div class="stats-icon">✅</div>
                        <div class="stats-content">
                            <div class="stats-value"><%= atencionesCompletadas %></div>
                            <h3>Atenciones Completadas</h3>
                            <p>Servicios finalizados</p>
                        </div>
                    </div>
                    
                    <div class="stats-card warning">
                        <div class="stats-icon">⏱️</div>
                        <div class="stats-content">
                            <div class="stats-value"><%= atencionesEnProgreso %></div>
                            <h3>En Progreso</h3>
                            <p>Atenciones activas</p>
                        </div>
                    </div>
                </div>
                <% } %>

                <!-- Filtros -->
                <% if (historial != null && !historial.isEmpty()) { %>
                <div class="filter-controls">
                    <strong>🔍 Filtrar por estado:</strong>
                    <button onclick="filtrarPorEstado('todos')" class="btn btn-small">Todos</button>
                    <button onclick="filtrarPorEstado('completado')" class="btn btn-small btn-success">Completados</button>
                    <button onclick="filtrarPorEstado('progreso')" class="btn btn-small btn-warning">En Progreso</button>
                </div>
                <% } %>

                <!-- Tabla de historial -->
                <% if (historial != null && !historial.isEmpty()) { %>
                <div class="table-container">
                    <div class="table-wrapper">
                        <table>
                            <thead>
                                <tr>
                                    <th>ID Atención</th>
                                    <th>Fecha Inicio</th>
                                    <th>Fecha Fin</th>
                                    <th>Estado</th>
                                    <th>Groomer</th>
                                    <th>Sucursal</th>
                                    <th>Servicios</th>
                                    <th>Monto</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (HistorialMascotaDTO atencion : historial) { 
                                    boolean estaCompletada = atencion.getTiempoRealFin() != null;
                                %>
                                <tr>
                                    <td><span class="id-badge"><%= atencion.getIdAtencion() %></span></td>
                                    <td><strong><%= atencion.getTiempoRealInicio() %></strong></td>
                                    <td>
                                        <% if (estaCompletada) { %>
                                            <strong><%= atencion.getTiempoRealFin() %></strong>
                                        <% } else { %>
                                            <span class="no-data">En progreso</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <span class="status-badge <%= estaCompletada ? "status-completed" : "status-progress" %>">
                                            <%= estaCompletada ? "✅ Completado" : "⏱️ En Progreso" %>
                                        </span>
                                    </td>
                                    <td>
                                        <% if (atencion.getGroomer() != null && !atencion.getGroomer().isEmpty()) { %>
                                            👨‍💼 <%= atencion.getGroomer() %>
                                        <% } else { %>
                                            <span class="no-data">N/A</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if (atencion.getSucursal() != null && !atencion.getSucursal().isEmpty()) { %>
                                            🏢 <%= atencion.getSucursal() %>
                                        <% } else { %>
                                            <span class="no-data">N/A</span>
                                        <% } %>
                                    </td>
                                    <td class="service-list">
                                        <% if (atencion.getServicios() != null && !atencion.getServicios().isEmpty()) { %>
                                            🛠️ <%= atencion.getServicios() %>
                                        <% } else { %>
                                            <span class="no-data">N/A</span>
                                        <% } %>
                                    </td>
                                    <td class="money">S/ <%= String.format("%.2f", atencion.getMontoFacturado()) %></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
                <% } else if (historial != null && historial.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-icon">📄</div>
                    <h3>No hay historial de atenciones</h3>
                    <p>Esta mascota no tiene registros de servicios o atenciones en el sistema.<br>Los registros aparecerán aquí cuando se realicen atenciones.</p>
                    <a href="Clientes.jsp" class="btn btn-accent">👥 Buscar Otra Mascota</a>
                </div>
                <% } %>

                <!-- Navegación -->
                <div class="navigation">
                    <a href="Clientes.jsp" class="btn btn-primary">👥 Ver Clientes</a>
                    <a href="ListaMascotas.jsp" class="btn btn-info">🐾 Ver Todas las Mascotas</a>
                    <a href="MascotasPorCliente.jsp" class="btn btn-warning">🔍 Ver Mascotas por Cliente</a>
                    <a href="dashboard.jsp" class="btn btn-secondary">📊 Ir al Dashboard</a>
                    <% if (historial != null && !historial.isEmpty()) { %>
                    <a href="#" class="btn btn-success" onclick="exportarHistorial()">📊 Exportar CSV</a>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Animaciones y efectos interactivos
        document.addEventListener('DOMContentLoaded', function() {
            // Efecto de aparición escalonada para las filas de la tabla
            const tableRows = document.querySelectorAll('tbody tr');
            tableRows.forEach((row, index) => {
                row.style.opacity = '0';
                row.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    row.style.transition = 'all 0.5s cubic-bezier(0.4, 0, 0.2, 1)';
                    row.style.opacity = '1';
                    row.style.transform = 'translateY(0)';
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

            // Resaltar filas al pasar el mouse
            tableRows.forEach(row => {
                row.addEventListener('mouseenter', function() {
                    this.style.backgroundColor = 'rgba(171, 203, 213, 0.05)';
                });
                row.addEventListener('mouseleave', function() {
                    this.style.backgroundColor = '';
                });
            });

            // Efectos en badges de estado
            const statusBadges = document.querySelectorAll('.status-badge');
            statusBadges.forEach(badge => {
                badge.addEventListener('mouseenter', function() {
                    this.style.transform = 'scale(1.05)';
                });
                badge.addEventListener('mouseleave', function() {
                    this.style.transform = 'scale(1)';
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
                    'Registro completo de servicios y atenciones de la mascota - ' + now.toLocaleDateString('es-ES', options);
            }

            setInterval(updateTime, 1000);
        });

        // Función para filtrar por estado
        function filtrarPorEstado(estado) {
            const rows = document.querySelectorAll('tbody tr');
            rows.forEach(row => {
                const statusBadge = row.querySelector('.status-badge');
                if (estado === 'todos') {
                    row.style.display = '';
                } else if (estado === 'completado' && statusBadge.textContent.includes('✅')) {
                    row.style.display = '';
                } else if (estado === 'progreso' && statusBadge.textContent.includes('⏱️')) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        // Función para exportar historial
        function exportarHistorial() {
            if (confirm('¿Desea exportar el historial de atenciones a un archivo CSV?')) {
                // Simular exportación
                const exportBtn = document.querySelector('.btn-success[onclick="exportarHistorial()"]');
                const originalText = exportBtn.innerHTML;
                exportBtn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Exportando...';
                exportBtn.disabled = true;
                
                setTimeout(() => {
                    exportBtn.innerHTML = originalText;
                    exportBtn.disabled = false;
                    alert('✅ Historial exportado correctamente');
                }, 2000);
            }
        }

        // Función para mostrar loading en botones
        function showLoading(button) {
            const originalText = button.innerHTML;
            button.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Procesando...';
            button.disabled = true;
            
            setTimeout(() => {
                button.innerHTML = originalText;
                button.disabled = false;
            }, 2000);
        }

        // Agregar evento de loading a los botones principales
        const mainButtons = document.querySelectorAll('.header-actions .btn, .navigation .btn:not([onclick])');
        mainButtons.forEach(button => {
            button.addEventListener('click', function(e) {
                if (this.href && !this.href.includes('javascript')) {
                    showLoading(this);
                }
            });
        });
    </script>
</body>
</html>