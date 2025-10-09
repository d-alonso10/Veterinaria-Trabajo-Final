package dao;

import java.sql.*;
import modelo.UsuarioSistema;

public class UsuarioSistemaDao {
    
    private Connection con;
    private CallableStatement cstmt;
    private ResultSet rs;
    private String url = "jdbc:mysql://localhost/vet_teran";
    private String user = "root";
    private String pass = "";

    // MÉTODO: Registrar un nuevo usuario del sistema
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

    // MÉTODO: Validar credenciales de usuario usando el procedimiento almacenado
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

    // Método main para probar el nuevo DAO
    public static void main(String[] args) {
        UsuarioSistemaDao usuarioDAO = new UsuarioSistemaDao();

 

        System.out.println("\n=== Probando sp_ValidarUsuario ===");
        
        // Probar validación con credenciales correctas
        System.out.println("Validando credenciales correctas...");
        UsuarioSistema usuarioValidado = usuarioDAO.validarUsuario("maria@vetteran.com", "hash123");
        
        if (usuarioValidado != null) {
            System.out.println("✅ Validación exitosa!");
            System.out.println("ID: " + usuarioValidado.getIdUsuario());
            System.out.println("Nombre: " + usuarioValidado.getNombre());
            System.out.println("Rol: " + usuarioValidado.getRol());
            System.out.println("Email: " + usuarioValidado.getEmail());
            System.out.println("Fecha de creación: " + usuarioValidado.getCreatedAt());
        } else {
            System.out.println("❌ Validación fallida");
        }

        // Probar validación con credenciales incorrectas
        System.out.println("\nValidando credenciales incorrectas...");
        UsuarioSistema usuarioInvalido = usuarioDAO.validarUsuario("maria@vetteran.com", "password_incorrecto");
        
        if (usuarioInvalido == null) {
            System.out.println("✅ Comportamiento esperado: Credenciales incorrectas rechazadas");
        }

        // Probar validación con usuario que no existe
        System.out.println("\nValidando usuario inexistente...");
        UsuarioSistema usuarioNoExiste = usuarioDAO.validarUsuario("noexiste@vetteran.com", "hash123");
        
        if (usuarioNoExiste == null) {
            System.out.println("✅ Comportamiento esperado: Usuario no encontrado");
        }

        System.out.println("\n=== Resumen de pruebas ===");
        System.out.println("Validación correcta: " + (usuarioValidado != null ? "✅ ÉXITO" : "❌ FALLÓ"));
        System.out.println("Validación incorrecta: " + (usuarioInvalido == null ? "✅ ÉXITO" : "❌ FALLÓ"));
        System.out.println("Usuario inexistente: " + (usuarioNoExiste == null ? "✅ ÉXITO" : "❌ FALLÓ"));
    }
}