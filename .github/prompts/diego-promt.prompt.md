---
mode: agent
---


📋 Informe Detallado de Análisis y Correcciones del Proyecto Veterinaria
Fecha: 22 de Octubre, 2025
Analizado por: Gemini
Versión Java: 8
IDE: Netbeans 8.2
Resumen Ejecutivo
Tras analizar los archivos proporcionados (InformeErrores.md, PROGRESO_CORRECCIONES_DIEGO.md, código fuente .java y .jsp, y Base de datos Veterinaria.sql), se confirma que se ha avanzado significativamente en la corrección de los errores críticos iniciales (MVC y PRG), pero aún persisten inconsistencias y tareas pendientes que impiden el correcto funcionamiento.
Puntos Clave:
Correcciones MVC (Prioridad 1):
✅ Los JSPs ListaClientes.jsp y ListaMascotas.jsp han sido limpiados de llamadas directas a DAOs.
✅ ClienteControlador y MascotaControlador ahora cargan datos y los envían a los JSPs.
⚠️ Problema Persistente: Menu.jsp NO ha sido corregido y sigue enlazando directamente a JSPs, invalidando gran parte de la corrección MVC. includes/menu.jsp sí parece corregido, pero Menu.jsp lo ignora en muchas partes.
Correcciones PRG (Prioridad 2):
✅ ClienteControlador y MascotaControlador implementan correctamente response.sendRedirect() tras la inserción.
⚠️ Problema Persistente: Los controladores marcados como pendientes en PROGRESO_CORRECCIONES_DIEGO.md (PromocionControlador, UsuarioSistemaControlador, PaqueteServicioControlador, UtilidadesControlador, NotificacionControlador, FacturaControlador) NO implementan el patrón PRG todavía, lo que mantiene el riesgo de duplicación de datos.
Correcciones Context Path (Prioridad 3):
✅ includes/menu.jsp usa <%= request.getContextPath() %>.
⚠️ Problema Persistente: Menu.jsp NO usa request.getContextPath() en la mayoría de sus enlaces. Otros JSPs como ListaClientes.jsp sí lo usan en formularios y algunos enlaces. La corrección es incompleta.
Métodos DAO Faltantes:
🚨 Crítico: Se identificaron numerosos métodos llamados por los Servlets que no existen en sus respectivos DAOs (ClienteDao, PromocionDao, UsuarioSistemaDao, PaqueteServicioDao, FacturaDao, NotificacionDao). Esto causa errores en tiempo de ejecución. Se proporcionan implementaciones SQL/JDBC más abajo.
Otros Problemas Identificados:
Credenciales de BD hardcodeadas en cada DAO.
Manejo de errores inconsistente.
Potencial riesgo de SQL Injection (aunque mitigado por CallableStatement).
Conector MySQL antiguo.
Uso de Class.forName("com.mysql.jdbc.Driver") obsoleto.
1. Verificación Detallada de Correcciones
1.1. Fallo MVC (Prioridad 1)
Progreso:
ListaClientes.jsp ya no importa ni instancia ClienteDao. Recibe la lista clientes del request.
ListaMascotas.jsp ya no importa ni instancia MascotaDao. Recibe la lista mascotas del request.
ClienteControlador implementa listarTodosClientes que obtiene datos del DAO y los envía vía request.setAttribute("clientes", ...) antes del forward.
MascotaControlador implementa listarTodasMascotas que obtiene datos del DAO y los envía vía request.setAttribute("mascotas", ...) antes del forward.
Problemas Pendientes:
Menu.jsp (Archivo Principal): Este archivo ignora las correcciones hechas en includes/menu.jsp. Contiene enlaces directos como <a href="Clientes.jsp">, <a href="ListaMascotas.jsp">, <a href="ListaPromociones.jsp">, etc. Esto rompe el flujo MVC fundamentalmente. Debes reemplazar el contenido del menú en Menu.jsp con una inclusión del archivo corregido includes/menu.jsp.
includes/menu.jsp: Aunque usa getContextPath y apunta a controladores, algunos enlaces aún no tienen el parámetro accion necesario para que el controlador sepa qué hacer (ej. href="ServicioControlador" debe ser href="<%= request.getContextPath() %>/ServicioControlador?accion=listar").
1.2. Fallo PRG (Prioridad 2)
Progreso:
ClienteControlador#insertarCliente: Usa response.sendRedirect(request.getContextPath() + "/ClienteControlador?accion=listarTodos&creado=exito"); correctamente tras un INSERT exitoso.
MascotaControlador#insertarMascota: Usa response.sendRedirect(request.getContextPath() + "/MascotaControlador?accion=listarTodas&creado=exito"); correctamente tras un INSERT exitoso.
Problemas Pendientes:
Como indica PROGRESO_CORRECCIONES_DIEGO.md y se verifica en el código fuente, los siguientes controladores aún usan forward después de operaciones POST, manteniendo el riesgo de duplicación:
PromocionControlador (accion="crear").
UsuarioSistemaControlador (accion="registrar").
PaqueteServicioControlador (accion="crear").
FacturaControlador (accion="crear").
NotificacionControlador (accion="registrar").
UtilidadesControlador (accion="recalcular", aunque no modifica datos, podría ser largo y es mejor redirigir).
1.3. Rutas con Context Path (Prioridad 3)
Progreso:
includes/menu.jsp utiliza request.getContextPath() en todos sus enlaces <a>.
ListaClientes.jsp lo usa en el action del formulario de búsqueda y en algunos enlaces de navegación.
Problemas Pendientes:
Menu.jsp: La mayoría de los enlaces <a> NO usan request.getContextPath(). Por ejemplo: <a href="Clientes.jsp">, <a href="CitaControlador?accion=todasCitas">.
Otros JSPs (Revisión General): Es necesario revisar todos los JSPs para asegurar que todos los href="..." y action="..." que apuntan a recursos de la aplicación (Servlets o JSPs) incluyan el prefijo <%= request.getContextPath() %>/.
2. ❗ Métodos DAO Faltantes (Implementaciones Propuestas)
Se identificaron varios métodos que los Servlets intentan llamar pero que no están definidos en las clases DAO correspondientes. A continuación se proponen las implementaciones usando JDBC estándar y SQL directo, asumiendo que no existen Stored Procedures específicos para ellos.
Nota: Deberás agregar estas implementaciones a los archivos .java de los DAOs respectivos. Recuerda incluir el manejo de excepciones (try-catch-finally) y el cierre de recursos (Connection, PreparedStatement, ResultSet).
2.1. ClienteDao.java
Java
// --- Métodos Faltantes en ClienteDao.java ---

// Para ClienteControlador?accion=editar (antes de mostrar el formulario de edición)
public Cliente obtenerClientePorId(int idCliente) {
    Cliente cliente = null;
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String sql = "SELECT * FROM cliente WHERE id_cliente = ?";

    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, pass);
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, idCliente);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            cliente = new Cliente();
            cliente.setIdCliente(rs.getInt("id_cliente"));
            cliente.setNombre(rs.getString("nombre"));
            cliente.setApellido(rs.getString("apellido"));
            cliente.setDniRuc(rs.getString("dni_ruc"));
            cliente.setEmail(rs.getString("email"));
            cliente.setTelefono(rs.getString("telefono"));
            cliente.setDireccion(rs.getString("direccion"));
            // Podrías necesitar manejar 'preferencias' (JSON) si es relevante aquí
        }
    } catch (Exception e) {
        System.err.println("Error al obtener cliente por ID: " + e.getMessage());
        e.printStackTrace();
    } finally {
        // Cerrar recursos (rs, pstmt, conn)
         try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
         try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
         try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
    return cliente;
}

// Para ClienteControlador?accion=actualizar (después de enviar el formulario de edición)
public boolean actualizarCliente(Cliente cliente) {
    boolean exito = false;
    Connection conn = null;
    PreparedStatement pstmt = null;
    String sql = "UPDATE cliente SET nombre = ?, apellido = ?, dni_ruc = ?, email = ?, telefono = ?, direccion = ?, preferencias = ? WHERE id_cliente = ?";

    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, pass);
        pstmt = conn.prepareStatement(sql);

        pstmt.setString(1, cliente.getNombre());
        pstmt.setString(2, cliente.getApellido());
        pstmt.setString(3, cliente.getDniRuc());
        pstmt.setString(4, cliente.getEmail());
        pstmt.setString(5, cliente.getTelefono());
        pstmt.setString(6, cliente.getDireccion());

        // Manejo simple de preferencias (ajustar si es necesario)
        String prefs = cliente.getPreferencias();
        pstmt.setString(7, (prefs != null && !prefs.isEmpty()) ? "{\"preferencia\":\"" + prefs + "\"}" : "{}");

        pstmt.setInt(8, cliente.getIdCliente());

        int filasAfectadas = pstmt.executeUpdate();
        exito = (filasAfectadas > 0);

    } catch (Exception e) {
        System.err.println("Error al actualizar cliente: " + e.getMessage());
        e.printStackTrace();
    } finally {
        // Cerrar recursos (pstmt, conn)
         try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
         try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
    return exito;
}

// Para ClienteControlador?accion=eliminar
public boolean eliminarCliente(int idCliente) {
    boolean exito = false;
    Connection conn = null;
    PreparedStatement pstmtMascotas = null;
    PreparedStatement pstmtCliente = null;
    String sqlDeleteMascotas = "DELETE FROM mascota WHERE id_cliente = ?";
    String sqlDeleteCliente = "DELETE FROM cliente WHERE id_cliente = ?";

    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, pass);
        conn.setAutoCommit(false); // Iniciar transacción

        // 1. Eliminar mascotas asociadas (o manejar la restricción FK de otra forma)
        pstmtMascotas = conn.prepareStatement(sqlDeleteMascotas);
        pstmtMascotas.setInt(1, idCliente);
        pstmtMascotas.executeUpdate(); // No importa cuántas se borren

        // 2. Eliminar cliente
        pstmtCliente = conn.prepareStatement(sqlDeleteCliente);
        pstmtCliente.setInt(1, idCliente);
        int filasAfectadas = pstmtCliente.executeUpdate();

        conn.commit(); // Confirmar transacción
        exito = (filasAfectadas > 0);

    } catch (Exception e) {
        System.err.println("Error al eliminar cliente: " + e.getMessage());
        e.printStackTrace();
        try { if (conn != null) conn.rollback(); } catch (SQLException se) { se.printStackTrace(); } // Revertir en caso de error
    } finally {
        // Cerrar recursos (pstmtMascotas, pstmtCliente, conn)
         try { if (pstmtMascotas != null) pstmtMascotas.close(); } catch (SQLException e) { e.printStackTrace(); }
         try { if (pstmtCliente != null) pstmtCliente.close(); } catch (SQLException e) { e.printStackTrace(); }
         try { if (conn != null) { conn.setAutoCommit(true); conn.close(); } } catch (SQLException e) { e.printStackTrace(); }
    }
    return exito;
}

2.2. PromocionDao.java
Java
// --- Métodos Faltantes en PromocionDao.java ---

// Nota: Ya tienes insertarPromocion y obtenerPromocionesActivas.
//       El método obtenerPromociones() existente parece listar todas, lo renombro
//       para claridad y añado los demás.

public List<Promocion> listarTodasPromociones() {
    return obtenerPromociones(); // Reutiliza tu método existente
}

public List<Promocion> buscarPromociones(String termino, String tipo, String estado, java.sql.Date fechaInicio, java.sql.Date fechaFin) {
    List<Promocion> promociones = new ArrayList<>();
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    StringBuilder sql = new StringBuilder("SELECT * FROM promocion WHERE 1=1");
    List<Object> params = new ArrayList<>();

    if (termino != null && !termino.isEmpty()) {
        sql.append(" AND (nombre LIKE ? OR descripcion LIKE ?)");
        params.add("%" + termino + "%");
        params.add("%" + termino + "%");
    }
    if (tipo != null && !tipo.isEmpty()) {
        sql.append(" AND tipo = ?");
        params.add(tipo);
    }
    if (estado != null && !estado.isEmpty()) {
        sql.append(" AND estado = ?");
        params.add(estado);
    }
    if (fechaInicio != null && fechaFin != null) {
        sql.append(" AND fecha_inicio >= ? AND fecha_fin <= ?");
        params.add(fechaInicio);
        params.add(fechaFin);
    }
    sql.append(" ORDER BY fecha_inicio DESC");

    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, pass);
        pstmt = conn.prepareStatement(sql.toString());

        for (int i = 0; i < params.size(); i++) {
            pstmt.setObject(i + 1, params.get(i));
        }

        rs = pstmt.executeQuery();
        while (rs.next()) {
             Promocion p = new Promocion();
             p.setIdPromocion(rs.getInt("id_promocion"));
             p.setNombre(rs.getString("nombre"));
             p.setDescripcion(rs.getString("descripcion"));
             p.setTipo(rs.getString("tipo"));
             p.setValor(rs.getDouble("valor"));
             p.setFechaInicio(rs.getDate("fecha_inicio"));
             p.setFechaFin(rs.getDate("fecha_fin"));
             p.setEstado(rs.getString("estado"));
             promociones.add(p);
        }
    } catch (Exception e) {
        System.err.println("Error al buscar promociones: " + e.getMessage());
        e.printStackTrace();
    } finally {
        // Cerrar recursos
         try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
         try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
         try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
    return promociones;
}

public Promocion obtenerPromocionPorId(int idPromocion) {
    Promocion promocion = null;
    // ... (Implementación similar a obtenerClientePorId con SELECT * FROM promocion WHERE id_promocion = ?)
     Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null; // ... try-catch-finally ...
     // Dentro del try:
     // sql = "SELECT * FROM promocion WHERE id_promocion = ?"
     // pstmt.setInt(1, idPromocion);
     // rs = pstmt.executeQuery();
     // if(rs.next()) { /* llenar objeto promocion */ }
    return promocion;
}

public boolean actualizarPromocion(int idPromocion, String nombre, String descripcion, double valor) {
     boolean exito = false;
     // ... (Implementación similar a actualizarCliente con UPDATE promocion SET nombre = ?, descripcion = ?, valor = ? WHERE id_promocion = ?)
     Connection conn = null; PreparedStatement pstmt = null; // ... try-catch-finally ...
     // Dentro del try:
     // pstmt.setString(1, nombre);
     // pstmt.setString(2, descripcion);
     // pstmt.setDouble(3, valor);
     // pstmt.setInt(4, idPromocion);
     // filasAfectadas = pstmt.executeUpdate();
     // exito = filasAfectadas > 0;
     return exito;
}

public boolean cambiarEstadoPromocion(int idPromocion, String nuevoEstado) {
     boolean exito = false;
     // ... (Implementación similar a actualizarCliente con UPDATE promocion SET estado = ? WHERE id_promocion = ?)
     // Validar que nuevoEstado sea 'activa' o 'inactiva' antes de ejecutar.
     Connection conn = null; PreparedStatement pstmt = null; // ... try-catch-finally ...
     // Dentro del try:
     // pstmt.setString(1, nuevoEstado);
     // pstmt.setInt(2, idPromocion);
     // ...
    return exito;
}

public boolean eliminarPromocion(int idPromocion) {
     // En lugar de DELETE, cambiamos el estado a 'inactiva' para mantener historial
     return cambiarEstadoPromocion(idPromocion, "inactiva");
}

// Métodos adicionales llamados por PromocionControlador que requieren lógica más compleja
// o posiblemente Stored Procedures que no tenemos definidos aquí.
// Por ahora, devolvemos valores placeholder.

public int obtenerVecesUsadaPromocion(int idPromocion) {
    // Placeholder: Necesitaría consultar tablas de facturas/detalles
    System.err.println("WARN: obtenerVecesUsadaPromocion no implementado, devolviendo 0.");
    return 0;
}

public double obtenerMontoAhorradoPromocion(int idPromocion) {
    // Placeholder: Necesitaría lógica de cálculo basada en usos
    System.err.println("WARN: obtenerMontoAhorradoPromocion no implementado, devolviendo 0.0.");
    return 0.0;
}

public boolean validarPromocionParaCliente(int idPromocion, int idCliente, double montoCompra) {
    // Placeholder: Lógica compleja (¿restricciones por cliente? ¿monto mínimo?)
    System.err.println("WARN: validarPromocionParaCliente no implementado, devolviendo true por defecto.");
    return true; // Asumir válida por ahora
}

public double calcularDescuentoPromocion(Promocion promocion, double montoCompra) {
     // Placeholder: Implementar cálculo real según tipo y valor
     System.err.println("WARN: calcularDescuentoPromocion no implementado, devolviendo 0.0.");
     if (promocion != null) {
         if ("porcentaje".equalsIgnoreCase(promocion.getTipo()) && montoCompra > 0) {
             // return montoCompra * (promocion.getValor() / 100.0); // Cálculo real
         } else if ("monto".equalsIgnoreCase(promocion.getTipo())) {
             // return Math.min(promocion.getValor(), montoCompra); // Cálculo real
         }
     }
    return 0.0;
}

public String obtenerMotivoRechazoPromocion(int idPromocion, int idCliente, double montoCompra) {
     // Placeholder: Lógica para determinar por qué falló validarPromocionParaCliente
     System.err.println("WARN: obtenerMotivoRechazoPromocion no implementado.");
    return "Motivo desconocido (función no implementada)";
}

2.3. UsuarioSistemaDao.java
Java
// --- Métodos Faltantes en UsuarioSistemaDao.java ---
// Nota: Ya tienes registrarUsuarioSistema y validarUsuario.

public void registrarUltimoAcceso(int idUsuario) {
    // Implementación con UPDATE usuario_sistema SET updated_at = NOW() WHERE id_usuario = ?
    Connection conn = null; PreparedStatement pstmt = null; // ... try-catch-finally ...
}

public void registrarIntentoFallidoLogin(String email) {
    // Podría registrarse en audit_log o en una tabla específica de intentos.
    System.err.println("WARN: registrarIntentoFallidoLogin no implementado.");
}

public void registrarCierreSesion(int idUsuario) {
    // Podría registrarse en audit_log.
    System.err.println("WARN: registrarCierreSesion no implementado.");
}

public List<UsuarioSistema> listarTodosUsuarios() {
    List<UsuarioSistema> usuarios = new ArrayList<>();
    // Implementación con SELECT id_usuario, nombre, rol, email, created_at, updated_at FROM usuario_sistema ORDER BY nombre
    Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null; // ... try-catch-finally ...
    // Dentro del try, iterar rs y llenar la lista de usuarios.
    return usuarios;
}

public boolean verificarPasswordActual(int idUsuario, String passwordActualHash) {
    boolean coincide = false;
    // Implementación con SELECT password_hash FROM usuario_sistema WHERE id_usuario = ?
    // y comparar el hash obtenido con passwordActualHash.
    Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null; // ... try-catch-finally ...
    return coincide;
}

public boolean cambiarPassword(int idUsuario, String passwordNuevoHash) {
    boolean exito = false;
    // Implementación con UPDATE usuario_sistema SET password_hash = ? WHERE id_usuario = ?
    Connection conn = null; PreparedStatement pstmt = null; // ... try-catch-finally ...
    return exito;
}

public boolean actualizarPerfil(int idUsuario, String nombre, String email) {
    boolean exito = false;
    // Implementación con UPDATE usuario_sistema SET nombre = ?, email = ? WHERE id_usuario = ?
    Connection conn = null; PreparedStatement pstmt = null; // ... try-catch-finally ...
    return exito;
}

public boolean cambiarEstadoUsuario(int idUsuario, String nuevoEstado) {
    boolean exito = false;
    // Implementación con UPDATE usuario_sistema SET estado = ? WHERE id_usuario = ?
    // Asegurarse que la tabla 'usuario_sistema' tenga una columna 'estado'. NO ESTÁ EN EL SQL PROPORCIONADO.
    // ALTER TABLE usuario_sistema ADD COLUMN estado ENUM('ACTIVO','INACTIVO') DEFAULT 'ACTIVO';
    System.err.println("WARN: cambiarEstadoUsuario requiere columna 'estado' en tabla 'usuario_sistema'.");
     Connection conn = null; PreparedStatement pstmt = null; // ... try-catch-finally ...
    return exito;
}

public List<UsuarioSistema> buscarUsuarios(String termino, String rol, String estado) {
    List<UsuarioSistema> usuarios = new ArrayList<>();
    // Implementación con SELECT ... FROM usuario_sistema WHERE ... LIKE ... AND rol = ? AND estado = ?
     Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null; // ... try-catch-finally ...
     // Similar a buscarPromociones, construir SQL dinámicamente.
    return usuarios;
}

public UsuarioSistema obtenerPerfilCompleto(int idUsuario) {
    UsuarioSistema usuario = null;
    // Implementación similar a obtenerClientePorId con SELECT * FROM usuario_sistema WHERE id_usuario = ?
     Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null; // ... try-catch-finally ...
    return usuario;
}

public boolean eliminarUsuario(int idUsuario) {
    boolean exito = false;
    // Implementación con DELETE FROM usuario_sistema WHERE id_usuario = ?
    // Cuidado con las Foreign Keys si otras tablas referencian id_usuario (ej. audit_log)
     Connection conn = null; PreparedStatement pstmt = null; // ... try-catch-finally ...
    return exito;
}
2.4. PaqueteServicioDao.java
Java
// --- Métodos Faltantes en PaqueteServicioDao.java ---
// Nota: Ya tienes crearPaqueteServicio y agregarServicioPaquete.

public List<PaqueteServicio> listarPaquetesServicio() {
    List<PaqueteServicio> paquetes = new ArrayList<>();
    // Implementación con SELECT * FROM paquete_servicio ORDER BY nombre
     Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null; // ... try-catch-finally ...
     // Iterar rs y llenar lista.
    return paquetes;
}

public PaqueteServicio obtenerPaquetePorId(int idPaquete) {
    PaqueteServicio paquete = null;
    // Implementación con SELECT * FROM paquete_servicio WHERE id_paquete = ?
     Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null; // ... try-catch-finally ...
     // if(rs.next()) { /* llenar objeto paquete */ }
    return paquete;
}

public boolean servicioYaEnPaquete(int idPaquete, int idServicio) {
    boolean existe = false;
    // Implementación con SELECT 1 FROM paquete_servicio_item WHERE id_paquete = ? AND id_servicio = ? LIMIT 1
     Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null; // ... try-catch-finally ...
     // if(rs.next()) { existe = true; }
    return existe;
}

public List<PaqueteServicioItem> obtenerServiciosPaquete(int idPaquete) {
    List<PaqueteServicioItem> items = new ArrayList<>();
    // Implementación con SELECT psi.*, s.nombre, s.precio_base
    // FROM paquete_servicio_item psi
    // JOIN servicio s ON psi.id_servicio = s.id_servicio
    // WHERE psi.id_paquete = ?
     Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null; // ... try-catch-finally ...
     // Iterar rs, crear PaqueteServicioItem y añadir nombre/precio del servicio.
    return items;
}

public boolean actualizarPaqueteServicio(int idPaquete, String nombre, String descripcion, double precioTotal, String estado) {
    boolean exito = false;
    // Implementación con UPDATE paquete_servicio SET nombre = ?, descripcion = ?, precio_total = ? WHERE id_paquete = ?
    // Nota: La tabla 'paquete_servicio' no tiene columna 'estado' en el SQL. Añadirla si es necesario.
    // ALTER TABLE paquete_servicio ADD COLUMN estado ENUM('ACTIVO','INACTIVO','DESCONTINUADO') DEFAULT 'ACTIVO';
    System.err.println("WARN: actualizarPaqueteServicio requiere columna 'estado' en tabla 'paquete_servicio'.");
     Connection conn = null; PreparedStatement pstmt = null; // ... try-catch-finally ...
    return exito;
}

public boolean eliminarPaqueteServicio(int idPaquete) {
    boolean exito = false;
    Connection conn = null;
    PreparedStatement pstmtItems = null;
    PreparedStatement pstmtPaquete = null;
    // Implementación con Transacción:
    // 1. DELETE FROM paquete_servicio_item WHERE id_paquete = ?
    // 2. DELETE FROM paquete_servicio WHERE id_paquete = ?
     // ... try-catch-finally con conn.setAutoCommit(false), commit, rollback ...
    return exito;
}

public boolean eliminarServicioPaquete(int idPaquete, int idServicio) {
    boolean exito = false;
    // Implementación con DELETE FROM paquete_servicio_item WHERE id_paquete = ? AND id_servicio = ?
     Connection conn = null; PreparedStatement pstmt = null; // ... try-catch-finally ...
    return exito;
}

public List<PaqueteServicio> buscarPaquetesServicio(String termino, String estado, Double precioMin, Double precioMax) {
    List<PaqueteServicio> paquetes = new ArrayList<>();
    // Implementación con SELECT * FROM paquete_servicio WHERE ... LIKE ... AND estado = ? AND precio_total BETWEEN ? AND ?
     Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null; // ... try-catch-finally ...
     // Similar a buscarPromociones, construir SQL dinámicamente.
     // Nota: requiere columna 'estado'.
    return paquetes;
}
2.5. FacturaDao.java
Java
// --- Métodos Faltantes en FacturaDao.java ---
// Nota: Ya tienes crearFactura, obtenerFacturasPorCliente, anularFactura.

// DTO para listar facturas con nombre de cliente
// Crear una clase FacturaClienteDTO.java en el paquete 'modelo'
// public class FacturaClienteDTO extends Factura {
//     private String nombreCliente;
//     private String apellidoCliente;
//     // Getters y Setters
// }

public List<FacturaClienteDTO> listarTodasFacturas() {
    List<FacturaClienteDTO> facturas = new ArrayList<>();
    // Implementación con SELECT f.*, c.nombre as nombreCliente, c.apellido as apellidoCliente
    // FROM factura f JOIN cliente c ON f.id_cliente = c.id_cliente
    // ORDER BY f.fecha_emision DESC
     Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null; // ... try-catch-finally ...
     // Iterar rs y llenar lista de FacturaClienteDTO.
    return facturas;
}

public List<FacturaClienteDTO> buscarFacturas(String termino) {
     List<FacturaClienteDTO> facturas = new ArrayList<>();
     // Implementación con SELECT f.*, c.nombre, c.apellido FROM factura f JOIN cliente c ON f.id_cliente = c.id_cliente
     // WHERE f.serie LIKE ? OR f.numero LIKE ? OR c.nombre LIKE ? OR c.apellido LIKE ? OR c.dni_ruc LIKE ?
     Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null; // ... try-catch-finally ...
     // Usar "%" + termino + "%" para los LIKE.
    return facturas;
}

public List<FacturaClienteDTO> obtenerFacturasPorFecha(java.sql.Timestamp fechaInicio, java.sql.Timestamp fechaFin) {
     List<FacturaClienteDTO> facturas = new ArrayList<>();
     // Implementación con SELECT f.*, c.nombre, c.apellido FROM factura f JOIN cliente c ON f.id_cliente = c.id_cliente
     // WHERE f.fecha_emision BETWEEN ? AND ? ORDER BY f.fecha_emision
     Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null; // ... try-catch-finally ...
    return facturas;
}

public List<FacturaClienteDTO> obtenerFacturasPorEstado(String estado) {
     List<FacturaClienteDTO> facturas = new ArrayList<>();
     // Implementación con SELECT f.*, c.nombre, c.apellido FROM factura f JOIN cliente c ON f.id_cliente = c.id_cliente
     // WHERE f.estado = ? ORDER BY f.fecha_emision
     Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null; // ... try-catch-finally ...
    return facturas;
}

public Factura obtenerFacturaPorId(int idFactura) {
    Factura factura = null;
    // Implementación con SELECT * FROM factura WHERE id_factura = ?
     Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null; // ... try-catch-finally ...
     // if(rs.next()) { /* llenar objeto factura */ }
    return factura;
}

// Sobrecargar anularFactura para incluir motivo (si se necesita guardar)
public boolean anularFactura(int idFactura, String motivo) {
    // Podrías guardar el motivo en una tabla de auditoría o similar antes de llamar al SP
    System.out.println("INFO: Anulando factura " + idFactura + " por motivo: " + motivo);
    return anularFactura(idFactura); // Llama al método existente
}

2.6. NotificacionDao.java
Java
// --- Métodos Faltantes en NotificacionDao.java ---
// Nota: Ya tienes registrarNotificacion y obtenerNotificacionesCliente.

public boolean marcarNotificacionLeida(int idNotificacion) {
    boolean exito = false;
    // Implementación con UPDATE notificacion SET estado = 'LEIDA' WHERE id_notificacion = ? AND estado <> 'LEIDA'
     Connection conn = null; PreparedStatement pstmt = null; // ... try-catch-finally ...
    return exito;
}

public boolean marcarNotificacionEnviada(int idNotificacion) {
    boolean exito = false;
    // Implementación con UPDATE notificacion SET estado = 'ENVIADA', enviado_at = NOW() WHERE id_notificacion = ? AND estado = 'PENDIENTE'
     Connection conn = null; PreparedStatement pstmt = null; // ... try-catch-finally ...
    return exito;
}

// DTO NotificacionClienteDTO ya existe
public List<NotificacionClienteDTO> buscarNotificaciones(String tipo, String canal, String estado, String contenido) {
    List<NotificacionClienteDTO> notificaciones = new ArrayList<>();
    // Implementación con SELECT n.*, c.nombre, c.apellido FROM notificacion n JOIN cliente c ON n.destinatario_id = c.id_cliente WHERE ...
     Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null; // ... try-catch-finally ...
     // Construir SQL dinámicamente similar a buscarPromociones.
    return notificaciones;
}

public List<NotificacionClienteDTO> obtenerNotificacionesPendientes() {
    List<NotificacionClienteDTO> notificaciones = new ArrayList<>();
    // Implementación con SELECT n.*, c.nombre, c.apellido FROM notificacion n JOIN cliente c ON n.destinatario_id = c.id_cliente
    // WHERE n.estado = 'PENDIENTE' ORDER BY n.created_at ASC
     Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null; // ... try-catch-finally ...
    return notificaciones;
}

public List<NotificacionClienteDTO> obtenerNotificacionesRecientes(int limite) {
    List<NotificacionClienteDTO> notificaciones = new ArrayList<>();
    // Implementación con SELECT n.*, c.nombre, c.apellido FROM notificacion n JOIN cliente c ON n.destinatario_id = c.id_cliente
    // ORDER BY n.created_at DESC LIMIT ?
     Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null; // ... try-catch-finally ...
     // pstmt.setInt(1, limite);
    return notificaciones;
}
2.7. ServicioDao.java (Métodos necesarios para FacturaControlador)
Java
// --- Métodos Necesarios en ServicioDao.java ---

public List<Servicio> obtenerServicios() {
    List<Servicio> servicios = new ArrayList<>();
    // Implementación con SELECT * FROM servicio ORDER BY nombre
    Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null; // ... try-catch-finally ...
    return servicios;
}

public Servicio obtenerServicioPorId(int idServicio) {
    Servicio servicio = null;
    // Implementación con SELECT * FROM servicio WHERE id_servicio = ?
     Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null; // ... try-catch-finally ...
    return servicio;
}
3. Otros Problemas Identificados y Recomendaciones
Credenciales de Base de Datos: Las credenciales (url, user, pass) están hardcodeadas en cada clase DAO. Esto es inseguro y dificulta el mantenimiento.
Recomendación: Externalizar la configuración de la conexión (e.g., a un archivo de propiedades o usando JNDI si estás en un servidor de aplicaciones como Tomcat/GlassFish). Crear una clase de utilidad (DatabaseConnection o similar) para gestionar la obtención de conexiones.
Conector MySQL y Driver: Estás usando un conector antiguo (mysql-connector-java-5.0.8-bin.jar) y la forma Class.forName("com.mysql.jdbc.Driver") está obsoleta.
Recomendación: Actualizar el conector MySQL a una versión más reciente (ej. 8.x) compatible con Java 8. El registro del driver suele ser automático con versiones modernas, eliminando la necesidad de Class.forName.
Manejo de Excepciones: Es inconsistente. Algunos métodos imprimen printStackTrace(), otros solo mensajes. No se relanzan excepciones específicas para que las capas superiores (Servlets) puedan manejarlas adecuadamente.
Recomendación: Implementar un manejo de excepciones más robusto. Considera crear excepciones personalizadas (e.g., DaoException) y relanzarlas desde los DAOs. Los Servlets deberían tener un bloque try-catch general en processRequest para capturar estas excepciones y mostrar una página de error amigable.
SQL Injection: Aunque el uso de PreparedStatement y CallableStatement mitiga el riesgo principal, asegúrate de que cualquier construcción dinámica de SQL (como en los métodos buscar...) valide y limpie adecuadamente los parámetros que no van directamente como ?.
Transacciones: Operaciones como eliminarCliente (que borra mascotas y luego cliente) o eliminarPaqueteServicio (que borra items y luego paquete) deberían ejecutarse dentro de una transacción (conn.setAutoCommit(false); ... conn.commit(); ... conn.rollback();) para asegurar la atomicidad. La implementación propuesta para eliminarCliente ya incluye esto.
Cierre de Recursos: El código finally para cerrar ResultSet, Statement/PreparedStatement, y Connection es repetitivo.
Recomendación (Java 7+): Usar try-with-resources para simplificar el cierre automático de recursos. Dado que estás en Java 8, esto es aplicable. Ejemplo:
Java
String sql = "...";
try (Connection conn = DriverManager.getConnection(url, user, pass);
     PreparedStatement pstmt = conn.prepareStatement(sql)) {
    // ... usar pstmt ...
    try (ResultSet rs = pstmt.executeQuery()) {
        // ... usar rs ...
    }
} catch (SQLException e) {
    // Manejar excepción
} // Los recursos se cierran automáticamente
JSON en ClienteDao: El manejo del campo preferencias es muy básico ("{\"preferencia\": \"" + ... + "\"}"). Si las preferencias se vuelven más complejas, esto será difícil de mantener.
Recomendación: Considerar usar una librería JSON como Gson o Jackson para convertir objetos Java a/desde JSON de forma más robusta, aunque esto añade una dependencia externa. Para Java 8 sin librerías externas, podrías seguir con el enfoque simple o construir el JSON manualmente con más cuidado si la estructura es fija.
4. 🚀 Plan de Acción Recomendado (Actualizado)
Prioridad Urgente - Corregir Menu.jsp: Reemplaza el menú hardcodeado en Menu.jsp por una inclusión de includes/menu.jsp usando <jsp:include page="includes/menu.jsp" />. Verifica también los enlaces en includes/menu.jsp que no tengan ?accion=....
Prioridad Urgente - Implementar Métodos DAO Faltantes: Agrega las implementaciones de los métodos listados en la Sección 2 a sus respectivas clases DAO. Sin esto, la aplicación seguirá fallando.
Prioridad Alta - Completar Correcciones PRG: Aplica el patrón response.sendRedirect(...) en los métodos doPost (o equivalentes) de los controladores pendientes: PromocionControlador, UsuarioSistemaControlador, PaqueteServicioControlador, FacturaControlador, NotificacionControlador.
Prioridad Media - Completar Context Path: Realiza una búsqueda global en todos los archivos JSP por href=" y action=" y añade el prefijo <%= request.getContextPath() %>/ donde corresponda.
Prioridad Baja/Mejora - Refactorización:
Centralizar la conexión a la base de datos.
Actualizar el conector MySQL.
Mejorar el manejo de excepciones.
Implementar try-with-resources.
Revisar y asegurar transacciones donde sea necesario.

Realiza pruebas unitarias y si creas carpetas de pruebas añadelos a gitignore. Se deben pasar todas las pruebas.