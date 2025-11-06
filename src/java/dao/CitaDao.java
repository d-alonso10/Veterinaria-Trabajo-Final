package dao;

import java.sql.*;
import java.util.*;
import modelo.Cita;
import modelo.CitaProximaDTO;

public class CitaDao {

    // --- CORRECCIÓN: Propiedades de conexión ---
    private String url = "jdbc:mysql://localhost/vet_teran";
    private String user = "root";
    private String pass = ""; // Asegúrate que esta sea tu contraseña

    /**
     * CORRECCIÓN: Método centralizado para obtener conexión
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
     * CORRECCIÓN: Método centralizado para cerrar recursos
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
     * CORRECCIÓN: Método refactorizado con manejo de recursos
     */
    public boolean crearCita(Cita cita) {
        boolean exito = false;
        Connection con = null;
        CallableStatement cstmt = null;
        // ResultSet (rs) no es necesario aquí, el SP no devuelve uno
        
        try {
            con = getConnection();
            cstmt = con.prepareCall("{CALL sp_CrearCita(?, ?, ?, ?, ?, ?, ?)}");

            cstmt.setInt(1, cita.getIdMascota());
            cstmt.setInt(2, cita.getIdCliente());
            cstmt.setInt(3, cita.getIdSucursal());
            cstmt.setInt(4, cita.getIdServicio());
            cstmt.setTimestamp(5, cita.getFechaProgramada());
            cstmt.setString(6, cita.getModalidad());
            cstmt.setString(7, cita.getNotas());

            int filasAfectadas = cstmt.executeUpdate();
            if (filasAfectadas > 0) {
                exito = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(con, cstmt, null); // Cierra con y cstmt
        }
        return exito;
    }

    /**
     * CORRECCIÓN: Método refactorizado con manejo de recursos
     */
    public boolean reprogramarCita(int idCita, java.sql.Timestamp nuevaFecha) {
        boolean exito = false;
        Connection con = null;
        CallableStatement cstmt = null;
        
        try {
            con = getConnection();
            cstmt = con.prepareCall("{CALL sp_ReprogramarCita(?, ?)}");

            cstmt.setInt(1, idCita);
            cstmt.setTimestamp(2, nuevaFecha);

            int filasAfectadas = cstmt.executeUpdate();
            if (filasAfectadas > 0) {
                exito = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(con, cstmt, null);
        }
        return exito;
    }

    /**
     * CORRECCIÓN: Método refactorizado con manejo de recursos
     */
    public boolean cancelarCita(int idCita) {
        boolean exito = false;
        Connection con = null;
        CallableStatement cstmt = null;
        
        try {
            con = getConnection();
            cstmt = con.prepareCall("{CALL sp_CancelarCita(?)}");

            cstmt.setInt(1, idCita);

            int filasAfectadas = cstmt.executeUpdate();
            if (filasAfectadas > 0) {
                exito = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(con, cstmt, null);
        }
        return exito;
    }

    /**
     * CORRECCIÓN: Método refactorizado con manejo de recursos
     */
    public boolean confirmarAsistenciaCita(int idCita) {
        boolean exito = false;
        Connection con = null;
        CallableStatement cstmt = null;
        
        try {
            con = getConnection();
            cstmt = con.prepareCall("{CALL sp_ConfirmarAsistenciaCita(?)}");

            cstmt.setInt(1, idCita);

            int filasAfectadas = cstmt.executeUpdate();
            if (filasAfectadas > 0) {
                exito = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(con, cstmt, null);
        }
        return exito;
    }

    /**
     * CORRECCIÓN: Método refactorizado con manejo de recursos
     */
    public List<CitaProximaDTO> obtenerProximasCitas(int idCliente) {
        List<CitaProximaDTO> proximasCitas = new ArrayList<>();
        Connection con = null;
        CallableStatement cstmt = null;
        ResultSet rs = null;
        
        try {
            con = getConnection();
            cstmt = con.prepareCall("{CALL sp_ObtenerProximasCitas(?)}");
            cstmt.setInt(1, idCliente);

            rs = cstmt.executeQuery();

            while (rs.next()) {
                CitaProximaDTO cita = new CitaProximaDTO();
                cita.setIdCita(rs.getInt("id_cita"));
                cita.setFechaProgramada(rs.getTimestamp("fecha_programada"));
                cita.setMascota(rs.getString("mascota"));
                cita.setServicio(rs.getString("servicio"));
                cita.setEstado(rs.getString("estado"));
                cita.setModalidad(rs.getString("modalidad"));

                proximasCitas.add(cita);
            }

        } catch (Exception e) {
            System.err.println("Error en la operación SQL");
            e.printStackTrace();
        } finally {
            closeResources(con, cstmt, rs); // Cierra todo
        }
        return proximasCitas;
    }

    /**
     * CORRECCIÓN: Método refactorizado con manejo de recursos
     */
    public boolean crearAtencionDesdeCita(int idCita, int idGroomer, int idSucursal,
            int turnoNum, java.sql.Timestamp tiempoEstimadoInicio,
            java.sql.Timestamp tiempoEstimadoFin, int prioridad) {
        
        boolean exito = false;
        Connection con = null;
        CallableStatement cstmt = null;
        
        try {
            con = getConnection();
            cstmt = con.prepareCall("{CALL sp_CrearAtencionDesdeCita(?, ?, ?, ?, ?, ?, ?)}");

            cstmt.setInt(1, idCita);
            cstmt.setInt(2, idGroomer);
            cstmt.setInt(3, idSucursal);
            cstmt.setInt(4, turnoNum);
            cstmt.setTimestamp(5, tiempoEstimadoInicio);
            cstmt.setTimestamp(6, tiempoEstimadoFin);
            cstmt.setInt(7, prioridad);

            int filasAfectadas = cstmt.executeUpdate();
            if (filasAfectadas > 0) {
                exito = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(con, cstmt, null);
        }
        return exito;
    }

    /**
     * CORRECCIÓN: Método refactorizado con manejo de recursos
     * (Se mantienen los logs de depuración)
     */
    public List<CitaProximaDTO> obtenerTodasProximasCitas() {
        List<CitaProximaDTO> proximasCitas = new ArrayList<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        PreparedStatement pstmtTest = null; // Statement separado para la prueba
        ResultSet rsTest = null; // ResultSet separado para la prueba

        try {
            System.out.println("=== INICIANDO obtenerTodasProximasCitas ===");
            System.out.println("📍 URL: " + url);
            System.out.println("📍 User: " + user);

            con = getConnection();
            System.out.println("✅ Conexión establecida");

            // PRIMERO: Hacer una consulta simple de prueba
            System.out.println("=== CONSULTA SIMPLE DE PRUEBA ===");
            String testSql = "SELECT COUNT(*) as total FROM cita WHERE estado IN ('reservada', 'confirmada')";
            pstmtTest = con.prepareStatement(testSql);
            rsTest = pstmtTest.executeQuery();
            if (rsTest.next()) {
                int total = rsTest.getInt("total");
                System.out.println("📊 Citas con estado válido en BD: " + total);
            }
            // Importante cerrar estos recursos de prueba para no interferir
            rsTest.close();
            pstmtTest.close();

            // SEGUNDO: Consulta completa con JOINs
            System.out.println("=== CONSULTA COMPLETA ===");
            String sql = "SELECT c.id_cita, c.fecha_programada, " +
                         "COALESCE(m.nombre, 'Sin mascota') as mascota, " +
                         "COALESCE(s.nombre, 'Sin servicio') as servicio, " +
                         "c.estado, c.modalidad " +
                         "FROM cita c " +
                         "LEFT JOIN mascota m ON c.id_mascota = m.id_mascota " +
                         "LEFT JOIN servicio s ON c.id_servicio = s.id_servicio " +
                         "WHERE c.estado IN ('reservada', 'confirmada') " +
                         "ORDER BY c.fecha_programada ASC";

            System.out.println("📝 Ejecutando SQL: " + sql);

            pstmt = con.prepareStatement(sql);
            rs = pstmt.executeQuery();

            int rowCount = 0;
            while (rs.next()) {
                rowCount++;
                CitaProximaDTO cita = new CitaProximaDTO();
                cita.setIdCita(rs.getInt("id_cita"));
                cita.setFechaProgramada(rs.getTimestamp("fecha_programada"));
                cita.setMascota(rs.getString("mascota"));
                cita.setServicio(rs.getString("servicio"));
                cita.setEstado(rs.getString("estado"));
                cita.setModalidad(rs.getString("modalidad"));

                proximasCitas.add(cita);

                System.out.println("📋 Cita " + rowCount + ": ID=" + cita.getIdCita()
                        + ", Estado=" + cita.getEstado()
                        + ", Mascota=" + cita.getMascota()
                        + ", Servicio=" + cita.getServicio());
            }

            System.out.println("✅ Consulta completada. Filas encontradas: " + rowCount);

        } catch (Exception e) {
            System.err.println("❌ ERROR en obtenerTodasProximasCitas: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // CORRECCIÓN: Cierra todos los recursos. 
            // Los de prueba (rsTest, pstmtTest) ya se cerraron.
            closeResources(con, pstmt, rs);
            System.out.println("✅ Recursos liberados");
        }

        System.out.println("=== FINALIZANDO obtenerTodasProximasCitas - Total: " + proximasCitas.size() + " ===");
        return proximasCitas;
    }
}