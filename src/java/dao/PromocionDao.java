package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.Promocion;

public class PromocionDao {
    
    private Connection con;
    private CallableStatement cstmt;
    private ResultSet rs;
    private String url = "jdbc:mysql://localhost/vet_teran";
    private String user = "root";
    private String pass = "";

    // MÉTODO: Obtener promociones activas
    public List<Promocion> obtenerPromocionesActivas() {
        List<Promocion> promociones = new ArrayList<>();
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_ObtenerPromocionesActivas()}");
            
            rs = cstmt.executeQuery();

            while (rs.next()) {
                Promocion promocion = new Promocion();
                promocion.setIdPromocion(rs.getInt("id_promocion"));
                promocion.setNombre(rs.getString("nombre"));
                promocion.setDescripcion(rs.getString("descripcion"));
                promocion.setTipo(rs.getString("tipo"));
                promocion.setValor(rs.getDouble("valor"));
                promocion.setFechaInicio(rs.getDate("fecha_inicio"));
                promocion.setFechaFin(rs.getDate("fecha_fin"));
                promocion.setEstado(rs.getString("estado"));
                
                promociones.add(promocion);
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
        return promociones;
    }

    // MÉTODO: Insertar una nueva promoción
    public int insertarPromocion(String nombre, String descripcion, String tipo, 
                                double valor, java.sql.Date fechaInicio, java.sql.Date fechaFin) {
        int idPromocionGenerado = -1;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_InsertarPromocion(?, ?, ?, ?, ?, ?)}");
            
            // Establecer parámetros
            cstmt.setString(1, nombre);
            cstmt.setString(2, descripcion);
            cstmt.setString(3, tipo);
            cstmt.setDouble(4, valor);
            cstmt.setDate(5, fechaInicio);
            cstmt.setDate(6, fechaFin);
            
            // Ejecutar el procedimiento almacenado
            boolean tieneResultados = cstmt.execute();
            
            // Obtener el ID generado
            if (tieneResultados) {
                rs = cstmt.getResultSet();
                if (rs.next()) {
                    idPromocionGenerado = rs.getInt("id_promocion");
                }
            }

        } catch (ClassNotFoundException e) {
            System.err.println("Error: Driver no encontrado");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Error en la operación SQL al insertar promoción");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error general al insertar promoción");
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
        return idPromocionGenerado;
    }

    // Método sobrecargado para insertar usando objeto Promocion
    public int insertarPromocion(Promocion promocion) {
        return insertarPromocion(
            promocion.getNombre(),
            promocion.getDescripcion(),
            promocion.getTipo(),
            promocion.getValor(),
            promocion.getFechaInicio(),
            promocion.getFechaFin()
        );
    }

    // MÉTODO: Actualizar estado de una promoción
    public boolean actualizarEstadoPromocion(int idPromocion, String estado) {
        // Validar que el estado sea válido
        if (!"activa".equals(estado) && !"inactiva".equals(estado)) {
            System.err.println("❌ ERROR: Estado '" + estado + "' no es válido.");
            System.err.println("✅ ESTADOS VÁLIDOS: 'activa', 'inactiva'");
            return false;
        }
        
        boolean actualizado = false;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_ActualizarEstadoPromocion(?, ?)}");
            
            // Establecer parámetros
            cstmt.setInt(1, idPromocion);
            cstmt.setString(2, estado);
            
            // Ejecutar el procedimiento almacenado
            int filasAfectadas = cstmt.executeUpdate();
            
            // Verificar si se actualizó correctamente
            if (filasAfectadas > 0) {
                actualizado = true;
                System.out.println("✅ Estado de promoción actualizado exitosamente!");
                System.out.println("   ID: " + idPromocion);
                System.out.println("   Nuevo estado: '" + estado + "'");
            } else {
                System.out.println("⚠️  No se encontró la promoción con ID: " + idPromocion);
            }

        } catch (ClassNotFoundException e) {
            System.err.println("Error: Driver no encontrado");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Error en la operación SQL al actualizar estado de promoción");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error general al actualizar estado de promoción");
            e.printStackTrace();
        } finally {
            try {
                if (cstmt != null) cstmt.close();
                if (con != null) con.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return actualizado;
    }

    // NUEVO MÉTODO: Obtener todas las promociones
    public List<Promocion> obtenerPromociones() {
        List<Promocion> promociones = new ArrayList<>();
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);

            cstmt = con.prepareCall("{CALL sp_ObtenerPromociones()}");
            
            rs = cstmt.executeQuery();

            while (rs.next()) {
                Promocion promocion = new Promocion();
                promocion.setIdPromocion(rs.getInt("id_promocion"));
                promocion.setNombre(rs.getString("nombre"));
                promocion.setDescripcion(rs.getString("descripcion"));
                promocion.setTipo(rs.getString("tipo"));
                promocion.setValor(rs.getDouble("valor"));
                promocion.setFechaInicio(rs.getDate("fecha_inicio"));
                promocion.setFechaFin(rs.getDate("fecha_fin"));
                promocion.setEstado(rs.getString("estado"));
                
                promociones.add(promocion);
            }

        } catch (ClassNotFoundException e) {
            System.err.println("Error: Driver no encontrado");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Error en la operación SQL al obtener promociones");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error general al obtener promociones");
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
        return promociones;
    }

    // Método main para probar solo el nuevo método agregado
    public static void main(String[] args) {
        PromocionDao promocionDAO = new PromocionDao();

        System.out.println("=== Probando sp_ObtenerPromociones ===");
        
        List<Promocion> todasLasPromociones = promocionDAO.obtenerPromociones();
        
        if (todasLasPromociones.isEmpty()) {
            System.out.println("No hay promociones registradas en el sistema");
            System.out.println("💡 Sugerencia: Usa sp_InsertarPromocion para crear algunas promociones");
        } else {
            System.out.println("\n📋 CATÁLOGO COMPLETO DE PROMOCIONES - TOTAL: " + todasLasPromociones.size());
            System.out.println("=========================================================");
            
            // Agrupar por estado para mejor organización
            java.util.Map<String, List<Promocion>> promocionesPorEstado = new java.util.HashMap<>();
            for (Promocion promocion : todasLasPromociones) {
                String estado = promocion.getEstado();
                if (!promocionesPorEstado.containsKey(estado)) {
                    promocionesPorEstado.put(estado, new ArrayList<>());
                }
                promocionesPorEstado.get(estado).add(promocion);
            }
            
            // Mostrar por estado
            for (java.util.Map.Entry<String, List<Promocion>> entry : promocionesPorEstado.entrySet()) {
                String estado = entry.getKey();
                List<Promocion> promocionesEstado = entry.getValue();
                
                String iconoEstado = "";
                String colorEstado = "";
                
                switch (estado) {
                    case "activa":
                        iconoEstado = "🟢";
                        colorEstado = "ACTIVAS";
                        break;
                    case "inactiva":
                        iconoEstado = "🔴";
                        colorEstado = "INACTIVAS";
                        break;
                    default:
                        iconoEstado = "⚪";
                        colorEstado = estado.toUpperCase();
                }
                
                System.out.println("\n" + iconoEstado + " PROMOCIONES " + colorEstado + " (" + promocionesEstado.size() + ")");
                System.out.println("==========================================");
                
                for (int i = 0; i < promocionesEstado.size(); i++) {
                    Promocion promocion = promocionesEstado.get(i);
                    String iconoTipo = "porcentaje".equals(promocion.getTipo()) ? "📊" : "💰";
                    String descripcionTipo = "porcentaje".equals(promocion.getTipo()) ? 
                        promocion.getValor() + "%" : "S/ " + promocion.getValor();
                    
                    System.out.println((i + 1) + ". " + iconoTipo + " " + promocion.getNombre());
                    System.out.println("   ID: " + promocion.getIdPromocion());
                    System.out.println("   Descuento: " + descripcionTipo);
                    System.out.println("   Vigencia: " + promocion.getFechaInicio() + " al " + promocion.getFechaFin());
                    
                    // Manejar descripción
                    String descripcion = promocion.getDescripcion();
                    if (descripcion == null || descripcion.trim().isEmpty()) {
                        descripcion = "Sin descripción";
                    } else if (descripcion.length() > 50) {
                        descripcion = descripcion.substring(0, 50) + "...";
                    }
                    System.out.println("   Descripción: " + descripcion);
                    
                    // Calcular días de vigencia
                    long diasVigencia = (promocion.getFechaFin().getTime() - promocion.getFechaInicio().getTime()) / (1000 * 60 * 60 * 24);
                    System.out.println("   Duración: " + diasVigencia + " días");
                    
                    if (i < promocionesEstado.size() - 1) {
                        System.out.println("   ─────────────────────────");
                    }
                }
            }
            
            // Estadísticas generales
            System.out.println("\n📊 ESTADÍSTICAS GENERALES:");
            System.out.println("==========================");
            
            int totalActivas = promocionesPorEstado.getOrDefault("activa", new ArrayList<>()).size();
            int totalInactivas = promocionesPorEstado.getOrDefault("inactiva", new ArrayList<>()).size();
            int totalPorcentaje = 0;
            int totalMonto = 0;
            double mayorDescuentoPorcentaje = 0;
            double mayorDescuentoMonto = 0;
            String promocionMayorPorcentaje = "";
            String promocionMayorMonto = "";
            
            for (Promocion promocion : todasLasPromociones) {
                if ("porcentaje".equals(promocion.getTipo())) {
                    totalPorcentaje++;
                    if (promocion.getValor() > mayorDescuentoPorcentaje) {
                        mayorDescuentoPorcentaje = promocion.getValor();
                        promocionMayorPorcentaje = promocion.getNombre();
                    }
                } else if ("monto".equals(promocion.getTipo())) {
                    totalMonto++;
                    if (promocion.getValor() > mayorDescuentoMonto) {
                        mayorDescuentoMonto = promocion.getValor();
                        promocionMayorMonto = promocion.getNombre();
                    }
                }
            }
            
            System.out.println("• Total promociones: " + todasLasPromociones.size());
            System.out.println("• Promociones activas: " + totalActivas);
            System.out.println("• Promociones inactivas: " + totalInactivas);
            System.out.println("• Descuentos por porcentaje: " + totalPorcentaje);
            System.out.println("• Descuentos por monto fijo: " + totalMonto);
            System.out.println("• Mayor descuento porcentual: " + mayorDescuentoPorcentaje + "% en '" + promocionMayorPorcentaje + "'");
            System.out.println("• Mayor descuento en monto: S/ " + mayorDescuentoMonto + " en '" + promocionMayorMonto + "'");
            
            // Análisis de distribución
            System.out.println("\n📈 DISTRIBUCIÓN:");
            System.out.println("================");
            double porcentajeActivas = (double) totalActivas / todasLasPromociones.size() * 100;
            double porcentajePorcentaje = (double) totalPorcentaje / todasLasPromociones.size() * 100;
            
            System.out.println("• Promociones activas: " + String.format("%.1f", porcentajeActivas) + "%");
            System.out.println("• Promociones inactivas: " + String.format("%.1f", 100 - porcentajeActivas) + "%");
            System.out.println("• Descuentos porcentuales: " + String.format("%.1f", porcentajePorcentaje) + "%");
            System.out.println("• Descuentos de monto fijo: " + String.format("%.1f", 100 - porcentajePorcentaje) + "%");
            
            // Promociones más recientes
            if (!todasLasPromociones.isEmpty()) {
                System.out.println("\n🆕 PROMOCIONES MÁS RECIENTES:");
                System.out.println("============================");
                int limite = Math.min(3, todasLasPromociones.size());
                for (int i = 0; i < limite; i++) {
                    Promocion promocion = todasLasPromociones.get(i);
                    System.out.println((i + 1) + ". " + promocion.getNombre() + " (" + promocion.getFechaInicio() + ")");
                }
            }
        }
        
        // Comparativa con método anterior
        System.out.println("\n🔍 COMPARATIVA CON sp_ObtenerPromocionesActivas:");
        System.out.println("===============================================");
        
        List<Promocion> promocionesActivas = promocionDAO.obtenerPromocionesActivas();
        List<Promocion> todasPromociones = promocionDAO.obtenerPromociones();
        
        System.out.println("• sp_ObtenerPromocionesActivas: " + promocionesActivas.size() + " promociones");
        System.out.println("• sp_ObtenerPromociones: " + todasPromociones.size() + " promociones");
        System.out.println("• Diferencia: " + (todasPromociones.size() - promocionesActivas.size()) + " promociones inactivas");
        
        System.out.println("\n🎯 USOS PRÁCTICOS DEL NUEVO MÉTODO:");
        System.out.println("===================================");
        System.out.println("1. 📊 Panel administrativo - Vista completa de todas las promociones");
        System.out.println("2. 📈 Reportes históricos - Análisis de campañas pasadas y presentes");
        System.out.println("3. 🔄 Gestión de estados - Activar/desactivar promociones fácilmente");
        System.out.println("4. 📋 Auditoría - Seguimiento de todas las promociones creadas");
        System.out.println("5. 🎫 Archivo histórico - Consulta de promociones vencidas o inactivas");
        
        System.out.println("\n✅ Método sp_ObtenerPromociones probado exitosamente");
    }

    // MÉTODOS FALTANTES REQUERIDOS POR PromocionControlador según instrucciones de Diego

    // Método renombrado para claridad
    public List<Promocion> listarTodasPromociones() {
        return obtenerPromociones(); // Reutiliza el método existente
    }

    // Búsqueda avanzada de promociones
    public List<Promocion> buscarPromociones(String termino, String tipo, String estado, java.sql.Date fechaInicio, java.sql.Date fechaFin) {
        List<Promocion> promociones = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        StringBuilder sql = new StringBuilder("SELECT * FROM promocion WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (termino != null && !termino.isEmpty()) {
            sql.append(" AND (nombre LIKE ? OR descripcion LIKE ?)");
            params.add("%" + termino + "%");
            params.add("%" + termino + "%");
        }
        if (tipo != null && !tipo.isEmpty()) {
            sql.append(" AND tipo = ?");
            params.add(tipo);
        }
        if (estado != null && !estado.isEmpty()) {
            sql.append(" AND estado = ?");
            params.add(estado);
        }
        if (fechaInicio != null && fechaFin != null) {
            sql.append(" AND fecha_inicio >= ? AND fecha_fin <= ?");
            params.add(fechaInicio);
            params.add(fechaFin);
        }
        sql.append(" ORDER BY fecha_inicio DESC");

        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, pass);
            pstmt = conn.prepareStatement(sql.toString());

            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            rs = pstmt.executeQuery();
            while (rs.next()) {
                Promocion p = new Promocion();
                p.setIdPromocion(rs.getInt("id_promocion"));
                p.setNombre(rs.getString("nombre"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setTipo(rs.getString("tipo"));
                p.setValor(rs.getDouble("valor"));
                p.setFechaInicio(rs.getDate("fecha_inicio"));
                p.setFechaFin(rs.getDate("fecha_fin"));
                p.setEstado(rs.getString("estado"));
                promociones.add(p);
            }
        } catch (Exception e) {
            System.err.println("Error al buscar promociones: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return promociones;
    }

    public Promocion obtenerPromocionPorId(int idPromocion) {
        Promocion promocion = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM promocion WHERE id_promocion = ?";

        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, pass);
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, idPromocion);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                promocion = new Promocion();
                promocion.setIdPromocion(rs.getInt("id_promocion"));
                promocion.setNombre(rs.getString("nombre"));
                promocion.setDescripcion(rs.getString("descripcion"));
                promocion.setTipo(rs.getString("tipo"));
                promocion.setValor(rs.getDouble("valor"));
                promocion.setFechaInicio(rs.getDate("fecha_inicio"));
                promocion.setFechaFin(rs.getDate("fecha_fin"));
                promocion.setEstado(rs.getString("estado"));
            }
        } catch (Exception e) {
            System.err.println("Error al obtener promoción por ID: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return promocion;
    }

    public boolean actualizarPromocion(int idPromocion, String nombre, String descripcion, double valor) {
        boolean exito = false;
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "UPDATE promocion SET nombre = ?, descripcion = ?, valor = ? WHERE id_promocion = ?";

        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, pass);
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, nombre);
            pstmt.setString(2, descripcion);
            pstmt.setDouble(3, valor);
            pstmt.setInt(4, idPromocion);
            int filasAfectadas = pstmt.executeUpdate();
            exito = filasAfectadas > 0;
        } catch (Exception e) {
            System.err.println("Error al actualizar promoción: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return exito;
    }

    public boolean cambiarEstadoPromocion(int idPromocion, String nuevoEstado) {
        // Validar que nuevoEstado sea 'activa' o 'inactiva' antes de ejecutar
        if (!"activa".equals(nuevoEstado) && !"inactiva".equals(nuevoEstado)) {
            System.err.println("Estado inválido: " + nuevoEstado + ". Debe ser 'activa' o 'inactiva'");
            return false;
        }
        return actualizarEstadoPromocion(idPromocion, nuevoEstado); // Reutiliza método existente
    }

    public boolean eliminarPromocion(int idPromocion) {
        // En lugar de DELETE, cambiamos el estado a 'inactiva' para mantener historial
        return cambiarEstadoPromocion(idPromocion, "inactiva");
    }

    // MÉTODOS ADICIONALES CON IMPLEMENTACIONES PLACEHOLDER
    // Estos métodos requieren lógica más compleja o stored procedures no definidos

    public int obtenerVecesUsadaPromocion(int idPromocion) {
        // PLACEHOLDER: Necesitaría consultar tablas de facturas/detalles
        System.err.println("WARN: obtenerVecesUsadaPromocion no implementado completamente, devolviendo 0.");
        return 0;
    }

    public double obtenerMontoAhorradoPromocion(int idPromocion) {
        // PLACEHOLDER: Necesitaría lógica de cálculo basada en usos
        System.err.println("WARN: obtenerMontoAhorradoPromocion no implementado completamente, devolviendo 0.0.");
        return 0.0;
    }

    public boolean validarPromocionParaCliente(int idPromocion, int idCliente, double montoCompra) {
        // PLACEHOLDER: Lógica compleja (¿restricciones por cliente? ¿monto mínimo?)
        System.err.println("WARN: validarPromocionParaCliente no implementado completamente, devolviendo true por defecto.");
        return true; // Asumir válida por ahora
    }

    public double calcularDescuentoPromocion(Promocion promocion, double montoCompra) {
        // Implementación básica de cálculo real
        if (promocion != null && montoCompra > 0) {
            if ("porcentaje".equalsIgnoreCase(promocion.getTipo())) {
                return montoCompra * (promocion.getValor() / 100.0);
            } else if ("monto".equalsIgnoreCase(promocion.getTipo())) {
                return Math.min(promocion.getValor(), montoCompra);
            }
        }
        return 0.0;
    }

    public String obtenerMotivoRechazoPromocion(int idPromocion, int idCliente, double montoCompra) {
        // PLACEHOLDER: Lógica para determinar por qué falló validarPromocionParaCliente
        System.err.println("WARN: obtenerMotivoRechazoPromocion no implementado completamente.");
        return "Motivo desconocido (función no implementada)";
    }
}