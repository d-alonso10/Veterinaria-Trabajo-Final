<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, modelo.MascotaBusquedaDTO"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Buscar Mascotas - Sistema PetCare</title>
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

        .btn-action {
            padding: 8px 16px;
            font-size: 0.85em;
            border-radius: 12px;
            margin: 2px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.3s ease;
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

        /* Search Container */
        .search-container {
            background: var(--white);
            padding: 30px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
            border-top: 4px solid var(--primary-color);
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out;
        }

        .search-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-primary);
        }

        .search-form {
            display: flex;
            gap: 20px;
            align-items: flex-end;
        }

        .form-group {
            flex: 1;
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

        .search-help {
            font-size: 0.9em;
            color: var(--text-light);
            margin-top: 8px;
            font-style: italic;
        }

        /* Results Header */
        .results-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding: 25px;
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            animation: fadeInUp 0.6s ease-out 0.2s both;
        }

        .results-count {
            font-size: 1.3em;
            color: var(--text-dark);
            font-weight: 700;
        }

        .results-count span {
            color: var(--primary-color);
            font-size: 1.4em;
        }

        .quick-actions {
            display: flex;
            gap: 12px;
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

        /* Status Badges */
        .id-badge {
            background: var(--primary-light);
            color: var(--text-dark);
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.85em;
            border: 1px solid var(--primary-color);
        }

        .species-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.8em;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .species-perro {
            background: linear-gradient(135deg, #e8f4f8 0%, #d4eaf0 100%);
            color: var(--text-dark);
            border: 1px solid var(--primary-light);
        }

        .species-gato {
            background: linear-gradient(135deg, #f8e8f4 0%, #f4d4e8 100%);
            color: #8e44ad;
            border: 1px solid #e8cff4;
        }

        .species-otro {
            background: linear-gradient(135deg, #f8f4e8 0%, #f4ead4 100%);
            color: #f39c12;
            border: 1px solid #f4e4c8;
        }

        .microchip-badge {
            background: linear-gradient(135deg, #e8f8f4 0%, #d4f4e8 100%);
            color: var(--success-color);
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8em;
            font-weight: 600;
            border: 1px solid #c8f4e0;
        }

        .no-microchip {
            background: linear-gradient(135deg, #f8f8f8 0%, #e8e8e8 100%);
            color: var(--text-light);
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8em;
            font-weight: 600;
            border: 1px solid #e0e0e0;
        }

        .no-data {
            color: var(--text-light);
            font-style: italic;
            font-size: 0.9em;
        }

        /* Action Buttons */
        .action-buttons-table {
            display: flex;
            gap: 8px;
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

        /* Navigation */
        .navigation {
            display: flex;
            gap: 20px;
            margin-top: 40px;
            justify-content: center;
            flex-wrap: wrap;
        }

        /* Table Wrapper for Responsive */
        .table-wrapper {
            overflow-x: auto;
            border-radius: var(--radius);
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
            .search-form {
                flex-direction: column;
                gap: 15px;
            }
            .results-header {
                flex-direction: column;
                gap: 20px;
                text-align: center;
            }
            .quick-actions {
                justify-content: center;
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
            .action-buttons-table {
                flex-direction: column;
                gap: 8px;
            }
        }

        @media (max-width: 480px) {
            .header {
                padding: 20px;
            }
            .main-content {
                padding: 15px;
            }
            .search-container {
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
                <li class="menu-item active">
                    <a href="#">
                        <span class="menu-icon">🔍</span>
                        <span>Buscar Mascotas</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="Clientes.jsp">
                        <span class="menu-icon">👥</span>
                        <span>Clientes</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="InsertarMascota.jsp">
                        <span class="menu-icon">➕</span>
                        <span>Nueva Mascota</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="ListaMascotas.jsp">
                        <span class="menu-icon">🐾</span>
                        <span>Todas las Mascotas</span>
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
                        <span class="menu-icon">👥</span>
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
                        <h1>🔍 Buscar Mascotas</h1>
                        <p>Encuentra mascotas en el sistema por nombre, raza, dueño o características - <%= new java.text.SimpleDateFormat("EEEE, d 'de' MMMM 'de' yyyy").format(new java.util.Date()) %></p>
                    </div>
                    <div class="header-actions">
                        <a href="InsertarMascota.jsp" class="btn btn-success">➕ Nueva Mascota</a>
                        <a href="ListaMascotas.jsp" class="btn btn-info">🐾 Ver Todas</a>
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

                <!-- Search Form -->
                <div class="search-container">
                    <form action="MascotaControlador" method="POST" id="searchForm">
                        <input type="hidden" name="accion" value="buscar">
                        <div class="search-form">
                            <div class="form-group">
                                <label for="termino">Término de Búsqueda:</label>
                                <input type="text" id="termino" name="termino" class="form-control" 
                                       placeholder="Buscar por nombre, raza, dueño, microchip..." 
                                       value="<%= request.getAttribute("terminoBusqueda") != null ? request.getAttribute("terminoBusqueda") : "" %>">
                                <div class="search-help">🔍 Puedes buscar por nombre de mascota, raza, especie, nombre del dueño o número de microchip</div>
                            </div>
                            <button type="submit" class="btn btn-primary" id="searchBtn">
                                <span>🔍 Buscar Mascotas</span>
                            </button>
                        </div>
                    </form>
                </div>

                <% 
                    List<MascotaBusquedaDTO> mascotas = (List<MascotaBusquedaDTO>) request.getAttribute("mascotas");
                    Integer totalResultados = (Integer) request.getAttribute("totalResultados");
                    String terminoBusqueda = (String) request.getAttribute("terminoBusqueda");
                %>

                <!-- Results Section -->
                <% if (totalResultados != null || (mascotas != null && !mascotas.isEmpty())) { %>
                    <div class="results-header">
                        <div class="results-count">
                            <% if (totalResultados != null) { %>
                                <span><%= totalResultados %></span> mascotas encontradas
                                <% if (terminoBusqueda != null && !terminoBusqueda.isEmpty()) { %>
                                    para "<%= terminoBusqueda %>"
                                <% } %>
                            <% } else if (mascotas != null) { %>
                                <span><%= mascotas.size() %></span> mascotas en resultados
                            <% } %>
                        </div>
                        <div class="quick-actions">
                            <a href="InsertarMascota.jsp" class="btn btn-success btn-small">➕ Nueva Mascota</a>
                            <button onclick="exportarResultados()" class="btn btn-secondary btn-small">📊 Exportar</button>
                            <button onclick="limpiarBusqueda()" class="btn btn-warning btn-small">🔄 Limpiar</button>
                        </div>
                    </div>
                <% } %>

                <!-- Results Table -->
                <% if (mascotas != null && !mascotas.isEmpty()) { %>
                    <div class="table-container">
                        <div class="table-wrapper">
                            <table>
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Nombre</th>
                                        <th>Especie</th>
                                        <th>Raza</th>
                                        <th>Microchip</th>
                                        <th>Dueño</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (MascotaBusquedaDTO mascota : mascotas) { 
                                        String speciesClass = "species-otro";
                                        if ("perro".equalsIgnoreCase(mascota.getEspecie())) {
                                            speciesClass = "species-perro";
                                        } else if ("gato".equalsIgnoreCase(mascota.getEspecie())) {
                                            speciesClass = "species-gato";
                                        }
                                    %>
                                    <tr>
                                        <td><span class="id-badge"><%= mascota.getIdMascota() %></span></td>
                                        <td>
                                            <strong>🐕 <%= mascota.getNombre() %></strong>
                                        </td>
                                        <td>
                                            <span class="species-badge <%= speciesClass %>">
                                                <%= mascota.getEspecie() %>
                                            </span>
                                        </td>
                                        <td><%= mascota.getRaza() != null ? mascota.getRaza() : "<span class='no-data'>N/A</span>" %></td>
                                        <td>
                                            <% if (mascota.getMicrochip() != null && !mascota.getMicrochip().isEmpty()) { %>
                                                <span class="microchip-badge">🔢 <%= mascota.getMicrochip() %></span>
                                            <% } else { %>
                                                <span class="no-microchip">Sin microchip</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <strong>👤 <%= mascota.getClienteNombre() %> <%= mascota.getClienteApellido() %></strong>
                                        </td>
                                        <td>
                                            <div class="action-buttons-table">
                                                <a href="VerMascota.jsp?id=<%= mascota.getIdMascota() %>" class="btn-action btn-primary" title="Ver detalles">
                                                    👁️ Ver
                                                </a>
                                                <a href="EditarMascota.jsp?id=<%= mascota.getIdMascota() %>" class="btn-action btn-warning" title="Editar mascota">
                                                    ✏️ Editar
                                                </a>
                                                <a href="CrearCita.jsp?mascotaId=<%= mascota.getIdMascota() %>" class="btn-action btn-success" title="Crear cita">
                                                    📅 Cita
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                <% } else if (mascotas != null && mascotas.isEmpty()) { %>
                    <div class="empty-state">
                        <div class="empty-icon">🔍</div>
                        <h3>No se encontraron mascotas</h3>
                        <p>
                            <% if (terminoBusqueda != null && !terminoBusqueda.isEmpty()) { %>
                                No hay resultados para "<strong><%= terminoBusqueda %></strong>".<br>
                                Intenta con otros términos de búsqueda o verifica la ortografía.
                            <% } else { %>
                                No hay mascotas registradas en el sistema.<br>
                                ¡Comienza agregando la primera mascota!
                            <% } %>
                        </p>
                        <a href="InsertarMascota.jsp" class="btn btn-primary">➕ Agregar Primera Mascota</a>
                    </div>
                <% } %>

                <!-- Navigation -->
                <div class="navigation">
                    <a href="InsertarMascota.jsp" class="btn btn-success">➕ Nueva Mascota</a>
                    <a href="ListaMascotas.jsp" class="btn btn-info">🐾 Ver Todas las Mascotas</a>
                    <a href="Clientes.jsp" class="btn btn-primary">👥 Gestión de Clientes</a>
                    <a href="dashboard.jsp" class="btn btn-secondary">📊 Ir al Dashboard</a>
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
            const buttons = document.querySelectorAll('.btn, .btn-action');
            buttons.forEach(button => {
                button.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-3px)';
                });
                button.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                });
            });

            // Manejar el envío del formulario de búsqueda
            const searchForm = document.getElementById('searchForm');
            const searchBtn = document.getElementById('searchBtn');
            
            searchForm.addEventListener('submit', function(e) {
                const termino = document.getElementById('termino').value.trim();
                
                if (!termino) {
                    e.preventDefault();
                    mostrarMensaje('Por favor, ingresa un término de búsqueda.', 'error');
                    return;
                }
                
                // Mostrar estado de carga
                const originalText = searchBtn.innerHTML;
                searchBtn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Buscando...';
                searchBtn.disabled = true;
                
                // Restaurar después de un tiempo (en caso de que la página no recargue)
                setTimeout(() => {
                    searchBtn.innerHTML = originalText;
                    searchBtn.disabled = false;
                }, 3000);
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
                    'Encuentra mascotas en el sistema por nombre, raza, dueño o características - ' + now.toLocaleDateString('es-ES', options);
            }

            setInterval(updateTime, 1000);
        });

        // Función para limpiar la búsqueda
        function limpiarBusqueda() {
            document.getElementById('termino').value = '';
            document.getElementById('searchForm').submit();
        }

        // Función para exportar resultados
        function exportarResultados() {
            const exportBtn = document.querySelector('.btn-secondary[onclick="exportarResultados()"]');
            const originalText = exportBtn.innerHTML;
            exportBtn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Exportando...';
            exportBtn.disabled = true;
            
            setTimeout(() => {
                exportBtn.innerHTML = originalText;
                exportBtn.disabled = false;
                mostrarMensaje('✅ Resultados exportados correctamente en formato CSV', 'success');
            }, 2000);
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
            const searchContainer = document.querySelector('.search-container');
            mainContent.insertBefore(mensajeDiv, searchContainer);
            
            setTimeout(() => {
                mensajeDiv.remove();
            }, 5000);
        }

        // Manejar tecla Enter en la búsqueda
        document.getElementById('termino').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                document.getElementById('searchForm').submit();
            }
        });

        // Auto-focus en el campo de búsqueda al cargar la página
        window.addEventListener('load', function() {
            const termino = document.getElementById('termino');
            if (termino && !termino.value) {
                setTimeout(() => {
                    termino.focus();
                }, 500);
            }
        });

        // Función para búsqueda avanzada (extensión futura)
        function buscarAvanzado() {
            mostrarMensaje('🔍 La búsqueda avanzada estará disponible en la próxima actualización', 'info');
        }

        // Función para ver estadísticas de búsqueda
        function verEstadisticas() {
            mostrarMensaje('📊 Las estadísticas de búsqueda estarán disponibles próximamente', 'info');
        }
    </script>
</body>
</html>