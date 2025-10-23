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
                    case "listar":
                        listarPaquetesServicio(request, response);
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

            if (nombre.isEmpty() || descripcion.isEmpty() || precioTotalStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ Nombre, descripción y precio total son obligatorios");
                request.getRequestDispatcher("CrearPaqueteServicio.jsp").forward(request, response);
                return;
            }

            if (nombre.length() < 3 || nombre.length() > 100) {
                request.setAttribute("mensaje", "❌ El nombre debe tener entre 3 y 100 caracteres");
                request.getRequestDispatcher("CrearPaqueteServicio.jsp").forward(request, response);
                return;
            }

            if (descripcion.length() > 500) {
                request.setAttribute("mensaje", "❌ La descripción no puede exceder 500 caracteres");
                request.getRequestDispatcher("CrearPaqueteServicio.jsp").forward(request, response);
                return;
            }

            double precioTotal;
            try {
                precioTotal = Double.parseDouble(precioTotalStr);
                if (precioTotal <= 0) {
                    throw new NumberFormatException("Precio debe ser positivo");
                }
                
                if (precioTotal > 10000.00) {
                    request.setAttribute("mensaje", "❌ El precio no puede exceder $10,000.00");
                    request.getRequestDispatcher("CrearPaqueteServicio.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("mensaje", "❌ Precio total inválido");
                request.getRequestDispatcher("CrearPaqueteServicio.jsp").forward(request, response);
                return;
            }

            PaqueteServicio paquete = new PaqueteServicio();
            paquete.setNombre(nombre);
            paquete.setDescripcion(descripcion);
            paquete.setPrecioTotal(precioTotal);

            PaqueteServicioDao dao = new PaqueteServicioDao();
            int idPaqueteCreado = dao.crearPaqueteServicio(paquete);

            if (idPaqueteCreado > 0) {
                response.sendRedirect(request.getContextPath() + "/PaqueteServicioControlador?accion=listar&creado=exito&id=" + idPaqueteCreado);
                return;
            } else {
                request.setAttribute("mensaje", "❌ Error al crear el paquete de servicios");
                request.setAttribute("tipoMensaje", "error");
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al crear paquete de servicios");
            return;
        }

        request.getRequestDispatcher("CrearPaqueteServicio.jsp").forward(request, response);
    }

    private void agregarServicioAPaquete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String vistaError = "AgregarServicioPaquete.jsp";
        int idPaquete = 0;
        
        try {
            String idPaqueteStr = limpiarParametro(request.getParameter("idPaquete"));
            String idServicioStr = limpiarParametro(request.getParameter("idServicio"));
            String cantidadStr = limpiarParametro(request.getParameter("cantidad"));

            if (idPaqueteStr.isEmpty() || idServicioStr.isEmpty() || cantidadStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ Paquete, servicio y cantidad son obligatorios");
                request.getRequestDispatcher(vistaError).forward(request, response);
                return;
            }

            int idServicio, cantidad;
            try {
                idPaquete = Integer.parseInt(idPaqueteStr);
                idServicio = Integer.parseInt(idServicioStr);
                cantidad = Integer.parseInt(cantidadStr);

                if (idPaquete <= 0 || idServicio <= 0 || cantidad <= 0) {
                    throw new NumberFormatException("Los valores deben ser positivos");
                }

                if (cantidad > 20) {
                    request.setAttribute("mensaje", "❌ La cantidad no puede exceder 20 unidades por servicio");
                    request.getRequestDispatcher(vistaError).forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("mensaje", "❌ IDs o cantidad inválidos");
                request.getRequestDispatcher(vistaError).forward(request, response);
                return;
            }

            // CORRECCIÓN: Verificar que el servicio existe buscándolo en la lista de servicios
            ServicioDao servicioDao = new ServicioDao();
            List<Servicio> servicios = servicioDao.obtenerServicios();
            boolean servicioExiste = false;
            for (Servicio servicio : servicios) {
                if (servicio.getIdServicio() == idServicio) {
                    servicioExiste = true;
                    break;
                }
            }
            
            if (!servicioExiste) {
                request.setAttribute("mensaje", "❌ Servicio no encontrado");
                request.getRequestDispatcher(vistaError).forward(request, response);
                return;
            }

            PaqueteServicioDao paqueteDao = new PaqueteServicioDao();
            PaqueteServicio paquete = paqueteDao.obtenerPaquetePorId(idPaquete);
            if (paquete == null) {
                request.setAttribute("mensaje", "❌ Paquete no encontrado");
                request.getRequestDispatcher(vistaError).forward(request, response);
                return;
            }

            if (paqueteDao.servicioYaEnPaquete(idPaquete, idServicio)) {
                request.setAttribute("mensaje", "❌ Este servicio ya está incluido en el paquete");
                request.getRequestDispatcher(vistaError).forward(request, response);
                return;
            }

            PaqueteServicioItem item = new PaqueteServicioItem();
            item.setIdPaquete(idPaquete);
            item.setIdServicio(idServicio);
            item.setCantidad(cantidad);

            boolean exito = paqueteDao.agregarServicioPaquete(item);

            if (exito) {
                response.sendRedirect(request.getContextPath() + "/PaqueteServicioControlador?accion=obtenerDetalle&idPaquete=" + idPaquete + "&agregado=exito");
                return;
            } else {
                request.setAttribute("mensaje", "❌ Error al agregar el servicio al paquete");
                request.setAttribute("tipoMensaje", "error");
            }

        } catch (Exception e) {
            if (idPaquete > 0) {
                 response.sendRedirect(request.getContextPath() + "/PaqueteServicioControlador?accion=obtenerDetalle&idPaquete=" + idPaquete + "&error=sistema");
                 return;
            }
            manejarError(request, response, e, "Error al agregar servicio al paquete");
            return;
        }
        
        request.getRequestDispatcher(vistaError).forward(request, response);
    }

    private void listarPaquetesServicio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
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
                request.setAttribute("paquetesServicio", paquetes);
                request.setAttribute("totalPaquetes", paquetes.size());

                double precioMinimo = Double.MAX_VALUE;
                double precioMaximo = 0.0;
                double promedioPrecios = 0.0;

                for (PaqueteServicio paquete : paquetes) {
                    double precio = paquete.getPrecioTotal();
                    if (precio < precioMinimo) precioMinimo = precio;
                    if (precio > precioMaximo) precioMaximo = precio;
                    promedioPrecios += precio;
                }

                if (paquetes.size() > 0) {
                    promedioPrecios /= paquetes.size();
                    request.setAttribute("precioMinimo", precioMinimo);
                    request.setAttribute("precioMaximo", precioMaximo);
                    request.setAttribute("promedioPrecios", promedioPrecios);
                }
                
                if (request.getAttribute("mensaje") == null) {
                    request.setAttribute("mensaje", "✅ Se encontraron " + paquetes.size() + " paquetes de servicios");
                }
            } else {
                request.setAttribute("paquetesServicio", null);
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
            String idPaqueteStr = limpiarParametro(request.getParameter("idPaquete"));

            if (idPaqueteStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID de paquete requerido");
                request.getRequestDispatcher("ListaPaquetesServicios.jsp").forward(request, response);
                return;
            }

            int idPaquete = Integer.parseInt(idPaqueteStr);

            String servicioEliminado = request.getParameter("servicioEliminado");
            String servicioAgregado = request.getParameter("agregado");
            String errorSistema = request.getParameter("error");

            if ("exito".equals(servicioEliminado)) {
                request.setAttribute("mensaje", "✅ Servicio eliminado del paquete exitosamente");
                request.setAttribute("tipoMensaje", "exito");
            } else if ("exito".equals(servicioAgregado)) {
                request.setAttribute("mensaje", "✅ Servicio agregado al paquete exitosamente");
                request.setAttribute("tipoMensaje", "exito");
            } else if ("sistema".equals(errorSistema)) {
                request.setAttribute("mensaje", "❌ Error del sistema al modificar el paquete");
                request.setAttribute("tipoMensaje", "error");
            }

            PaqueteServicioDao dao = new PaqueteServicioDao();
            PaqueteServicio paquete = dao.obtenerPaquetePorId(idPaquete);

            if (paquete != null) {
                request.setAttribute("paqueteDetalle", paquete);

                List<PaqueteServicioItem> serviciosPaquete = dao.obtenerServiciosPaquete(idPaquete);
                if (serviciosPaquete != null && !serviciosPaquete.isEmpty()) {
                    request.setAttribute("serviciosPaquete", serviciosPaquete);
                    request.setAttribute("totalServicios", serviciosPaquete.size());

                    double valorIndividual = 0.0;
                    for (PaqueteServicioItem item : serviciosPaquete) {
                        valorIndividual += (item.getPrecioUnitario() * item.getCantidad());
                    }
                    
                    request.setAttribute("valorIndividual", valorIndividual);
                    request.setAttribute("ahorroEstimado", valorIndividual - paquete.getPrecioTotal());
                    request.setAttribute("porcentajeDescuento", 
                        valorIndividual > 0 ? ((valorIndividual - paquete.getPrecioTotal()) / valorIndividual) * 100 : 0);
                } else {
                    request.setAttribute("serviciosPaquete", null);
                    if (request.getAttribute("mensaje") == null) {
                        request.setAttribute("mensaje", "⚠️ Este paquete no tiene servicios asociados");
                    }
                }

                if (request.getAttribute("mensaje") == null) {
                    request.setAttribute("mensaje", "✅ Detalle del paquete cargado correctamente");
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
        
        String vistaError = "EditarPaqueteServicio.jsp";
        
        try {
            String idPaqueteStr = limpiarParametro(request.getParameter("idPaquete"));
            String nombre = limpiarParametro(request.getParameter("nombre"));
            String descripcion = limpiarParametro(request.getParameter("descripcion"));
            String precioTotalStr = limpiarParametro(request.getParameter("precioTotal"));

            if (idPaqueteStr.isEmpty() || nombre.isEmpty() || descripcion.isEmpty() || precioTotalStr.isEmpty()) {
                request.setAttribute("mensaje", "❌ ID, nombre, descripción y precio son obligatorios");
                request.getRequestDispatcher(vistaError).forward(request, response);
                return;
            }

            int idPaquete = Integer.parseInt(idPaqueteStr);
            double precioTotal = Double.parseDouble(precioTotalStr);

            if (precioTotal <= 0) {
                request.setAttribute("mensaje", "❌ El precio debe ser mayor a cero");
                request.getRequestDispatcher(vistaError).forward(request, response);
                return;
            }

            PaqueteServicioDao dao = new PaqueteServicioDao();
            boolean exito = dao.actualizarPaqueteServicio(idPaquete, nombre, descripcion, precioTotal, "ACTIVO");

            if (exito) {
                response.sendRedirect(request.getContextPath() + "/PaqueteServicioControlador?accion=listar&actualizado=exito&id=" + idPaquete);
                return;
            } else {
                request.setAttribute("mensaje", "❌ Error al actualizar el paquete");
                request.setAttribute("tipoMensaje", "error");
                request.getRequestDispatcher(vistaError).forward(request, response);
                return;
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ Datos numéricos inválidos");
            request.getRequestDispatcher(vistaError).forward(request, response);
            return;
        } catch (Exception e) {
            manejarError(request, response, e, "Error al actualizar paquete de servicios");
            return;
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
                return;
            } else {
                request.setAttribute("mensaje", "❌ Error al eliminar el paquete (verifique dependencias)");
                request.setAttribute("tipoMensaje", "error");
                listarPaquetesServicio(request, response);
                return;
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ ID de paquete inválido");
            listarPaquetesServicio(request, response);
            return;
        } catch (Exception e) {
            manejarError(request, response, e, "Error al eliminar paquete de servicios");
            return;
        }
    }

    private void eliminarServicioDePaquete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idPaqueteStr = limpiarParametro(request.getParameter("idPaquete"));
        
        try {
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
                return;
            } else {
                request.setAttribute("mensaje", "❌ Error al eliminar el servicio del paquete");
                request.setAttribute("tipoMensaje", "error");
                request.setAttribute("idPaquete", idPaqueteStr);
                obtenerDetallePaquete(request, response);
                return;
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "❌ IDs proporcionados inválidos");
            request.getRequestDispatcher("DetallePaqueteServicio.jsp").forward(request, response);
        } catch (Exception e) {
             if (!idPaqueteStr.isEmpty()) {
                 response.sendRedirect(request.getContextPath() + "/PaqueteServicioControlador?accion=obtenerDetalle&idPaquete=" + idPaqueteStr + "&error=sistema");
                 return;
             }
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

            Double precioMin = null, precioMax = null;
            if (!precioMinStr.isEmpty()) {
                try {
                    precioMin = Double.parseDouble(precioMinStr);
                } catch (NumberFormatException e) {
                    request.setAttribute("mensaje", "⚠️ Precio mínimo inválido, ignorando criterio");
                }
            }

            if (!precioMaxStr.isEmpty()) {
                try {
                    precioMax = Double.parseDouble(precioMaxStr);
                } catch (NumberFormatException e) {
                    request.setAttribute("mensaje", "⚠️ Precio máximo inválido, ignorando criterio");
                }
            }

            paquetes = dao.buscarPaquetesServicio(termino, estado, 
                precioMin != null ? precioMin : 0.0, 
                precioMax != null ? precioMax : 100000.0);

            if (paquetes != null && !paquetes.isEmpty()) {
                request.setAttribute("paquetesServicio", paquetes);
                request.setAttribute("totalPaquetes", paquetes.size());
                request.setAttribute("mensaje", "✅ Se encontraron " + paquetes.size() + " paquetes");
            } else {
                request.setAttribute("paquetesServicio", null);
                request.setAttribute("mensaje", "ℹ️ No se encontraron paquetes con los criterios especificados");
            }

            request.setAttribute("terminoBusqueda", termino);
            request.setAttribute("estadoBusqueda", estado);
            request.setAttribute("precioMinBusqueda", precioMinStr);
            request.setAttribute("precioMaxBusqueda", precioMaxStr);

        } catch (Exception e) {
            manejarError(request, response, e, "Error al buscar paquetes de servicios");
            return;
        }

        request.getRequestDispatcher("BuscarPaquetesServicios.jsp").forward(request, response);
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