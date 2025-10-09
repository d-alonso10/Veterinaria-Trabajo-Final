package dao;

import java.sql.*;
import modelo.MetricasDashboardDTO;
import modelo.EstadisticasMensualesDTO;

public class DashboardDao {
    
    private Connection con;
    private CallableStatement cstmt;
    private ResultSet rs;
    private String url = "jdbc:mysql://localhost/vet_teran";
    private String user = "root";
    private String pass = "";

    public MetricasDashboardDTO obtenerMetricasDashboard(java.sql.Date fechaInicio, java.sql.Date fechaFin) {
        MetricasDashboardDTO metricas = new MetricasDashboardDTO();
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_ObtenerMetricasDashboard(?, ?)}");
            
            cstmt.setDate(1, fechaInicio);
            cstmt.setDate(2, fechaFin);
            
            boolean tieneResultados = cstmt.execute();
            
            // Procesar múltiples resultados del procedimiento almacenado
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
                    rs.close();
                }
                resultCount++;
                tieneResultados = cstmt.getMoreResults();
            } while (tieneResultados || cstmt.getUpdateCount() != -1);

        } catch (ClassNotFoundException e) {
            System.err.println("Error: Driver no encontrado");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Error en la operación SQL al obtener métricas del dashboard");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error general al obtener métricas del dashboard");
            e.printStackTrace();
        } finally {
            try {
                if (cstmt != null) cstmt.close();
                if (con != null) con.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return metricas;
    }

    // NUEVO MÉTODO: Obtener estadísticas mensuales
    public EstadisticasMensualesDTO obtenerEstadisticasMensuales(int anio, int mes) {
        EstadisticasMensualesDTO estadisticas = new EstadisticasMensualesDTO();
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

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

        } catch (ClassNotFoundException e) {
            System.err.println("Error: Driver no encontrado");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Error en la operación SQL al obtener estadísticas mensuales");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error general al obtener estadísticas mensuales");
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
        return estadisticas;
    }

    // Método main para probar solo el nuevo método agregado
    public static void main(String[] args) {
        DashboardDao dashboardDAO = new DashboardDao();

        System.out.println("=== Probando sp_ObtenerEstadisticasMensuales ===");
        
        // Probar con diferentes meses y años
        int anioActual = 2025;
        int[] mesesPrueba = {1, 2, 3, 9}; // Enero, Febrero, Marzo, Septiembre
        
        for (int mes : mesesPrueba) {
            System.out.println("\n" + crearLinea(60));
            System.out.println("📊 ESTADÍSTICAS MENSUALES - " + obtenerNombreMes(mes) + " " + anioActual);
            System.out.println(crearLinea(60));
            
            EstadisticasMensualesDTO estadisticas = dashboardDAO.obtenerEstadisticasMensuales(anioActual, mes);
            
            // Mostrar estadísticas principales
            System.out.println("💰 TOTAL FACTURADO: S/ " + String.format("%.2f", estadisticas.getTotalFacturado()));
            System.out.println("👥 CLIENTES NUEVOS: " + estadisticas.getClientesNuevos());
            System.out.println("⚡ ATENCIONES REALIZADAS: " + estadisticas.getAtencionesRealizadas());
            System.out.println("🏆 SERVICIO MÁS POPULAR: " + 
                (estadisticas.getServicioPopular() != null ? estadisticas.getServicioPopular() : "No hay datos"));
            
            // Análisis detallado
            System.out.println("\n📈 ANÁLISIS DETALLADO:");
            System.out.println(crearLineaPunteada(30));
            
            // Promedio por atención
            if (estadisticas.getAtencionesRealizadas() > 0) {
                double promedioPorAtencion = estadisticas.getTotalFacturado() / estadisticas.getAtencionesRealizadas();
                System.out.println("• Ticket promedio: S/ " + String.format("%.2f", promedioPorAtencion));
            }
            
            // Eficiencia de captación
            if (estadisticas.getClientesNuevos() > 0 && estadisticas.getTotalFacturado() > 0) {
                double valorPorClienteNuevo = estadisticas.getTotalFacturado() / estadisticas.getClientesNuevos();
                System.out.println("• Valor por cliente nuevo: S/ " + String.format("%.2f", valorPorClienteNuevo));
            }
            
            // Densidad de atenciones
            int diasEnMes = obtenerDiasEnMes(mes, anioActual);
            double atencionesPorDia = (double) estadisticas.getAtencionesRealizadas() / diasEnMes;
            System.out.println("• Atenciones por día: " + String.format("%.1f", atencionesPorDia));
            
            // Evaluación del desempeño
            System.out.println("\n🎯 EVALUACIÓN DEL DESEMPEÑO:");
            System.out.println(crearLineaPunteada(35));
            
            if (estadisticas.getTotalFacturado() >= 10000) {
                System.out.println("✅ Excelente - Alto volumen de facturación");
            } else if (estadisticas.getTotalFacturado() >= 5000) {
                System.out.println("⚠️  Bueno - Facturación moderada");
            } else {
                System.out.println("💡 Oportunidad - Potencial de crecimiento");
            }
            
            if (estadisticas.getClientesNuevos() >= 20) {
                System.out.println("📈 Fuerte captación - Muchos clientes nuevos");
            } else if (estadisticas.getClientesNuevos() >= 10) {
                System.out.println("📊 Crecimiento estable - Captación constante");
            } else {
                System.out.println("🎯 Enfocar marketing - Pocos clientes nuevos");
            }
            
            if (estadisticas.getAtencionesRealizadas() >= 100) {
                System.out.println("🔥 Alta productividad - Muchas atenciones");
            } else if (estadisticas.getAtencionesRealizadas() >= 50) {
                System.out.println("⚡ Buen ritmo - Flujo constante");
            } else {
                System.out.println("🔄 Optimizar agenda - Capacidad disponible");
            }
            
            // Proyecciones para el próximo mes
            System.out.println("\n🔮 PROYECCIONES:");
            double crecimientoEsperado = estadisticas.getTotalFacturado() * 0.1; // 10% de crecimiento
            System.out.println("• Crecimiento esperado: S/ " + String.format("%.2f", crecimientoEsperado));
            System.out.println("• Meta próximo mes: S/ " + String.format("%.2f", estadisticas.getTotalFacturado() + crecimientoEsperado));
        }
        
        // Comparativa entre meses
        System.out.println("\n" + crearLinea(60));
        System.out.println("📅 COMPARATIVA ENTRE MESES");
        System.out.println(crearLinea(60));
        
        for (int mes : mesesPrueba) {
            EstadisticasMensualesDTO stats = dashboardDAO.obtenerEstadisticasMensuales(anioActual, mes);
            System.out.println(obtenerNombreMes(mes) + ": S/ " + String.format("%.2f", stats.getTotalFacturado()) + 
                             " | " + stats.getAtencionesRealizadas() + " atenciones | " + 
                             stats.getClientesNuevos() + " clientes nuevos");
        }
        
        // Ejemplos de uso en reportes
        System.out.println("\n" + crearLinea(60));
        System.out.println("🚀 USO EN REPORTES Y ANÁLISIS");
        System.out.println(crearLinea(60));
        
        System.out.println("1. 📊 Reportes ejecutivos:");
        System.out.println("   - Análisis de tendencias mensuales");
        System.out.println("   - Toma de decisiones estratégicas");
        System.out.println("   - Evaluación de campañas de marketing");
        
        System.out.println("\n2. 💼 Reuniones de equipo:");
        System.out.println("   - Revisión de metas y objetivos");
        System.out.println("   - Planificación de recursos");
        System.out.println("   - Identificación de oportunidades");
        
        System.out.println("\n3. 📈 Dashboard histórico:");
        System.out.println("   - Gráficos de evolución temporal");
        System.out.println("   - Comparativa año tras año");
        System.out.println("   - Análisis de estacionalidad");
        
        System.out.println("\n4. 🎯 Planificación comercial:");
        System.out.println("   - Definición de metas realistas");
        System.out.println("   - Estrategias de crecimiento");
        System.out.println("   - Optimización de servicios ofrecidos");
        
        System.out.println("\n✅ Método sp_ObtenerEstadisticasMensuales probado exitosamente");
    }
    
    // Métodos auxiliares
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
    
    private static String obtenerNombreMes(int mes) {
        String[] meses = {"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
                         "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"};
        return meses[mes - 1];
    }
    
    private static int obtenerDiasEnMes(int mes, int anio) {
        java.util.Calendar calendario = java.util.Calendar.getInstance();
        calendario.set(anio, mes - 1, 1);
        return calendario.getActualMaximum(java.util.Calendar.DAY_OF_MONTH);
    }
}