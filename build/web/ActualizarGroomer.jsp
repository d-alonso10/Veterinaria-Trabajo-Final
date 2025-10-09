<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Groomer, java.util.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Actualizar Groomer - Sistema PetCare</title>
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
            max-width: 800px;
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

        .btn-full {
            width: 100%;
            justify-content: center;
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

        /* Form Styles */
        .form-container {
            background: var(--white);
            padding: 40px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.8s ease-out;
        }

        .form-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-warning);
        }

        .form-header {
            text-align: center;
            margin-bottom: 40px;
            padding-bottom: 30px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        }

        .form-icon {
            font-size: 4em;
            margin-bottom: 20px;
            color: var(--warning-color);
            animation: pulse 2s infinite;
        }

        .form-header h2 {
            color: var(--text-dark);
            margin-bottom: 15px;
            font-size: 2em;
            font-weight: 700;
        }

        .form-header p {
            color: var(--text-light);
            font-size: 1.2em;
            line-height: 1.6;
        }

        .form-group {
            margin-bottom: 30px;
        }

        .form-group label {
            display: block;
            margin-bottom: 12px;
            font-weight: 600;
            color: var(--text-dark);
            font-size: 1em;
        }

        .form-control {
            width: 100%;
            padding: 16px 20px;
            border: 1px solid #e0e0e0;
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
            box-shadow: 0 0 0 3px rgba(171, 203, 213, 0.2);
        }

        textarea.form-control {
            height: 120px;
            resize: vertical;
            line-height: 1.6;
        }

        .form-help {
            font-size: 0.9em;
            color: var(--text-light);
            margin-top: 8px;
            font-style: italic;
            line-height: 1.4;
        }

        .required::after {
            content: " *";
            color: var(--danger-color);
        }

        /* Section Styles */
        .form-section {
            background: linear-gradient(135deg, #f8f9fa 0%, #f1f3f4 100%);
            padding: 30px;
            border-radius: var(--radius);
            margin-bottom: 30px;
            border-left: 4px solid var(--primary-color);
            transition: all 0.3s ease;
        }

        .form-section:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }

        .section-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
        }

        .section-icon {
            font-size: 1.5em;
            color: var(--primary-color);
        }

        .section-title {
            font-size: 1.3em;
            font-weight: 700;
            color: var(--text-dark);
        }

        /* Checkbox Grid */
        .dias-semana {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 15px;
            margin: 20px 0;
        }

        .dia-checkbox {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 15px;
            background: var(--white);
            border-radius: var(--radius);
            border: 1px solid #e0e0e0;
            transition: all 0.3s ease;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }

        .dia-checkbox::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(171, 203, 213, 0.1), transparent);
            transition: left 0.6s;
        }

        .dia-checkbox:hover::before {
            left: 100%;
        }

        .dia-checkbox:hover {
            border-color: var(--primary-color);
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }

        .dia-checkbox input[type="checkbox"] {
            margin: 0;
            transform: scale(1.3);
            accent-color: var(--primary-color);
        }

        .dia-checkbox label {
            margin: 0;
            font-weight: 600;
            cursor: pointer;
            flex: 1;
            color: var(--text-dark);
        }

        /* Time Inputs */
        .hora-input {
            display: flex;
            gap: 25px;
            align-items: center;
            margin: 20px 0;
            flex-wrap: wrap;
        }

        .hora-group {
            flex: 1;
            min-width: 180px;
        }

        .hora-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--text-dark);
        }

        /* Form Actions */
        .form-actions {
            display: flex;
            gap: 20px;
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid rgba(0, 0, 0, 0.05);
            flex-wrap: wrap;
        }

        .form-actions .btn {
            flex: 1;
            min-width: 180px;
        }

        /* Quick Actions */
        .quick-actions {
            display: flex;
            gap: 15px;
            margin: 20px 0;
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

        @keyframes pulse {
            0% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.05);
            }
            100% {
                transform: scale(1);
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
            .form-container {
                padding: 25px;
            }
            .dias-semana {
                grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            }
            .hora-input {
                flex-direction: column;
                gap: 20px;
            }
            .hora-group {
                width: 100%;
            }
            .form-actions {
                flex-direction: column;
            }
            .quick-actions {
                flex-direction: column;
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
                font-size: 1.6em;
            }
            .dias-semana {
                grid-template-columns: 1fr 1fr;
            }
            .section-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
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
                    <a href="ServicioControlador">
                        <span class="menu-icon">🛠️</span>
                        <span>Servicios</span>
                    </a>
                </li>
                
                <!-- Personal y Operaciones -->
                <div class="menu-section">Personal y Operaciones</div>
                <li class="menu-item active">
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
                    <a href="AuditControlador?accion=listar"></a>
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
                        <h1>✏️ Actualizar Groomer</h1>
                        <p>Modificar información del especialista en grooming</p>
                    </div>
                    <div class="header-actions">
                        <a href="GroomerControlador" class="btn btn-secondary">← Volver al Listado</a>
                    </div>
                </div>
            </div>

            <div class="main-content">
                <!-- Mensajes -->
                <% if (request.getAttribute("mensaje") != null) {%>
                <div class="mensaje <%= request.getAttribute("mensaje").toString().contains("✅") ? "exito" : "error"%>">
                    <%= request.getAttribute("mensaje")%>
                </div>
                <% } %>

                <%
                    Groomer groomer = (Groomer) request.getAttribute("groomer");
                    if (groomer != null) {

                        // Procesar especialidades existentes
                        List<String> especialidadesList = new ArrayList<>();
                        if (groomer.getEspecialidades() != null && !groomer.getEspecialidades().isEmpty()) {
                            try {
                                String esp = groomer.getEspecialidades()
                                        .replace("[", "").replace("]", "").replace("\"", "").trim();
                                if (!esp.isEmpty()) {
                                    String[] especialidadesArray = esp.split(",");
                                    for (String e : especialidadesArray) {
                                        if (!e.trim().isEmpty()) {
                                            especialidadesList.add(e.trim());
                                        }
                                    }
                                }
                            } catch (Exception e) {}
                        }

                        // Procesar disponibilidad existente
                        List<String> diasSeleccionados = new ArrayList<>();
                        String horaInicio = "08:00";
                        String horaFin = "17:00";
                        String tiempoCita = "60";

                        if (groomer.getDisponibilidad() != null && !groomer.getDisponibilidad().isEmpty()) {
                            try {
                                String disp = groomer.getDisponibilidad();
                                // Buscar días en el JSON
                                if (disp.contains("lunes")) diasSeleccionados.add("lunes");
                                if (disp.contains("martes")) diasSeleccionados.add("martes");
                                if (disp.contains("miercoles")) diasSeleccionados.add("miercoles");
                                if (disp.contains("jueves")) diasSeleccionados.add("jueves");
                                if (disp.contains("viernes")) diasSeleccionados.add("viernes");
                                if (disp.contains("sabado")) diasSeleccionados.add("sabado");
                                if (disp.contains("domingo")) diasSeleccionados.add("domingo");
                            } catch (Exception e) {}
                        }
                %>

                <div class="form-container">
                    <div class="form-header">
                        <div class="form-icon">✏️</div>
                        <h2>Actualizar Información del Groomer</h2>
                        <p>Modifica los datos del especialista en grooming</p>
                    </div>

                    <form action="GroomerControlador" method="POST" id="groomerForm">
                        <input type="hidden" name="idGroomer" value="<%= groomer.getIdGroomer()%>">
                        
                        <!-- Campos normales que el servidor puede procesar directamente -->
                        <input type="hidden" name="especialidades" id="especialidadesField">
                        <input type="hidden" name="disponibilidad" id="disponibilidadField">

                        <!-- Información Básica -->
                        <div class="form-section">
                            <div class="section-header">
                                <span class="section-icon">👤</span>
                                <span class="section-title">Información Básica</span>
                            </div>
                            
                            <div class="form-group">
                                <label for="nombre" class="required">Nombre del Groomer:</label>
                                <input type="text" id="nombre" name="nombre" class="form-control" required 
                                       value="<%= groomer.getNombre() != null ? groomer.getNombre() : ""%>"
                                       placeholder="Ingrese el nombre completo del groomer">
                                <div class="form-help">Nombre completo del especialista en grooming</div>
                            </div>
                        </div>

                        <!-- Especialidades -->
                        <div class="form-section">
                            <div class="section-header">
                                <span class="section-icon">🛠️</span>
                                <span class="section-title">Especialidades</span>
                            </div>
                            
                            <div class="form-group">
                                <label for="especialidadesTexto">Especialidades (separadas por coma):</label>
                                <textarea id="especialidadesTexto" name="especialidadesTexto" class="form-control"
                                          placeholder="Ej: Corte de pelo, Baño terapéutico, Cepillado, Corte de uñas, Limpieza dental"><%
                                    for (int i = 0; i < especialidadesList.size(); i++) {
                                        if (i > 0) out.print(", ");
                                        out.print(especialidadesList.get(i));
                                    }
                                %></textarea>
                                <div class="form-help">Lista de servicios especializados separados por comas</div>
                            </div>
                        </div>

                        <!-- Disponibilidad -->
                        <div class="form-section">
                            <div class="section-header">
                                <span class="section-icon">📅</span>
                                <span class="section-title">Disponibilidad</span>
                            </div>
                            
                            <!-- Acciones rápidas -->
                            <div class="quick-actions">
                                <button type="button" class="btn btn-small btn-info" onclick="seleccionarTodosLosDias()">
                                    <span>✅ Seleccionar Todos</span>
                                </button>
                                <button type="button" class="btn btn-small btn-secondary" onclick="limpiarTodosLosDias()">
                                    <span>❌ Limpiar Todos</span>
                                </button>
                                <button type="button" class="btn btn-small btn-primary" onclick="seleccionarDiasLaborales()">
                                    <span>🏢 Días Laborales</span>
                                </button>
                            </div>
                            
                            <!-- Días de la semana -->
                            <div class="form-group">
                                <label class="required">Días de trabajo:</label>
                                <div class="dias-semana">
                                    <%
                                        String[] diasSemana = {"lunes", "martes", "miercoles", "jueves", "viernes", "sabado", "domingo"};
                                        for (String dia : diasSemana) {
                                            boolean checked = diasSeleccionados.contains(dia);
                                    %>
                                    <div class="dia-checkbox">
                                        <input type="checkbox" id="<%= dia%>" name="diasArray" value="<%= dia%>" 
                                               <%= checked ? "checked" : ""%>>
                                        <label for="<%= dia%>"><%= dia.substring(0, 1).toUpperCase() + dia.substring(1)%></label>
                                    </div>
                                    <% }%>
                                </div>
                                <div class="form-help">Seleccione los días en los que el groomer está disponible</div>
                            </div>

                            <!-- Horario -->
                            <div class="form-group">
                                <label class="required">Horario de trabajo:</label>
                                <div class="hora-input">
                                    <div class="hora-group">
                                        <label for="horaInicio">Hora de inicio:</label>
                                        <input type="time" id="horaInicio" name="horaInicio" class="form-control" value="<%= horaInicio%>">
                                    </div>
                                    <div class="hora-group">
                                        <label for="horaFin">Hora de fin:</label>
                                        <input type="time" id="horaFin" name="horaFin" class="form-control" value="<%= horaFin%>">
                                    </div>
                                </div>
                                <div class="form-help">Establezca el horario laboral del groomer</div>
                            </div>

                            <!-- Tiempo por cita -->
                            <div class="form-group">
                                <label for="tiempoCita" class="required">Duración promedio por cita:</label>
                                <input type="number" id="tiempoCita" name="tiempoCita" class="form-control" 
                                       min="15" max="180" step="15" value="<%= tiempoCita%>"
                                       placeholder="60">
                                <div class="form-help">Tiempo estimado en minutos para cada cita (múltiplos de 15)</div>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" name="acc" value="Actualizar" class="btn btn-warning btn-full" onclick="return prepararYEnviar()">
                                <span>💾 Actualizar Groomer</span>
                            </button>
                            <button type="button" class="btn btn-info btn-full" onclick="mostrarDatos()">
                                <span>👁️ Ver Datos del Formulario</span>
                            </button>
                            <a href="GroomerControlador" class="btn btn-secondary btn-full">
                                <span>↶ Cancelar y Volver</span>
                            </a>
                        </div>
                    </form>
                </div>

                <% } else { %>
                <div class="mensaje error">
                    ❌ No se pudo cargar la información del groomer.
                </div>
                <div class="form-actions">
                    <a href="GroomerControlador" class="btn btn-secondary btn-full">
                        <span>↶ Volver al Listado</span>
                    </a>
                </div>
                <% }%>
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
            
            // Validación básica del formulario
            const form = document.getElementById('groomerForm');
            form.addEventListener('submit', function(e) {
                const nombre = document.getElementById('nombre').value.trim();
                if (!nombre) {
                    e.preventDefault();
                    alert('⚠️ El nombre del groomer es obligatorio.');
                    return false;
                }
            });

            // Animación para las secciones del formulario
            const formSections = document.querySelectorAll('.form-section');
            formSections.forEach((section, index) => {
                section.style.animationDelay = (index * 0.1) + 's';
            });
        });

        function mostrarDatos() {
            const especialidades = document.getElementById('especialidadesTexto').value;
            const diasSeleccionados = getDiasSeleccionados();
            const horaInicio = document.getElementById('horaInicio').value;
            const horaFin = document.getElementById('horaFin').value;
            const tiempoCita = document.getElementById('tiempoCita').value;

            alert("📋 Datos actuales del formulario:\n\n" +
                  "👤 Nombre: " + document.getElementById('nombre').value + "\n" +
                  "🛠️ Especialidades: " + (especialidades || "No especificadas") + "\n" +
                  "📅 Días seleccionados: " + (diasSeleccionados.length > 0 ? diasSeleccionados.join(", ") : "Ninguno") + "\n" +
                  "🕐 Horario: " + horaInicio + " - " + horaFin + "\n" +
                  "⏱️ Duración cita: " + tiempoCita + " minutos");
        }

        function getDiasSeleccionados() {
            const dias = [];
            document.querySelectorAll('input[name="diasArray"]:checked').forEach(checkbox => {
                dias.push(checkbox.value);
            });
            return dias;
        }

        function prepararYEnviar() {
            console.log("=== PREPARANDO DATOS PARA ACTUALIZACIÓN ===");
            
            // 1. Preparar especialidades como JSON array
            const especialidadesTexto = document.getElementById('especialidadesTexto').value;
            const especialidadesArray = especialidadesTexto.split(',').map(e => e.trim()).filter(e => e !== '');
            document.getElementById('especialidadesField').value = JSON.stringify(especialidadesArray);
            console.log("Especialidades JSON:", document.getElementById('especialidadesField').value);
            
            // 2. Preparar disponibilidad como JSON object
            const disponibilidadObj = {
                dias: getDiasSeleccionados(),
                horaInicio: document.getElementById('horaInicio').value,
                horaFin: document.getElementById('horaFin').value,
                tiempoCita: parseInt(document.getElementById('tiempoCita').value) || 60
            };
            
            document.getElementById('disponibilidadField').value = JSON.stringify(disponibilidadObj);
            console.log("Disponibilidad JSON:", document.getElementById('disponibilidadField').value);
            
            // 3. Validaciones adicionales
            if (disponibilidadObj.dias.length === 0) {
                if (!confirm('⚠️ No has seleccionado ningún día de trabajo. ¿Deseas continuar?')) {
                    return false;
                }
            }
            
            if (!disponibilidadObj.horaInicio || !disponibilidadObj.horaFin) {
                alert('⚠️ Por favor, completa el horario de trabajo.');
                return false;
            }
            
            // 4. Mostrar confirmación final
            const confirmar = confirm("¿Estás seguro de actualizar el groomer?\n\n" +
                "📋 Datos a guardar:\n" +
                "• Nombre: " + document.getElementById('nombre').value + "\n" +
                "• Especialidades: " + (especialidadesArray.length > 0 ? especialidadesArray.join(", ") : "Ninguna") + "\n" +
                "• Días: " + (disponibilidadObj.dias.length > 0 ? disponibilidadObj.dias.join(", ") : "Ninguno") + "\n" +
                "• Horario: " + disponibilidadObj.horaInicio + " a " + disponibilidadObj.horaFin + "\n" +
                "• Duración cita: " + disponibilidadObj.tiempoCita + " minutos");
            
            return confirmar;
        }

        // Funciones para selección rápida de días
        function seleccionarTodosLosDias() {
            document.querySelectorAll('input[name="diasArray"]').forEach(checkbox => {
                checkbox.checked = true;
            });
            mostrarFeedback('✅ Todos los días seleccionados');
        }

        function limpiarTodosLosDias() {
            document.querySelectorAll('input[name="diasArray"]').forEach(checkbox => {
                checkbox.checked = false;
            });
            mostrarFeedback('❌ Todos los días deseleccionados');
        }

        function seleccionarDiasLaborales() {
            document.querySelectorAll('input[name="diasArray"]').forEach(checkbox => {
                checkbox.checked = ['lunes', 'martes', 'miercoles', 'jueves', 'viernes'].includes(checkbox.value);
            });
            mostrarFeedback('🏢 Días laborales seleccionados');
        }

        function mostrarFeedback(mensaje) {
            // Crear elemento de feedback temporal
            const feedback = document.createElement('div');
            feedback.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                background: var(--success-color);
                color: white;
                padding: 15px 20px;
                border-radius: var(--radius);
                box-shadow: var(--shadow);
                z-index: 1000;
                animation: slideInRight 0.3s ease-out;
            `;
            feedback.textContent = mensaje;
            document.body.appendChild(feedback);
            
            setTimeout(() => {
                feedback.remove();
            }, 3000);
        }

        // Debug al cargar la página
        document.addEventListener('DOMContentLoaded', function() {
            console.log("=== FORMULARIO DE ACTUALIZACIÓN CARGADO ===");
            console.log("Groomer ID:", <%= groomer != null ? groomer.getIdGroomer() : "null" %>);
        });

        // Animación para entrada de elementos
        @keyframes slideInRight {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
    </script>
</body>
</html>