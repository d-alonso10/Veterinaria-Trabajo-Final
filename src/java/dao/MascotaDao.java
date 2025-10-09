package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.Mascota;
import modelo.HistorialMascotaDTO;
import modelo.MascotaBusquedaDTO;

public class MascotaDao {

    private Connection con;
    private CallableStatement cstmt;
    private ResultSet rs;
    private String url = "jdbc:mysql://localhost/vet_teran";
    private String user = "root";
    private String pass = "";

    public boolean insertarMascota(Mascota mascota) {
        boolean exito = false;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_InsertarMascota(?, ?, ?, ?, ?, ?, ?, ?)}");

            cstmt.setInt(1, mascota.getIdCliente());
            cstmt.setString(2, mascota.getNombre());
            cstmt.setString(3, mascota.getEspecie());
            cstmt.setString(4, mascota.getRaza());
            cstmt.setString(5, mascota.getSexo());
            cstmt.setDate(6, mascota.getFechaNacimiento());
            cstmt.setString(7, mascota.getMicrochip());
            cstmt.setString(8, mascota.getObservaciones());

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

    public List<Mascota> obtenerMascotasPorCliente(int idCliente) {
        List<Mascota> mascotas = new ArrayList<>();

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_ObtenerMascotasPorCliente(?)}");
            cstmt.setInt(1, idCliente);

            rs = cstmt.executeQuery();

            while (rs.next()) {
                Mascota mascota = new Mascota();
                mascota.setIdMascota(rs.getInt("id_mascota"));
                mascota.setNombre(rs.getString("nombre"));
                mascota.setEspecie(rs.getString("especie"));
                mascota.setRaza(rs.getString("raza"));
                mascota.setSexo(rs.getString("sexo"));
                mascota.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                mascota.setMicrochip(rs.getString("microchip"));

                mascotas.add(mascota);
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
        return mascotas;
    }

    public List<HistorialMascotaDTO> historialMascota(int idMascota) {
        List<HistorialMascotaDTO> historial = new ArrayList<>();

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_HistorialMascota(?)}");
            cstmt.setInt(1, idMascota);

            rs = cstmt.executeQuery();

            while (rs.next()) {
                HistorialMascotaDTO atencion = new HistorialMascotaDTO();
                atencion.setIdAtencion(rs.getInt("id_atencion"));
                atencion.setTiempoRealInicio(rs.getTimestamp("tiempo_real_inicio"));
                atencion.setTiempoRealFin(rs.getTimestamp("tiempo_real_fin"));
                atencion.setGroomer(rs.getString("groomer"));
                atencion.setSucursal(rs.getString("sucursal"));
                atencion.setServicios(rs.getString("servicios"));
                atencion.setMontoFacturado(rs.getDouble("monto_facturado"));

                historial.add(atencion);
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
        return historial;
    }

    public List<MascotaBusquedaDTO> buscarMascotas(String termino) {
        List<MascotaBusquedaDTO> mascotas = new ArrayList<>();

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_BuscarMascotas(?)}");

            cstmt.setString(1, termino);

            rs = cstmt.executeQuery();

            while (rs.next()) {
                MascotaBusquedaDTO mascota = new MascotaBusquedaDTO();
                mascota.setIdMascota(rs.getInt("id_mascota"));
                mascota.setNombre(rs.getString("nombre"));
                mascota.setEspecie(rs.getString("especie"));
                mascota.setRaza(rs.getString("raza"));
                mascota.setMicrochip(rs.getString("microchip"));
                mascota.setClienteNombre(rs.getString("cliente_nombre"));
                mascota.setClienteApellido(rs.getString("cliente_apellido"));

                mascotas.add(mascota);
            }

        } catch (ClassNotFoundException e) {
            System.err.println("Error: Driver no encontrado");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Error en la operación SQL al buscar mascotas");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error general al buscar mascotas");
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
        return mascotas;
    }
}
