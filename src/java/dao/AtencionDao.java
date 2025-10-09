package dao;

import java.sql.*;
import java.util.*;
import modelo.Atencion;
import modelo.ColaAtencionDTO;

public class AtencionDao {

    private Connection con;
    private CallableStatement cstmt;
    private ResultSet rs;
    private String url = "jdbc:mysql://localhost/vet_teran";
    private String user = "root";
    private String pass = "";

    public boolean crearAtencionWalkIn(Atencion atencion) {
        boolean exito = false;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_CrearAtencionWalkIn(?, ?, ?, ?, ?, ?, ?, ?, ?)}");

            cstmt.setInt(1, atencion.getIdMascota());
            cstmt.setInt(2, atencion.getIdCliente());
            cstmt.setInt(3, atencion.getIdGroomer());
            cstmt.setInt(4, atencion.getIdSucursal());
            cstmt.setInt(5, atencion.getTurnoNum());
            cstmt.setTimestamp(6, atencion.getTiempoEstimadoInicio());
            cstmt.setTimestamp(7, atencion.getTiempoEstimadoFin());
            cstmt.setInt(8, atencion.getPrioridad());
            cstmt.setString(9, atencion.getObservaciones());

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

    public boolean actualizarEstadoAtencion(int idAtencion, String nuevoEstado) {
        boolean exito = false;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            // Mapear estados de la aplicación a estados del SP
            String estadoSP = mapearEstadoParaSP(nuevoEstado);

            System.out.println("🔀 Mapeando estado: " + nuevoEstado + " -> " + estadoSP);

            cstmt = con.prepareCall("{CALL sp_ActualizarEstadoAtencion(?, ?)}");

            cstmt.setInt(1, idAtencion);
            cstmt.setString(2, estadoSP);

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

// Método para mapear estados de la app a estados del SP
    private String mapearEstadoParaSP(String estadoApp) {
        if (estadoApp == null) {
            return "en_espera";
        }

        switch (estadoApp.toLowerCase()) {
            case "pendiente":
                return "en_espera";
            case "en_proceso":
                return "en_servicio";
            case "completada":
                return "terminado";
            case "cancelada":
                return "pausado"; // O el estado que uses para cancelaciones
            default:
                return estadoApp;
        }
    }

    public List<ColaAtencionDTO> obtenerColaActual(Integer idSucursal) {
        List<ColaAtencionDTO> colaAtenciones = new ArrayList<>();

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_ObtenerColaActual(?)}");

            if (idSucursal != null) {
                cstmt.setInt(1, idSucursal);
            } else {
                cstmt.setNull(1, Types.INTEGER);
            }

            rs = cstmt.executeQuery();

            while (rs.next()) {
                ColaAtencionDTO atencionCola = new ColaAtencionDTO();
                atencionCola.setIdAtencion(rs.getInt("id_atencion"));
                atencionCola.setMascota(rs.getString("mascota"));
                atencionCola.setCliente(rs.getString("cliente"));
                atencionCola.setGroomer(rs.getString("groomer"));
                atencionCola.setEstado(rs.getString("estado"));
                atencionCola.setTurnoNum(rs.getInt("turno_num"));
                atencionCola.setTiempoEstimadoInicio(rs.getTimestamp("tiempo_estimado_inicio"));
                atencionCola.setTiempoEstimadoFin(rs.getTimestamp("tiempo_estimado_fin"));

                colaAtenciones.add(atencionCola);
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
        return colaAtenciones;
    }

    public static void main(String[] args) {
        AtencionDao atencionDAO = new AtencionDao();

        System.out.println("=== Probando sp_ObtenerColaActual ===");

        System.out.println("\n--- Cola de todas las sucursales ---");
        List<ColaAtencionDTO> colaGeneral = atencionDAO.obtenerColaActual(null);

        if (colaGeneral.isEmpty()) {
            System.out.println("No hay atenciones en cola para ninguna sucursal");
        } else {
            System.out.println("COLA GENERAL - TOTAL: " + colaGeneral.size() + " atenciones");
            System.out.println("==================================");

            for (ColaAtencionDTO atencion : colaGeneral) {
                System.out.println("Turno: " + atencion.getTurnoNum() + " | "
                        + "Mascota: " + atencion.getMascota() + " | "
                        + "Cliente: " + atencion.getCliente() + " | "
                        + "Groomer: " + atencion.getGroomer() + " | "
                        + "Estado: " + atencion.getEstado() + " | "
                        + "Inicio estimado: " + atencion.getTiempoEstimadoInicio());
            }
        }

        System.out.println("\n--- Cola de sucursal específica (ID 1) ---");
        List<ColaAtencionDTO> colaSucursal = atencionDAO.obtenerColaActual(1);

        if (colaSucursal.isEmpty()) {
            System.out.println("No hay atenciones en cola para la sucursal ID 1");
        } else {
            System.out.println("COLA SUCURSAL ID 1 - TOTAL: " + colaSucursal.size() + " atenciones");
            System.out.println("==========================================");

            for (ColaAtencionDTO atencion : colaSucursal) {
                System.out.println("Turno: " + atencion.getTurnoNum() + " | "
                        + "Mascota: " + atencion.getMascota() + " | "
                        + "Cliente: " + atencion.getCliente() + " | "
                        + "Groomer: " + atencion.getGroomer() + " | "
                        + "Estado: " + atencion.getEstado());
            }
        }
    }
}
