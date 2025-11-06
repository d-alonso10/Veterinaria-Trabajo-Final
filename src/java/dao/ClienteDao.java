package dao;

import java.sql.*;
import java.util.*;
import modelo.Cliente;
import modelo.ClienteFrecuenteDTO;

public class ClienteDao {

    // --- MANEJO DE CONEXIÓN CENTRALIZADO ---
    private String url = "jdbc:mysql://localhost/vet_teran";
    private String user = "root";
    private String pass = "";

    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            return DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver MySQL no encontrado", e);
        }
    }

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
    // --- FIN MANEJO DE CONEXIÓN ---

    public boolean insertarCliente(Cliente cliente) {
        boolean exito = false;
        Connection con = null;
        CallableStatement cstmt = null;
        
        try {
            con = getConnection();
            cstmt = con.prepareCall("{CALL sp_InsertarCliente(?, ?, ?, ?, ?, ?, ?)}");
            cstmt.setString(1, cliente.getNombre());
            cstmt.setString(2, cliente.getApellido());
            cstmt.setString(3, cliente.getDniRuc());
            cstmt.setString(4, cliente.getEmail());
            cstmt.setString(5, cliente.getTelefono());
            cstmt.setString(6, cliente.getDireccion());

            String preferencias = cliente.getPreferencias();
            if (preferencias != null && !preferencias.trim().isEmpty()) {
                // Asumimos que las preferencias ya vienen como un JSON simple o un string
                // Si no es un JSON válido, lo envolvemos
                if (!preferencias.trim().startsWith("{")) {
                     preferencias = "{\"preferencia\": \"" + preferencias.replace("\"", "\\\"") + "\"}";
                }
                cstmt.setString(7, preferencias);
            } else {
                cstmt.setString(7, "{}");
            }

            int filasAfectadas = cstmt.executeUpdate();
            exito = (filasAfectadas > 0);

        } catch (Exception e) {
            System.err.println("Error SQL al insertar cliente: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(con, cstmt, null);
        }
        return exito;
    }

    public List<ClienteFrecuenteDTO> clientesFrecuentes() {
        List<ClienteFrecuenteDTO> clientesFrecuentes = new ArrayList<>();
        Connection con = null;
        CallableStatement cstmt = null;
        ResultSet rs = null;

        try {
            con = getConnection();
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

        } catch (Exception e) {
            System.err.println("Error en la operación SQL: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(con, cstmt, rs);
        }
        return clientesFrecuentes;
    }

    public List<Cliente> buscarClientes(String termino) {
        List<Cliente> clientes = new ArrayList<>();
        Connection con = null;
        CallableStatement cstmt = null;
        ResultSet rs = null;

        try {
            con = getConnection();
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

        } catch (Exception e) {
            System.err.println("Error en la operación SQL al buscar clientes: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(con, cstmt, rs);
        }
        return clientes;
    }

    public List<Cliente> listarTodosClientes() {
        List<Cliente> clientes = new ArrayList<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT id_cliente, nombre, apellido, dni_ruc, email, telefono, direccion FROM cliente ORDER BY nombre, apellido";
        
        try {
            con = getConnection();
            pstmt = con.prepareStatement(sql);
            rs = pstmt.executeQuery();

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

        } catch (Exception e) {
            System.err.println("Error al listar clientes: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(con, pstmt, rs);
        }
        return clientes;
    }

    public Cliente obtenerClientePorId(int idCliente) {
        Cliente cliente = null;
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM cliente WHERE id_cliente = ?";

        try {
            con = getConnection();
            pstmt = con.prepareStatement(sql);
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
                String prefs = rs.getString("preferencias");
                cliente.setPreferencias(prefs != null ? prefs : "{}");
            }

        } catch (Exception e) {
            System.err.println("Error al obtener cliente por ID: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(con, pstmt, rs);
        }
        return cliente;
    }

    public boolean actualizarCliente(Cliente cliente) {
        boolean exito = false;
        Connection con = null;
        PreparedStatement pstmt = null;
        String sql = "UPDATE cliente SET nombre = ?, apellido = ?, dni_ruc = ?, email = ?, telefono = ?, direccion = ?, preferencias = ? WHERE id_cliente = ?";

        try {
            con = getConnection();
            pstmt = con.prepareStatement(sql);

            pstmt.setString(1, cliente.getNombre());
            pstmt.setString(2, cliente.getApellido());
            pstmt.setString(3, cliente.getDniRuc());
            pstmt.setString(4, cliente.getEmail());
            pstmt.setString(5, cliente.getTelefono());
            pstmt.setString(6, cliente.getDireccion());

            String prefs = cliente.getPreferencias();
            if (prefs != null && prefs.trim().startsWith("{") && prefs.trim().endsWith("}")) {
                pstmt.setString(7, prefs);
            } else {
                pstmt.setString(7, "{\"preferencia\":\"" + (prefs != null ? prefs.replace("\"", "\\\"") : "") + "\"}");
            }

            pstmt.setInt(8, cliente.getIdCliente());
            exito = (pstmt.executeUpdate() > 0);

        } catch (Exception e) {
            System.err.println("Error al actualizar cliente: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(con, pstmt, null);
        }
        return exito;
    }

    public boolean eliminarCliente(int idCliente) {
        boolean exito = false;
        Connection con = null;
        PreparedStatement pstmtMascotas = null;
        PreparedStatement pstmtCliente = null;
        String sqlDeleteMascotas = "DELETE FROM mascota WHERE id_cliente = ?";
        String sqlDeleteCliente = "DELETE FROM cliente WHERE id_cliente = ?";

        try {
            con = getConnection();
            con.setAutoCommit(false);

            pstmtMascotas = con.prepareStatement(sqlDeleteMascotas);
            pstmtMascotas.setInt(1, idCliente);
            pstmtMascotas.executeUpdate(); // Elimina mascotas primero

            pstmtCliente = con.prepareStatement(sqlDeleteCliente);
            pstmtCliente.setInt(1, idCliente);
            exito = (pstmtCliente.executeUpdate() > 0); // Luego elimina cliente

            con.commit(); // Confirma la transacción

        } catch (Exception e) {
            try { if (con != null) con.rollback(); } catch (SQLException se) {}
            System.err.println("Error al eliminar cliente (rollback): " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Cierra statements en su propio try-catch
            try { if (pstmtMascotas != null) pstmtMascotas.close(); } catch (SQLException ex) {}
            try { if (pstmtCliente != null) pstmtCliente.close(); } catch (SQLException ex) {}
            // Cierra la conexión y restaura auto-commit
            try { 
                if (con != null) { 
                    con.setAutoCommit(true); 
                    con.close(); 
                } 
            } catch (SQLException ex) {}
        }
        return exito;
    }
}