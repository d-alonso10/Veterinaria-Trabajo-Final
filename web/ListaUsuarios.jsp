<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Usuarios del Sistema - Sistema PetCare</title>
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

        .users-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
        }

        .user-card {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .user-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px rgba(0,0,0,0.15);
        }

        .user-header {
            background: var(--gradient-primary);
            color: var(--white);
            padding: 20px 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .user-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5em;
            font-weight: bold;
        }

        .user-info {
            flex: 1;
            margin-left: 15px;
        }

        .user-name {
            font-size: 1.3em;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .user-role {
            opacity: 0.9;
            font-size: 0.9em;
        }

        .user-body {
            padding: 25px;
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

        .status-suspended {
            background: #fff3cd;
            color: #856404;
        }

        .role-badge {
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 0.8em;
            font-weight: 600;
            text-transform: uppercase;
        }

        .role-admin {
            background: linear-gradient(135deg, var(--danger-color) 0%, #d32f2f 100%);
            color: var(--white);
        }

        .role-veterinario {
            background: linear-gradient(135deg, var(--info-color) 0%, #0b7dda 100%);
            color: var(--white);
        }

        .role-groomer {
            background: linear-gradient(135deg, var(--warning-color) 0%, #ffb300 100%);
            color: var(--text-dark);
        }

        .role-recepcionista {
            background: linear-gradient(135deg, var(--success-color) 0%, #45a049 100%);
            color: var(--white);
        }

        .actions-bar {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }

        .permissions-section {
            background: var(--bg-light);
            padding: 15px;
            border-radius: 12px;
            margin-top: 15px;
        }

        .permissions-title {
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 10px;
            font-size: 0.9em;
        }

        .permissions-list {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
        }

        .permission-tag {
            background: var(--primary-color);
            color: var(--white);
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.75em;
            font-weight: 500;
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

            .users-grid {
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
                    <a href="ListaMascotas.jsp">Mascotas</a>
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
                <li class="menu-item">
                    <span>🔧</span>
                    <a href="ListaDetallesServicios.jsp">Detalles Servicios</a>
                </li>
                <li class="menu-item">
                    <span>🔔</span>
                    <a href="UtilidadesNotificaciones.jsp">Notificaciones</a>
                </li>
                <li class="menu-item active">
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
                    <h1>👤 Usuarios del Sistema</h1>
                    <p>Administra los usuarios y permisos del sistema veterinario</p>
                </div>
                <a href="CrearUsuario.jsp" class="btn btn-primary">
                    ➕ Nuevo Usuario
                </a>
            </div>

            <!-- Estadísticas -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">👥</div>
                    <div class="stat-number" id="totalUsuarios">0</div>
                    <div class="stat-label">Total Usuarios</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">🟢</div>
                    <div class="stat-number" id="usuariosActivos">0</div>
                    <div class="stat-label">Usuarios Activos</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">👨‍⚕️</div>
                    <div class="stat-number" id="veterinarios">0</div>
                    <div class="stat-label">Veterinarios</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">🔒</div>
                    <div class="stat-number" id="administradores">0</div>
                    <div class="stat-label">Administradores</div>
                </div>
            </div>

            <!-- Controles y Filtros -->
            <div class="controls-section">
                <div class="search-filters">
                    <div class="search-group">
                        <label>Buscar Usuario</label>
                        <input type="text" id="searchUsuario" class="search-input" placeholder="Nombre, usuario o email...">
                    </div>
                    <div class="search-group">
                        <label>Rol</label>
                        <select id="filterRol" class="search-input">
                            <option value="">Todos los roles</option>
                            <option value="ADMIN">Administrador</option>
                            <option value="VETERINARIO">Veterinario</option>
                            <option value="GROOMER">Groomer</option>
                            <option value="RECEPCIONISTA">Recepcionista</option>
                        </select>
                    </div>
                    <div class="search-group">
                        <label>Estado</label>
                        <select id="filterEstado" class="search-input">
                            <option value="">Todos</option>
                            <option value="ACTIVO">Activos</option>
                            <option value="INACTIVO">Inactivos</option>
                            <option value="SUSPENDIDO">Suspendidos</option>
                        </select>
                    </div>
                </div>
                <div>
                    <button class="btn btn-primary" onclick="buscarUsuarios()">
                        🔍 Buscar
                    </button>
                </div>
            </div>

            <!-- Lista de Usuarios -->
            <div class="users-grid" id="usuariosGrid">
                <!-- Los usuarios se cargarán aquí dinámicamente -->
            </div>

            <!-- Estado Vacío -->
            <div class="empty-state" id="emptyState" style="display: none;">
                <div class="empty-icon">👤</div>
                <div class="empty-text">No se encontraron usuarios</div>
                <a href="CrearUsuario.jsp" class="btn btn-primary">
                    ➕ Crear Primer Usuario
                </a>
            </div>
        </div>
    </div>

    <script>
        // Datos de ejemplo para usuarios
        const usuarios = [
            {
                id: 1,
                nombre: "Dr. Carlos Mendez",
                usuario: "cmendez",
                email: "carlos.mendez@petcare.com",
                rol: "ADMIN",
                estado: "ACTIVO",
                telefono: "555-0101",
                fechaCreacion: "2024-01-10",
                ultimoAcceso: "2024-03-15 09:30",
                permisos: ["Gestión Completa", "Usuarios", "Reportes", "Configuración"]
            },
            {
                id: 2,
                nombre: "Dra. Ana Rodriguez",
                usuario: "arodriguez",
                email: "ana.rodriguez@petcare.com",
                rol: "VETERINARIO",
                estado: "ACTIVO",
                telefono: "555-0102",
                fechaCreacion: "2024-01-15",
                ultimoAcceso: "2024-03-15 14:15",
                permisos: ["Consultas", "Diagnósticos", "Historiales", "Recetas"]
            },
            {
                id: 3,
                nombre: "María González",
                usuario: "mgonzalez",
                email: "maria.gonzalez@petcare.com",
                rol: "GROOMER",
                estado: "ACTIVO",
                telefono: "555-0103",
                fechaCreacion: "2024-01-20",
                ultimoAcceso: "2024-03-14 16:45",
                permisos: ["Servicios Grooming", "Citas Grooming", "Inventario"]
            },
            {
                id: 4,
                nombre: "Pedro Salazar",
                usuario: "psalazar",
                email: "pedro.salazar@petcare.com",
                rol: "RECEPCIONISTA",
                estado: "ACTIVO",
                telefono: "555-0104",
                fechaCreacion: "2024-02-01",
                ultimoAcceso: "2024-03-15 08:00",
                permisos: ["Citas", "Clientes", "Pagos", "Notificaciones"]
            },
            {
                id: 5,
                nombre: "Dr. Luis Torres",
                usuario: "ltorres",
                email: "luis.torres@petcare.com",
                rol: "VETERINARIO",
                estado: "SUSPENDIDO",
                telefono: "555-0105",
                fechaCreacion: "2024-01-25",
                ultimoAcceso: "2024-03-10 11:20",
                permisos: ["Consultas", "Diagnósticos"]
            },
            {
                id: 6,
                nombre: "Sofia Martinez",
                usuario: "smartinez",
                email: "sofia.martinez@petcare.com",
                rol: "GROOMER",
                estado: "INACTIVO",
                telefono: "555-0106",
                fechaCreacion: "2024-02-10",
                ultimoAcceso: "2024-02-28 17:30",
                permisos: ["Servicios Grooming"]
            }
        ];

        function inicializarPagina() {
            cargarUsuarios();
            actualizarEstadisticas();
        }

        function cargarUsuarios() {
            renderizarUsuarios(usuarios);
        }

        function renderizarUsuarios(usuariosLista) {
            const grid = document.getElementById('usuariosGrid');
            const emptyState = document.getElementById('emptyState');

            if (usuariosLista.length === 0) {
                grid.style.display = 'none';
                emptyState.style.display = 'block';
                return;
            }

            grid.style.display = 'grid';
            emptyState.style.display = 'none';
            
            grid.innerHTML = usuariosLista.map(usuario => `
                <div class="user-card">
                    <div class="user-header">
                        <div style="display: flex; align-items: center; width: 100%;">
                            <div class="user-avatar">${obtenerIniciales(usuario.nombre)}</div>
                            <div class="user-info">
                                <div class="user-name">${usuario.nombre}</div>
                                <div class="user-role">@${usuario.usuario}</div>
                            </div>
                            <div class="role-badge role-${usuario.rol.toLowerCase()}">
                                ${usuario.rol}
                            </div>
                        </div>
                    </div>
                    
                    <div class="user-body">
                        <div class="info-grid">
                            <div class="info-item">
                                <span class="info-label">Email</span>
                                <span class="info-value">📧 ${usuario.email}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Teléfono</span>
                                <span class="info-value">📞 ${usuario.telefono}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Estado</span>
                                <span class="status-badge ${obtenerClaseEstado(usuario.estado)}">
                                    ${usuario.estado}
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Último Acceso</span>
                                <span class="info-value">🕒 ${formatearFechaHora(usuario.ultimoAcceso)}</span>
                            </div>
                        </div>

                        ${usuario.permisos && usuario.permisos.length > 0 ? `
                            <div class="permissions-section">
                                <div class="permissions-title">🔑 Permisos</div>
                                <div class="permissions-list">
                                    ${usuario.permisos.map(permiso => 
                                        `<span class="permission-tag">${permiso}</span>`
                                    ).join('')}
                                </div>
                            </div>
                        ` : ''}

                        <div class="actions-bar">
                            <button class="btn btn-sm btn-primary" onclick="editarUsuario(${usuario.id})">
                                ✏️ Editar
                            </button>
                            <button class="btn btn-sm btn-warning" onclick="cambiarEstado(${usuario.id})">
                                🔄 Estado
                            </button>
                            <button class="btn btn-sm btn-danger" onclick="eliminarUsuario(${usuario.id})">
                                🗑️ Eliminar
                            </button>
                        </div>
                    </div>
                </div>
            `).join('');
        }

        function actualizarEstadisticas() {
            const total = usuarios.length;
            const activos = usuarios.filter(u => u.estado === 'ACTIVO').length;
            const veterinarios = usuarios.filter(u => u.rol === 'VETERINARIO').length;
            const administradores = usuarios.filter(u => u.rol === 'ADMIN').length;

            document.getElementById('totalUsuarios').textContent = total;
            document.getElementById('usuariosActivos').textContent = activos;
            document.getElementById('veterinarios').textContent = veterinarios;
            document.getElementById('administradores').textContent = administradores;
        }

        function buscarUsuarios() {
            const searchTerm = document.getElementById('searchUsuario').value.toLowerCase();
            const rolFilter = document.getElementById('filterRol').value;
            const estadoFilter = document.getElementById('filterEstado').value;

            let usuariosFiltrados = usuarios.filter(usuario => {
                const matchesSearch = !searchTerm || 
                    usuario.nombre.toLowerCase().includes(searchTerm) ||
                    usuario.usuario.toLowerCase().includes(searchTerm) ||
                    usuario.email.toLowerCase().includes(searchTerm);
                
                const matchesRol = !rolFilter || usuario.rol === rolFilter;
                const matchesEstado = !estadoFilter || usuario.estado === estadoFilter;

                return matchesSearch && matchesRol && matchesEstado;
            });

            renderizarUsuarios(usuariosFiltrados);
        }

        function obtenerIniciales(nombre) {
            return nombre.split(' ').map(n => n.charAt(0)).join('').substring(0, 2).toUpperCase();
        }

        function obtenerClaseEstado(estado) {
            switch(estado) {
                case 'ACTIVO': return 'status-active';
                case 'INACTIVO': return 'status-inactive';
                case 'SUSPENDIDO': return 'status-suspended';
                default: return 'status-inactive';
            }
        }

        function formatearFechaHora(fechaHora) {
            if (!fechaHora) return 'Nunca';
            const [fecha, hora] = fechaHora.split(' ');
            const fechaObj = new Date(fecha + 'T' + hora);
            return fechaObj.toLocaleDateString('es-ES', {
                month: 'short',
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            });
        }

        function editarUsuario(id) {
            window.location.href = `CrearUsuario.jsp?id=${id}&accion=editar`;
        }

        function cambiarEstado(id) {
            const usuario = usuarios.find(u => u.id === id);
            const nuevoEstado = usuario.estado === 'ACTIVO' ? 'INACTIVO' : 'ACTIVO';
            
            if (confirm(`¿Cambiar estado de ${usuario.nombre} a ${nuevoEstado}?`)) {
                usuario.estado = nuevoEstado;
                cargarUsuarios();
                actualizarEstadisticas();
                alert(`Estado actualizado a ${nuevoEstado}`);
            }
        }

        function eliminarUsuario(id) {
            const usuario = usuarios.find(u => u.id === id);
            if (confirm(`¿Está seguro de eliminar al usuario "${usuario.nombre}"?\n\nEsta acción no se puede deshacer.`)) {
                const index = usuarios.findIndex(u => u.id === id);
                if (index > -1) {
                    usuarios.splice(index, 1);
                    cargarUsuarios();
                    actualizarEstadisticas();
                    alert('Usuario eliminado correctamente');
                }
            }
        }

        // Búsqueda en tiempo real
        document.getElementById('searchUsuario').addEventListener('input', buscarUsuarios);
        document.getElementById('filterRol').addEventListener('change', buscarUsuarios);
        document.getElementById('filterEstado').addEventListener('change', buscarUsuarios);

        // Inicializar la página
        document.addEventListener('DOMContentLoaded', inicializarPagina);
    </script>
</body>
</html>