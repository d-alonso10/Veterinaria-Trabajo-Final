package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.AuditLogDTO;

public class AuditDao {
    
    private Connection con;
    private CallableStatement cstmt;
    private ResultSet rs;
    private String url = "jdbc:mysql://localhost/vet_teran";
    private String user = "root";
    private String pass = "";

    // MÉTODO: Consultar logs de auditoría
    public List<AuditLogDTO> obtenerLogsAuditoria(Integer limite, String entidad, String accion) {
        List<AuditLogDTO> logs = new ArrayList<>();
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_ObtenerLogsAuditoria(?, ?, ?)}");
            
            // Establecer parámetros (manejo de nulls)
            if (limite != null) {
                cstmt.setInt(1, limite);
            } else {
                cstmt.setNull(1, Types.INTEGER);
            }
            
            if (entidad != null && !entidad.trim().isEmpty()) {
                cstmt.setString(2, entidad);
            } else {
                cstmt.setNull(2, Types.VARCHAR);
            }
            
            if (accion != null && !accion.trim().isEmpty()) {
                cstmt.setString(3, accion);
            } else {
                cstmt.setNull(3, Types.VARCHAR);
            }
            
            rs = cstmt.executeQuery();

            while (rs.next()) {
                AuditLogDTO log = new AuditLogDTO();
                log.setEntidad(rs.getString("entidad"));
                log.setEntidadId(rs.getInt("entidad_id"));
                log.setAccion(rs.getString("accion"));
                log.setUsuario(rs.getString("usuario"));
                log.setTimestamp(rs.getTimestamp("timestamp"));
                log.setAntes(rs.getString("antes"));
                log.setDespues(rs.getString("despues"));
                
                logs.add(log);
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
        return logs;
    }

    // Método main para probar el procedimiento almacenado
    public static void main(String[] args) {
        AuditDao auditDAO = new AuditDao();

        System.out.println("=== Probando sp_ObtenerLogsAuditoria ===");
        
        // Prueba 1: Últimos 10 logs sin filtros
        System.out.println("\n--- Últimos 10 logs (sin filtros) ---");
        List<AuditLogDTO> logsGenerales = auditDAO.obtenerLogsAuditoria(10, null, null);
        
        mostrarLogs(logsGenerales);
        
        // Prueba 2: Filtro por entidad específica
        System.out.println("\n--- Logs de la entidad 'cliente' ---");
        List<AuditLogDTO> logsClientes = auditDAO.obtenerLogsAuditoria(20, "cliente", null);
        
        mostrarLogs(logsClientes);
        
        // Prueba 3: Filtro por acción específica
        System.out.println("\n--- Últimos INSERT realizados ---");
        List<AuditLogDTO> logsInserts = auditDAO.obtenerLogsAuditoria(15, null, "INSERT");
        
        mostrarLogs(logsInserts);
        
        // Prueba 4: Filtro combinado
        System.out.println("\n--- UPDATEs en la entidad 'mascota' ---");
        List<AuditLogDTO> logsMascotasUpdate = auditDAO.obtenerLogsAuditoria(10, "mascota", "UPDATE");
        
        mostrarLogs(logsMascotasUpdate);
    }
    
    // Método auxiliar para mostrar logs
    private static void mostrarLogs(List<AuditLogDTO> logs) {
        if (logs.isEmpty()) {
            System.out.println("No se encontraron logs con los criterios especificados");
        } else {
            System.out.println("Total de logs encontrados: " + logs.size());
            System.out.println("=====================================");
            
            for (AuditLogDTO log : logs) {
                System.out.println("\n📋 ENTIDAD: " + log.getEntidad() + " (ID: " + log.getEntidadId() + ")");
                System.out.println("🛠️  ACCIÓN: " + log.getAccion());
                System.out.println("👤 USUARIO: " + (log.getUsuario() != null ? log.getUsuario() : "Sistema"));
                System.out.println("⏰ FECHA/HORA: " + log.getTimestamp());
                
                // Mostrar cambios si existen
                if (log.getAntes() != null && !log.getAntes().equals("null")) {
                    System.out.println("📄 ANTES: " + log.getAntes());
                }
                if (log.getDespues() != null && !log.getDespues().equals("null")) {
                    System.out.println("📄 DESPUÉS: " + log.getDespues());
                }
                
                System.out.println("---------------------------");
            }
            
            // Estadísticas
            System.out.println("\n📊 ESTADÍSTICAS:");
            long inserts = logs.stream().filter(l -> "INSERT".equals(l.getAccion())).count();
            long updates = logs.stream().filter(l -> "UPDATE".equals(l.getAccion())).count();
            long deletes = logs.stream().filter(l -> "DELETE".equals(l.getAccion())).count();
            
            System.out.println("INSERT: " + inserts);
            System.out.println("UPDATE: " + updates);
            System.out.println("DELETE: " + deletes);
            
            // Entidades más auditadas
            logs.stream()
                .collect(java.util.stream.Collectors.groupingBy(AuditLogDTO::getEntidad, java.util.stream.Collectors.counting()))
                .forEach((entidad, count) -> {
                    System.out.println(entidad + ": " + count + " registros");
                });
        }
    }
}