package control;

import dao.DetalleServicioDao;
import dao.ServicioDao;
import modelo.DetalleServicio;
import modelo.DetalleServicioAtencionDTO;
import modelo.Servicio;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/DetalleServicioControlador"})
public class DetalleServicioControlador extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Configurar encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String accion = request.getParameter("accion");

        try {
            if (accion != null) {
                switch (accion) {
                    case "agregar":
                        agregarServicioAtencion(request, response);
                        break;
                    case "listar":
                        listarDetallesAtencion(request, response);
                        break;
                    case "eliminar":
                        eliminarDetalleServicio(request, response);
                        break;
                    case "actualizar":
                        actualizarDetalleServicio(request, response);
                        break;
                    case "buscarServicios":
                        buscarServiciosDisponibles(request, response);
                        break;
                    default:
                        response.sendRedirect(request.getContextPath() + "/ColaAtencion.jsp");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/ColaAtencion.jsp");
            }
        } catch (Exception e) {
            manejarError(request, response, e, "Error general en el controlador de detalles de servicio");
        }
    }

    /**
     * Agrega un servicio a una atención específica
     */
    private void agregarServicioAtencion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String vistaError = "CrearAtencionDesdeCita.jsp";
        int idAtencion = 0;
        
        try {
            // Obtener y validar parámetros
            String idAtencionStr = limpiarParametro(request.getParameter("idAtencion"));
            String idServicioStr = limpiarParametro(request.getParameter("idServicio"));
            String cantidadStr = limpiarParametro(request.getParameter("cantidad"));
            String precioUnitarioStr = limpiarParametro(request.getParameter("precioUnitario"));
            String descuentoIdStr = limpiarParametro(request.getParameter("descuentoId"));
            String observaciones = limpiarParametro(request.getParameter("observaciones"));

            // Validaciones básicas
            if (idAtencionStr.isEmpty() || idServicioStr.isEmpty() || cantidadStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ Atención, servicio y cantidad son obligatorios");
                request.getRequestDispatcher(vistaError).forward(request, response);
                return;
            }

            // Conversión de tipos con validación
            int idServicio, cantidad, descuentoId = 0;
            double precioUnitario;

            try {
                idAtencion = Integer.parseInt(idAtencionStr);
                idServicio = Integer.parseInt(idServicioStr);
                cantidad = Integer.parseInt(cantidadStr);
                
                if (!descuentoIdStr.isEmpty()) {
                    descuentoId = Integer.parseInt(descuentoIdStr);
                }
                
                // Si no se proporciona precio, obtenerlo del servicio
                if (precioUnitarioStr.isEmpty()) {
                    ServicioDao servicioDao = new ServicioDao();
                    List<Servicio> servicios = servicioDao.obtenerServicios();
                    Servicio servicioEncontrado = null;
                    
                    // Buscar el servicio por ID en la lista
                    for (Servicio servicio : servicios) {
                        if (servicio.getIdServicio() == idServicio) {
                            servicioEncontrado = servicio;
                            break;
                        }
                    }
                    
                    if (servicioEncontrado != null) {
                        // CORRECCIÓN: Usar getPrecioBase() en lugar de getPrecio_base()
                        precioUnitario = servicioEncontrado.getPrecioBase();
                    } else {
                        throw new Exception("Servicio no encontrado con ID: " + idServicio);
                    }
                } else {
                    precioUnitario = Double.parseDouble(precioUnitarioStr);
                }

                // Validaciones de negocio
                if (cantidad <= 0) {
                    request.setAttribute("mensaje", "❌ La cantidad debe ser mayor a cero");
                    request.getRequestDispatcher(vistaError).forward(request, response);
                    return;
                }

                if (precioUnitario < 0) {
                    request.setAttribute("mensaje", "❌ El precio no puede ser negativo");
                    request.getRequestDispatcher(vistaError).forward(request, response);
                    return;
                }

            } catch (NumberFormatException e) {
                request.setAttribute("mensaje", "❌ Error en los datos numéricos proporcionados");
                request.getRequestDispatcher(vistaError).forward(request, response);
                return;
            }

            // Crear objeto DetalleServicio
            DetalleServicio detalle = new DetalleServicio();
            detalle.setIdAtencion(idAtencion);
            detalle.setIdServicio(idServicio);
            detalle.setCantidad(cantidad);
            detalle.setPrecioUnitario(precioUnitario);
            detalle.setDescuentoId(descuentoId);
            detalle.setObservaciones(observaciones);

            // Insertar en la base de datos
            DetalleServicioDao dao = new DetalleServicioDao();
            boolean exito = dao.agregarServicioAtencion(detalle);

            if (exito) {
                response.sendRedirect(request.getContextPath() + "/DetalleServicioControlador?accion=listar&idAtencion=" + idAtencion + "&agregado=exito");
                return;
            } else {
                request.setAttribute("mensaje", "❌ Error al agregar el servicio a la atención");
            }

        } catch (Exception e) {
            request.setAttribute("mensaje", "❌ Error al agregar servicio: " + e.getMessage());
            request.getRequestDispatcher(vistaError).forward(request, response);
            return;
        }

        request.getRequestDispatcher(vistaError).forward(request, response);
    }

    /**
     * Lista todos los detalles de servicios de una atención
     */
    private void listarDetallesAtencion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String vistaDestino = "DetalleServiciosAtencion.jsp";
        
        try {
            String idAtencionStr = limpiarParametro(request.getParameter("idAtencion"));
            
            if (idAtencionStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID de atención requerido");
                request.getRequestDispatcher("ColaAtencion.jsp").forward(request, response);
                return;
            }
            
            // Manejar mensajes PRG
            if ("exito".equals(request.getParameter("agregado"))) {
                request.setAttribute("mensaje", "✅ Servicio agregado exitosamente.");
                request.setAttribute("tipoMensaje", "exito");
            } else if ("exito".equals(request.getParameter("eliminado"))) {
                request.setAttribute("mensaje", "✅ Servicio eliminado exitosamente.");
                request.setAttribute("tipoMensaje", "exito");
            } else if ("exito".equals(request.getParameter("actualizado"))) {
                request.setAttribute("mensaje", "✅ Detalle de servicio actualizado exitosamente.");
                request.setAttribute("tipoMensaje", "exito");
            }

            int idAtencion = Integer.parseInt(idAtencionStr);
            listarDetallesAtencionInterno(request, idAtencion);

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ ID de atención inválido");
            request.getRequestDispatcher("ColaAtencion.jsp").forward(request, response);
            return;
        } catch (Exception e) {
            manejarError(request, response, e, "Error al listar detalles de servicios");
            return;
        }

        request.getRequestDispatcher(vistaDestino).forward(request, response);
    }

    /**
     * Método interno para cargar detalles de atención (reutilizable)
     */
    private void listarDetallesAtencionInterno(HttpServletRequest request, int idAtencion) {
        try {
            DetalleServicioDao dao = new DetalleServicioDao();
            List<DetalleServicioAtencionDTO> detalles = dao.detalleServiciosAtencion(idAtencion);

            double totalAtencion = 0.0;
            if (detalles != null && !detalles.isEmpty()) {
                // Calcular total
                for (DetalleServicioAtencionDTO detalle : detalles) {
                    totalAtencion += detalle.getSubtotal();
                }
                
                request.setAttribute("detallesServicios", detalles);
                request.setAttribute("totalServicios", detalles.size());
                request.setAttribute("totalAtencion", totalAtencion);
            } else {
                request.setAttribute("detallesServicios", null);
                request.setAttribute("totalServicios", 0);
                request.setAttribute("totalAtencion", 0.0);
                if (request.getAttribute("mensaje") == null) {
                    request.setAttribute("mensaje", "ℹ️ No hay servicios registrados para esta atención");
                }
            }

            request.setAttribute("idAtencionConsulta", idAtencion);

        } catch (Exception e) {
            System.err.println("Error al cargar detalles internos: " + e.getMessage());
            request.setAttribute("mensaje", "❌ Error al cargar los detalles de servicios");
        }
    }

    /**
     * Elimina un detalle de servicio específico
     */
    private void eliminarDetalleServicio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idAtencionStr = limpiarParametro(request.getParameter("idAtencion"));
        int idAtencion = 0;
        String vistaError = "DetalleServiciosAtencion.jsp";
        
        try {
            String idDetalleStr = limpiarParametro(request.getParameter("idDetalle"));

            if (idDetalleStr.isEmpty() || idAtencionStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID de detalle e ID de atención son requeridos");
                request.getRequestDispatcher("ColaAtencion.jsp").forward(request, response);
                return;
            }

            int idDetalle = Integer.parseInt(idDetalleStr);
            idAtencion = Integer.parseInt(idAtencionStr);

            DetalleServicioDao dao = new DetalleServicioDao();
            boolean exito = dao.eliminarDetalleServicio(idDetalle);

            if (exito) {
                response.sendRedirect(request.getContextPath() + "/DetalleServicioControlador?accion=listar&idAtencion=" + idAtencion + "&eliminado=exito");
                return;
            } else {
                request.setAttribute("mensaje", "❌ Error al eliminar el servicio de la atención");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ IDs proporcionados inválidos");
        } catch (Exception e) {
            manejarError(request, response, e, "Error al eliminar detalle de servicio");
            return;
        }

        listarDetallesAtencionInterno(request, idAtencion);
        request.getRequestDispatcher(vistaError).forward(request, response);
    }

    /**
     * Actualiza un detalle de servicio existente
     */
    private void actualizarDetalleServicio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idAtencionStr = limpiarParametro(request.getParameter("idAtencion"));
        int idAtencion = 0;
        String vistaError = "DetalleServiciosAtencion.jsp";

        try {
            String idDetalleStr = limpiarParametro(request.getParameter("idDetalle"));
            String cantidadStr = limpiarParametro(request.getParameter("cantidad"));
            String precioUnitarioStr = limpiarParametro(request.getParameter("precioUnitario"));
            String observaciones = limpiarParametro(request.getParameter("observaciones"));

            // Validaciones básicas
            if (idDetalleStr.isEmpty() || cantidadStr.isEmpty() || precioUnitarioStr.isEmpty() || idAtencionStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID detalle, ID atención, cantidad y precio son obligatorios");
                if (!idAtencionStr.isEmpty()) {
                    listarDetallesAtencionInterno(request, Integer.parseInt(idAtencionStr));
                }
                request.getRequestDispatcher(vistaError).forward(request, response);
                return;
            }

            // Conversiones
            int idDetalle = Integer.parseInt(idDetalleStr);
            int cantidad = Integer.parseInt(cantidadStr);
            double precioUnitario = Double.parseDouble(precioUnitarioStr);
            idAtencion = Integer.parseInt(idAtencionStr);

            // Validaciones de negocio
            if (cantidad <= 0 || precioUnitario < 0) {
                request.setAttribute("mensaje", "❌ Cantidad debe ser mayor a 0 y precio no negativo");
                listarDetallesAtencionInterno(request, idAtencion);
                request.getRequestDispatcher(vistaError).forward(request, response);
                return;
            }

            DetalleServicioDao dao = new DetalleServicioDao();
            boolean exito = dao.actualizarDetalleServicio(idDetalle, cantidad, precioUnitario, observaciones);

            if (exito) {
                response.sendRedirect(request.getContextPath() + "/DetalleServicioControlador?accion=listar&idAtencion=" + idAtencion + "&actualizado=exito");
                return;
            } else {
                request.setAttribute("mensaje", "❌ Error al actualizar el detalle de servicio");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ Datos numéricos inválidos");
            if (idAtencion > 0) listarDetallesAtencionInterno(request, idAtencion);
        } catch (Exception e) {
            manejarError(request, response, e, "Error al actualizar detalle de servicio");
            return;
        }

        if (idAtencion > 0) listarDetallesAtencionInterno(request, idAtencion);
        request.getRequestDispatcher(vistaError).forward(request, response);
    }

    /**
     * Busca servicios disponibles para agregar a una atención
     */
    private void buscarServiciosDisponibles(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String termino = limpiarParametro(request.getParameter("termino"));
            String categoria = limpiarParametro(request.getParameter("categoria"));

            ServicioDao servicioDao = new ServicioDao();
            List<Servicio> servicios;

            if (!termino.isEmpty()) {
                // CORRECCIÓN: El DAO no tiene método buscarServicios, usar obtenerServicios y filtrar
                servicios = servicioDao.obtenerServicios();
                // Filtrar por término si es necesario (implementación básica)
                if (!termino.isEmpty()) {
                    List<Servicio> serviciosFiltrados = new java.util.ArrayList<>();
                    String terminoLower = termino.toLowerCase();
                    for (Servicio servicio : servicios) {
                        if (servicio.getNombre().toLowerCase().contains(terminoLower) ||
                            servicio.getDescripcion().toLowerCase().contains(terminoLower) ||
                            servicio.getCodigo().toLowerCase().contains(terminoLower)) {
                            serviciosFiltrados.add(servicio);
                        }
                    }
                    servicios = serviciosFiltrados;
                }
            } else if (!categoria.isEmpty()) {
                // CORRECCIÓN: Usar obtenerServiciosPorCategoria si se proporciona categoría
                servicios = servicioDao.obtenerServiciosPorCategoria(categoria);
            } else {
                servicios = servicioDao.obtenerServicios();
            }

            request.setAttribute("serviciosDisponibles", servicios);
            request.setAttribute("terminoBusqueda", termino);
            request.setAttribute("categoriaBusqueda", categoria);

            if (servicios != null && !servicios.isEmpty()) {
                request.setAttribute("totalServicios", servicios.size());
                request.setAttribute("mensaje", "✅ Se encontraron " + servicios.size() + " servicios");
            } else {
                request.setAttribute("mensaje", "ℹ️ No se encontraron servicios con los criterios especificados");
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al buscar servicios disponibles");
            return;
        }

        request.getRequestDispatcher("BuscarServiciosAtencion.jsp").forward(request, response);
    }

    /**
     * Manejo centralizado de errores
     */
    private void manejarError(HttpServletRequest request, HttpServletResponse response, 
                             Exception e, String mensajeContexto) 
            throws ServletException, IOException {
        
        System.err.println("=== ERROR EN DETALLE SERVICIO CONTROLADOR ===");
        System.err.println("Contexto: " + mensajeContexto);
        System.err.println("Mensaje: " + e.getMessage());
        e.printStackTrace();

        request.setAttribute("mensaje", "❌ " + mensajeContexto + ": " + e.getMessage());
        request.setAttribute("tipoMensaje", "error");
        
        request.getRequestDispatcher("ColaAtencion.jsp").forward(request, response);
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
        return "Controlador para gestión de detalles de servicios en atenciones";
    }
}