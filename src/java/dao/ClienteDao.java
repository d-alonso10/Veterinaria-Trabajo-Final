package dao;

import java.sql.*;
import java.util.*;
import modelo.Cliente;
import modelo.ClienteFrecuenteDTO;

public class ClienteDao {

    private Connection con;
    private CallableStatement cstmt;
    private ResultSet rs;
    private String url = "jdbc:mysql://localhost/vet_teran";
    private String user = "root";
    private String pass = "";

    public boolean insertarCliente(Cliente cliente) {
        boolean exito = false;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_InsertarCliente(?, ?, ?, ?, ?, ?, ?)}");

            cstmt.setString(1, cliente.getNombre());
            cstmt.setString(2, cliente.getApellido());
            cstmt.setString(3, cliente.getDniRuc());
            cstmt.setString(4, cliente.getEmail());
            cstmt.setString(5, cliente.getTelefono());
            cstmt.setString(6, cliente.getDireccion());

            // CONVERTIR String a JSON válido
            String preferencias = cliente.getPreferencias();
            if (preferencias != null && !preferencias.trim().isEmpty()) {
                // Crear un objeto JSON simple con el valor
                String jsonPreferencias = "{\"preferencia\": \"" + preferencias.replace("\"", "\\\"") + "\"}";
                cstmt.setString(7, jsonPreferencias);
            } else {
                // JSON vacío si no hay preferencias
                cstmt.setString(7, "{}");
            }

            int filasAfectadas = cstmt.executeUpdate();

            if (filasAfectadas > 0) {
                exito = true;
            }

        } catch (SQLException e) {
            System.err.println("Error SQL al insertar cliente: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Error general al insertar cliente");
        } finally {
            try {
                if (cstmt != null) {
                    cstmt.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException ex) {
                System.err.println("Error al cerrar conexiones: " + ex.getMessage());
            }
        }
        return exito;
    }

    // MÉTODO: Obtener clientes frecuentes (top 10)
    public List<ClienteFrecuenteDTO> clientesFrecuentes() {
        List<ClienteFrecuenteDTO> clientesFrecuentes = new ArrayList<>();

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_ClientesFrecuentes()}");

            rs = cstmt.executeQuery();

            while (rs.next()) {
                ClienteFrecuenteDTO clienteFrecuente = new ClienteFrecuenteDTO();
                clienteFrecuente.setIdCliente(rs.getInt("id_cliente"));
                clienteFrecuente.setNombre(rs.getString("nombre"));
                clienteFrecuente.setApellido(rs.getString("apellido"));
                clienteFrecuente.setEmail(rs.getString("email"));
                clienteFrecuente.setTelefono(rs.getString("telefono"));
                clienteFrecuente.setTotalAtenciones(rs.getInt("total_atenciones"));
                clienteFrecuente.setTotalMascotas(rs.getInt("total_mascotas"));
                clienteFrecuente.setTotalGastado(rs.getDouble("total_gastado"));

                clientesFrecuentes.add(clienteFrecuente);
            }

        } catch (ClassNotFoundException e) {
            System.err.println("Error: Driver no encontrado");
        } catch (SQLException e) {
            System.err.println("Error en la operación SQL");
        } catch (Exception e) {
            System.err.println("Error general");
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (cstmt != null) {
                    cstmt.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException ex) {
                System.err.println("Error al cerrar conexiones: " + ex.getMessage());
            }
        }
        return clientesFrecuentes;
    }

    public List<Cliente> buscarClientes(String termino) {
        List<Cliente> clientes = new ArrayList<>();

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_BuscarClientes(?)}");

            cstmt.setString(1, termino);

            rs = cstmt.executeQuery();

            while (rs.next()) {
                Cliente cliente = new Cliente();
                cliente.setIdCliente(rs.getInt("id_cliente"));
                cliente.setNombre(rs.getString("nombre"));
                cliente.setApellido(rs.getString("apellido"));
                cliente.setDniRuc(rs.getString("dni_ruc"));
                cliente.setEmail(rs.getString("email"));
                cliente.setTelefono(rs.getString("telefono"));
                cliente.setDireccion(rs.getString("direccion"));

                clientes.add(cliente);
            }

        } catch (ClassNotFoundException e) {
            System.err.println("Error: Driver no encontrado");
        } catch (SQLException e) {
            System.err.println("Error en la operación SQL al buscar clientes");
        } catch (Exception e) {
            System.err.println("Error general al buscar clientes");
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (cstmt != null) {
                    cstmt.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException ex) {
                System.err.println("Error al cerrar conexiones: " + ex.getMessage());
            }
        }
        return clientes;
    }

    public List<Cliente> listarTodosClientes() {
        List<Cliente> clientes = new ArrayList<>();
        Connection localCon = null;
        PreparedStatement pstmt = null;
        ResultSet localRs = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            localCon = DriverManager.getConnection(url, user, pass);

            String sql = "SELECT id_cliente, nombre, apellido, dni_ruc, email, telefono, direccion FROM cliente ORDER BY nombre, apellido";
            pstmt = localCon.prepareStatement(sql);
            localRs = pstmt.executeQuery();

            while (localRs.next()) {
                Cliente cliente = new Cliente();
                cliente.setIdCliente(localRs.getInt("id_cliente"));
                cliente.setNombre(localRs.getString("nombre"));
                cliente.setApellido(localRs.getString("apellido"));
                cliente.setDniRuc(localRs.getString("dni_ruc"));
                cliente.setEmail(localRs.getString("email"));
                cliente.setTelefono(localRs.getString("telefono"));
                cliente.setDireccion(localRs.getString("direccion"));

                clientes.add(cliente);
            }

            System.out.println("DEBUG - Clientes encontrados en Dao: " + clientes.size());

        } catch (ClassNotFoundException e) {
            System.err.println("Error: Driver no encontrado - " + e.getMessage());
            return null; 
        } catch (SQLException e) {
            System.err.println("Error SQL al listar clientes: " + e.getMessage());
            e.printStackTrace();
            return null; 
        } catch (Exception e) {
            System.err.println("Error general al listar clientes: " + e.getMessage());
            e.printStackTrace();
            return null; 
        } finally {
            try {
                if (localRs != null) {
                    localRs.close();
                }
                if (pstmt != null) {
                    pstmt.close();
                }
                if (localCon != null) {
                    localCon.close();
                }
            } catch (SQLException ex) {
                System.err.println("Error al cerrar conexiones: " + ex.getMessage());
            }
        }
        return clientes;
    }

    // MÉTODOS FALTANTES REQUERIDOS POR ClienteControlador según instrucciones de Diego

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
                // Manejar preferencias JSON
                String prefs = rs.getString("preferencias");
                cliente.setPreferencias(prefs != null ? prefs : "{}");
            }
        } catch (Exception e) {
            System.err.println("Error al obtener cliente por ID: " + e.getMessage());
            e.printStackTrace();
        } finally {
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

            // Manejo simple de preferencias (JSON)
            String prefs = cliente.getPreferencias();
            if (prefs != null && !prefs.trim().isEmpty()) {
                // Si ya es JSON válido, usarlo directamente; si no, crear estructura básica
                if (prefs.startsWith("{") && prefs.endsWith("}")) {
                    pstmt.setString(7, prefs);
                } else {
                    pstmt.setString(7, "{\"preferencia\":\"" + prefs.replace("\"", "\\\"") + "\"}");
                }
            } else {
                pstmt.setString(7, "{}");
            }

            pstmt.setInt(8, cliente.getIdCliente());

            int filasAfectadas = pstmt.executeUpdate();
            exito = (filasAfectadas > 0);

        } catch (Exception e) {
            System.err.println("Error al actualizar cliente: " + e.getMessage());
            e.printStackTrace();
        } finally {
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

            // 1. Eliminar mascotas asociadas (o manejar la restricción FK)
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
            try { if (pstmtMascotas != null) pstmtMascotas.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (pstmtCliente != null) pstmtCliente.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) { conn.setAutoCommit(true); conn.close(); } } catch (SQLException e) { e.printStackTrace(); }
        }
        return exito;
    }
}
