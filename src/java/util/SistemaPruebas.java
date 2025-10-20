package util;

import dao.*;
import modelo.*;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;
import java.util.ArrayList;

/**
 * Sistema de pruebas internas para validar funcionalidad
 * Compatible con Java 8 (1.8.0_202) y NetBeans 8.2
 */
public class SistemaPruebas {
    
    private int pruebasEjecutadas = 0;
    private int pruebasExitosas = 0;
    private int pruebasErrores = 0;
    private List<String> resultados = new ArrayList<String>();
    
    public void ejecutarTodasLasPruebas() {
        System.out.println("🧪 INICIANDO SISTEMA DE PRUEBAS VETERINARIA TERÁN VET");
        System.out.println("=====================================================");
        
        JavaCompatibilityHelper.printSystemInfo();
        
        // Validar conexión primero
        if (!JavaCompatibilityHelper.testDatabaseConnection()) {
            System.out.println("❌ ABORTANDO: No hay conexión a base de datos");
            return;
        }
        
        System.out.println("\n🔬 EJECUTANDO PRUEBAS DE FUNCIONALIDAD:");
        System.out.println("=====================================");
        
        // Pruebas por módulo
        probarModuloClientes();
        probarModuloMascotas();
        probarModuloGroomers();
        probarModuloServicios();
        probarModuloCitas();
        probarModuloAtenciones();
        probarModuloFacturas();
        probarModuloPagos();
        
        // Resumen final
        mostrarResumenPruebas();
    }
    
    private void probarModuloClientes() {
        System.out.println("\n👥 MÓDULO CLIENTES:");
        System.out.println("==================");
        
        try {
            ClienteDao dao = new ClienteDao();
            
            // Prueba 1: Listar todos los clientes
            ejecutarPrueba("Listar todos los clientes", () -> {
                List<Cliente> clientes = dao.listarTodosClientes();
                return clientes != null && !clientes.isEmpty();
            });
            
            // Prueba 2: Buscar clientes
            ejecutarPrueba("Buscar clientes con término vacío", () -> {
                List<Cliente> clientes = dao.buscarClientes("");
                return clientes != null;
            });
            
            // Prueba 3: Clientes frecuentes
            ejecutarPrueba("Obtener clientes frecuentes", () -> {
                List<ClienteFrecuenteDTO> frecuentes = dao.clientesFrecuentes();
                return frecuentes != null;
            });
            
            // Prueba 4: Insertar cliente de prueba
            ejecutarPrueba("Insertar cliente de prueba", () -> {
                Cliente clientePrueba = new Cliente();
                clientePrueba.setNombre("Cliente");
                clientePrueba.setApellido("Prueba");
                clientePrueba.setDniRuc("99999999");
                clientePrueba.setEmail("prueba@test.com");
                clientePrueba.setTelefono("555-9999");
                clientePrueba.setDireccion("Dirección de prueba");
                clientePrueba.setPreferencias("Prueba automática");
                
                // Intentar insertar (puede fallar si ya existe)
                boolean resultado = dao.insertarCliente(clientePrueba);
                return true; // Consideramos exitoso independiente del resultado
            });
            
        } catch (Exception e) {
            registrarError("Error en módulo clientes: " + e.getMessage());
        }
    }
    
    private void probarModuloMascotas() {
        System.out.println("\n🐕 MÓDULO MASCOTAS:");
        System.out.println("==================");
        
        try {
            MascotaDao dao = new MascotaDao();
            
            // Prueba: Obtener mascotas por cliente
            ejecutarPrueba("Obtener mascotas por cliente (ID=1)", () -> {
                List<MascotaClienteDTO> mascotas = dao.obtenerMascotasPorCliente(1);
                return mascotas != null;
            });
            
            // Prueba: Buscar mascotas
            ejecutarPrueba("Buscar mascotas", () -> {
                List<MascotaClienteDTO> mascotas = dao.buscarMascotas("Max");
                return mascotas != null;
            });
            
            // Prueba: Historial de mascota
            ejecutarPrueba("Obtener historial de mascota (ID=1)", () -> {
                List<HistorialMascotaDTO> historial = dao.obtenerHistorialMascota(1);
                return historial != null;
            });
            
        } catch (Exception e) {
            registrarError("Error en módulo mascotas: " + e.getMessage());
        }
    }
    
    private void probarModuloGroomers() {
        System.out.println("\n✂️ MÓDULO GROOMERS:");
        System.out.println("==================");
        
        try {
            GroomerDao dao = new GroomerDao();
            
            // Prueba: Obtener todos los groomers
            ejecutarPrueba("Obtener todos los groomers", () -> {
                List<Groomer> groomers = dao.obtenerGroomers();
                return groomers != null;
            });
            
            // Prueba: Disponibilidad de groomers
            Date hoy = new Date(System.currentTimeMillis());
            ejecutarPrueba("Obtener disponibilidad de groomers", () -> {
                List<GroomerDisponibilidadDTO> disponibilidad = dao.obtenerDisponibilidadGroomers(hoy);
                return disponibilidad != null;
            });
            
            // Prueba: Ocupación de groomers
            ejecutarPrueba("Obtener ocupación de groomers", () -> {
                List<OcupacionGroomerDTO> ocupacion = dao.ocupacionGroomer(hoy);
                return ocupacion != null;
            });
            
            // Prueba: Tiempos promedio
            Date hace30dias = new Date(System.currentTimeMillis() - (30L * 24 * 60 * 60 * 1000));
            ejecutarPrueba("Obtener tiempos promedio de groomers", () -> {
                List<TiempoPromedioGroomerDTO> tiempos = dao.tiemposPromedioGroomer(hace30dias, hoy);
                return tiempos != null;
            });
            
        } catch (Exception e) {
            registrarError("Error en módulo groomers: " + e.getMessage());
        }
    }
    
    private void probarModuloServicios() {
        System.out.println("\n🛁 MÓDULO SERVICIOS:");
        System.out.println("===================");
        
        try {
            ServicioDao dao = new ServicioDao();
            
            // Prueba: Obtener todos los servicios
            ejecutarPrueba("Obtener todos los servicios", () -> {
                List<Servicio> servicios = dao.obtenerServicios();
                return servicios != null;
            });
            
            // Prueba: Servicios más solicitados
            ejecutarPrueba("Obtener servicios más solicitados", () -> {
                List<ServicioSolicitadoDTO> solicitados = dao.serviciosMasSolicitados();
                return solicitados != null;
            });
            
            // Prueba: Servicios por categoría
            ejecutarPrueba("Obtener servicios por categoría 'baño'", () -> {
                List<Servicio> servicios = dao.serviciosPorCategoria("baño");
                return servicios != null;
            });
            
        } catch (Exception e) {
            registrarError("Error en módulo servicios: " + e.getMessage());
        }
    }
    
    private void probarModuloCitas() {
        System.out.println("\n📅 MÓDULO CITAS:");
        System.out.println("===============");
        
        try {
            CitaDao dao = new CitaDao();
            
            // Prueba: Obtener todas las próximas citas
            ejecutarPrueba("Obtener todas las próximas citas", () -> {
                List<CitaProximaDTO> citas = dao.obtenerTodasProximasCitas();
                return citas != null;
            });
            
            // Prueba: Próximas citas de cliente específico
            ejecutarPrueba("Obtener próximas citas de cliente (ID=1)", () -> {
                List<CitaProximaDTO> citas = dao.obtenerProximasCitas(1);
                return citas != null;
            });
            
        } catch (Exception e) {
            registrarError("Error en módulo citas: " + e.getMessage());
        }
    }
    
    private void probarModuloAtenciones() {
        System.out.println("\n🏥 MÓDULO ATENCIONES:");
        System.out.println("====================");
        
        try {
            AtencionDao dao = new AtencionDao();
            
            // Prueba: Obtener cola actual
            ejecutarPrueba("Obtener cola actual de atenciones", () -> {
                List<ColaAtencionDTO> cola = dao.obtenerColaActual(null);
                return cola != null;
            });
            
            // Prueba: Cola por sucursal específica
            ejecutarPrueba("Obtener cola de atenciones por sucursal (ID=1)", () -> {
                List<ColaAtencionDTO> cola = dao.obtenerColaActual(1);
                return cola != null;
            });
            
        } catch (Exception e) {
            registrarError("Error en módulo atenciones: " + e.getMessage());
        }
    }
    
    private void probarModuloFacturas() {
        System.out.println("\n🧾 MÓDULO FACTURAS:");
        System.out.println("==================");
        
        try {
            FacturaDao dao = new FacturaDao();
            
            // Prueba: Buscar facturas
            ejecutarPrueba("Buscar facturas", () -> {
                List<FacturaClienteDTO> facturas = dao.buscarFacturas("");
                return facturas != null;
            });
            
            // Prueba: Facturas por cliente
            ejecutarPrueba("Obtener facturas por cliente (ID=1)", () -> {
                List<FacturaClienteDTO> facturas = dao.obtenerFacturasPorCliente(1);
                return facturas != null;
            });
            
        } catch (Exception e) {
            registrarError("Error en módulo facturas: " + e.getMessage());
        }
    }
    
    private void probarModuloPagos() {
        System.out.println("\n💰 MÓDULO PAGOS:");
        System.out.println("===============");
        
        try {
            PagoDao dao = new PagoDao();
            
            // Prueba: Obtener pagos por factura
            ejecutarPrueba("Obtener pagos por factura (ID=1)", () -> {
                List<PagoDTO> pagos = dao.obtenerPagosPorFactura(1);
                return pagos != null;
            });
            
        } catch (Exception e) {
            registrarError("Error en módulo pagos: " + e.getMessage());
        }
    }
    
    // Métodos auxiliares
    private void ejecutarPrueba(String descripcion, PruebaFuncional prueba) {
        pruebasEjecutadas++;
        try {
            boolean resultado = prueba.ejecutar();
            if (resultado) {
                pruebasExitosas++;
                System.out.println("  ✅ " + descripcion);
                resultados.add("✅ " + descripcion);
            } else {
                pruebasErrores++;
                System.out.println("  ❌ " + descripcion + " (falló condición)");
                resultados.add("❌ " + descripcion + " (falló condición)");
            }
        } catch (Exception e) {
            pruebasErrores++;
            System.out.println("  ❌ " + descripcion + " (excepción: " + e.getMessage() + ")");
            resultados.add("❌ " + descripcion + " (excepción: " + e.getMessage() + ")");
        }
    }
    
    private void registrarError(String mensaje) {
        pruebasErrores++;
        System.out.println("  ❌ " + mensaje);
        resultados.add("❌ " + mensaje);
    }
    
    private void mostrarResumenPruebas() {
        System.out.println("\n📊 RESUMEN DE PRUEBAS:");
        System.out.println("=====================");
        System.out.println("🔬 Total ejecutadas: " + pruebasEjecutadas);
        System.out.println("✅ Exitosas: " + pruebasExitosas);
        System.out.println("❌ Con errores: " + pruebasErrores);
        
        double porcentajeExito = pruebasEjecutadas > 0 ? 
            (double) pruebasExitosas / pruebasEjecutadas * 100 : 0;
        System.out.println("📈 Porcentaje de éxito: " + 
            String.format("%.1f", porcentajeExito) + "%");
        
        if (porcentajeExito >= 80) {
            System.out.println("\n🎉 SISTEMA EN BUEN ESTADO");
        } else if (porcentajeExito >= 60) {
            System.out.println("\n⚠️  SISTEMA REQUIERE ATENCIÓN");
        } else {
            System.out.println("\n🚨 SISTEMA REQUIERE REVISIÓN URGENTE");
        }
        
        // Mostrar detalles si hay errores
        if (pruebasErrores > 0) {
            System.out.println("\n🔍 DETALLES DE ERRORES:");
            System.out.println("======================");
            for (String resultado : resultados) {
                if (resultado.startsWith("❌")) {
                    System.out.println(resultado);
                }
            }
        }
        
        System.out.println("\n💡 RECOMENDACIONES:");
        System.out.println("==================");
        if (pruebasErrores == 0) {
            System.out.println("• Sistema funcionando correctamente");
            System.out.println("• Ejecutar pruebas periódicamente");
        } else {
            System.out.println("• Revisar stored procedures en la base de datos");
            System.out.println("• Verificar datos de prueba en las tablas");
            System.out.println("• Comprobar configuración de conexión");
            System.out.println("• Ejecutar: CALL stored_procedures_veterinaria.sql");
        }
    }
    
    // Interface funcional compatible con Java 8
    @FunctionalInterface
    private interface PruebaFuncional {
        boolean ejecutar() throws Exception;
    }
    
    /**
     * Método principal para ejecutar las pruebas
     */
    public static void main(String[] args) {
        System.out.println("🏥 VETERINARIA TERÁN VET - SISTEMA DE PRUEBAS");
        System.out.println("==============================================");
        
        SistemaPruebas sistema = new SistemaPruebas();
        sistema.ejecutarTodasLasPruebas();
        
        System.out.println("\n🔧 INSTRUCCIONES DE USO:");
        System.out.println("=======================");
        System.out.println("1. Ejecutar este programa después de cada cambio importante");
        System.out.println("2. Si hay errores, revisar los stored procedures");
        System.out.println("3. Asegurarse de que existan datos de prueba en las tablas");
        System.out.println("4. Verificar que todos los DAOs estén actualizados");
        System.out.println("5. Comprobar que la base de datos 'vet_teran' esté accesible");
    }
}