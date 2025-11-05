<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard - Sistema PetCare</title>
        <style>
            html {
                overflow-x: hidden;
            }
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
                overflow-x: hidden;
            }

            .container {
                display: flex;
                min-height: 100vh;
                overflow: hidden;
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
                min-width: 0;
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
                background: linear-gradient(135deg, var(--info-color) 0%, #0b7dda 100%);
                color: var(--white);
                box-shadow: 0 8px 25px rgba(33, 150, 243, 0.3);
            }

            .btn-info:hover {
                transform: translateY(-3px);
                box-shadow: 0 12px 35px rgba(33, 150, 243, 0.4);
            }

            /* Stats Container */
            .stats-container {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
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

            /* Dashboard Cards */
            .dashboard-cards {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 25px;
                margin: 30px 0;
            }

            .card {
                background: var(--white);
                padding: 30px;
                border-radius: var(--radius);
                box-shadow: var(--shadow);
                transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
                border: 1px solid rgba(0, 0, 0, 0.05);
                position: relative;
                overflow: hidden;
                animation: fadeInUp 0.8s ease-out;
            }

            .card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: var(--gradient-primary);
            }

            .card:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 40px rgba(0,0,0,0.15);
            }

            .card h3 {
                color: var(--text-dark);
                margin-bottom: 20px;
                font-size: 1.4em;
                font-weight: 700;
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .card-icon {
                font-size: 1.5em;
                color: var(--primary-color);
            }

            .card-content {
                color: var(--text-light);
                line-height: 1.8;
            }

            .card-content p {
                margin-bottom: 12px;
                padding: 8px 0;
                border-bottom: 1px solid rgba(0, 0, 0, 0.05);
                display: flex;
                align-items: center;
                gap: 8px;
                transition: all 0.3s ease;
            }

            .card-content p:hover {
                color: var(--text-dark);
                transform: translateX(5px);
            }

            .card-content p:last-child {
                border-bottom: none;
                margin-bottom: 0;
            }

            /* Quick Actions */
            .quick-actions {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
                margin: 30px 0;
            }

            .action-card {
                background: var(--white);
                padding: 25px;
                border-radius: var(--radius);
                box-shadow: var(--shadow);
                text-align: center;
                transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
                border: 1px solid rgba(0, 0, 0, 0.05);
                animation: fadeInUp 0.8s ease-out;
            }

            .action-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 40px rgba(0,0,0,0.15);
            }

            .action-icon {
                font-size: 2.5em;
                margin-bottom: 15px;
                display: block;
            }

            .action-title {
                font-size: 1.1em;
                font-weight: 600;
                color: var(--text-dark);
                margin-bottom: 10px;
            }

            .action-description {
                color: var(--text-light);
                font-size: 0.9em;
                margin-bottom: 15px;
            }

            /* Recent Activity */
            .activity-list {
                background: var(--white);
                border-radius: var(--radius);
                box-shadow: var(--shadow);
                overflow: hidden;
                margin: 30px 0;
                border: 1px solid rgba(0, 0, 0, 0.05);
                animation: fadeInUp 0.8s ease-out;
            }

            .activity-header {
                padding: 20px 25px;
                background: var(--gradient-primary);
                color: var(--white);
                font-size: 1.2em;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .activity-item {
                padding: 18px 25px;
                border-bottom: 1px solid rgba(0, 0, 0, 0.05);
                display: flex;
                align-items: center;
                gap: 15px;
                transition: all 0.3s ease;
            }

            .activity-item:hover {
                background: rgba(171, 203, 213, 0.05);
            }

            .activity-item:last-child {
                border-bottom: none;
            }

            .activity-icon {
                font-size: 1.3em;
                width: 40px;
                text-align: center;
            }

            .activity-content {
                flex: 1;
            }

            .activity-title {
                font-weight: 600;
                color: var(--text-dark);
                margin-bottom: 4px;
            }

            .activity-time {
                color: var(--text-light);
                font-size: 0.85em;
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
                .dashboard-cards {
                    grid-template-columns: 1fr;
                }
                .stats-container {
                    grid-template-columns: repeat(2, 1fr);
                }
                .quick-actions {
                    grid-template-columns: repeat(2, 1fr);
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
                .stats-container {
                    grid-template-columns: 1fr;
                }
                .quick-actions {
                    grid-template-columns: 1fr;
                }
            }

            /* Animation Effects */
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
            <!-- Sidebar Menu - Incluido desde includes/menu.jsp para seguir patrón MVC -->
            <jsp:include page="includes/menu.jsp" />

            <!-- Main Content -->
            <div class="content">
                <div class="header">
                    <div class="header-top">
                        <div class="welcome">
                            <h1>📊 Dashboard Principal</h1>
                            <p>Resumen completo del sistema - <%= new java.text.SimpleDateFormat("EEEE, d 'de' MMMM 'de' yyyy").format(new java.util.Date())%></p>
                        </div>
                        <div class="header-actions">
                            <a href="<%= request.getContextPath()%>/CitaControlador?accion=mostrarFormulario" class="btn btn-success">➕ Nueva Cita</a>
                            <a href="<%= request.getContextPath()%>/ClienteControlador?accion=mostrarFormulario" class="btn btn-primary">👤 Agregar Cliente</a>
                        </div>
                    </div>
                </div>

                <div class="main-content">
                    <!-- Estadísticas Principales -->
                    <div class="stats-container">
                        <div class="stat-card floating">
                            <span class="stat-icon">📅</span>
                            <div class="stat-number">24</div>
                            <div class="stat-label">Citas Hoy</div>
                        </div>
                        <div class="stat-card floating" style="animation-delay: 0.2s;">
                            <span class="stat-icon">👥</span>
                            <div class="stat-number">18</div>
                            <div class="stat-label">Clientes Atendidos</div>
                        </div>
                        <div class="stat-card floating" style="animation-delay: 0.4s;">
                            <span class="stat-icon">💰</span>
                            <div class="stat-number">S/ 2,850</div>
                            <div class="stat-label">Ingresos del Día</div>
                        </div>
                        <div class="stat-card floating" style="animation-delay: 0.6s;">
                            <span class="stat-icon">⭐</span>
                            <div class="stat-number">92%</div>
                            <div class="stat-label">Satisfacción</div>
                        </div>
                    </div>

                    <!-- Acciones Rápidas -->
                    <div class="quick-actions">
                        <div class="action-card">
                            <span class="action-icon">📅</span>
                            <div class="action-title">Agendar Cita</div>
                            <div class="action-description">Programar nueva cita para cliente</div>
                            <a href="<%= request.getContextPath()%>/CitaControlador?accion=mostrarFormulario" class="btn btn-primary btn-small">Acceder</a>
                        </div>
                        <div class="action-card">
                            <span class="action-icon">👤</span>
                            <div class="action-title">Nuevo Cliente</div>
                            <div class="action-description">Registrar nuevo cliente en el sistema</div>
                            <a href="<%= request.getContextPath()%>/ClienteControlador?accion=mostrarFormulario" class="btn btn-success btn-small">Registrar</a>
                        </div>
                        <div class="action-card">
                            <span class="action-icon">🐾</span>
                            <div class="action-title">Registrar Mascota</div>
                            <div class="action-description">Agregar mascota a cliente existente</div>
                            <a href="<%= request.getContextPath()%>/MascotaControlador?accion=mostrarFormulario" class="btn btn-info btn-small">Gestionar</a>
                        </div>
                        <div class="action-card">
                            <span class="action-icon">💳</span>
                            <div class="action-title">Registrar Pago</div>
                            <div class="action-description">Procesar pago de servicios</div>
                            <a href="<%= request.getContextPath()%>/PagoControlador?accion=mostrarFormulario" class="btn btn-warning btn-small">Pagar</a>
                        </div>
                    </div>

                    <!-- Tarjetas de Información -->
                    <div class="dashboard-cards">
                        <div class="card">
                            <h3><span class="card-icon">📅</span> Próximas Citas</h3>
                            <div class="card-content">
                                <p>🕙 10:00 AM - Baño completo (Rex)</p>
                                <p>🕚 11:30 AM - Corte de pelo (Luna)</p>
                                <p>🕑 02:00 PM - Limpieza dental (Max)</p>
                                <p>🕒 03:30 PM - Corte de uñas (Bella)</p>
                                <p>🕓 04:45 PM - Baño medicado (Rocky)</p>
                            </div>
                        </div>

                        <div class="card">
                            <h3><span class="card-icon">🎯</span> Acciones Rápidas</h3>
                            <div class="card-content">
                                <p>📋 Agendar nueva cita</p>
                                <p>💰 Registrar pago</p>
                                <p>📈 Generar reporte mensual</p>
                                <p>📦 Revisar inventario</p>
                                <p>👥 Gestionar personal</p>
                            </div>
                        </div>

                        <div class="card">
                            <h3><span class="card-icon">📈</span> Métricas Importantes</h3>
                            <div class="card-content">
                                <p>📊 Tasa de ocupación: 78%</p>
                                <p>🔄 Clientes recurrentes: 65%</p>
                                <p>⏱️ Tiempo promedio servicio: 45 min</p>
                                <p>💰 Promedio gasto por cliente: S/ 45</p>
                                <p>⭐ Rating promedio: 4.8/5</p>
                            </div>
                        </div>
                    </div>

                    <!-- Actividad Reciente -->
                    <div class="activity-list">
                        <div class="activity-header">
                            <span>🕒 Actividad Reciente</span>
                        </div>
                        <div class="activity-item">
                            <span class="activity-icon">✅</span>
                            <div class="activity-content">
                                <div class="activity-title">Cita completada - Baño completo</div>
                                <div class="activity-time">Hace 15 minutos - Cliente: María González</div>
                            </div>
                        </div>
                        <div class="activity-item">
                            <span class="activity-icon">💰</span>
                            <div class="activity-content">
                                <div class="activity-title">Pago procesado - S/ 75.00</div>
                                <div class="activity-time">Hace 30 minutos - Cliente: Carlos López</div>
                            </div>
                        </div>
                        <div class="activity-item">
                            <span class="activity-icon">👤</span>
                            <div class="activity-content">
                                <div class="activity-title">Nuevo cliente registrado</div>
                                <div class="activity-time">Hace 1 hora - Ana Martínez</div>
                            </div>
                        </div>
                        <div class="activity-item">
                            <span class="activity-icon">📅</span>
                            <div class="activity-content">
                                <div class="activity-title">Cita reprogramada</div>
                                <div class="activity-time">Hace 2 horas - De 10:00 AM a 11:00 AM</div>
                            </div>
                        </div>
                        <div class="activity-item">
                            <span class="activity-icon">🐾</span>
                            <div class="activity-content">
                                <div class="activity-title">Nueva mascota registrada</div>
                                <div class="activity-time">Hace 3 horas - Max (Golden Retriever)</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            // Animaciones y efectos interactivos
            document.addEventListener('DOMContentLoaded', function () {
                // Efecto de aparición escalonada para las tarjetas
                const cards = document.querySelectorAll('.card, .stat-card, .action-card');
                cards.forEach((card, index) => {
                    card.style.opacity = '0';
                    card.style.transform = 'translateY(30px)';

                    setTimeout(() => {
                        card.style.transition = 'all 0.6s cubic-bezier(0.4, 0, 0.2, 1)';
                        card.style.opacity = '1';
                        card.style.transform = 'translateY(0)';
                    }, index * 100);
                });

                // Efecto hover para botones
                const buttons = document.querySelectorAll('.btn');
                buttons.forEach(button => {
                    button.addEventListener('mouseenter', function () {
                        this.style.transform = 'translateY(-3px)';
                    });
                    button.addEventListener('mouseleave', function () {
                        this.style.transform = 'translateY(0)';
                    });
                });

                // Contador animado para las estadísticas
                const statNumbers = document.querySelectorAll('.stat-number');
                statNumbers.forEach(stat => {
                    const text = stat.textContent;
                    if (text.includes('S/')) {
                        const target = parseFloat(text.replace('S/ ', '').replace(',', ''));
                        if (!isNaN(target)) {
                            animateValue(stat, 0, target, 2000, 'S/ ');
                        }
                    } else if (text.includes('%')) {
                        const target = parseInt(text.replace('%', ''));
                        if (!isNaN(target)) {
                            animateValue(stat, 0, target, 2000, '', '%');
                        }
                    } else {
                        const target = parseInt(text);
                        if (!isNaN(target)) {
                            animateValue(stat, 0, target, 2000);
                        }
                    }
                });

                function animateValue(element, start, end, duration, prefix = '', suffix = '') {
                    let startTimestamp = null;
                    const step = (timestamp) => {
                        if (!startTimestamp)
                            startTimestamp = timestamp;
                        const progress = Math.min((timestamp - startTimestamp) / duration, 1);
                        const value = Math.floor(progress * (end - start) + start);

                        if (prefix === 'S/ ') {
                            element.textContent = prefix + value.toLocaleString('es-PE');
                        } else {
                            element.textContent = prefix + value + suffix;
                        }

                        if (progress < 1) {
                            window.requestAnimationFrame(step);
                        }
                    };
                    window.requestAnimationFrame(step);
                }

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
                            'Resumen completo del sistema - ' + now.toLocaleDateString('es-ES', options);
                }

                setInterval(updateTime, 1000);
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

            // Agregar evento de loading a los botones principales
            const mainButtons = document.querySelectorAll('.header-actions .btn, .quick-actions .btn');
            mainButtons.forEach(button => {
                button.addEventListener('click', function (e) {
                    if (this.href) {
                        showLoading(this);
                    }
                });
            });
        </script>
    </body>
</html>