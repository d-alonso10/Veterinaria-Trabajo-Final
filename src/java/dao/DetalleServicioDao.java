package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.DetalleServicio;
import modelo.DetalleServicioAtencionDTO;

public class DetalleServicioDao {
    
    private Connection con;
    private CallableStatement cstmt;
    private ResultSet rs;
    private String url = "jdbc:mysql://localhost/vet_teran";
    private String user = "root";
    private String pass = "";

    public boolean agregarServicioAtencion(DetalleServicio detalleServicio) {
        boolean exito = false;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);
            
            cstmt = con.prepareCall("{CALL sp_AgregarServicioAtencion(?, ?, ?, ?, ?, ?)}");
            
            cstmt.setInt(1, detalleServicio.getIdAtencion());
            cstmt.setInt(2, detalleServicio.getIdServicio());
            cstmt.setInt(3, detalleServicio.getCantidad());
            cstmt.setDouble(4, detalleServicio.getPrecioUnitario());
            cstmt.setInt(5, detalleServicio.getDescuentoId());
            cstmt.setString(6, detalleServicio.getObservaciones());
            
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

    // NUEVO MÉTODO: Obtener detalle de servicios por atención
    public List<DetalleServicioAtencionDTO> detalleServiciosAtencion(int idAtencion) {
        List<DetalleServicioAtencionDTO> detalles = new ArrayList<>();
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_DetalleServiciosAtencion(?)}");
            cstmt.setInt(1, idAtencion);
            
            rs = cstmt.executeQuery();

            while (rs.next()) {
                DetalleServicioAtencionDTO detalle = new DetalleServicioAtencionDTO();
                detalle.setIdDetalle(rs.getInt("id_detalle"));
                detalle.setServicio(rs.getString("servicio"));
                detalle.setCategoria(rs.getString("categoria"));
                detalle.setCantidad(rs.getInt("cantidad"));
                detalle.setPrecioUnitario(rs.getDouble("precio_unitario"));
                detalle.setSubtotal(rs.getDouble("subtotal"));
                detalle.setObservaciones(rs.getString("observaciones"));
                
                detalles.add(detalle);
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
        return detalles;
    }

    // Método main para probar solo el último método agregado
    public static void main(String[] args) {
        DetalleServicioDao detalleServicioDAO = new DetalleServicioDao();

        System.out.println("=== Probando sp_DetalleServiciosAtencion ===");
        
        // Obtener detalle de servicios de la atención con ID 1
        int idAtencion = 1;
        List<DetalleServicioAtencionDTO> detalles = detalleServicioDAO.detalleServiciosAtencion(idAtencion);
        
        if (detalles.isEmpty()) {
            System.out.println("No se encontraron servicios para la atención ID: " + idAtencion);
            System.out.println("Posibles causas:");
            System.out.println("- La atención no existe");
            System.out.println("- La atención no tiene servicios registrados");
        } else {
            System.out.println("DETALLE DE SERVICIOS - ATENCIÓN ID: " + idAtencion);
            System.out.println("=====================================");
            
            double subtotalTotal = 0;
            int totalItems = 0;
            int contador = 1;
            
            for (DetalleServicioAtencionDTO detalle : detalles) {
                System.out.println("\n" + contador + ". " + detalle.getServicio());
                System.out.println("   Categoría: " + detalle.getCategoria());
                System.out.println("   Cantidad: " + detalle.getCantidad());
                System.out.println("   Precio unitario: S/ " + detalle.getPrecioUnitario());
                System.out.println("   Subtotal: S/ " + detalle.getSubtotal());
                System.out.println("   Observaciones: " + detalle.getObservaciones());
                System.out.println("   -------------------------");
                
                subtotalTotal += detalle.getSubtotal();
                totalItems += detalle.getCantidad();
                contador++;
            }
            
            // Resumen del detalle
            System.out.println("\nRESUMEN DE LA ATENCIÓN:");
            System.out.println("======================");
            System.out.println("Total de servicios diferentes: " + detalles.size());
            System.out.println("Total de items: " + totalItems);
            System.out.println("Subtotal: S/ " + subtotalTotal);
            System.out.println("IGV (18%): S/ " + (subtotalTotal * 0.18));
            System.out.println("TOTAL: S/ " + (subtotalTotal * 1.18));
            
            // Análisis por categoría
            System.out.println("\nDISTRIBUCIÓN POR CATEGORÍA:");
            System.out.println("===========================");
            detalles.stream()
                .collect(java.util.stream.Collectors.groupingBy(DetalleServicioAtencionDTO::getCategoria))
                .forEach((categoria, serviciosCat) -> {
                    double totalCat = serviciosCat.stream().mapToDouble(DetalleServicioAtencionDTO::getSubtotal).sum();
                    System.out.println("- " + categoria + ": S/ " + totalCat + 
                                   " (" + serviciosCat.size() + " servicios)");
                });
            
            // Servicio más caro
            if (!detalles.isEmpty()) {
                DetalleServicioAtencionDTO servicioCaro = detalles.stream()
                    .max((d1, d2) -> Double.compare(d1.getSubtotal(), d2.getSubtotal()))
                    .get();
                System.out.println("\nSERVICIO DE MAYOR VALOR:");
                System.out.println("Nombre: " + servicioCaro.getServicio());
                System.out.println("Subtotal: S/ " + servicioCaro.getSubtotal());
            }
        }
    }

    // MÉTODO: Eliminar detalle de servicio
    public boolean eliminarDetalleServicio(int idDetalle) {
        boolean exito = false;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_EliminarDetalleServicio(?)}");
            cstmt.setInt(1, idDetalle);
            
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

    // MÉTODO: Actualizar detalle de servicio
    public boolean actualizarDetalleServicio(int idDetalle, int cantidad, double precioUnitario, String observaciones) {
        boolean exito = false;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_ActualizarDetalleServicio(?, ?, ?, ?)}");
            
            cstmt.setInt(1, idDetalle);
            cstmt.setInt(2, cantidad);
            cstmt.setDouble(3, precioUnitario);
            cstmt.setString(4, observaciones);
            
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
}