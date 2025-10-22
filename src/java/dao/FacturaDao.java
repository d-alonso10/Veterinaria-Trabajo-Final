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
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);
            
            cstmt = con.prepareCall("{CALL sp_AnularFacturaConMotivo(?, ?)}");
            
            cstmt.setInt(1, idFactura);
            cstmt.setString(2, motivo);
            
            int filasAfectadas = cstmt.executeUpdate();
            exito = (filasAfectadas > 0);
            
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

    // MÉTODO: Buscar facturas por término
    public List<Factura> buscarFacturas(String termino) {
        List<Factura> facturas = new ArrayList<>();
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_BuscarFacturas(?)}");
            cstmt.setString(1, termino);
            
            rs = cstmt.executeQuery();

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
                if (cstmt != null) cstmt.close();
                if (con != null) con.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return facturas;
    }

    // MÉTODO: Obtener facturas por rango de fechas
    public List<Factura> obtenerFacturasPorFecha(java.sql.Date fechaInicio, java.sql.Date fechaFin) {
        List<Factura> facturas = new ArrayList<>();
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_ObtenerFacturasPorFecha(?, ?)}");
            cstmt.setDate(1, fechaInicio);
            cstmt.setDate(2, fechaFin);
            
            rs = cstmt.executeQuery();

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
                if (cstmt != null) cstmt.close();
                if (con != null) con.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return facturas;
    }

    // MÉTODO: Obtener facturas por estado
    public List<Factura> obtenerFacturasPorEstado(String estado) {
        List<Factura> facturas = new ArrayList<>();
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_ObtenerFacturasPorEstado(?)}");
            cstmt.setString(1, estado);
            
            rs = cstmt.executeQuery();

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
                if (cstmt != null) cstmt.close();
                if (con != null) con.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return facturas;
    }

    // MÉTODO: Listar todas las facturas
    public List<Factura> listarTodasFacturas() {
        List<Factura> facturas = new ArrayList<>();
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_ListarTodasFacturas()}");
            
            rs = cstmt.executeQuery();

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
                if (cstmt != null) cstmt.close();
                if (con != null) con.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return facturas;
    }

    // MÉTODO: Obtener factura por ID
    public Factura obtenerFacturaPorId(int idFactura) {
        Factura factura = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_ObtenerFacturaPorId(?)}");
            cstmt.setInt(1, idFactura);
            
            rs = cstmt.executeQuery();

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
                if (cstmt != null) cstmt.close();
                if (con != null) con.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return factura;
    }
}