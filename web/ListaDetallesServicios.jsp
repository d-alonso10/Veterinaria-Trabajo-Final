<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalles de Servicios - Sistema PetCare</title>
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
            --gradient-danger: linear-gradient(135deg, var(--danger-color) 0%, #d32f2f 100%);
            --gradient-warning: linear-gradient(135deg, var(--warning-color) 0%, #ffb300 100%);
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

        .user-info {
            padding: 25px 20px;
            display: flex;
            align-items: center;
            gap: 15px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            background: rgba(255, 255, 255, 0.05);
        }

        .menu {
            list-style: none;
            padding: 25px 0;
        }

        .menu-item {
            padding: 16px 30px;
            border-left: 4px solid transparent;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .menu-item:hover, .menu-item.active {
            background: rgba(255, 255, 255, 0.15);
            border-left-color: var(--white);
            transform: translateX(8px);
        }

        .menu-item a {
            color: var(--white);
            text-decoration: none;
            font-weight: 500;
        }

        .main-content {
            flex: 1;
            padding: 40px;
            overflow-y: auto;
        }

        .header {
            background: var(--white);
            padding: 30px 40px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            font-size: 2.2em;
            color: var(--text-dark);
            margin-bottom: 8px;
            font-weight: 700;
        }

        .header p {
            color: var(--text-light);
            font-size: 1.1em;
            margin: 0;
        }

        .controls-section {
            background: var(--white);
            padding: 25px 30px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 20px;
            display: grid;
            grid-template-columns: 1fr auto;
            gap: 20px;
            align-items: center;
        }

        .search-filters {
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .search-group {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .search-group label {
            font-size: 0.9em;
            color: var(--text-light);
            font-weight: 500;
        }

        .search-input {
            padding: 12px 16px;
            border: 2px solid #e0e0e0;
            border-radius: var(--radius);
            font-size: 0.95em;
            min-width: 200px;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(171, 203, 213, 0.1);
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: var(--radius);
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            font-size: 0.95em;
            justify-content: center;
        }

        .btn-primary {
            background: var(--gradient-primary);
            color: var(--white);
            box-shadow: 0 4px 15px rgba(171, 203, 213, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(171, 203, 213, 0.4);
        }

        .btn-success {
            background: var(--gradient-success);
            color: var(--white);
        }

        .btn-warning {
            background: var(--gradient-warning);
            color: var(--text-dark);
        }

        .btn-danger {
            background: var(--gradient-danger);
            color: var(--white);
        }

        .btn-sm {
            padding: 8px 16px;
            font-size: 0.85em;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: var(--white);
            padding: 25px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            text-align: center;
            position: relative;
            overflow: hidden;
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

        .stat-icon {
            font-size: 3em;
            margin-bottom: 15px;
        }

        .stat-number {
            font-size: 2.5em;
            font-weight: 800;
            color: var(--text-dark);
            margin-bottom: 5px;
        }

        .stat-label {
            color: var(--text-light);
            font-size: 1.1em;
            font-weight: 500;
        }

        .details-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
        }

        .detail-card {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .detail-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px rgba(0,0,0,0.15);
        }

        .detail-header {
            background: var(--gradient-primary);
            color: var(--white);
            padding: 20px 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .detail-title {
            font-size: 1.3em;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .detail-body {
            padding: 25px;
        }

        .detail-info {
            margin-bottom: 20px;
        }

        .detail-info h4 {
            color: var(--text-dark);
            margin-bottom: 8px;
            font-size: 1.1em;
        }

        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 20px;
        }

        .info-item {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .info-label {
            font-size: 0.9em;
            color: var(--text-light);
            font-weight: 500;
        }

        .info-value {
            font-weight: 600;
            color: var(--text-dark);
        }

        .price-badge {
            background: var(--gradient-success);
            color: var(--white);
            padding: 8px 15px;
            border-radius: 25px;
            font-weight: 700;
            font-size: 1.1em;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-active {
            background: #d4edda;
            color: #155724;
        }

        .status-inactive {
            background: #f8d7da;
            color: #721c24;
        }

        .actions-bar {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }

        .description-section {
            background: var(--bg-light);
            padding: 15px;
            border-radius: 12px;
            margin-top: 15px;
        }

        .description-text {
            color: var(--text-light);
            font-style: italic;
            line-height: 1.5;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
        }

        .empty-icon {
            font-size: 4em;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .empty-text {
            font-size: 1.2em;
            color: var(--text-light);
            margin-bottom: 25px;
        }

        @media (max-width: 768px) {
            .controls-section {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .search-filters {
                flex-direction: column;
                align-items: stretch;
            }

            .search-input {
                min-width: auto;
            }

            .details-grid {
                grid-template-columns: 1fr;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="logo">
                <h1>🐾 PetCare</h1>
            </div>
            
            <div class="user-info">
                <div class="user-avatar" style="width: 50px; height: 50px; border-radius: 50%; background: rgba(255, 255, 255, 0.2); display: flex; align-items: center; justify-content: center; font-weight: bold;">👨‍⚕️</div>
                <div class="user-details">
                    <h3>Dr. Admin</h3>
                    <p>Administrador</p>
                </div>
            </div>

            <ul class="menu">
                <li class="menu-item">
                    <span>📊</span>
                    <a href="Menu.jsp">Dashboard</a>
                </li>
                <li class="menu-item">
                    <span>👥</span>
                    <a href="ListaClientes.jsp">Clientes</a>
                </li>
                <li class="menu-item">
                    <span>🐕</span>
                    <a href="<%= request.getContextPath() %>/MascotaControlador?accion=listarTodas">Mascotas</a>
                </li>
                <li class="menu-item">
                    <span>👨‍⚕️</span>
                    <a href="ListaGroomers.jsp">Groomers</a>
                </li>
                <li class="menu-item">
                    <span>🎯</span>
                    <a href="ListaServicios.jsp">Servicios</a>
                </li>
                <li class="menu-item">
                    <span>📅</span>
                    <a href="ProximasCitas.jsp">Citas</a>
                </li>
                <li class="menu-item">
                    <span>⏰</span>
                    <a href="ColaAtencion.jsp">Cola de Atención</a>
                </li>
                <li class="menu-item">
                    <span>💰</span>
                    <a href="UtilidadesFacturas.jsp">Facturas</a>
                </li>
                <li class="menu-item">
                    <span>💳</span>
                    <a href="ListaPagos.jsp">Pagos</a>
                </li>
                <li class="menu-item">
                    <span>📋</span>
                    <a href="ListaPaquetesServicios.jsp">Paquetes</a>
                </li>
                <li class="menu-item">
                    <span>🎁</span>
                    <a href="ListaPromociones.jsp">Promociones</a>
                </li>
                <li class="menu-item active">
                    <span>🔧</span>
                    <a href="ListaDetallesServicios.jsp">Detalles Servicios</a>
                </li>
                <li class="menu-item">
                    <span>🔔</span>
                    <a href="UtilidadesNotificaciones.jsp">Notificaciones</a>
                </li>
                <li class="menu-item">
                    <span>👤</span>
                    <a href="ListaUsuarios.jsp">Usuarios</a>
                </li>
                <li class="menu-item">
                    <span>📊</span>
                    <a href="ReporteIngresos.jsp">Reportes</a>
                </li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="header">
                <div>
                    <h1>🔧 Detalles de Servicios</h1>
                    <p>Gestiona los componentes y especificaciones detalladas de cada servicio</p>
                </div>
                <a href="CrearDetalleServicio.jsp" class="btn btn-primary">
                    ➕ Nuevo Detalle
                </a>
            </div>

            <!-- Estadísticas -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">📋</div>
                    <div class="stat-number" id="totalDetalles">0</div>
                    <div class="stat-label">Total Detalles</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">🔥</div>
                    <div class="stat-number" id="detallesActivos">0</div>
                    <div class="stat-label">Detalles Activos</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">🎯</div>
                    <div class="stat-number" id="serviciosConDetalles">0</div>
                    <div class="stat-label">Servicios con Detalles</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">💰</div>
                    <div class="stat-number" id="costoPromedio">$0</div>
                    <div class="stat-label">Costo Promedio</div>
                </div>
            </div>

            <!-- Controles y Filtros -->
            <div class="controls-section">
                <div class="search-filters">
                    <div class="search-group">
                        <label>Buscar Detalle</label>
                        <input type="text" id="searchDetalle" class="search-input" placeholder="Nombre, descripción o servicio...">
                    </div>
                    <div class="search-group">
                        <label>Servicio</label>
                        <select id="filterServicio" class="search-input">
                            <option value="">Todos los servicios</option>
                        </select>
                    </div>
                    <div class="search-group">
                        <label>Estado</label>
                        <select id="filterEstado" class="search-input">
                            <option value="">Todos</option>
                            <option value="ACTIVO">Activos</option>
                            <option value="INACTIVO">Inactivos</option>
                        </select>
                    </div>
                </div>
                <div>
                    <button class="btn btn-primary" onclick="buscarDetalles()">
                        🔍 Buscar
                    </button>
                </div>
            </div>

            <!-- Lista de Detalles -->
            <div class="details-grid" id="detallesGrid">
                <!-- Los detalles se cargarán aquí dinámicamente -->
            </div>

            <!-- Estado Vacío -->
            <div class="empty-state" id="emptyState" style="display: none;">
                <div class="empty-icon">🔧</div>
                <div class="empty-text">No se encontraron detalles de servicios</div>
                <a href="CrearDetalleServicio.jsp" class="btn btn-primary">
                    ➕ Crear Primer Detalle
                </a>
            </div>
        </div>
    </div>

    <script>
        // Datos de ejemplo para detalles de servicios
        const detallesServicios = [
            {
                id: 1,
                nombre: "Corte de Uñas Especializado",
                servicioNombre: "Grooming Completo",
                servicioId: 1,
                descripcion: "Corte profesional de uñas con técnica especializada para evitar el nervio",
                costo: 15.50,
                tiempoEstimado: 15,
                estado: "ACTIVO",
                instrucciones: "Utilizar cortauñas específico para la raza. Revisar largo del nervio antes del corte.",
                materiales: ["Cortauñas profesional", "Lima para mascotas", "Polvo hemostático"],
                fechaCreacion: "2024-01-15",
                ultimaModificacion: "2024-03-10"
            },
            {
                id: 2,
                nombre: "Limpieza de Oídos Profunda",
                servicioNombre: "Grooming Completo",
                servicioId: 1,
                descripcion: "Limpieza completa del canal auditivo con productos especializados",
                costo: 12.00,
                tiempoEstimado: 10,
                estado: "ACTIVO",
                instrucciones: "Usar solución limpiadora específica. No introducir hisopos profundamente.",
                materiales: ["Solución limpiadora ótica", "Gasas estériles", "Hisopos especiales"],
                fechaCreacion: "2024-01-20",
                ultimaModificacion: "2024-02-28"
            },
            {
                id: 3,
                nombre: "Análisis de Sangre Básico",
                servicioNombre: "Consulta Veterinaria",
                servicioId: 2,
                descripcion: "Hemograma completo y química sanguínea básica",
                costo: 45.00,
                tiempoEstimado: 30,
                estado: "ACTIVO",
                instrucciones: "Ayuno de 12 horas previo. Extraer muestra de vena cefálica o yugular.",
                materiales: ["Tubos de ensayo", "Agujas 21G", "Jeringas 3ml", "Alcohol 70%"],
                fechaCreacion: "2024-02-01",
                ultimaModificacion: "2024-03-05"
            },
            {
                id: 4,
                nombre: "Aplicación de Champú Medicado",
                servicioNombre: "Baño Medicado",
                servicioId: 3,
                descripcion: "Tratamiento con champú específico para problemas dermatológicos",
                costo: 8.00,
                tiempoEstimado: 20,
                estado: "ACTIVO",
                instrucciones: "Dejar actuar el champú por 10 minutos. Enjuagar completamente.",
                materiales: ["Champú medicado", "Guantes de nitrilo", "Toallas absorbentes"],
                fechaCreacion: "2024-01-25",
                ultimaModificacion: "2024-03-12"
            },
            {
                id: 5,
                nombre: "Vacuna Antirrábica",
                servicioNombre: "Vacunación",
                servicioId: 4,
                descripcion: "Aplicación de vacuna antirrábica anual",
                costo: 25.00,
                tiempoEstimado: 5,
                estado: "INACTIVO",
                instrucciones: "Verificar historial de vacunación. Aplicar vía subcutánea en el cuello.",
                materiales: ["Vacuna antirrábica", "Jeringa 1ml", "Aguja 25G", "Alcohol"],
                fechaCreacion: "2024-01-10",
                ultimaModificacion: "2024-03-01"
            },
            {
                id: 6,
                nombre: "Revisión Dental Completa",
                servicioNombre: "Consulta Veterinaria",
                servicioId: 2,
                descripcion: "Evaluación completa del estado dental y oral",
                costo: 20.00,
                tiempoEstimado: 25,
                estado: "ACTIVO",
                instrucciones: "Revisar presencia de sarro, gingivitis y movilidad dental.",
                materiales: ["Espejo dental", "Sonda periodontal", "Guantes", "Linterna"],
                fechaCreacion: "2024-02-10",
                ultimaModificacion: "2024-03-08"
            }
        ];

        // Datos de servicios para el filtro
        const servicios = [
            { id: 1, nombre: "Grooming Completo" },
            { id: 2, nombre: "Consulta Veterinaria" },
            { id: 3, nombre: "Baño Medicado" },
            { id: 4, nombre: "Vacunación" }
        ];

        function inicializarPagina() {
            cargarServicios();
            cargarDetalles();
            actualizarEstadisticas();
        }

        function cargarServicios() {
            const select = document.getElementById('filterServicio');
            servicios.forEach(servicio => {
                const option = document.createElement('option');
                option.value = servicio.id;
                option.textContent = servicio.nombre;
                select.appendChild(option);
            });
        }

        function cargarDetalles() {
            renderizarDetalles(detallesServicios);
        }

        function renderizarDetalles(detalles) {
            const grid = document.getElementById('detallesGrid');
            const emptyState = document.getElementById('emptyState');

            if (detalles.length === 0) {
                grid.style.display = 'none';
                emptyState.style.display = 'block';
                return;
            }

            grid.style.display = 'grid';
            emptyState.style.display = 'none';
            
            grid.innerHTML = detalles.map(detalle => `
                <div class="detail-card">
                    <div class="detail-header">
                        <div class="detail-title">
                            🔧 ${detalle.nombre}
                        </div>
                        <div class="price-badge">$${detalle.costo.toFixed(2)}</div>
                    </div>
                    
                    <div class="detail-body">
                        <div class="detail-info">
                            <h4>📋 Información General</h4>
                            <div class="info-grid">
                                <div class="info-item">
                                    <span class="info-label">Servicio</span>
                                    <span class="info-value">${detalle.servicioNombre}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Tiempo Estimado</span>
                                    <span class="info-value">⏱️ ${detalle.tiempoEstimado} min</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Estado</span>
                                    <span class="status-badge ${detalle.estado === 'ACTIVO' ? 'status-active' : 'status-inactive'}">
                                        ${detalle.estado}
                                    </span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Última Modificación</span>
                                    <span class="info-value">${formatearFecha(detalle.ultimaModificacion)}</span>
                                </div>
                            </div>
                        </div>

                        ${detalle.descripcion ? `
                            <div class="description-section">
                                <div class="description-text">${detalle.descripcion}</div>
                            </div>
                        ` : ''}

                        ${detalle.materiales && detalle.materiales.length > 0 ? `
                            <div class="detail-info">
                                <h4>🧰 Materiales Necesarios</h4>
                                <div style="display: flex; flex-wrap: wrap; gap: 8px; margin-top: 10px;">
                                    ${detalle.materiales.map(material => 
                                        `<span style="background: var(--bg-light); padding: 6px 12px; border-radius: 15px; font-size: 0.85em; color: var(--text-dark);">${material}</span>`
                                    ).join('')}
                                </div>
                            </div>
                        ` : ''}

                        <div class="actions-bar">
                            <button class="btn btn-sm btn-primary" onclick="editarDetalle(${detalle.id})">
                                ✏️ Editar
                            </button>
                            <button class="btn btn-sm btn-warning" onclick="verInstrucciones(${detalle.id})">
                                📖 Instrucciones
                            </button>
                            <button class="btn btn-sm btn-danger" onclick="eliminarDetalle(${detalle.id})">
                                🗑️ Eliminar
                            </button>
                        </div>
                    </div>
                </div>
            `).join('');
        }

        function actualizarEstadisticas() {
            const total = detallesServicios.length;
            const activos = detallesServicios.filter(d => d.estado === 'ACTIVO').length;
            const serviciosUnicos = [...new Set(detallesServicios.map(d => d.servicioId))].length;
            const costoPromedio = detallesServicios.reduce((sum, d) => sum + d.costo, 0) / total || 0;

            document.getElementById('totalDetalles').textContent = total;
            document.getElementById('detallesActivos').textContent = activos;
            document.getElementById('serviciosConDetalles').textContent = serviciosUnicos;
            document.getElementById('costoPromedio').textContent = `$${costoPromedio.toFixed(2)}`;
        }

        function buscarDetalles() {
            const searchTerm = document.getElementById('searchDetalle').value.toLowerCase();
            const servicioFilter = document.getElementById('filterServicio').value;
            const estadoFilter = document.getElementById('filterEstado').value;

            let detallesFiltrados = detallesServicios.filter(detalle => {
                const matchesSearch = !searchTerm || 
                    detalle.nombre.toLowerCase().includes(searchTerm) ||
                    detalle.descripcion.toLowerCase().includes(searchTerm) ||
                    detalle.servicioNombre.toLowerCase().includes(searchTerm);
                
                const matchesServicio = !servicioFilter || detalle.servicioId == servicioFilter;
                const matchesEstado = !estadoFilter || detalle.estado === estadoFilter;

                return matchesSearch && matchesServicio && matchesEstado;
            });

            renderizarDetalles(detallesFiltrados);
        }

        function editarDetalle(id) {
            window.location.href = `CrearDetalleServicio.jsp?id=${id}&accion=editar`;
        }

        function verInstrucciones(id) {
            const detalle = detallesServicios.find(d => d.id === id);
            if (detalle && detalle.instrucciones) {
                alert(`📖 Instrucciones para "${detalle.nombre}":\n\n${detalle.instrucciones}`);
            } else {
                alert('No hay instrucciones específicas para este detalle.');
            }
        }

        function eliminarDetalle(id) {
            const detalle = detallesServicios.find(d => d.id === id);
            if (confirm(`¿Está seguro de eliminar el detalle "${detalle.nombre}"?`)) {
                // Aquí iría la lógica para eliminar
                alert('Detalle eliminado correctamente');
                // Recargar la lista
                const index = detallesServicios.findIndex(d => d.id === id);
                if (index > -1) {
                    detallesServicios.splice(index, 1);
                    cargarDetalles();
                    actualizarEstadisticas();
                }
            }
        }

        function formatearFecha(fecha) {
            return new Date(fecha).toLocaleDateString('es-ES', {
                year: 'numeric',
                month: 'short',
                day: 'numeric'
            });
        }

        // Búsqueda en tiempo real
        document.getElementById('searchDetalle').addEventListener('input', buscarDetalles);
        document.getElementById('filterServicio').addEventListener('change', buscarDetalles);
        document.getElementById('filterEstado').addEventListener('change', buscarDetalles);

        // Inicializar la página
        document.addEventListener('DOMContentLoaded', inicializarPagina);
    </script>
</body>
</html>