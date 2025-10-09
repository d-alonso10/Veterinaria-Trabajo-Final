package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.ReporteIngresosDTO;

public class ReporteDao {
    
    private Connection con;
    private CallableStatement cstmt;
    private ResultSet rs;
    private String url = "jdbc:mysql://localhost/vet_teran";
    private String user = "root";
    private String pass = "";

    // MÉTODO: Reporte de ingresos por rango de fechas
    public List<ReporteIngresosDTO> reporteIngresos(java.sql.Date fechaInicio, java.sql.Date fechaFin, Integer idSucursal) {
        List<ReporteIngresosDTO> reporte = new ArrayList<>();
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_ReporteIngresos(?, ?, ?)}");
            
            cstmt.setDate(1, fechaInicio);
            cstmt.setDate(2, fechaFin);
            
            if (idSucursal != null) {
                cstmt.setInt(3, idSucursal);
            } else {
                cstmt.setNull(3, Types.INTEGER);
            }
            
            rs = cstmt.executeQuery();

            while (rs.next()) {
                ReporteIngresosDTO ingreso = new ReporteIngresosDTO();
                ingreso.setFecha(rs.getDate("fecha"));
                ingreso.setCantidadFacturas(rs.getInt("cantidad_facturas"));
                ingreso.setIngresosTotales(rs.getDouble("ingresos_totales"));
                ingreso.setPromedioPorFactura(rs.getDouble("promedio_por_factura"));
                
                reporte.add(ingreso);
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
        return reporte;
    }

    // Método main para probar el procedimiento almacenado
    public static void main(String[] args) {
        ReporteDao reporteDAO = new ReporteDao();

        System.out.println("=== Probando sp_ReporteIngresos ===");
        
        // Parámetros para el reporte
        java.sql.Date fechaInicio = java.sql.Date.valueOf("2024-01-01");
        java.sql.Date fechaFin = java.sql.Date.valueOf("2024-12-31");
        Integer idSucursal = null; // null para todas las sucursales
        
        System.out.println("Parámetros del reporte:");
        System.out.println("Fecha inicio: " + fechaInicio);
        System.out.println("Fecha fin: " + fechaFin);
        System.out.println("Sucursal: " + (idSucursal != null ? idSucursal : "Todas"));
        
        List<ReporteIngresosDTO> reporte = reporteDAO.reporteIngresos(fechaInicio, fechaFin, idSucursal);
        
        if (reporte.isEmpty()) {
            System.out.println("\nNo se encontraron ingresos para el período especificado");
        } else {
            System.out.println("\nREPORTE DE INGRESOS");
            System.out.println("===================");
            
            double totalGeneral = 0;
            int totalFacturas = 0;
            
            for (ReporteIngresosDTO ingreso : reporte) {
                System.out.println("\nFecha: " + ingreso.getFecha());
                System.out.println("Facturas emitidas: " + ingreso.getCantidadFacturas());
                System.out.println("Ingresos del día: S/ " + ingreso.getIngresosTotales());
                System.out.println("Promedio por factura: S/ " + ingreso.getPromedioPorFactura());
                System.out.println("---------------------------");
                
                totalGeneral += ingreso.getIngresosTotales();
                totalFacturas += ingreso.getCantidadFacturas();
            }
            
            // Resumen general del reporte
            System.out.println("\nRESUMEN GENERAL DEL PERÍODO:");
            System.out.println("============================");
            System.out.println("Total de días con ingresos: " + reporte.size());
            System.out.println("Total de facturas emitidas: " + totalFacturas);
            System.out.println("Ingresos totales: S/ " + totalGeneral);
            System.out.println("Promedio diario: S/ " + (totalGeneral / reporte.size()));
            System.out.println("Promedio general por factura: S/ " + (totalGeneral / totalFacturas));
            
            // Día con mayores ingresos
            if (!reporte.isEmpty()) {
                ReporteIngresosDTO mejorDia = reporte.stream()
                    .max((d1, d2) -> Double.compare(d1.getIngresosTotales(), d2.getIngresosTotales()))
                    .get();
                System.out.println("Mejor día: " + mejorDia.getFecha() + " - S/ " + mejorDia.getIngresosTotales());
            }
        }
        
        // Ejemplo con sucursal específica
        System.out.println("\n=== Probando con sucursal específica ===");
        idSucursal = 1;
        List<ReporteIngresosDTO> reporteSucursal = reporteDAO.reporteIngresos(fechaInicio, fechaFin, idSucursal);
        
        if (reporteSucursal.isEmpty()) {
            System.out.println("No se encontraron ingresos para la sucursal ID: " + idSucursal);
        } else {
            System.out.println("Reporte sucursal ID " + idSucursal + " - Total días: " + reporteSucursal.size());
        }
    }
}