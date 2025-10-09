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

    // Método main para probar solo el último método agregado
    public static void main(String[] args) {
        FacturaDao facturaDAO = new FacturaDao();

        System.out.println("=== Probando sp_AnularFactura ===");
        
        // Anular factura (suponiendo que existe una factura con ID 1)
        int idFactura = 1;
        
        boolean anulada = facturaDAO.anularFactura(idFactura);
        
        if (anulada) {
            System.out.println("✅ Factura anulada correctamente usando sp_AnularFactura");
            System.out.println("ID Factura: " + idFactura);
            System.out.println("\n⚠️  El procedimiento automáticamente:");
            System.out.println("- Cambia el estado de la factura a 'anulada'");
            System.out.println("- Cambia el estado de los pagos asociados a 'fallido'");
        } else {
            System.out.println("❌ Error al anular la factura");
            System.out.println("Posibles causas:");
            System.out.println("- La factura no existe");
            System.out.println("- ID de factura incorrecto");
            System.out.println("- La factura ya estaba anulada");
        }
    }
}