<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Insertar Groomer - Sistema PetCare</title>
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
            max-width: 1000px;
            margin: 0 auto;
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

        .form-container {
            background: var(--white);
            padding: 40px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
            border-top: 4px solid var(--primary-color);
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
            transition: color 0.3s ease;
        }

        .required::after {
            content: " *";
            color: var(--danger-color);
        }

        .form-section {
            background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
            padding: 25px;
            border-radius: var(--radius);
            margin-bottom: 30px;
            border-left: 4px solid var(--primary-color);
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
            color: var(--primary-color);
        }

        .section-title {
            font-size: 1.3em;
            font-weight: 700;
        }

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

        .info-box {
            background: linear-gradient(135deg, #f0f7ff 0%, #e6f3ff 100%);
            padding: 25px;
            border-radius: var(--radius);
            border-left: 4px solid var(--info-color);
            margin-top: 30px;
            box-shadow: var(--shadow);
        }

        .info-box strong {
            color: var(--text-dark);
            font-size: 1.1em;
            margin-bottom: 10px;
            display: block;
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
            .form-container {
                padding: 25px;
            }
            .form-actions {
                grid-template-columns: 1fr;
            }
            .form-header h2 {
                font-size: 1.8em;
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
            .btn {
                width: 100%;
                justify-content: center;
            }
        }

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
                    <a href="configuracion.jsp">
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
                        <h1>✂️ Insertar Nuevo Groomer</h1>
                        <p>Agregar nuevo especialista en grooming al sistema</p>
                    </div>
                    <div class="header-actions">
                        <a href="GroomerControlador" class="btn btn-secondary">
                            <span>← Volver al Listado</span>
                        </a>
                        <a href="dashboard.jsp" class="btn btn-primary">
                            <span>📊 Ir al Dashboard</span>
                        </a>
                    </div>
                </div>
            </div>

            <div class="main-content">
                <% if (request.getAttribute("mensaje") != null) { %>
                    <div class="mensaje <%= request.getAttribute("mensaje").toString().contains("✅") ? "exito" : "error" %>">
                        <%= request.getAttribute("mensaje") %>
                    </div>
                <% } %>

                <div class="form-container">
                    <div class="form-header">
                        <span class="form-icon floating">✂️</span>
                        <h2>Nuevo Especialista en Grooming</h2>
                        <p>Complete la información del nuevo groomer para integrarlo al sistema</p>
                    </div>

                    <form action="<%= request.getContextPath() %>/GroomerControlador" method="POST" id="groomerForm">
                        <!-- Información Básica -->
                        <div class="form-section">
                            <div class="section-header">
                                <span class="section-icon">👤</span>
                                <span class="section-title">Información Personal</span>
                            </div>
                            
                            <div class="form-group">
                                <label for="nombre" class="required">Nombre Completo:</label>
                                <input type="text" id="nombre" name="nombre" class="form-control" required 
                                       placeholder="Ingrese el nombre completo del groomer"
                                       oninput="validarNombre(this)">
                                <div class="form-help">Nombre completo del especialista en grooming (mínimo 2 caracteres)</div>
                            </div>

                            <div class="form-group">
                                <label for="email">Correo Electrónico:</label>
                                <input type="email" id="email" name="email" class="form-control"
                                       placeholder="ejemplo@teranvet.com"
                                       oninput="validarEmail(this)">
                                <div class="form-help">Correo electrónico profesional del groomer</div>
                            </div>

                            <div class="form-group">
                                <label for="telefono">Teléfono de Contacto:</label>
                                <input type="tel" id="telefono" name="telefono" class="form-control"
                                       placeholder="+51 987 654 321"
                                       oninput="formatearTelefono(this)">
                                <div class="form-help">Número de contacto para emergencias y coordinaciones</div>
                            </div>
                        </div>

                        <!-- Especialidades y Habilidades -->
                        <div class="form-section">
                            <div class="section-header">
                                <span class="section-icon">🛠️</span>
                                <span class="section-title">Especialidades y Habilidades</span>
                            </div>
                            
                            <div class="form-group">
                                <label for="especialidades">Especialidades Principales:</label>
                                <textarea id="especialidades" name="especialidades" class="form-control"
                                          placeholder="Ej: Corte de pelo, Baño terapéutico, Cepillado, Corte de uñas, Limpieza dental, Estilizado"
                                          oninput="contarEspecialidades(this)"></textarea>
                                <div class="form-help">
                                    <span id="contadorEspecialidades">0</span> especialidades listadas (separadas por comas)
                                    <button type="button" class="btn btn-small btn-primary" onclick="sugerirEspecialidades()" style="margin-left: 10px; padding: 4px 8px; font-size: 0.8em;">
                                        🎯 Sugerir
                                    </button>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="experiencia">Años de Experiencia:</label>
                                <input type="number" id="experiencia" name="experiencia" class="form-control"
                                       min="0" max="50" step="0.5"
                                       placeholder="3.5"
                                       onchange="validarExperiencia(this)">
                                <div class="form-help">Años de experiencia en grooming profesional</div>
                            </div>
                        </div>

                        <!-- Disponibilidad y Horario -->
                        <div class="form-section">
                            <div class="section-header">
                                <span class="section-icon">📅</span>
                                <span class="section-title">Disponibilidad y Horario</span>
                            </div>
                            
                            <div class="form-group">
                                <label for="disponibilidad">Horario de Trabajo:</label>
                                <input type="text" id="disponibilidad" name="disponibilidad" class="form-control"
                                       placeholder="Ej: Lunes a Viernes 8:00-16:00, Sábados 9:00-13:00">
                                <div class="form-help">Descripción del horario de trabajo y disponibilidad regular</div>
                            </div>

                            <div class="form-group">
                                <label for="sucursal">Sucursal Asignada:</label>
                                <select id="sucursal" name="sucursal" class="form-control">
                                    <option value="">Seleccionar sucursal...</option>
                                    <option value="sucursal_principal">Sucursal Principal - Centro</option>
                                    <option value="sucursal_norte">Sucursal Norte - Miraflores</option>
                                    <option value="sucursal_sur">Sucursal Sur - San Isidro</option>
                                    <option value="sucursal_este">Sucursal Este - La Molina</option>
                                </select>
                                <div class="form-help">Sucursal donde trabajará principalmente el groomer</div>
                            </div>
                        </div>

                        <!-- Estado del Groomer -->
                        <div class="form-section">
                            <div class="section-header">
                                <span class="section-icon">✅</span>
                                <span class="section-title">Estado del Groomer</span>
                            </div>
                            
                            <div class="form-group">
                                <label for="estado">Estado Actual:</label>
                                <select id="estado" name="estado" class="form-control" required>
                                    <option value="activo">🟢 Activo - Disponible para trabajo</option>
                                    <option value="capacitacion">🟡 En Capacitación - Limitado</option>
                                    <option value="vacaciones">🔴 En Vacaciones - No disponible</option>
                                    <option value="suspendido">⚫ Suspendido - No activo</option>
                                </select>
                                <div class="form-help">Estado actual del groomer en el sistema</div>
                            </div>

                            <div class="form-group">
                                <label for="fecha_ingreso">Fecha de Ingreso:</label>
                                <input type="date" id="fecha_ingreso" name="fecha_ingreso" class="form-control"
                                       value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                                <div class="form-help">Fecha en que el groomer se integra al sistema</div>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" name="acc" value="Confirmar" class="btn btn-success" onclick="return validarFormulario()">
                                <span>✅ Confirmar y Guardar</span>
                            </button>
                            <button type="button" class="btn btn-primary" onclick="cargarDatosEjemplo()">
                                <span>📝 Cargar Datos de Ejemplo</span>
                            </button>
                            <button type="button" class="btn btn-warning" onclick="limpiarFormulario()">
                                <span>🗑️ Limpiar Formulario</span>
                            </button>
                            <a href="GroomerControlador" class="btn btn-secondary">
                                <span>↶ Cancelar y Volver</span>
                            </a>
                        </div>
                    </form>
                </div>

                <!-- Información adicional -->
                <div class="info-box">
                    <strong>💡 Información importante:</strong><br>
                    • Los campos marcados con <span class="required">*</span> son obligatorios<br>
                    • Las especialidades deben separarse por comas para mejor organización<br>
                    • El estado determina la disponibilidad inmediata del groomer<br>
                    • La sucursal puede cambiarse posteriormente según necesidades<br>
                    • Los datos de contacto son esenciales para coordinaciones urgentes
                </div>
            </div>
        </div>
    </div>

    <script>
        // Script mejorado para manejar la interacción del formulario
        document.addEventListener('DOMContentLoaded', function() {
            const menuItems = document.querySelectorAll('.menu-item');
            
            menuItems.forEach(item => {
                item.addEventListener('click', function() {
                    menuItems.forEach(i => i.classList.remove('active'));
                    this.classList.add('active');
                });
            });
            
            // Auto-focus en el campo de nombre
            document.getElementById('nombre').focus();
            
            // Inicializar contadores y validaciones
            contarEspecialidades(document.getElementById('especialidades'));
            validarExperiencia(document.getElementById('experiencia'));
            
            // Efectos de aparición para elementos del formulario
            const formElements = document.querySelectorAll('.form-section, .form-actions, .info-box');
            formElements.forEach((element, index) => {
                element.style.opacity = '0';
                element.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    element.style.transition = 'all 0.6s cubic-bezier(0.4, 0, 0.2, 1)';
                    element.style.opacity = '1';
                    element.style.transform = 'translateY(0)';
                }, index * 200);
            });
        });

        // Función para validar el nombre
        function validarNombre(input) {
            const valor = input.value.trim();
            const ayuda = input.parentElement.querySelector('.form-help');
            
            if (valor.length < 2 && valor.length > 0) {
                ayuda.style.color = 'var(--danger-color)';
                ayuda.textContent = '❌ El nombre debe tener al menos 2 caracteres';
                input.style.borderColor = 'var(--danger-color)';
            } else if (valor.length >= 2) {
                ayuda.style.color = 'var(--success-color)';
                ayuda.textContent = '✅ Nombre válido';
                input.style.borderColor = 'var(--success-color)';
            } else {
                ayuda.style.color = 'var(--text-light)';
                ayuda.textContent = 'Nombre completo del especialista en grooming (mínimo 2 caracteres)';
                input.style.borderColor = '#e0e0e0';
            }
        }

        // Función para validar email
        function validarEmail(input) {
            const valor = input.value.trim();
            const ayuda = input.parentElement.querySelector('.form-help');
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            
            if (valor && !emailRegex.test(valor)) {
                ayuda.style.color = 'var(--danger-color)';
                ayuda.textContent = '❌ Formato de email inválido';
                input.style.borderColor = 'var(--danger-color)';
            } else if (valor && emailRegex.test(valor)) {
                ayuda.style.color = 'var(--success-color)';
                ayuda.textContent = '✅ Email válido';
                input.style.borderColor = 'var(--success-color)';
            } else {
                ayuda.style.color = 'var(--text-light)';
                ayuda.textContent = 'Correo electrónico profesional del groomer';
                input.style.borderColor = '#e0e0e0';
            }
        }

        // Función para formatear teléfono
        function formatearTelefono(input) {
            let valor = input.value.replace(/\D/g, '');
            
            if (valor.length > 0) {
                if (valor.length <= 3) {
                    valor = valor;
                } else if (valor.length <= 6) {
                    valor = valor.replace(/(\d{3})(\d+)/, '$1 $2');
                } else if (valor.length <= 9) {
                    valor = valor.replace(/(\d{3})(\d{3})(\d+)/, '$1 $2 $3');
                } else {
                    valor = valor.replace(/(\d{3})(\d{3})(\d{3})(\d+)/, '$1 $2 $3 $4');
                }
                
                // Agregar código de país si no está presente
                if (!valor.startsWith('+51') && !valor.startsWith('51')) {
                    valor = '+51 ' + valor;
                }
            }
            
            input.value = valor;
        }

        // Función para contar especialidades
        function contarEspecialidades(textarea) {
            const valor = textarea.value.trim();
            let contador = 0;
            
            if (valor) {
                const especialidades = valor.split(',').map(e => e.trim()).filter(e => e !== '');
                contador = especialidades.length;
            }
            
            const contadorElement = document.getElementById('contadorEspecialidades');
            contadorElement.textContent = contador;
            
            if (contador > 0) {
                contadorElement.style.color = 'var(--success-color)';
                contadorElement.style.fontWeight = '600';
                textarea.style.borderColor = 'var(--success-color)';
            } else {
                contadorElement.style.color = 'var(--text-light)';
                contadorElement.style.fontWeight = 'normal';
                textarea.style.borderColor = '#e0e0e0';
            }
        }

        // Función para validar experiencia
        function validarExperiencia(input) {
            const valor = parseFloat(input.value);
            const ayuda = input.parentElement.querySelector('.form-help');
            
            if (isNaN(valor) || valor < 0) {
                ayuda.style.color = 'var(--danger-color)';
                ayuda.textContent = '❌ La experiencia debe ser un número positivo';
                input.style.borderColor = 'var(--danger-color)';
            } else if (valor > 50) {
                ayuda.style.color = 'var(--warning-color)';
                ayuda.textContent = '⚠️ Verificar años de experiencia';
                input.style.borderColor = 'var(--warning-color)';
            } else {
                ayuda.style.color = 'var(--success-color)';
                ayuda.textContent = '✅ Experiencia válida';
                input.style.borderColor = 'var(--success-color)';
            }
        }

        // Función para validar el formulario completo
        function validarFormulario() {
            const nombre = document.getElementById('nombre').value.trim();
            const email = document.getElementById('email').value.trim();
            const especialidades = document.getElementById('especialidades').value.trim();
            const estado = document.getElementById('estado').value;
            
            // Validar nombre obligatorio
            if (!nombre) {
                mostrarError('⚠️ El nombre del groomer es obligatorio.');
                document.getElementById('nombre').focus();
                return false;
            }
            
            if (nombre.length < 2) {
                mostrarError('⚠️ El nombre debe tener al menos 2 caracteres.');
                document.getElementById('nombre').focus();
                return false;
            }
            
            // Validar email si está presente
            if (email) {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email)) {
                    mostrarError('⚠️ El formato del email es inválido.');
                    document.getElementById('email').focus();
                    return false;
                }
            }
            
            // Validar estado
            if (!estado) {
                mostrarError('⚠️ Debe seleccionar un estado para el groomer.');
                document.getElementById('estado').focus();
                return false;
            }
            
            // Preparar datos para confirmación
            const datosConfirmacion = {
                nombre: nombre,
                email: email || 'No especificado',
                especialidades: especialidades ? especialidades.split(',').length + ' especialidades' : 'No especificadas',
                experiencia: document.getElementById('experiencia').value || '0',
                disponibilidad: document.getElementById('disponibilidad').value || 'No especificada',
                sucursal: document.getElementById('sucursal').value || 'No asignada',
                estado: document.getElementById('estado').options[document.getElementById('estado').selectedIndex].text,
                fechaIngreso: document.getElementById('fecha_ingreso').value
            };
            
            // Confirmación antes de enviar
            const confirmar = confirm('¿Está seguro de que desea agregar este groomer?\n\n' +
                'Datos a guardar:\n' +
                '• Nombre: ' + datosConfirmacion.nombre + '\n' +
                '• Email: ' + datosConfirmacion.email + '\n' +
                '• Especialidades: ' + datosConfirmacion.especialidades + '\n' +
                '• Experiencia: ' + datosConfirmacion.experiencia + ' años\n' +
                '• Disponibilidad: ' + datosConfirmacion.disponibilidad + '\n' +
                '• Sucursal: ' + datosConfirmacion.sucursal + '\n' +
                '• Estado: ' + datosConfirmacion.estado + '\n' +
                '• Fecha de ingreso: ' + datosConfirmacion.fechaIngreso);
            
            if (confirmar) {
                // Mostrar loading en el botón de enviar
                const submitBtn = document.querySelector('button[type="submit"]');
                const originalText = submitBtn.innerHTML;
                submitBtn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Guardando...';
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

        // Función para mostrar errores
        function mostrarError(mensaje) {
            // Crear o actualizar mensaje de error
            let errorDiv = document.querySelector('.mensaje.error');
            if (!errorDiv) {
                errorDiv = document.createElement('div');
                errorDiv.className = 'mensaje error';
                document.querySelector('.main-content').insertBefore(errorDiv, document.querySelector('.form-container'));
            }
            errorDiv.innerHTML = mensaje;
            
            // Scroll to error
            errorDiv.scrollIntoView({ behavior: 'smooth', block: 'center' });
            
            // Auto-remover después de 5 segundos
            setTimeout(() => {
                if (errorDiv.parentNode) {
                    errorDiv.parentNode.removeChild(errorDiv);
                }
            }, 5000);
        }

        // Función para cargar datos de ejemplo
        function cargarDatosEjemplo() {
            if (confirm('¿Desea cargar datos de ejemplo para pruebas?')) {
                document.getElementById('nombre').value = 'María González López';
                document.getElementById('email').value = 'maria.gonzalez@teranvet.com';
                document.getElementById('telefono').value = '+51 987 654 321';
                document.getElementById('especialidades').value = 'Corte de pelo, Baño terapéutico, Cepillado profesional, Corte de uñas, Limpieza dental, Estilizado canino';
                document.getElementById('experiencia').value = '3.5';
                document.getElementById('disponibilidad').value = 'Lunes a Viernes 8:00-16:00, Sábados 9:00-13:00';
                document.getElementById('sucursal').value = 'sucursal_principal';
                document.getElementById('estado').value = 'activo';
                
                // Actualizar validaciones
                validarNombre(document.getElementById('nombre'));
                validarEmail(document.getElementById('email'));
                contarEspecialidades(document.getElementById('especialidades'));
                validarExperiencia(document.getElementById('experiencia'));
                
                // Mostrar mensaje de éxito
                mostrarMensajeExito('✅ Datos de ejemplo cargados correctamente. Puede modificar la información según sea necesario.');
            }
        }

        // Función para mostrar mensajes de éxito
        function mostrarMensajeExito(mensaje) {
            const exitoDiv = document.createElement('div');
            exitoDiv.className = 'mensaje exito';
            exitoDiv.innerHTML = mensaje;
            document.querySelector('.main-content').insertBefore(exitoDiv, document.querySelector('.form-container'));
            
            // Auto-remover después de 4 segundos
            setTimeout(() => {
                if (exitoDiv.parentNode) {
                    exitoDiv.parentNode.removeChild(exitoDiv);
                }
            }, 4000);
        }

        // Función para limpiar el formulario
        function limpiarFormulario() {
            if (confirm('¿Está seguro de que desea limpiar todos los campos del formulario?')) {
                document.getElementById('groomerForm').reset();
                
                // Restablecer estilos y mensajes
                const formControls = document.querySelectorAll('.form-control');
                formControls.forEach(control => {
                    control.style.borderColor = '#e0e0e0';
                });
                
                const formHelps = document.querySelectorAll('.form-help');
                formHelps.forEach(help => {
                    help.style.color = 'var(--text-light)';
                    // Restaurar texto original basado en el campo
                    const field = help.previousElementSibling;
                    if (field.id === 'nombre') {
                        help.textContent = 'Nombre completo del especialista en grooming (mínimo 2 caracteres)';
                    } else if (field.id === 'email') {
                        help.textContent = 'Correo electrónico profesional del groomer';
                    } else if (field.id === 'especialidades') {
                        help.textContent = 'Ej: Corte de pelo, Baño terapéutico, Cepillado, Corte de uñas, Limpieza dental, Estilizado';
                        document.getElementById('contadorEspecialidades').textContent = '0';
                    } else if (field.id === 'experiencia') {
                        help.textContent = 'Años de experiencia en grooming profesional';
                    }
                });
                
                document.getElementById('nombre').focus();
                mostrarMensajeExito('✅ Formulario limpiado correctamente.');
            }
        }

        // Función para sugerir especialidades comunes
        function sugerirEspecialidades() {
            const especialidadesComunes = [
                "Corte de pelo estándar",
                "Baño terapéutico", 
                "Cepillado profesional",
                "Corte de uñas",
                "Limpieza dental",
                "Estilizado canino",
                "Deslanado",
                "Hidratación profunda",
                "Secado profesional",
                "Corte de pelo de raza específica",
                "Limpieza de oídos",
                "Tratamiento antipulgas"
            ];
            
            const textarea = document.getElementById('especialidades');
            const especialidadesActuales = textarea.value.trim();
            const nuevasEspecialidades = especialidadesComunes.join(', ');
            
            if (especialidadesActuales) {
                textarea.value = especialidadesActuales + ', ' + nuevasEspecialidades;
            } else {
                textarea.value = nuevasEspecialidades;
            }
            
            contarEspecialidades(textarea);
            mostrarMensajeExito('🎯 Especialidades comunes agregadas. Puede editarlas según sea necesario.');
        }

        // Manejar tecla Enter en el formulario (evitar envío accidental)
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