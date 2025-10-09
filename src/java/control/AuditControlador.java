package control;

import dao.AuditDao;
import java.io.IOException;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import modelo.AuditLogDTO;

@WebServlet(urlPatterns = {"/AuditControlador"})
public class AuditControlador extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Configuración de codificación
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String accion = request.getParameter("accion");
        String acc = request.getParameter("acc");

        try {
            if (accion != null) {
                switch (accion) {
                    case "listar":
                        listarLogs(request, response);
                        return;
                    case "filtrar":
                        filtrarLogs(request, response);
                        return;
                    default:
                        response.sendRedirect("menuAuditoria.jsp");
                        return;
                }
            } else if (acc != null && acc.equals("Ver Logs")) {
                listarLogs(request, response);
                return;
            } else {
                // Caso por defecto: mostrar la página principal de auditoría
                response.sendRedirect("menuAuditoria.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "❌ Error en auditoría: " + e.getMessage());
            request.getRequestDispatcher("LogsAuditoria.jsp").forward(request, response);
        }
    }

    // ============================================================
    // MÉTODO 1: Listar todos los logs (por defecto)
    // ============================================================
    private void listarLogs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            AuditDao dao = new AuditDao();
            List<AuditLogDTO> logs = dao.obtenerLogsAuditoria(50, null, null);

            request.setAttribute("logs", logs);
            request.setAttribute("totalLogs", logs.size());
            request.setAttribute("mensaje", "✅ Logs cargados correctamente");

        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error al listar logs: " + e.getMessage());
        }

        request.getRequestDispatcher("LogsAuditoria.jsp").forward(request, response);
    }

    // ============================================================
    // MÉTODO 2: Filtrar logs por entidad o acción
    // ============================================================
    private void filtrarLogs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String limiteStr = request.getParameter("limite");
            String entidad = limpiarParametro(request.getParameter("entidad"));
            String accion = limpiarParametro(request.getParameter("accionFiltro"));

            Integer limite = null;
            if (limiteStr != null && !limiteStr.trim().isEmpty()) {
                limite = Integer.parseInt(limiteStr);
            }

            AuditDao dao = new AuditDao();
            List<AuditLogDTO> logs = dao.obtenerLogsAuditoria(limite, entidad, accion);

            request.setAttribute("logs", logs);
            request.setAttribute("entidadFiltro", entidad);
            request.setAttribute("accionFiltro", accion);
            request.setAttribute("totalLogs", logs.size());

            if (logs.isEmpty()) {
                request.setAttribute("mensaje", "⚠️ No se encontraron resultados con los filtros aplicados");
            } else {
                request.setAttribute("mensaje", "✅ Resultados filtrados correctamente");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ Error: El límite debe ser un número válido");
        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error al filtrar logs: " + e.getMessage());
        }

        request.getRequestDispatcher("LogsAuditoria.jsp").forward(request, response);
    }

    // ============================================================
    // Método auxiliar
    // ============================================================
    private String limpiarParametro(String param) {
        if (param == null) {
            return "";
        }
        return param.trim();
    }

    // ============================================================
    // Métodos estándar del servlet
    // ============================================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Controlador para la auditoría del sistema (logs)";
    }
}
