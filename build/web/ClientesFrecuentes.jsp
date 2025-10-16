<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, modelo.ClienteFrecuenteDTO"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clientes Frecuentes - Sistema PetCare</title>
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
            --gold: #FFD700;
            --silver: #C0C0C0;
            --bronze: #CD7F32;
            --gradient-gold: linear-gradient(135deg, var(--gold) 0%, #ffed4e 100%);
            --gradient-silver: linear-gradient(135deg, var(--silver) 0%, #a8a8a8 100%);
            --gradient-bronze: linear-gradient(135deg, var(--bronze) 0%, #b08d57 100%);
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

        /* Mensajes de estado */
        .mensaje {
            padding: 20px 25px;
            margin: 0 0 30px 0;
            border-radius: var(--radius);
            border-left: 4px solid;
            font-size: 0.95em;
            box-shadow: var(--shadow);
            background: var(--white);
            animation: fadeInUp 0.6s ease-out;
        }

        .exito {
            border-left-color: var(--success-color);
            color: #1e7e34;
            background: linear-gradient(135deg, #f0f9f4 0%, #e8f5e8 100%);
        }

        .error {
            border-left-color: var(--danger-color);
            color: #c53030;
            background: linear-gradient(135deg, #fdf2f2 0%, #ffeaea 100%);
        }

        .info {
            border-left-color: var(--info-color);
            color: var(--text-dark);
            background: linear-gradient(135deg, #f0f7ff 0%, #e6f2ff 100%);
        }

        /* Podio Styles */
        .podio-container {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            padding: 40px 30px;
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.8s ease-out;
        }

        .podio-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--gold) 0%, var(--silver) 50%, var(--bronze) 100%);
        }

        .podio-title {
            text-align: center;
            margin-bottom: 40px;
            color: var(--text-dark);
        }

        .podio-title h2 {
            font-size: 2em;
            margin-bottom: 15px;
            font-weight: 700;
        }

        .podio-title p {
            color: var(--text-light);
            font-size: 1.1em;
        }

        .podio-grid {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 25px;
            align-items: end;
        }

        .podio-item {
            text-align: center;
            padding: 30px 25px;
            border-radius: var(--radius);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.8s ease-out;
        }

        .podio-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.6s;
        }

        .podio-item:hover::before {
            left: 100%;
        }

        .podio-item:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }

        .podio-2 {
            order: 1;
            background: var(--gradient-silver);
            color: var(--text-dark);
        }

        .podio-1 {
            order: 2;
            background: var(--gradient-gold);
            color: var(--text-dark);
            transform: scale(1.1);
            z-index: 2;
        }

        .podio-3 {
            order: 3;
            background: var(--gradient-bronze);
            color: var(--text-dark);
        }

        .podio-rank {
            font-size: 3em;
            font-weight: bold;
            margin-bottom: 15px;
            display: block;
        }

        .podio-name {
            font-size: 1.4em;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .podio-stats {
            font-size: 1em;
            opacity: 0.9;
            margin-bottom: 15px;
            line-height: 1.6;
        }

        .podio-amount {
            font-size: 1.3em;
            font-weight: 800;
            margin-top: 10px;
            color: var(--text-dark);
        }

        /* Stats Card */
        .stats-card {
            background: var(--white);
            padding: 30px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 20px;
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.8s ease-out;
        }

        .stats-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-primary);
        }

        .stats-icon {
            font-size: 3em;
            color: var(--primary-color);
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

        .stats-content strong {
            color: var(--primary-dark);
        }

        /* Table Container */
        .table-container {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 30px;
            animation: fadeInUp 0.8s ease-out;
            position: relative;
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
            padding: 20px;
            text-align: left;
            position: sticky;
            top: 0;
            font-size: 0.95em;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        td {
            padding: 18px 20px;
            text-align: left;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }

        tr:hover td {
            background-color: rgba(171, 203, 213, 0.05);
            transform: translateY(-1px);
        }

        /* Badges */
        .badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 700;
            text-transform: uppercase;
            display: inline-block;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .badge-gold {
            background: var(--gradient-gold);
            color: #000;
        }

        .badge-silver {
            background: var(--gradient-silver);
            color: #000;
        }

        .badge-bronze {
            background: var(--gradient-bronze);
            color: #000;
        }

        .badge-premium {
            background: var(--gradient-info);
            color: white;
        }

        .badge-frecuente {
            background: var(--gradient-success);
            color: white;
        }

        .badge-activo {
            background: var(--gradient-primary);
            color: white;
        }

        .ranking {
            font-weight: bold;
            font-size: 16px;
            text-align: center;
        }

        .money {
            color: var(--success-color);
            font-weight: 700;
            font-size: 1.1em;
        }

        /* Contact Info */
        .contact-info {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--text-light);
            font-size: 0.9em;
            margin-bottom: 4px;
        }

        .id-badge {
            background: var(--primary-light);
            color: var(--text-dark);
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.85em;
            display: inline-block;
            margin-top: 5px;
        }

        .no-data {
            color: var(--text-light);
            font-style: italic;
        }

        .table-wrapper {
            overflow-x: auto;
            border-radius: var(--radius);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 80px 40px;
            color: var(--text-light);
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            animation: fadeInUp 0.8s ease-out;
            position: relative;
            overflow: hidden;
        }

        .empty-state::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-primary);
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

        /* Navigation */
        .navigation {
            display: flex;
            gap: 20px;
            margin-top: 40px;
            justify-content: center;
            flex-wrap: wrap;
        }

        /* Animation */
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
            .podio-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            .podio-1 {
                transform: none;
                order: 1;
            }
            .podio-2 {
                order: 2;
            }
            .podio-3 {
                order: 3;
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
            .podio-item {
                padding: 20px 15px;
            }
            .podio-rank {
                font-size: 2.5em;
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
                    <a href="ClienteControlador?accion=listarFrecuentes">
                        <span class="menu-icon">🏆</span>
                        <span>Clientes Frecuentes</span>
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
                        <h1>🏆 Top 10 - Clientes Frecuentes</h1>
                        <p>Clientes con mayor número de atenciones y gasto total</p>
                    </div>
                    <div class="header-actions">
                        <a href="Clientes.jsp" class="btn btn-secondary">👥 Todos los Clientes</a>
                        <a href="InsertarCliente.jsp" class="btn btn-success">➕ Nuevo Cliente</a>
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

                <!-- Podio para los top 3 -->
                <% 
                List<ClienteFrecuenteDTO> clientesFrecuentes = (List<ClienteFrecuenteDTO>) request.getAttribute("clientesFrecuentes");
                if (clientesFrecuentes != null && clientesFrecuentes.size() >= 3) { 
                %>
                <div class="podio-container">
                    <div class="podio-title">
                        <h2>🎉 Podio de Clientes Estrella</h2>
                        <p>Nuestros clientes más valiosos del mes</p>
                    </div>
                    <div class="podio-grid">
                        <!-- Segundo lugar -->
                        <div class="podio-item podio-2 floating" style="animation-delay: 0.2s;">
                            <div class="podio-rank">🥈</div>
                            <div class="podio-name"><%= clientesFrecuentes.get(1).getNombre() %> <%= clientesFrecuentes.get(1).getApellido() %></div>
                            <div class="podio-stats">
                                <div>📋 <%= clientesFrecuentes.get(1).getTotalAtenciones() %> atenciones</div>
                                <div>🐾 <%= clientesFrecuentes.get(1).getTotalMascotas() %> mascotas</div>
                            </div>
                            <div class="podio-amount">💰 S/ <%= String.format("%.2f", clientesFrecuentes.get(1).getTotalGastado()) %></div>
                        </div>
                        
                        <!-- Primer lugar -->
                        <div class="podio-item podio-1 floating" style="animation-delay: 0.1s;">
                            <div class="podio-rank">🥇</div>
                            <div class="podio-name"><%= clientesFrecuentes.get(0).getNombre() %> <%= clientesFrecuentes.get(0).getApellido() %></div>
                            <div class="podio-stats">
                                <div>📋 <%= clientesFrecuentes.get(0).getTotalAtenciones() %> atenciones</div>
                                <div>🐾 <%= clientesFrecuentes.get(0).getTotalMascotas() %> mascotas</div>
                            </div>
                            <div class="podio-amount">💰 S/ <%= String.format("%.2f", clientesFrecuentes.get(0).getTotalGastado()) %></div>
                        </div>
                        
                        <!-- Tercer lugar -->
                        <div class="podio-item podio-3 floating" style="animation-delay: 0.3s;">
                            <div class="podio-rank">🥉</div>
                            <div class="podio-name"><%= clientesFrecuentes.get(2).getNombre() %> <%= clientesFrecuentes.get(2).getApellido() %></div>
                            <div class="podio-stats">
                                <div>📋 <%= clientesFrecuentes.get(2).getTotalAtenciones() %> atenciones</div>
                                <div>🐾 <%= clientesFrecuentes.get(2).getTotalMascotas() %> mascotas</div>
                            </div>
                            <div class="podio-amount">💰 S/ <%= String.format("%.2f", clientesFrecuentes.get(2).getTotalGastado()) %></div>
                        </div>
                    </div>
                </div>
                <% } %>

                <!-- Estadísticas -->
                <% Integer totalClientes = (Integer) request.getAttribute("totalClientes"); %>
                <% if (totalClientes != null) { %>
                    <div class="stats-card">
                        <div class="stats-icon">📊</div>
                        <div class="stats-content">
                            <h3>Resumen de Clientes Frecuentes</h3>
                            <p><strong>Total de clientes frecuentes:</strong> <%= totalClientes %></p>
                            <p><em>Clientes con mayor fidelidad y frecuencia de visitas</em></p>
                        </div>
                    </div>
                <% } %>

                <!-- Tabla de clientes frecuentes -->
                <% if (clientesFrecuentes != null && !clientesFrecuentes.isEmpty()) { %>
                    <div class="table-container">
                        <div class="table-wrapper">
                            <table>
                                <thead>
                                    <tr>
                                        <th width="5%">Rank</th>
                                        <th width="15%">Cliente</th>
                                        <th width="15%">Contacto</th>
                                        <th width="10%">Atenciones</th>
                                        <th width="10%">Mascotas</th>
                                        <th width="15%">Total Gastado</th>
                                        <th width="15%">Promedio por Atención</th>
                                        <th width="15%">Nivel</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                    int rank = 1;
                                    for (ClienteFrecuenteDTO cliente : clientesFrecuentes) { 
                                        String badgeClass = "";
                                        if (rank == 1) badgeClass = "badge-gold";
                                        else if (rank == 2) badgeClass = "badge-silver";
                                        else if (rank == 3) badgeClass = "badge-bronze";
                                        
                                        double promedioAtencion = cliente.getTotalAtenciones() > 0 ? 
                                            cliente.getTotalGastado() / cliente.getTotalAtenciones() : 0;
                                    %>
                                    <tr>
                                        <td class="ranking">
                                            <% if (rank <= 3) { %>
                                                <span class="badge <%= badgeClass %>">#<%= rank %></span>
                                            <% } else { %>
                                                #<%= rank %>
                                            <% } %>
                                        </td>
                                        <td>
                                            <strong><%= cliente.getNombre() %> <%= cliente.getApellido() %></strong><br>
                                            <span class="id-badge">ID: <%= cliente.getIdCliente() %></span>
                                        </td>
                                        <td>
                                            <% if (cliente.getEmail() != null && !cliente.getEmail().isEmpty()) { %>
                                                <div class="contact-info">📧 <%= cliente.getEmail() %></div>
                                            <% } else { %>
                                                <span class="no-data">N/A</span>
                                            <% } %>
                                            <% if (cliente.getTelefono() != null && !cliente.getTelefono().isEmpty()) { %>
                                                <div class="contact-info">📞 <%= cliente.getTelefono() %></div>
                                            <% } else { %>
                                                <span class="no-data">N/A</span>
                                            <% } %>
                                        </td>
                                        <td style="text-align: center;">
                                            <strong style="font-size: 18px;"><%= cliente.getTotalAtenciones() %></strong>
                                        </td>
                                        <td style="text-align: center;">
                                            <strong style="font-size: 16px;"><%= cliente.getTotalMascotas() %></strong>
                                        </td>
                                        <td class="money">S/ <%= String.format("%.2f", cliente.getTotalGastado()) %></td>
                                        <td class="money">S/ <%= String.format("%.2f", promedioAtencion) %></td>
                                        <td>
                                            <% if (cliente.getTotalAtenciones() >= 10) { %>
                                                <span class="badge badge-premium">💎 Premium</span>
                                            <% } else if (cliente.getTotalAtenciones() >= 5) { %>
                                                <span class="badge badge-frecuente">🔥 Frecuente</span>
                                            <% } else { %>
                                                <span class="badge badge-activo">👍 Activo</span>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <% rank++; } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                <% } else if (clientesFrecuentes != null && clientesFrecuentes.isEmpty()) { %>
                    <div class="empty-state">
                        <h3>📊 No hay datos de clientes frecuentes</h3>
                        <p>Los clientes frecuentes aparecerán aquí después de varias atenciones</p>
                        <a href="InsertarCliente.jsp" class="btn btn-primary" style="margin-top: 15px;">➕ Agregar Primer Cliente</a>
                    </div>
                <% } %>

                <!-- Navegación -->
                <div class="navigation">
                    <a href="InsertarCliente.jsp" class="btn btn-success">➕ Nuevo Cliente</a>
                    <a href="BuscarClientes.jsp" class="btn btn-info">🔍 Buscar Clientes</a>
                    <a href="ClienteControlador?accion=listarTodos" class="btn btn-primary">📋 Todos los Clientes</a>
                    <a href="reportes.jsp?tipo=clientes" class="btn btn-secondary">📈 Reportes</a>
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
            
            // Efectos de hover para el podio
            const podioItems = document.querySelectorAll('.podio-item');
            podioItems.forEach(item => {
                item.addEventListener('mouseenter', function() {
                    if (this.classList.contains('podio-1')) {
                        this.style.transform = 'scale(1.15) translateY(-8px)';
                    } else {
                        this.style.transform = 'translateY(-12px)';
                    }
                });
                
                item.addEventListener('mouseleave', function() {
                    if (this.classList.contains('podio-1')) {
                        this.style.transform = 'scale(1.1)';
                    } else {
                        this.style.transform = 'translateY(0)';
                    }
                });
            });

            // Animación de entrada para las filas de la tabla
            const tableRows = document.querySelectorAll('tbody tr');
            tableRows.forEach((row, index) => {
                row.style.opacity = '0';
                row.style.transform = 'translateX(-30px)';
                
                setTimeout(() => {
                    row.style.transition = 'all 0.6s cubic-bezier(0.4, 0, 0.2, 1)';
                    row.style.opacity = '1';
                    row.style.transform = 'translateX(0)';
                }, index * 100);
            });

            // Efecto de confeti al hacer clic en el podio (simulado)
            podioItems.forEach(item => {
                item.addEventListener('click', function() {
                    this.style.animation = 'none';
                    setTimeout(() => {
                        this.style.animation = 'floating 3s ease-in-out infinite';
                    }, 10);
                });
            });
        });

        // Función para mostrar detalles del cliente
        function verDetallesCliente(idCliente) {
            alert('👤 Detalles del cliente ID: ' + idCliente + '\n\nEsta funcionalidad puede expandirse para mostrar más información del cliente, historial de citas y mascotas.');
        }

        // Función para exportar ranking
        function exportarRanking() {
            alert('📊 Exportando ranking de clientes frecuentes...\nFormato: Excel\nTotal de clientes: <%= totalClientes != null ? totalClientes : 0 %>');
        }

        // Función para enviar promoción a clientes frecuentes
        function enviarPromocion() {
            if (confirm('🎁 ¿Deseas enviar una promoción especial a los clientes frecuentes?\n\nSe enviará un correo electrónico con ofertas exclusivas.')) {
                alert('📧 Promoción enviada exitosamente a los clientes frecuentes!');
            }
        }
    </script>
</body>
</html>