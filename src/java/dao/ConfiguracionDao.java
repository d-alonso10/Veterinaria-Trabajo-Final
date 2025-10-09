package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.ConfiguracionEstimacion;
import modelo.EstimacionTiempoDTO;

public class ConfiguracionDao {

    private Connection con;
    private CallableStatement cstmt;
    private ResultSet rs;
    private String url = "jdbc:mysql://localhost/vet_teran";
    private String user = "root";
    private String pass = "";

    // MÉTODO: Obtener estimaciones de tiempo por servicio y groomer
    public List<EstimacionTiempoDTO> obtenerEstimacionesTiempo() {
        List<EstimacionTiempoDTO> estimaciones = new ArrayList<>();

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_ObtenerEstimacionesTiempo()}");

            rs = cstmt.executeQuery();

            while (rs.next()) {
                EstimacionTiempoDTO estimacion = new EstimacionTiempoDTO();

                // NUEVO: leer ids
                estimacion.setIdServicio(rs.getInt("id_servicio"));
                estimacion.setIdGroomer(rs.getInt("id_groomer"));

                estimacion.setServicio(rs.getString("servicio"));
                estimacion.setGroomer(rs.getString("groomer"));
                estimacion.setTiempoEstimadoMin(rs.getInt("tiempo_estimado_min"));
                estimacion.setDuracionBase(rs.getInt("duracion_base"));

                // opcional: calcular nivelEficiencia si quieres (o dejar vacío)
                // estimacion.setNivelEficiencia(calcularNivel(...));
                estimaciones.add(estimacion);
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
                if (rs != null) {
                    rs.close();
                }
                if (cstmt != null) {
                    cstmt.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return estimaciones;
    }

    // MÉTODO: Ajustar tiempo estimado de un servicio
    public boolean ajustarTiempoEstimado(ConfiguracionEstimacion configuracion) {
        boolean exito = false;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_AjustarTiempoEstimado(?, ?, ?)}");

            cstmt.setInt(1, configuracion.getIdServicio());
            cstmt.setInt(2, configuracion.getIdGroomer());
            cstmt.setInt(3, configuracion.getTiempoEstimadoMin());

            int filasAfectadas = cstmt.executeUpdate();

            if (filasAfectadas > 0) {
                exito = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cstmt != null) {
                    cstmt.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return exito;
    }

    // Método main para probar ambos procedimientos almacenados
    public static void main(String[] args) {
        ConfiguracionDao configuracionDAO = new ConfiguracionDao();

        System.out.println("=== Probando sp_ObtenerEstimacionesTiempo ===");

        List<EstimacionTiempoDTO> estimaciones = configuracionDAO.obtenerEstimacionesTiempo();

        if (estimaciones.isEmpty()) {
            System.out.println("No se encontraron estimaciones de tiempo configuradas");
            System.out.println("💡 Sugerencia: Configura las estimaciones para mejorar la planificación");
        } else {
            System.out.println("\n⏰ ESTIMACIONES DE TIEMPO - SERVICIO x GROOMER");
            System.out.println("=============================================");

            // Agrupar por servicio para mejor visualización
            estimaciones.stream()
                    .collect(java.util.stream.Collectors.groupingBy(EstimacionTiempoDTO::getServicio))
                    .forEach((servicio, estimacionesServicio) -> {
                        System.out.println("\n📋 SERVICIO: " + servicio);
                        System.out.println("   Duración base: " + estimacionesServicio.get(0).getDuracionBase() + " min");
                        System.out.println("   -------------------------");

                        for (EstimacionTiempoDTO estimacion : estimacionesServicio) {
                            String diferencia = "";
                            int diff = estimacion.getTiempoEstimadoMin() - estimacion.getDuracionBase();
                            if (diff > 0) {
                                diferencia = " (+" + diff + " min)";
                            } else if (diff < 0) {
                                diferencia = " (" + diff + " min)";
                            } else {
                                diferencia = " (igual)";
                            }

                            String eficiencia = estimacion.getNivelEficiencia();
                            System.out.println("   👤 " + estimacion.getGroomer() + ": "
                                    + estimacion.getTiempoEstimadoMin() + " min"
                                    + diferencia + " - " + eficiencia);
                        }
                    });

            // Resumen general
            System.out.println("\n📊 RESUMEN GENERAL:");
            System.out.println("==================");
            System.out.println("Total de configuraciones: " + estimaciones.size());

            // Servicios con más configuraciones
            long serviciosUnicos = estimaciones.stream()
                    .map(EstimacionTiempoDTO::getServicio)
                    .distinct()
                    .count();
            long groomersUnicos = estimaciones.stream()
                    .map(EstimacionTiempoDTO::getGroomer)
                    .distinct()
                    .count();

            System.out.println("Servicios diferentes: " + serviciosUnicos);
            System.out.println("Groomers diferentes: " + groomersUnicos);
        }

        System.out.println("\n=== Probando sp_AjustarTiempoEstimado ===");

        // Crear una configuración de estimación para ajustar
        ConfiguracionEstimacion nuevaConfig = new ConfiguracionEstimacion();
        nuevaConfig.setIdServicio(1); // ID de servicio existente
        nuevaConfig.setIdGroomer(1);  // ID de groomer existente
        nuevaConfig.setTiempoEstimadoMin(45); // Nuevo tiempo estimado

        boolean ajustado = configuracionDAO.ajustarTiempoEstimado(nuevaConfig);

        if (ajustado) {
            System.out.println("✅ Tiempo estimado ajustado correctamente");
            System.out.println("Servicio ID: " + nuevaConfig.getIdServicio());
            System.out.println("Groomer ID: " + nuevaConfig.getIdGroomer());
            System.out.println("Nuevo tiempo: " + nuevaConfig.getTiempoEstimadoMin() + " minutos");
            System.out.println("\n⚠️  El procedimiento automáticamente:");
            System.out.println("- Actualiza si ya existe la configuración");
            System.out.println("- Crea una nueva configuración si no existe");
        } else {
            System.out.println("❌ Error al ajustar el tiempo estimado");
            System.out.println("Posibles causas:");
            System.out.println("- El servicio no existe");
            System.out.println("- El groomer no existe");
            System.out.println("- Error de conexión a la base de datos");
        }

        // Ejemplo de uso en planificación
        System.out.println("\n🚀 USO EN PLANIFICACIÓN:");
        System.out.println("=======================");
        System.out.println("Estas estimaciones se usan para:");
        System.out.println("- Programación de citas");
        System.out.println("- Asignación de groomers");
        System.out.println("- Cálculo de tiempos de espera");
        System.out.println("- Optimización de la cola de atención");

        // Mostrar cómo se verían los datos en la entidad ConfiguracionEstimacion
        System.out.println("\n💾 ESTRUCTURA DE DATOS:");
        System.out.println("======================");
        System.out.println("La tabla configuracion_estimacion contiene:");
        System.out.println("- id_config: Identificador único");
        System.out.println("- id_servicio: FK al servicio");
        System.out.println("- id_groomer: FK al groomer");
        System.out.println("- tiempo_estimado_min: Tiempo personalizado");
    }
}
