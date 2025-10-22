package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.Factura;

public class FacturaDao {
    
    private Connection con;
    private CallableStatement cstmt;
    private ResultSet rs;
    private String url = "jdbc:mysql://localhost/vet_teran";
    private String user = "root";
    private String pass = "";

    public boolean crearFactura(Factura factura) {
        boolean exito = false;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);
            
            cstmt = con.prepareCall("{CALL sp_CrearFactura(?, ?, ?, ?)}");
            
            cstmt.setString(1, factura.getSerie());
            cstmt.setString(2, factura.getNumero());
            cstmt.setInt(3, factura.getIdAtencion());
            cstmt.setString(4, factura.getMetodoPagoSugerido());
            
            int filasAfectadas = cstmt.executeUpdate();
            
            if (filasAfectadas > 0) {
                exito = true;
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cstmt != null) cstmt.close();
                if (con != null) con.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return exito;
    }

    public List<Factura> obtenerFacturasPorCliente(int idCliente) {
        List<Factura> facturas = new ArrayList<>();
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_ObtenerFacturasPorCliente(?)}");
            cstmt.setInt(1, idCliente);
            
            rs = cstmt.executeQuery();

            while (rs.next()) {
                Factura factura = new Factura();
                factura.setIdFactura(rs.getInt("id_factura"));
                factura.setSerie(rs.getString("serie"));
                factura.setNumero(rs.getString("numero"));
                factura.setFechaEmision(rs.getTimestamp("fecha_emision"));
                factura.setSubtotal(rs.getDouble("subtotal"));
                factura.setImpuesto(rs.getDouble("impuesto"));
                factura.setTotal(rs.getDouble("total"));
                factura.setEstado(rs.getString("estado"));
                factura.setMetodoPagoSugerido(rs.getString("metodo_pago_sugerido"));
                
                facturas.add(factura);
            }

        } catch (ClassNotFoundException e) {
            System.err.println("Error: Driver no encontrado");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Error en la operación SQL");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error general");
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
        return facturas;
    }

    // NUEVO MÉTODO: Anular factura
    public boolean anularFactura(int idFactura) {
        boolean exito = false;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);
            
            cstmt = con.prepareCall("{CALL sp_AnularFactura(?)}");
            
            cstmt.setInt(1, idFactura);
            
            int filasAfectadas = cstmt.executeUpdate();
            
            if (filasAfectadas > 0) {
                exito = true;
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cstmt != null) cstmt.close();
                if (con != null) con.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return exito;
    }

    // MÉTODO: Anular factura con motivo
    public boolean anularFactura(int idFactura, String motivo) {
        boolean exito = false;
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, pass);
            conn.setAutoCommit(false);
            
            // 1. Actualizar estado de la factura a 'anulada'
            String sqlFactura = "UPDATE factura SET estado = 'anulada' WHERE id_factura = ? AND estado = 'emitida'";
            pstmt = conn.prepareStatement(sqlFactura);
            pstmt.setInt(1, idFactura);
            
            int filasFactura = pstmt.executeUpdate();
            
            if (filasFactura > 0) {
                // 2. Anular todos los pagos asociados a esta factura
                pstmt.close();
                String sqlPagos = "UPDATE pago SET estado = 'fallido' WHERE id_factura = ? AND estado != 'fallido'";
                pstmt = conn.prepareStatement(sqlPagos);
                pstmt.setInt(1, idFactura);
                
                pstmt.executeUpdate(); // No importa si no hay pagos
                
                conn.commit();
                exito = true;
            } else {
                conn.rollback();
            }
            
        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException se) {
                se.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return exito;
    }

    // MÉTODO: Buscar facturas por término
    public List<Factura> buscarFacturas(String termino) {
        List<Factura> facturas = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, pass);

            String sql = "SELECT f.*, c.nombre, c.apellido " +
                        "FROM factura f " +
                        "INNER JOIN cliente c ON f.id_cliente = c.id_cliente " +
                        "WHERE f.serie LIKE ? OR f.numero LIKE ? OR " +
                        "CONCAT(c.nombre, ' ', c.apellido) LIKE ? OR " +
                        "c.dni_ruc LIKE ? " +
                        "ORDER BY f.fecha_emision DESC";
            
            pstmt = conn.prepareStatement(sql);
            String busqueda = "%" + termino + "%";
            pstmt.setString(1, busqueda);
            pstmt.setString(2, busqueda);
            pstmt.setString(3, busqueda);
            pstmt.setString(4, busqueda);
            
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Factura factura = new Factura();
                factura.setIdFactura(rs.getInt("id_factura"));
                factura.setSerie(rs.getString("serie"));
                factura.setNumero(rs.getString("numero"));
                factura.setIdCliente(rs.getInt("id_cliente"));
                factura.setIdAtencion(rs.getInt("id_atencion"));
                factura.setFechaEmision(rs.getTimestamp("fecha_emision"));
                factura.setSubtotal(rs.getDouble("subtotal"));
                factura.setImpuesto(rs.getDouble("impuesto"));
                factura.setDescuentoTotal(rs.getDouble("descuento_total"));
                factura.setTotal(rs.getDouble("total"));
                factura.setEstado(rs.getString("estado"));
                factura.setMetodoPagoSugerido(rs.getString("metodo_pago_sugerido"));
                
                facturas.add(factura);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return facturas;
    }

    // MÉTODO: Obtener facturas por rango de fechas
    public List<Factura> obtenerFacturasPorFecha(java.sql.Timestamp fechaInicio, java.sql.Timestamp fechaFin) {
        List<Factura> facturas = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, pass);

            String sql = "SELECT * FROM factura " +
                        "WHERE fecha_emision >= ? AND fecha_emision <= ? " +
                        "ORDER BY fecha_emision DESC";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setTimestamp(1, fechaInicio);
            pstmt.setTimestamp(2, fechaFin);
            
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Factura factura = new Factura();
                factura.setIdFactura(rs.getInt("id_factura"));
                factura.setSerie(rs.getString("serie"));
                factura.setNumero(rs.getString("numero"));
                factura.setIdCliente(rs.getInt("id_cliente"));
                factura.setIdAtencion(rs.getInt("id_atencion"));
                factura.setFechaEmision(rs.getTimestamp("fecha_emision"));
                factura.setSubtotal(rs.getDouble("subtotal"));
                factura.setImpuesto(rs.getDouble("impuesto"));
                factura.setDescuentoTotal(rs.getDouble("descuento_total"));
                factura.setTotal(rs.getDouble("total"));
                factura.setEstado(rs.getString("estado"));
                factura.setMetodoPagoSugerido(rs.getString("metodo_pago_sugerido"));
                
                facturas.add(factura);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return facturas;
    }

    // MÉTODO: Obtener facturas por estado
    public List<Factura> obtenerFacturasPorEstado(String estado) {
        List<Factura> facturas = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, pass);

            String sql = "SELECT * FROM factura WHERE estado = ? ORDER BY fecha_emision DESC";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, estado);
            
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Factura factura = new Factura();
                factura.setIdFactura(rs.getInt("id_factura"));
                factura.setSerie(rs.getString("serie"));
                factura.setNumero(rs.getString("numero"));
                factura.setIdCliente(rs.getInt("id_cliente"));
                factura.setIdAtencion(rs.getInt("id_atencion"));
                factura.setFechaEmision(rs.getTimestamp("fecha_emision"));
                factura.setSubtotal(rs.getDouble("subtotal"));
                factura.setImpuesto(rs.getDouble("impuesto"));
                factura.setDescuentoTotal(rs.getDouble("descuento_total"));
                factura.setTotal(rs.getDouble("total"));
                factura.setEstado(rs.getString("estado"));
                factura.setMetodoPagoSugerido(rs.getString("metodo_pago_sugerido"));
                
                facturas.add(factura);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return facturas;
    }

    // MÉTODO: Listar todas las facturas
    public List<Factura> listarTodasFacturas() {
        List<Factura> facturas = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, pass);

            String sql = "SELECT * FROM factura ORDER BY fecha_emision DESC";
            
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Factura factura = new Factura();
                factura.setIdFactura(rs.getInt("id_factura"));
                factura.setSerie(rs.getString("serie"));
                factura.setNumero(rs.getString("numero"));
                factura.setIdCliente(rs.getInt("id_cliente"));
                factura.setIdAtencion(rs.getInt("id_atencion"));
                factura.setFechaEmision(rs.getTimestamp("fecha_emision"));
                factura.setSubtotal(rs.getDouble("subtotal"));
                factura.setImpuesto(rs.getDouble("impuesto"));
                factura.setDescuentoTotal(rs.getDouble("descuento_total"));
                factura.setTotal(rs.getDouble("total"));
                factura.setEstado(rs.getString("estado"));
                factura.setMetodoPagoSugerido(rs.getString("metodo_pago_sugerido"));
                
                facturas.add(factura);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return facturas;
    }

    // MÉTODO: Obtener factura por ID
    public Factura obtenerFacturaPorId(int idFactura) {
        Factura factura = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, pass);

            String sql = "SELECT * FROM factura WHERE id_factura = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, idFactura);
            
            rs = pstmt.executeQuery();

            if (rs.next()) {
                factura = new Factura();
                factura.setIdFactura(rs.getInt("id_factura"));
                factura.setSerie(rs.getString("serie"));
                factura.setNumero(rs.getString("numero"));
                factura.setIdCliente(rs.getInt("id_cliente"));
                factura.setIdAtencion(rs.getInt("id_atencion"));
                factura.setFechaEmision(rs.getTimestamp("fecha_emision"));
                factura.setSubtotal(rs.getDouble("subtotal"));
                factura.setImpuesto(rs.getDouble("impuesto"));
                factura.setDescuentoTotal(rs.getDouble("descuento_total"));
                factura.setTotal(rs.getDouble("total"));
                factura.setEstado(rs.getString("estado"));
                factura.setMetodoPagoSugerido(rs.getString("metodo_pago_sugerido"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return factura;
    }
}