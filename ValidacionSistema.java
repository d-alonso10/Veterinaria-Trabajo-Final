import java.io.*;
import java.util.*;

/**
 * Script de validación del sistema veterinario
 * Verifica la conectividad entre JSPs, Controladores y DAOs
 * Compatible con Java 8
 */
public class ValidacionSistema {
    
    private static final String BASE_PATH = "c:\\Users\\x13924\\Documents\\proyectos\\Veterinaria-Trabajo-Final\\";
    private static int totalTests = 0;
    private static int passedTests = 0;
    private static List<String> issues = new ArrayList<>();
    
    public static void main(String[] args) {
        System.out.println("=================================================");
        System.out.println("🔍 VALIDACIÓN COMPLETA DEL SISTEMA VETERINARIO");
        System.out.println("=================================================");
        System.out.println("📅 Fecha: " + new Date());
        System.out.println("☕ Validando compatibilidad Java 8...\n");
        
        try {
            // 1. Verificar estructura de archivos
            verificarEstructuraArchivos();
            
            // 2. Verificar conectividad JSP-Controlador
            verificarConectividadJSPControlador();
            
            // 3. Verificar stored procedures
            verificarStoredProcedures();
            
            // 4. Verificar compatibilidad Java 8
            verificarCompatibilidadJava8();
            
            // 5. Generar reporte final
            generarReporteFinal();
            
        } catch (Exception e) {
            System.err.println("❌ Error durante la validación: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private static void verificarEstructuraArchivos() {
        System.out.println("📁 VERIFICANDO ESTRUCTURA DE ARCHIVOS");
        System.out.println("=====================================");
        
        // Verificar controladores principales
        String[] controladoresRequeridos = {
            "AtencionControlador.java",
            "ClienteControlador.java", 
            "CitaControlador.java",
            "FacturaControlador.java",
            "MascotaControlador.java",
            "GroomerControlador.java",
            "ServicioControlador.java",
            "NotificacionControlador.java",
            "PaqueteServicioControlador.java",
            "SucursalControlador.java",
            "UsuarioSistemaControlador.java",
            "ReporteControlador.java",
            "DashboardControlador.java",
            "AuditControlador.java",
            "UtilidadesControlador.java",
            "ConfiguracionControlador.java",
            "DetalleServicioControlador.java"
        };
        
        for (String controlador : controladoresRequeridos) {
            verificarArchivo("src/java/control/" + controlador, "Controlador");
        }
        
        // Verificar JSPs principales
        String[] jspsRequeridos = {
            "Dashboard.jsp",
            "Menu.jsp",
            "BuscarClientes.jsp",
            "BuscarFacturas.jsp", 
            "BuscarMascotas.jsp",
            "CrearCita.jsp",
            "CrearFactura.jsp",
            "CrearNotificacion.jsp",
            "CrearPaqueteServicio.jsp",
            "CrearPromocion.jsp",
            "CrearUsuario.jsp",
            "ListaClientes.jsp",
            "ListaFacturas.jsp",
            "ListaMascotas.jsp",
            "ColaAtencion.jsp"
        };
        
        for (String jsp : jspsRequeridos) {
            verificarArchivo("web/" + jsp, "JSP");
        }
        
        // Verificar archivos de configuración
        verificarArchivo("web/stored_procedures_veterinaria.sql", "Stored Procedures");
        verificarArchivo("src/java/util/JavaCompatibilityHelper.java", "Utilidad Java 8");
        verificarArchivo("src/java/util/SistemaPruebas.java", "Sistema de Pruebas");
        
        System.out.println();
    }
    
    private static void verificarConectividadJSPControlador() {
        System.out.println("🔗 VERIFICANDO CONECTIVIDAD JSP-CONTROLADOR");
        System.out.println("==========================================");
        
        // Mapeo de JSPs con sus controladores
        Map<String, String> jspsControladores = new HashMap<>();
        jspsControladores.put("BuscarClientes.jsp", "ClienteControlador");
        jspsControladores.put("BuscarFacturas.jsp", "FacturaControlador");
        jspsControladores.put("BuscarMascotas.jsp", "MascotaControlador");
        jspsControladores.put("CrearCita.jsp", "CitaControlador");
        jspsControladores.put("CrearFactura.jsp", "FacturaControlador");
        jspsControladores.put("CrearNotificacion.jsp", "NotificacionControlador");
        jspsControladores.put("CrearPaqueteServicio.jsp", "PaqueteServicioControlador");
        jspsControladores.put("CrearUsuario.jsp", "UsuarioSistemaControlador");
        jspsControladores.put("Dashboard.jsp", "DashboardControlador");
        jspsControladores.put("ColaAtencion.jsp", "AtencionControlador");
        
        for (Map.Entry<String, String> entry : jspsControladores.entrySet()) {
            String jsp = entry.getKey();
            String controlador = entry.getValue();
            verificarConexionJSP(jsp, controlador);
        }
        
        System.out.println();
    }
    
    private static void verificarStoredProcedures() {
        System.out.println("🗄️ VERIFICANDO STORED PROCEDURES");
        System.out.println("================================");
        
        String sqlFile = BASE_PATH + "web/stored_procedures_veterinaria.sql";
        
        try {
            File archivo = new File(sqlFile);
            if (!archivo.exists()) {
                reportarIssue("❌ Archivo de stored procedures no encontrado: " + sqlFile);
                return;
            }
            
            BufferedReader reader = new BufferedReader(new FileReader(archivo));
            String linea;
            int totalProcedures = 0;
            List<String> proceduresEncontrados = new ArrayList<>();
            
            while ((linea = reader.readLine()) != null) {
                if (linea.trim().startsWith("CREATE PROCEDURE") || linea.trim().startsWith("DELIMITER") && linea.contains("CREATE PROCEDURE")) {
                    totalProcedures++;
                    // Extraer nombre del procedimiento
                    if (linea.contains("sp_")) {
                        String procedureName = linea.substring(linea.indexOf("sp_"));
                        procedureName = procedureName.split("\\(")[0].trim();
                        proceduresEncontrados.add(procedureName);
                    }
                }
            }
            reader.close();
            
            reportarExito("✅ Archivo SQL encontrado - Tamaño: " + (archivo.length() / 1024) + "KB");
            reportarExito("✅ Stored procedures detectados: " + totalProcedures);
            
            // Verificar procedures específicos
            String[] proceduresRequeridos = {
                "sp_CrearAtencionWalkIn",
                "sp_ActualizarEstadoAtencion", 
                "sp_ObtenerColaActual",
                "sp_CrearCita",
                "sp_BuscarClientes",
                "sp_BuscarFacturas",
                "sp_CrearFactura"
            };
            
            for (String proc : proceduresRequeridos) {
                boolean encontrado = false;
                for (String procEncontrado : proceduresEncontrados) {
                    if (procEncontrado.contains(proc)) {
                        encontrado = true;
                        break;
                    }
                }
                
                if (encontrado) {
                    reportarExito("✅ " + proc + " - Definido");
                } else {
                    reportarIssue("❌ " + proc + " - NO encontrado");
                }
            }
            
        } catch (IOException e) {
            reportarIssue("❌ Error leyendo stored procedures: " + e.getMessage());
        }
        
        System.out.println();
    }
    
    private static void verificarCompatibilidadJava8() {
        System.out.println("☕ VERIFICANDO COMPATIBILIDAD JAVA 8");
        System.out.println("===================================");
        
        // Verificar JavaCompatibilityHelper
        String helperFile = BASE_PATH + "src/java/util/JavaCompatibilityHelper.java";
        
        try {
            File archivo = new File(helperFile);
            if (!archivo.exists()) {
                reportarIssue("❌ JavaCompatibilityHelper.java no encontrado");
                return;
            }
            
            BufferedReader reader = new BufferedReader(new FileReader(archivo));
            String contenido = "";
            String linea;
            
            while ((linea = reader.readLine()) != null) {
                contenido += linea + "\n";
            }
            reader.close();
            
            // Verificar características Java 8
            if (contenido.contains("com.mysql.jdbc.Driver")) {
                reportarExito("✅ Driver MySQL para Java 8 configurado");
            } else {
                reportarIssue("❌ Driver MySQL Java 8 no configurado");
            }
            
            if (contenido.contains("String.join") || contenido.contains("joinStrings")) {
                reportarExito("✅ Método joinStrings para Java 8 implementado");
            } else {
                reportarIssue("❌ Método de unión de strings no encontrado");
            }
            
            if (contenido.contains("getConnection")) {
                reportarExito("✅ Método de conexión a BD implementado");
            } else {
                reportarIssue("❌ Método de conexión no encontrado");
            }
            
        } catch (IOException e) {
            reportarIssue("❌ Error verificando compatibilidad Java 8: " + e.getMessage());
        }
        
        System.out.println();
    }
    
    private static void verificarArchivo(String rutaRelativa, String tipo) {
        totalTests++;
        String rutaCompleta = BASE_PATH + rutaRelativa;
        File archivo = new File(rutaCompleta);
        
        if (archivo.exists()) {
            long tamaño = archivo.length();
            reportarExito("✅ " + tipo + ": " + rutaRelativa + " (" + (tamaño/1024) + "KB)");
        } else {
            reportarIssue("❌ " + tipo + " faltante: " + rutaRelativa);
        }
    }
    
    private static void verificarConexionJSP(String jsp, String controlador) {
        totalTests++;
        String rutaJSP = BASE_PATH + "web/" + jsp;
        
        try {
            File archivoJSP = new File(rutaJSP);
            if (!archivoJSP.exists()) {
                reportarIssue("❌ " + jsp + " no encontrado");
                return;
            }
            
            BufferedReader reader = new BufferedReader(new FileReader(archivoJSP));
            String contenido = "";
            String linea;
            
            while ((linea = reader.readLine()) != null) {
                contenido += linea + "\n";
            }
            reader.close();
            
            // Verificar si el JSP referencia al controlador
            if (contenido.contains(controlador)) {
                reportarExito("✅ " + jsp + " ↔ " + controlador + " - Conectados");
            } else {
                reportarIssue("⚠️ " + jsp + " - Posible desconexión con " + controlador);
            }
            
        } catch (IOException e) {
            reportarIssue("❌ Error verificando " + jsp + ": " + e.getMessage());
        }
    }
    
    private static void reportarExito(String mensaje) {
        passedTests++;
        System.out.println(mensaje);
    }
    
    private static void reportarIssue(String mensaje) {
        issues.add(mensaje);
        System.out.println(mensaje);
    }
    
    private static void generarReporteFinal() {
        System.out.println("📊 REPORTE FINAL DE VALIDACIÓN");
        System.out.println("==============================");
        
        double porcentajeExito = totalTests > 0 ? ((double)passedTests / totalTests) * 100 : 0;
        
        System.out.println("🧪 Total de pruebas ejecutadas: " + totalTests);
        System.out.println("✅ Pruebas exitosas: " + passedTests);
        System.out.println("❌ Issues detectados: " + issues.size());
        System.out.println("📈 Porcentaje de éxito: " + String.format("%.1f", porcentajeExito) + "%");
        System.out.println();
        
        if (!issues.isEmpty()) {
            System.out.println("🔍 ISSUES DETECTADOS:");
            System.out.println("====================");
            for (String issue : issues) {
                System.out.println(issue);
            }
            System.out.println();
        }
        
        if (porcentajeExito >= 90) {
            System.out.println("🎉 SISTEMA VALIDADO EXITOSAMENTE");
            System.out.println("✨ El sistema está listo para ser utilizado");
        } else if (porcentajeExito >= 75) {
            System.out.println("⚠️ SISTEMA MAYORMENTE FUNCIONAL");
            System.out.println("🔧 Algunos ajustes menores requeridos");
        } else {
            System.out.println("🚨 ATENCIÓN REQUERIDA");
            System.out.println("🛠️ Varios componentes necesitan corrección");
        }
        
        System.out.println();
        System.out.println("=================================================");
        System.out.println("🏁 VALIDACIÓN COMPLETADA - " + new Date());
        System.out.println("=================================================");
    }
}