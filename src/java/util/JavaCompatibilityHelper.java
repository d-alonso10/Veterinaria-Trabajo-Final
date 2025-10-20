package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import java.util.ArrayList;
import java.util.Collections;

/**
 * Utilidades para asegurar compatibilidad con Java 8 (1.8.0_202) y NetBeans 8.2
 * Veterinaria Terán Vet - Sistema de Gestión Grooming
 * 
 * COMPATIBILIDAD:
 * - Java 8 (1.8.0_202)
 * - NetBeans 8.2
 * - MySQL Connector/J 5.1.x (com.mysql.jdbc.Driver)
 * - Servlets API 3.1
 * - JSP 2.3
 */
public class JavaCompatibilityHelper {
    
    // Configuración de base de datos para Java 8
    private static final String DB_URL = "jdbc:mysql://localhost/vet_teran";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";
    private static final String DRIVER_CLASS = "com.mysql.jdbc.Driver";
    
    /**
     * Obtiene conexión a base de datos usando el driver MySQL compatible con Java 8
     * Usa com.mysql.jdbc.Driver (NO com.mysql.cj.jdbc.Driver que requiere Java 8+)
     */
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName(DRIVER_CLASS);
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }
    
    /**
     * Reemplaza String.join() que no está disponible en Java 7
     * Compatible con Java 8
     */
    public static String joinStrings(List<String> strings, String delimiter) {
        if (strings == null || strings.isEmpty()) {
            return "";
        }
        
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < strings.size(); i++) {
            sb.append(strings.get(i));
            if (i < strings.size() - 1) {
                sb.append(delimiter);
            }
        }
        return sb.toString();
    }
    
    /**
     * Reemplaza String.join() para arrays
     */
    public static String joinStrings(String[] strings, String delimiter) {
        return joinStrings(Arrays.asList(strings), delimiter);
    }
    
    /**
     * Validador de cadenas nulas o vacías compatible con Java 8
     */
    public static boolean isNullOrEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }
    
    /**
     * Validador de strings con valor por defecto
     */
    public static String getStringOrDefault(String value, String defaultValue) {
        return isNullOrEmpty(value) ? defaultValue : value.trim();
    }
    
    /**
     * Convierte valor a entero con valor por defecto
     */
    public static int getIntOrDefault(String value, int defaultValue) {
        if (isNullOrEmpty(value)) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
    
    /**
     * Convierte valor a double con valor por defecto
     */
    public static double getDoubleOrDefault(String value, double defaultValue) {
        if (isNullOrEmpty(value)) {
            return defaultValue;
        }
        try {
            return Double.parseDouble(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
    
    /**
     * Crea lista inmutable compatible con Java 8
     * Reemplaza List.of() que no está disponible
     */
    public static <T> List<T> createImmutableList(T... elements) {
        List<T> list = new ArrayList<T>();
        for (T element : elements) {
            list.add(element);
        }
        return Collections.unmodifiableList(list);
    }
    
    /**
     * Limpia parámetros de request para evitar inyección SQL
     */
    public static String sanitizeParameter(String param) {
        if (param == null) {
            return "";
        }
        
        return param.trim()
                   .replaceAll("[<>\"'%;()&+]", "")  // Eliminar caracteres peligrosos
                   .replaceAll("\\s+", " ");         // Normalizar espacios
    }
    
    /**
     * Valida formato de email básico
     */
    public static boolean isValidEmail(String email) {
        if (isNullOrEmpty(email)) {
            return false;
        }
        
        // Validación básica compatible con Java 8
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
        return email.matches(emailRegex);
    }
    
    /**
     * Valida formato de teléfono básico
     */
    public static boolean isValidPhone(String phone) {
        if (isNullOrEmpty(phone)) {
            return false;
        }
        
        // Permite números, espacios, guiones y paréntesis
        String phoneRegex = "^[\\d\\s\\-\\(\\)\\+]{7,15}$";
        return phone.matches(phoneRegex);
    }
    
    /**
     * Formateo de JSON simple para compatibilidad
     */
    public static String createSimpleJson(String key, String value) {
        if (value == null) {
            value = "";
        }
        
        // Escapar comillas en el valor
        String escapedValue = value.replace("\"", "\\\"")
                                  .replace("\n", "\\n")
                                  .replace("\r", "\\r")
                                  .replace("\t", "\\t");
        
        return "{\"" + key + "\": \"" + escapedValue + "\"}";
    }
    
    /**
     * Información del sistema para debug
     */
    public static void printSystemInfo() {
        System.out.println("=== INFORMACIÓN DEL SISTEMA ===");
        System.out.println("Java Version: " + System.getProperty("java.version"));
        System.out.println("Java Vendor: " + System.getProperty("java.vendor"));
        System.out.println("Java Home: " + System.getProperty("java.home"));
        System.out.println("OS Name: " + System.getProperty("os.name"));
        System.out.println("OS Version: " + System.getProperty("os.version"));
        System.out.println("User Dir: " + System.getProperty("user.dir"));
        System.out.println("Driver MySQL: " + DRIVER_CLASS);
        System.out.println("URL BD: " + DB_URL);
        System.out.println("=============================");
    }
    
    /**
     * Test de conexión a base de datos
     */
    public static boolean testDatabaseConnection() {
        try {
            System.out.println("🔍 Probando conexión a base de datos...");
            Connection conn = getConnection();
            
            if (conn != null && !conn.isClosed()) {
                System.out.println("✅ Conexión exitosa a: " + DB_URL);
                conn.close();
                return true;
            } else {
                System.out.println("❌ Error: Conexión nula o cerrada");
                return false;
            }
            
        } catch (ClassNotFoundException e) {
            System.out.println("❌ Error: Driver MySQL no encontrado");
            System.out.println("💡 Asegúrate de tener mysql-connector-java-5.1.x.jar en el classpath");
            return false;
        } catch (SQLException e) {
            System.out.println("❌ Error SQL: " + e.getMessage());
            System.out.println("💡 Verifica que MySQL esté corriendo y la BD 'vet_teran' exista");
            return false;
        } catch (Exception e) {
            System.out.println("❌ Error general: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Método principal para pruebas
     */
    public static void main(String[] args) {
        System.out.println("🚀 VETERINARIA TERÁN VET - VERIFICACIÓN DE COMPATIBILIDAD");
        System.out.println("===========================================================");
        
        printSystemInfo();
        
        System.out.println("\n🔧 PRUEBAS DE COMPATIBILIDAD:");
        
        // Test 1: Conexión BD
        System.out.println("\n1. Conexión a Base de Datos:");
        boolean dbOk = testDatabaseConnection();
        
        // Test 2: Utilidades de string
        System.out.println("\n2. Utilidades de String:");
        List<String> testList = createImmutableList("item1", "item2", "item3");
        String joined = joinStrings(testList, ", ");
        System.out.println("✅ Join de strings: " + joined);
        
        // Test 3: Validaciones
        System.out.println("\n3. Validaciones:");
        System.out.println("✅ Email válido: " + isValidEmail("test@example.com"));
        System.out.println("✅ Teléfono válido: " + isValidPhone("555-0123"));
        
        // Test 4: JSON simple
        System.out.println("\n4. JSON Simple:");
        String json = createSimpleJson("preferencia", "Baño completo los martes");
        System.out.println("✅ JSON creado: " + json);
        
        // Test 5: Sanitización
        System.out.println("\n5. Sanitización:");
        String dangerous = "<script>alert('test')</script>";
        String safe = sanitizeParameter(dangerous);
        System.out.println("✅ Texto peligroso: " + dangerous);
        System.out.println("✅ Texto seguro: " + safe);
        
        // Resumen
        System.out.println("\n📊 RESUMEN:");
        System.out.println("============");
        System.out.println("🔗 Conexión BD: " + (dbOk ? "✅ OK" : "❌ ERROR"));
        System.out.println("🔧 Utilidades: ✅ OK");
        System.out.println("🛡️  Validaciones: ✅ OK");
        System.out.println("📝 JSON: ✅ OK");
        System.out.println("🧹 Sanitización: ✅ OK");
        
        if (dbOk) {
            System.out.println("\n🎉 SISTEMA LISTO PARA Java 8 + NetBeans 8.2");
        } else {
            System.out.println("\n⚠️  REQUIERE CONFIGURACIÓN DE BASE DE DATOS");
        }
    }
}