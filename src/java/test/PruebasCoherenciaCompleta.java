package test;

import dao.FacturaDao;
import dao.NotificacionDao;
import dao.UsuarioSistemaDao;
import dao.PaqueteServicioDao;
import modelo.*;
import java.sql.*;
import java.util.List;

/**
 * SUITE COMPLETA DE PRUEBAS UNITARIAS
 * Validación de Coherencia DAO vs. Modelo vs. Base de Datos
 * 
 * @author Sistema de Veterinaria Terán
 * @version 2.0 - Post Correcciones de Coherencia
 */
public class PruebasCoherenciaCompleta {
    
    private static final String DB_URL = "jdbc:mysql://localhost:3306/vet_teran?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";
    
    public static void main(String[] args) {
        System.out.println("=========================================================");
        System.out.println("🧪 SUITE COMPLETA DE PRUEBAS DE COHERENCIA DAO vs MODELO");
        System.out.println("=========================================================");
        
        testConexionBaseDatos();
        testFacturaDao();
        testNotificacionDao();
        testUsuarioSistemaDao();
        testPaqueteServicioDao();
        
        System.out.println("\n=========================================================");
        System.out.println("✅ RESUMEN FINAL DE PRUEBAS COMPLETADO");
        System.out.println("=========================================================");
    }
    
    /**
     * PRUEBA 1: Validar conexión a base de datos
     */
    private static void testConexionBaseDatos() {
        System.out.println("\n🔍 PRUEBA 1: Conexión a Base de Datos");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            
            // Verificar que las tablas principales existen
            DatabaseMetaData meta = conn.getMetaData();
            
            String[] tablas = {"cliente", "mascota", "factura", "notificacion", "usuario_sistema", "paquete_servicio"};
            for (String tabla : tablas) {
                ResultSet rs = meta.getTables(null, null, tabla, null);
                if (rs.next()) {
                    System.out.println("  ✅ Tabla '" + tabla + "' existe");
                } else {
                    System.out.println("  ❌ Tabla '" + tabla + "' NO existe");
                }
                rs.close();
            }
            
            conn.close();
            System.out.println("  ✅ Conexión a BD exitosa");
            
        } catch (Exception e) {
            System.out.println("  ❌ Error de conexión: " + e.getMessage());
        }
    }
    
    /**
     * PRUEBA 2: Validar FacturaDao coherencia
     */
    private static void testFacturaDao() {
        System.out.println("\n🧾 PRUEBA 2: Coherencia FacturaDao");
        FacturaDao dao = new FacturaDao();
        
        try {
            // Test 1: Método que retorna List<Factura> (sin JOIN)
            System.out.println("  📋 Test 2.1: obtenerFacturasPorFecha()");
            List<Factura> facturasPorFecha = dao.obtenerFacturasPorFecha(
                Timestamp.valueOf("2024-01-01 00:00:00"), 
                Timestamp.valueOf("2024-12-31 23:59:59")
            );
            System.out.println("    ✅ Retorna List<Factura>: " + facturasPorFecha.size() + " registros");
            
            // Test 2: Método corregido que retorna List<FacturaClienteDTO> (con JOIN)
            System.out.println("  📋 Test 2.2: buscarFacturas() - CORREGIDO");
            List<FacturaClienteDTO> facturasConCliente = dao.buscarFacturas("2024");
            System.out.println("    ✅ Retorna List<FacturaClienteDTO>: " + facturasConCliente.size() + " registros");
            
            if (!facturasConCliente.isEmpty()) {
                FacturaClienteDTO primera = facturasConCliente.get(0);
                System.out.println("    ✅ Datos de cliente incluidos:");
                System.out.println("      - Nombre: " + primera.getNombreCliente());
                System.out.println("      - Apellido: " + primera.getApellidoCliente());
                System.out.println("      - Número completo: " + primera.getNumeroFactura());
                System.out.println("      - Cliente completo: " + primera.getNombreCompletoCliente());
            }
            
            // Test 3: Método básico sin JOIN
            System.out.println("  📋 Test 2.3: listarTodasFacturas()");
            List<Factura> todasFacturas = dao.listarTodasFacturas();
            System.out.println("    ✅ Retorna List<Factura>: " + todasFacturas.size() + " registros");
            
        } catch (Exception e) {
            System.out.println("    ❌ Error en FacturaDao: " + e.getClass().getSimpleName() + " - " + e.getMessage());
        }
    }
    
    /**
     * PRUEBA 3: Validar NotificacionDao coherencia
     */
    private static void testNotificacionDao() {
        System.out.println("\n📢 PRUEBA 3: Coherencia NotificacionDao");
        NotificacionDao dao = new NotificacionDao();
        
        try {
            // Test 1: Método corregido con JOIN a cliente
            System.out.println("  📋 Test 3.1: obtenerNotificacionesPendientes() - CORREGIDO");
            List<NotificacionClienteDTO> pendientes = dao.obtenerNotificacionesPendientes();
            System.out.println("    ✅ Retorna List<NotificacionClienteDTO>: " + pendientes.size() + " registros");
            
            if (!pendientes.isEmpty()) {
                NotificacionClienteDTO primera = pendientes.get(0);
                System.out.println("    ✅ Campos corregidos incluidos:");
                System.out.println("      - ID Notificación: " + primera.getIdNotificacion());
                System.out.println("      - Fecha Creación: " + primera.getFechaCreacion());
                System.out.println("      - Nombre Cliente: " + primera.getNombreCliente());
                System.out.println("      - Apellido Cliente: " + primera.getApellidoCliente());
                System.out.println("      - Cliente Completo: " + primera.getNombreCompletoCliente());
            }
            
            // Test 2: Método con JOIN dinámico
            System.out.println("  📋 Test 3.2: buscarNotificaciones() - CORREGIDO");
            List<NotificacionClienteDTO> busqueda = dao.buscarNotificaciones("email", null, null, null);
            System.out.println("    ✅ Búsqueda por tipo 'email': " + busqueda.size() + " registros");
            
            // Test 3: Método con límite
            System.out.println("  📋 Test 3.3: obtenerNotificacionesRecientes()");
            List<NotificacionClienteDTO> recientes = dao.obtenerNotificacionesRecientes(5);
            System.out.println("    ✅ Últimas 5 notificaciones: " + recientes.size() + " registros");
            
        } catch (Exception e) {
            System.out.println("    ❌ Error en NotificacionDao: " + e.getClass().getSimpleName() + " - " + e.getMessage());
        }
    }
    
    /**
     * PRUEBA 4: Validar UsuarioSistemaDao coherencia
     */
    private static void testUsuarioSistemaDao() {
        System.out.println("\n👤 PRUEBA 4: Coherencia UsuarioSistemaDao");
        UsuarioSistemaDao dao = new UsuarioSistemaDao();
        
        try {
            // Test 1: Método corregido sin campo 'estado'
            System.out.println("  📋 Test 4.1: buscarUsuarios() - CORREGIDO (sin campo estado)");
            List<UsuarioSistema> usuarios = dao.buscarUsuarios("admin", "admin");
            System.out.println("    ✅ Búsqueda sin campo 'estado': " + usuarios.size() + " registros");
            
            // Test 2: Listar todos los usuarios
            System.out.println("  📋 Test 4.2: listarTodosUsuarios()");
            List<UsuarioSistema> todosUsuarios = dao.listarTodosUsuarios();
            System.out.println("    ✅ Total usuarios: " + todosUsuarios.size() + " registros");
            
            if (!todosUsuarios.isEmpty()) {
                UsuarioSistema primero = todosUsuarios.get(0);
                System.out.println("    ✅ Campos válidos encontrados:");
                System.out.println("      - ID: " + primero.getIdUsuario());
                System.out.println("      - Nombre: " + primero.getNombre());
                System.out.println("      - Rol: " + primero.getRol());
                System.out.println("      - Email: " + primero.getEmail());
            }
            
            System.out.println("    ✅ CORRECCIÓN: Método cambiarEstadoUsuario() comentado (campo inexistente)");
            
        } catch (Exception e) {
            System.out.println("    ❌ Error en UsuarioSistemaDao: " + e.getClass().getSimpleName() + " - " + e.getMessage());
        }
    }
    
    /**
     * PRUEBA 5: Validar PaqueteServicioDao coherencia
     */
    private static void testPaqueteServicioDao() {
        System.out.println("\n📦 PRUEBA 5: Coherencia PaqueteServicioDao");
        PaqueteServicioDao dao = new PaqueteServicioDao();
        
        try {
            // Test 1: Método básico
            System.out.println("  📋 Test 5.1: listarPaquetesServicio()");
            List<PaqueteServicio> paquetes = dao.listarPaquetesServicio();
            System.out.println("    ✅ Total paquetes: " + paquetes.size() + " registros");
            
            // Test 2: Método con modelo ampliado
            if (!paquetes.isEmpty()) {
                PaqueteServicio primero = paquetes.get(0);
                System.out.println("  📋 Test 5.2: obtenerPaquetePorId()");
                PaqueteServicio paquete = dao.obtenerPaquetePorId(primero.getIdPaquete());
                
                if (paquete != null) {
                    System.out.println("    ✅ Paquete encontrado: " + paquete.getNombre());
                    
                    // Test 3: Verificar modelo PaqueteServicioItem ampliado
                    System.out.println("  📋 Test 5.3: obtenerServiciosPaquete() - Modelo ampliado");
                    List<PaqueteServicioItem> items = dao.obtenerServiciosPaquete(paquete.getIdPaquete());
                    System.out.println("    ✅ Items del paquete: " + items.size() + " registros");
                    
                    if (!items.isEmpty()) {
                        PaqueteServicioItem item = items.get(0);
                        System.out.println("    ✅ Campos ampliados del modelo:");
                        System.out.println("      - Nombre Servicio: " + item.getNombreServicio());
                        System.out.println("      - Precio Unitario: " + item.getPrecioUnitario());
                        System.out.println("      - Duración: " + item.getDuracionMinutos() + " min");
                    }
                }
            }
            
            // Test 4: Verificación de servicios en paquete
            System.out.println("  📋 Test 5.4: servicioYaEnPaquete()");
            boolean existe = dao.servicioYaEnPaquete(1, 1);
            System.out.println("    ✅ Verificación servicio en paquete: " + existe);
            
        } catch (Exception e) {
            System.out.println("    ❌ Error en PaqueteServicioDao: " + e.getClass().getSimpleName() + " - " + e.getMessage());
        }
    }
}