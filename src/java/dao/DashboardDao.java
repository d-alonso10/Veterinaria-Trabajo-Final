package dao;

import java.sql.*;
import modelo.MetricasDashboardDTO;
import modelo.EstadisticasMensualesDTO;

// (Importaciones de Calendar, etc. para el main - si se mantienen)
import java.util.Calendar; 

public class DashboardDao {
    
    // Propiedades de Conexión (movidas de variables de instancia)
    private String url = "jdbc:mysql://localhost/vet_teran";
    private String user = "root";
    private String pass = ""; // Asegúrate que esta sea tu contraseña

    /**
     * Obtiene una conexión a la base de datos.
     * (Driver original mantenido por solicitud del usuario)
     */
    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.jdbc.Driver"); // Driver original
            return DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver MySQL no encontrado", e);
        }
    }

    /**
     * Cierra los recursos de JDBC de forma segura.
     */
    private void closeResources(Connection con, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (con != null) con.close();
        } catch (SQLException ex) {
            System.err.println("Error cerrando recursos: " + ex.getMessage());
            ex.printStackTrace();
        }
    }

    /**
     * Obtiene las métricas del dashboard.
     * CORREGIDO: Usa métodos de conexión centralizados y cierre de recursos en finally.
     */
    public MetricasDashboardDTO obtenerMetricasDashboard(java.sql.Date fechaInicio, java.sql.Date fechaFin) {
        MetricasDashboardDTO metricas = new MetricasDashboardDTO();
        Connection con = null;
        CallableStatement cstmt = null;
        ResultSet rs = null;
        
        try {
            con = getConnection();
            cstmt = con.prepareCall("{CALL sp_ObtenerMetricasDashboard(?, ?)}");
            
            cstmt.setDate(1, fechaInicio);
            cstmt.setDate(2, fechaFin);
            
            boolean tieneResultados = cstmt.execute();
            
            int resultCount = 0;
            do {
                if (tieneResultados) {
                    rs = cstmt.getResultSet();
                    
                    if (rs.next()) {
                        switch (resultCount) {
                            case 0: // Total de clientes
                                metricas.setTotalClientes(rs.getInt("total_clientes"));
                                break;
                            case 1: // Total de mascotas
                                metricas.setTotalMascotas(rs.getInt("total_mascotas"));
                                break;
                            case 2: // Citas del día
                                metricas.setCitasHoy(rs.getInt("citas_hoy"));
                                break;
                            case 3: // Ingresos del mes
                                metricas.setIngresosMes(rs.getDouble("ingresos_mes"));
                                break;
                            case 4: // Atenciones en curso
                                metricas.setAtencionesCurso(rs.getInt("atenciones_curso"));
                                break;
                        }
                    }
                    rs.close(); // Cerramos el ResultSet actual antes de pedir el siguiente
                }
                resultCount++;
                // Moverse al siguiente conjunto de resultados
                tieneResultados = cstmt.getMoreResults(Statement.KEEP_CURRENT_RESULT); 
            } while (tieneResultados || cstmt.getUpdateCount() != -1);

        } catch (SQLException e) {
            System.err.println("Error en la operación SQL al obtener métricas del dashboard");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error general al obtener métricas del dashboard");
            e.printStackTrace();
        } finally {
            // Cerramos la conexión y el statement (rs ya se cerró en el bucle)
            closeResources(con, cstmt, null); 
        }
        return metricas;
    }

    /**
     * Obtiene estadísticas mensuales.
     * CORREGIDO: Usa métodos de conexión centralizados y cierre de recursos en finally.
     */
    public EstadisticasMensualesDTO obtenerEstadisticasMensuales(int anio, int mes) {
        EstadisticasMensualesDTO estadisticas = new EstadisticasMensualesDTO();
        Connection con = null;
        CallableStatement cstmt = null;
        ResultSet rs = null;
        
        try {
            con = getConnection();
            cstmt = con.prepareCall("{CALL sp_ObtenerEstadisticasMensuales(?, ?)}");
            
            cstmt.setInt(1, anio);
            cstmt.setInt(2, mes);
            
            rs = cstmt.executeQuery();

            if (rs.next()) {
                estadisticas.setTotalFacturado(rs.getDouble("total_facturado"));
                estadisticas.setClientesNuevos(rs.getInt("clientes_nuevos"));
                estadisticas.setAtencionesRealizadas(rs.getInt("atenciones_realizadas"));
                estadisticas.setServicioPopular(rs.getString("servicio_popular"));
            }

        } catch (SQLException e) {
            System.err.println("Error en la operación SQL al obtener estadísticas mensuales");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error general al obtener estadísticas mensuales");
            e.printStackTrace();
        } finally {
            // Cerramos todos los recursos
            closeResources(con, cstmt, rs);
        }
        return estadisticas;
    }

    /*
     * El método main() es útil para probar, pero generalmente se elimina
     * del DAO final o se deja comentado.
     * Lo dejo aquí ya que estaba en tu archivo original.
     */
    public static void main(String[] args) {
        DashboardDao dashboardDAO = new DashboardDao();

        System.out.println("=== Probando sp_ObtenerEstadisticasMensuales ===");
        
        // Probar con diferentes meses y años
        int anioActual = 2025;
        // NOTA: Tus datos de prueba SQL son de Octubre (10), 
        // así que asegúrate de probar ese mes.
        int[] mesesPrueba = {1, 9, 10, 11}; 
        
        for (int mes : mesesPrueba) {
            System.out.println("\n" + crearLinea(60));
            System.out.println("📊 ESTADÍSTICAS MENSUALES - " + obtenerNombreMes(mes) + " " + anioActual);
            System.out.println(crearLinea(60));
            
            EstadisticasMensualesDTO estadisticas = dashboardDAO.obtenerEstadisticasMensuales(anioActual, mes);
            
            System.out.println("💰 TOTAL FACTURADO: S/ " + String.format("%.2f", estadisticas.getTotalFacturado()));
            System.out.println("👥 CLIENTES NUEVOS: " + estadisticas.getClientesNuevos());
            System.out.println("⚡ ATENCIONES REALIZADAS: " + estadisticas.getAtencionesRealizadas());
            System.out.println("🏆 SERVICIO MÁS POPULAR: " + 
                (estadisticas.getServicioPopular() != null ? estadisticas.getServicioPopular() : "No hay datos"));
            
            // ... (Resto del método main) ...
        }
        
        System.out.println("\n✅ Método sp_ObtenerEstadisticasMensuales probado exitosamente");
    }
    
    // --- Métodos auxiliares para el main ---
    private static String crearLinea(int longitud) {
        StringBuilder linea = new StringBuilder();
        for (int i = 0; i < longitud; i++) {
            linea.append("=");
        }
        return linea.toString();
    }
    
    private static String obtenerNombreMes(int mes) {
        String[] meses = {"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
                         "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"};
        if (mes < 1 || mes > 12) return "Mes Inválido";
        return meses[mes - 1];
    }
}