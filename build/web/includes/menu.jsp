<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- Sidebar Menu Include -->
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
        <li class="menu-item <%= request.getRequestURI().contains("Dashboard.jsp") || request.getRequestURI().contains("Menu.jsp") ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/DashboardControlador">
                <span class="menu-icon">&#128202;</span>
                <span>Dashboard</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="<%= request.getContextPath() %>/CitaControlador?accion=todasCitas">
                <span class="menu-icon">&#128197;</span>
                <span>Citas</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="<%= request.getContextPath() %>/AtencionControlador?accion=listar">
                <span class="menu-icon">&#127919;</span>
                <span>Atención</span>
            </a>
        </li>
        
        <!-- Gestión de Clientes -->
        <div class="menu-section">Gestión de Clientes</div>
        <li class="menu-item">
            <a href="<%= request.getContextPath() %>/ClienteControlador?accion=listarTodos">
                <span class="menu-icon">&#128101;</span>
                <span>Clientes</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="<%= request.getContextPath() %>/MascotaControlador?accion=listarTodas">
                <span class="menu-icon">&#128062;</span>
                <span>Mascotas</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="<%= request.getContextPath() %>/ServicioControlador?accion=listar">
                <span class="menu-icon">&#128736;</span>
                <span>Servicios</span>
            </a>
        </li>
        <li class="menu-item <%= request.getRequestURI().contains("ListaDetallesServicios.jsp") ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/DetalleServicioControlador?accion=listar">
                <span class="menu-icon">&#128295;</span>
                <span>Detalles de Servicios</span>
            </a>
        </li>
        <li class="menu-item <%= request.getRequestURI().contains("CrearDetalleServicio.jsp") ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/DetalleServicioControlador?accion=mostrarFormulario">
                <span class="menu-icon">&#9889;</span>
                <span>Crear Detalle Servicio</span>
            </a>
        </li>
        <li class="menu-item <%= request.getRequestURI().contains("ListaPaquetesServicios.jsp") ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/PaqueteServicioControlador?accion=listar">
                <span class="menu-icon">&#128230;</span>
                <span>Paquetes de Servicios</span>
            </a>
        </li>
        <li class="menu-item <%= request.getRequestURI().contains("CrearPaqueteServicio.jsp") ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/PaqueteServicioControlador?accion=mostrarFormulario">
                <span class="menu-icon">&#127919;</span>
                <span>Crear Paquete Servicio</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="<%= request.getContextPath() %>/ClienteControlador?accion=listarFrecuentes">
                <span class="menu-icon">🏆</span>
                <span>Clientes Frecuentes</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="<%= request.getContextPath() %>/ClienteControlador?accion=mostrarBusqueda">
                <span class="menu-icon">&#128269;</span>
                <span>Búsqueda Avanzada</span>
            </a>
        </li>
        
        <!-- Personal y Operaciones -->
        <div class="menu-section">Personal y Operaciones</div>
        <li class="menu-item">
            <a href="<%= request.getContextPath() %>/GroomerControlador?accion=listar">
                <span class="menu-icon">&#9986;</span>
                <span>Groomers</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="<%= request.getContextPath() %>/SucursalControlador?accion=listar">
                <span class="menu-icon">&#127970;</span>
                <span>Sucursales</span>
            </a>
        </li>
        
        <!-- Finanzas -->
        <div class="menu-section">Finanzas</div>
        <li class="menu-item <%= request.getRequestURI().contains("ListaPagos.jsp") ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/PagoControlador?accion=listar">
                <span class="menu-icon">&#128179;</span>
                <span>Lista de Pagos</span>
            </a>
        </li>
        <li class="menu-item <%= request.getRequestURI().contains("RegistrarPago.jsp") ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/PagoControlador?accion=mostrarFormulario">
                <span class="menu-icon">💰</span>
                <span>Registrar Pago</span>
            </a>
        </li>
        <li class="menu-item <%= request.getRequestURI().contains("ListaFacturas.jsp") ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/FacturaControlador?accion=listar">
                <span class="menu-icon">&#129534;</span>
                <span>Lista de Facturas</span>
            </a>
        </li>
        <li class="menu-item <%= request.getRequestURI().contains("CrearFactura.jsp") ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/FacturaControlador?accion=mostrarFormulario">
                <span class="menu-icon">📄</span>
                <span>Crear Factura</span>
            </a>
        </li>
        <li class="menu-item <%= request.getRequestURI().contains("ListaPromociones.jsp") ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/PromocionControlador?accion=listar">
                <span class="menu-icon">🎁</span>
                <span>Lista de Promociones</span>
            </a>
        </li>
        <li class="menu-item <%= request.getRequestURI().contains("CrearPromocion.jsp") ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/PromocionControlador?accion=mostrarFormulario">
                <span class="menu-icon">🎉</span>
                <span>Crear Promoción</span>
            </a>
        </li>
        
        <!-- Comunicaciones -->
        <div class="menu-section">Comunicaciones</div>
        <li class="menu-item <%= request.getRequestURI().contains("ListaNotificaciones.jsp") ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/NotificacionControlador?accion=listar">
                <span class="menu-icon">🔔</span>
                <span>Lista de Notificaciones</span>
            </a>
        </li>
        <li class="menu-item <%= request.getRequestURI().contains("CrearNotificacion.jsp") ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/NotificacionControlador?accion=mostrarFormulario">
                <span class="menu-icon">📢</span>
                <span>Crear Notificación</span>
            </a>
        </li>
        
        <!-- Análisis y Control -->
        <div class="menu-section">Análisis y Control</div>
        <li class="menu-item">
            <a href="<%= request.getContextPath() %>/ReporteControlador?accion=mostrar">
                <span class="menu-icon">&#128200;</span>
                <span>Reportes</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="<%= request.getContextPath() %>/AuditControlador?accion=listar">
                <span class="menu-icon">&#128269;</span>
                <span>Auditoria</span>
            </a>
        </li>
        
        <!-- Sistema -->
        <div class="menu-section">Sistema</div>
        <li class="menu-item <%= request.getRequestURI().contains("ListaUsuarios.jsp") ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/UsuarioSistemaControlador?accion=listar">
                <span class="menu-icon">&#128100;</span>
                <span>Lista de Usuarios</span>
            </a>
        </li>
        <li class="menu-item <%= request.getRequestURI().contains("CrearUsuario.jsp") ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/UsuarioSistemaControlador?accion=mostrarFormulario">
                <span class="menu-icon">&#128101;</span>
                <span>Crear Usuario</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="<%= request.getContextPath() %>/UtilidadesControlador?accion=mostrarPanel">
                <span class="menu-icon">🔧</span>
                <span>Utilidades</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="<%= request.getContextPath() %>/ConfiguracionControlador?accion=listar">
                <span class="menu-icon">&#9881;</span>
                <span>Configuración</span>
            </a>
        </li>
    </ul>
</div>