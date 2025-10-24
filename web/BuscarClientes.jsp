<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, modelo.Cliente"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Búsqueda Avanzada de Clientes - Sistema PetCare</title>
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

        .mensaje {
            padding: 20px 25px;
            margin: 0 0 30px 0;
            border-radius: var(--radius);
            border-left: 6px solid;
            font-size: 1em;
            box-shadow: var(--shadow);
            background: var(--white);
            border: 1px solid rgba(0, 0, 0, 0.05);
            animation: slideInUp 0.6s ease-out;
        }

        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .exito {
            background: linear-gradient(135deg, rgba(76, 175, 80, 0.1) 0%, rgba(76, 175, 80, 0.05) 100%);
            border-left-color: var(--success-color);
            color: #2e7d32;
        }

        .error {
            background: linear-gradient(135deg, rgba(244, 67, 54, 0.1) 0%, rgba(244, 67, 54, 0.05) 100%);
            border-left-color: var(--danger-color);
            color: #c62828;
        }

        .info {
            background: linear-gradient(135deg, rgba(33, 150, 243, 0.1) 0%, rgba(33, 150, 243, 0.05) 100%);
            border-left-color: var(--info-color);
            color: #1565c0;
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

        .btn-info {
            background: linear-gradient(135deg, var(--info-color) 0%, #0b7dda 100%);
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

        .search-box {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            padding: 30px;
            margin-bottom: 30px;
            border: 1px solid rgba(0, 0, 0, 0.05);
            animation: fadeInUp 0.8s ease-out;
            position: relative;
            overflow: hidden;
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

        .search-box::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 120px;
            height: 120px;
            background: linear-gradient(45deg, transparent, rgba(171, 203, 213, 0.1), transparent);
            transform: translate(30px, -30px) rotate(45deg);
        }

        .search-form {
            display: flex;
            gap: 15px;
            align-items: center;
            position: relative;
            z-index: 1;
        }

        .search-input {
            flex: 1;
            padding: 15px 20px;
            border: 2px solid rgba(0, 0, 0, 0.1);
            border-radius: var(--radius);
            font-size: 1.1em;
            transition: all 0.3s ease;
            background: var(--bg-light);
        }

        .search-input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(171, 203, 213, 0.2);
            background: var(--white);
            transform: translateY(-2px);
        }

        .search-tips {
            margin-top: 15px;
            color: var(--text-light);
            font-size: 0.9em;
            display: flex;
            align-items: center;
            gap: 8px;
            position: relative;
            z-index: 1;
        }

        .stats-card {
            background: var(--white);
            padding: 25px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
            border: 1px solid rgba(0, 0, 0, 0.05);
            display: flex;
            align-items: center;
            gap: 20px;
            animation: fadeInUp 0.8s ease-out;
            position: relative;
            overflow: hidden;
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
            font-size: 2.5em;
            color: var(--primary-color);
        }

        .stats-content h3 {
            color: var(--text-dark);
            margin-bottom: 8px;
            font-size: 1.3em;
            font-weight: 700;
        }

        .stats-content p {
            color: var(--text-light);
            font-size: 1em;
            line-height: 1.6;
        }

        .results-box {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            padding: 30px;
            margin-bottom: 30px;
            border: 1px solid rgba(0, 0, 0, 0.05);
            animation: fadeInUp 0.8s ease-out;
        }

        .results-title {
            color: var(--text-dark);
            margin-bottom: 25px;
            font-size: 1.5em;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .table-container {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 40px;
            border: 1px solid rgba(0, 0, 0, 0.05);
            animation: fadeInUp 0.8s ease-out;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: var(--gradient-primary);
            color: var(--white);
            font-weight: 700;
            padding: 20px;
            text-align: left;
            position: sticky;
            top: 0;
            font-size: 0.95em;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        td {
            padding: 18px 20px;
            text-align: left;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }

        tr {
            transition: all 0.3s ease;
        }

        tr:hover {
            background: rgba(171, 203, 213, 0.05);
        }

        tr:hover td {
            transform: translateX(5px);
        }

        .id-badge {
            background: linear-gradient(135deg, var(--primary-light) 0%, var(--primary-color) 100%);
            color: var(--text-dark);
            padding: 8px 12px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.85em;
            border: 2px solid var(--primary-color);
        }

        .dni-badge {
            background: linear-gradient(135deg, #e8f4f8 0%, var(--primary-light) 100%);
            color: var(--text-dark);
            padding: 8px 12px;
            border-radius: 20px;
            font-family: 'Courier New', monospace;
            font-size: 0.85em;
            font-weight: 600;
            border: 2px solid var(--primary-color);
        }

        .contact-info {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--text-light);
            font-size: 0.9em;
            transition: all 0.3s ease;
        }

        tr:hover .contact-info {
            color: var(--text-dark);
        }

        .empty-state {
            text-align: center;
            padding: 80px 40px;
            color: var(--text-light);
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            border: 2px dashed var(--primary-light);
            animation: fadeInUp 0.8s ease-out;
        }

        .empty-state h3 {
            font-size: 2em;
            margin-bottom: 20px;
            color: var(--text-dark);
        }

        .empty-state p {
            font-size: 1.1em;
            margin-bottom: 30px;
            color: var(--text-light);
        }

        .suggestions {
            text-align: left;
            max-width: 500px;
            margin: 0 auto;
            background: var(--bg-light);
            padding: 25px;
            border-radius: var(--radius);
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .suggestions p {
            font-weight: 600;
            margin-bottom: 15px;
            color: var(--text-dark);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .suggestions ul {
            list-style: none;
            padding: 0;
        }

        .suggestions li {
            padding: 10px 0;
            display: flex;
            align-items: center;
            gap: 10px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        }

        .suggestions li:last-child {
            border-bottom: none;
        }

        .navigation {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
            flex-wrap: wrap;
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
            .search-form {
                flex-direction: column;
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
            .btn {
                width: 100%;
                justify-content: center;
            }
            .search-box {
                padding: 20px;
            }
            .empty-state {
                padding: 40px 20px;
            }
        }

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

        .highlight {
            background-color: #FFEB3B;
            padding: 2px 4px;
            border-radius: 4px;
            font-weight: 600;
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
                    <p>Administrador</p>
                </div>
            </div>
            
            <ul class="menu">
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
                <li class="menu-item active">
                    <a href="BuscarClientes.jsp">
                        <span class="menu-icon">🔍</span>
                        <span>Búsqueda Avanzada</span>
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
                
                <div class="menu-section">Sistema</div>
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
                        <h1>🔍 Búsqueda Avanzada de Clientes</h1>
                        <p>Encuentra clientes específicos usando múltiples criterios de búsqueda</p>
                    </div>
                    <div class="header-actions">
                        <a href="InsertarCliente.jsp" class="btn btn-success">➕ Nuevo Cliente</a>
                        <a href="<%= request.getContextPath() %>/ClienteControlador?accion=listarTodos" class="btn btn-info">👥 Todos los Clientes</a>
                    </div>
                </div>
            </div>

            <div class="main-content">
                <% 
                    String mensaje = (String) request.getAttribute("mensaje");
                    String terminoBusqueda = (String) request.getAttribute("terminoBusqueda");
                    Integer totalResultados = (Integer) request.getAttribute("totalResultados");
                    List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");
                %>
                
                <% if (mensaje != null) { %>
                    <div class="mensaje <%= mensaje.contains("✅") ? "exito" : mensaje.contains("❌") ? "error" : "info" %>">
                        <%= mensaje %>
                    </div>
                <% } %>
                
                <div class="search-box">
                    <form action="ClienteControlador" method="POST" class="search-form" id="searchForm">
                        <input type="hidden" name="accion" value="buscar">
                        <input type="text" name="termino" 
                               value="<%= terminoBusqueda != null ? terminoBusqueda : "" %>" 
                               placeholder="🔍 Buscar por nombre, apellido, email, teléfono, DNI..." 
                               class="search-input" id="searchInput">
                        <button type="submit" class="btn btn-primary">🔍 Buscar</button>
                    </form>
                    <div class="search-tips">
                        💡 Puedes buscar por cualquier campo: nombre, apellido, email, teléfono o DNI
                    </div>
                </div>

                <% if (totalResultados != null && terminoBusqueda != null) { %>
                    <div class="stats-card">
                        <div class="stats-icon">📊</div>
                        <div class="stats-content">
                            <h3>Resultados de la Búsqueda</h3>
                            <p><strong>Término buscado:</strong> "<%= terminoBusqueda %>"</p>
                            <p><strong>Clientes encontrados:</strong> <%= totalResultados %></p>
                            <p><strong>Tiempo de búsqueda:</strong> &lt; 1 segundo</p>
                        </div>
                    </div>
                <% } %>

                <% if (clientes != null && !clientes.isEmpty()) { %>
                    <div class="results-box">
                        <h3 class="results-title">📋 Clientes Encontrados</h3>
                        <div class="table-container">
                            <table>
                                <thead>
                                    <tr>
                                        <th style="width: 80px;">ID</th>
                                        <th>Nombre</th>
                                        <th>Apellido</th>
                                        <th style="width: 140px;">DNI/RUC</th>
                                        <th>Email</th>
                                        <th>Teléfono</th>
                                        <th>Dirección</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Cliente cliente : clientes) { %>
                                    <tr>
                                        <td>
                                            <span class="id-badge"><%= cliente.getIdCliente() %></span>
                                        </td>
                                        <td>
                                            <strong style="color: var(--text-dark); font-size: 1.05em;">
                                                <%= cliente.getNombre() %>
                                            </strong>
                                        </td>
                                        <td>
                                            <strong style="color: var(--text-dark); font-size: 1.05em;">
                                                <%= cliente.getApellido() %>
                                            </strong>
                                        </td>
                                        <td>
                                            <span class="dni-badge"><%= cliente.getDniRuc() %></span>
                                        </td>
                                        <td>
                                            <% if (cliente.getEmail() != null && !cliente.getEmail().isEmpty()) { %>
                                                <div class="contact-info">📧 <%= cliente.getEmail() %></div>
                                            <% } else { %>
                                                <span style="color: var(--text-light); font-style: italic;">No registrado</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <% if (cliente.getTelefono() != null && !cliente.getTelefono().isEmpty()) { %>
                                                <div class="contact-info">📞 <%= cliente.getTelefono() %></div>
                                            <% } else { %>
                                                <span style="color: var(--text-light); font-style: italic;">No registrado</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <% if (cliente.getDireccion() != null && !cliente.getDireccion().isEmpty()) { %>
                                                <div class="contact-info">📍 <%= cliente.getDireccion() %></div>
                                            <% } else { %>
                                                <span style="color: var(--text-light); font-style: italic;">No registrada</span>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                <% } else if (clientes != null && clientes.isEmpty() && terminoBusqueda != null) { %>
                    <div class="empty-state">
                        <h3>🔍 No se encontraron clientes</h3>
                        <p>No hay clientes que coincidan con "<strong><%= terminoBusqueda %></strong>"</p>
                        <div class="suggestions">
                            <p>💡 Sugerencias para mejorar tu búsqueda:</p>
                            <ul>
                                <li>✅ Verifica la ortografía de los términos</li>
                                <li>🔍 Intenta con términos más generales</li>
                                <li>👥 Busca por nombre, apellido, email o teléfono</li>
                                <li>📝 Usa solo una parte del nombre o apellido</li>
                                <li>🔢 Verifica el formato del DNI o teléfono</li>
                            </ul>
                        </div>
                    </div>
                <% } %>

                <div class="navigation">
                    <a href="InsertarCliente.jsp" class="btn btn-success">➕ Nuevo Cliente</a>
                    <a href="ClienteControlador?accion=listarFrecuentes" class="btn btn-info">🏆 Clientes Frecuentes</a>
                    <a href="<%= request.getContextPath() %>/ClienteControlador?accion=listarTodos" class="btn btn-primary">👥 Todos los Clientes</a>
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
                row.style.transform = 'translateY(30px)';
                
                setTimeout(() => {
                    row.style.transition = 'all 0.6s cubic-bezier(0.4, 0, 0.2, 1)';
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

            // Búsqueda en tiempo real
            const searchInput = document.getElementById('searchInput');
            const searchForm = document.getElementById('searchForm');
            
            if (searchInput) {
                let timeoutId;
                searchInput.addEventListener('input', function() {
                    clearTimeout(timeoutId);
                    if (this.value.length >= 3 || this.value.length === 0) {
                        timeoutId = setTimeout(() => {
                            // Mostrar loading
                            const submitBtn = searchForm.querySelector('button[type="submit"]');
                            const originalText = submitBtn.innerHTML;
                            submitBtn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Buscando...';
                            
                            setTimeout(() => {
                                searchForm.submit();
                            }, 500);
                        }, 800);
                    }
                });
            }

            // Focus en el campo de búsqueda al cargar la página
            setTimeout(() => {
                if (searchInput) {
                    searchInput.focus();
                    // Seleccionar el texto si ya hay un término de búsqueda
                    if (searchInput.value) {
                        searchInput.select();
                    }
                }
            }, 1000);

            // Resaltar términos de búsqueda en los resultados
            function highlightSearchTerms() {
                const searchTerm = '<%= terminoBusqueda != null ? terminoBusqueda : "" %>';
                if (searchTerm && searchTerm.length >= 2) {
                    const cells = document.querySelectorAll('td');
                    const regex = new RegExp(searchTerm, 'gi');
                    
                    cells.forEach(cell => {
                        const originalContent = cell.innerHTML;
                        const highlightedContent = originalContent.replace(
                            regex,
                            match => `<span class="highlight">${match}</span>`
                        );
                        cell.innerHTML = highlightedContent;
                    });
                }
            }

            // Aplicar resaltado después de un pequeño delay
            setTimeout(highlightSearchTerms, 100);
        });

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

        // Agregar evento de loading a los botones de navegación
        const navButtons = document.querySelectorAll('.navigation .btn, .header-actions .btn');
        navButtons.forEach(button => {
            button.addEventListener('click', function(e) {
                if (this.href && !this.href.includes('javascript')) {
                    showLoading(this);
                }
            });
        });

        // Búsqueda rápida con Enter
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && document.activeElement.classList.contains('search-input')) {
                e.preventDefault();
                document.querySelector('.search-form').submit();
            }
        });
    </script>
</body>
</html>
