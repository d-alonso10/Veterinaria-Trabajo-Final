package dao;

import java.sql.*;
import modelo.PaqueteServicio;
import modelo.PaqueteServicioItem;

public class PaqueteServicioDao {
    
    private Connection con;
    private CallableStatement cstmt;
    private ResultSet rs;
    private String url = "jdbc:mysql://localhost/vet_teran";
    private String user = "root";
    private String pass = "";

    public int crearPaqueteServicio(PaqueteServicio paquete) {
        int idPaquete = -1;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);
            
            cstmt = con.prepareCall("{CALL sp_CrearPaqueteServicio(?, ?, ?)}");
            
            cstmt.setString(1, paquete.getNombre());
            cstmt.setString(2, paquete.getDescripcion());
            cstmt.setDouble(3, paquete.getPrecioTotal());
            
            // Ejecutar y obtener el resultado
            boolean tieneResultados = cstmt.execute();
            
            if (tieneResultados) {
                rs = cstmt.getResultSet();
                if (rs.next()) {
                    idPaquete = rs.getInt("id_paquete");
                }
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
        return idPaquete;
    }

    // NUEVO MÉTODO: Agregar servicio a paquete
    public boolean agregarServicioPaquete(PaqueteServicioItem item) {
        boolean exito = false;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);
            
            cstmt = con.prepareCall("{CALL sp_AgregarServicioPaquete(?, ?, ?)}");
            
            cstmt.setInt(1, item.getIdPaquete());
            cstmt.setInt(2, item.getIdServicio());
            cstmt.setInt(3, item.getCantidad());
            
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
        PaqueteServicioDao paqueteDAO = new PaqueteServicioDao();

        System.out.println("=== Probando sp_AgregarServicioPaquete ===");
        
        // Primero creamos un paquete de ejemplo
        PaqueteServicio paqueteEjemplo = new PaqueteServicio();
        paqueteEjemplo.setNombre("Paquete Spa Completo");
        paqueteEjemplo.setDescripcion("Servicio de spa completo para mascotas consentidas");
        paqueteEjemplo.setPrecioTotal(200.00);
        
        int idPaquete = paqueteDAO.crearPaqueteServicio(paqueteEjemplo);
        
        if (idPaquete == -1) {
            System.out.println("❌ No se pudo crear el paquete de ejemplo. Usando ID 1 para pruebas.");
            idPaquete = 1; // ID de paquete existente para pruebas
        }

        System.out.println("\n🛠️  AGREGANDO SERVICIOS AL PAQUETE ID: " + idPaquete);
        System.out.println("===========================================");

        // Ejemplo 1: Agregar baño al paquete
        PaqueteServicioItem item1 = new PaqueteServicioItem();
        item1.setIdPaquete(idPaquete);
        item1.setIdServicio(1); // ID de servicio "Baño completo"
        item1.setCantidad(1);
        
        boolean agregado1 = paqueteDAO.agregarServicioPaquete(item1);
        
        if (agregado1) {
            System.out.println("✅ Baño completo agregado al paquete");
            System.out.println("   Servicio ID: " + item1.getIdServicio());
            System.out.println("   Cantidad: " + item1.getCantidad());
        } else {
            System.out.println("❌ Error al agregar baño al paquete");
        }

        // Ejemplo 2: Agregar corte de pelo
        PaqueteServicioItem item2 = new PaqueteServicioItem();
        item2.setIdPaquete(idPaquete);
        item2.setIdServicio(2); // ID de servicio "Corte de pelo"
        item2.setCantidad(1);
        
        boolean agregado2 = paqueteDAO.agregarServicioPaquete(item2);
        
        if (agregado2) {
            System.out.println("\n✅ Corte de pelo agregado al paquete");
            System.out.println("   Servicio ID: " + item2.getIdServicio());
            System.out.println("   Cantidad: " + item2.getCantidad());
        } else {
            System.out.println("\n❌ Error al agregar corte de pelo al paquete");
        }

        // Ejemplo 3: Agregar limpieza dental (cantidad 2)
        PaqueteServicioItem item3 = new PaqueteServicioItem();
        item3.setIdPaquete(idPaquete);
        item3.setIdServicio(3); // ID de servicio "Limpieza dental"
        item3.setCantidad(2);
        
        boolean agregado3 = paqueteDAO.agregarServicioPaquete(item3);
        
        if (agregado3) {
            System.out.println("\n✅ Limpieza dental agregada al paquete");
            System.out.println("   Servicio ID: " + item3.getIdServicio());
            System.out.println("   Cantidad: " + item3.getCantidad());
        } else {
            System.out.println("\n❌ Error al agregar limpieza dental al paquete");
        }

        // Ejemplo 4: Actualizar cantidad de un servicio existente
        PaqueteServicioItem item4 = new PaqueteServicioItem();
        item4.setIdPaquete(idPaquete);
        item4.setIdServicio(1); // Mismo servicio que item1
        item4.setCantidad(2);   // Cambiar cantidad de 1 a 2
        
        boolean actualizado = paqueteDAO.agregarServicioPaquete(item4);
        
        if (actualizado) {
            System.out.println("\n🔄 Cantidad de baño actualizada en el paquete");
            System.out.println("   Servicio ID: " + item4.getIdServicio());
            System.out.println("   Nueva cantidad: " + item4.getCantidad());
            System.out.println("   ⚠️  Se usó ON DUPLICATE KEY UPDATE");
        } else {
            System.out.println("\n❌ Error al actualizar la cantidad");
        }

        // Resumen del paquete creado
        System.out.println("\n📦 RESUMEN DEL PAQUETE CREADO:");
        System.out.println("==============================");
        System.out.println("Nombre: " + paqueteEjemplo.getNombre());
        System.out.println("Precio total: S/ " + paqueteEjemplo.getPrecioTotal());
        System.out.println("Descripción: " + paqueteEjemplo.getDescripcion());
        System.out.println("Servicios agregados: 4 (con una actualización)");
        
        // Ventajas del ON DUPLICATE KEY UPDATE
        System.out.println("\n🎯 VENTAJAS DEL ON DUPLICATE KEY UPDATE:");
        System.out.println("=======================================");
        System.out.println("🔄 Evita duplicados automáticamente");
        System.out.println("⚡ Actualiza cantidades sin verificar primero");
        System.out.println("💾 Una sola operación para insertar/actualizar");
        System.out.println("🚀 Mejor rendimiento en operaciones repetitivas");
        
        // Próximos pasos recomendados
        System.out.println("\n🚀 PRÓXIMOS PASOS RECOMENDADOS:");
        System.out.println("==============================");
        System.out.println("1. Crear método para consultar servicios de un paquete");
        System.out.println("2. Implementar validación de precios de paquetes");
        System.out.println("3. Crear método para eliminar servicios de paquetes");
        System.out.println("4. Desarrollar reporte de paquetes más populares");
        System.out.println("5. Integrar paquetes en el proceso de facturación");
        
        // Ejemplo de uso en facturación
        System.out.println("\n💰 EJEMPLO DE USO EN FACTURACIÓN:");
        System.out.println("================================");
        System.out.println("Cuando un cliente compra un paquete:");
        System.out.println("1. Se factura el precio total del paquete");
        System.out.println("2. Se registran automáticamente todos los servicios incluidos");
        System.out.println("3. El groomer ve todos los servicios a realizar");
        System.out.println("4. El sistema calcula el tiempo total estimado");
    }
}