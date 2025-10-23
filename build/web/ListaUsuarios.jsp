<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.UsuarioSistema, java.util.List"%>
<%
    // Verificar sesión y permisos
    HttpSession userSession = request.getSession(false);
    UsuarioSistema usuarioLogueado = null;
    if (userSession != null) {
        usuarioLogueado = (UsuarioSistema) userSession.getAttribute("usuarioLogueado");
    }
    
    if (usuarioLogueado == null || !"ADMINISTRADOR".equals(usuarioLogueado.getRol())) {
        response.sendRedirect("Login.jsp");
        return;
    }
    
    // Obtener datos del controlador
    List<UsuarioSistema> usuarios = (List<UsuarioSistema>) request.getAttribute("usuarios");
    String mensaje = (String) request.getAttribute("mensaje");
    String tipoMensaje = (String) request.getAttribute("tipoMensaje");
    
    // Obtener estadísticas
    Integer totalUsuarios = (Integer) request.getAttribute("totalUsuarios");
    Integer usuariosActivos = (Integer) request.getAttribute("usuariosActivos");
    Integer usuariosInactivos = (Integer) request.getAttribute("usuariosInactivos");
    Integer administradores = (Integer) request.getAttribute("administradores");
    Integer veterinarios = (Integer) request.getAttribute("veterinarios");
    Integer recepcionistas = (Integer) request.getAttribute("recepcionistas");
    Integer otrosRoles = (Integer) request.getAttribute("otrosRoles");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Usuarios del Sistema - Sistema PetCare</title>
    <style>
        /* ... (todo tu CSS se mantiene igual) ... */
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
                <div class="user-avatar" style="width: 50px; height: 50px; border-radius: 50%; background: rgba(255, 255, 255, 0.2); display: flex; align-items: center; justify-content: center; font-weight: bold;">
                    <%= usuarioLogueado != null ? usuarioLogueado.getNombre().charAt(0) : "👤" %>
                </div>
                <div class="user-details">
                    <h3><%= usuarioLogueado != null ? usuarioLogueado.getNombre() : "Usuario" %></h3>
                    <p><%= usuarioLogueado != null ? usuarioLogueado.getRol() : "Rol" %></p>
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
                    <a href="UsuarioSistemaControlador?accion=listarUsuarios">Usuarios</a>
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
                <a href="RegistrarUsuario.jsp" class="btn btn-primary">
                    ➕ Nuevo Usuario
                </a>
            </div>

            <!-- Mensajes del sistema -->
            <% if (mensaje != null) { %>
                <div class="message <%= tipoMensaje != null ? tipoMensaje : "success" %>" style="margin-bottom: 20px;">
                    <%= mensaje %>
                </div>
            <% } %>

            <!-- Estadísticas -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">👥</div>
                    <div class="stat-number" id="totalUsuarios"><%= totalUsuarios != null ? totalUsuarios : 0 %></div>
                    <div class="stat-label">Total Usuarios</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">🟢</div>
                    <div class="stat-number" id="usuariosActivos"><%= usuariosActivos != null ? usuariosActivos : 0 %></div>
                    <div class="stat-label">Usuarios Activos</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">👨‍⚕️</div>
                    <div class="stat-number" id="veterinarios"><%= veterinarios != null ? veterinarios : 0 %></div>
                    <div class="stat-label">Veterinarios</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">🔒</div>
                    <div class="stat-number" id="administradores"><%= administradores != null ? administradores : 0 %></div>
                    <div class="stat-label">Administradores</div>
                </div>
            </div>

            <!-- Controles y Filtros -->
            <div class="controls-section">
                <form action="UsuarioSistemaControlador" method="get" style="display: contents;">
                    <input type="hidden" name="accion" value="buscarUsuarios">
                    <div class="search-filters">
                        <div class="search-group">
                            <label>Buscar Usuario</label>
                            <input type="text" name="termino" class="search-input" placeholder="Nombre, usuario o email..." value="<%= request.getParameter("termino") != null ? request.getParameter("termino") : "" %>">
                        </div>
                        <div class="search-group">
                            <label>Rol</label>
                            <select name="rol" class="search-input">
                                <option value="">Todos los roles</option>
                                <option value="ADMINISTRADOR" <%= "ADMINISTRADOR".equals(request.getParameter("rol")) ? "selected" : "" %>>Administrador</option>
                                <option value="VETERINARIO" <%= "VETERINARIO".equals(request.getParameter("rol")) ? "selected" : "" %>>Veterinario</option>
                                <option value="GROOMER" <%= "GROOMER".equals(request.getParameter("rol")) ? "selected" : "" %>>Groomer</option>
                                <option value="RECEPCIONISTA" <%= "RECEPCIONISTA".equals(request.getParameter("rol")) ? "selected" : "" %>>Recepcionista</option>
                            </select>
                        </div>
                        <div class="search-group">
                            <label>Estado</label>
                            <select name="estado" class="search-input">
                                <option value="">Todos</option>
                                <option value="ACTIVO" <%= "ACTIVO".equals(request.getParameter("estado")) ? "selected" : "" %>>Activos</option>
                                <option value="INACTIVO" <%= "INACTIVO".equals(request.getParameter("estado")) ? "selected" : "" %>>Inactivos</option>
                            </select>
                        </div>
                    </div>
                    <div>
                        <button type="submit" class="btn btn-primary">
                            🔍 Buscar
                        </button>
                    </div>
                </form>
            </div>

            <!-- Lista de Usuarios -->
            <div class="users-grid" id="usuariosGrid">
                <% if (usuarios != null && !usuarios.isEmpty()) { 
                    for (UsuarioSistema usuario : usuarios) { %>
                        <div class="user-card">
                            <div class="user-header">
                                <div style="display: flex; align-items: center; width: 100%;">
                                    <div class="user-avatar"><%= obtenerIniciales(usuario.getNombre()) %></div>
                                    <div class="user-info">
                                        <div class="user-name"><%= usuario.getNombre() %></div>
                                        <div class="user-role">📧 <%= usuario.getEmail() %></div>
                                    </div>
                                    <div class="role-badge role-<%= usuario.getRol().toLowerCase() %>">
                                        <%= usuario.getRol() %>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="user-body">
                                <div class="info-grid">
                                    <div class="info-item">
                                        <span class="info-label">ID Usuario</span>
                                        <span class="info-value">#<%= usuario.getIdUsuario() %></span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">Fecha Creación</span>
                                        <span class="info-value">📅 <%= usuario.getCreatedAt() != null ? usuario.getCreatedAt().toString().substring(0, 10) : "N/A" %></span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">Estado</span>
                                        <span class="status-badge <%= obtenerClaseEstado(usuario.getEstado()) %>">
                                            <%= usuario.getEstado() != null ? usuario.getEstado() : "ACTIVO" %>
                                        </span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">Última Actualización</span>
                                        <span class="info-value">🕒 <%= usuario.getUpdatedAt() != null ? usuario.getUpdatedAt().toString().substring(0, 16) : "N/A" %></span>
                                    </div>
                                </div>

                                <div class="actions-bar">
                                    <a href="RegistrarUsuario.jsp?id=<%= usuario.getIdUsuario() %>&accion=editar" class="btn btn-sm btn-primary">
                                        ✏️ Editar
                                    </a>
                                    <% if ("ACTIVO".equals(usuario.getEstado())) { %>
                                        <a href="UsuarioSistemaControlador?accion=cambiarEstado&idUsuario=<%= usuario.getIdUsuario() %>&estado=INACTIVO" class="btn btn-sm btn-warning" onclick="return confirm('¿Desactivar usuario <%= usuario.getNombre() %>?')">
                                            🔴 Desactivar
                                        </a>
                                    <% } else { %>
                                        <a href="UsuarioSistemaControlador?accion=cambiarEstado&idUsuario=<%= usuario.getIdUsuario() %>&estado=ACTIVO" class="btn btn-sm btn-success" onclick="return confirm('¿Activar usuario <%= usuario.getNombre() %>?')">
                                            🟢 Activar
                                        </a>
                                    <% } %>
                                    <a href="UsuarioSistemaControlador?accion=eliminarUsuario&idUsuario=<%= usuario.getIdUsuario() %>" class="btn btn-sm btn-danger" onclick="return confirm('¿Está seguro de eliminar al usuario <%= usuario.getNombre() %>? Esta acción no se puede deshacer.')">
                                        🗑️ Eliminar
                                    </a>
                                </div>
                            </div>
                        </div>
                    <% } 
                } else { %>
                    <div class="empty-state" id="emptyState">
                        <div class="empty-icon">👤</div>
                        <div class="empty-text">No se encontraron usuarios</div>
                        <a href="RegistrarUsuario.jsp" class="btn btn-primary">
                            ➕ Crear Primer Usuario
                        </a>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <script>
        // Funciones auxiliares
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

        // Auto-enfocar el campo de búsqueda
        document.addEventListener('DOMContentLoaded', function() {
            const searchInput = document.querySelector('input[name="termino"]');
            if (searchInput) {
                searchInput.focus();
            }
        });
    </script>
</body>
</html>

<%!
    // Métodos auxiliares JSP
    private String obtenerIniciales(String nombre) {
        if (nombre == null || nombre.trim().isEmpty()) return "👤";
        String[] partes = nombre.split(" ");
        StringBuilder iniciales = new StringBuilder();
        for (String parte : partes) {
            if (!parte.isEmpty()) {
                iniciales.append(parte.charAt(0));
            }
        }
        return iniciales.toString().toUpperCase();
    }

    private String obtenerClaseEstado(String estado) {
        if (estado == null) return "status-inactive";
        switch(estado) {
            case "ACTIVO": return "status-active";
            case "INACTIVO": return "status-inactive";
            case "SUSPENDIDO": return "status-suspended";
            default: return "status-inactive";
        }
    }
%>