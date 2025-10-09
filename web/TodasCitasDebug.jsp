<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, java.util.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Debug - Todas las Citas</title>
</head>
<body>
    <h1>Debug - Todas las Citas en BD</h1>
    
    <%
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost/vet_teran", "root", "");
            
            String sql = "SELECT * FROM cita ORDER BY id_cita";
            pstmt = con.prepareStatement(sql);
            rs = pstmt.executeQuery();
    %>
    
    <table border="1" style="width: 100%;">
        <tr>
            <th>ID</th>
            <th>Mascota ID</th>
            <th>Cliente ID</th>
            <th>Fecha Programada</th>
            <th>Estado</th>
            <th>Modalidad</th>
        </tr>
        <%
            int count = 0;
            while (rs.next()) {
                count++;
        %>
        <tr>
            <td><%= rs.getInt("id_cita") %></td>
            <td><%= rs.getInt("id_mascota") %></td>
            <td><%= rs.getInt("id_cliente") %></td>
            <td><%= rs.getTimestamp("fecha_programada") %></td>
            <td><%= rs.getString("estado") %></td>
            <td><%= rs.getString("modalidad") %></td>
        </tr>
        <% } %>
    </table>
    
    <h3>Total de citas en BD: <%= count %></h3>
    
    <%
        } catch (Exception e) {
            out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
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
    <a href="CrearCitaPrueba.jsp">➕ Crear Citas de Prueba</a> |
    <a href="CitaControlador">📅 Ver Próximas Citas</a> |
    <a href="Menu.jsp">← Menú Principal</a>
</body>
</html> 
