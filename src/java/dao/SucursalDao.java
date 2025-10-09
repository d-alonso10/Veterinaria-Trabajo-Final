package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.Sucursal;

public class SucursalDao {
    
    private Connection con;
    private CallableStatement cstmt;
    private ResultSet rs;
    private String url = "jdbc:mysql://localhost/vet_teran";
    private String user = "root";
    private String pass = "";

    public int insertarSucursal(Sucursal sucursal) {
        int idSucursal = -1;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);
            
            cstmt = con.prepareCall("{CALL sp_InsertarSucursal(?, ?, ?)}");
            
            cstmt.setString(1, sucursal.getNombre());
            cstmt.setString(2, sucursal.getDireccion());
            cstmt.setString(3, sucursal.getTelefono());
            
            // Ejecutar y obtener el resultado
            boolean tieneResultados = cstmt.execute();
            
            if (tieneResultados) {
                rs = cstmt.getResultSet();
                if (rs.next()) {
                    idSucursal = rs.getInt("id_sucursal");
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
        return idSucursal;
    }

    public List<Sucursal> obtenerSucursales() {
        List<Sucursal> sucursales = new ArrayList<>();
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_ObtenerSucursales()}");
            
            rs = cstmt.executeQuery();

            while (rs.next()) {
                Sucursal sucursal = new Sucursal();
                sucursal.setIdSucursal(rs.getInt("id_sucursal"));
                sucursal.setNombre(rs.getString("nombre"));
                sucursal.setDireccion(rs.getString("direccion"));
                sucursal.setTelefono(rs.getString("telefono"));
                sucursal.setCreatedAt(rs.getTimestamp("created_at"));
                
                sucursales.add(sucursal);
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
        return sucursales;
    }

    // NUEVO MÉTODO: Actualizar sucursal
    public boolean actualizarSucursal(Sucursal sucursal) {
        boolean exito = false;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);
            
            cstmt = con.prepareCall("{CALL sp_ActualizarSucursal(?, ?, ?, ?)}");
            
            cstmt.setInt(1, sucursal.getIdSucursal());
            cstmt.setString(2, sucursal.getNombre());
            cstmt.setString(3, sucursal.getDireccion());
            cstmt.setString(4, sucursal.getTelefono());
            
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
        SucursalDao sucursalDAO = new SucursalDao();

        System.out.println("=== Probando sp_ActualizarSucursal ===");
        
        // Primero obtenemos las sucursales existentes para demostrar el cambio
        System.out.println("\n--- Sucursales antes de la actualización ---");
        List<Sucursal> sucursalesAntes = sucursalDAO.obtenerSucursales();
        
        if (sucursalesAntes.isEmpty()) {
            System.out.println("No hay sucursales para actualizar. Creando una de ejemplo...");
            
            // Crear una sucursal de ejemplo
            Sucursal nuevaSucursal = new Sucursal();
            nuevaSucursal.setNombre("Sucursal Ejemplo");
            nuevaSucursal.setDireccion("Av. Ejemplo 123");
            nuevaSucursal.setTelefono("(01) 111-1111");
            
            int idNueva = sucursalDAO.insertarSucursal(nuevaSucursal);
            if (idNueva != -1) {
                System.out.println("✅ Sucursal de ejemplo creada con ID: " + idNueva);
                sucursalesAntes = sucursalDAO.obtenerSucursales();
            }
        }
        
        if (!sucursalesAntes.isEmpty()) {
            // Tomar la primera sucursal para actualizar
            Sucursal sucursalAActualizar = sucursalesAntes.get(0);
            
            System.out.println("\n📝 ACTUALIZANDO SUCURSAL:");
            System.out.println("ID: " + sucursalAActualizar.getIdSucursal());
            System.out.println("Nombre actual: " + sucursalAActualizar.getNombre());
            System.out.println("Dirección actual: " + sucursalAActualizar.getDireccion());
            System.out.println("Teléfono actual: " + sucursalAActualizar.getTelefono());
            
            // Simular cambios
            Sucursal sucursalActualizada = new Sucursal();
            sucursalActualizada.setIdSucursal(sucursalAActualizar.getIdSucursal());
            sucursalActualizada.setNombre(sucursalAActualizar.getNombre() + " - Renovada");
            sucursalActualizada.setDireccion("Nueva dirección: " + sucursalAActualizar.getDireccion());
            sucursalActualizada.setTelefono("(01) 999-9999");
            
            boolean actualizado = sucursalDAO.actualizarSucursal(sucursalActualizada);
            
            if (actualizado) {
                System.out.println("\n✅ Sucursal actualizada correctamente");
                System.out.println("Nuevos datos:");
                System.out.println("Nombre: " + sucursalActualizada.getNombre());
                System.out.println("Dirección: " + sucursalActualizada.getDireccion());
                System.out.println("Teléfono: " + sucursalActualizada.getTelefono());
                
                // Verificar los cambios
                System.out.println("\n--- Verificando cambios ---");
                List<Sucursal> sucursalesDespues = sucursalDAO.obtenerSucursales();
                Sucursal sucursalVerificada = sucursalesDespues.stream()
                    .filter(s -> s.getIdSucursal() == sucursalActualizada.getIdSucursal())
                    .findFirst()
                    .orElse(null);
                
                if (sucursalVerificada != null) {
                    System.out.println("✅ Cambios confirmados en la base de datos");
                    System.out.println("Nombre en BD: " + sucursalVerificada.getNombre());
                    System.out.println("Dirección en BD: " + sucursalVerificada.getDireccion());
                    System.out.println("Teléfono en BD: " + sucursalVerificada.getTelefono());
                }
            } else {
                System.out.println("\n❌ Error al actualizar la sucursal");
                System.out.println("Posibles causas:");
                System.out.println("- La sucursal no existe");
                System.out.println("- ID de sucursal incorrecto");
                System.out.println("- Error de conexión a la base de datos");
            }
        }

        // Ejemplos de casos de uso reales
        System.out.println("\n🎯 CASOS DE USO REALES PARA ACTUALIZAR SUCURSALES:");
        System.out.println("=================================================");
        
        System.out.println("\n1. 📍 CAMBIO DE DIRECCIÓN:");
        System.out.println("   - Mudanza a local más grande");
        System.out.println("   - Mejor ubicación estratégica");
        System.out.println("   - Expansión a nuevo local");
        
        System.out.println("\n2. 📞 ACTUALIZACIÓN DE CONTACTO:");
        System.out.println("   - Cambio de número telefónico");
        System.out.println("   - Adición de nuevas líneas");
        System.out.println("   - Corrección de datos erróneos");
        
        System.out.println("\n3. 🏷️  REBRANDING:");
        System.out.println("   - Cambio de nombre de sucursal");
        System.out.println("   - Actualización de imagen corporativa");
        System.out.println("   - Especialización de servicios");
        
        System.out.println("\n4. 🔄 FUSIÓN O REORGANIZACIÓN:");
        System.out.println("   - Fusión de sucursales cercanas");
        System.out.println("   - Reorganización de la red de sucursales");
        System.out.println("   - Cierre temporal por remodelación");

        // Buenas prácticas
        System.out.println("\n💡 BUENAS PRÁCTICAS:");
        System.out.println("===================");
        System.out.println("✅ Siempre validar que la sucursal existe antes de actualizar");
        System.out.println("✅ Notificar a clientes sobre cambios importantes");
        System.out.println("✅ Actualizar información en todos los sistemas relacionados");
        System.out.println("✅ Mantener backup de datos anteriores");
        System.out.println("✅ Registrar en audit_log los cambios significativos");
        
        // Integración con auditoría
        System.out.println("\n🔍 INTEGRACIÓN CON AUDITORÍA:");
        System.out.println("============================");
        System.out.println("Cada actualización debería generar un registro en audit_log:");
        System.out.println("- Entidad: 'sucursal'");
        System.out.println("- Entidad_id: ID de la sucursal");
        System.out.println("- Acción: 'UPDATE'");
        System.out.println("- Antes/Después: Datos anteriores y nuevos");

        // Flujo completo CRUD
        System.out.println("\n🔄 FLUJO COMPLETO CRUD SUCURSALES:");
        System.out.println("================================");
        System.out.println("CREATE → sp_InsertarSucursal");
        System.out.println("READ   → sp_ObtenerSucursales");
        System.out.println("UPDATE → sp_ActualizarSucursal");
        System.out.println("DELETE → (Por implementar si es necesario)");
    }
    
    private static String analizarZona(String direccion) {
        if (direccion == null) return "";
        
        direccion = direccion.toLowerCase();
        
        if (direccion.contains("miraflores")) return "Miraflores";
        if (direccion.contains("surco")) return "Surco";
        if (direccion.contains("san isidro")) return "San Isidro";
        if (direccion.contains("san miguel")) return "San Miguel";
        if (direccion.contains("la molina")) return "La Molina";
        if (direccion.contains("barranco")) return "Barranco";
        if (direccion.contains("magdalena")) return "Magdalena";
        if (direccion.contains("pueblo libre")) return "Pueblo Libre";
        
        return "Otra zona";
    }
}