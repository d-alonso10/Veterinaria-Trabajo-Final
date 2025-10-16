<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Estimación - Sistema PetCare</title>
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
            max-width: 800px;
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

        /* Form Container Mejorado */
        .form-container {
            background: var(--white);
            padding: 40px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
            border: 1px solid rgba(0, 0, 0, 0.05);
            animation: fadeInUp 0.6s ease-out;
            position: relative;
            overflow: hidden;
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
            text-align: center;
            margin-bottom: 30px;
        }

        .form-header h2 {
            font-size: 1.8em;
            color: var(--text-dark);
            margin-bottom: 10px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }

        .form-header p {
            color: var(--text-light);
            font-size: 1.1em;
        }

        /* Form Styles Mejorados */
        .form-group {
            margin-bottom: 25px;
            position: relative;
        }

        .form-label {
            display: block;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 8px;
            font-size: 1em;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-label-icon {
            font-size: 1.2em;
            width: 24px;
            text-align: center;
        }

        .form-input {
            width: 100%;
            padding: 16px 20px;
            border: 2px solid #e0e0e0;
            border-radius: var(--radius);
            font-size: 1em;
            background: #f9f9f9;
            transition: all 0.3s ease;
            font-family: inherit;
            color: var(--text-dark);
        }

        .form-input:focus {
            outline: none;
            border-color: var(--primary-color);
            background: var(--white);
            box-shadow: 0 0 0 4px rgba(171, 203, 213, 0.2);
            transform: translateY(-2px);
        }

        .form-input:read-only {
            background: #f5f5f5;
            color: var(--text-light);
            cursor: not-allowed;
            border-color: #d0d0d0;
        }

        .form-input:read-only:focus {
            transform: none;
            box-shadow: none;
            border-color: #d0d0d0;
        }

        .form-help {
            display: block;
            margin-top: 6px;
            color: var(--text-light);
            font-size: 0.85em;
            font-style: italic;
        }

        /* Info Cards */
        .info-card {
            background: linear-gradient(135deg, #f0f7ff 0%, #e6f3ff 100%);
            border: 1px solid var(--primary-light);
            border-radius: var(--radius);
            padding: 20px;
            margin-bottom: 25px;
            animation: fadeInUp 0.6s ease-out 0.2s both;
        }

        .info-card h3 {
            color: var(--text-dark);
            margin-bottom: 10px;
            font-size: 1.1em;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .info-card p {
            color: var(--text-light);
            font-size: 0.95em;
            line-height: 1.6;
        }

        /* Time Preview */
        .time-preview {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border: 2px dashed #dee2e6;
            border-radius: var(--radius);
            padding: 25px;
            text-align: center;
            margin: 25px 0;
            animation: fadeInUp 0.6s ease-out 0.4s both;
        }

        .time-preview h4 {
            color: var(--text-dark);
            margin-bottom: 15px;
            font-size: 1.1em;
            font-weight: 600;
        }

        .time-comparison {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-top: 15px;
        }

        .time-item {
            background: var(--white);
            padding: 15px;
            border-radius: var(--radius);
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }

        .time-label {
            font-size: 0.9em;
            color: var(--text-light);
            margin-bottom: 8px;
            font-weight: 600;
        }

        .time-value {
            font-size: 1.4em;
            font-weight: 800;
            color: var(--primary-dark);
            font-family: 'Courier New', monospace;
        }

        .time-difference {
            font-size: 0.9em;
            font-weight: 600;
            margin-top: 8px;
            padding: 4px 8px;
            border-radius: 12px;
            display: inline-block;
        }

        .positive {
            background: #e8f6ef;
            color: #1e8449;
        }

        .negative {
            background: #fdedec;
            color: #c0392b;
        }

        .neutral {
            background: #f0f3f4;
            color: #566573;
        }

        /* Form Actions */
        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            flex-wrap: wrap;
        }

        .form-actions .btn {
            flex: 1;
            min-width: 120px;
            justify-content: center;
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
            .time-comparison {
                grid-template-columns: 1fr;
            }
            .form-actions {
                flex-direction: column;
            }
            .form-actions .btn {
                width: 100%;
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
                <li class="menu-item">
                    <a href="AuditControlador?accion=listar">
                        <span class="menu-icon">🔍</span>
                        <span>Auditoria</span>
                    </a>
                </li>
                
                <!-- Sistema -->
                <div class="menu-section">Sistema</div>
                <li class="menu-item active">
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
                        <h1>✏️ Editar Estimación de Tiempo</h1>
                        <p>Actualiza los tiempos estimados para servicios y groomers</p>
                    </div>
                    <div class="header-actions">
                        <a href="ConfiguracionControlador?accion=listar" class="btn btn-secondary">
                            <span>📋 Ver Todas las Estimaciones</span>
                        </a>
                        <a href="dashboard.jsp" class="btn btn-primary">
                            <span>📊 Ir al Dashboard</span>
                        </a>
                    </div>
                </div>
            </div>

            <div class="main-content">
                <!-- Información de Contexto -->
                <div class="info-card">
                    <h3>📝 Información Importante</h3>
                    <p>Al modificar el tiempo estimado, estarás ajustando la planificación de citas para este servicio y groomer específico. Los cambios se reflejarán inmediatamente en el sistema de programación.</p>
                </div>

                <!-- Formulario de Edición -->
                <div class="form-container">
                    <div class="form-header">
                        <h2>⏱️ Configuración de Tiempos</h2>
                        <p>Actualiza los valores según las necesidades del servicio</p>
                    </div>

                    <form action="ConfiguracionControlador" method="post" id="estimacionForm">
                        <input type="hidden" name="accion" value="actualizar">

                        <div class="form-group">
                            <label class="form-label">
                                <span class="form-label-icon">🆔</span>
                                ID Servicio
                            </label>
                            <input type="text" name="idServicio" value="<%= request.getAttribute("idServicio") %>" 
                                   class="form-input" readonly>
                            <span class="form-help">Identificador único del servicio (no editable)</span>
                        </div>

                        <div class="form-group">
                            <label class="form-label">
                                <span class="form-label-icon">👨‍💼</span>
                                ID Groomer
                            </label>
                            <input type="text" name="idGroomer" value="<%= request.getAttribute("idGroomer") %>" 
                                   class="form-input" readonly>
                            <span class="form-help">Identificador único del groomer (no editable)</span>
                        </div>

                        <div class="form-group">
                            <label class="form-label">
                                <span class="form-label-icon">⏰</span>
                                Nuevo Tiempo Estimado (minutos)
                            </label>
                            <input type="number" name="tiempoEstimadoMin" min="1" max="480" 
                                   class="form-input" required id="tiempoInput"
                                   placeholder="Ingresa el tiempo en minutos">
                            <span class="form-help">Tiempo estimado que tomará completar el servicio (1-480 minutos)</span>
                        </div>

                        <!-- Vista Previa de Comparación -->
                        <div class="time-preview" id="timePreview" style="display: none;">
                            <h4>📊 Comparación de Tiempos</h4>
                            <div class="time-comparison">
                                <div class="time-item">
                                    <div class="time-label">Tiempo Base</div>
                                    <div class="time-value" id="baseTime">-- min</div>
                                </div>
                                <div class="time-item">
                                    <div class="time-label">Nuevo Estimado</div>
                                    <div class="time-value" id="newTime">-- min</div>
                                    <div class="time-difference neutral" id="timeDifference">--</div>
                                </div>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-success" id="submitBtn">
                                <span>💾 Guardar Cambios</span>
                            </button>
                            <a href="ConfiguracionControlador?accion=listar" class="btn btn-secondary">
                                <span>❌ Cancelar</span>
                            </a>
                            <button type="button" class="btn btn-warning" onclick="resetForm()">
                                <span>🔄 Restablecer</span>
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Información Adicional -->
                <div class="info-card">
                    <h3>💡 Recomendaciones</h3>
                    <p>• Considera la experiencia del groomer al ajustar los tiempos<br>
                       • Los tiempos más cortos permiten más citas por día<br>
                       • Los tiempos más largos garantizan mejor calidad de servicio<br>
                       • Mantén un balance entre eficiencia y calidad</p>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Script mejorado para el formulario de edición
        document.addEventListener('DOMContentLoaded', function() {
            const tiempoInput = document.getElementById('tiempoInput');
            const timePreview = document.getElementById('timePreview');
            const baseTimeElement = document.getElementById('baseTime');
            const newTimeElement = document.getElementById('newTime');
            const timeDifferenceElement = document.getElementById('timeDifference');
            const submitBtn = document.getElementById('submitBtn');

            // Simular tiempo base (en una implementación real, esto vendría del servidor)
            const tiempoBase = 45; // Ejemplo: 45 minutos base

            // Mostrar tiempo base
            baseTimeElement.textContent = tiempoBase + ' min';

            // Actualizar vista previa en tiempo real
            tiempoInput.addEventListener('input', function() {
                const nuevoTiempo = parseInt(this.value) || 0;
                
                if (nuevoTiempo > 0) {
                    // Mostrar vista previa
                    timePreview.style.display = 'block';
                    
                    // Actualizar valores
                    newTimeElement.textContent = nuevoTiempo + ' min';
                    
                    // Calcular y mostrar diferencia
                    const diferencia = nuevoTiempo - tiempoBase;
                    let diferenciaText = '';
                    let diferenciaClass = 'neutral';
                    
                    if (diferencia > 0) {
                        diferenciaText = `+${diferencia} min más lento`;
                        diferenciaClass = 'negative';
                    } else if (diferencia < 0) {
                        diferenciaText = `${Math.abs(diferencia)} min más rápido`;
                        diferenciaClass = 'positive';
                    } else {
                        diferenciaText = 'Sin cambios';
                        diferenciaClass = 'neutral';
                    }
                    
                    timeDifferenceElement.textContent = diferenciaText;
                    timeDifferenceElement.className = 'time-difference ' + diferenciaClass;
                    
                } else {
                    timePreview.style.display = 'none';
                }
            });

            // Validación del formulario
            const form = document.getElementById('estimacionForm');
            form.addEventListener('submit', function(e) {
                const tiempo = parseInt(tiempoInput.value);
                
                if (!tiempo || tiempo < 1 || tiempo > 480) {
                    e.preventDefault();
                    alert('⚠️ Por favor, ingresa un tiempo válido entre 1 y 480 minutos.');
                    tiempoInput.focus();
                    return;
                }

                // Mostrar loading
                submitBtn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Guardando...';
                submitBtn.disabled = true;

                // Simular envío (en producción esto sería automático)
                setTimeout(() => {
                    submitBtn.innerHTML = '<span>💾 Guardar Cambios</span>';
                    submitBtn.disabled = false;
                }, 2000);
            });

            // Efectos de focus mejorados
            const inputs = document.querySelectorAll('.form-input');
            inputs.forEach(input => {
                input.addEventListener('focus', function() {
                    this.parentElement.style.transform = 'translateY(-2px)';
                });
                
                input.addEventListener('blur', function() {
                    this.parentElement.style.transform = 'translateY(0)';
                });
            });

            // Sugerencia de tiempos comunes
            const tiemposSugeridos = [15, 30, 45, 60, 90, 120];
            const sugerenciasContainer = document.createElement('div');
            sugerenciasContainer.className = 'form-help';
            sugerenciasContainer.innerHTML = '<strong>Tiempos sugeridos:</strong> ' + 
                tiemposSugeridos.map(t => `<a href="javascript:void(0)" onclick="document.getElementById('tiempoInput').value=${t}">${t}min</a>`).join(' • ');
            
            tiempoInput.parentElement.appendChild(sugerenciasContainer);
        });

        // Función para restablecer el formulario
        function resetForm() {
            if (confirm('¿Estás seguro de que deseas restablecer el formulario? Se perderán los cambios no guardados.')) {
                document.getElementById('estimacionForm').reset();
                document.getElementById('timePreview').style.display = 'none';
                document.getElementById('tiempoInput').focus();
            }
        }

        // Función para calcular impacto en citas
        function calcularImpacto() {
            const nuevoTiempo = parseInt(document.getElementById('tiempoInput').value) || 0;
            if (nuevoTiempo > 0) {
                const citasPorDia = Math.floor(480 / nuevoTiempo); // 8 horas = 480 minutos
                alert(`📅 Con este tiempo estimado:\n\n• ${citasPorDia} citas posibles por día\n• ${citasPorDia * 5} citas por semana\n• ${citasPorDia * 20} citas por mes`);
            } else {
                alert('Por favor, ingresa un tiempo válido primero.');
            }
        }

        // Atajos de teclado
        document.addEventListener('keydown', function(e) {
            // Ctrl + S para guardar
            if (e.ctrlKey && e.key === 's') {
                e.preventDefault();
                document.getElementById('submitBtn').click();
            }
            
            // Escape para cancelar
            if (e.key === 'Escape') {
                window.location.href = 'ConfiguracionControlador?accion=listar';
            }
        });
    </script>
</body>
</html>