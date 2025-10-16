package control;

import dao.DashboardDao;
import modelo.MetricasDashboardDTO;
import modelo.EstadisticasMensualesDTO;
import java.io.IOException;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/DashboardControlador"})
public class DashboardControlador extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Configurar encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String accion = request.getParameter("accion");

        try {
            if (accion != null) {
                switch (accion) {
                    case "metricas":
                        cargarMetricasDashboard(request, response);
                        break;
                    case "estadisticasMensuales":
                        cargarEstadisticasMensuales(request, response);
                        break;
                    case "metricasRango":
                        cargarMetricasRango(request, response);
                        break;
                    default:
                        cargarDashboardPrincipal(request, response);
                }
            } else {
                cargarDashboardPrincipal(request, response);
            }
        } catch (Exception e) {
            manejarError(request, response, e, "Error general en el dashboard");
        }
    }

    /**
     * Carga las métricas principales del dashboard para el día actual
     */
    private void cargarDashboardPrincipal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            DashboardDao dao = new DashboardDao();
            
            // Obtener fechas para el día actual
            Calendar cal = Calendar.getInstance();
            Date hoy = new Date(cal.getTimeInMillis());
            
            // Cargar métricas del día
            MetricasDashboardDTO metricas = dao.obtenerMetricasDashboard(hoy, hoy);
            
            if (metricas != null) {
                request.setAttribute("metricas", metricas);
                request.setAttribute("fechaConsulta", new SimpleDateFormat("dd/MM/yyyy").format(hoy));
                request.setAttribute("mensaje", "✅ Métricas cargadas correctamente");
            } else {
                request.setAttribute("mensaje", "⚠️ No se pudieron cargar las métricas");
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al cargar el dashboard principal");
            return;
        }

        request.getRequestDispatcher("Menu.jsp").forward(request, response);
    }

    /**
     * Carga métricas del dashboard para un rango de fechas específico
     */
    private void cargarMetricasRango(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String fechaInicioStr = limpiarParametro(request.getParameter("fechaInicio"));
            String fechaFinStr = limpiarParametro(request.getParameter("fechaFin"));

            // Validar parámetros
            if (fechaInicioStr == null || fechaInicioStr.isEmpty() || 
                fechaFinStr == null || fechaFinStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ Las fechas de inicio y fin son obligatorias");
                request.getRequestDispatcher("Dashboard.jsp").forward(request, response);
                return;
            }

            // Convertir fechas
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date fechaInicio = new Date(sdf.parse(fechaInicioStr).getTime());
            Date fechaFin = new Date(sdf.parse(fechaFinStr).getTime());

            // Validar que fecha inicio no sea mayor que fecha fin
            if (fechaInicio.after(fechaFin)) {
                request.setAttribute("mensaje", "❌ La fecha de inicio no puede ser mayor que la fecha fin");
                request.getRequestDispatcher("Dashboard.jsp").forward(request, response);
                return;
            }

            DashboardDao dao = new DashboardDao();
            MetricasDashboardDTO metricas = dao.obtenerMetricasDashboard(fechaInicio, fechaFin);

            if (metricas != null) {
                request.setAttribute("metricas", metricas);
                request.setAttribute("fechaInicio", fechaInicioStr);
                request.setAttribute("fechaFin", fechaFinStr);
                request.setAttribute("mensaje", "✅ Métricas cargadas para el rango seleccionado");
            } else {
                request.setAttribute("mensaje", "⚠️ No se encontraron datos para el rango de fechas especificado");
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al cargar métricas por rango de fechas");
            return;
        }

        request.getRequestDispatcher("Dashboard.jsp").forward(request, response);
    }

    /**
     * Carga estadísticas mensuales específicas
     */
    private void cargarEstadisticasMensuales(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String anioStr = limpiarParametro(request.getParameter("anio"));
            String mesStr = limpiarParametro(request.getParameter("mes"));

            // Valores por defecto (mes actual)
            Calendar cal = Calendar.getInstance();
            int anio = cal.get(Calendar.YEAR);
            int mes = cal.get(Calendar.MONTH) + 1; // Calendar.MONTH es 0-based

            // Usar parámetros si se proporcionan
            if (anioStr != null && !anioStr.isEmpty()) {
                try {
                    int anioParam = Integer.parseInt(anioStr);
                    if (anioParam >= 2020 && anioParam <= 2030) { // Validación básica
                        anio = anioParam;
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("mensaje", "⚠️ Año inválido, usando año actual");
                }
            }

            if (mesStr != null && !mesStr.isEmpty()) {
                try {
                    int mesParam = Integer.parseInt(mesStr);
                    if (mesParam >= 1 && mesParam <= 12) {
                        mes = mesParam;
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("mensaje", "⚠️ Mes inválido, usando mes actual");
                }
            }

            DashboardDao dao = new DashboardDao();
            EstadisticasMensualesDTO estadisticas = dao.obtenerEstadisticasMensuales(anio, mes);

            if (estadisticas != null) {
                request.setAttribute("estadisticas", estadisticas);
                request.setAttribute("anioConsulta", anio);
                request.setAttribute("mesConsulta", mes);
                request.setAttribute("mensaje", "✅ Estadísticas mensuales cargadas");
            } else {
                request.setAttribute("mensaje", "⚠️ No se encontraron estadísticas para el período especificado");
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al cargar estadísticas mensuales");
            return;
        }

        request.getRequestDispatcher("EstadisticasMensuales.jsp").forward(request, response);
    }

    /**
     * Carga solo las métricas básicas (para AJAX o actualizaciones parciales)
     */
    private void cargarMetricasDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            DashboardDao dao = new DashboardDao();
            
            // Obtener fechas del día actual
            Calendar cal = Calendar.getInstance();
            Date hoy = new Date(cal.getTimeInMillis());
            
            MetricasDashboardDTO metricas = dao.obtenerMetricasDashboard(hoy, hoy);

            if (metricas != null) {
                // Para respuestas AJAX, podrías devolver JSON
                response.setContentType("application/json;charset=UTF-8");
                
                // Construir respuesta JSON simple
                StringBuilder json = new StringBuilder();
                json.append("{");
                json.append("\"totalClientes\":").append(metricas.getTotalClientes()).append(",");
                json.append("\"totalMascotas\":").append(metricas.getTotalMascotas()).append(",");
                json.append("\"citasHoy\":").append(metricas.getCitasHoy()).append(",");
                json.append("\"ingresosMes\":").append(metricas.getIngresosMes()).append(",");
                json.append("\"atencionesCurso\":").append(metricas.getAtencionesCurso());
                json.append("}");
                
                response.getWriter().write(json.toString());
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\":\"No se pudieron cargar las métricas\"}");
            }

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    /**
     * Manejo centralizado de errores
     */
    private void manejarError(HttpServletRequest request, HttpServletResponse response, 
                             Exception e, String mensajeContexto) 
            throws ServletException, IOException {
        
        System.err.println("=== ERROR EN DASHBOARD CONTROLADOR ===");
        System.err.println("Contexto: " + mensajeContexto);
        System.err.println("Mensaje: " + e.getMessage());
        e.printStackTrace();

        request.setAttribute("mensaje", "❌ " + mensajeContexto + ": " + e.getMessage());
        request.setAttribute("tipoMensaje", "error");
        
        // Redirigir a página de error o dashboard con mensaje
        request.getRequestDispatcher("Menu.jsp").forward(request, response);
    }

    /**
     * Método auxiliar para limpiar parámetros
     */
    private String limpiarParametro(String param) {
        if (param == null) {
            return "";
        }
        return param.trim();
    }

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
        return "Controlador para métricas y estadísticas del dashboard";
    }
}