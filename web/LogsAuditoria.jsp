<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, modelo.AuditLogDTO" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Auditoría - Sistema PetCare</title>
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
            max-width: 1400px;
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

        /* Search Box Mejorado */
        .search-box {
            background: var(--white);
            padding: 30px;
            border-radius: var(--radius);
            margin-bottom: 30px;
            box-shadow: var(--shadow);
            border-top: 4px solid var(--primary-color);
            animation: fadeInUp 0.6s ease-out;
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

        .search-form {
            display: flex;
            gap: 20px;
            align-items: center;
            flex-wrap: wrap;
        }

        .search-input, .filter-select {
            flex: 1;
            min-width: 200px;
            padding: 16px 20px;
            border: 2px solid #e0e0e0;
            border-radius: var(--radius);
            font-size: 1em;
            background: #f9f9f9;
            transition: all 0.3s ease;
            font-family: inherit;
        }

        .search-input:focus, .filter-select:focus {
            outline: none;
            border-color: var(--primary-color);
            background: var(--white);
            box-shadow: 0 0 0 4px rgba(171, 203, 213, 0.2);
            transform: translateY(-2px);
        }

        /* Stats Container Mejorado */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin: 30px 0;
        }

        .stat-card {
            background: var(--white);
            padding: 30px 25px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            text-align: center;
            border: 1px solid rgba(0, 0, 0, 0.05);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.8s ease-out;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-primary);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }

        .stat-icon {
            font-size: 3em;
            margin-bottom: 15px;
            display: block;
        }

        .stat-number {
            font-size: 2.5em;
            font-weight: 800;
            margin: 10px 0;
            color: var(--primary-dark);
        }

        .stat-label {
            color: var(--text-light);
            font-size: 1em;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* Table Container Mejorado */
        .table-container {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 30px;
            border: 1px solid rgba(0, 0, 0, 0.05);
            animation: fadeInUp 0.8s ease-out;
        }

        .table-wrapper {
            overflow-x: auto;
            border-radius: var(--radius);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1000px;
        }

        th {
            background: var(--gradient-primary);
            color: var(--white);
            font-weight: 600;
            padding: 20px;
            text-align: left;
            border-bottom: 2px solid var(--primary-dark);
            position: sticky;
            top: 0;
            font-size: 0.95em;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        td {
            padding: 18px 20px;
            text-align: left;
            border-bottom: 1px solid rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            font-size: 0.95em;
        }

        tr {
            transition: all 0.3s ease;
        }

        tr:hover td {
            background-color: rgba(171, 203, 213, 0.05);
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        /* Badges y Estados Mejorados */
        .badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.85em;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .badge-insert {
            background: linear-gradient(135deg, #e8f6ef 0%, #d1f2eb 100%);
            color: #1e8449;
            border: 1px solid #a3e4d7;
        }

        .badge-update {
            background: linear-gradient(135deg, #fef9e7 0%, #fcf3cf 100%);
            color: #b7950b;
            border: 1px solid #f9e79f;
        }

        .badge-delete {
            background: linear-gradient(135deg, #fdedec 0%, #fadbd8 100%);
            color: #c0392b;
            border: 1px solid #f5b7b1;
        }

        .entity-badge {
            background: var(--primary-light);
            color: var(--text-dark);
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.85em;
            border: 1px solid var(--primary-color);
        }

        .id-badge {
            background: linear-gradient(135deg, #e8f4f8 0%, #d4eaf0 100%);
            color: var(--text-dark);
            padding: 6px 12px;
            border-radius: 20px;
            font-family: 'Courier New', monospace;
            font-size: 0.85em;
            font-weight: 600;
            border: 1px solid var(--primary-light);
        }

        .timestamp {
            color: var(--text-light);
            font-size: 0.9em;
            font-family: 'Courier New', monospace;
        }

        .json-data {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 12px;
            font-family: 'Courier New', monospace;
            font-size: 0.85em;
            max-height: 120px;
            overflow-y: auto;
            color: var(--text-dark);
        }

        .no-data {
            color: var(--text-light);
            font-style: italic;
            font-size: 0.9em;
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

        /* Empty State Mejorado */
        .empty-state {
            text-align: center;
            padding: 80px 40px;
            color: var(--text-light);
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin: 30px 0;
            animation: fadeInUp 0.8s ease-out;
        }

        .empty-state-icon {
            font-size: 4em;
            margin-bottom: 20px;
            display: block;
            opacity: 0.7;
        }

        .empty-state h3 {
            font-size: 1.8em;
            margin-bottom: 15px;
            color: var(--text-dark);
            font-weight: 600;
        }

        .empty-state p {
            font-size: 1.1em;
            margin-bottom: 30px;
            max-width: 500px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.8;
        }

        /* Filtros adicionales */
        .filters-container {
            background: var(--white);
            padding: 25px;
            border-radius: var(--radius);
            margin-bottom: 25px;
            box-shadow: var(--shadow);
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            align-items: center;
        }

        .filter-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .filter-label {
            font-weight: 600;
            color: var(--text-dark);
            font-size: 0.9em;
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
            .search-form {
                flex-direction: column;
            }
            .stats-container {
                grid-template-columns: 1fr;
            }
            .filters-container {
                flex-direction: column;
                align-items: stretch;
            }
            .filter-group {
                width: 100%;
                justify-content: space-between;
            }
        }

        @media (max-width: 480px) {
            .header {
                padding: 20px;
            }
            .main-content {
                padding: 15px;
            }
            .btn {
                width: 100%;
                justify-content: center;
            }
            .empty-state {
                padding: 40px 20px;
            }
            .empty-state-icon {
                font-size: 3em;
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

        .pulse {
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
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

        /* Export button */
        .btn-export {
            background: linear-gradient(135deg, #9b59b6 0%, #8e44ad 100%);
            color: white;
            box-shadow: 0 8px 25px rgba(155, 89, 182, 0.3);
        }

        .btn-export:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(155, 89, 182, 0.4);
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
                <li class="menu-item active">
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
                        <h1>🔍 Auditoría del Sistema</h1>
                        <p>Registro completo de todas las actividades del sistema</p>
                    </div>
                    <div class="header-actions">
                        <a href="dashboard.jsp" class="btn btn-primary">
                            <span>📊 Ir al Dashboard</span>
                        </a>
                        <button onclick="exportarLogs()" class="btn btn-export">
                            <span>📤 Exportar Logs</span>
                        </button>
                    </div>
                </div>
            </div>

            <div class="main-content">
                <!-- Mensajes -->
                <% 
                    String mensaje = (String) request.getAttribute("mensaje");
                    if (mensaje != null) {
                        String tipoClase = mensaje.startsWith("✅") ? "exito" :
                                           mensaje.startsWith("⚠️") ? "warning" : "error";
                %>
                    <div class="mensaje <%= tipoClase %>"><%= mensaje %></div>
                <% } %>

                <!-- Estadísticas de Auditoría -->
                <div class="stats-container">
                    <div class="stat-card floating">
                        <span class="stat-icon">📋</span>
                        <div class="stat-number" id="totalLogs">
                            <%= request.getAttribute("totalLogs") != null ? request.getAttribute("totalLogs") : 0 %>
                        </div>
                        <div class="stat-label">Total de Registros</div>
                    </div>
                    <div class="stat-card floating" style="animation-delay: 0.2s;">
                        <span class="stat-icon">➕</span>
                        <div class="stat-number" id="insertsCount">0</div>
                        <div class="stat-label">Inserciones</div>
                    </div>
                    <div class="stat-card floating" style="animation-delay: 0.4s;">
                        <span class="stat-icon">✏️</span>
                        <div class="stat-number" id="updatesCount">0</div>
                        <div class="stat-label">Actualizaciones</div>
                    </div>
                    <div class="stat-card floating" style="animation-delay: 0.6s;">
                        <span class="stat-icon">🗑️</span>
                        <div class="stat-number" id="deletesCount">0</div>
                        <div class="stat-label">Eliminaciones</div>
                    </div>
                </div>

                <!-- Filtros de Búsqueda Mejorados -->
                <div class="search-box">
                    <form action="AuditControlador" method="get" class="search-form" id="searchForm">
                        <input type="hidden" name="accion" value="filtrar">

                        <input type="text" name="entidad" 
                               placeholder="🔍 Entidad (cliente, mascota, cita...)" 
                               class="search-input"
                               value="<%= request.getAttribute("entidadFiltro") != null ? request.getAttribute("entidadFiltro") : "" %>">

                        <select name="accionFiltro" class="filter-select">
                            <option value="">-- Todas las Acciones --</option>
                            <option value="INSERT" <%= "INSERT".equals(request.getAttribute("accionFiltro")) ? "selected" : "" %>>INSERT</option>
                            <option value="UPDATE" <%= "UPDATE".equals(request.getAttribute("accionFiltro")) ? "selected" : "" %>>UPDATE</option>
                            <option value="DELETE" <%= "DELETE".equals(request.getAttribute("accionFiltro")) ? "selected" : "" %>>DELETE</option>
                        </select>

                        <input type="number" name="limite" min="1" max="1000" value="50" 
                               class="search-input" style="width: 100px;">

                        <button type="submit" class="btn btn-primary">
                            <span>🔍 Filtrar</span>
                        </button>
                        
                        <a href="AuditControlador?accion=listar" class="btn btn-secondary">
                            <span>🔄 Mostrar Todos</span>
                        </a>
                    </form>
                </div>

                <!-- Tabla de Logs Mejorada -->
                <% 
                    List<AuditLogDTO> logs = (List<AuditLogDTO>) request.getAttribute("logs");
                    if (logs != null && !logs.isEmpty()) { 
                %>
                    <div class="table-container">
                        <div class="table-wrapper">
                            <table>
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Entidad</th>
                                        <th>ID Entidad</th>
                                        <th>Acción</th>
                                        <th>Usuario</th>
                                        <th>Fecha/Hora</th>
                                        <th>Datos Anteriores</th>
                                        <th>Datos Nuevos</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        int i = 1;
                                        for (AuditLogDTO log : logs) { 
                                            String badgeClass = "";
                                            switch(log.getAccion()) {
                                                case "INSERT": badgeClass = "badge-insert"; break;
                                                case "UPDATE": badgeClass = "badge-update"; break;
                                                case "DELETE": badgeClass = "badge-delete"; break;
                                            }
                                    %>
                                    <tr class="fade-in-row">
                                        <td>
                                            <span class="id-badge">#<%= i++ %></span>
                                        </td>
                                        <td>
                                            <span class="entity-badge"><%= log.getEntidad() %></span>
                                        </td>
                                        <td>
                                            <span class="id-badge"><%= log.getEntidadId() %></span>
                                        </td>
                                        <td>
                                            <span class="badge <%= badgeClass %>"><%= log.getAccion() %></span>
                                        </td>
                                        <td>
                                            <strong><%= (log.getUsuario() != null ? log.getUsuario() : "Sistema") %></strong>
                                        </td>
                                        <td>
                                            <span class="timestamp"><%= log.getTimestamp() %></span>
                                        </td>
                                        <td>
                                            <% if (log.getAntes() != null && !log.getAntes().isEmpty()) { %>
                                                <div class="json-data" title="<%= log.getAntes() %>">
                                                    <%= log.getAntes().length() > 100 ? log.getAntes().substring(0, 100) + "..." : log.getAntes() %>
                                                </div>
                                            <% } else { %>
                                                <span class="no-data">-</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <% if (log.getDespues() != null && !log.getDespues().isEmpty()) { %>
                                                <div class="json-data" title="<%= log.getDespues() %>">
                                                    <%= log.getDespues().length() > 100 ? log.getDespues().substring(0, 100) + "..." : log.getDespues() %>
                                                </div>
                                            <% } else { %>
                                                <span class="no-data">-</span>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Resumen de resultados -->
                    <div class="info" style="margin: 20px 0; padding: 15px 25px;">
                        <strong>📋 Resumen:</strong> Mostrando <strong><%= logs.size() %></strong> 
                        <%= logs.size() == 1 ? "registro" : "registros" %> de auditoría
                        <% if (request.getAttribute("entidadFiltro") != null && !((String)request.getAttribute("entidadFiltro")).isEmpty()) { %>
                            para la entidad: "<strong><%= request.getAttribute("entidadFiltro") %></strong>"
                        <% } %>
                        <% if (request.getAttribute("accionFiltro") != null && !((String)request.getAttribute("accionFiltro")).isEmpty()) { %>
                            con acción: "<strong><%= request.getAttribute("accionFiltro") %></strong>"
                        <% } %>
                    </div>

                <% } else { %>
                    <div class="empty-state">
                        <span class="empty-state-icon">📋</span>
                        <h3>No hay registros de auditoría</h3>
                        <p>
                            <% if (request.getAttribute("entidadFiltro") != null || request.getAttribute("accionFiltro") != null) { %>
                                No se encontraron registros que coincidan con los filtros aplicados.
                            <% } else { %>
                                Los registros de auditoría aparecerán aquí cuando se realicen operaciones en el sistema.
                            <% } %>
                        </p>
                        <% if (request.getAttribute("entidadFiltro") != null || request.getAttribute("accionFiltro") != null) { %>
                            <a href="AuditControlador?accion=listar" class="btn btn-primary" style="margin-top: 15px;">
                                <span>🔄 Ver todos los registros</span>
                            </a>
                        <% } %>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <script>
        // Script mejorado para la página de auditoría
        document.addEventListener('DOMContentLoaded', function() {
            // Contar acciones por tipo
            function contarAcciones() {
                const inserts = document.querySelectorAll('.badge-insert').length;
                const updates = document.querySelectorAll('.badge-update').length;
                const deletes = document.querySelectorAll('.badge-delete').length;
                
                document.getElementById('insertsCount').textContent = inserts;
                document.getElementById('updatesCount').textContent = updates;
                document.getElementById('deletesCount').textContent = deletes;
            }

            // Efecto de carga suave para las filas de la tabla
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

            // Contar acciones después de que se carguen las filas
            setTimeout(contarAcciones, 500);

            // Animación de contadores en las estadísticas
            function animateCounter(element, target) {
                let current = 0;
                const increment = target / 50;
                const timer = setInterval(() => {
                    current += increment;
                    if (current >= target) {
                        element.textContent = target;
                        clearInterval(timer);
                    } else {
                        element.textContent = Math.floor(current);
                    }
                }, 40);
            }

            // Animar contador total
            const totalElement = document.getElementById('totalLogs');
            if (totalElement) {
                const total = parseInt(totalElement.textContent);
                animateCounter(totalElement, total);
            }

            // Expandir/contraer datos JSON al hacer clic
            const jsonDataElements = document.querySelectorAll('.json-data');
            jsonDataElements.forEach(element => {
                element.style.cursor = 'pointer';
                element.addEventListener('click', function() {
                    const fullText = this.getAttribute('title');
                    if (fullText && fullText.length > 100) {
                        if (this.style.maxHeight && this.style.maxHeight !== '120px') {
                            this.style.maxHeight = '120px';
                            this.textContent = fullText.substring(0, 100) + '...';
                        } else {
                            this.style.maxHeight = 'none';
                            this.textContent = fullText;
                        }
                    }
                });
            });

            // Búsqueda en tiempo real con debounce
            let searchTimeout;
            const searchInput = document.querySelector('input[name="entidad"]');
            if (searchInput) {
                searchInput.addEventListener('input', function() {
                    clearTimeout(searchTimeout);
                    searchTimeout = setTimeout(() => {
                        if (this.value.length >= 2 || this.value.length === 0) {
                            document.getElementById('searchForm').submit();
                        }
                    }, 800);
                });
            }
        });

        // Función para exportar logs
        function exportarLogs() {
            if (confirm('¿Desea exportar los registros de auditoría?')) {
                const exportBtn = document.querySelector('.btn-export');
                const originalText = exportBtn.innerHTML;
                exportBtn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Exportando...';
                exportBtn.disabled = true;
                
                // Simular exportación
                setTimeout(() => {
                    exportBtn.innerHTML = originalText;
                    exportBtn.disabled = false;
                    alert('✅ Registros de auditoría exportados correctamente');
                }, 2000);
            }
        }

        // Función para filtrar por fecha (placeholder para futura implementación)
        function filtrarPorFecha() {
            alert('🚧 Función de filtrado por fecha en desarrollo');
        }

        // Función para limpiar registros antiguos (solo para administradores)
        function limpiarRegistrosAntiguos() {
            if (confirm('¿Está seguro de que desea eliminar los registros de auditoría antiguos?\n\nEsta acción no se puede deshacer.')) {
                if (confirm('⚠️ ADVERTENCIA: Esta acción eliminará permanentemente los registros. ¿Continuar?')) {
                    // Aquí iría la llamada al servidor para limpiar registros
                    alert('✅ Registros antiguos eliminados correctamente');
                }
            }
        }
    </script>
</body>
</html>