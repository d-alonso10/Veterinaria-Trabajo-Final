package control;

import dao.ReporteDao;
import modelo.ReporteIngresosDTO;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ReporteControlador")
public class ReporteControlador extends HttpServlet {

    private ReporteDao reporteDao = new ReporteDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }

        switch (accion) {
            case "listar":
                mostrarReporte(request, response);
                break;
            case "filtrar":
                filtrarReporte(request, response);
                break;
            default:
                mostrarReporte(request, response);
                break;
        }
    }

    private void mostrarReporte(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Obtener el año actual
        java.time.LocalDate ahora = java.time.LocalDate.now();
        int anioActual = ahora.getYear();

        // Rango dinámico del año actual
        java.sql.Date fechaInicio = java.sql.Date.valueOf(anioActual + "-01-01");
        java.sql.Date fechaFin = java.sql.Date.valueOf(anioActual + "-12-31");

        Integer idSucursal = null;

        // Obtener los datos del reporte
        List<ReporteIngresosDTO> lista = reporteDao.reporteIngresos(fechaInicio, fechaFin, idSucursal);

        // Preparar atributos para la vista
        request.setAttribute("reporte", lista);
        request.setAttribute("anioActual", anioActual);
        request.setAttribute("fechaInicio", fechaInicio);
        request.setAttribute("fechaFin", fechaFin);

        // Mensaje dinámico y adaptativo
        if (lista.isEmpty()) {
            request.setAttribute("mensaje", "⚠️ No se encontraron ingresos registrados en " + anioActual + ".");
        } else {
            request.setAttribute("mensaje", "✅ Mostrando reporte general de ingresos del año " + anioActual + ".");
        }

        // Redirigir al JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("ReporteIngresos.jsp");
        dispatcher.forward(request, response);
    }

    private void filtrarReporte(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String fechaInicioStr = request.getParameter("fechaInicio");
            String fechaFinStr = request.getParameter("fechaFin");
            String idSucursalStr = request.getParameter("idSucursal");

            Date fechaInicio = (fechaInicioStr != null && !fechaInicioStr.isEmpty())
                    ? Date.valueOf(fechaInicioStr)
                    : null;

            Date fechaFin = (fechaFinStr != null && !fechaFinStr.isEmpty())
                    ? Date.valueOf(fechaFinStr)
                    : null;

            Integer idSucursal = (idSucursalStr != null && !idSucursalStr.isEmpty())
                    ? Integer.parseInt(idSucursalStr)
                    : null;

            List<ReporteIngresosDTO> lista = reporteDao.reporteIngresos(fechaInicio, fechaFin, idSucursal);

            if (lista.isEmpty()) {
                request.setAttribute("mensaje", "⚠️ No se encontraron ingresos para el rango seleccionado.");
            } else {
                request.setAttribute("mensaje", "✅ Reporte generado correctamente.");
            }

            request.setAttribute("reporte", lista);
            RequestDispatcher dispatcher = request.getRequestDispatcher("ReporteIngresos.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error al generar el reporte: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("ReporteIngresos.jsp");
            dispatcher.forward(request, response);
        }
    }
}
