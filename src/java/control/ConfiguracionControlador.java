package control;

import dao.ConfiguracionDao;
import java.io.IOException;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import modelo.ConfiguracionEstimacion;
import modelo.EstimacionTiempoDTO;

@WebServlet(urlPatterns = {"/ConfiguracionControlador"})
public class ConfiguracionControlador extends HttpServlet {

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
                        listarEstimaciones(request, response);
                        return;
                    case "editar":
                        mostrarFormularioEdicion(request, response);
                        return;
                    case "actualizar":
                        actualizarTiempo(request, response);
                        return;
                    default:
                        response.sendRedirect("menuConfiguracion.jsp");
                        return;
                }

            } else if (acc != null && acc.equals("Ver Configuración")) {
                listarEstimaciones(request, response);
                return;
            } else {
                // Caso por defecto: ir al menú principal de configuración
                response.sendRedirect("menuConfiguracion.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "❌ Error en configuración: " + e.getMessage());
            request.getRequestDispatcher("listarEstimaciones.jsp").forward(request, response);
        }
    }

    // ============================================================
    // MÉTODO 1: Listar todas las estimaciones
    // ============================================================
    private void listarEstimaciones(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            ConfiguracionDao dao = new ConfiguracionDao();
            List<EstimacionTiempoDTO> estimaciones = dao.obtenerEstimacionesTiempo();

            request.setAttribute("estimaciones", estimaciones);
            request.setAttribute("totalEstimaciones", estimaciones.size());
            request.setAttribute("mensaje", "✅ Estimaciones cargadas correctamente");

        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error al listar estimaciones: " + e.getMessage());
        }

        request.getRequestDispatcher("listarEstimaciones.jsp").forward(request, response);
    }

    // ============================================================
    // MÉTODO 2: Mostrar formulario para editar una estimación
    // ============================================================
    private void mostrarFormularioEdicion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int idServicio = Integer.parseInt(request.getParameter("idServicio"));
            int idGroomer = Integer.parseInt(request.getParameter("idGroomer"));

            // Pasar datos al JSP
            request.setAttribute("idServicio", idServicio);
            request.setAttribute("idGroomer", idGroomer);

            request.getRequestDispatcher("editarEstimacion.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ IDs no válidos para editar la estimación");
            listarEstimaciones(request, response);
        }
    }

    // ============================================================
    // MÉTODO 3: Actualizar tiempo estimado de un servicio
    // ============================================================
    private void actualizarTiempo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int idServicio = Integer.parseInt(request.getParameter("idServicio"));
            int idGroomer = Integer.parseInt(request.getParameter("idGroomer"));
            int tiempoEstimadoMin = Integer.parseInt(request.getParameter("tiempoEstimadoMin"));

            ConfiguracionEstimacion configuracion = new ConfiguracionEstimacion();
            configuracion.setIdServicio(idServicio);
            configuracion.setIdGroomer(idGroomer);
            configuracion.setTiempoEstimadoMin(tiempoEstimadoMin);

            ConfiguracionDao dao = new ConfiguracionDao();
            boolean exito = dao.ajustarTiempoEstimado(configuracion);

            if (exito) {
                request.setAttribute("mensaje", "✅ Tiempo estimado actualizado correctamente.");
            } else {
                request.setAttribute("mensaje", "❌ No se pudo actualizar el tiempo estimado.");
            }

            listarEstimaciones(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ Error: ingrese valores numéricos válidos.");
            listarEstimaciones(request, response);
        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error al actualizar la estimación: " + e.getMessage());
            listarEstimaciones(request, response);
        }
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
        return "Controlador para la configuración de estimaciones de tiempo (servicio x groomer)";
    }
}
