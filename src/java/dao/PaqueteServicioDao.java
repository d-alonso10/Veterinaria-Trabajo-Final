package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.PaqueteServicio;
import modelo.PaqueteServicioItem;

public class PaqueteServicioDao {
    
    private Connection con;
    private CallableStatement cstmt;
    private ResultSet rs;
    private String url = "jdbc:mysql://localhost/vet_teran";
    private String user = "root";
    private String pass = "";

    public int crearPaqueteServicio(PaqueteServicio paquete) {
        int idPaquete = -1;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);
            
            cstmt = con.prepareCall("{CALL sp_CrearPaqueteServicio(?, ?, ?)}");
            
            cstmt.setString(1, paquete.getNombre());
            cstmt.setString(2, paquete.getDescripcion());
            cstmt.setDouble(3, paquete.getPrecioTotal());
            
            // Ejecutar y obtener el resultado
            boolean tieneResultados = cstmt.execute();
            
            if (tieneResultados) {
                rs = cstmt.getResultSet();
                if (rs.next()) {
                    idPaquete = rs.getInt("id_paquete");
                }
            }
            
        } catch (Exception e) {
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
        return idPaquete;
    }

    // NUEVO MÉTODO: Agregar servicio a paquete
    public boolean agregarServicioPaquete(PaqueteServicioItem item) {
        boolean exito = false;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);
            
            cstmt = con.prepareCall("{CALL sp_AgregarServicioPaquete(?, ?, ?)}");
            
            cstmt.setInt(1, item.getIdPaquete());
            cstmt.setInt(2, item.getIdServicio());
            cstmt.setInt(3, item.getCantidad());
            
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

    // MÉTODO: Obtener paquete por ID
    public PaqueteServicio obtenerPaquetePorId(int idPaquete) {
        PaqueteServicio paquete = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, pass);
            
            String sql = "SELECT * FROM paquete_servicio WHERE id_paquete = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, idPaquete);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                paquete = new PaqueteServicio();
                paquete.setIdPaquete(rs.getInt("id_paquete"));
                paquete.setNombre(rs.getString("nombre"));
                paquete.setDescripcion(rs.getString("descripcion"));
                paquete.setPrecioTotal(rs.getDouble("precio_total"));
                paquete.setCreatedAt(rs.getTimestamp("created_at"));
                paquete.setUpdatedAt(rs.getTimestamp("updated_at"));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return paquete;
    }

    // MÉTODO: Verificar si un servicio ya está en el paquete
    public boolean servicioYaEnPaquete(int idPaquete, int idServicio) {
        boolean existe = false;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, pass);
            
            String sql = "SELECT COUNT(*) as existe FROM paquete_servicio_item WHERE id_paquete = ? AND id_servicio = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, idPaquete);
            pstmt.setInt(2, idServicio);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                existe = rs.getInt("existe") > 0;
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return existe;
    }

    // MÉTODO: Listar todos los paquetes de servicios
    public List<PaqueteServicio> listarPaquetesServicio() {
        List<PaqueteServicio> paquetes = new ArrayList<>();
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);
            
            cstmt = con.prepareCall("{CALL sp_ListarPaquetesServicio()}");
            
            rs = cstmt.executeQuery();
            
            while (rs.next()) {
                PaqueteServicio paquete = new PaqueteServicio();
                paquete.setIdPaquete(rs.getInt("id_paquete"));
                paquete.setNombre(rs.getString("nombre"));
                paquete.setDescripcion(rs.getString("descripcion"));
                paquete.setPrecioTotal(rs.getDouble("precio_total"));
                paquete.setCreatedAt(rs.getTimestamp("created_at"));
                paquete.setUpdatedAt(rs.getTimestamp("updated_at"));
                
                paquetes.add(paquete);
            }
            
        } catch (Exception e) {
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
        return paquetes;
    }

    // MÉTODO: Obtener servicios de un paquete
    public List<PaqueteServicioItem> obtenerServiciosPaquete(int idPaquete) {
        List<PaqueteServicioItem> servicios = new ArrayList<>();
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);
            
            cstmt = con.prepareCall("{CALL sp_ObtenerServiciosPaquete(?)}");
            cstmt.setInt(1, idPaquete);
            
            rs = cstmt.executeQuery();
            
            while (rs.next()) {
                PaqueteServicioItem item = new PaqueteServicioItem();
                item.setIdPaquete(rs.getInt("id_paquete"));
                item.setIdServicio(rs.getInt("id_servicio"));
                item.setCantidad(rs.getInt("cantidad"));
                
                // Datos adicionales del servicio
                item.setNombreServicio(rs.getString("nombre_servicio"));
                item.setPrecioUnitario(rs.getDouble("precio_base"));
                item.setDuracionMinutos(rs.getInt("duracion_estimada_min"));
                
                servicios.add(item);
            }
            
        } catch (Exception e) {
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
        return servicios;
    }

    // MÉTODO: Actualizar paquete de servicio
    public boolean actualizarPaqueteServicio(int idPaquete, String nombre, String descripcion, double precioTotal, String estado) {
        boolean exito = false;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);
            
            cstmt = con.prepareCall("{CALL sp_ActualizarPaqueteServicio(?, ?, ?, ?, ?)}");
            
            cstmt.setInt(1, idPaquete);
            cstmt.setString(2, nombre);
            cstmt.setString(3, descripcion);
            cstmt.setDouble(4, precioTotal);
            cstmt.setString(5, estado);
            
            int filasAfectadas = cstmt.executeUpdate();
            exito = (filasAfectadas > 0);
            
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

    // MÉTODO: Eliminar paquete de servicio
    public boolean eliminarPaqueteServicio(int idPaquete) {
        boolean exito = false;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);
            
            cstmt = con.prepareCall("{CALL sp_EliminarPaqueteServicio(?)}");
            cstmt.setInt(1, idPaquete);
            
            int filasAfectadas = cstmt.executeUpdate();
            exito = (filasAfectadas > 0);
            
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

    // MÉTODO: Eliminar servicio de un paquete
    public boolean eliminarServicioPaquete(int idPaquete, int idServicio) {
        boolean exito = false;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);
            
            cstmt = con.prepareCall("{CALL sp_EliminarServicioPaquete(?, ?)}");
            cstmt.setInt(1, idPaquete);
            cstmt.setInt(2, idServicio);
            
            int filasAfectadas = cstmt.executeUpdate();
            exito = (filasAfectadas > 0);
            
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

    // MÉTODO: Buscar paquetes de servicios con filtros
    public List<PaqueteServicio> buscarPaquetesServicio(String termino, String estado, double precioMin, double precioMax) {
        List<PaqueteServicio> paquetes = new ArrayList<>();
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);
            
            cstmt = con.prepareCall("{CALL sp_BuscarPaquetesServicio(?, ?, ?, ?)}");
            
            cstmt.setString(1, termino);
            cstmt.setString(2, estado);
            cstmt.setDouble(3, precioMin);
            cstmt.setDouble(4, precioMax);
            
            rs = cstmt.executeQuery();
            
            while (rs.next()) {
                PaqueteServicio paquete = new PaqueteServicio();
                paquete.setIdPaquete(rs.getInt("id_paquete"));
                paquete.setNombre(rs.getString("nombre"));
                paquete.setDescripcion(rs.getString("descripcion"));
                paquete.setPrecioTotal(rs.getDouble("precio_total"));
                paquete.setCreatedAt(rs.getTimestamp("created_at"));
                paquete.setUpdatedAt(rs.getTimestamp("updated_at"));
                
                paquetes.add(paquete);
            }
            
        } catch (Exception e) {
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
        return paquetes;
    }
}