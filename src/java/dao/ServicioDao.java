package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import modelo.Servicio;
import modelo.ServicioMasSolicitadoDTO;

public class ServicioDao {
    
    private Connection con;
    private CallableStatement cstmt;
    private ResultSet rs;
    
    // AGREGAR PARÁMETROS DE CONEXIÓN CON CODIFICACIÓN UTF-8
    private String url = "jdbc:mysql://localhost/vet_teran?useUnicode=true&characterEncoding=UTF-8";
    private String user = "root";
    private String pass = "";

    // Lista de categorías válidas según el ENUM del procedimiento almacenado
    private static final List<String> CATEGORIAS_VALIDAS = Arrays.asList(
        "baño", "corte", "dental", "paquete", "otro"
    );

    public List<ServicioMasSolicitadoDTO> serviciosMasSolicitados(java.sql.Date fechaInicio, java.sql.Date fechaFin) {
        List<ServicioMasSolicitadoDTO> servicios = new ArrayList<>();
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_ServiciosMasSolicitados(?, ?)}");
            
            cstmt.setDate(1, fechaInicio);
            cstmt.setDate(2, fechaFin);
            
            rs = cstmt.executeQuery();

            while (rs.next()) {
                ServicioMasSolicitadoDTO servicio = new ServicioMasSolicitadoDTO();
                servicio.setNombre(rs.getString("nombre"));
                servicio.setCategoria(rs.getString("categoria"));
                servicio.setVecesSolicitado(rs.getInt("veces_solicitado"));
                servicio.setCantidadTotal(rs.getInt("cantidad_total"));
                servicio.setIngresosGenerados(rs.getDouble("ingresos_generados"));
                
                servicios.add(servicio);
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
        return servicios;
    }

    // MÉTODO: Convertir categoría para la base de datos - CORREGIDO
    private String convertirCategoriaParaBD(String categoria) {
        if (categoria == null) return null;
        
        String categoriaNormalizada = categoria.toLowerCase().trim();
        
        // EL PROCEDIMIENTO ESPERA 'baño' CON Ñ, NO CONVERTIR A 'bano'
        // Validar que la categoría sea una de las permitidas por el ENUM
        if (CATEGORIAS_VALIDAS.contains(categoriaNormalizada)) {
            return categoriaNormalizada;
        }
        
        System.err.println("❌ ERROR: Categoría '" + categoria + "' no es válida.");
        System.err.println("✅ CATEGORÍAS VÁLIDAS: baño, corte, dental, paquete, otro");
        return null;
    }

    // MÉTODO: Convertir categoría para mostrar en interfaz - CORREGIDO
    public String convertirCategoriaParaInterfaz(String categoriaBD) {
        if (categoriaBD == null) return null;
        
        // Las categorías ya vienen correctas desde la BD
        return categoriaBD;
    }

    // MÉTODO: Obtener categorías válidas para interfaz - CORREGIDO
    public String[] obtenerCategoriasParaInterfaz() {
        return CATEGORIAS_VALIDAS.toArray(new String[0]);
    }

    // MÉTODO: Insertar servicio - CORREGIDO
    public int insertarServicio(Servicio servicio) {
        // Convertir categoría para BD
        String categoriaBD = convertirCategoriaParaBD(servicio.getCategoria());
        
        if (categoriaBD == null) {
            System.err.println("❌ ERROR: Categoría '" + servicio.getCategoria() + "' no es válida.");
            System.err.println("✅ CATEGORÍAS VÁLIDAS: baño, corte, dental, paquete, otro");
            return -1;
        }
        
        int idServicio = -1;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);
            
            cstmt = con.prepareCall("{CALL sp_InsertarServicio(?, ?, ?, ?, ?, ?)}");
            
            cstmt.setString(1, servicio.getCodigo());
            cstmt.setString(2, servicio.getNombre());
            cstmt.setString(3, servicio.getDescripcion());
            cstmt.setInt(4, servicio.getDuracionEstimadaMin());
            cstmt.setDouble(5, servicio.getPrecioBase());
            cstmt.setString(6, categoriaBD); // Usar categoría convertida
            
            // Ejecutar y obtener el resultado
            boolean tieneResultados = cstmt.execute();
            
            if (tieneResultados) {
                rs = cstmt.getResultSet();
                if (rs.next()) {
                    idServicio = rs.getInt("id_servicio");
                }
            }
            
            if (idServicio != -1) {
                System.out.println("✅ Servicio insertado correctamente con ID: " + idServicio);
                System.out.println("   Categoría en BD: '" + categoriaBD + "'");
            }
            
        } catch (SQLException e) {
            System.err.println("❌ ERROR SQL al insertar servicio:");
            System.err.println("   Mensaje: " + e.getMessage());
            System.err.println("   SQL State: " + e.getSQLState());
            System.err.println("   Error Code: " + e.getErrorCode());
            e.printStackTrace();
            
        } catch (Exception e) {
            System.err.println("❌ Error general al insertar servicio");
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
        return idServicio;
    }

    // MÉTODO: Obtener todos los servicios - CORREGIDO
    public List<Servicio> obtenerServicios() {
        List<Servicio> servicios = new ArrayList<>();
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_ObtenerServicios()}");
            
            rs = cstmt.executeQuery();

            while (rs.next()) {
                Servicio servicio = new Servicio();
                servicio.setIdServicio(rs.getInt("id_servicio"));
                servicio.setCodigo(rs.getString("codigo"));
                servicio.setNombre(rs.getString("nombre"));
                servicio.setDescripcion(rs.getString("descripcion"));
                servicio.setDuracionEstimadaMin(rs.getInt("duracion_estimada_min"));
                servicio.setPrecioBase(rs.getDouble("precio_base"));
                
                // Convertir categoría de BD para interfaz - USAR MÉTODO CORREGIDO
                String categoriaBD = rs.getString("categoria");
                servicio.setCategoria(convertirCategoriaParaInterfaz(categoriaBD));
                
                servicio.setCreatedAt(rs.getTimestamp("created_at"));
                
                servicios.add(servicio);
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
        return servicios;
    }

    // MÉTODO: Actualizar un servicio existente - COMPLETAMENTE CORREGIDO
    public boolean actualizarServicio(int idServicio, String codigo, String nombre, String descripcion, 
                                     int duracionEstimadaMin, double precioBase, String categoria) {
        // Convertir categoría para BD
        String categoriaBD = convertirCategoriaParaBD(categoria);
        
        System.out.println("=== 🔄 DAO - INICIANDO ACTUALIZACIÓN ===");
        System.out.println("📥 Parámetros recibidos en DAO:");
        System.out.println("   idServicio: " + idServicio);
        System.out.println("   codigo: '" + codigo + "'");
        System.out.println("   nombre: '" + nombre + "'");
        System.out.println("   descripcion: '" + descripcion + "'");
        System.out.println("   duracionEstimadaMin: " + duracionEstimadaMin);
        System.out.println("   precioBase: " + precioBase);
        System.out.println("   categoria: '" + categoria + "'");
        System.out.println("   categoriaBD: '" + categoriaBD + "'");
        
        if (categoriaBD == null) {
            System.err.println("❌ ERROR: Categoría '" + categoria + "' no es válida.");
            System.err.println("✅ CATEGORÍAS VÁLIDAS: baño, corte, dental, paquete, otro");
            return false;
        }
        
        boolean actualizado = false;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            System.out.println("📡 Ejecutando CALL sp_ActualizarServicio con parámetros:");
            System.out.println("   p_id_servicio: " + idServicio);
            System.out.println("   p_codigo: '" + codigo + "'");
            System.out.println("   p_nombre: '" + nombre + "'");
            System.out.println("   p_descripcion: '" + descripcion + "'");
            System.out.println("   p_duracion_estimada_min: " + duracionEstimadaMin);
            System.out.println("   p_precio_base: " + precioBase);
            System.out.println("   p_categoria: '" + categoriaBD + "'");

            cstmt = con.prepareCall("{CALL sp_ActualizarServicio(?, ?, ?, ?, ?, ?, ?)}");
            
            // Establecer parámetros
            cstmt.setInt(1, idServicio);
            cstmt.setString(2, codigo);
            cstmt.setString(3, nombre);
            cstmt.setString(4, descripcion);
            cstmt.setInt(5, duracionEstimadaMin);
            cstmt.setDouble(6, precioBase);
            cstmt.setString(7, categoriaBD);
            
            // Ejecutar el procedimiento almacenado
            int filasAfectadas = cstmt.executeUpdate();
            
            System.out.println("📊 Filas afectadas por la actualización: " + filasAfectadas);
            
            // Verificar si se actualizó correctamente
            if (filasAfectadas > 0) {
                actualizado = true;
                System.out.println("✅ Servicio actualizado exitosamente!");
                System.out.println("   ID: " + idServicio);
                System.out.println("   Categoría en BD: '" + categoriaBD + "'");
            } else {
                System.out.println("⚠️  No se encontró el servicio con ID: " + idServicio);
                System.out.println("💡 Posibles causas:");
                System.out.println("   - El ID no existe en la base de datos");
                System.out.println("   - Los datos son iguales a los existentes (0 filas cambiadas)");
            }

        } catch (ClassNotFoundException e) {
            System.err.println("❌ Error: Driver no encontrado");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("❌ ERROR SQL al actualizar servicio:");
            System.err.println("   Mensaje: " + e.getMessage());
            System.err.println("   SQL State: " + e.getSQLState());
            System.err.println("   Error Code: " + e.getErrorCode());
            e.printStackTrace();
            
            if (e.getMessage().contains("Data truncated")) {
                System.err.println("🔍 PROBLEMA DE CODIFICACIÓN DETECTADO");
                System.err.println("   La categoría enviada no coincide con el ENUM");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error general al actualizar servicio");
            e.printStackTrace();
        } finally {
            try {
                if (cstmt != null) cstmt.close();
                if (con != null) con.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        
        System.out.println("=== " + (actualizado ? "✅" : "❌") + " DAO - ACTUALIZACIÓN FINALIZADA ===");
        return actualizado;
    }

    // Método sobrecargado para actualizar usando objeto Servicio - CORREGIDO
    public boolean actualizarServicio(Servicio servicio) {
        // Validar que el objeto servicio no sea nulo
        if (servicio == null) {
            System.err.println("❌ ERROR: El objeto Servicio no puede ser nulo");
            return false;
        }
        
        // Llamar al método principal sin imprimir mensajes adicionales
        return actualizarServicio(
            servicio.getIdServicio(),
            servicio.getCodigo(),
            servicio.getNombre(),
            servicio.getDescripcion(),
            servicio.getDuracionEstimadaMin(),
            servicio.getPrecioBase(),
            servicio.getCategoria()
        );
    }

    // MÉTODO: Obtener servicios por categoría - CORREGIDO
    public List<Servicio> obtenerServiciosPorCategoria(String categoria) {
        List<Servicio> servicios = new ArrayList<>();
        
        // Convertir categoría para BD
        String categoriaBD = convertirCategoriaParaBD(categoria);
        
        if (categoriaBD == null) {
            System.err.println("❌ ERROR: Categoría '" + categoria + "' no es válida.");
            System.err.println("✅ CATEGORÍAS VÁLIDAS: baño, corte, dental, paquete, otro");
            return servicios; // Retorna lista vacía
        }
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_ObtenerServiciosPorCategoria(?)}");
            
            cstmt.setString(1, categoriaBD);
            
            rs = cstmt.executeQuery();

            while (rs.next()) {
                Servicio servicio = new Servicio();
                servicio.setIdServicio(rs.getInt("id_servicio"));
                servicio.setCodigo(rs.getString("codigo"));
                servicio.setNombre(rs.getString("nombre"));
                servicio.setDescripcion(rs.getString("descripcion"));
                servicio.setDuracionEstimadaMin(rs.getInt("duracion_estimada_min"));
                servicio.setPrecioBase(rs.getDouble("precio_base"));
                
                // Convertir categoría de BD para interfaz
                servicio.setCategoria(convertirCategoriaParaInterfaz(categoriaBD));
                
                servicio.setCreatedAt(rs.getTimestamp("created_at"));
                
                servicios.add(servicio);
            }

        } catch (ClassNotFoundException e) {
            System.err.println("Error: Driver no encontrado");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Error en la operación SQL al obtener servicios por categoría");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error general al obtener servicios por categoría");
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
}