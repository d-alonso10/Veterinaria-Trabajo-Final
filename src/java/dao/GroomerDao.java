package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.TiempoPromedioGroomerDTO;
import modelo.OcupacionGroomerDTO;
import modelo.Groomer;
import modelo.GroomerDisponibilidadDTO;

public class GroomerDao {

    private Connection con;
    private CallableStatement cstmt;
    private ResultSet rs;
    private String url = "jdbc:mysql://localhost/vet_teran";
    private String user = "root";
    private String pass = "";

    public List<TiempoPromedioGroomerDTO> tiemposPromedioGroomer(java.sql.Date fechaInicio, java.sql.Date fechaFin) {
        List<TiempoPromedioGroomerDTO> tiempos = new ArrayList<>();

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_TiemposPromedioGroomer(?, ?)}");

            cstmt.setDate(1, fechaInicio);
            cstmt.setDate(2, fechaFin);

            rs = cstmt.executeQuery();

            while (rs.next()) {
                TiempoPromedioGroomerDTO tiempo = new TiempoPromedioGroomerDTO();
                tiempo.setNombreGroomer(rs.getString("nombre"));
                tiempo.setTotalAtenciones(rs.getInt("total_atenciones"));
                tiempo.setTiempoPromedioMinutos(rs.getDouble("tiempo_promedio_minutos"));
                tiempo.setTiempoMinimo(rs.getInt("tiempo_minimo"));
                tiempo.setTiempoMaximo(rs.getInt("tiempo_maximo"));

                tiempos.add(tiempo);
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
        return tiempos;
    }

    public List<OcupacionGroomerDTO> ocupacionGroomer(java.sql.Date fecha) {
        List<OcupacionGroomerDTO> ocupaciones = new ArrayList<>();

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_OcupacionGroomer(?)}");

            cstmt.setDate(1, fecha);

            rs = cstmt.executeQuery();

            while (rs.next()) {
                OcupacionGroomerDTO ocupacion = new OcupacionGroomerDTO();
                ocupacion.setNombreGroomer(rs.getString("nombre"));
                ocupacion.setAtencionesRealizadas(rs.getInt("atenciones_realizadas"));
                ocupacion.setMinutosTrabajados(rs.getInt("minutos_trabajados"));
                ocupacion.setPorcentajeOcupacion(rs.getDouble("porcentaje_ocupacion"));

                ocupaciones.add(ocupacion);
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
        return ocupaciones;
    }

    public int insertarGroomer(String nombre, String especialidades, String disponibilidad) {
        int idGroomerGenerado = -1;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_InsertarGroomer(?, ?, ?)}");

            cstmt.setString(1, nombre);
            cstmt.setString(2, especialidades);
            cstmt.setString(3, disponibilidad);

            boolean tieneResultados = cstmt.execute();

            if (tieneResultados) {
                rs = cstmt.getResultSet();
                if (rs.next()) {
                    idGroomerGenerado = rs.getInt("id_groomer");
                }
            }

        } catch (ClassNotFoundException e) {
            System.err.println("Error: Driver no encontrado");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Error en la operación SQL al insertar groomer");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error general al insertar groomer");
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
        return idGroomerGenerado;
    }

    public int insertarGroomer(Groomer groomer) {
        return insertarGroomer(
                groomer.getNombre(),
                groomer.getEspecialidades(),
                groomer.getDisponibilidad()
        );
    }

    public boolean actualizarGroomer(int idGroomer, String nombre, String especialidades, String disponibilidad) {
        boolean actualizado = false;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_ActualizarGroomer(?, ?, ?, ?)}");

            cstmt.setInt(1, idGroomer);
            cstmt.setString(2, nombre);
            cstmt.setString(3, especialidades);
            cstmt.setString(4, disponibilidad);

            int filasAfectadas = cstmt.executeUpdate();

            if (filasAfectadas > 0) {
                actualizado = true;
            }

        } catch (ClassNotFoundException e) {
            System.err.println("Error: Driver no encontrado");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Error en la operación SQL al actualizar groomer");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error general al actualizar groomer");
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
        return actualizado;
    }

    public boolean actualizarGroomer(Groomer groomer) {
        return actualizarGroomer(
                groomer.getIdGroomer(),
                groomer.getNombre(),
                groomer.getEspecialidades(),
                groomer.getDisponibilidad()
        );
    }

    public List<Groomer> obtenerGroomers() {
        List<Groomer> groomers = new ArrayList<>();

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_ObtenerGroomers()}");

            rs = cstmt.executeQuery();

            while (rs.next()) {
                Groomer groomer = new Groomer();
                groomer.setIdGroomer(rs.getInt("id_groomer"));
                groomer.setNombre(rs.getString("nombre"));
                groomer.setEspecialidades(rs.getString("especialidades"));
                groomer.setDisponibilidad(rs.getString("disponibilidad"));
                groomer.setCreatedAt(rs.getTimestamp("created_at"));

                groomers.add(groomer);
            }

        } catch (ClassNotFoundException e) {
            System.err.println("Error: Driver no encontrado");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Error en la operación SQL al obtener groomers");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error general al obtener groomers");
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
        return groomers;
    }

    public List<GroomerDisponibilidadDTO> obtenerDisponibilidadGroomers(java.sql.Date fecha) {
        List<GroomerDisponibilidadDTO> disponibilidad = new ArrayList<>();

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_ObtenerDisponibilidadGroomers(?)}");

            cstmt.setDate(1, fecha);

            rs = cstmt.executeQuery();

            while (rs.next()) {
                GroomerDisponibilidadDTO groomer = new GroomerDisponibilidadDTO();
                groomer.setIdGroomer(rs.getInt("id_groomer"));
                groomer.setNombre(rs.getString("nombre"));
                groomer.setDisponibilidad(rs.getString("disponibilidad"));
                groomer.setAtencionesProgramadas(rs.getInt("atenciones_programadas"));

                disponibilidad.add(groomer);
            }

        } catch (ClassNotFoundException e) {
            System.err.println("Error: Driver no encontrado");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Error en la operación SQL al obtener disponibilidad de groomers");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error general al obtener disponibilidad de groomers");
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
        return disponibilidad;
    }

    // Método main para probar solo el nuevo método agregado
    public static void main(String[] args) {
        GroomerDao groomerDAO = new GroomerDao();

        System.out.println("=== Probando sp_ObtenerDisponibilidadGroomers ===");

        // Probar con diferentes fechas
        java.sql.Date fechaHoy = new java.sql.Date(System.currentTimeMillis());
        java.sql.Date fechaManana = new java.sql.Date(System.currentTimeMillis() + (24 * 60 * 60 * 1000));
        java.sql.Date fechaPasada = java.sql.Date.valueOf("2025-01-15");

        java.sql.Date[] fechasPrueba = {fechaHoy, fechaManana, fechaPasada};

        for (java.sql.Date fecha : fechasPrueba) {
            System.out.println("\n" + crearLinea(60));
            System.out.println("📅 DISPONIBILIDAD DE GROOMERS - " + fecha);
            System.out.println(crearLinea(60));

            List<GroomerDisponibilidadDTO> disponibilidad = groomerDAO.obtenerDisponibilidadGroomers(fecha);

            if (disponibilidad.isEmpty()) {
                System.out.println("📭 No se encontraron groomers disponibles para esta fecha");
                System.out.println("💡 Sugerencia: Verifica que existan groomers registrados en el sistema");
            } else {
                System.out.println("✅ Se encontraron " + disponibilidad.size() + " groomer(s)");
                System.out.println("\n👥 DISPONIBILIDAD DEL DÍA:");
                System.out.println(crearLineaPunteada(40));

                int totalAtenciones = 0;
                int groomersDisponibles = 0;
                int groomersOcupados = 0;

                for (int i = 0; i < disponibilidad.size(); i++) {
                    GroomerDisponibilidadDTO groomer = disponibilidad.get(i);

                    String estado = groomer.getAtencionesProgramadas() == 0 ? "🟢 DISPONIBLE" : "🟡 OCUPADO";
                    String cargaTrabajo = groomer.getAtencionesProgramadas() + " atenciones programadas";

                    System.out.println((i + 1) + ". " + groomer.getNombre());
                    System.out.println("   🆔 ID: " + groomer.getIdGroomer());
                    System.out.println("   📊 Estado: " + estado);
                    System.out.println("   📋 Carga: " + cargaTrabajo);
                    System.out.println("   🕒 Disponibilidad: " + groomer.getDisponibilidad());

                    // Análisis de disponibilidad
                    if (groomer.getAtencionesProgramadas() == 0) {
                        groomersDisponibles++;
                        System.out.println("   💡 Recomendación: ✅ Ideal para nuevas citas");
                    } else if (groomer.getAtencionesProgramadas() <= 3) {
                        groomersOcupados++;
                        System.out.println("   💡 Recomendación: ⚠️  Carga moderada - aún disponible");
                    } else {
                        groomersOcupados++;
                        System.out.println("   💡 Recomendación: ❌ Alta carga - considerar otro groomer");
                    }

                    totalAtenciones += groomer.getAtencionesProgramadas();

                    if (i < disponibilidad.size() - 1) {
                        System.out.println("   ───────────────────────");
                    }
                }

                // Estadísticas del día
                System.out.println("\n📊 ESTADÍSTICAS DEL DÍA:");
                System.out.println(crearLineaPunteada(30));
                System.out.println("• Total groomers: " + disponibilidad.size());
                System.out.println("• Groomers disponibles: " + groomersDisponibles);
                System.out.println("• Groomers ocupados: " + groomersOcupados);
                System.out.println("• Total atenciones programadas: " + totalAtenciones);
                System.out.println("• Promedio atenciones por groomer: "
                        + (disponibilidad.size() > 0 ? totalAtenciones / disponibilidad.size() : 0));

                // Recomendaciones de asignación
                System.out.println("\n🎯 RECOMENDACIONES DE ASIGNACIÓN:");
                System.out.println(crearLineaPunteada(40));

                if (groomersDisponibles > 0) {
                    System.out.println("✅ Hay " + groomersDisponibles + " groomer(s) completamente disponible(s)");
                    System.out.println("💡 Asigna nuevas citas a estos groomers primero");
                }

                if (groomersOcupados > 0) {
                    System.out.println("⚠️  " + groomersOcupados + " groomer(s) tiene(n) atenciones programadas");
                    System.out.println("💡 Considera distribuir la carga equitativamente");
                }

                // Groomer más disponible
                GroomerDisponibilidadDTO groomerMasDisponible = null;
                for (GroomerDisponibilidadDTO g : disponibilidad) {
                    if (groomerMasDisponible == null || g.getAtencionesProgramadas() < groomerMasDisponible.getAtencionesProgramadas()) {
                        groomerMasDisponible = g;
                    }
                }

                if (groomerMasDisponible != null && groomerMasDisponible.getAtencionesProgramadas() == 0) {
                    System.out.println("\n🏆 GROOMER MÁS RECOMENDADO:");
                    System.out.println("• Nombre: " + groomerMasDisponible.getNombre());
                    System.out.println("• Disponibilidad: " + groomerMasDisponible.getDisponibilidad());
                    System.out.println("• Estado: Completamente disponible");
                }
            }
        }

        // Ejemplos de uso en aplicación real
        System.out.println("\n" + crearLinea(60));
        System.out.println("🚀 USOS PRÁCTICOS EN APLICACIÓN:");
        System.out.println(crearLinea(60));

        System.out.println("1. 📅 Programación de citas:");
        System.out.println("   - Mostrar groomers disponibles al crear nueva cita");
        System.out.println("   - Sugerir groomer con menor carga de trabajo");
        System.out.println("   - Evitar sobrecargar groomers específicos");

        System.out.println("\n2. 📱 App de groomers:");
        System.out.println("   - Ver agenda personal del día");
        System.out.println("   - Conocer carga de trabajo anticipada");
        System.out.println("   - Planificar tiempos entre atenciones");

        System.out.println("\n3. 💼 Gestión administrativa:");
        System.out.println("   - Distribuir equitativamente el trabajo");
        System.out.println("   - Identificar groomers sobrecargados");
        System.out.println("   - Optimizar recursos humanos");

        System.out.println("\n4. 📊 Reportes de productividad:");
        System.out.println("   - Analizar distribución de carga laboral");
        System.out.println("   - Identificar patrones de disponibilidad");
        System.out.println("   - Planificar contrataciones futuras");

        System.out.println("\n✅ Método sp_ObtenerDisponibilidadGroomers probado exitosamente");
    }

    // Métodos auxiliares para formato
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
