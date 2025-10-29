package control;

import dao.PaqueteServicioDao;
import dao.ServicioDao;
import modelo.PaqueteServicio;
import modelo.PaqueteServicioItem;
import modelo.Servicio;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/PaqueteServicioControlador"})
public class PaqueteServicioControlador extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String accion = request.getParameter("accion");

        try {
            if (accion != null) {
                switch (accion) {
                    case "crear":
                        crearPaqueteServicio(request, response);
                        break;
                    case "agregarServicio":
                        agregarServicioAPaquete(request, response);
                        break;
                    case "listar":
                    case "listarPaquetes":
                        listarPaquetesServicio(request, response);
                        break;
                    case "obtenerDetalle":
                        obtenerDetallePaquete(request, response);
                        break;
                    case "actualizar":
                        actualizarPaqueteServicio(request, response);
                        break;
                    case "eliminar":
                        eliminarPaqueteServicio(request, response);
                        break;
                    case "eliminarServicioPaquete":
                        eliminarServicioDePaquete(request, response);
                        break;
                    case "buscarPaquetes":
                        buscarPaquetesServicio(request, response);
                        break;
                    case "mostrarFormulario":
                        mostrarFormularioCreacion(request, response);
                        break;
                    default:
                        listarPaquetesServicio(request, response);
                }
            } else {
                listarPaquetesServicio(request, response);
            }
        } catch (Exception e) {
            manejarError(request, response, e, "Error general en el controlador de paquetes de servicios");
        }
    }

    private void crearPaqueteServicio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String nombre = limpiarParametro(request.getParameter("nombre"));
            String descripcion = limpiarParametro(request.getParameter("descripcion"));
            String precioTotalStr = limpiarParametro(request.getParameter("precioTotal"));

            // Validaciones básicas
            if (nombre == null || nombre.trim().isEmpty() || 
                descripcion == null || descripcion.trim().isEmpty() || 
                precioTotalStr == null || precioTotalStr.trim().isEmpty()) {
                request.setAttribute("mensaje", "❌ Nombre, descripción y precio total son obligatorios");
                request.getRequestDispatcher("CrearPaqueteServicio.jsp").forward(request, response);
                return;
            }

            nombre = nombre.trim();
            descripcion = descripcion.trim();

            if (nombre.length() < 2 || nombre.length() > 100) {
                request.setAttribute("mensaje", "❌ El nombre debe tener entre 2 y 100 caracteres");
                request.getRequestDispatcher("CrearPaqueteServicio.jsp").forward(request, response);
                return;
            }

            double precioTotal;
            try {
                precioTotal = Double.parseDouble(precioTotalStr);
                if (precioTotal <= 0) {
                    request.setAttribute("mensaje", "❌ El precio debe ser mayor a cero");
                    request.getRequestDispatcher("CrearPaqueteServicio.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("mensaje", "❌ Precio total inválido");
                request.getRequestDispatcher("CrearPaqueteServicio.jsp").forward(request, response);
                return;
            }

            // Crear el paquete
            PaqueteServicio paquete = new PaqueteServicio();
            paquete.setNombre(nombre);
            paquete.setDescripcion(descripcion);
            paquete.setPrecioTotal(precioTotal);

            PaqueteServicioDao dao = new PaqueteServicioDao();
            int idPaqueteCreado = dao.crearPaqueteServicio(paquete);

            if (idPaqueteCreado > 0) {
                response.sendRedirect(request.getContextPath() + "/PaqueteServicioControlador?accion=listar&creado=exito&id=" + idPaqueteCreado);
            } else {
                request.setAttribute("mensaje", "❌ Error al crear el paquete de servicios");
                request.getRequestDispatcher("CrearPaqueteServicio.jsp").forward(request, response);
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al crear paquete de servicios");
        }
    }

    private void agregarServicioAPaquete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String idPaqueteStr = limpiarParametro(request.getParameter("idPaquete"));
            String idServicioStr = limpiarParametro(request.getParameter("idServicio"));
            String cantidadStr = limpiarParametro(request.getParameter("cantidad"));

            if (idPaqueteStr.isEmpty() || idServicioStr.isEmpty() || cantidadStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ Paquete, servicio y cantidad son obligatorios");
                request.getRequestDispatcher("AgregarServicioPaquete.jsp").forward(request, response);
                return;
            }

            int idPaquete = Integer.parseInt(idPaqueteStr);
            int idServicio = Integer.parseInt(idServicioStr);
            int cantidad = Integer.parseInt(cantidadStr);

            // Validar que el paquete existe
            PaqueteServicioDao paqueteDao = new PaqueteServicioDao();
            PaqueteServicio paquete = paqueteDao.obtenerPaquetePorId(idPaquete);
            if (paquete == null) {
                request.setAttribute("mensaje", "❌ El paquete especificado no existe");
                request.getRequestDispatcher("AgregarServicioPaquete.jsp").forward(request, response);
                return;
            }

            // Validar que el servicio no esté ya en el paquete
            if (paqueteDao.servicioYaEnPaquete(idPaquete, idServicio)) {
                request.setAttribute("mensaje", "❌ Este servicio ya está incluido en el paquete");
                request.getRequestDispatcher("AgregarServicioPaquete.jsp").forward(request, response);
                return;
            }

            PaqueteServicioItem item = new PaqueteServicioItem();
            item.setIdPaquete(idPaquete);
            item.setIdServicio(idServicio);
            item.setCantidad(cantidad);

            boolean exito = paqueteDao.agregarServicioPaquete(item);

            if (exito) {
                response.sendRedirect(request.getContextPath() + "/PaqueteServicioControlador?accion=obtenerDetalle&idPaquete=" + idPaquete + "&agregado=exito");
            } else {
                request.setAttribute("mensaje", "❌ Error al agregar el servicio al paquete");
                request.getRequestDispatcher("AgregarServicioPaquete.jsp").forward(request, response);
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al agregar servicio al paquete");
        }
    }

    private void listarPaquetesServicio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Manejar mensajes de éxito
            String creado = request.getParameter("creado");
            String actualizado = request.getParameter("actualizado");
            String eliminado = request.getParameter("eliminado");
            String idParam = request.getParameter("id");

            if ("exito".equals(creado)) {
                request.setAttribute("mensaje", "✅ Paquete de servicios creado exitosamente" + (idParam != null ? " con ID: " + idParam : ""));
                request.setAttribute("tipoMensaje", "exito");
            } else if ("exito".equals(actualizado)) {
                request.setAttribute("mensaje", "✅ Paquete de servicios actualizado exitosamente" + (idParam != null ? " ID: " + idParam : ""));
                request.setAttribute("tipoMensaje", "exito");
            } else if ("exito".equals(eliminado)) {
                request.setAttribute("mensaje", "✅ Paquete de servicios eliminado exitosamente" + (idParam != null ? " ID: " + idParam : ""));
                request.setAttribute("tipoMensaje", "exito");
            }

            PaqueteServicioDao dao = new PaqueteServicioDao();
            List<PaqueteServicio> paquetes = dao.listarPaquetesServicio();

            if (paquetes != null && !paquetes.isEmpty()) {
                request.setAttribute("paquetes", paquetes);
                request.setAttribute("totalPaquetes", paquetes.size());

                // Calcular estadísticas básicas
                double precioMinimo = Double.MAX_VALUE;
                double precioMaximo = 0.0;
                double promedioPrecios = 0.0;
                int paquetesActivos = paquetes.size(); // Asumimos que todos están activos

                for (PaqueteServicio paquete : paquetes) {
                    double precio = paquete.getPrecioTotal();
                    if (precio < precioMinimo) precioMinimo = precio;
                    if (precio > precioMaximo) precioMaximo = precio;
                    promedioPrecios += precio;
                }

                promedioPrecios = paquetes.size() > 0 ? promedioPrecios / paquetes.size() : 0;

                request.setAttribute("precioMinimo", String.format("%.2f", precioMinimo));
                request.setAttribute("precioMaximo", String.format("%.2f", precioMaximo));
                request.setAttribute("promedioPrecios", String.format("%.2f", promedioPrecios));
                request.setAttribute("paquetesActivos", paquetesActivos);
                request.setAttribute("descuentoPromedio", 15.0); // Valor de ejemplo
                request.setAttribute("paquetesVendidos", paquetes.size()); // Valor de ejemplo
                
            } else {
                request.setAttribute("paquetes", null);
                request.setAttribute("totalPaquetes", 0);
                request.setAttribute("paquetesActivos", 0);
                request.setAttribute("descuentoPromedio", 0);
                request.setAttribute("paquetesVendidos", 0);
                
                if (request.getAttribute("mensaje") == null) {
                    request.setAttribute("mensaje", "ℹ️ No existen paquetes de servicios registrados");
                }
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al listar paquetes de servicios");
            return;
        }

        request.getRequestDispatcher("ListaPaquetesServicios.jsp").forward(request, response);
    }

    private void obtenerDetallePaquete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idPaqueteStr = request.getParameter("idPaquete");

            if (idPaqueteStr == null || idPaqueteStr.trim().isEmpty()) {
                request.setAttribute("mensaje", "❌ ID de paquete requerido");
                request.getRequestDispatcher("ListaPaquetesServicios.jsp").forward(request, response);
                return;
            }

            int idPaquete = Integer.parseInt(idPaqueteStr.trim());

            // Manejar mensajes de operaciones
            String servicioEliminado = request.getParameter("servicioEliminado");
            String servicioAgregado = request.getParameter("agregado");

            if ("exito".equals(servicioEliminado)) {
                request.setAttribute("mensaje", "✅ Servicio eliminado del paquete exitosamente");
                request.setAttribute("tipoMensaje", "exito");
            } else if ("exito".equals(servicioAgregado)) {
                request.setAttribute("mensaje", "✅ Servicio agregado al paquete exitosamente");
                request.setAttribute("tipoMensaje", "exito");
            }

            PaqueteServicioDao dao = new PaqueteServicioDao();
            PaqueteServicio paquete = dao.obtenerPaquetePorId(idPaquete);

            if (paquete != null) {
                request.setAttribute("paquete", paquete);

                // Obtener servicios del paquete
                List<PaqueteServicioItem> serviciosPaquete = dao.obtenerServiciosPaquete(idPaquete);
                request.setAttribute("serviciosPaquete", serviciosPaquete);
                
                if (serviciosPaquete != null && !serviciosPaquete.isEmpty()) {
                    request.setAttribute("totalServicios", serviciosPaquete.size());
                    
                    // Calcular valor individual y ahorro
                    double valorIndividual = 0.0;
                    for (PaqueteServicioItem item : serviciosPaquete) {
                        valorIndividual += (item.getPrecioUnitario() * item.getCantidad());
                    }
                    
                    double ahorro = valorIndividual - paquete.getPrecioTotal();
                    double porcentajeDescuento = valorIndividual > 0 ? (ahorro / valorIndividual) * 100 : 0;
                    
                    request.setAttribute("valorIndividual", String.format("%.2f", valorIndividual));
                    request.setAttribute("ahorro", String.format("%.2f", ahorro));
                    request.setAttribute("porcentajeDescuento", String.format("%.1f", porcentajeDescuento));
                } else {
                    request.setAttribute("totalServicios", 0);
                    request.setAttribute("valorIndividual", "0.00");
                    request.setAttribute("ahorro", "0.00");
                    request.setAttribute("porcentajeDescuento", "0.0");
                }

            } else {
                request.setAttribute("mensaje", "❌ Paquete no encontrado");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ ID de paquete inválido");
        } catch (Exception e) {
            manejarError(request, response, e, "Error al obtener detalle del paquete");
            return;
        }

        request.getRequestDispatcher("DetallePaqueteServicio.jsp").forward(request, response);
    }

    private void actualizarPaqueteServicio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String idPaqueteStr = limpiarParametro(request.getParameter("idPaquete"));
            String nombre = limpiarParametro(request.getParameter("nombre"));
            String descripcion = limpiarParametro(request.getParameter("descripcion"));
            String precioTotalStr = limpiarParametro(request.getParameter("precioTotal"));

            if (idPaqueteStr.isEmpty() || nombre.isEmpty() || descripcion.isEmpty() || precioTotalStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID, nombre, descripción y precio son obligatorios");
                request.getRequestDispatcher("EditarPaqueteServicio.jsp").forward(request, response);
                return;
            }

            int idPaquete = Integer.parseInt(idPaqueteStr);
            double precioTotal = Double.parseDouble(precioTotalStr);

            if (precioTotal <= 0) {
                request.setAttribute("mensaje", "❌ El precio debe ser mayor a cero");
                request.getRequestDispatcher("EditarPaqueteServicio.jsp").forward(request, response);
                return;
            }

            PaqueteServicioDao dao = new PaqueteServicioDao();
            boolean exito = dao.actualizarPaqueteServicio(idPaquete, nombre, descripcion, precioTotal, "ACTIVO");

            if (exito) {
                response.sendRedirect(request.getContextPath() + "/PaqueteServicioControlador?accion=listar&actualizado=exito&id=" + idPaquete);
            } else {
                request.setAttribute("mensaje", "❌ Error al actualizar el paquete");
                request.getRequestDispatcher("EditarPaqueteServicio.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ Datos numéricos inválidos");
            request.getRequestDispatcher("EditarPaqueteServicio.jsp").forward(request, response);
        } catch (Exception e) {
            manejarError(request, response, e, "Error al actualizar paquete de servicios");
        }
    }

    private void eliminarPaqueteServicio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idPaqueteStr = limpiarParametro(request.getParameter("idPaquete"));

            if (idPaqueteStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID de paquete requerido");
                request.getRequestDispatcher("ListaPaquetesServicios.jsp").forward(request, response);
                return;
            }

            int idPaquete = Integer.parseInt(idPaqueteStr);

            PaqueteServicioDao dao = new PaqueteServicioDao();
            boolean exito = dao.eliminarPaqueteServicio(idPaquete);

            if (exito) {
                response.sendRedirect(request.getContextPath() + "/PaqueteServicioControlador?accion=listar&eliminado=exito&id=" + idPaquete);
            } else {
                request.setAttribute("mensaje", "❌ Error al eliminar el paquete. Verifique que no tenga servicios asociados.");
                listarPaquetesServicio(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ ID de paquete inválido");
            listarPaquetesServicio(request, response);
        } catch (Exception e) {
            manejarError(request, response, e, "Error al eliminar paquete de servicios");
        }
    }

    private void eliminarServicioDePaquete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String idPaqueteStr = limpiarParametro(request.getParameter("idPaquete"));
            String idServicioStr = limpiarParametro(request.getParameter("idServicio"));

            if (idPaqueteStr.isEmpty() || idServicioStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID de paquete e ID de servicio son requeridos");
                request.getRequestDispatcher("DetallePaqueteServicio.jsp").forward(request, response);
                return;
            }

            int idPaquete = Integer.parseInt(idPaqueteStr);
            int idServicio = Integer.parseInt(idServicioStr);

            PaqueteServicioDao dao = new PaqueteServicioDao();
            boolean exito = dao.eliminarServicioPaquete(idPaquete, idServicio);

            if (exito) {
                response.sendRedirect(request.getContextPath() + "/PaqueteServicioControlador?accion=obtenerDetalle&idPaquete=" + idPaquete + "&servicioEliminado=exito");
            } else {
                request.setAttribute("mensaje", "❌ Error al eliminar el servicio del paquete");
                obtenerDetallePaquete(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ IDs proporcionados inválidos");
            request.getRequestDispatcher("DetallePaqueteServicio.jsp").forward(request, response);
        } catch (Exception e) {
            manejarError(request, response, e, "Error al eliminar servicio del paquete");
        }
    }

    private void buscarPaquetesServicio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String termino = limpiarParametro(request.getParameter("termino"));
            String estado = limpiarParametro(request.getParameter("estado"));
            String precioMinStr = limpiarParametro(request.getParameter("precioMin"));
            String precioMaxStr = limpiarParametro(request.getParameter("precioMax"));

            PaqueteServicioDao dao = new PaqueteServicioDao();
            List<PaqueteServicio> paquetes = null;

            double precioMin = 0.0;
            double precioMax = 100000.0;

            if (!precioMinStr.isEmpty()) {
                try {
                    precioMin = Double.parseDouble(precioMinStr);
                } catch (NumberFormatException e) {
                    // Mantener valor por defecto
                }
            }

            if (!precioMaxStr.isEmpty()) {
                try {
                    precioMax = Double.parseDouble(precioMaxStr);
                } catch (NumberFormatException e) {
                    // Mantener valor por defecto
                }
            }

            paquetes = dao.buscarPaquetesServicio(termino, estado, precioMin, precioMax);

            if (paquetes != null && !paquetes.isEmpty()) {
                request.setAttribute("paquetes", paquetes);
                request.setAttribute("totalPaquetes", paquetes.size());
                request.setAttribute("mensaje", "✅ Se encontraron " + paquetes.size() + " paquetes");
            } else {
                request.setAttribute("paquetes", null);
                request.setAttribute("mensaje", "ℹ️ No se encontraron paquetes con los criterios especificados");
            }

            // Mantener valores de búsqueda en el formulario
            request.setAttribute("terminoBusqueda", termino);
            request.setAttribute("estadoBusqueda", estado);
            request.setAttribute("precioMinBusqueda", precioMinStr);
            request.setAttribute("precioMaxBusqueda", precioMaxStr);

        } catch (Exception e) {
            manejarError(request, response, e, "Error al buscar paquetes de servicios");
            return;
        }

        request.getRequestDispatcher("ListaPaquetesServicios.jsp").forward(request, response);
    }

    private void mostrarFormularioCreacion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            ServicioDao servicioDao = new ServicioDao();
            List<Servicio> serviciosDisponibles = servicioDao.obtenerServicios();
            request.setAttribute("serviciosDisponibles", serviciosDisponibles);
        } catch (Exception e) {
            System.err.println("Error al cargar servicios para formulario: " + e.getMessage());
        }
        
        request.getRequestDispatcher("CrearPaqueteServicio.jsp").forward(request, response);
    }

    private void manejarError(HttpServletRequest request, HttpServletResponse response, 
                             Exception e, String mensajeContexto) 
            throws ServletException, IOException {
        
        System.err.println("=== ERROR EN PAQUETE SERVICIO CONTROLADOR ===");
        System.err.println("Contexto: " + mensajeContexto);
        System.err.println("Mensaje: " + e.getMessage());
        e.printStackTrace();

        request.setAttribute("mensaje", "❌ " + mensajeContexto + ": " + e.getMessage());
        request.setAttribute("tipoMensaje", "error");
        
        // Redirigir a la lista principal en caso de error
        try {
            listarPaquetesServicio(request, response);
        } catch (Exception ex) {
            // Si falla la redirección, enviar error simple
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, mensajeContexto);
        }
    }

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
        return "Controlador para gestión completa de paquetes de servicios";
    }
}