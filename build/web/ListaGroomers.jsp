<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, modelo.Groomer" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Groomers - Sistema PetCare</title>
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

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        /* Stats Card */
        .stats-card {
            background: var(--white);
            padding: 30px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
            border-left: 4px solid var(--primary-color);
            display: flex;
            align-items: center;
            gap: 20px;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
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

        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
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

        /* Status Badges */
        .id-badge {
            background: var(--primary-light);
            color: var(--text-dark);
            padding: 8px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.85em;
            display: inline-block;
        }

        .especialidades-list {
            font-size: 0.9em;
            line-height: 1.5;
            color: var(--text-dark);
        }

        .disponibilidad-info {
            font-size: 0.85em;
            line-height: 1.5;
            color: var(--text-dark);
        }

        .disponibilidad-item {
            margin-bottom: 6px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .fecha-badge {
            background: #f8f9fa;
            color: var(--text-light);
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8em;
            border: 1px solid #e9ecef;
            display: inline-block;
        }

        /* Action Buttons Table */
        .action-buttons-table {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn-action {
            padding: 10px 16px;
            border: none;
            border-radius: var(--radius);
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-weight: 500;
            transition: all 0.3s ease;
            font-size: 0.85em;
            position: relative;
            overflow: hidden;
        }

        .btn-action::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.6s;
        }

        .btn-action:hover::before {
            left: 100%;
        }

        .btn-action-primary {
            background: var(--gradient-primary);
            color: var(--white);
            box-shadow: 0 4px 15px rgba(171, 203, 213, 0.3);
        }

        .btn-action-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(171, 203, 213, 0.4);
        }

        .btn-action-warning {
            background: var(--gradient-warning);
            color: var(--text-dark);
            box-shadow: 0 4px 15px rgba(255, 193, 7, 0.3);
        }

        .btn-action-warning:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(255, 193, 7, 0.4);
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

        .no-data {
            color: var(--text-light);
            font-style: italic;
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
            .action-buttons {
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
            .btn {
                width: 100%;
                justify-content: center;
            }
            .action-buttons-table {
                flex-direction: column;
                gap: 8px;
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
                    <a href="<%= request.getContextPath() %>/ClienteControlador?accion=listarTodos">
                        <span class="menu-icon">👥</span>
                        <span>Clientes</span>
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
                <li class="menu-item active">
                    <a href="GroomerControlador"">
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
                        <h1>✂️ Lista de Groomers</h1>
                        <p>Gestión completa del personal de grooming</p>
                    </div>
                    <div class="header-actions">
                        <a href="GroomerControlador?accion=formularioInsertar" class="btn btn-success">➕ Nuevo Groomer</a>
                        <a href="Menu.jsp" class="btn btn-secondary">🏠 Menú Principal</a>
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

                <!-- Botones de acciones -->
                <div class="action-buttons">
                    <a href="GroomerControlador?accion=formularioInsertar" class="btn btn-success">➕ Nuevo Groomer</a>
                    <a href="GroomerControlador?accion=tiemposPromedio" class="btn btn-info">⏱️ Tiempos Promedio</a>
                    <a href="GroomerControlador?accion=ocupacion" class="btn btn-primary">📊 Ocupación</a>
                    <a href="GroomerControlador?accion=disponibilidad" class="btn btn-warning">📅 Disponibilidad</a>
                    <a href="GroomerControlador" class="btn btn-secondary">🔄 Actualizar Lista</a>
                </div>

                <%
                    List<Groomer> groomers = (List<Groomer>) request.getAttribute("groomers");
                    Integer totalGroomers = (Integer) request.getAttribute("totalGroomers");
                %>

                <!-- Estadísticas -->
                <div class="stats-card">
                    <div class="stats-icon">👥</div>
                    <div class="stats-content">
                        <h3>Resumen de Groomers</h3>
                        <p><strong>Total de groomers activos:</strong> <%= totalGroomers != null ? totalGroomers : 0 %></p>
                        <p><em>Personal especializado en cuidado de mascotas</em></p>
                    </div>
                </div>

                <!-- Tabla de groomers -->
                <% if (groomers != null && !groomers.isEmpty()) { %>
                    <div class="table-container">
                        <div class="table-wrapper">
                            <table>
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Nombre</th>
                                        <th>Especialidades</th>
                                        <th>Disponibilidad</th>
                                        <th>Fecha Registro</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Groomer groomer : groomers) { %>
                                        <tr>
                                            <td><span class="id-badge"><%= groomer.getIdGroomer() %></span></td>
                                            <td>
                                                <strong>✂️ <%= groomer.getNombre() != null ? groomer.getNombre() : "<span class='no-data'>N/A</span>" %></strong>
                                            </td>
                                            <td>
                                                <% 
                                                String especialidadesTexto = "N/A";
                                                if (groomer.getEspecialidades() != null && !groomer.getEspecialidades().isEmpty()) {
                                                    if (!groomer.getEspecialidades().startsWith("[")) {
                                                        especialidadesTexto = groomer.getEspecialidades();
                                                    } else {
                                                        try {
                                                            String esp = groomer.getEspecialidades()
                                                                .replace("[", "").replace("]", "").replace("\"", "").trim();
                                                            especialidadesTexto = esp.isEmpty() ? "N/A" : esp;
                                                        } catch (Exception e) {
                                                            especialidadesTexto = "Error";
                                                        }
                                                    }
                                                }
                                                %>
                                                <div class="especialidades-list"><%= especialidadesTexto %></div>
                                            </td>
                                            <td>
                                                <% 
                                                String disponibilidadTexto = "No configurada";
                                                if (groomer.getDisponibilidad() != null && !groomer.getDisponibilidad().isEmpty()) {
                                                    String disp = groomer.getDisponibilidad();
                                                    
                                                    // Parsear el formato específico: {"dias":["lunes","martes",...],"horaInicio":"08:00","horaFin":"17:00","tiempoCita":60}
                                                    try {
                                                        int diasCount = 0;
                                                        String horaInicio = "";
                                                        String horaFin = "";
                                                        String tiempoCita = "";
                                                        
                                                        // 1. Contar días
                                                        if (disp.contains("\"dias\":[")) {
                                                            int start = disp.indexOf("\"dias\":[") + 8;
                                                            int end = disp.indexOf("]", start);
                                                            if (start > 7 && end > start) {
                                                                String diasStr = disp.substring(start, end);
                                                                // Contar elementos separados por coma
                                                                if (!diasStr.trim().isEmpty()) {
                                                                    String[] diasArray = diasStr.split(",");
                                                                    diasCount = diasArray.length;
                                                                }
                                                            }
                                                        }
                                                        
                                                        // 2. Extraer horaInicio
                                                        if (disp.contains("\"horaInicio\":\"")) {
                                                            int start = disp.indexOf("\"horaInicio\":\"") + 14;
                                                            int end = disp.indexOf("\"", start);
                                                            if (start > 13 && end > start) {
                                                                horaInicio = disp.substring(start, end);
                                                            }
                                                        }
                                                        
                                                        // 3. Extraer horaFin
                                                        if (disp.contains("\"horaFin\":\"")) {
                                                            int start = disp.indexOf("\"horaFin\":\"") + 11;
                                                            int end = disp.indexOf("\"", start);
                                                            if (start > 10 && end > start) {
                                                                horaFin = disp.substring(start, end);
                                                            }
                                                        }
                                                        
                                                        // 4. Extraer tiempoCita (número sin comillas)
                                                        if (disp.contains("\"tiempoCita\":")) {
                                                            int start = disp.indexOf("\"tiempoCita\":") + 12;
                                                            int end = disp.indexOf(",", start);
                                                            if (end == -1) end = disp.indexOf("}", start);
                                                            if (start > 11 && end > start) {
                                                                tiempoCita = disp.substring(start, end).trim();
                                                            }
                                                        }
                                                        
                                                        // Construir texto informativo
                                                        StringBuilder info = new StringBuilder();
                                                        
                                                        if (diasCount > 0) {
                                                            info.append("<div class='disponibilidad-item'>📅 ").append(diasCount);
                                                            if (diasCount == 1) {
                                                                info.append(" día");
                                                            } else if (diasCount == 7) {
                                                                info.append(" días (toda la semana)");
                                                            } else {
                                                                info.append(" días");
                                                            }
                                                            info.append("</div>");
                                                        } else {
                                                            info.append("<div class='disponibilidad-item'>📅 Sin días específicos</div>");
                                                        }
                                                        
                                                        if (!horaInicio.isEmpty() && !horaFin.isEmpty()) {
                                                            info.append("<div class='disponibilidad-item'>🕐 ").append(horaInicio).append(" - ").append(horaFin).append("</div>");
                                                        }
                                                        
                                                        if (!tiempoCita.isEmpty()) {
                                                            info.append("<div class='disponibilidad-item'>⏱️ ").append(tiempoCita).append(" min/cita</div>");
                                                        }
                                                        
                                                        disponibilidadTexto = info.toString();
                                                        
                                                    } catch (Exception e) {
                                                        disponibilidadTexto = "Error parseando disponibilidad";
                                                    }
                                                }
                                                %>
                                                <div class="disponibilidad-info"><%= disponibilidadTexto %></div>
                                            </td>
                                            <td>
                                                <% 
                                                if (groomer.getCreatedAt() != null) {
                                                    String fecha = groomer.getCreatedAt().toString();
                                                    if (fecha.contains(" ")) {
                                                        out.print("<span class='fecha-badge'>" + fecha.split(" ")[0] + "</span>");
                                                    } else {
                                                        out.print("<span class='fecha-badge'>" + fecha + "</span>");
                                                    }
                                                } else {
                                                    out.print("<span class='no-data'>N/A</span>");
                                                }
                                                %>
                                            </td>
                                            <td>
                                                <div class="action-buttons-table">
                                                    <a href="GroomerControlador?accion=formularioActualizar&idGroomer=<%= groomer.getIdGroomer() %>" 
                                                       class="btn-action btn-action-warning"
                                                       title="Modificar groomer">
                                                        ✏️ Modificar
                                                    </a>
                                                    <a href="GroomerControlador?accion=verDetalles&idGroomer=<%= groomer.getIdGroomer() %>" 
                                                       class="btn-action btn-action-primary"
                                                       title="Ver detalles">
                                                        👁️ Detalles
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                <% } else { %>
                    <div class="empty-state">
                        <h3>✂️ No hay groomers registrados</h3>
                        <p>Comienza agregando el primer groomer al sistema</p>
                        <a href="GroomerControlador?accion=formularioInsertar" class="btn btn-success">➕ Agregar Primer Groomer</a>
                    </div>
                <% } %>

                <!-- Navegación -->
                <div class="navigation">
                    <a href="GroomerControlador?accion=formularioInsertar" class="btn btn-success">➕ Nuevo Groomer</a>
                    <a href="Menu.jsp" class="btn btn-secondary">🏠 Menú Principal</a>
                    <a href="CitaControlador?accion=todasCitas" class="btn btn-primary">📅 Gestión de Citas</a>
                    <a href="AtencionControlador" class="btn btn-warning">🎯 Panel de Atención</a>
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
            
            // Agregar efectos hover a los botones de acción
            const actionButtons = document.querySelectorAll('.btn-action');
            actionButtons.forEach(button => {
                button.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-2px)';
                });
                button.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                });
            });

            // Función para filtrar groomers por disponibilidad
            function filtrarGroomers(filtro) {
                const rows = document.querySelectorAll('tbody tr');
                rows.forEach(row => {
                    const disponibilidadInfo = row.querySelector('.disponibilidad-info');
                    if (filtro === 'todos') {
                        row.style.display = '';
                    } else if (filtro === 'disponibles' && disponibilidadInfo.textContent.includes('días')) {
                        row.style.display = '';
                    } else if (filtro === 'no-configurados' && disponibilidadInfo.textContent.includes('No configurada')) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            }

            // Agregar filtros si hay datos
            <% if (groomers != null && !groomers.isEmpty()) { %>
            document.addEventListener('DOMContentLoaded', function() {
                const tableContainer = document.querySelector('.table-container');
                const filterDiv = document.createElement('div');
                filterDiv.style.marginBottom = '15px';
                filterDiv.style.display = 'flex';
                filterDiv.style.gap = '10px';
                filterDiv.style.alignItems = 'center';
                filterDiv.style.flexWrap = 'wrap';
                filterDiv.innerHTML = `
                    <strong>Filtrar por disponibilidad:</strong>
                    <button onclick="filtrarGroomers('todos')" class="btn btn-small">Todos</button>
                    <button onclick="filtrarGroomers('disponibles')" class="btn btn-small">📅 Con Disponibilidad</button>
                    <button onclick="filtrarGroomers('no-configurados')" class="btn btn-small">⚠️ Sin Configurar</button>
                `;
                tableContainer.parentNode.insertBefore(filterDiv, tableContainer);
            });
            <% } %>
        });

        // Función para exportar lista de groomers
        function exportarGroomers() {
            alert('📊 Exportando lista de groomers...\nFormato: CSV\nTotal: <%= totalGroomers != null ? totalGroomers : 0 %> groomers');
            // Aquí iría la lógica real de exportación
        }

        // Función para generar reporte de productividad
        function generarReporteProductividad() {
            alert('📈 Generando reporte de productividad...\nIncluye:\n• Tiempos promedio por servicio\n• Ocupación semanal\n• Disponibilidad por groomer');
        }
    </script>
</body>
</html>