package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.Pago;

public class PagoDao {
    
    private Connection con;
    private CallableStatement cstmt;
    private ResultSet rs;
    private String url = "jdbc:mysql://localhost/vet_teran";
    private String user = "root";
    private String pass = "";

    // MÉTODO: Registrar un pago
    public boolean registrarPago(Pago pago) {
        boolean exito = false;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);
            
            cstmt = con.prepareCall("{CALL sp_RegistrarPago(?, ?, ?, ?)}");
            
            cstmt.setInt(1, pago.getIdFactura());
            cstmt.setDouble(2, pago.getMonto());
            cstmt.setString(3, pago.getMetodo());
            cstmt.setString(4, pago.getReferencia());
            
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

    // MÉTODO: Consultar pagos de una factura
    public List<Pago> obtenerPagosPorFactura(int idFactura) {
        List<Pago> pagos = new ArrayList<>();
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_ObtenerPagosPorFactura(?)}");
            cstmt.setInt(1, idFactura);
            
            rs = cstmt.executeQuery();

            while (rs.next()) {
                Pago pago = new Pago();
                pago.setIdPago(rs.getInt("id_pago"));
                pago.setFechaPago(rs.getTimestamp("fecha_pago"));
                pago.setMonto(rs.getDouble("monto"));
                pago.setMetodo(rs.getString("metodo"));
                pago.setReferencia(rs.getString("referencia"));
                pago.setEstado(rs.getString("estado"));
                
                pagos.add(pago);
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
        return pagos;
    }

    // Método main para probar ambos métodos
    public static void main(String[] args) {
        PagoDao pagoDAO = new PagoDao();

        System.out.println("=== Probando sp_RegistrarPago ===");
        
        // Registrar un nuevo pago
        Pago nuevoPago = new Pago();
        nuevoPago.setIdFactura(1); // ID de factura existente
        nuevoPago.setMonto(150.00);
        nuevoPago.setMetodo("efectivo");
        nuevoPago.setReferencia("PAGO-001");
        
        boolean registrado = pagoDAO.registrarPago(nuevoPago);
        
        if (registrado) {
            System.out.println("✅ Pago registrado correctamente usando sp_RegistrarPago");
            System.out.println("ID Factura: " + nuevoPago.getIdFactura());
            System.out.println("Monto: S/ " + nuevoPago.getMonto());
            System.out.println("Método: " + nuevoPago.getMetodo());
            System.out.println("Referencia: " + nuevoPago.getReferencia());
            System.out.println("Estado: confirmado (automático)");
        } else {
            System.out.println("❌ Error al registrar el pago");
            System.out.println("Posibles causas:");
            System.out.println("- La factura no existe");
            System.out.println("- ID de factura incorrecto");
        }

        System.out.println("\n=== Probando sp_ObtenerPagosPorFactura ===");
        
        // Obtener pagos de la factura con ID 1
        int idFactura = 1;
        List<Pago> pagosFactura = pagoDAO.obtenerPagosPorFactura(idFactura);
        
        if (pagosFactura.isEmpty()) {
            System.out.println("No se encontraron pagos para la factura ID: " + idFactura);
        } else {
            System.out.println("PAGOS DE LA FACTURA ID: " + idFactura);
            System.out.println("================================");
            
            double totalPagado = 0;
            int contador = 1;
            
            for (Pago pago : pagosFactura) {
                System.out.println("\n" + contador + ". PAGO ID: " + pago.getIdPago());
                System.out.println("   Fecha: " + pago.getFechaPago());
                System.out.println("   Monto: S/ " + pago.getMonto());
                System.out.println("   Método: " + pago.getMetodo());
                System.out.println("   Referencia: " + pago.getReferencia());
                System.out.println("   Estado: " + pago.getEstado());
                System.out.println("   -------------------------");
                
                totalPagado += pago.getMonto();
                contador++;
            }
            
            // Estadísticas
            System.out.println("\nRESUMEN DE PAGOS:");
            System.out.println("Total de pagos: " + pagosFactura.size());
            System.out.println("Monto total pagado: S/ " + totalPagado);
            
            // Pago más reciente
            if (!pagosFactura.isEmpty()) {
                Pago pagoReciente = pagosFactura.get(0);
                System.out.println("Último pago: " + pagoReciente.getFechaPago() + 
                                 " - S/ " + pagoReciente.getMonto() + 
                                 " (" + pagoReciente.getMetodo() + ")");
            }
        }
    }
}