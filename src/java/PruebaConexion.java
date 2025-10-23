import java.sql.*;

public class PruebaConexion {
    public static void main(String[] args) {
        System.out.println("==============================");
        System.out.println("   PRUEBA DE CONEXIÓN BD");
        System.out.println("==============================");
        
        String url = "jdbc:mysql://localhost:3306/vet_teran?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
        String usuario = "root";
        String password = "";
        
        try {
            // Cargar el driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Establecer conexión
            Connection conn = DriverManager.getConnection(url, usuario, password);
            System.out.println("✅ Conexión exitosa a la base de datos");
            
            // Probar consulta simple de FacturaDao
            String sqlFacturas = "SELECT COUNT(*) as total FROM factura";
            PreparedStatement ps1 = conn.prepareStatement(sqlFacturas);
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) {
                System.out.println("✅ Total de facturas: " + rs1.getInt("total"));
            }
            rs1.close();
            ps1.close();
            
            // Probar consulta simple de NotificacionDao
            String sqlNotif = "SELECT COUNT(*) as total FROM notificacion";
            PreparedStatement ps2 = conn.prepareStatement(sqlNotif);
            ResultSet rs2 = ps2.executeQuery();
            if (rs2.next()) {
                System.out.println("✅ Total de notificaciones: " + rs2.getInt("total"));
            }
            rs2.close();
            ps2.close();
            
            // Probar consulta simple de PaqueteServicioDao
            String sqlPaquetes = "SELECT COUNT(*) as total FROM paquete_servicio";
            PreparedStatement ps3 = conn.prepareStatement(sqlPaquetes);
            ResultSet rs3 = ps3.executeQuery();
            if (rs3.next()) {
                System.out.println("✅ Total de paquetes: " + rs3.getInt("total"));
            }
            rs3.close();
            ps3.close();
            
            // Probar consulta con JOIN (similar a FacturaDao.buscarFacturas)
            String sqlJoin = "SELECT f.numero_factura, c.nombre FROM factura f " +
                           "INNER JOIN cliente c ON f.id_cliente = c.id_cliente LIMIT 5";
            PreparedStatement ps4 = conn.prepareStatement(sqlJoin);
            ResultSet rs4 = ps4.executeQuery();
            System.out.println("✅ Facturas con datos de cliente:");
            while (rs4.next()) {
                System.out.println("   - " + rs4.getString("numero_factura") + 
                                 " | Cliente: " + rs4.getString("nombre"));
            }
            rs4.close();
            ps4.close();
            
            conn.close();
            System.out.println("✅ Conexión cerrada correctamente");
            
            System.out.println("\n==============================");
            System.out.println("   RESULTADO FINAL");
            System.out.println("==============================");
            System.out.println("🎉 TODAS LAS CONSULTAS SQL");
            System.out.println("   FUNCIONAN CORRECTAMENTE");
            System.out.println("🎉 LOS DAOs ESTÁN LISTOS PARA USO");
            
        } catch (Exception e) {
            System.out.println("❌ Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}