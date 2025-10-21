package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.UsuarioSistema;

public class UsuarioSistemaDao {
    
    private Connection con;
    private CallableStatement cstmt;
    private PreparedStatement pstmt;
    private ResultSet rs;
    private String url = "jdbc:mysql://localhost/vet_teran";
    private String user = "root";
    private String pass = "";

    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            return DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver no encontrado", e);
        }
    }

    private void closeResources(Connection con, PreparedStatement pstmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (con != null) con.close();
        } catch (SQLException ex) {
            System.err.println("Error cerrando recursos: " + ex.getMessage());
        }
    }

    // MÉTODO EXISTENTE: Registrar un nuevo usuario del sistema (con procedimiento almacenado)
    public int registrarUsuarioSistema(String nombre, String rol, String email, String passwordHash) {
        int idUsuarioGenerado = -1;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_RegistrarUsuarioSistema(?, ?, ?, ?)}");
            
            // Establecer parámetros
            cstmt.setString(1, nombre);
            cstmt.setString(2, rol);
            cstmt.setString(3, email);
            cstmt.setString(4, passwordHash);
            
            // Ejecutar el procedimiento almacenado
            boolean tieneResultados = cstmt.execute();
            
            // Obtener el ID generado
            if (tieneResultados) {
                rs = cstmt.getResultSet();
                if (rs.next()) {
                    idUsuarioGenerado = rs.getInt("id_usuario");
                }
            }

        } catch (ClassNotFoundException e) {
            System.err.println("Error: Driver no encontrado");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Error en la operación SQL al registrar usuario");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error general al registrar usuario");
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (cstmt != null) cstmt.close();
                if (con != null) con.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
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

    // MÉTODO EXISTENTE: Validar credenciales de usuario usando el procedimiento almacenado
    public UsuarioSistema validarUsuario(String email, String passwordHash) {
        UsuarioSistema usuario = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_ValidarUsuario(?, ?)}");
            
            // Establecer parámetros
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
            }

        } catch (ClassNotFoundException e) {
            System.err.println("Error: Driver no encontrado");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Error en la operación SQL al validar usuario");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error general al validar usuario");
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (cstmt != null) cstmt.close();
                if (con != null) con.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return usuario;
    }

    // =============================================
    // NUEVOS MÉTODOS CON CONSULTAS SQL DIRECTAS
    // =============================================

    // MÉTODO: Listar todos los usuarios del sistema
    public List<UsuarioSistema> listarTodosUsuarios() {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<UsuarioSistema> usuarios = new ArrayList<>();
        
        try {
            con = getConnection();
            String sql = "SELECT id_usuario, nombre, rol, email, created_at, updated_at " +
                        "FROM usuario_sistema " +
                        "ORDER BY nombre";
            
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
                usuarios.add(usuario);
            }

        } catch (SQLException e) {
            System.err.println("Error al listar usuarios: " + e.getMessage());
        } finally {
            closeResources(con, pstmt, rs);
        }
        return usuarios;
    }

    // MÉTODO: Cambiar contraseña de usuario
    public boolean cambiarPassword(int idUsuario, String nuevoPasswordHash) {
        Connection con = null;
        PreparedStatement pstmt = null;
        
        try {
            con = getConnection();
            String sql = "UPDATE usuario_sistema SET password_hash = ?, updated_at = CURRENT_TIMESTAMP " +
                        "WHERE id_usuario = ?";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, nuevoPasswordHash);
            pstmt.setInt(2, idUsuario);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("Error al cambiar contraseña: " + e.getMessage());
            return false;
        } finally {
            closeResources(con, pstmt, null);
        }
    }

    // MÉTODO: Verificar contraseña actual
    public boolean verificarPasswordActual(int idUsuario, String passwordActualHash) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            con = getConnection();
            String sql = "SELECT id_usuario FROM usuario_sistema " +
                        "WHERE id_usuario = ? AND password_hash = ?";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, idUsuario);
            pstmt.setString(2, passwordActualHash);
            
            rs = pstmt.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            System.err.println("Error al verificar contraseña actual: " + e.getMessage());
            return false;
        } finally {
            closeResources(con, pstmt, rs);
        }
    }

    // MÉTODO: Actualizar perfil de usuario
    public boolean actualizarPerfil(int idUsuario, String nombre, String email) {
        Connection con = null;
        PreparedStatement pstmt = null;
        
        try {
            con = getConnection();
            String sql = "UPDATE usuario_sistema SET nombre = ?, email = ?, updated_at = CURRENT_TIMESTAMP " +
                        "WHERE id_usuario = ?";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, nombre);
            pstmt.setString(2, email);
            pstmt.setInt(3, idUsuario);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("Error al actualizar perfil: " + e.getMessage());
            return false;
        } finally {
            closeResources(con, pstmt, null);
        }
    }

    // MÉTODO: Cambiar estado de usuario
    public boolean cambiarEstadoUsuario(int idUsuario, String nuevoEstado) {
        Connection con = null;
        PreparedStatement pstmt = null;
        
        try {
            con = getConnection();
            String sql = "UPDATE usuario_sistema SET estado = ?, updated_at = CURRENT_TIMESTAMP " +
                        "WHERE id_usuario = ?";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, nuevoEstado);
            pstmt.setInt(2, idUsuario);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("Error al cambiar estado de usuario: " + e.getMessage());
            return false;
        } finally {
            closeResources(con, pstmt, null);
        }
    }

    // MÉTODO: Buscar usuarios por criterios
    public List<UsuarioSistema> buscarUsuarios(String termino, String rol, String estado) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<UsuarioSistema> usuarios = new ArrayList<>();
        
        try {
            con = getConnection();
            StringBuilder sql = new StringBuilder(
                "SELECT id_usuario, nombre, rol, email, created_at, updated_at " +
                "FROM usuario_sistema WHERE 1=1"
            );
            
            List<Object> parametros = new ArrayList<>();
            
            if (termino != null && !termino.trim().isEmpty()) {
                sql.append(" AND (nombre LIKE ? OR email LIKE ?)");
                parametros.add("%" + termino + "%");
                parametros.add("%" + termino + "%");
            }
            
            if (rol != null && !rol.trim().isEmpty()) {
                sql.append(" AND rol = ?");
                parametros.add(rol);
            }
            
            if (estado != null && !estado.trim().isEmpty()) {
                sql.append(" AND estado = ?");
                parametros.add(estado);
            }
            
            sql.append(" ORDER BY nombre");
            
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
                usuarios.add(usuario);
            }

        } catch (SQLException e) {
            System.err.println("Error al buscar usuarios: " + e.getMessage());
        } finally {
            closeResources(con, pstmt, rs);
        }
        return usuarios;
    }

    // MÉTODO: Obtener perfil completo del usuario
    public UsuarioSistema obtenerPerfilCompleto(int idUsuario) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        UsuarioSistema usuario = null;
        
        try {
            con = getConnection();
            String sql = "SELECT id_usuario, nombre, rol, email, created_at, updated_at " +
                        "FROM usuario_sistema WHERE id_usuario = ?";
            
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
            }

        } catch (SQLException e) {
            System.err.println("Error al obtener perfil: " + e.getMessage());
        } finally {
            closeResources(con, pstmt, rs);
        }
        return usuario;
    }

    // MÉTODO: Eliminar usuario del sistema
    public boolean eliminarUsuario(int idUsuario) {
        Connection con = null;
        PreparedStatement pstmt = null;
        
        try {
            con = getConnection();
            String sql = "DELETE FROM usuario_sistema WHERE id_usuario = ?";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, idUsuario);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("Error al eliminar usuario: " + e.getMessage());
            return false;
        } finally {
            closeResources(con, pstmt, null);
        }
    }

    // MÉTODO: Registrar último acceso del usuario
    public boolean registrarUltimoAcceso(int idUsuario) {
        Connection con = null;
        PreparedStatement pstmt = null;
        
        try {
            con = getConnection();
            String sql = "UPDATE usuario_sistema SET updated_at = CURRENT_TIMESTAMP " +
                        "WHERE id_usuario = ?";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, idUsuario);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("Error al registrar último acceso: " + e.getMessage());
            return false;
        } finally {
            closeResources(con, pstmt, null);
        }
    }

    // MÉTODO: Registrar intento fallido de login
    public boolean registrarIntentoFallidoLogin(String email) {
        Connection con = null;
        PreparedStatement pstmt = null;
        
        try {
            con = getConnection();
            String sql = "UPDATE usuario_sistema SET updated_at = CURRENT_TIMESTAMP " +
                        "WHERE email = ?";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, email);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("Error al registrar intento fallido: " + e.getMessage());
            return false;
        } finally {
            closeResources(con, pstmt, null);
        }
    }

    // MÉTODO: Registrar cierre de sesión
    public boolean registrarCierreSesion(int idUsuario) {
        return registrarUltimoAcceso(idUsuario);
    }

    // MÉTODO: Verificar si email ya existe
    public boolean existeEmail(String email) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            con = getConnection();
            String sql = "SELECT id_usuario FROM usuario_sistema WHERE email = ?";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, email);
            
            rs = pstmt.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            System.err.println("Error al verificar email: " + e.getMessage());
            return false;
        } finally {
            closeResources(con, pstmt, rs);
        }
    }
}