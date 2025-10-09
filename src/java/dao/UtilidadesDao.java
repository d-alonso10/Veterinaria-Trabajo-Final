package dao;

import java.sql.*;
import java.util.*;
import modelo.AuditLog;
import modelo.Notificacion;
import modelo.Factura;

public class UtilidadesDao {
    
    private Connection con;
    private CallableStatement cstmt;
    private ResultSet rs;
    private String url = "jdbc:mysql://localhost/vet_teran";
    private String user = "root";
    private String pass = "";

    // MÉTODO 21: Limpiar datos temporales
    public boolean limpiarDatosTemporales(int diasAntiguedad) {
        boolean exito = false;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);
            
            cstmt = con.prepareCall("{CALL sp_LimpiarDatosTemporales(?)}");
            cstmt.setInt(1, diasAntiguedad);
            
            int filasAfectadas = cstmt.executeUpdate();
            
            if (filasAfectadas >= 0) { // Puede ser 0 si no hay datos que limpiar
                exito = true;
            }
            
        } catch (Exception e) {
            System.err.println("Error al limpiar datos temporales");
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

    // MÉTODO 22: Generar backup de datos esenciales
    public boolean generarBackupEsencial(java.sql.Date fechaBackup) {
        boolean exito = false;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);
            
            cstmt = con.prepareCall("{CALL sp_GenerarBackupEsencial(?)}");
            cstmt.setDate(1, fechaBackup);
            
            // Este procedimiento retorna un resultado, no hace UPDATE
            rs = cstmt.executeQuery();
            
            if (rs.next()) {
                String mensaje = rs.getString("mensaje");
                if ("Backup completado exitosamente".equals(mensaje)) {
                    exito = true;
                }
            }
            
        } catch (Exception e) {
            System.err.println("Error al generar backup");
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
        return exito;
    }

    // MÉTODO 23: Recalcular totales de facturas
    public boolean recalcularTotalesFacturas() {
        boolean exito = false;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);
            
            cstmt = con.prepareCall("{CALL sp_RecalcularTotalesFacturas()}");
            
            // Este procedimiento retorna un resultado
            rs = cstmt.executeQuery();
            
            if (rs.next()) {
                String mensaje = rs.getString("mensaje");
                if ("Totales recalculados exitosamente".equals(mensaje)) {
                    exito = true;
                }
            }
            
        } catch (Exception e) {
            System.err.println("Error al recalcular totales de facturas");
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
        return exito;
    }

    // MÉTODO AUXILIAR: Obtener logs de auditoría para análisis
    public List<AuditLog> obtenerLogsAuditoria(int dias) {
        List<AuditLog> logs = new ArrayList<>();
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            String sql = "SELECT * FROM audit_log WHERE timestamp >= DATE_SUB(NOW(), INTERVAL ? DAY) ORDER BY timestamp DESC";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, dias);
            
            rs = pstmt.executeQuery();

            while (rs.next()) {
                AuditLog log = new AuditLog();
                log.setIdLog(rs.getInt("id_log"));
                log.setEntidad(rs.getString("entidad"));
                log.setEntidadId(rs.getInt("entidad_id"));
                log.setAccion(rs.getString("accion"));
                log.setIdUsuario(rs.getInt("id_usuario"));
                log.setAntes(rs.getString("antes"));
                log.setDespues(rs.getString("despues"));
                log.setTimestamp(rs.getTimestamp("timestamp"));
                
                logs.add(log);
            }

        } catch (ClassNotFoundException e) {
            System.err.println("Error: Driver no encontrado");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Error en la operación SQL al obtener logs");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error general al obtener logs");
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

    // MÉTODO AUXILIAR: Obtener notificaciones pendientes
    public List<Notificacion> obtenerNotificacionesPendientes() {
        List<Notificacion> notificaciones = new ArrayList<>();
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            String sql = "SELECT * FROM notificacion WHERE estado = 'pendiente' ORDER BY enviado_at ASC";
            PreparedStatement pstmt = con.prepareStatement(sql);
            
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Notificacion notificacion = new Notificacion();
                notificacion.setIdNotificacion(rs.getInt("id_notificacion"));
                notificacion.setTipo(rs.getString("tipo"));
                notificacion.setDestinatarioId(rs.getInt("destinatario_id"));
                notificacion.setCanal(rs.getString("canal"));
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
            System.err.println("Error en la operación SQL al obtener notificaciones");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error general al obtener notificaciones");
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

    // MÉTODO AUXILIAR: Obtener facturas con problemas de cálculo
    public List<Factura> obtenerFacturasConProblemas() {
        List<Factura> facturas = new ArrayList<>();
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            String sql = "SELECT f.* FROM factura f " +
                        "INNER JOIN atencion a ON f.id_atencion = a.id_atencion " +
                        "INNER JOIN detalle_servicio ds ON a.id_atencion = ds.id_atencion " +
                        "GROUP BY f.id_factura " +
                        "HAVING ABS(f.subtotal - COALESCE(SUM(ds.subtotal), 0)) > 0.01 " +
                        "OR ABS(f.total - (COALESCE(SUM(ds.subtotal), 0) * 1.18)) > 0.01";
            
            PreparedStatement pstmt = con.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Factura factura = new Factura();
                factura.setIdFactura(rs.getInt("id_factura"));
                factura.setSerie(rs.getString("serie"));
                factura.setNumero(rs.getString("numero"));
                factura.setIdCliente(rs.getInt("id_cliente"));
                factura.setIdAtencion(rs.getInt("id_atencion"));
                factura.setFechaEmision(rs.getTimestamp("fecha_emision"));
                factura.setSubtotal(rs.getDouble("subtotal"));
                factura.setImpuesto(rs.getDouble("impuesto"));
                factura.setDescuentoTotal(rs.getDouble("descuento_total"));
                factura.setTotal(rs.getDouble("total"));
                factura.setEstado(rs.getString("estado"));
                factura.setMetodoPagoSugerido(rs.getString("metodo_pago_sugerido"));
                
                facturas.add(factura);
            }

        } catch (ClassNotFoundException e) {
            System.err.println("Error: Driver no encontrado");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Error en la operación SQL al obtener facturas con problemas");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error general al obtener facturas con problemas");
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
        return facturas;
    }

    // Métodos auxiliares para formato (similares a los del ClienteDao)
    private static String crearLinea(int longitud) {
        StringBuilder linea = new StringBuilder();
        for (int i = 0; i < longitud; i++) {
            linea.append("=");
        }
        return linea.toString();
    }

    private static String crearLineaPunteada(int longitud) {
        StringBuilder linea = new StringBuilder();
        for (int i = 0; i < longitud; i++) {
            linea.append("-");
        }
        return linea.toString();
    }

    
}