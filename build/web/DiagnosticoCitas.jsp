<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, java.util.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Diagnóstico Citas</title>
</head>
<body>
    <h1>🔧 Diagnóstico Completo - Citas</h1>
    
    <%
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            // 1. Probar conexión
            out.println("<h2>1. Probando conexión...</h2>");
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost/vet_teran", "root", "");
            out.println("✅ Conexión exitosa<br>");
            
            // 2. Contar citas totales
            out.println("<h2>2. Contando citas totales...</h2>");
            String countSql = "SELECT COUNT(*) as total FROM cita";
            pstmt = con.prepareStatement(countSql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                out.println("Total de citas en BD: " + rs.getInt("total") + "<br>");
            }
            rs.close();
            pstmt.close();
            
            // 3. Contar citas con estado 'reservada' o 'confirmada'
            out.println("<h2>3. Citas con estado 'reservada' o 'confirmada'...</h2>");
            String estadoSql = "SELECT COUNT(*) as total FROM cita WHERE estado IN ('reservada', 'confirmada')";
            pstmt = con.prepareStatement(estadoSql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                out.println("Citas con estado válido: " + rs.getInt("total") + "<br>");
            }
            rs.close();
            pstmt.close();
            
            // 4. Mostrar todas las citas con estados válidos
            out.println("<h2>4. Detalle de citas con estados válidos:</h2>");
            String detalleSql = "SELECT id_cita, id_mascota, id_cliente, fecha_programada, estado, modalidad " +
                               "FROM cita WHERE estado IN ('reservada', 'confirmada') " +
                               "ORDER BY id_cita";
            pstmt = con.prepareStatement(detalleSql);
            rs = pstmt.executeQuery();
            
            out.println("<table border='1' style='width: 100%;'>");
            out.println("<tr><th>ID</th><th>Mascota ID</th><th>Cliente ID</th><th>Fecha</th><th>Estado</th><th>Modalidad</th></tr>");
            
            int countValidas = 0;
            while (rs.next()) {
                countValidas++;
                out.println("<tr>");
                out.println("<td>" + rs.getInt("id_cita") + "</td>");
                out.println("<td>" + rs.getInt("id_mascota") + "</td>");
                out.println("<td>" + rs.getInt("id_cliente") + "</td>");
                out.println("<td>" + rs.getTimestamp("fecha_programada") + "</td>");
                out.println("<td>" + rs.getString("estado") + "</td>");
                out.println("<td>" + rs.getString("modalidad") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            out.println("<p><strong>Citas válidas encontradas: " + countValidas + "</strong></p>");
            
            // 5. Probar la consulta exacta del Dao
            out.println("<h2>5. Probando consulta exacta del CitaDao...</h2>");
            String daoSQL = "SELECT c.id_cita, c.fecha_programada, " +
                          "COALESCE(m.nombre, 'Sin mascota') as mascota, " +
                          "COALESCE(s.nombre, 'Sin servicio') as servicio, " +
                          "c.estado, c.modalidad " +
                          "FROM cita c " +
                          "LEFT JOIN mascota m ON c.id_mascota = m.id_mascota " +
                          "LEFT JOIN servicio s ON c.id_servicio = s.id_servicio " +
                          "WHERE c.estado IN ('reservada', 'confirmada') " +
                          "ORDER BY c.fecha_programada ASC";
            
            pstmt = con.prepareStatement(daoSQL);
            rs = pstmt.executeQuery();
            
            out.println("<table border='1' style='width: 100%;'>");
            out.println("<tr><th>ID</th><th>Fecha</th><th>Mascota</th><th>Servicio</th><th>Estado</th><th>Modalidad</th></tr>");
            
            int countDao = 0;
            while (rs.next()) {
                countDao++;
                out.println("<tr>");
                out.println("<td>" + rs.getInt("id_cita") + "</td>");
                out.println("<td>" + rs.getTimestamp("fecha_programada") + "</td>");
                out.println("<td>" + rs.getString("mascota") + "</td>");
                out.println("<td>" + rs.getString("servicio") + "</td>");
                out.println("<td>" + rs.getString("estado") + "</td>");
                out.println("<td>" + rs.getString("modalidad") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            out.println("<p><strong>Resultados de consulta Dao: " + countDao + "</strong></p>");
            
        } catch (Exception e) {
            out.println("<p style='color: red;'>❌ Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (SQLException ex) {
                out.println("<p style='color: red;'>Error cerrando conexión: " + ex.getMessage() + "</p>");
            }
        }
    %>
    
    <br>
    <a href="CitaControlador">📅 Probar CitaControlador</a> |
    <a href="Menu.jsp">← Menú Principal</a>
</body>
</html>
