<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, modelo.Cliente"%>
<%@page import="dao.ClienteDao"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Clientes - Sistema PetCare</title>
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

        .btn-action {
            padding: 8px 16px;
            font-size: 0.85em;
            border-radius: 12px;
            margin: 2px;
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
        }

        .search-input {
            flex: 1;
            padding: 16px 20px;
            border: 2px solid #e0e0e0;
            border-radius: var(--radius);
            font-size: 1em;
            background: #f9f9f9;
            transition: all 0.3s ease;
            font-family: inherit;
        }

        .search-input:focus {
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
        .id-badge {
            background: var(--primary-light);
            color: var(--text-dark);
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.85em;
            border: 1px solid var(--primary-color);
        }

        .dni-badge {
            background: linear-gradient(135deg, #e8f4f8 0%, #d4eaf0 100%);
            color: var(--text-dark);
            padding: 6px 12px;
            border-radius: 20px;
            font-family: 'Courier New', monospace;
            font-size: 0.85em;
            font-weight: 600;
            border: 1px solid var(--primary-light);
        }

        .contact-info {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--text-dark);
            font-size: 0.9em;
            transition: all 0.3s ease;
        }

        .contact-info:hover {
            color: var(--primary-dark);
            transform: translateX(3px);
        }

        .no-data {
            color: var(--text-light);
            font-style: italic;
            font-size: 0.9em;
        }

        /* Action Buttons Mejorados */
        .action-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            justify-content: flex-start;
        }

        .btn-pets {
            background: linear-gradient(135deg, #9b59b6 0%, #8e44ad 100%);
            color: white;
            padding: 10px 18px;
            font-size: 0.85em;
            border-radius: 12px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.3s ease;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(155, 89, 182, 0.3);
        }

        .btn-pets:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(155, 89, 182, 0.4);
            background: linear-gradient(135deg, #8e44ad 0%, #7d3c98 100%);
        }

        .btn-edit {
            background: linear-gradient(135deg, var(--warning-color) 0%, #e0a800 100%);
            color: var(--text-dark);
            padding: 10px 18px;
            font-size: 0.85em;
            border-radius: 12px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.3s ease;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(255, 193, 7, 0.3);
        }

        .btn-edit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(255, 193, 7, 0.4);
        }

        .btn-delete {
            background: linear-gradient(135deg, var(--danger-color) 0%, #d32f2f 100%);
            color: white;
            padding: 10px 18px;
            font-size: 0.85em;
            border-radius: 12px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.3s ease;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(244, 67, 54, 0.3);
        }

        .btn-delete:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(244, 67, 54, 0.4);
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
            .navigation {
                grid-template-columns: 1fr;
            }
            .action-buttons {
                flex-direction: column;
                align-items: stretch;
            }
            .action-buttons a {
                width: 100%;
                justify-content: center;
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

        .filter-select {
            padding: 10px 15px;
            border: 2px solid #e0e0e0;
            border-radius: var(--radius);
            background: #f9f9f9;
            font-size: 0.9em;
            transition: all 0.3s ease;
        }

        .filter-select:focus {
            outline: none;
            border-color: var(--primary-color);
            background: var(--white);
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
                <li class="menu-item active">
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
                        <h1>👥 Gestión de Clientes</h1>
                        <p>Administra y gestiona todos los clientes del sistema</p>
                    </div>
                    <div class="header-actions">
                        <a href="InsertarCliente.jsp" class="btn btn-success">
                            <span>➕ Nuevo Cliente</span>
                        </a>
                        <a href="dashboard.jsp" class="btn btn-primary">
                            <span>📊 Ir al Dashboard</span>
                        </a>
                    </div>
                </div>
            </div>

            <div class="main-content">
                <!-- Mensajes -->
                <% if (request.getAttribute("mensaje") != null) { %>
                    <div class="mensaje <%= request.getAttribute("mensaje").toString().contains("✅") ? "exito" : "error" %>">
                        <%= request.getAttribute("mensaje") %>
                    </div>
                <% } %>

                <!-- Búsqueda rápida mejorada -->
                <div class="search-box">
                    <form action="ClienteControlador" method="POST" class="search-form" id="searchForm">
                        <input type="hidden" name="accion" value="buscar">
                        <input type="text" name="termino" placeholder="🔍 Buscar por nombre, apellido, DNI, email..." 
                               class="search-input" id="searchInput"
                               value="<%= request.getParameter("termino") != null ? request.getParameter("termino") : "" %>">
                        <button type="submit" class="btn btn-primary">
                            <span>Buscar Clientes</span>
                        </button>
                        <% if (request.getParameter("termino") != null && !request.getParameter("termino").isEmpty()) { %>
                            <a href="ClienteControlador" class="btn btn-secondary">
                                <span>🔄 Limpiar</span>
                            </a>
                        <% } %>
                    </form>
                </div>

                <%
                    List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");
                    Integer totalClientes = (Integer) request.getAttribute("totalClientes");
                    
                    // DEBUG TEMPORAL - Manteniendo tu lógica exacta
                    if (clientes == null) {
                        // Cargar directamente como fallback
                        ClienteDao dao = new ClienteDao();
                        clientes = dao.buscarClientes("");
                        totalClientes = clientes != null ? clientes.size() : 0;
                    }

                    // Calcular estadísticas adicionales
                    int clientesConEmail = 0;
                    int clientesConTelefono = 0;
                    if (clientes != null) {
                        for (Cliente cliente : clientes) {
                            if (cliente.getEmail() != null && !cliente.getEmail().isEmpty()) {
                                clientesConEmail++;
                            }
                            if (cliente.getTelefono() != null && !cliente.getTelefono().isEmpty()) {
                                clientesConTelefono++;
                            }
                        }
                    }
                %>

                <!-- Estadísticas mejoradas -->
                <div class="stats-container">
                    <div class="stat-card floating">
                        <span class="stat-icon">👥</span>
                        <div class="stat-number" id="totalClientes"><%= totalClientes != null ? totalClientes : 0 %></div>
                        <div class="stat-label">Total de Clientes</div>
                    </div>
                    <div class="stat-card floating" style="animation-delay: 0.2s;">
                        <span class="stat-icon">📧</span>
                        <div class="stat-number" id="clientesConEmail"><%= clientesConEmail %></div>
                        <div class="stat-label">Con Email</div>
                    </div>
                    <div class="stat-card floating" style="animation-delay: 0.4s;">
                        <span class="stat-icon">📞</span>
                        <div class="stat-number" id="clientesConTelefono"><%= clientesConTelefono %></div>
                        <div class="stat-label">Con Teléfono</div>
                    </div>
                    <div class="stat-card floating" style="animation-delay: 0.6s;">
                        <span class="stat-icon">📊</span>
                        <div class="stat-number" id="porcentajeCompletos">
                            <%= totalClientes != null && totalClientes > 0 ? 
                                String.format("%.0f", (double)(clientesConEmail + clientesConTelefono) / (totalClientes * 2) * 100) : 0 %>%
                        </div>
                        <div class="stat-label">Datos Completos</div>
                    </div>
                </div>

                <!-- Tabla de clientes mejorada -->
                <% if (clientes != null && !clientes.isEmpty()) { %>
                    <div class="table-container">
                        <div class="table-wrapper">
                            <table>
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Información Personal</th>
                                        <th>Documento</th>
                                        <th>Contacto</th>
                                        <th>Dirección</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Cliente cliente : clientes) { %>
                                    <tr class="fade-in-row">
                                        <td>
                                            <span class="id-badge">#<%= cliente.getIdCliente() %></span>
                                        </td>
                                        <td>
                                            <div style="display: flex; flex-direction: column; gap: 4px;">
                                                <strong style="font-size: 1.1em; color: var(--text-dark);">
                                                    <%= cliente.getNombre() %> <%= cliente.getApellido() %>
                                                </strong>
                                                <small style="color: var(--text-light); font-size: 0.85em;">
                                                    ID: <%= cliente.getIdCliente() %>
                                                </small>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="dni-badge">📋 <%= cliente.getDniRuc() %></span>
                                        </td>
                                        <td>
                                            <div style="display: flex; flex-direction: column; gap: 8px;">
                                                <% if (cliente.getEmail() != null && !cliente.getEmail().isEmpty()) { %>
                                                    <div class="contact-info">📧 <%= cliente.getEmail() %></div>
                                                <% } else { %>
                                                    <span class="no-data">📧 No registrado</span>
                                                <% } %>
                                                <% if (cliente.getTelefono() != null && !cliente.getTelefono().isEmpty()) { %>
                                                    <div class="contact-info">📞 <%= cliente.getTelefono() %></div>
                                                <% } else { %>
                                                    <span class="no-data">📞 No registrado</span>
                                                <% } %>
                                            </div>
                                        </td>
                                        <td>
                                            <% if (cliente.getDireccion() != null && !cliente.getDireccion().isEmpty()) { %>
                                                <div class="contact-info">📍 <%= cliente.getDireccion() %></div>
                                            <% } else { %>
                                                <span class="no-data">📍 No registrada</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="MascotaControlador?accion=obtenerPorCliente&idCliente=<%= cliente.getIdCliente() %>" 
                                                   class="btn-pets" 
                                                   title="Ver mascotas de <%= cliente.getNombre() %> <%= cliente.getApellido() %>"
                                                   onclick="return confirmarVerMascotas('<%= cliente.getNombre() %> <%= cliente.getApellido() %>')">
                                                    🐾 Mascotas
                                                </a>
                                                <a href="ClienteControlador?accion=editar&id=<%= cliente.getIdCliente() %>" 
                                                   class="btn-edit"
                                                   title="Editar cliente">
                                                    ✏️ Editar
                                                </a>
                                                <a href="ClienteControlador?accion=eliminar&id=<%= cliente.getIdCliente() %>" 
                                                   class="btn-delete"
                                                   title="Eliminar cliente"
                                                   onclick="return confirmarEliminacion('<%= cliente.getNombre() %> <%= cliente.getApellido() %>')">
                                                    🗑️ Eliminar
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Resumen de resultados -->
                    <div class="info" style="margin: 20px 0;">
                        <strong>📋 Resumen:</strong> Mostrando <strong><%= clientes.size() %></strong> 
                        <%= clientes.size() == 1 ? "cliente" : "clientes" %> 
                        <% if (request.getParameter("termino") != null && !request.getParameter("termino").isEmpty()) { %>
                            para la búsqueda: "<strong><%= request.getParameter("termino") %></strong>"
                        <% } %>
                    </div>

                <% } else if (clientes != null && clientes.isEmpty()) { %>
                    <div class="empty-state">
                        <span class="empty-state-icon">👥</span>
                        <h3>No hay clientes registrados</h3>
                        <p>
                            <% if (request.getParameter("termino") != null && !request.getParameter("termino").isEmpty()) { %>
                                No se encontraron clientes que coincidan con tu búsqueda: 
                                "<strong><%= request.getParameter("termino") %></strong>"
                            <% } else { %>
                                Comienza agregando tu primer cliente al sistema. Los clientes son esenciales para gestionar 
                                las mascotas y programar citas en tu veterinaria.
                            <% } %>
                        </p>
                        <a href="InsertarCliente.jsp" class="btn btn-primary btn-large">
                            <span>➕ Agregar Primer Cliente</span>
                        </a>
                        <% if (request.getParameter("termino") != null && !request.getParameter("termino").isEmpty()) { %>
                            <a href="ClienteControlador" class="btn btn-secondary" style="margin-top: 15px;">
                                <span>🔄 Ver todos los clientes</span>
                            </a>
                        <% } %>
                    </div>
                <% } %>

                <!-- Navegación mejorada -->
                <div class="navigation">
                    <a href="InsertarCliente.jsp" class="btn btn-success">
                        <span>➕ Nuevo Cliente</span>
                    </a>
                    <a href="ClienteControlador?accion=listarFrecuentes" class="btn btn-primary">
                        <span>🏆 Clientes Frecuentes</span>
                    </a>
                    <a href="BuscarClientes.jsp" class="btn btn-primary">
                        <span>🔍 Búsqueda Avanzada</span>
                    </a>
                    <a href="dashboard.jsp" class="btn btn-secondary">
                        <span>📊 Volver al Dashboard</span>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Script mejorado para manejar la interacción
        document.addEventListener('DOMContentLoaded', function() {
            const menuItems = document.querySelectorAll('.menu-item');
            
            menuItems.forEach(item => {
                item.addEventListener('click', function() {
                    menuItems.forEach(i => i.classList.remove('active'));
                    this.classList.add('active');
                });
            });

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

            // Focus en el campo de búsqueda
            const searchInput = document.getElementById('searchInput');
            if (searchInput) {
                setTimeout(() => {
                    searchInput.focus();
                    // Seleccionar texto si ya hay una búsqueda
                    if (searchInput.value) {
                        searchInput.select();
                    }
                }, 500);
            }

            // Búsqueda en tiempo real con debounce
            let searchTimeout;
            if (searchInput) {
                searchInput.addEventListener('input', function() {
                    clearTimeout(searchTimeout);
                    searchTimeout = setTimeout(() => {
                        if (this.value.length >= 3 || this.value.length === 0) {
                            // Mostrar loading
                            const submitBtn = document.querySelector('#searchForm button[type="submit"]');
                            const originalText = submitBtn.innerHTML;
                            submitBtn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Buscando...';
                            
                            document.getElementById('searchForm').submit();
                        }
                    }, 800);
                });
            }

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

            // Animar contadores al cargar la página
            setTimeout(() => {
                const totalElement = document.getElementById('totalClientes');
                const emailElement = document.getElementById('clientesConEmail');
                const phoneElement = document.getElementById('clientesConTelefono');
                
                if (totalElement) animateCounter(totalElement, <%= totalClientes != null ? totalClientes : 0 %>);
                if (emailElement) animateCounter(emailElement, <%= clientesConEmail %>);
                if (phoneElement) animateCounter(phoneElement, <%= clientesConTelefono %>);
            }, 1000);

            // Efectos hover mejorados para botones de acción
            const actionButtons = document.querySelectorAll('.btn-pets, .btn-edit, .btn-delete');
            actionButtons.forEach(button => {
                button.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-3px) scale(1.05)';
                });
                button.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0) scale(1)';
                });
            });

            // Agregar tooltips dinámicos
            actionButtons.forEach(button => {
                button.addEventListener('mouseenter', function(e) {
                    const tooltip = document.createElement('div');
                    tooltip.className = 'tooltip';
                    tooltip.textContent = this.getAttribute('title');
                    tooltip.style.cssText = `
                        position: absolute;
                        background: var(--text-dark);
                        color: white;
                        padding: 8px 12px;
                        border-radius: 6px;
                        font-size: 0.8em;
                        z-index: 1000;
                        white-space: nowrap;
                        pointer-events: none;
                        transform: translateY(-100%);
                        margin-top: -10px;
                    `;
                    document.body.appendChild(tooltip);
                    
                    const rect = this.getBoundingClientRect();
                    tooltip.style.left = (rect.left + rect.width / 2 - tooltip.offsetWidth / 2) + 'px';
                    tooltip.style.top = (rect.top - 10) + 'px';
                    
                    this._tooltip = tooltip;
                });
                
                button.addEventListener('mouseleave', function() {
                    if (this._tooltip) {
                        this._tooltip.remove();
                    }
                });
            });
        });

        // Función para confirmar antes de ver mascotas
        function confirmarVerMascotas(nombreCliente) {
            return confirm(`¿Está seguro de que desea ver las mascotas de ${nombreCliente}?`);
        }

        // Función para confirmar eliminación
        function confirmarEliminacion(nombreCliente) {
            return confirm(`¿Está seguro de que desea eliminar al cliente ${nombreCliente}?\n\nEsta acción no se puede deshacer y también eliminará todas sus mascotas asociadas.`);
        }

        // Función para exportar datos (placeholder)
        function exportarClientes() {
            if (confirm('¿Desea exportar la lista de clientes a Excel?')) {
                // Simular exportación
                const exportBtn = document.querySelector('.btn-export');
                const originalText = exportBtn.innerHTML;
                exportBtn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Exportando...';
                
                setTimeout(() => {
                    exportBtn.innerHTML = originalText;
                    alert('✅ Lista de clientes exportada correctamente');
                }, 2000);
            }
        }

        // Función para filtrar tabla
        function filtrarTabla() {
            const filtro = document.getElementById('filtroEstado').value;
            const filas = document.querySelectorAll('tbody tr');
            
            filas.forEach(fila => {
                if (filtro === 'todos') {
                    fila.style.display = '';
                } else {
                    // Aquí puedes implementar lógica de filtrado específica
                    fila.style.display = '';
                }
            });
        }

        // Agregar funcionalidad de selección múltiple
        let selectedClients = new Set();

        function toggleClientSelection(clientId) {
            if (selectedClients.has(clientId)) {
                selectedClients.delete(clientId);
            } else {
                selectedClients.add(clientId);
            }
            updateSelectionCounter();
        }

        function updateSelectionCounter() {
            const counter = document.getElementById('selectionCounter');
            if (counter) {
                counter.textContent = selectedClients.size;
                counter.style.display = selectedClients.size > 0 ? 'inline' : 'none';
            }
        }

        // Inicializar contador de selección
        document.addEventListener('DOMContentLoaded', function() {
            const selectionCounter = document.createElement('span');
            selectionCounter.id = 'selectionCounter';
            selectionCounter.style.cssText = `
                background: var(--primary-color);
                color: white;
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 0.8em;
                margin-left: 10px;
                display: none;
            `;
            
            const header = document.querySelector('.welcome h1');
            if (header) {
                header.appendChild(selectionCounter);
            }
        });
    </script>
</body>
</html>