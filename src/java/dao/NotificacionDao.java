package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.Notificacion;
import modelo.NotificacionClienteDTO;

public class NotificacionDao {
    
    private Connection con;
    private CallableStatement cstmt;
    private ResultSet rs;
    private String url = "jdbc:mysql://localhost/vet_teran";
    private String user = "root";
    private String pass = "";

    public boolean registrarNotificacion(Notificacion notificacion) {
        boolean exito = false;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);
            
            cstmt = con.prepareCall("{CALL sp_RegistrarNotificacion(?, ?, ?, ?, ?, ?)}");
            
            cstmt.setString(1, notificacion.getTipo());
            cstmt.setInt(2, notificacion.getDestinatarioId());
            cstmt.setString(3, notificacion.getCanal());
            cstmt.setString(4, notificacion.getContenido());
            cstmt.setString(5, notificacion.getReferenciaTipo());
            cstmt.setInt(6, notificacion.getReferenciaId());
            
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

    // NUEVO MÉTODO: Obtener notificaciones de un cliente
    public List<NotificacionClienteDTO> obtenerNotificacionesCliente(int destinatarioId, Integer limite) {
        List<NotificacionClienteDTO> notificaciones = new ArrayList<>();
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_ObtenerNotificacionesCliente(?, ?)}");
            
            cstmt.setInt(1, destinatarioId);
            
            if (limite != null) {
                cstmt.setInt(2, limite);
            } else {
                cstmt.setNull(2, Types.INTEGER);
            }
            
            rs = cstmt.executeQuery();

            while (rs.next()) {
                NotificacionClienteDTO notificacion = new NotificacionClienteDTO();
                notificacion.setTipo(rs.getString("tipo"));
                notificacion.setContenido(rs.getString("contenido"));
                notificacion.setEnviadoAt(rs.getTimestamp("enviado_at"));
                notificacion.setEstado(rs.getString("estado"));
                notificacion.setReferenciaTipo(rs.getString("referencia_tipo"));
                notificacion.setReferenciaId(rs.getInt("referencia_id"));
                
                notificaciones.add(notificacion);
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
        return notificaciones;
    }

    // Método main para probar solo el último método agregado
    public static void main(String[] args) {
        NotificacionDao notificacionDAO = new NotificacionDao();

        System.out.println("=== Probando sp_ObtenerNotificacionesCliente ===");
        
        // Obtener notificaciones del cliente con ID 1
        int destinatarioId = 1;
        Integer limite = 10; // Últimas 10 notificaciones
        
        System.out.println("Consultando notificaciones para cliente ID: " + destinatarioId);
        System.out.println("Límite: " + (limite != null ? limite : "Sin límite"));
        
        List<NotificacionClienteDTO> notificaciones = notificacionDAO.obtenerNotificacionesCliente(destinatarioId, limite);
        
        if (notificaciones.isEmpty()) {
            System.out.println("\nNo se encontraron notificaciones para este cliente");
        } else {
            System.out.println("\n📨 HISTORIAL DE NOTIFICACIONES - CLIENTE ID: " + destinatarioId);
            System.out.println("==================================================");
            
            int totalNotificaciones = 0;
            int emails = 0, sms = 0, push = 0;
            int contador = 1;
            
            for (NotificacionClienteDTO notificacion : notificaciones) {
                String icono = "";
                switch (notificacion.getTipo()) {
                    case "email": icono = "📧"; emails++; break;
                    case "sms": icono = "📱"; sms++; break;
                    case "push": icono = "🔔"; push++; break;
                    default: icono = "💬";
                }
                
                System.out.println("\n" + contador + ". " + icono + " " + notificacion.getTipo().toUpperCase());
                System.out.println("   Contenido: " + notificacion.getContenido());
                System.out.println("   Fecha: " + notificacion.getEnviadoAt());
                System.out.println("   Estado: " + notificacion.getEstado());
                
                if (notificacion.getReferenciaTipo() != null) {
                    System.out.println("   Referencia: " + notificacion.getReferenciaTipo() + " #" + notificacion.getReferenciaId());
                }
                
                System.out.println("   -------------------------");
                
                totalNotificaciones++;
                contador++;
            }
            
            // Resumen del historial
            System.out.println("\n📊 RESUMEN DEL HISTORIAL:");
            System.out.println("========================");
            System.out.println("Total de notificaciones: " + totalNotificaciones);
            System.out.println("📧 Emails: " + emails);
            System.out.println("📱 SMS: " + sms);
            System.out.println("🔔 Push: " + push);
            
            // Notificación más reciente
            if (!notificaciones.isEmpty()) {
                NotificacionClienteDTO notificacionReciente = notificaciones.get(0);
                System.out.println("\n⏰ NOTIFICACIÓN MÁS RECIENTE:");
                System.out.println("Tipo: " + notificacionReciente.getTipo());
                System.out.println("Fecha: " + notificacionReciente.getEnviadoAt());
                System.out.println("Contenido: " + notificacionReciente.getContenido());
            }
            
            // Análisis por tipo de referencia
            System.out.println("\n🔗 ANÁLISIS POR TIPO DE REFERENCIA:");
            System.out.println("=================================");
            notificaciones.stream()
                .filter(n -> n.getReferenciaTipo() != null)
                .collect(java.util.stream.Collectors.groupingBy(NotificacionClienteDTO::getReferenciaTipo, java.util.stream.Collectors.counting()))
                .forEach((tipo, count) -> {
                    System.out.println("- " + tipo + ": " + count + " notificaciones");
                });
                
            // Frecuencia de notificaciones
            if (notificaciones.size() >= 2) {
                NotificacionClienteDTO masAntigua = notificaciones.get(notificaciones.size() - 1);
                NotificacionClienteDTO masReciente = notificaciones.get(0);
                
                long diff = masReciente.getEnviadoAt().getTime() - masAntigua.getEnviadoAt().getTime();
                long dias = diff / (1000 * 60 * 60 * 24);
                double frecuencia = (double) totalNotificaciones / (dias > 0 ? dias : 1);
                
                System.out.println("\n📈 FRECUENCIA:");
                System.out.println("Período analizado: " + dias + " días");
                System.out.println("Frecuencia: " + String.format("%.2f", frecuencia) + " notificaciones por día");
            }
        }
        
        // Prueba con límite diferente
        System.out.println("\n=== Prueba con límite de 5 notificaciones ===");
        List<NotificacionClienteDTO> notificacionesLimitadas = notificacionDAO.obtenerNotificacionesCliente(destinatarioId, 5);
        System.out.println("Notificaciones obtenidas: " + notificacionesLimitadas.size());
    }
}