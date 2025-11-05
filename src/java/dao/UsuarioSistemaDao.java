package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.UsuarioSistema;

public class UsuarioSistemaDao {
    
    // Variables de conexión (ajusta 'pass' si es necesario)
    private Connection con;
    private CallableStatement cstmt;
    private PreparedStatement pstmt;
    private ResultSet rs;
    private String url = "jdbc:mysql://localhost/vet_teran";
    private String user = "root";
    private String pass = ""; // Asegúrate que esta sea tu contraseña de MySQL

    /**
     * Obtiene una conexión a la base de datos.
     * (Driver original mantenido por solicitud del usuario)
     */
    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.jdbc.Driver"); // Driver original
            return DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver MySQL no encontrado", e);
        }
    }

    /**
     * Cierra los recursos de JDBC de forma segura.
     * (Sobrecargado para manejar CallableStatement y PreparedStatement)
     */
    private void closeResources(Connection con, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (con != null) con.close();
        } catch (SQLException ex) {
            System.err.println("Error cerrando recursos: " + ex.getMessage());
            ex.printStackTrace();
        }
    }


    /**
     * Registra un nuevo usuario usando el Stored Procedure.
     * CORRECCIÓN: Usa getConnection() y closeResources() para consistencia.
     */
    public int registrarUsuarioSistema(String nombre, String rol, String email, String passwordHash) {
        int idUsuarioGenerado = -1;
        // Reinicializar variables de clase
        con = null;
        cstmt = null;
        rs = null;
        
        try {
            con = getConnection();
            cstmt = con.prepareCall("{CALL sp_RegistrarUsuarioSistema(?, ?, ?, ?)}");
            
            cstmt.setString(1, nombre);
            cstmt.setString(2, rol);
            cstmt.setString(3, email);
            cstmt.setString(4, passwordHash);
            
            boolean tieneResultados = cstmt.execute();
            
            if (tieneResultados) {
                rs = cstmt.getResultSet();
                if (rs.next()) {
                    idUsuarioGenerado = rs.getInt("id_usuario");
                }
            }

        } catch (SQLException e) {
            System.err.println("Error en la operación SQL al registrar usuario");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error general al registrar usuario");
            e.printStackTrace();
        } finally {
            // Usa el método closeResources estándar
            closeResources(con, cstmt, rs);
        }
        return idUsuarioGenerado;
    }

    // Método sobrecargado para registrar usando objeto UsuarioSistema
    public int registrarUsuarioSistema(UsuarioSistema usuario) {
        return registrarUsuarioSistema(
            usuario.getNombre(), 
            usuario.getRol(), 
            usuario.getEmail(), 
            usuario.getPasswordHash()
        );
    }

    /**
     * Valida credenciales usando el Stored Procedure.
     * CORRECCIÓN: Lee el campo 'estado' y usa los métodos de conexión estándar.
     */
    public UsuarioSistema validarUsuario(String email, String passwordHash) {
        UsuarioSistema usuario = null;
        // Reinicializar variables de clase
        con = null;
        cstmt = null;
        rs = null;
        
        try {
            con = getConnection();
            cstmt = con.prepareCall("{CALL sp_ValidarUsuario(?, ?)}");
            
            cstmt.setString(1, email);
            cstmt.setString(2, passwordHash);
            
            rs = cstmt.executeQuery();

            if (rs.next()) {
                usuario = new UsuarioSistema();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setNombre(rs.getString("nombre"));
                usuario.setRol(rs.getString("rol"));
                usuario.setEmail(rs.getString("email"));
                usuario.setCreatedAt(rs.getTimestamp("created_at"));
                // CORRECCIÓN: Leer el campo 'estado' (asumiendo que el SP fue actualizado)
                usuario.setEstado(rs.getString("estado")); 
            }

        } catch (SQLException e) {
            System.err.println("Error en la operación SQL al validar usuario");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error general al validar usuario");
            e.printStackTrace();
        } finally {
            closeResources(con, cstmt, rs);
        }
        return usuario;
    }

    /**
     * Lista todos los usuarios del sistema.
     * CORRECCIÓN: Añade el campo 'estado' a la consulta.
     */
    public List<UsuarioSistema> listarTodosUsuarios() {
        // Reinicializar variables de clase
        con = null;
        pstmt = null;
        rs = null;
        List<UsuarioSistema> usuarios = new ArrayList<>();
        
        // CORRECCIÓN: Se añade 'estado' al SELECT 
        String sql = "SELECT id_usuario, nombre, rol, email, created_at, updated_at, estado " +
                     "FROM usuario_sistema " +
                     "ORDER BY nombre";
        
        try {
            con = getConnection();
            pstmt = con.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                UsuarioSistema usuario = new UsuarioSistema();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setNombre(rs.getString("nombre"));
                usuario.setRol(rs.getString("rol"));
                usuario.setEmail(rs.getString("email"));
                usuario.setCreatedAt(rs.getTimestamp("created_at"));
                usuario.setUpdatedAt(rs.getTimestamp("updated_at"));
                usuario.setEstado(rs.getString("estado")); // CORRECCIÓN: Se asigna 'estado'
                usuarios.add(usuario);
            }

        } catch (SQLException e) {
            System.err.println("Error al listar usuarios: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(con, pstmt, rs);
        }
        return usuarios;
    }

    // MÉTODO: Cambiar contraseña de usuario
    public boolean cambiarPassword(int idUsuario, String nuevoPasswordHash) {
        // Reinicializar variables de clase
        con = null;
        pstmt = null;
        
        String sql = "UPDATE usuario_sistema SET password_hash = ?, updated_at = CURRENT_TIMESTAMP " +
                     "WHERE id_usuario = ?";
        
        try {
            con = getConnection();
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, nuevoPasswordHash);
            pstmt.setInt(2, idUsuario);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("Error al cambiar contraseña: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(con, pstmt, null);
        }
    }

    // MÉTODO: Verificar contraseña actual
    public boolean verificarPasswordActual(int idUsuario, String passwordActualHash) {
        // Reinicializar variables de clase
        con = null;
        pstmt = null;
        rs = null;
        
        String sql = "SELECT id_usuario FROM usuario_sistema " +
                     "WHERE id_usuario = ? AND password_hash = ?";
        
        try {
            con = getConnection();
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, idUsuario);
            pstmt.setString(2, passwordActualHash);
            
            rs = pstmt.executeQuery();
            return rs.next(); // True si encuentra coincidencia

        } catch (SQLException e) {
            System.err.println("Error al verificar contraseña actual: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(con, pstmt, rs);
        }
    }

    // MÉTODO: Actualizar perfil de usuario
    public boolean actualizarPerfil(int idUsuario, String nombre, String email) {
        // Reinicializar variables de clase
        con = null;
        pstmt = null;
        
        String sql = "UPDATE usuario_sistema SET nombre = ?, email = ?, updated_at = CURRENT_TIMESTAMP " +
                     "WHERE id_usuario = ?";
        
        try {
            con = getConnection();
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, nombre);
            pstmt.setString(2, email);
            pstmt.setInt(3, idUsuario);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("Error al actualizar perfil: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(con, pstmt, null);
        }
    }

    /**
     * MÉTODO RESTAURADO: Cambiar estado de usuario (ACTIVO/INACTIVO).
     * El campo 'estado' SÍ existe en la BD.
     */
    public boolean cambiarEstadoUsuario(int idUsuario, String nuevoEstado) {
        // Reinicializar variables de clase
        con = null;
        pstmt = null;
        
        // Validación simple para asegurar que el estado es correcto
        if (!"ACTIVO".equals(nuevoEstado) && !"INACTIVO".equals(nuevoEstado)) {
            System.err.println("Estado no válido. Debe ser 'ACTIVO' or 'INACTIVO'.");
            return false;
        }

        String sql = "UPDATE usuario_sistema SET estado = ?, updated_at = CURRENT_TIMESTAMP " +
                     "WHERE id_usuario = ?";
        
        try {
            con = getConnection();
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, nuevoEstado);
            pstmt.setInt(2, idUsuario);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("Error al cambiar estado de usuario: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(con, pstmt, null);
        }
    }

    /**
     * MÉTODO CORREGIDO: Buscar usuarios por criterios, incluyendo 'estado'.
     * (Se pasa un parámetro 'estado' adicional que faltaba).
     */
    public List<UsuarioSistema> buscarUsuarios(String termino, String rol, String estado) {
        // Reinicializar variables de clase
        con = null;
        pstmt = null;
        rs = null;
        List<UsuarioSistema> usuarios = new ArrayList<>();
        List<Object> parametros = new ArrayList<>();
        
        // CORRECCIÓN: Se añade 'estado' al SELECT 
        StringBuilder sql = new StringBuilder(
            "SELECT id_usuario, nombre, rol, email, created_at, updated_at, estado " +
            "FROM usuario_sistema WHERE 1=1"
        );
        
        if (termino != null && !termino.trim().isEmpty()) {
            sql.append(" AND (nombre LIKE ? OR email LIKE ?)");
            parametros.add("%" + termino + "%");
            parametros.add("%" + termino + "%");
        }
        
        if (rol != null && !rol.trim().isEmpty()) {
            sql.append(" AND rol = ?");
            parametros.add(rol);
        }

        // CORRECCIÓN: Se añade filtro por 'estado'
        if (estado != null && !estado.trim().isEmpty()) {
            sql.append(" AND estado = ?");
            parametros.add(estado);
        }
        
        sql.append(" ORDER BY nombre");
        
        try {
            con = getConnection();
            pstmt = con.prepareStatement(sql.toString());
            
            for (int i = 0; i < parametros.size(); i++) {
                pstmt.setObject(i + 1, parametros.get(i));
            }
            
            rs = pstmt.executeQuery();

            while (rs.next()) {
                UsuarioSistema usuario = new UsuarioSistema();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setNombre(rs.getString("nombre"));
                usuario.setRol(rs.getString("rol"));
                usuario.setEmail(rs.getString("email"));
                usuario.setCreatedAt(rs.getTimestamp("created_at"));
                usuario.setUpdatedAt(rs.getTimestamp("updated_at"));
                usuario.setEstado(rs.getString("estado")); // CORRECCIÓN: Se asigna 'estado'
                usuarios.add(usuario);
            }

        } catch (SQLException e) {
            System.err.println("Error al buscar usuarios: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(con, pstmt, rs);
        }
        return usuarios;
    }

    /**
     * MÉTODO CORREGIDO: Obtener perfil completo del usuario, incluyendo 'estado'.
     */
    public UsuarioSistema obtenerPerfilCompleto(int idUsuario) {
        // Reinicializar variables de clase
        con = null;
        pstmt = null;
        rs = null;
        UsuarioSistema usuario = null;
        
        // CORRECCIÓN: Se añade 'estado' al SELECT 
        String sql = "SELECT id_usuario, nombre, rol, email, created_at, updated_at, estado " +
                     "FROM usuario_sistema WHERE id_usuario = ?";
        
        try {
            con = getConnection();
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, idUsuario);
            
            rs = pstmt.executeQuery();

            if (rs.next()) {
                usuario = new UsuarioSistema();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setNombre(rs.getString("nombre"));
                usuario.setRol(rs.getString("rol"));
                usuario.setEmail(rs.getString("email"));
                usuario.setCreatedAt(rs.getTimestamp("created_at"));
                usuario.setUpdatedAt(rs.getTimestamp("updated_at"));
                usuario.setEstado(rs.getString("estado")); // CORRECCIÓN: Se asigna 'estado'
            }

        } catch (SQLException e) {
            System.err.println("Error al obtener perfil: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(con, pstmt, rs);
        }
        return usuario;
    }

    // MÉTODO: Eliminar usuario del sistema
    public boolean eliminarUsuario(int idUsuario) {
        // Reinicializar variables de clase
        con = null;
        pstmt = null;
        
        String sql = "DELETE FROM usuario_sistema WHERE id_usuario = ?";
        
        try {
            con = getConnection();
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, idUsuario);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("Error al eliminar usuario: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(con, pstmt, null);
        }
    }

    /**
     * Registra el último acceso (o cualquier actualización) tocando 'updated_at'.
     * Usado para login, logout, etc.
     */
    public boolean registrarUltimoAcceso(int idUsuario) {
        // Reinicializar variables de clase
        con = null;
        pstmt = null;
        
        String sql = "UPDATE usuario_sistema SET updated_at = CURRENT_TIMESTAMP " +
                     "WHERE id_usuario = ?";
        
        try {
            con = getConnection();
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, idUsuario);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("Error al registrar último acceso: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(con, pstmt, null);
        }
    }

    /**
     * Registra un intento fallido (actualiza 'updated_at' del email).
     * Esto ayuda a rastrear actividad sospechosa.
     */
    public boolean registrarIntentoFallidoLogin(String email) {
        // Reinicializar variables de clase
        con = null;
        pstmt = null;
        
        String sql = "UPDATE usuario_sistema SET updated_at = CURRENT_TIMESTAMP " +
                     "WHERE email = ?";
        
        try {
            con = getConnection();
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, email);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("Error al registrar intento fallido: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(con, pstmt, null);
        }
    }

    // MÉTODO: Registrar cierre de sesión (es alias de registrarUltimoAcceso)
    public boolean registrarCierreSesion(int idUsuario) {
        return registrarUltimoAcceso(idUsuario);
    }

    // MÉTODO: Verificar si email ya existe
    public boolean existeEmail(String email) {
        // Reinicializar variables de clase
        con = null;
        pstmt = null;
        rs = null;
        
        String sql = "SELECT id_usuario FROM usuario_sistema WHERE email = ?";
        
        try {
            con = getConnection();
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, email);
            
            rs = pstmt.executeQuery();
            return rs.next(); // True si encuentra un registro

        } catch (SQLException e) {
            System.err.println("Error al verificar email: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(con, pstmt, rs);
        }
    }
}